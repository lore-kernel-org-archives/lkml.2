Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1CWMqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:46:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36416 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1CWMqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wfZFu0wP8rrrqgr7uNzYHO9QOKcPe185VQDaLYGqQpP2DUy/xNpZIOoCt3Io6GBmHc
         f8ar5gziD+s592tgHysp0+nU2C2zX1gRZvwb4THxBcF2HaL3LxJsAWzmzIk6Tb+xQbMd
         q80rmwOP0/fnzuKOAMLVlG4CZQ4You+pyIz40=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 1/2] vsprintf: introduce %pT format specifier
Date: Wed, 23 Mar 2011 21:46:34 +0900
Message-Id: <1300884395-13835-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The %pT format specifier is for stack backtrace. Its handler
sprint_trace() does symbol lookup using (address-1) to ensure
the address will not point outside of the function.

If there is a tail-call to the function marked "noreturn",
gcc optimized out the code after the call then causes saved
return address points outside of the function (i.e. the start
of the next function), so pollutes call trace somewhat.
This patch will fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: linux-arch@vger.kernel.org
---
 include/linux/kallsyms.h |    7 +++++++
 kernel/kallsyms.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 lib/vsprintf.c           |    7 ++++++-
 3 files changed, 53 insertions(+), 1 deletions(-)

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
index 6f6d091b5757..1e889477ff618 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -368,6 +368,46 @@ int sprint_symbol(char *buffer, unsigned long address)
 }
 EXPORT_SYMBOL_GPL(sprint_symbol);
 
+/**
+ * sprint_trace - Look up a kernel trace symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function is for stack trace and does the same thing as sprint_symbol()
+ * but with modified/decreased @address. If there is a tail-call to the
+ * function marked "noreturn", gcc optimized out code after the call so that
+ * the stack-saved return address could point outside of the caller. This
+ * function ensures that kallsyms will find the original caller by decreasing
+ * @address and then adjusts the result by increasing offset.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
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

