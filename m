Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895Ab0HFT0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:26:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65157 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab0HFT0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=VGMSyIl2AG/3O5bi6J5nOLcxJvT57g70/SzyNde7BU5sFg4niWh8mB8PRBshJgwCS3
         zgIRsTO5pt8wKI6T2F6bYuuYHHbPV/klCKCgYpQuIXfZIbx8g/qFjrQgnBshJIVxperL
         AG/mRWGNPHgNYhKN4uX+Zq04sqwonafYS17Ao=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: =?utf-8?q?Micha=C5=82_Nazarewicz?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 3/3] lib: vsprintf: added a put_dec() test and benchmark tool
Date: Fri, 6 Aug 2010 21:26:10 +0200
User-Agent: KMail/1.8.2
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com> <201008060710.06304.vda.linux@googlemail.com> <op.vg0csju97p4s8u@pikus>
In-Reply-To: <op.vg0csju97p4s8u@pikus>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_SHGXMOH6EpZIjJ/"
Message-Id: <201008062126.10789.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_SHGXMOH6EpZIjJ/
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 06 August 2010 10:34, Micha=C5=82 Nazarewicz wrote:
> On Fri, 06 Aug 2010 07:10:06 +0200, Denys Vlasenko <vda.linux@googlemail.=
com> wrote:
>=20
> > On Friday 06 August 2010 00:38, Michal Nazarewicz wrote:
> >> This commit adds a test application for the put_dec() and
> >> family of functions that are used by the previous two commits.
> >>
> >> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> >
> >> +put-dec-test: put-dec-test.c
> >> +	exec $(CC) $(CFLAGS) -o $@ $<
> >
> > (1) Why exec?
>=20
> Micro Makefile optimisation -- saves us a fork().
>=20
> I'll try to fix the benchmark over the weekend and will post updated
> version.  Thanks for the comments.

You might find some ideas in the attached file:
* removed "correction" code
* added verification of correctness for put_dec()
* different rand64
  (old one was giving same "random" number surprisingly often)
* more robust coding in a few places

=2D-=20
vda

--Boundary-00=_SHGXMOH6EpZIjJ/
Content-Type: text/x-csrc;
  charset="utf-8";
  name="put-dec-test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="put-dec-test.c"

#define _BSD_SOURCE

#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>


#  define do_div(n, base) ({			\
		uint32_t __base = (base);	\
		uint32_t __rem = (n) % __base;	\
		(n) /= __base;			\
		__rem;				\
	})


/****************************** Original versian ******************************/

static char *orig_put_dec_trunc(char *buf, unsigned q)
{
	unsigned d3, d2, d1, d0;
	d1 = (q>>4) & 0xf;
	d2 = (q>>8) & 0xf;
	d3 = (q>>12);

	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
	q = (d0 * 0xcd) >> 11;
	d0 = d0 - 10*q;
	*buf++ = d0 + '0'; /* least significant digit */
	d1 = q + 9*d3 + 5*d2 + d1;
	if (d1 != 0) {
		q = (d1 * 0xcd) >> 11;
		d1 = d1 - 10*q;
		*buf++ = d1 + '0'; /* next digit */

		d2 = q + 2*d2;
		if ((d2 != 0) || (d3 != 0)) {
			q = (d2 * 0xd) >> 7;
			d2 = d2 - 10*q;
			*buf++ = d2 + '0'; /* next digit */

			d3 = q + 4*d3;
			if (d3 != 0) {
				q = (d3 * 0xcd) >> 11;
				d3 = d3 - 10*q;
				*buf++ = d3 + '0';  /* next digit */
				if (q != 0)
					*buf++ = q + '0'; /* most sign. digit */
			}
		}
	}

	return buf;
}
/* Same with if's removed. Always emits five digits */
static char *orig_put_dec_full(char *buf, unsigned q)
{
	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
	/* but anyway, gcc produces better code with full-sized ints */
	unsigned d3, d2, d1, d0;
	d1 = (q>>4) & 0xf;
	d2 = (q>>8) & 0xf;
	d3 = (q>>12);

	/*
	 * Possible ways to approx. divide by 10
	 * gcc -O2 replaces multiply with shifts and adds
	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
	 * (x * 0x67) >> 10:  1100111
	 * (x * 0x34) >> 9:    110100 - same
	 * (x * 0x1a) >> 8:     11010 - same
	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
	 */
	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
	q = (d0 * 0xcd) >> 11;
	d0 = d0 - 10*q;
	*buf++ = d0 + '0';
	d1 = q + 9*d3 + 5*d2 + d1;
		q = (d1 * 0xcd) >> 11;
		d1 = d1 - 10*q;
		*buf++ = d1 + '0';

		d2 = q + 2*d2;
			q = (d2 * 0xd) >> 7;
			d2 = d2 - 10*q;
			*buf++ = d2 + '0';

			d3 = q + 4*d3;
				q = (d3 * 0xcd) >> 11; /* - shorter code */
				/* q = (d3 * 0x67) >> 10; - would also work */
				d3 = d3 - 10*q;
				*buf++ = d3 + '0';
					*buf++ = q + '0';

	return buf;
}

