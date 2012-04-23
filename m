Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2DWVp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:45:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5836 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2DWVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:45:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6690"; a="184252301"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vsprintf: Fix %ps on non symbols when using kallsyms
Date: Mon, 23 Apr 2012 14:45:24 -0700
Message-Id: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.227.gd1ca7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %ps in a printk format will sometimes fail silently and
print the empty string if the address passed in does not match a
symbol that kallsyms knows about. But using %pS will fall back to
printing the full address if kallsyms can't find the symbol. Make
%ps act the same as %pS by falling back to printing the address.

While we're here also make %ps print the module that a symbol
comes from so that it matches what %pS already does. Take this
simple function for example (in a module):

	static void test_printk(void)
	{
		int test;
		pr_info("with pS: %pS\n", &test);
		pr_info("with ps: %ps\n", &test);
	}

Before this patch:

 with pS: 0xdff7df44
 with ps:

After this patch:

 with pS: 0xdff7df44
 with ps: 0xdff7df44

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

The name is admittedly bad. Please suggest alternatives.

 include/linux/kallsyms.h |    7 +++++++
 kernel/kallsyms.c        |   32 ++++++++++++++++++++++++--------
 lib/vsprintf.c           |    2 +-
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 3875719..6883e19 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -36,6 +36,7 @@ const char *kallsyms_lookup(unsigned long addr,
 
 /* Look up a kernel symbol and return it in a text buffer. */
 extern int sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_symbol_no_offset(char *buffer, unsigned long address);
 extern int sprint_backtrace(char *buffer, unsigned long address);
 
 /* Look up a kernel symbol and print it to the kernel messages. */
@@ -80,6 +81,12 @@ static inline int sprint_symbol(char *buffer, unsigned long addr)
 	return 0;
 }
 
+static inline int sprint_symbol_no_offset(char *buffer, unsigned long addr)
+{
+	*buffer = '\0';
+	return 0;
+}
+
 static inline int sprint_backtrace(char *buffer, unsigned long addr)
 {
 	*buffer = '\0';
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 079f1d3..2169fee 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -343,7 +343,7 @@ int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
 
 /* Look up a kernel symbol and return it in a text buffer. */
 static int __sprint_symbol(char *buffer, unsigned long address,
-			   int symbol_offset)
+			   int symbol_offset, int add_offset)
 {
 	char *modname;
 	const char *name;
@@ -358,13 +358,13 @@ static int __sprint_symbol(char *buffer, unsigned long address,
 	if (name != buffer)
 		strcpy(buffer, name);
 	len = strlen(buffer);
-	buffer += len;
 	offset -= symbol_offset;
 
+	if (add_offset)
+		len += sprintf(buffer + len, "+%#lx/%#lx", offset, size);
+
 	if (modname)
-		len += sprintf(buffer, "+%#lx/%#lx [%s]", offset, size, modname);
-	else
-		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
+		len += sprintf(buffer + len, " [%s]", modname);
 
 	return len;
 }
@@ -382,12 +382,28 @@ static int __sprint_symbol(char *buffer, unsigned long address,
  */
 int sprint_symbol(char *buffer, unsigned long address)
 {
-	return __sprint_symbol(buffer, address, 0);
+	return __sprint_symbol(buffer, address, 0, 1);
 }
-
 EXPORT_SYMBOL_GPL(sprint_symbol);
 
 /**
+ * sprint_symbol_no_offset - Look up a kernel symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function looks up a kernel symbol with @address and stores its name
+ * and module name to @buffer if possible. If no symbol was found, just saves
+ * its @address as is.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
+int sprint_symbol_no_offset(char *buffer, unsigned long address)
+{
+	return __sprint_symbol(buffer, address, 0, 0);
+}
+EXPORT_SYMBOL_GPL(sprint_symbol_no_offset);
+
+/**
  * sprint_backtrace - Look up a backtrace symbol and return it in a text buffer
  * @buffer: buffer to be stored
  * @address: address to lookup
@@ -403,7 +419,7 @@ EXPORT_SYMBOL_GPL(sprint_symbol);
  */
 int sprint_backtrace(char *buffer, unsigned long address)
 {
-	return __sprint_symbol(buffer, address, -1);
+	return __sprint_symbol(buffer, address, -1, 1);
 }
 
 /* Look up a kernel symbol and print it to the kernel messages. */
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index ba7bb1b..0b56d43 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -535,7 +535,7 @@ char *symbol_string(char *buf, char *end, void *ptr,
 	else if (ext != 'f' && ext != 's')
 		sprint_symbol(sym, value);
 	else
-		kallsyms_lookup(value, NULL, NULL, NULL, sym);
+		sprint_symbol_no_offset(sym, value);
 
 	return string(buf, end, sym, spec);
 #else
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

