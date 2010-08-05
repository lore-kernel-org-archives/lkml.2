Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588Ab0HEWjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:39:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58483 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577Ab0HEWir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WHjS9IaAk5RSPwVmmSJOjFtTJcXXpBhLTiBFBFkB18MnbHRE0//79F782oSPAYsdyM
         Hybe4rfB1ZpunFtqZ5Xa1iMBAYPohY7k4kIZ1MOUOse0E39OXJKPVSYDIA5DxIG2y0wq
         qTDX6bPPNPFXv/DzigdDaVWsNIyg5Wk99Emdw=
From: Michal Nazarewicz <mina86@mina86.com>
To: linux-kernel@vger.kernel.org
Cc: m.nazarewicz@samsung.com, Michal Nazarewicz <mina86@mina86.com>,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Denis Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] lib: vsprintf: added a put_dec() test and benchmark tool
Date: Fri,  6 Aug 2010 00:38:23 +0200
Message-Id: <b3cd8c92d68f3ca7104be13841f1f66f7db9f7e1.1280872240.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <0543dae0f66ba8e0ce42ce3adf1fe31704eb240d.1280872240.git.mina86@mina86.com>
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com> <0543dae0f66ba8e0ce42ce3adf1fe31704eb240d.1280872240.git.mina86@mina86.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds a test application for the put_dec() and
family of functions that are used by the previous two commits.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 tools/put-dec/Makefile       |    8 +
 tools/put-dec/put-dec-test.c |  725 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 733 insertions(+), 0 deletions(-)
 create mode 100644 tools/put-dec/Makefile
 create mode 100644 tools/put-dec/put-dec-test.c

This is just a benchmark I've used to test various implementations of
the put_dec() and friends.  This is not intended as a patch included
in the kernel -- it's merely a tool for anyone who'd like to check
various versions.

