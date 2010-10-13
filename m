Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0JMVmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 17:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab0JMVmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 17:42:15 -0400
Date: Wed, 13 Oct 2010 23:37:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make div64_u64() precise on 32bit platforms
Message-ID: <20101013213746.GA27248@redhat.com>
References: <201010121227.05735.behlendorf1@llnl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010121227.05735.behlendorf1@llnl.gov>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12, Brian Behlendorf wrote:
>
> I'm resending the patch as is and adding what I hope are the right CCs.  Also
> let me explain why I opted to add abs64() and use the gcc builtin.
>
> >Can't we just improve abs? Say,
>
> I was reluctant to change abs() since it would have a much larger impact on
> the code base.  Using typeof() should be OK but if any of the callers
> mistakenly call abs() with an unsigned value then we could see compiler
> warnings about '__x < 0' being a useless conditional.

I see. Probably in this case we want this warning. But I agree, it is better
to make a separate patch for such a change.

> >This is a bit unusual. I mean, it is not that common to use gcc builtins
> >in the normal code. And, it seems, we can use __fls(divisor >> 32) or
> >just fls64() instead ?
>
> I opted for the gcc builtin because I felt it made the code more readable.  I
> also suspect it will perform slightly better than __fls() on some archs.

Well, compared to div_64() we are going to do, this is nothing. But
I won't argue.


I think the patch is correct. A couple of questions though,

> + * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c'

404

>  u64 div64_u64(u64 dividend, u64 divisor)
>  {
> -	u32 high, d;
> -
> -	high = divisor >> 32;
> -	if (high) {
> -		unsigned int shift = fls(high);
> +	u64 u0, quot0, quot1;
> +	u32 rem;
> +	int n;
> +
> +	if (divisor >> 32 == 0) {
> +		if (dividend >> 32 < divisor) {
> +			return div_u64_rem(dividend, divisor, &rem);
> +		} else {
> +			u0 = dividend & 0xFFFFFFFF;
> +			quot1 = div_u64_rem(dividend >> 32, divisor, &rem);
> +			u0 += ((u64)rem << 32);
> +			quot0 = div_u64_rem(u0, divisor, &rem);
> +			return (quot1 << 32) + quot0;
> +		}

Looks correct... but I can't understand these complications.
Looks like we can just do

	if ((divisor >> 32) == 0) {
		div_u64(dividend, divisor);
	} else {
	...

No?

> +	} else {
> +		n = __builtin_clzll(divisor);
> +		quot1 = div_u64_rem(dividend >> 1, (divisor << n) >> 32, &rem);
> +		quot0 = (quot1 << n) >> 31;

I can't understand this "dividend >> 1". It seems to me that

		quot1 = div_u64(dividend, (divisor << n) >> 32);
		quot0 = (quot1 << n) >> 32;

should be equally correct. Or I missed some overflow?


Anyway this looks correct, but I almost died trying to understand this
code (or, better say, to convince myself I can understand it ;)

Looks like, if we denote

		A = dividend
		B = divisor
		K = 1ull << (32 - n)

then
		quot0 = A / (B - (B % K))

which is obviously >= A/B. All we need is to ensure is that it is
<= A/B + 1, and this seems to be true.

So, I believe the patch is correct.



A bit off-topic,

> 			uu = tabu[i];
> 			vu = tabu[j];
> 			qu = div64_u64(uu, vu);
> 			ru = uu - qu * vu;
> 			if (qu > uu || ru >= vu) {
> 				printk("%016llx/%016llx != %016llx "
> 				   "rem %016llx\n", uu, vu, qu, ru);
> 				errors++;
> 			}

I wouldn't trust this check too much. I mean, it can miss an error.
For example, consider something like

	vu = -1ll
	uu = vu / 2
	qu = 2		// suppose that div64_u64() is very wrong

Afaics, this wrong qu passes the check.

Oleg.