static __attribute__((noinline))
char *orig_put_dec(char *buf, unsigned long long num)
{
	while (1) {
		unsigned rem;
		if (num < 100000)
			return orig_put_dec_trunc(buf, num);
		rem = do_div(num, 100000);
		buf = orig_put_dec_full(buf, rem);
	}
}



/****************************** Modified versions ******************************/

/*
 * Decimal conversion is by far the most typical, and is used for
 * /proc and /sys data. This directly impacts e.g. top performance
 * with many processes running.
 *
 * We optimize it for speed using ideas described at
 * <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
 *
 * '(num * 0xcccd) >> 19' is an approximation of 'num / 10' that gives
 * correct results for num < 81920.  Because of this, we check at the
 * beginning if we are dealing with a number that may cause trouble
 * and if so, we make it smaller.
 *
 * (As a minor note, all operands are always 16 bit so this function
 * should work well on hardware that cannot multiply 32 bit numbers).
 *
 * (Previous a code based on
 * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html> was used here,
 * with permission from the author, Douglas W. Jones.)
 *
 * Other, possible ways to approx. divide by 10
 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
 * (x * 0x67) >> 10:  1100111
 * (x * 0x34) >> 9:    110100 - same
 * (x * 0x1a) >> 8:     11010 - same
 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
 */
static char *mod3_put_dec_full(char *buf, unsigned q)
{
	unsigned r;
	char a = '0';

	if (q > 0xffff) {
		a = '6';
		q -= 60000;
	}

	r   = (q * 0xcccd) >> 19;
	*buf++ = (q - 10 * r) + '0';

	q   = (r * 0x199a) >> 16;
	*buf++ = (r - 10 * q)  + '0';

	r   = (q * 0xcd) >> 11;
	*buf++ = (q - 10 * r)  + '0';

	q   = (r * 0xd) >> 7;
	*buf++ = (r - 10 * q) + '0';

	*buf++ = q + a;

	return buf;
}

static char *mod3_put_dec_trunc(char *buf, unsigned q)
{
	unsigned r;

	/*
	 * We need to check if num is < 81920 so we might as well
	 * check if we can just call the _full version of this
	 * function.
	 */
	if (q > 9999)
		return mod3_put_dec_full(buf, q);

	r   = (q * 0xcccd) >> 19;
	*buf++ = (q - 10 * r) + '0';

	if (r) {
		q   = (r * 0x199a) >> 16;
		*buf++ = (r - 10 * q)  + '0';

		if (q) {
			r   = (q * 0xcd) >> 11;
			*buf++ = (q - 10 * r)  + '0';

			if (r)
				*buf++ = r + '0';
		}
	}

	return buf;
}

static __attribute__((noinline))
char *mod3_put_dec(char *buf, unsigned long long num)
{
	while (1) {
		unsigned rem;
		if (num < 100000)
			return mod3_put_dec_trunc(buf, num);
		rem = do_div(num, 100000);
		buf = mod3_put_dec_full(buf, rem);
	}
}

/****************************** Main ******************************/

static unsigned long long rand_64(void)
{
	unsigned long long v = 0;
	int i;

	for (i = 0; i < sizeof(v); i++) {
		v += rand();
		v <<= 9;
	}
	return v;
}

static char buf1[sizeof(long long)*3];

