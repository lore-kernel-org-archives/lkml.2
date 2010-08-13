Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557Ab0HMMFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 08:05:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65045 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761520Ab0HMMFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=jaqMD/a/fokHP2ffXKdc1Hd3JTuA1uuDXb79fp81p4RkcXlwbU2YeHl1YoeiUhyOtq
         TK8wJU43OJ1Y9JPIT8ohVnXKZT4n8b3SbVVjF4Nrle9DCctVyyWZ0aZkOeUsSQ1lFcnf
         SIXyle8r2hBp4D+dwAbSFuz2JwJOrx7DyAPVA=
From: Michal Nazarewicz <mina86@mina86.com>
To: linux-kernel@vger.kernel.org
Cc: Denis Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>, m.nazarewicz@samsung.com,
        Michal Nazarewicz <mina86@mina86.com>,
        "Douglas W. Jones" <jones@cs.uiowa.edu>
Subject: [PATCHv4 1/2] lib: vsprintf: optimised put_dec() function
Date: Fri, 13 Aug 2010 14:05:11 +0200
Message-Id: <e32e267d160675b71f5ab0c570fd4a288afe4b0f.1281700694.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The put_dec() and family of functions were based on a code
optimised for processors with 8-bit ALU but since we don't
need to limit ourselves to such small ALUs, the code was
optimised and used capacities of an 16-bit ALU anyway.

This patch goes further and uses the full capacity of the
processor's ALU.

On 64-bit machines, the number is repeatedly divided by
100,000 to split it into 5-decimal-digit which are converted
using the obvious base conversion algorithm expect division by
ten is replaced with multiplication and shifts.

On 32-bit machines, no division is performed at all and in
particular, no 64-bit division is performed.  This can speed
up conversion a few times and up to 10 times!

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Douglas W. Jones <jones@cs.uiowa.edu>
Cc: Denis Vlasenko <vda.linux@googlemail.com>
---
 lib/vsprintf.c |  293 ++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 201 insertions(+), 92 deletions(-)

