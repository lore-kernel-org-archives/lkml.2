Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2LLSTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:19:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35419 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:19:44 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>, Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 01/26] vsprintf: Add extension %pSR - print_symbol replacement
Date: Wed, 12 Dec 2012 10:18:50 -0800
Message-Id: <7542485752d1a01815a68c900be498a87aabe0b0.1355335227.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_symbol takes a long and converts it to a function
name and offset.  %pS does something similar, but doesn't
translate the address via __builtin_extract_return_addr.
%pSR does the translation.

This will enable replacing multiple calls like
	printk(...);
	printk_symbol(addr);
	printk("\n");
with a single non-interleavable in dmesg
	printk("... %pSR\n", (void *)addr);

Update documentation too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/printk-formats.txt |    2 ++
 lib/vsprintf.c                   |   18 +++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 8ffb274..69a5ca1 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -17,6 +17,8 @@ Symbols/Function Pointers:
 	%pF	versatile_init+0x0/0x110
 	%pf	versatile_init
 	%pS	versatile_init+0x0/0x110
+	%pSR	versatile_init+0x9/0x110
+		(with __builtin_extract_return_addr() translation)
 	%ps	versatile_init
 	%pB	prev_fn_of_versatile_init+0x88/0x88
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index fab33a9..832ff0b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -534,14 +534,21 @@ char *string(char *buf, char *end, const char *s, struct printf_spec spec)
 
 static noinline_for_stack
 char *symbol_string(char *buf, char *end, void *ptr,
-		    struct printf_spec spec, char ext)
+		    struct printf_spec spec, const char *fmt)
 {
-	unsigned long value = (unsigned long) ptr;
+	unsigned long value;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	if (ext == 'B')
+#endif
+
+	if (fmt[1] == 'R')
+		ptr = __builtin_extract_return_addr(ptr);
+	value = (unsigned long)ptr;
+
+#ifdef CONFIG_KALLSYMS
+	if (*fmt == 'B')
 		sprint_backtrace(sym, value);
-	else if (ext != 'f' && ext != 's')
+	else if (*fmt != 'f' && *fmt != 's')
 		sprint_symbol(sym, value);
 	else
 		sprint_symbol_no_offset(sym, value);
@@ -987,6 +994,7 @@ int kptr_restrict __read_mostly;
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
+ * - '[FfSs]R' as above with __builtin_extract_return_addr() translation
  * - 'B' For backtraced symbolic direct pointers with offset
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
@@ -1059,7 +1067,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'S':
 	case 's':
 	case 'B':
-		return symbol_string(buf, end, ptr, spec, *fmt);
+		return symbol_string(buf, end, ptr, spec, fmt);
 	case 'R':
 	case 'r':
 		return resource_string(buf, end, ptr, spec, fmt);
-- 
1.7.8.112.g3fd21

