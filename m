Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1CRLVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:21:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53964 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1CRLVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VYF6Ju3aeHm3E0Upz/9sW7Czj5O/ipFXnZhmTlCzlcixHZfiS4H2qaYK0Zziksv+kK
         7i+W1QTrqWmX5oF9dZ2xTh8TityUkwtxRXO54YkRD07i66WE94Y9YU6XfU/iTRR43pZ6
         6YytItKuOLOq5dMdqXXU2SUu9aqoZ/JMS6rmY=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [RFC 1/2] vsprintf: introduce %pT format specifier
Date: Fri, 18 Mar 2011 20:21:17 +0900
Message-Id: <1300447278-2073-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300447278-2073-1-git-send-email-namhyung@gmail.com>
References: <1300447278-2073-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The %pT format specifier is for stack backtrace. Its handler
sprint_trace() does symbol lookup using (offset-1) to ensure
the offset will not point outside of the function.

If there is a tail-call to the function marked "noreturn",
gcc optimized out the code after the call then causes saved
return address points outside of the function (i.e. the start
of the next function), so messes up a call trace entry.
This patch will fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/kallsyms.h |    7 +++++++
 kernel/kallsyms.c        |   26 ++++++++++++++++++++++++++
 lib/vsprintf.c           |    7 ++++++-
 3 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index d8e9b3d1c23c..4964ed2021cc 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -36,6 +36,7 @@ const char *kallsyms_lookup(unsigned long addr,

 /* Look up a kernel symbol and return it in a text buffer. */
 extern int sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_trace(char *buffer, unsigned long address);

 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
@@ -79,6 +80,12 @@ static inline int sprint_symbol(char *buffer, unsigned long addr)
 	return 0;
 }

+static inline int sprint_trace(char *buffer, unsigned long addr)
+{
+	*buffer = '\0';
+	return 0;
+}
+
 static inline int lookup_symbol_name(unsigned long addr, char *symname)
 {
 	return -ERANGE;
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f6d091b5757..2e43200cdc79 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -368,6 +368,32 @@ int sprint_symbol(char *buffer, unsigned long address)
 }
 EXPORT_SYMBOL_GPL(sprint_symbol);

+int sprint_trace(char *buffer, unsigned long address)
+{
+	char *modname;
+	const char *name;
+	unsigned long offset, size;
+	int len;
+
+	name = kallsyms_lookup(address-1, &size, &offset, &modname, buffer);
+	if (!name)
+		return sprintf(buffer, "0x%lx", address);
+
+	if (name != buffer)
+		strcpy(buffer, name);
+	len = strlen(buffer);
+	buffer += len;
+	offset++;
+
+	if (modname)
+		len += sprintf(buffer, "+%#lx/%#lx [%s]",
+						offset, size, modname);
+	else
+		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
+
+	return len;
+}
+
 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
 {
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d3023df8477f..c9c56a54cc42 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -574,7 +574,9 @@ char *symbol_string(char *buf, char *end, void *ptr,
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	if (ext != 'f' && ext != 's')
+	if (ext == 'T')
+		sprint_trace(sym, value);
+	else if (ext != 'f' && ext != 's')
 		sprint_symbol(sym, value);
 	else
 		kallsyms_lookup(value, NULL, NULL, NULL, sym);
@@ -949,6 +951,7 @@ int kptr_restrict = 1;
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
+ * - 'T' For backtraced symbolic direct pointers with offset
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'M' For a 6-byte MAC address, it prints the address in the
@@ -1008,6 +1011,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		/* Fallthrough */
 	case 'S':
 	case 's':
+	case 'T':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 	case 'r':
@@ -1279,6 +1283,7 @@ qualifier:
  * %ps output the name of a text symbol without offset
  * %pF output the name of a function pointer with its offset
  * %pf output the name of a function pointer without its offset
+ * %pT output the name of a trace symbol with its offset
  * %pR output the address range in a struct resource with decoded flags
  * %pr output the address range in a struct resource with raw flags
  * %pM output a 6-byte MAC address with colons
--
1.7.4