> On Wednesday 11 August 2010 23:58, Michal Nazarewicz wrote:
>> +static noinline_for_stack
>> +char *put_dec(char *buf, unsigned long long n)
>> +{
>> +	uint32_t d3, d2, d1, q;
>> +
>> +	if (n < 10) {
>> +		*buf++ = '0' + (unsigned)n;
>> +		return buf;
>> +	}

Denys Vlasenko <vda.linux@googlemail.com> writes:
> I looked at it and discovered that 0 is already special-cased
> at put_dec() callsite. You can drop the above if() block
> (or better comment it out, explaining that caller does it),
> and while at it, improve special-case code in number():
> replace
>
>         /* generate full string in tmp[], in reverse order */
>         i = 0;
>         if (num == 0)
>                 tmp[i++] = '0';
>
> with
>
>         if (num <= 7)
>                 tmp[i++] = '0' + num;
>
> (7, not 9, because it can be an octal conversion).

Well spotted! I've used:

> +	if (num < spec.base) {
> +		tmp[i++] = (digits[(unsigned)num] | locase);

and also documented that put_dec() won't work with zero.

>> +	q   = q / 10000;
>> +	buf = put_dec_full4(buf, q % 10000);
>
> Bug. You need to use temporary variable to store q / 10000 result.

Fixed.


Delta betwenn v3 and v4:
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index ce55ddc..dd2a189 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -373,7 +373,14 @@ static noinline_for_stack char *put_dec_trunc5(char *buf, unsigned q)
>  	return buf;
>  }
>  
> -/* No inlining helps gcc to use registers better */
> +/*
> + * This function formats all integers correctly, however on 32-bit
> + * processors function below is used (not this one) which handles only
> + * NON-ZERO integers.  So be advised never to call this function with
> + * num == 0.
> + *
> + * No inlining helps gcc to use registers better
> + */
>  static noinline_for_stack
>  char *put_dec(char *buf, unsigned long long num)
>  {
> @@ -440,25 +447,25 @@ char *put_dec_8bit(char *buf, unsigned q)
>   * permission from the author).  This performs no 64-bit division and
>   * hence should be faster on 32-bit machines then the version of the
>   * function above.
> + *
> + * This function formats correctly all NON-ZERO integers.  Passing
> + * zero makes daemons come out of your closet.  This is OK, since
> + * number(), which calls this function, has a special case for zero
> + * anyways.
>   */
>  static noinline_for_stack
>  char *put_dec(char *buf, unsigned long long n)
>  {
>  	uint32_t d3, d2, d1, q;
>  
> -	if (n < 10) {
> -		*buf++ = '0' + (unsigned)n;
> -		return buf;
> -	}
> -
>  	d1  = (n >> 16) & 0xFFFF;
>  	d2  = (n >> 32) & 0xFFFF;
>  	d3  = (n >> 48) & 0xFFFF;
>  
>  	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
>  
> -	q   = q / 10000;
>  	buf = put_dec_full4(buf, q % 10000);
> +	q   = q / 10000;
>  
>  	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
>  	q   = d1 / 10000;
> @@ -554,22 +561,23 @@ char *number(char *buf, char *end, unsigned long long num,
>  			spec.field_width--;
>  		}
>  	}
> -	if (need_pfx) {
> -		spec.field_width--;
> -		if (spec.base == 16)
> -			spec.field_width--;
> -	}
> +	if (need_pfx)
> +		/*
> +		 * This substract 1 for base 8 and 2 for base 16; base
> +		 * 10 never gets here.
> +		 */
> +		spec.field_width -= spec.base / 8;
>  
>  	/* generate full string in tmp[], in reverse order */
>  	i = 0;
> -	if (num == 0)
> -		tmp[i++] = '0';
> +	if (num < spec.base) {
> +		tmp[i++] = (digits[(unsigned)num] | locase);
>  	/* Generic code, for any base:
>  	else do {
>  		tmp[i++] = (digits[do_div(num,base)] | locase);
>  	} while (num != 0);
>  	*/
> -	else if (spec.base != 10) { /* 8 or 16 */
> +	} else if (spec.base != 10) { /* 8 or 16 */
>  		int mask = spec.base - 1;
>  		int shift = 3;
>  

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b8a2f54..dd2a189 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -278,109 +278,217 @@ int skip_atoi(const char **s)
 	return i;
 }
 
-/* Decimal conversion is by far the most typical, and is used
+
+#if BITS_PER_LONG > 32                   /* machine is at least 64-bit */    \
+ || ULLONG_MAX > 18446744073709551615ULL /* long long is more than 64-bit */
+
+/*
+ * Decimal conversion is by far the most typical, and is used
  * for /proc and /sys data. This directly impacts e.g. top performance
  * with many processes running. We optimize it for speed
- * using code from
- * http://www.cs.uiowa.edu/~jones/bcd/decimal.html
- * (with permission from the author, Douglas W. Jones). */
+ * using ideas described at <http://www.cs.uiowa.edu/~jones/bcd/divide.html>
+ * (with permission from the author, Douglas W. Jones).
+ *
+ * Formats correctly any integer in [0, 99999].
+ */
+static noinline_for_stack char *put_dec_full5(char *buf, unsigned q)
+{
+	unsigned r;
 
-/* Formats correctly any integer in [0,99999].
- * Outputs from one to five digits depending on input.
- * On i386 gcc 4.1.2 -O2: ~250 bytes of code. */
-static noinline_for_stack
-char *put_dec_trunc(char *buf, unsigned q)
+	/*
+	 * '(x * 0xcccd) >> 19' is an approximation of 'x / 10' that
+	 * gives correct results for all x < 81920 unless we use full
+	 * 64-bit intermidiate result in which case it gives correct
+	 * results for x < 262149.  Because of this, we cast 0xcccd to
+	 * (uint64_t).  Thanks to this we can produce full 5 digits
+	 * without any branches.
+	 */
+
+	r      = (q * (uint64_t)0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
+
+	/*
+	 * Other, possible ways to approx. divide by 10
+	 *  -- bigger loose most significant bits and are worse --
+	 * (x * 0xcccd) >> 19   x < 81920  (x < 262149 when 64-bit used)
+	 * (x * 0x6667) >> 18   x < 43699
+	 * (x * 0x3334) >> 17   x < 16389
+	 * (x * 0x199a) >> 16   x < 16389
+	 * (x * 0x0ccd) >> 15   x < 16389
+	 * (x * 0x0667) >> 14   x <  2739
+	 * (x * 0x0334) >> 13   x <  1029
+	 * (x * 0x019a) >> 12   x <  1029
+	 * (x * 0x00cd) >> 11   x <  1029   shorter code than * 0x67 (on i386)
+	 * (x * 0x0067) >> 10   x <   179
+	 * (x * 0x0034) >>  9   x <    69   same
+	 * (x * 0x001a) >>  8   x <    69   same
+	 * (x * 0x000d) >>  7   x <    69   same, shortest code (on i386)
+	 * (x * 0x0007) >>  6   x <    19
+	 *  -- smaller are useless --
+	 * See <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
+	 */
+
+	q      = (r * 0x199a) >> 16;
+	*buf++ = (r - 10 * q)  + '0';
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+
+	q      = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q) + '0';
+
+	*buf++ = q + '0';
+
+	return buf;
+}
+
+/* Same as above but do not pad with zeros. */
+static noinline_for_stack char *put_dec_trunc5(char *buf, unsigned q)
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
+	unsigned r;
+
+	/*
+	 * If q is 5-digit just use the put_dec_full5() instead of
+	 * cascading if()s.
+	 */
+	if (q > 9999)
+		return put_dec_full5(buf, q);
+
+	r      = (q * 0x199a) >> 16;
+	*buf++ = (q - 10 * r)  + '0';
+
+	if (r) {
+		q   = (r * 0xcd) >> 11;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q) {
+			r      = (q * 0xcd) >> 11;
+			*buf++ = (q - 10 * r)  + '0';
+
+			if (r)
+				*buf++ = r + '0';
 		}
 	}
 
 	return buf;
 }
