Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab1CXH6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:58:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:40823 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933612Ab1CXH6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:58:11 -0400
Date: Thu, 24 Mar 2011 07:57:52 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, namhyung@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, namhyung@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1300934550-21394-1-git-send-email-namhyung@gmail.com>
References: <1300934550-21394-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] vsprintf: Introduce %pB format specifier
Message-ID: <tip-0f77a8d378254f27df4a114a5da67223af1fe93f@git.kernel.org>
Git-Commit-ID: 0f77a8d378254f27df4a114a5da67223af1fe93f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Mar 2011 07:57:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f77a8d378254f27df4a114a5da67223af1fe93f
Gitweb:     http://git.kernel.org/tip/0f77a8d378254f27df4a114a5da67223af1fe93f
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Thu, 24 Mar 2011 11:42:29 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Mar 2011 08:36:10 +0100

vsprintf: Introduce %pB format specifier

The %pB format specifier is for stack backtrace. Its handler
sprint_backtrace() does symbol lookup using (address-1) to
ensure the address will not point outside of the function.

If there is a tail-call to the function marked "noreturn",
gcc optimized out the code after the call then causes saved
return address points outside of the function (i.e. the start
of the next function), so pollutes call trace somewhat.

This patch adds the %pB printk mechanism that allows architecture
call-trace printout functions to improve backtrace printouts.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org
LKML-Reference: <1300934550-21394-1-git-send-email-namhyung@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kallsyms.h |    7 +++++++
 kernel/kallsyms.c        |   44 +++++++++++++++++++++++++++++++++++++++++---
 lib/vsprintf.c           |    7 ++++++-
 3 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index d8e9b3d..0df513b 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -36,6 +36,7 @@ const char *kallsyms_lookup(unsigned long addr,
 
 /* Look up a kernel symbol and return it in a text buffer. */
 extern int sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_backtrace(char *buffer, unsigned long address);
 
 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
@@ -79,6 +80,12 @@ static inline int sprint_symbol(char *buffer, unsigned long addr)
 	return 0;
 }
 
+static inline int sprint_backtrace(char *buffer, unsigned long addr)
+{
+	*buffer = '\0';
+	return 0;
+}
+
 static inline int lookup_symbol_name(unsigned long addr, char *symname)
 {
 	return -ERANGE;
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f6d091..59e8799 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -342,13 +342,15 @@ int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
 }
 
 /* Look up a kernel symbol and return it in a text buffer. */
-int sprint_symbol(char *buffer, unsigned long address)
+static int __sprint_symbol(char *buffer, unsigned long address,
+			   int symbol_offset)
 {
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
 	int len;
 
+	address += symbol_offset;
 	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
 	if (!name)
 		return sprintf(buffer, "0x%lx", address);
@@ -357,17 +359,53 @@ int sprint_symbol(char *buffer, unsigned long address)
 		strcpy(buffer, name);
 	len = strlen(buffer);
 	buffer += len;
+	offset -= symbol_offset;
 
 	if (modname)
-		len += sprintf(buffer, "+%#lx/%#lx [%s]",
-						offset, size, modname);
+		len += sprintf(buffer, "+%#lx/%#lx [%s]", offset, size, modname);
 	else
 		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
 
 	return len;
 }
+
+/**
+ * sprint_symbol - Look up a kernel symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function looks up a kernel symbol with @address and stores its name,
+ * offset, size and module name to @buffer if possible. If no symbol was found,
+ * just saves its @address as is.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
+int sprint_symbol(char *buffer, unsigned long address)
+{
+	return __sprint_symbol(buffer, address, 0);
+}
+
 EXPORT_SYMBOL_GPL(sprint_symbol);
 
+/**
+ * sprint_backtrace - Look up a backtrace symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function is for stack backtrace and does the same thing as
+ * sprint_symbol() but with modified/decreased @address. If there is a
+ * tail-call to the function marked "noreturn", gcc optimized out code after
+ * the call so that the stack-saved return address could point outside of the
+ * caller. This function ensures that kallsyms will find the original caller
+ * by decreasing @address.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
+int sprint_backtrace(char *buffer, unsigned long address)
+{
+	return __sprint_symbol(buffer, address, -1);
+}
+
 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
 {
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d3023df..d9e01fc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -574,7 +574,9 @@ char *symbol_string(char *buf, char *end, void *ptr,
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	if (ext != 'f' && ext != 's')
+	if (ext == 'B')
+		sprint_backtrace(sym, value);
+	else if (ext != 'f' && ext != 's')
 		sprint_symbol(sym, value);
 	else
 		kallsyms_lookup(value, NULL, NULL, NULL, sym);
@@ -949,6 +951,7 @@ int kptr_restrict = 1;
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
+ * - 'B' For backtraced symbolic direct pointers with offset
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'M' For a 6-byte MAC address, it prints the address in the
@@ -1008,6 +1011,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		/* Fallthrough */
 	case 'S':
 	case 's':
+	case 'B':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 	case 'r':
@@ -1279,6 +1283,7 @@ qualifier:
  * %ps output the name of a text symbol without offset
  * %pF output the name of a function pointer with its offset
  * %pf output the name of a function pointer without its offset
+ * %pB output the name of a backtrace symbol with its offset
  * %pR output the address range in a struct resource with decoded flags
  * %pr output the address range in a struct resource with raw flags
  * %pM output a 6-byte MAC address with colons
