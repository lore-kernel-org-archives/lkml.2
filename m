Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670Ab0HEWiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:38:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58483 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934627Ab0HEWin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=LLgktmghvgysLewnVqxIZ+t1F+3jXUm72Xdm7XoBUP+rKdHd7tz/VEHV7AF5pJ19g3
         ImVXSfIt6SXqspwFfe+YCFzDt8StBOukQfI6wDtQ7FcoK1GtLJiDfSlBrgSv8tH6iTfn
         hyHpjmsK7K2g5iF0cDRznVz3CO4hOjex/DNLw=
From: Michal Nazarewicz <mina86@mina86.com>
To: linux-kernel@vger.kernel.org
Cc: m.nazarewicz@samsung.com, Michal Nazarewicz <mina86@mina86.com>,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Denis Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] lib: vsprintf: optimised put_dec_trunc() and put_dec_full()
Date: Fri,  6 Aug 2010 00:38:21 +0200
Message-Id: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The put_dec_trunc() and put_dec_full() functions were based on
a code optimised for processors with 8-bit ALU but even then
they failed to satisfy the same constraints and in fact
required at least 16-bit ALU (because at least one number they
operate in can take 9 bits).

This version of those functions proposed by this patch goes
further and uses the full capacity of a 32-bit ALU and instead
of splitting the number into nibbles and operating on them it
performs the obvious algorithm for base conversion expect it
uses optimised code for dividing by ten (ie. no division is
actually performed).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 lib/vsprintf.c |  150 +++++++++++++++++++++++++++----------------------------
 1 files changed, 74 insertions(+), 76 deletions(-)


I did some benchmark on the following three processors:

Phenom: AMD Phenom(tm) II X3 710 Processor   (64-bit)
Atom:   Intel(R) Atom(TM) CPU N270 @ 1.60GHz (32-bit)
ARM:    ARMv7 Processor rev 2 (v7l)          (32-bit)

Here are the results (normalised to the fastest/smallest):

                    :        ARM     Phonem      Intel
-- Speed -------------------------------------------------------
orig_put_dec_full   :   1.078600   1.777800   1.356917  Original
mod1_put_dec_full   :   1.000000   1.117665   1.017742
mod3_put_dec_full   :   1.032507   1.000000   1.000000  Proposed

orig_put_dec_trunc  :   1.092177   1.657014   1.215658  Original
mod1_put_dec_trunc  :   1.006836   1.395088   1.078385
mod3_put_dec_trunc  :   1.000000   1.000000   1.000000  Proposed
-- Size --------------------------------------------------------
orig_put_dec_full   :   1.212766   1.355372   1.310345  Original
mod1_put_dec_full   :   1.021277   1.000000   1.000000
mod3_put_dec_full   :   1.000000   1.049587   1.172414  Proposed

orig_put_dec_trunc  :   1.363636   1.784000   1.317365  Original
mod1_put_dec_trunc  :   1.181818   1.400000   1.275449
mod3_put_dec_trunc  :   1.000000   1.000000   1.000000  Proposed

Source of the benchmark as well as code of all the modified version of
functions is included with the third patch of the benchmark.


As it can be observed from the table, the "mod3" version (proposed by
this patch) is the fastest version with the only exception of
"mod3_put_dec_full" on ARM which is slightly slower then
"mod1_put_dec_full" version.

It is also smaller, in terms of code size, then the original version
even though "mod1" is even smaller.

In the end, I'm proposing "mod3" because the size is not that
important (those are mere bytes) and as of speed, for ARM I have
proposed another solution in the next patch of this patchset.

The function is also shorter in terms of lines of code. ;)

I'm currently running 2.6.35 with this patch applied.  It applies just
fine on -next as well but I haven't tested this kernel and I've run it
with -next on ARM.


diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b8a2f54..d63fb15 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -278,96 +278,94 @@ int skip_atoi(const char **s)
 	return i;
 }
 
-/* Decimal conversion is by far the most typical, and is used
- * for /proc and /sys data. This directly impacts e.g. top performance
- * with many processes running. We optimize it for speed
- * using code from
- * http://www.cs.uiowa.edu/~jones/bcd/decimal.html
- * (with permission from the author, Douglas W. Jones). */
-
-/* Formats correctly any integer in [0,99999].
- * Outputs from one to five digits depending on input.
- * On i386 gcc 4.1.2 -O2: ~250 bytes of code. */
+/*
+ * Decimal conversion is by far the most typical, and is used for
+ * /proc and /sys data. This directly impacts e.g. top performance
+ * with many processes running.
+ *
+ * We optimize it for speed using ideas described at
+ * <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
+ *
+ * '(num * 0xcccd) >> 19' is an approximation of 'num / 10' that gives
+ * correct results for num < 81920.  Because of this, we check at the
+ * beginning if we are dealing with a number that may cause trouble
+ * and if so, we make it smaller.
+ *
+ * (As a minor note, all operands are always 16 bit so this function
+ * should work well on hardware that cannot multiply 32 bit numbers).
+ *
+ * (Previous a code based on
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html> was used here,
+ * with permission from the author, Douglas W. Jones.)
+ *
+ * Other, possible ways to approx. divide by 10
+ * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+ * (x * 0x67) >> 10:  1100111
+ * (x * 0x34) >> 9:    110100 - same
+ * (x * 0x1a) >> 8:     11010 - same
+ * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+ */
 static noinline_for_stack