-/* Same with if's removed. Always emits five digits */
+
+/*
+ * This function formats all integers correctly, however on 32-bit
+ * processors function below is used (not this one) which handles only
+ * NON-ZERO integers.  So be advised never to call this function with
+ * num == 0.
+ *
+ * No inlining helps gcc to use registers better
+ */
 static noinline_for_stack
-char *put_dec_full(char *buf, unsigned q)
+char *put_dec(char *buf, unsigned long long num)
 {
-	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
-	/* but anyway, gcc produces better code with full-sized ints */
-	unsigned d3, d2, d1, d0;
-	d1 = (q>>4) & 0xf;
-	d2 = (q>>8) & 0xf;
-	d3 = (q>>12);
+	while (num >= 100000)
+		buf = put_dec_full5(buf, do_div(num, 100000));
+	return put_dec_trunc5(buf, num);
+}
 
-	/*
-	 * Possible ways to approx. divide by 10
-	 * gcc -O2 replaces multiply with shifts and adds
-	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
-	 * (x * 0x67) >> 10:  1100111
-	 * (x * 0x34) >> 9:    110100 - same
-	 * (x * 0x1a) >> 8:     11010 - same
-	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
-	 */
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
+/* This is used by ip4_string(). */
+#define put_dec_8bit put_dec_trunc5
+
+#else /* BITS_PER_LONG <= 32 (ie. 32-bit machine) && long long is 64-bit*/
+
+/*
+ * This is similar to the put_dec_full5() above expect it handles
+ * numbers from 0 to 9999 (ie. at most four digits).  It is used by
+ * the put_dec() below which is optimised for 32-bit processors.
+ */
+static noinline_for_stack
+char *put_dec_full4(char *buf, unsigned q)
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
 
 	return buf;
 }