static void reverse_buf1(char *b)
{
	char *a = buf1;
	*b-- = '\0';
	while (a < b) {
		char tmp = *a;
		*a = *b;
		*b = tmp;
		++a;
		--b;
	}
}

static int test(const char *name, char *b, char *fmt, ...)
{
	static char buf2[sizeof(long long)*3];
	va_list ap;

	reverse_buf1(b);

	va_start(ap, fmt);
	vsprintf(buf2, fmt, ap);
	va_end(ap);

	if (strcmp(buf1, buf2)) {
		fprintf(stderr, "%-20s: expecting '%s' got '%s'\n",
			name, buf2, buf1);
		return 1;
	}
	return 0;
}

static void stop(const char *name, struct timeval *start)
{
	struct timeval stop;

	gettimeofday(&stop, NULL);

	stop.tv_sec -= start->tv_sec;
	if (stop.tv_usec < start->tv_usec) {
		--stop.tv_sec;
		stop.tv_usec += 1000000;
	}
	stop.tv_usec -= start->tv_usec;

	printf("%-20s: %3d.%06ds\n", name, (int)stop.tv_sec, (int)stop.tv_usec);
	fflush(NULL);
}

#define FUNC(func, outer, inner, format, value) do {	\
		struct timeval start;					\
		unsigned i, o;						\
		for (i = (inner); i--; ) {				\
			typeof(value) v = (value);			\
			memset(buf1, 77, sizeof(buf1));			\
			ret |= test(#func, func(buf1, v), format, v);	\
		}							\
									\
		gettimeofday(&start, NULL);				\
		for (o = (outer); o; --o)				\
			for (i = (inner); i--; )			\
				func(buf1, (value));			\
		stop(#func, &start);					\
	} while (0)							\


int main(int argc, char **argv)
{
	int ret = 0;
	unsigned long iterations;
	unsigned long long ll;
	unsigned long long range;

	srand(time(NULL));

	iterations = 1000;
	if (argc > 1)
		iterations = atoi(argv[1]);

	printf("Benchmark with %ld iterations:\n", iterations*100000);
	printf("\tput_dec_full(99999..0)\n");
	fflush(NULL);
	/* func, bench_mult x test_iter, correction, fmt, val */
	FUNC(orig_put_dec_full, iterations, 100000, "%05u", i);
	FUNC(mod3_put_dec_full, iterations, 100000, "%05u", i);

	printf("\tput_dec_trunc(99999..0)\n");
	fflush(NULL);
	FUNC(orig_put_dec_trunc, iterations, 100000, "%u", i);
	FUNC(mod3_put_dec_trunc, iterations, 100000, "%u", i);

	ll = rand_64();
	printf("\tput_dec(%llu)\n", ll);
	fflush(NULL);
	FUNC(orig_put_dec, iterations, 100000, "%llu", ll);
	FUNC(mod3_put_dec, iterations, 100000, "%llu", ll);

	/* Test wide consecutive ranges at both ends of [0,max] interval */
	range = 10*1000*1000;
	if (argc > 2)
		range = atoi(argv[2]);
	ll = -1LL - range;
	while (ll != range) {
		char buf[sizeof(long long)*3];

		sprintf(buf, "%llu", ll);
		if (!(ll & 0xffff)) {
			printf("Testing correctness: %s%*s\r", buf, (int)(sizeof(long long) * 4), "");
			fflush(NULL);
		}
		memset(buf1, 77, sizeof(buf1));
		reverse_buf1(orig_put_dec(buf1, ll));
		if (strcmp(buf, buf1) == 0) {
			memset(buf1, 77, sizeof(buf1));
			reverse_buf1(mod3_put_dec(buf1, ll));
			if (strcmp(buf, buf1) == 0) {
				ll++;
				continue;
			}
		}
		printf("error at %llu: bad:'%s' expected:'%s'\n", ll, buf1, buf);
		return 1;
	}
	printf("\n");

	printf("\n>> Size of the functions:\n");
	setenv("APP", *argv, 1);
	printf("\tobjdump -t \"$APP\" | grep -F _put_dec | cut -f 2-\n");
	fflush(NULL);
	system("objdump -t \"$APP\" | grep -F _put_dec | cut -f 2-");

	return ret;
}

--Boundary-00=_SHGXMOH6EpZIjJ/--
