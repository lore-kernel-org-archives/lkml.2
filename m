Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1GSHSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 03:18:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:48868 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab1GSHSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 03:18:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,227,1309762800"; 
   d="scan'208";a="29272772"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv2.1] lib: make _tolower() public
Date: Tue, 19 Jul 2011 10:17:38 +0300
Message-Id: <117b1e349dda94de79266d7dd9b8f7e0b9deb5da.1311059753.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20110718205239.GA3543@p183.telecom.by>
References: <20110718205239.GA3543@p183.telecom.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is required by *printf and kstrto* functions that are located in
the different modules. This patch makes _tolower() public. However, it's good
idea to not use the helper outside of mentioned functions.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/ctype.h |    9 +++++++++
 lib/kstrtox.c         |    5 -----
 lib/vsprintf.c        |   23 ++++++++++-------------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/linux/ctype.h b/include/linux/ctype.h
index a3d6ee0..e21e335 100644
--- a/include/linux/ctype.h
+++ b/include/linux/ctype.h
@@ -52,4 +52,13 @@ static inline unsigned char __toupper(unsigned char c)
 #define tolower(c) __tolower(c)
 #define toupper(c) __toupper(c)
 
+/*
+ * Fast implementation of tolower() for internal usage. Do not use in your
+ * code.
+ */
+static inline char _tolower(const char c)
+{
+       return c | 0x20;
+}
+
 #endif
diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index 2dbae88..5e06675 100644
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
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 75bace7..d7222a9 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -31,13 +31,10 @@
 #include <asm/div64.h>
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
 
-/* Works only for digits and letters, but small and fast */
-#define TOLOWER(x) ((x) | 0x20)
-
 static unsigned int simple_guess_base(const char *cp)
 {
 	if (cp[0] == '0') {
-		if (TOLOWER(cp[1]) == 'x' && isxdigit(cp[2]))
+		if (_tolower(cp[1]) == 'x' && isxdigit(cp[2]))
 			return 16;
 		else
 			return 8;
@@ -59,13 +56,13 @@ unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int bas
 	if (!base)
 		base = simple_guess_base(cp);
 
-	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
+	if (base == 16 && cp[0] == '0' && _tolower(cp[1]) == 'x')
 		cp += 2;
 
 	while (isxdigit(*cp)) {
 		unsigned int value;
 
-		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
+		value = isdigit(*cp) ? *cp - '0' : _tolower(*cp) - 'a' + 10;
 		if (value >= base)
 			break;
 		result = result * base + value;
@@ -1036,8 +1033,8 @@ precision:
 qualifier:
 	/* get the conversion qualifier */
 	spec->qualifier = -1;
-	if (*fmt == 'h' || TOLOWER(*fmt) == 'l' ||
-	    TOLOWER(*fmt) == 'z' || *fmt == 't') {
+	if (*fmt == 'h' || _tolower(*fmt) == 'l' ||
+	    _tolower(*fmt) == 'z' || *fmt == 't') {
 		spec->qualifier = *fmt++;
 		if (unlikely(spec->qualifier == *fmt)) {
 			if (spec->qualifier == 'l') {
@@ -1104,7 +1101,7 @@ qualifier:
 			spec->type = FORMAT_TYPE_LONG;
 		else
 			spec->type = FORMAT_TYPE_ULONG;
-	} else if (TOLOWER(spec->qualifier) == 'z') {
+	} else if (_tolower(spec->qualifier) == 'z') {
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
@@ -1262,7 +1259,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			if (qualifier == 'l') {
 				long *ip = va_arg(args, long *);
 				*ip = (str - buf);
-			} else if (TOLOWER(qualifier) == 'z') {
+			} else if (_tolower(qualifier) == 'z') {
 				size_t *ip = va_arg(args, size_t *);
 				*ip = (str - buf);
 			} else {
@@ -1549,7 +1546,7 @@ do {									\
 			void *skip_arg;
 			if (qualifier == 'l')
 				skip_arg = va_arg(args, long *);
-			else if (TOLOWER(qualifier) == 'z')
+			else if (_tolower(qualifier) == 'z')
 				skip_arg = va_arg(args, size_t *);
 			else
 				skip_arg = va_arg(args, int *);
@@ -1855,8 +1852,8 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 
 		/* get conversion qualifier */
 		qualifier = -1;
-		if (*fmt == 'h' || TOLOWER(*fmt) == 'l' ||
-		    TOLOWER(*fmt) == 'z') {
+		if (*fmt == 'h' || _tolower(*fmt) == 'l' ||
+		    _tolower(*fmt) == 'z') {
 			qualifier = *fmt++;
 			if (unlikely(qualifier == *fmt)) {
 				if (qualifier == 'h') {
-- 
1.7.5.4

