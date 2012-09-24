Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2IXNtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:49:41 -0400
Received: from science.horizon.com ([71.41.210.146]:59536 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754196Ab2IXNtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:49:40 -0400
Date: 24 Sep 2012 09:49:39 -0400
Message-ID: <20120924134939.23197.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mpn@google.com, vda.linux@googlemail.com
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
Cc: hughd@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <xa1tipb3d2nv.fsf@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Nazarewicz <mpn@google.com> wrote:
> The original has it a bit awkwardly because it just copies code from
> put_dec_full9() with the first iteration skipped.

Yeah, it also makes the comments pretty confusing.

> I guess the following should work, even though it's not so pretty:
> 
> static noinline_for_stack
> char *put_dec_trunc8(char *buf, unsigned r) {
> 	unsigned q;
> 
> 	if (r > 10000) {
> 		do {
> 			q = r + '0';
> 			r = (r * (uint64_t)0x1999999a) >> 32;
> 			*buf++ = q - 10 * r;
> 		} while (r >= 10000);
> 		if (r == 0)
> 			return buf;
> 	}
> 
> 	q      = (r * 0x199a) >> 16;
> 	*buf++ = (r - 10 * q)  + '0'; /* 6 */
> 	if (q == 0)
> 		return buf;
> 	r      = (q * 0xcd) >> 11;
> 	*buf++ = (q - 10 * r)  + '0'; /* 7 */
> 	if (r == 0)
> 		return buf;
> 	q      = (r * 0xcd) >> 11;
> 	*buf++ = (r - 10 * q) + '0'; /* 8 */
> 	if (q == 0)
> 		return buf;
> 	*buf++ = q + '0'; /* 9 */
> 	return buf;
> }

Two bugs:

1) The initial "(r > 10000)" should be >=.
   If you let r == 10000 through to the remaining code, you'll get ":000".

2) The "r == 0" test isn't necessary.
   Given that the loop divides r by 10 each time, r >= 10000 at the
   beginning implies r >= 1000 at the end, so 1000 <= r < 10000
   when the loop exits.

   The only place you might need a test is if the "r >= 10000"
   test is *false*.  I.e.

	if (r > 10000) {
		/* Code */
	} else if (r == 0)
		return buf;

(But I think that last test is the bug I need to track down.)


You could reduce the number of conditional branches by using a binary
search tree for the number of digits to jump into an unrolled loop,
in the style of Duff's device, but I wasn't sure the complexity
was worth it.  And the q/r swapping makes it even messier.

Basically something like this, except I'd also probably change the
variable names, and modify the calling convention to return the decimal
in big-endian order:

char *put_dec_trunc8(char *buf, unsigned r)
{
	unsigned q;

	if (r < 10000)
		if (r < 100)
			if (r < 10)
				goto d1;
			else
				goto d2;
		else
			if (r < 1000)
				goto d3;
			else
				goto d4;
	else
		if (r < 1000000)
			if (r < 100000)
				goto d5;
			else
				goto d6;
		else
			if (r < 10000000)
				goto d7;
			else
				goto d8;
d8:
	q = r + '0';
	r = (r * (uint64_t)0x1999999a) >> 32;
	*buf++ = q - 10 * r;
d7:
	q = r + '0';
	r = (r * (uint64_t)0x1999999a) >> 32;
	*buf++ = q - 10 * r;
d6:
	q = r + '0';
	r = (r * (uint64_t)0x1999999a) >> 32;
	*buf++ = q - 10 * r;
d5:
	q = r + '0';
	r = (r * (uint64_t)0x1999999a) >> 32;
	*buf++ = q - 10 * r;
d4:
	q = r + '0';
	r = (r * 0x199a) >> 16;
	*buf++ = q - 10 * r;
d3:
	q = r + '0';
	r = (r * 0xcd) >> 11;
	*buf++ = q - 10 * r;
d2:
	q = r + '0';
	r = (r * 0xcd) >> 11;
	*buf++ = q - 10 * r;
d1:
	*buf++ = r + '0';
	return buf;
}

Another possibility would be to count the bits in r, convert that to
an estimate of the number of digits, and do one test to see which side
of the appropriate threshold it lines on.

Here are the ambiguous cases:
Bits	Digits
4	1 (8) or 2 (15)
7	2 (64) or 3 (127)
10	3 (512) or 4 (1023)
14	4 (8192) or 5 (16383)
17	5 (65536) or 6 (131071)
20	6 (524288) 7 (1048575)
24	7 (8388608) or 8 (16777215)
27	8 (67108864) or 9(134217727)

So, for this range, we have
(3*bits+8)/10 <= digits <= (3*bits+10)/10.
Does that get us anywhere?

Actually, those formulae are good for up to 105 bits!
I bet there's a simpler version with a power-of-2
divisor that's good enough for this range.

Some initial guesses
f1(bits) = (19 * bits + 51)/64 (valid for bits < 45)
f2(bits) = (19 * bits + 70)/64 (valid for bits < 44)

I couldn't make it work with a quotient of 32.

Then it would be either:

{
	static unsigned const pow10[] = { 1, 10, 100, 1000, 10000, ... };
	unsigned bits = sigbits(r);
	unsigned digits = f1(bits);
	unsigned digits_high = f2(bits);

	digits += digits_high != digits && r >= pow10[digits_high];

	switch (digits) {
	case 8:
	case 7:
		...
	case 1:
		*buf++ = r + '0';
	}
	return buf;
}

or the possibly simpler:
{
	static unsigned const pow10[] = { 1, 10, 100, 1000, 10000, ... };
	unsigned bits = sigbits(r);
	unsigned digits = f2(bits);	/* This is the high estimate! */

	switch (digits - (r < pow1[digits])) {
	case 8:
	case 7:
		...
	case 1:
		*buf++ = r + '0';
	}
	return buf;
}

I'll play with that; thanks for the inspiration!
