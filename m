Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696Ab0HEWj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:39:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46107 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934646Ab0HEWip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=R8zBODKn8H099oUxBejecVYi3DCj41lGg1HYOOqKxNOkYfRfTaTnlu+CVbW6r328KJ
         liFHKN5NM8FnHX2ozYDJ07TyhV7dYkOtjbml19XKiEdbeT3xoBfNetNBkdy2DNS3mebA
         N7AkJtwP+y3lhoY0n0I851QHqrppCJuWWpCZU=
From: Michal Nazarewicz <mina86@mina86.com>
To: linux-kernel@vger.kernel.org
Cc: m.nazarewicz@samsung.com, Michal Nazarewicz <mina86@mina86.com>,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Denis Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] lib: vsprintf: optimised put_dec() for 32-bit machines
Date: Fri,  6 Aug 2010 00:38:22 +0200
Message-Id: <0543dae0f66ba8e0ce42ce3adf1fe31704eb240d.1280872240.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing put_dec() function uses a do_div() function for
dividing the 64-bit argument.  On 32-bit machines this may be
a costly operation.  This patch, replaces the put_dec()
function on 32-bit processors to one that performs no 64-bit
divisions.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 lib/vsprintf.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 102 insertions(+), 1 deletions(-)


I did some benchmark on the following two processors:

Atom:   Intel(R) Atom(TM) CPU N270 @ 1.60GHz
ARM:    ARMv7 Processor rev 2 (v7l)

(I'm ommitting Phenom since this code is ment for 32-bit processors).

Here are the results (normalised to the fastest/smallest):

                    :        ARM      Intel
-- Speed ---------------------------------------------------------------
orig_put_dec        :  10.194361   2.190063  Original
mod1_put_dec        :  10.259952   2.025620
mod2_put_dec        :  10.142540   1.970004
mod3_put_dec        :  10.284313   1.961153  Version from previous patch
mod4_put_dec        :  10.164480   1.986127
mod5_put_dec        :  14.529587   2.531521
mod6_put_dec        :   1.000000   1.000000  Proposed
mod7_put_dec        :   1.006486   1.011573
mod8_put_dec        :   8.347325   2.153098
-- Size ----------------------------------------------------------------
orig_put_dec        :   1.000000   1.000000  Original
mod1_put_dec        :   1.000000   1.000000
mod2_put_dec        :   1.361111   1.403226
mod3_put_dec        :   1.000000   1.000000  Version from previous patch
mod4_put_dec        :   1.361111   1.403226
mod5_put_dec        :   1.000000   1.000000
mod6_put_dec        :   2.555556   3.508065  Proposed
mod7_put_dec        :   2.833333   3.911290
mod8_put_dec        :   2.027778   2.258065

Source of the benchmark as well as code of all the modified version of
functions is included with the third patch of the benchmark.


As it can be obsevred, proposed version of the put_dec function is 10
times faster on ARM.  I imagine that it may be similar on other
"embedded" processors.

This may be skewed by the fact that the benchmark is using GCC's
64-bit division operator instead of kernel's do_div but it would
appear that by avoiding 64-bit division something can be gained.

The disadvantage is that the proposed function is 2.5-3.5 bigger.
Those are not big functions though -- we are talking here about
proposed function being below 512.


The drawback of this function is also that the patch adds a bit of
code.  It could be questionable whether it's worth optimising that
much.  Anyway, posting in case someone decides that it is or will be
simply interested. :)


I'm currently running 2.6.35 with this patch applied.  It applies just
fine on -next as well but I haven't tested this kernel (I don't really
have a machine that I wouldn't be afraid to run -next on ;) ).


PS. From Mr. Jones site: "Nonetheless, before relying on the material
here, it would be prudent to check the arithmetic!" hence I checked
all the calculations myself and everything seemed fine.  I've also run
test applitacion several times so it tested a few 64-bit numbers.
Here's a "bc" script which calculates all the numbers:


# You can feed "bc" with this file to check the numbers

# n  =                  1 * n0 +    0 <= n0 <= 65535
#                  6 5536 * n1 +    0 <= n1 <= 65535
#            42 9496 7296 * n2 +    0 <= n2 <= 65535
#      281 4749 7671 0656 * n3      0 <= n3 <= 65535

n0 = 65535
n1 = 65535
n2 = 65535
n3 = 65535

# n  =              10^ 0 * d0 +
#                   10^ 4 * d1 +
#                   10^ 8 * d2 +
#                   10^12 * d3 +
#                   10^16 * d4

a0 =  656 * n3 + 7296 * n2 + 5536 * n1 +   1 * n0
print "0 <= a0 <= ", a0, "\n"
# 0 <= a0 <=   884 001 615

a1 = 7671 * n3 + 9496 * n2 +    6 * n1
print "0 <= a1 <= ", a1, "\n"
# 0 <= a1 <= 1 125 432 555

