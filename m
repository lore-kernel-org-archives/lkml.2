Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab2KBOne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:43:34 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45299 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2KBOn3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Fri, 2 Nov 2012 10:43:29 -0400
Message-Id: <5093EA4802000078000A61D4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 14:44:08 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] sscanf: don't ignore field widths for numeric
 conversions
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another step towards better standard conformance. Rather than
adding a local buffer to store the specified portion of the string
(with the need to enforce an arbitrary maximum supported width to
limit the buffer size), do a maximum width conversion and then drop as
much of it as is necessary to meet the caller's request.

Also fail on negative field widths.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 lib/vsprintf.c |   96 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 43 deletions(-)

--- 3.7-rc3/lib/vsprintf.c
+++ 3.7-rc3-sscanf-field-width/lib/vsprintf.c
@@ -23,12 +23,12 @@
 #include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/kallsyms.h>
+#include <linux/math64.h>
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
-#include <asm/div64.h>
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
 
 #include "kstrtox.h"
@@ -2013,7 +2013,11 @@ int vsscanf(const char *buf, const char
 	char digit;
 	int num = 0;
 	u8 qualifier;
-	u8 base;
+	unsigned int base;
+	union {
+		long long s;
+		unsigned long long u;
+	} val;
 	s16 field_width;
 	bool is_sign;
 
@@ -2053,8 +2057,11 @@ int vsscanf(const char *buf, const char
 
 		/* get field width */
 		field_width = -1;
-		if (isdigit(*fmt))
+		if (isdigit(*fmt)) {
 			field_width = skip_atoi(&fmt);
+			if (field_width <= 0)
+				break;
+		}
 
 		/* get conversion qualifier */
 		qualifier = -1;
@@ -2154,58 +2161,61 @@ int vsscanf(const char *buf, const char
 		    || (base == 0 && !isdigit(digit)))
 			break;
 
+		if (is_sign)
+			val.s = qualifier != 'L' ?
+				simple_strtol(str, &next, base) :
+				simple_strtoll(str, &next, base);
+		else
+			val.u = qualifier != 'L' ?
+				simple_strtoul(str, &next, base) :
+				simple_strtoull(str, &next, base);
+
+		if (field_width > 0 && next - str > field_width) {
+			if (base == 0)
+				_parse_integer_fixup_radix(str, &base);
+			while (next - str > field_width) {
+				if (is_sign)
+					val.s = div_s64(val.s, base);
+				else
+					val.u = div_u64(val.u, base);
+				--next;
+			}
+		}
+
 		switch (qualifier) {
 		case 'H':	/* that's 'hh' in format */
-			if (is_sign) {
-				signed char *s = (signed char *)va_arg(args, signed char *);
-				*s = (signed char)simple_strtol(str, &next, base);
-			} else {
-				unsigned char *s = (unsigned char *)va_arg(args, unsigned char *);
-				*s = (unsigned char)simple_strtoul(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, signed char *) = val.s;
+			else
+				*va_arg(args, unsigned char *) = val.u;
 			break;
 		case 'h':
-			if (is_sign) {
-				short *s = (short *)va_arg(args, short *);
-				*s = (short)simple_strtol(str, &next, base);
-			} else {
-				unsigned short *s = (unsigned short *)va_arg(args, unsigned short *);
-				*s = (unsigned short)simple_strtoul(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, short *) = val.s;
+			else
+				*va_arg(args, unsigned short *) = val.u;
 			break;
 		case 'l':
-			if (is_sign) {
-				long *l = (long *)va_arg(args, long *);
-				*l = simple_strtol(str, &next, base);
-			} else {
-				unsigned long *l = (unsigned long *)va_arg(args, unsigned long *);
-				*l = simple_strtoul(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, long *) = val.s;
+			else
+				*va_arg(args, unsigned long *) = val.u;
 			break;
 		case 'L':
-			if (is_sign) {
-				long long *l = (long long *)va_arg(args, long long *);
-				*l = simple_strtoll(str, &next, base);
-			} else {
-				unsigned long long *l = (unsigned long long *)va_arg(args, unsigned long long *);
-				*l = simple_strtoull(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, long long *) = val.s;
+			else
+				*va_arg(args, unsigned long long *) = val.u;
 			break;
 		case 'Z':
 		case 'z':
-		{
-			size_t *s = (size_t *)va_arg(args, size_t *);
-			*s = (size_t)simple_strtoul(str, &next, base);
-		}
-		break;
+			*va_arg(args, size_t *) = val.u;
+			break;
 		default:
-			if (is_sign) {
-				int *i = (int *)va_arg(args, int *);
-				*i = (int)simple_strtol(str, &next, base);
-			} else {
-				unsigned int *i = (unsigned int *)va_arg(args, unsigned int*);
-				*i = (unsigned int)simple_strtoul(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, int *) = val.s;
+			else
+				*va_arg(args, unsigned int *) = val.u;
 			break;
 		}
 		num++;


