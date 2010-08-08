Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0HHTaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:30:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51858 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0HHTav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=B89w3+Fding67dmLz8+vPTFnR9TRpvbJK7hI7xBjUplnCCAv1FbIzjIxOnkZd2Q1de
         4lzb7ngB2JdvIWiziSxR2N+imiKcliWvl55UhgoSrYy3bwpXfKLMurE0SHPI6h0Nk0eN
         2c4WRbE8aDx7xMRKVVqpMwXJId9nclOqcTqww=
From: Michal Nazarewicz <mina86@mina86.com>
To: linux-kernel@vger.kernel.org
Cc: m.nazarewicz@samsung.com, Michal Nazarewicz <mina86@mina86.com>,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Denis Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv2 1/3] lib: vsprintf: optimised put_dec_trunc() and put_dec_full()
Date: Sun,  8 Aug 2010 21:29:55 +0200
Message-Id: <6f90103dea29739de0f4f0ede3f3da68afe84343.1281295424.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The put_dec_trunc() and put_dec_full() functions were based on
a code optimised for processors with 8-bit ALU but since we
don't need to limit ourselves to such small ALUs, the code was
optimised and used capacities of an 16-bit ALU anyway.

This patch goes further and uses the full capacity of a 32-bit
ALU and instead of splitting the number into nibbles and
operating on them it performs the obvious algorithm for base
conversion (except it uses optimised code for dividing by
ten).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 lib/vsprintf.c |  143 +++++++++++++++++++++++++++----------------------------
 1 files changed, 70 insertions(+), 73 deletions(-)

Compared to v1 only commit message and comments were changed.


I did some benchmark on the following processors:

ARM     : ARMv7 Processor rev 2 (v7l)                   (32-bit)
Atom    : Intel(R) Atom(TM) CPU N270 @ 1.60GHz          (32-bit)
Core    : Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz   (64-bit)
Phenom  : AMD Phenom(tm) II X3 710 Processor            (64-bit)

Here are the results (normalised to the fastest/smallest):

                    :        ARM       Atom       Core     Phenom
-- Speed --------------------------------------------------------
orig_put_dec_full   :   1.054570   1.356214   1.732636   1.725760  Original
mod1_put_dec_full   :   1.000000   1.017216   1.255518   1.116559
mod3_put_dec_full   :   1.018222   1.000000   1.000000   1.000000  Proposed

orig_put_dec_trunc  :   1.137903   1.216017   1.850478   1.662370  Original
mod1_put_dec_trunc  :   1.000000   1.078154   1.355635   1.400637
mod3_put_dec_trunc  :   1.025989   1.000000   1.000000   1.000000  Proposed
-- Size ---------------------------------------------------------
orig_put_dec_full   :   1.212766   1.310345   1.355372   1.355372  Original
mod1_put_dec_full   :   1.021277   1.000000   1.000000   1.000000
mod3_put_dec_full   :   1.000000   1.172414   1.049587   1.049587  Proposed

orig_put_dec_trunc  :   1.363636   1.317365   1.784000   1.784000  Original
mod1_put_dec_trunc  :   1.181818   1.275449   1.400000   1.400000
mod3_put_dec_trunc  :   1.000000   1.000000   1.000000   1.000000  Proposed


Source of the benchmark as well as code of all the modified version of
functions is included with the third patch of the benchmark.


As it can be observed from the table, the "mod3" version (proposed by
this patch) is the fastest version with the only exception of ARM on
which it looses by ~2% with "mod1".

It is also smaller, in terms of code size, then the original version
even though "mod1" is even smaller.

In the end, I'm proposing "mod3" because those few bytes are worth the
speed I think and also, for ARM I'm proposing another version in the
patch that follows this one.

The function is also shorter in terms of lines of code.


I'm currently running 2.6.35 with this patch applied.  It applies just
fine on -next and I've run it on ARM.


PS. I've sent a private email to Mr. Jones to get his permission to
use his code.  I'm sure there will be no issues.  I'll resubmitt the
patchset with his Signed-off-by when I hear back from him.

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b8a2f54..35764f6 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -278,96 +278,93 @@ int skip_atoi(const char **s)
 	return i;
 }
 
-/* Decimal conversion is by far the most typical, and is used
+/*
+ * Decimal conversion is by far the most typical, and is used
  * for /proc and /sys data. This directly impacts e.g. top performance
  * with many processes running. We optimize it for speed
- * using code from
- * http://www.cs.uiowa.edu/~jones/bcd/decimal.html
- * (with permission from the author, Douglas W. Jones). */
-
-/* Formats correctly any integer in [0,99999].
- * Outputs from one to five digits depending on input.
- * On i386 gcc 4.1.2 -O2: ~250 bytes of code. */
+ * using ideas described at <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
+ *
+ * Formats correctly any integer in [0, 9999].
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
+	/*
+	 * '(x * 0xcccd) >> 19' is an approximation of 'x / 10' that
+	 * gives correct results for all x < 81920.  However, because
+	 * intermediate result can be at most 32-bit we limit x to be
+	 * 16-bit.
+	 *
+	 * Because of those, we check if we are dealing with a "big"
+	 * number and if so, we make it smaller remembering to add to
+	 * the most significant digit.
+	 */
+	if (q >= 50000) {
+		a  = '5';
+		q -= 50000;
 	}
 
-	return buf;
-}
-/* Same with if's removed. Always emits five digits */
-static noinline_for_stack
-char *put_dec_full(char *buf, unsigned q)
-{
-	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
-	/* but anyway, gcc produces better code with full-sized ints */
-	unsigned d3, d2, d1, d0;
-	d1 = (q>>4) & 0xf;
-	d2 = (q>>8) & 0xf;
-	d3 = (q>>12);
+	r   = (q * 0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
 
 	/*
-	 * Possible ways to approx. divide by 10
-	 * gcc -O2 replaces multiply with shifts and adds
+	 * Other, possible ways to approx. divide by 10
 	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
 	 * (x * 0x67) >> 10:  1100111
 	 * (x * 0x34) >> 9:    110100 - same
 	 * (x * 0x1a) >> 8:     11010 - same
 	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
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
+	return buf;
+}
+
+/* Same as above but do not pad with zeros. */
+static noinline_for_stack
+char *put_dec_trunc(char *buf, unsigned q)
+{
+	unsigned r;
+
+	/*
+	 * We need to check if q is < 65536 so we might as well check
+	 * if we can just call the _full version of this function.
+	 */
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

