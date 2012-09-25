Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2IYLo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:44:29 -0400
Received: from science.horizon.com ([71.41.210.146]:65039 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755236Ab2IYLo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:44:26 -0400
Date: 25 Sep 2012 07:44:25 -0400
Message-ID: <20120925114425.15269.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mpn@google.com, vda.linux@googlemail.com
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
Cc: hughd@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <20120924134939.23197.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Denys Vlasenko for sending me his benchmarking code.

I went and hacked on it to ransomize the numbers being converted more,
since repeatedly converting the same number underestimates the number
of branch mispredictions.

Then I tried computing the number of digits beforehand, as mentioned
in my earlier message, and it came out slightly slower.  The code is:

static noinline_for_stack
char *put_dec_trunc8(char *buf, unsigned n)
{
        static unsigned const pow10[9] = { 0, 10, 100, 1000, 10000, 100000,
					 1000000, 10000000, 100000000 };
	unsigned digits = (19 * fls(n) + 6) >> 6;  /* Valid for < 44 bits */
	unsigned t;

	/*
	 * "Digits" is an estimate, always exact or high by 1, of the
	 * number of decimal digits in r.  It is offset by 1, so digits=0
	 * means 1 digit.  Given that the largest value ever passed to
	 * this function has 27 bits, The largest value is (19 * 27 +
	 * 6) >> 6 = 8, meaning 9 digits.  However, that will always be
	 * rounded down because r is less than pow10[8] = 10^8.
	 *
	 * We could use smaller multipliers in cases 4 through 6, but that
	 * would require a shift by less than 32, which is awkward on a
	 * 32-bit processor and wastes more time than the larger multiply.
	 */
	switch (digits - (n < pow10[digits])) {
	default:
		__builtin_unreachable();
	case 7:		/* q <= 99999999 */
		t = n + '0';
		n  = (n * (uint64_t)0x1999999a) >> 32;
		*buf++ = t - 10*n;
	case 6:		/* q <= 9999999 */
		t = n + '0';
		n  = (n * (uint64_t)0x1999999a) >> 32;
		*buf++ = t - 10*n;
	case 5:		/* t <= 999999 */
		t = n + '0';
		n  = (n * (uint64_t)0x1999999a) >> 32;
		*buf++ = t - 10*n;
	case 4:		/* t <= 99999 */
		t = n + '0';
		n  = (n * (uint64_t)0x1999999a) >> 32;
		*buf++ = t - 10*n;
	case 3:		/* t <= 9999 */
		t = n + '0';
		n  = (n * 0x199a) >> 16;
		*buf++ = t - 10*n;
	case 2:		/* t <= 999 */
		t = n + '0';
		n  = (n * 0xcd) >> 11;
		*buf++ = t - 10*n;
	case 1:		/* t <= 99 */
		t = n + '0';
		n  = (n * 0xcd) >> 11;
		*buf++ = t - 10*n;
	case 0:		/* t <= 9 */
		*buf++ = n + '0';
	}
	return buf;
}


But!  With more extensive refactoring of the number() code, computing
the number of digits at the beginning can eliminate the entire business
of formatting into tmp[] and copying backward.  We'll first compute the
number of digits, check for buffer overflow, insert the printf padding,
and then call the number-formatting code, passing the number of digits in.

It seems plausible that the resultant simplification will produce a
speedup.

I'm going to experiment with that.  Denys, since I'm playing in your sandbox,
do you have any violent objections to that?  (Assuming, of course, that it's
a net speed win and my surgery to function signatures isn't too hideous.)