diff --git a/tools/put-dec/Makefile b/tools/put-dec/Makefile
new file mode 100644
index 0000000..a56e3ef
--- /dev/null
+++ b/tools/put-dec/Makefile
@@ -0,0 +1,7 @@
+CFLAGS := -O2
+
+put-dec-test: put-dec-test.c
+	exec $(CC) $(CFLAGS) -o $@ $<
+
+clean:
+	rm -f -- put-dec-test
diff --git a/tools/put-dec/put-dec-test.c b/tools/put-dec/put-dec-test.c
new file mode 100644
index 0000000..b43cf08
--- /dev/null
+++ b/tools/put-dec/put-dec-test.c
@@ -0,0 +1,725 @@
+#define _BSD_SOURCE
+
+#include <stdarg.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/time.h>
+#include <time.h>
+
+
+#  define do_div(n, base) ({			\
+		uint32_t __base = (base);	\
+		uint32_t __rem = (n) % __base;	\
+		(n) /= __base;			\
+		__rem;				\
+	})
+
+
+/****************************** Original versian ******************************/
+
+static char *orig_put_dec_trunc(char *buf, unsigned q)
+{
+	unsigned d3, d2, d1, d0;
+	d1 = (q>>4) & 0xf;
+	d2 = (q>>8) & 0xf;
+	d3 = (q>>12);
+
+	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
+	q = (d0 * 0xcd) >> 11;
+	d0 = d0 - 10*q;
+	*buf++ = d0 + '0'; /* least significant digit */
+	d1 = q + 9*d3 + 5*d2 + d1;
+	if (d1 != 0) {
+		q = (d1 * 0xcd) >> 11;
+		d1 = d1 - 10*q;
+		*buf++ = d1 + '0'; /* next digit */
+
+		d2 = q + 2*d2;
+		if ((d2 != 0) || (d3 != 0)) {
+			q = (d2 * 0xd) >> 7;
+			d2 = d2 - 10*q;
+			*buf++ = d2 + '0'; /* next digit */
+
+			d3 = q + 4*d3;
+			if (d3 != 0) {
+				q = (d3 * 0xcd) >> 11;
+				d3 = d3 - 10*q;
+				*buf++ = d3 + '0';  /* next digit */
+				if (q != 0)
+					*buf++ = q + '0'; /* most sign. digit */
+			}
+		}
+	}
+
+	return buf;
+}
+/* Same with if's removed. Always emits five digits */
+static char *orig_put_dec_full(char *buf, unsigned q)
+{
+	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
+	/* but anyway, gcc produces better code with full-sized ints */
+	unsigned d3, d2, d1, d0;
+	d1 = (q>>4) & 0xf;
+	d2 = (q>>8) & 0xf;
+	d3 = (q>>12);
+
+	/*
+	 * Possible ways to approx. divide by 10
+	 * gcc -O2 replaces multiply with shifts and adds
+	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+	 * (x * 0x67) >> 10:  1100111
+	 * (x * 0x34) >> 9:    110100 - same
+	 * (x * 0x1a) >> 8:     11010 - same
+	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+	 */
+	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
+	q = (d0 * 0xcd) >> 11;
+	d0 = d0 - 10*q;
+	*buf++ = d0 + '0';
+	d1 = q + 9*d3 + 5*d2 + d1;
+		q = (d1 * 0xcd) >> 11;
+		d1 = d1 - 10*q;
+		*buf++ = d1 + '0';
+
+		d2 = q + 2*d2;
+			q = (d2 * 0xd) >> 7;
+			d2 = d2 - 10*q;
+			*buf++ = d2 + '0';
+
+			d3 = q + 4*d3;
+				q = (d3 * 0xcd) >> 11; /* - shorter code */
+				/* q = (d3 * 0x67) >> 10; - would also work */
+				d3 = d3 - 10*q;
+				*buf++ = d3 + '0';
+					*buf++ = q + '0';
+
+	return buf;
+}
+
+static __attribute__((noinline))
+char *orig_put_dec(char *buf, unsigned long long num)
+{
+	while (1) {
+		unsigned rem;
+		if (num < 100000)
+			return orig_put_dec_trunc(buf, num);
+		rem = do_div(num, 100000);
+		buf = orig_put_dec_full(buf, rem);
+	}
+}
+
+
+
+/****************************** Modified versions ******************************/
+
+/*
+ * Decimal conversion is by far the most typical, and is used for
+ * /proc and /sys data. This directly impacts e.g. top performance
+ * with many processes running.
+ *
+ * We optimize it for speed using code based on idea described at:
+ * http://www.cs.uiowa.edu/~jones/bcd/decimal.html (with permission
+ * from the author, Douglas W. Jones).
+ *
+ * The original code was designed for 8-bit ALus but since we can
+ * assume more capable hardware the code has been rewritten to use the
+ * following properties:
+ *
+ * n  =    1 * n0 +                   ( 0 <= n0 <= 1023 )
+ *      1024 * n1                     ( 0 <= n1 <=   97 )
+ * a0 = 0         + 4 * n1 + 1 * n0   ( 0 <= a0 <= 1412 )
+ * a1 = (a0 / 10) + 2 * n1            ( 0 <= a1 <=  335 )
+ * a2 = (a1 / 10) + 0 * n1            ( 0 <= a2 <=   33 )
+ * a3 = (a2 / 10) + 1 * n1            ( 0 <= a3 <=  100 )
+ * d0 = a0 % 10
+ * d1 = a1 % 10
+ * d2 = a2 % 10
+ * d3 = a3 % 10
+ * d4 = a3 / 10
+ *
+ * So instead of dividing the number into four nibles we divide it
+ * into two numbers: first one 10-bit and the other one 7-bit
+ * (argument is 17-bit number from 0 to 99999).
+ *
+ * Moreover, 1024, which is the value second part of the number needs
+ * to be multiplied by, has nice property that each digit is a power
+ * of two or zero -- this helps with multiplications.
+ *
+ * Possible ways to approx. divide by 10
+ * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+ * (x * 0x67) >> 10:  1100111
+ * (x * 0x34) >> 9:    110100 - same
+ * (x * 0x1a) >> 8:     11010 - same
+ * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+ */
+static char *mod1_put_dec_full(char *buf, unsigned q)
+{
+	unsigned p, r;
+	p   = q >> 10;
+
+	q  &= 0x3ff;
+	q  += 4 * p;
+	r   = (q * 0x199A) >> 16;
+	*buf++ = (q - 10 * r) + '0';
+
+	r  += 2 * p;
+	q   = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q)  + '0';
+
+	/* q += 0; */
+	r   = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+
+	r  += p;
+	q   = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q) + '0';
+
+	*buf++ = q + '0';
+
+	return buf;
+}
+
+static char *mod1_put_dec_trunc(char *buf, unsigned q)
+{
+	unsigned p, r;
+	p   = q >> 10;
+
+	q  &= 0x3ff;
+	q  += 4 * p;
+	r   = (q * 0x199a) >> 16;
+	*buf++ = (q - 10 * r) + '0';
+
+	r  += 2 * p;
+	if (r) {
+		q   = (r * 0xcd) >> 11;
+		*buf++ = (r - 10 * q)  + '0';
+
+		/* q += 0; */
+		if (q || p) {
+			r   = (q * 0xcd) >> 11;
+			*buf++ = (q - 10 * r)  + '0';
+
+			r  += p;
+			if (r) {
+				q   = (r * 0xcd) >> 11;
+				*buf++ = (r - 10 * q) + '0';
+
+				if (q)
+					*buf++ = q + '0';
+			}
+		}
+	}
+
+	return buf;
+}
+
+
+static __attribute__((noinline))
+char *mod1_put_dec(char *buf, unsigned long long num)
+{
+	while (1) {
+		unsigned rem;
+		if (num < 100000)
+			return mod1_put_dec_trunc(buf, num);
+		rem = do_div(num, 100000);
+		buf = mod1_put_dec_full(buf, rem);
+	}
+}
+
+
+static __attribute__((noinline))
+char *mod2_put_dec(char *buf, unsigned long long num)
+{
+	if (!num) {
+		*buf++ = '0';
+		return buf;
+	}
+
+	while (num >= 100000) {
+		unsigned rem;
+		rem = do_div(num, 100000);
+		buf = mod1_put_dec_full(buf, rem);
+	}
+
+	buf = mod1_put_dec_full(buf, num);
+	while (buf[-1] == '0')
+		--buf;
+	return buf;
+}
+
+
+
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
+static char *mod3_put_dec_full(char *buf, unsigned q)
+{
+	unsigned r;
+	char a = '0';
+
+	if (q > 0xffff) {
+		a = '6';
+		q -= 60000;
+	}
+
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
+	return buf;
+}
+
+static char *mod3_put_dec_trunc(char *buf, unsigned q)
+{
+	unsigned r;
+
+	/*
+	 * We need to check if num is < 81920 so we might as well
+	 * check if we can just call the _full version of this
+	 * function.
+	 */
+	if (q > 9999)
+		return mod3_put_dec_full(buf, q);
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
+
+	return buf;
+}
+
+
+static char *mod3_put_dec_8bit(char *buf, unsigned q)
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
+
+static __attribute__((noinline))
+char *mod3_put_dec(char *buf, unsigned long long num)
+{
+	while (1) {
+		unsigned rem;
+		if (num < 100000)
+			return mod3_put_dec_trunc(buf, num);
+		rem = do_div(num, 100000);
+		buf = mod3_put_dec_full(buf, rem);
+	}
+}
+
+
+static __attribute__((noinline))
+char *mod4_put_dec(char *buf, unsigned long long num)
+{
+	if (!num) {
+		*buf++ = '0';
+		return buf;
+	}
+
+	while (num >= 100000) {
+		unsigned rem;
+		rem = do_div(num, 100000);
+		buf = mod3_put_dec_full(buf, rem);
+	}
+
+	buf = mod3_put_dec_full(buf, num);
+	while (buf[-1] == '0')
+		--buf;
+	return buf;
+}
+
+
+
+/*
+ * Decimal conversion is by far the most typical, and is used for
+ * /proc and /sys data. This directly impacts e.g. top performance
+ * with many processes running.
+ *
+ * We optimize it for speed using ideas described at
+ * <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
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
+static char *mod5_put_dec_full(char *buf, unsigned q)
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
+static char *mod5_put_dec_trunc(char *buf, unsigned q)
+{
+	unsigned r;
+
+	r      = (q * 0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
+
+	if (r) {
+		q      = (r * 0x199a) >> 16;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q) {
+			r      = (q * 0xcd) >> 11;
+			*buf++ = (q - 10 * r)  + '0';
+
+			if (r)
+				*buf++ = r + '0';
+		}
+	}
+
+	return buf;
+}
+
+
+static __attribute__((noinline))
+char *mod5_put_dec(char *buf, unsigned long long num)
+{
+	while (1) {
+		unsigned rem;
+		if (num < 10000)
+			return mod5_put_dec_trunc(buf, num);
+		rem = do_div(num, 10000);
+		buf = mod5_put_dec_full(buf, rem);
+	}
+}
+
+/*
+ * Based on code by Douglas W. Jones found at
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html>.
+ */
+static __attribute__((noinline))
+char *mod6_put_dec(char *buf, unsigned long long n)
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
+	buf = mod5_put_dec_full(buf, q % 10000);
+	q   = q / 10000;
+
+	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
+		buf = mod5_put_dec_full(buf, d1 % 10000);
+		q   = d1 / 10000;
+
+		d2  = q + 4749 * d3 + 42 * d2;
+			buf = mod5_put_dec_full(buf, d2 % 10000);
+			q   = d2 / 10000;
+
+			d3  = q + 281 * d3;
+				buf = mod5_put_dec_full(buf, d3 % 10000);
+				q   = d3 / 10000;
+
+					buf = mod5_put_dec_trunc(buf, q);
+
+	while (buf[-1] == '0')
+		--buf;
+
+	return buf;
+}
+
+
+/*
+ * Based on code by Douglas W. Jones found at
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html>.
+ */
+static __attribute__((noinline))
+char *mod7_put_dec(char *buf, unsigned long long n)
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
+	buf = mod5_put_dec_full(buf, q % 10000);
+	q   = q / 10000;
+
+	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
+	if (d1) {
+		buf = mod5_put_dec_full(buf, d1 % 10000);
+		q   = d1 / 10000;
+
+		d2  = q + 4749 * d3 + 42 * d2;
+		if (d2) {
+			buf = mod5_put_dec_full(buf, d2 % 10000);
+			q   = d2 / 10000;
+
+			d3  = q + 281 * d3;
+			if (d3) {
+				buf = mod5_put_dec_full(buf, d3 % 10000);
+				q   = d3 / 10000;
+
+				if (q)
+					buf = mod5_put_dec_trunc(buf, q);
+			}
+		}
+	}
+
+	while (buf[-1] == '0')
+		--buf;
+
+	return buf;
+}
+
+
+static __attribute__((noinline))
+char *mod8_put_dec(char *buf, unsigned long long num)
+{
+	while (1) {
+		unsigned rem = do_div(num, 100000000);
+
+		if (!num && rem < 10000)
+			return mod5_put_dec_trunc(buf, rem);
+		buf = mod5_put_dec_full(buf, rem % 10000);
+
+		if (!num)
+			return mod5_put_dec_trunc(buf, rem / 10000);
+		buf = mod5_put_dec_full(buf, rem / 10000);
+	}
+}
+
+
+
+/****************************** Main ******************************/
+
+static uint64_t rand_64(void)
+{
+	uint64_t v = 0, m = 1;
+	for (;;) {
+		uint64_t n;
+		v = m * rand();
+		n = m + m * RAND_MAX;
+		if (n < m)
+			break;
+		m = n;
+	}
+	return v;
+}
+
+
+static char buf1[24];
+
+static int test(const char *name, char *b, char *fmt, ...)
+{
+	static char buf2[24];
+	char *a = buf1;
+	va_list ap;
+
+	*b-- = '\0';
+	while (a < b) {
+		char tmp = *a;
+		*a = *b;
+		*b = tmp;
+		++a;
+		--b;
+	}
+
+	va_start(ap, fmt);
+	vsprintf(buf2, fmt, ap);
+	va_end(ap);
+
+	if (strcmp(buf1, buf2)) {
+		fprintf(stderr, "%-20s: expecting %20s got %20s\n",
+			name, buf2, buf1);
+		return 1;
+	}
+	return 0;
+}
+
+static void stop(const char *name, struct timeval *start, struct timeval *correction)
+{
+	struct timeval stop, *a;
+	gettimeofday(&stop, NULL);
+
+	a = start;
+	do {
+		stop.tv_sec -= a->tv_sec;
+		if (stop.tv_usec < a->tv_usec) {
+			--stop.tv_sec;
+			stop.tv_usec += 1000000;
+		}
+		stop.tv_usec -= a->tv_usec;
+
+		a = correction;
+		correction = NULL;
+	} while (a);
+
+	if (name) {
+		fflush(NULL);
+		printf("%-20s: %3d.%06ds\n", name, stop.tv_sec, stop.tv_usec);
+	} else {
+		*start = stop;
+	}
+}
+
+#define FUNC(func, outer, inner, correction, format, value) do {	\
+		struct timeval start;					\
+		unsigned i, o;						\
+		for (i = (inner); i--; ) {				\
+			typeof(value) v = (value);			\
+			ret |= test(#func, func(buf1, v), format, v);	\
+		}							\
+									\
+		gettimeofday(&start, NULL);				\
+		for (o = (outer); o; --o)				\
+			for (i = (inner); i--; )			\
+				func(buf1, (value));			\
+		stop(#func, &start, correction);			\
+	} while (0)							\
+
+
+int main(int argc, char **argv) {
+	unsigned long iterations = 1000, i;
+	struct timeval correction;
+	int ret = 0;
+
+	srand(time(NULL));
+
+	if (argc > 1)
+		iterations = atoi(argv[1]);
+
+	gettimeofday(&correction, NULL);
+	for (i = 25000 * iterations; i; --i)
+		rand_64();
+	stop(NULL, &correction, NULL);
+
+
+	puts(">> Benchmarks:\n\tput_dec_full()");
+	fflush(NULL);
+
+	FUNC(orig_put_dec_full, iterations, 100000, NULL, "%05u", i);
+	FUNC(mod1_put_dec_full, iterations, 100000, NULL, "%05u", i);
+	FUNC(mod3_put_dec_full, iterations, 100000, NULL, "%05u", i);
+	FUNC(mod5_put_dec_full, iterations * 10, 10000, NULL, "%04u", i);
+
+	puts("\tput_dec_trunc()");
+	fflush(NULL);
+
+	FUNC(orig_put_dec_trunc, iterations, 100000, NULL, "%u", i);
+	FUNC(mod1_put_dec_trunc, iterations, 100000, NULL, "%u", i);
+	FUNC(mod3_put_dec_trunc, iterations, 100000, NULL, "%u", i);
+	FUNC(mod5_put_dec_trunc, iterations * 10, 10000, NULL, "%u", i);
+	FUNC(mod3_put_dec_8bit, iterations * 500, 256, NULL, "%u", i);
+
+	puts("\n\tput_dec()");
+	fflush(NULL);
+
+	FUNC(orig_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
+	FUNC(mod1_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
+	FUNC(mod2_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
+	FUNC(mod3_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
+	FUNC(mod4_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
+	FUNC(mod5_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
+	FUNC(mod6_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
+	FUNC(mod7_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
+	FUNC(mod8_put_dec, iterations / 4, 100000, &correction, "%llu", rand_64());
+
+
+	fflush(NULL);
+	puts("\n>> Size of the functions:");
+	fflush(NULL);
+
+	setenv("APP", *argv, 1);
+	puts("\tobjdump -t \"$APP\" | grep -F _put_dec | cut -f 2-");
+	system("objdump -t \"$APP\" | grep -F _put_dec | cut -f 2-");
+
+
+	return ret;
+}
-- 
1.7.1

