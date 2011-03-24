Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1CXCmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:42:42 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:37957 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab1CXCmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QMgDBcd3EAc3xTrPcTQBfz9biTZlyghPgjG+NGBysQ36K4psLD1yu4vqWq1NFLUio8
         kWosqiWNzKDpbx42AOSKPQaMIuLoHmMtFaH0h3T5unALQ0rhcnaTAh3HJ0riY0cEXq5u
         SB2KkJHkbJwKa66Qu4KCQG0LOW+hVuYeoiyE4=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH v2 1/2] vsprintf: introduce %pB format specifier
Date: Thu, 24 Mar 2011 11:42:29 +0900
Message-Id: <1300934550-21394-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The %pB format specifier is for stack backtrace. Its handler
sprint_backtrace() does symbol lookup using (address-1) to
ensure the address will not point outside of the function.

If there is a tail-call to the function marked "noreturn",
gcc optimized out the code after the call then causes saved
return address points outside of the function (i.e. the start
of the next function), so pollutes call trace somewhat.
This patch will fix it.

before:
 Call Trace:
  [<ffffffff812a8502>] panic+0x8c/0x18d
  [<ffffffffa000012a>] deep01+0x0/0x38 [test_panic]  <--- bad
  [<ffffffff81104666>] proc_file_write+0x73/0x8d
  [<ffffffff811000b3>] proc_reg_write+0x8d/0xac
  [<ffffffff810c7d32>] vfs_write+0xa1/0xc5
  [<ffffffff810c7e0f>] sys_write+0x45/0x6c
  [<ffffffff8f02943b>] system_call_fastpath+0x16/0x1b

after:
 Call Trace:
  [<ffffffff812bce69>] panic+0x8c/0x18d
  [<ffffffffa000012a>] panic_write+0x20/0x20 [test_panic]  <--- ok
  [<ffffffff81115fab>] proc_file_write+0x73/0x8d
  [<ffffffff81111a5f>] proc_reg_write+0x8d/0xac
  [<ffffffff810d90ee>] vfs_write+0xa1/0xc5
  [<ffffffff810d91cb>] sys_write+0x45/0x6c
  [<ffffffff812c07fb>] system_call_fastpath+0x16/0x1b

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-arch@vger.kernel.org
---
 include/linux/kallsyms.h |    7 +++++++
 kernel/kallsyms.c        |   44 +++++++++++++++++++++++++++++++++++++++++---
 lib/vsprintf.c           |    7 ++++++-
 3 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index d8e9b3d1c23c..0df513b7a9f8 100644
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
index 6f6d091b5757..59e879929b17 100644
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
index d3023df8477f..d9e01fc3168e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -433,7 +433,9 @@ char *symbol_string(char *buf, char *end, void *ptr,
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
@@ -808,6 +810,7 @@ int kptr_restrict = 1;
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
+ * - 'B' For backtraced symbolic direct pointers with offset
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'M' For a 6-byte MAC address, it prints the address in the
@@ -867,6 +870,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		/* Fallthrough */
 	case 'S':
 	case 's':
+	case 'B':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 	case 'r':
@@ -1134,6 +1138,7 @@ qualifier:
  * %ps output the name of a text symbol without offset
  * %pF output the name of a function pointer with its offset
  * %pf output the name of a function pointer without its offset
+ * %pB output the name of a backtrace symbol with its offset
  * %pR output the address range in a struct resource with decoded flags
  * %pr output the address range in a struct resource with raw flags
  * %pM output a 6-byte MAC address with colons
--
1.7.4