a2 = 4749 * n3 +   42 * n2
print "0 <= a2 <= ", a2, "\n"
# 0 <= a2 <=   313 978 185

a3 =  281 * n3
print "0 <= a3 <= ", a3, "\n"
# 0 <= a3 <=    18 415 335


b0 = a0
print "0 <= b0 <= ", b0, "\n0 <= c1 <= ", b0 / 10000, "\n"
# 0 <= d0 <=   884 001 615
# 0 <= c1 <=        88 400

b1 = a1 + b0 / 10000
print "0 <= b1 <= ", b1, "\n0 <= c2 <= ", b1 / 10000, "\n"
# 0 <= d1 <= 1 125 520 955
# 0 <= c2 <=       112 552

b2 = a2 + b1 / 10000
print "0 <= b2 <= ", b2, "\n0 <= c3 <= ", b2 / 10000, "\n"
# 0 <= d2 <=   314 090 737
# 0 <= c3 <=        31 409

b3 = a3 + b2 / 10000
print "0 <= b3 <= ", b3, "\n0 <= c4 <= ", b3 / 10000, "\n"
# 0 <= d3 <=    18 446 744
# 0 <= c4 <=         1 844

b4 = a4 + b3 / 10000
print "0 <= b4 <= ", b4, "\n"
# 0 <= b4 <=         1 844


diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d63fb15..bfbe662 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -278,6 +278,8 @@ int skip_atoi(const char **s)
 	return i;
 }
 
+#if BITS_PER_LONG == 64
+
 /*
  * Decimal conversion is by far the most typical, and is used for
  * /proc and /sys data. This directly impacts e.g. top performance
@@ -366,6 +368,9 @@ char *put_dec_trunc(char *buf, unsigned q)
 	return buf;
 }
 
+/* This is used by ip4_string(). */
+#define put_dec_8bit put_dec_trunc
+
 /* No inlining helps gcc to use registers better */
 static noinline_for_stack
 char *put_dec(char *buf, unsigned long long num)
@@ -379,6 +384,102 @@ char *put_dec(char *buf, unsigned long long num)
 	}
 }
 
+#else
+
+/*
+ * This is similar to the put_dec_full() above expect it handles
+ * numbers from 0 to 9999 (ie. at most four digits).  It is used by
+ * the put_dec() below which is optimised for 32-bit processors.
+ */
+static noinline_for_stack
+char *put_dec_full(char *buf, unsigned q)
+{
+	unsigned r;
+
+	r      = (q * 0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
+
+	q      = (r * 0x199a) >> 16;
+	*buf++ = (r - 10 * q)  + '0';
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+
+	*buf++ = r + '0';
+
+	return buf;
+}
+
+/*
+ * Similar to above but handles only 8-bit operands and does not pad
+ * with zeros.
+ */
+static noinline_for_stack
+char *put_dec_8bit(char *buf, unsigned q)
+{
+	unsigned r;
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r) + '0';
+
+	if (r) {
+		q   = (r * 0xd) >> 7;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q)
+			*buf++ = q + '0';
+	}
+
+	return buf;
+}
+
+/*
+ * Based on code by Douglas W. Jones found at
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html#sixtyfour>.  This
+ * performs no 64-bit division and hence should be faster on 32-bit
+ * machines then the version of the function above.
+ */
+static noinline_for_stack
+char *put_dec(char *buf, unsigned long long n)
+{
+	uint32_t d3, d2, d1, q;
+
+	if (!n) {
+		*buf++ = '0';
+		return buf;
+	}
+
+	d1  = (n >> 16) & 0xFFFF;
+	d2  = (n >> 32) & 0xFFFF;
+	d3  = (n >> 48) & 0xFFFF;
+
+	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
+
+	buf = put_dec_full(buf, q % 10000);
+	q   = q / 10000;
+
+	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
+	buf = put_dec_full(buf, d1 % 10000);
+	q   = d1 / 10000;
+
+	d2  = q + 4749 * d3 + 42 * d2;
+	buf = put_dec_full(buf, d2 % 10000);
+	q   = d2 / 10000;
+
+	d3  = q + 281 * d3;
+	buf = put_dec_full(buf, d3 % 10000);
+	q   = d3 / 10000;
+
+	buf = put_dec_full(buf, q);
+
+	while (buf[-1] == '0')
+		--buf;
+
+	return buf;
+}
+
+#endif
+
 #define ZEROPAD	1		/* pad with zero */
 #define SIGN	2		/* unsigned/signed long */
 #define PLUS	4		/* show plus */
@@ -752,7 +853,7 @@ char *ip4_string(char *p, const u8 *addr, const char *fmt)
 	}
 	for (i = 0; i < 4; i++) {
 		char temp[3];	/* hold each IP quad in reverse order */
-		int digits = put_dec_trunc(temp, addr[index]) - temp;
+		int digits = put_dec_8bit(temp, addr[index]) - temp;
 		if (leading_zeros) {
 			if (digits < 3)
 				*p++ = '0';
-- 
1.7.1

