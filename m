Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1GRIYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:24:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:6998 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab1GRIX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:23:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,221,1309762800"; 
   d="scan'208";a="27017805"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 1/2] lib: make TOLOWER macro public
Date: Mon, 18 Jul 2011 11:23:23 +0300
Message-Id: <e01fb9d779703004bf2f217ec7a2c3e7220610b9.1310977380.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is required by *printf and kstrto* functions that are located
in the different modules. This patch makes TOLOWER macro public.
However, it's good idea to not use the macro outside of mentioned
functions.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/kernel.h |    3 +++
 lib/kstrtox.c          |   13 ++++---------
 lib/vsprintf.c         |    3 ---
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 567a6f7..8c29d3a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -188,6 +188,9 @@ NORET_TYPE void do_exit(long error_code)
 NORET_TYPE void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
 
+/* Works only for digits and letters, but small and fast */
+#define TOLOWER(x) ((x) | 0x20)
+
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
 int __must_check _kstrtol(const char *s, unsigned int base, long *res);
diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index 2dbae88..5099755 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -19,11 +19,6 @@
 #include <linux/types.h>
 #include <asm/uaccess.h>
 
-static inline char _tolower(const char c)
-{
-	return c | 0x20;
-}
-
 static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
 	unsigned long long acc;
@@ -31,14 +26,14 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 
 	if (base == 0) {
 		if (s[0] == '0') {
-			if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
+			if (TOLOWER(s[1]) == 'x' && isxdigit(s[2]))
 				base = 16;
 			else
 				base = 8;
 		} else
 			base = 10;
 	}
-	if (base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
+	if (base == 16 && s[0] == '0' && TOLOWER(s[1]) == 'x')
 		s += 2;
 
 	acc = 0;
@@ -48,8 +43,8 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 
 		if ('0' <= *s && *s <= '9')
 			val = *s - '0';
-		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
-			val = _tolower(*s) - 'a' + 10;
+		else if ('a' <= TOLOWER(*s) && TOLOWER(*s) <= 'f')
+			val = TOLOWER(*s) - 'a' + 10;
 		else if (*s == '\n' && *(s + 1) == '\0')
 			break;
 		else
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 75bace7..29a0fe0 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -31,9 +31,6 @@
 #include <asm/div64.h>
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
 
-/* Works only for digits and letters, but small and fast */
-#define TOLOWER(x) ((x) | 0x20)
-
 static unsigned int simple_guess_base(const char *cp)
 {
 	if (cp[0] == '0') {
-- 
1.7.5.4