-char *put_dec_trunc(char *buf, unsigned q)
+char *put_dec_full(char *buf, unsigned q)
 {
-	unsigned d3, d2, d1, d0;
-	d1 = (q>>4) & 0xf;
-	d2 = (q>>8) & 0xf;
-	d3 = (q>>12);
-
-	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
-	q = (d0 * 0xcd) >> 11;
-	d0 = d0 - 10*q;
-	*buf++ = d0 + '0'; /* least significant digit */
-	d1 = q + 9*d3 + 5*d2 + d1;
-	if (d1 != 0) {
-		q = (d1 * 0xcd) >> 11;
-		d1 = d1 - 10*q;
-		*buf++ = d1 + '0'; /* next digit */
-
-		d2 = q + 2*d2;
-		if ((d2 != 0) || (d3 != 0)) {
-			q = (d2 * 0xd) >> 7;
-			d2 = d2 - 10*q;
-			*buf++ = d2 + '0'; /* next digit */
-
-			d3 = q + 4*d3;
-			if (d3 != 0) {
-				q = (d3 * 0xcd) >> 11;
-				d3 = d3 - 10*q;
-				*buf++ = d3 + '0';  /* next digit */
-				if (q != 0)
-					*buf++ = q + '0'; /* most sign. digit */
-			}
-		}
+	unsigned r;
+	char a = '0';
+
+	if (q > 0xffff) {
+		a = '6';
+		q -= 60000;
 	}
 
+	r   = (q * 0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
+
+	q   = (r * 0x199a) >> 16;
+	*buf++ = (r - 10 * q)  + '0';
+
+	r   = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+
+	q   = (r * 0xd) >> 7;
+	*buf++ = (r - 10 * q) + '0';
+
+	*buf++ = q + a;
+
 	return buf;
 }
-/* Same with if's removed. Always emits five digits */
+
+/* Same as above but do not pad with zeros. */
 static noinline_for_stack
-char *put_dec_full(char *buf, unsigned q)
+char *put_dec_trunc(char *buf, unsigned q)
 {
-	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
-	/* but anyway, gcc produces better code with full-sized ints */
-	unsigned d3, d2, d1, d0;
-	d1 = (q>>4) & 0xf;
-	d2 = (q>>8) & 0xf;
-	d3 = (q>>12);
+	unsigned r;
 
 	/*
-	 * Possible ways to approx. divide by 10
-	 * gcc -O2 replaces multiply with shifts and adds
-	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
-	 * (x * 0x67) >> 10:  1100111
-	 * (x * 0x34) >> 9:    110100 - same
-	 * (x * 0x1a) >> 8:     11010 - same
-	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+	 * We need to check if num is < 81920 so we might as well
+	 * check if we can just call the _full version of this
+	 * function.
 	 */
-	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
-	q = (d0 * 0xcd) >> 11;
-	d0 = d0 - 10*q;
-	*buf++ = d0 + '0';
-	d1 = q + 9*d3 + 5*d2 + d1;
-		q = (d1 * 0xcd) >> 11;
-		d1 = d1 - 10*q;
-		*buf++ = d1 + '0';
-
-		d2 = q + 2*d2;
-			q = (d2 * 0xd) >> 7;
-			d2 = d2 - 10*q;
-			*buf++ = d2 + '0';
-
-			d3 = q + 4*d3;
-				q = (d3 * 0xcd) >> 11; /* - shorter code */
-				/* q = (d3 * 0x67) >> 10; - would also work */
-				d3 = d3 - 10*q;
-				*buf++ = d3 + '0';
-					*buf++ = q + '0';
+	if (q > 9999)
+		return put_dec_full(buf, q);
+
+	r   = (q * 0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
+
+	if (r) {
+		q   = (r * 0x199a) >> 16;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q) {
+			r   = (q * 0xcd) >> 11;
+			*buf++ = (q - 10 * r)  + '0';
+
+			if (r)
+				*buf++ = r + '0';
+		}
+	}
 
 	return buf;
 }
+
 /* No inlining helps gcc to use registers better */
 static noinline_for_stack
 char *put_dec(char *buf, unsigned long long num)
-- 
1.7.1