-/* No inlining helps gcc to use registers better */
+
+/*
+ * Similar to above but handles only 8-bit operands and does not pad
+ * with zeros.  Used by ip4_string().
+ */
 static noinline_for_stack
-char *put_dec(char *buf, unsigned long long num)
+char *put_dec_8bit(char *buf, unsigned q)
 {
-	while (1) {
-		unsigned rem;
-		if (num < 100000)
-			return put_dec_trunc(buf, num);
-		rem = do_div(num, 100000);
-		buf = put_dec_full(buf, rem);
+	unsigned r;
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r) + '0';
+
+	if (r) {
+		q      = (r * 0xd) >> 7;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q)
+			*buf++ = q + '0';
 	}
+
+	return buf;
+}
+
+/*
+ * Based on code by Douglas W. Jones found at
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html#sixtyfour> (with
+ * permission from the author).  This performs no 64-bit division and
+ * hence should be faster on 32-bit machines then the version of the
+ * function above.
+ *
+ * This function formats correctly all NON-ZERO integers.  Passing
+ * zero makes daemons come out of your closet.  This is OK, since
+ * number(), which calls this function, has a special case for zero
+ * anyways.
+ */
+static noinline_for_stack
+char *put_dec(char *buf, unsigned long long n)
+{
+	uint32_t d3, d2, d1, q;
+
+	d1  = (n >> 16) & 0xFFFF;
+	d2  = (n >> 32) & 0xFFFF;
+	d3  = (n >> 48) & 0xFFFF;
+
+	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
+
+	buf = put_dec_full4(buf, q % 10000);
+	q   = q / 10000;
+
+	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
+	q   = d1 / 10000;
+	buf = put_dec_full4(buf, d1 % 10000);
+
+	d2  = q + 4749 * d3 + 42 * d2;
+	q   = d2 / 10000;
+	buf = put_dec_full4(buf, d2 % 10000);
+
+	d3  = q + 281 * d3;
+	q   = d3 / 10000;
+	buf = put_dec_full4(buf, d3 % 10000);
+
+	buf = put_dec_full4(buf, q);
+
+	while (buf[-1] == '0')
+		--buf;
+
+	return buf;
 }
 
+#endif
+
 #define ZEROPAD	1		/* pad with zero */
 #define SIGN	2		/* unsigned/signed long */
 #define PLUS	4		/* show plus */
@@ -453,22 +561,23 @@ char *number(char *buf, char *end, unsigned long long num,
 			spec.field_width--;
 		}
 	}
-	if (need_pfx) {
-		spec.field_width--;
-		if (spec.base == 16)
-			spec.field_width--;
-	}
+	if (need_pfx)
+		/*
+		 * This substract 1 for base 8 and 2 for base 16; base
+		 * 10 never gets here.
+		 */
+		spec.field_width -= spec.base / 8;
 
 	/* generate full string in tmp[], in reverse order */
 	i = 0;
-	if (num == 0)
-		tmp[i++] = '0';
+	if (num < spec.base) {
+		tmp[i++] = (digits[(unsigned)num] | locase);
 	/* Generic code, for any base:
 	else do {
 		tmp[i++] = (digits[do_div(num,base)] | locase);
 	} while (num != 0);
 	*/
-	else if (spec.base != 10) { /* 8 or 16 */
+	} else if (spec.base != 10) { /* 8 or 16 */
 		int mask = spec.base - 1;
 		int shift = 3;
 
@@ -754,7 +863,7 @@ char *ip4_string(char *p, const u8 *addr, const char *fmt)
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

