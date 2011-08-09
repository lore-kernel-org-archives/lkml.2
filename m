Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1HIVN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:13:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60898 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1HIVNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:13:25 -0400
Date: Wed, 10 Aug 2011 00:13:20 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kstrtox: common code between kstrto*() and simple_strto*()
 functions
Message-ID: <20110809211320.GA8716@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently termination logic (\0 or \n\0) is hardcoded in _kstrtoull(),
avoid that for code reuse between kstrto*() and simple_strtoull().
Essentially, make them different only in termination logic.

simple_strtoull() (and scanf(), BTW) ignores integer overflow,
that's a bug we currently don't have guts to fix,
making KSTRTOX_OVERFLOW hack necessary.

Almost forgot: patch shrinks code size by about ~80 bytes on x86_64.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 lib/kstrtox.c  |   75 ++++++++++++++++++++++++++++++++++++++++-----------------
 lib/kstrtox.h  |    8 ++++++
 lib/vsprintf.c |   33 +++++--------------------
 3 files changed, 68 insertions(+), 48 deletions(-)

--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -18,26 +18,40 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <asm/uaccess.h>
+#include "kstrtox.h"
 
-static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
+const char *_parse_integer_fixup_radix(const char *s, unsigned int *base)
 {
-	unsigned long long acc;
-	int ok;
-
-	if (base == 0) {
+	if (*base == 0) {
 		if (s[0] == '0') {
 			if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
-				base = 16;
+				*base = 16;
 			else
-				base = 8;
+				*base = 8;
 		} else
-			base = 10;
+			*base = 10;
 	}
-	if (base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
+	if (*base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
 		s += 2;
+	return s;
+}
 
-	acc = 0;
-	ok = 0;
+/*
+ * Convert non-negative integer string representation in explicitly given radix
+ * to an integer.
+ * Return number of characters consumed maybe or-ed with overflow bit.
+ * If overflow occurs, result integer (incorrect) is still returned.
+ *
+ * Don't you dare use this function.
+ */
+unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *res)
+{
+	unsigned int rv;
+	int overflow;
+
+	*res = 0;
+	rv = 0;
+	overflow = 0;
 	while (*s) {
 		unsigned int val;
 
@@ -45,23 +59,40 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 			val = *s - '0';
 		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
 			val = _tolower(*s) - 'a' + 10;
-		else if (*s == '\n' && *(s + 1) == '\0')
-			break;
 		else
-			return -EINVAL;
+			break;
 
 		if (val >= base)
-			return -EINVAL;
-		if (acc > div_u64(ULLONG_MAX - val, base))
-			return -ERANGE;
-		acc = acc * base + val;
-		ok = 1;
-
+			break;
+		if (*res > div_u64(ULLONG_MAX - val, base))
+			overflow = 1;
+		*res = *res * base + val;
+		rv++;
 		s++;
 	}
-	if (!ok)
+	if (overflow)
+		rv |= KSTRTOX_OVERFLOW;
+	return rv;
+}
+
+static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
+{
+	unsigned long long _res;
+	unsigned int rv;
+
+	s = _parse_integer_fixup_radix(s, &base);
+	rv = _parse_integer(s, base, &_res);
+	if (rv & KSTRTOX_OVERFLOW)
+		return -ERANGE;
+	rv &= ~KSTRTOX_OVERFLOW;
+	if (rv == 0)
+		return -EINVAL;
+	s += rv;
+	if (*s == '\n')
+		s++;
+	if (*s)
 		return -EINVAL;
-	*res = acc;
+	*res = _res;
 	return 0;
 }
 
--- /dev/null
+++ b/lib/kstrtox.h
@@ -0,0 +1,8 @@
+#ifndef _LIB_KSTRTOX_H
+#define _LIB_KSTRTOX_H
+
+#define KSTRTOX_OVERFLOW	(1U << 31)
+const char *_parse_integer_fixup_radix(const char *s, unsigned int *base);
+unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *res);
+
+#endif
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -31,17 +31,7 @@
 #include <asm/div64.h>
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
 
-static unsigned int simple_guess_base(const char *cp)
-{
-	if (cp[0] == '0') {
-		if (_tolower(cp[1]) == 'x' && isxdigit(cp[2]))
-			return 16;
-		else
-			return 8;
-	} else {
-		return 10;
-	}
-}
+#include "kstrtox.h"
 
 /**
  * simple_strtoull - convert a string to an unsigned long long
@@ -51,23 +41,14 @@ static unsigned int simple_guess_base(const char *cp)
  */
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
-	unsigned long long result = 0;
+	unsigned long long result;
+	unsigned int rv;
 
-	if (!base)
-		base = simple_guess_base(cp);
+	cp = _parse_integer_fixup_radix(cp, &base);
+	rv = _parse_integer(cp, base, &result);
+	/* FIXME */
+	cp += (rv & ~KSTRTOX_OVERFLOW);
 
-	if (base == 16 && cp[0] == '0' && _tolower(cp[1]) == 'x')
-		cp += 2;
-
-	while (isxdigit(*cp)) {
-		unsigned int value;
-
-		value = isdigit(*cp) ? *cp - '0' : _tolower(*cp) - 'a' + 10;
-		if (value >= base)
-			break;
-		result = result * base + value;
-		cp++;
-	}
 	if (endp)
 		*endp = (char *)cp;
 
