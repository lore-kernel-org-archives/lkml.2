Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0JNMQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:16:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab0JNMQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:16:30 -0400
Date: Thu, 14 Oct 2010 14:11:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make div64_u64() precise on 32bit platforms
Message-ID: <20101014121159.GA407@redhat.com>
References: <201010121227.05735.behlendorf1@llnl.gov> <20101013213746.GA27248@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013213746.GA27248@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13, Oleg Nesterov wrote:
>
> On 10/12, Brian Behlendorf wrote:
> >
> >  u64 div64_u64(u64 dividend, u64 divisor)
> >  {
> > -	u32 high, d;
> > -
> > -	high = divisor >> 32;
> > -	if (high) {
> > -		unsigned int shift = fls(high);
> > +	u64 u0, quot0, quot1;
> > +	u32 rem;
> > +	int n;
> > +
> > +	if (divisor >> 32 == 0) {
> > +		if (dividend >> 32 < divisor) {
> > +			return div_u64_rem(dividend, divisor, &rem);
> > +		} else {
> > +			u0 = dividend & 0xFFFFFFFF;
> > +			quot1 = div_u64_rem(dividend >> 32, divisor, &rem);
> > +			u0 += ((u64)rem << 32);
> > +			quot0 = div_u64_rem(u0, divisor, &rem);
> > +			return (quot1 << 32) + quot0;
> > +		}
>
> Looks correct... but I can't understand these complications.
> Looks like we can just do
>
> 	if ((divisor >> 32) == 0) {
> 		div_u64(dividend, divisor);
> 	} else {
> 	...
>
> No?
>
> > +	} else {
> > +		n = __builtin_clzll(divisor);
> > +		quot1 = div_u64_rem(dividend >> 1, (divisor << n) >> 32, &rem);
> > +		quot0 = (quot1 << n) >> 31;
>
> I can't understand this "dividend >> 1". It seems to me that
>
> 		quot1 = div_u64(dividend, (divisor << n) >> 32);
> 		quot0 = (quot1 << n) >> 32;
>
> should be equally correct. Or I missed some overflow?

Thinking more about this with a fresh head, we don't event need quot1,
unless I missed something. We can do

		quot0 = div_u64((dividend << n) >> 32, (divisor << n) >> 32);

instead. Or, better,

		n = 32 - __builtin_clzll(divisor);
		quot0 = div_u64(dividend >> n, divisor >> n);

And 32 - clzll == fls.

So, I think it can be really trivial, see the test-case below,
seems to work (you need 64bit machine to test).

What do you think? I do not trust my math skills.

Oleg.

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/fcntl.h>
#include <assert.h>

typedef unsigned long long u64;
typedef unsigned long u32;

static inline u64 div_u64(u64 A, u32 B)
{
	return A / B;
}

static inline unsigned long __fls(unsigned long word)
{
	asm("bsr %1,%0"
	    : "=r" (word)
	    : "rm" (word));
	return word;
}

u64 div64_u64(u64 A, u64 B)
{
	u32 high = B >> 32;
	u64 quot;

	if (high == 0) {
		quot = div_u64(A, B);
	} else {
		int n = 1 + __fls(high);
		quot = div_u64(A >> n, B >> n);

		if (quot != 0)
			quot--;
		if ((A - quot * B) >= B)
			quot++;
	}

	return quot;
}

int main(void)
{
	int fd, n;

	fd = open("/dev/urandom", O_RDONLY);
	assert(fd >= 0);

	for (n = 1;; ++n) {
		u64 xx[2], rs;

		assert(read(fd, xx, sizeof(xx)) == sizeof(xx));

		if (xx[1] == 0)
			continue;

		rs = div64_u64(xx[0], xx[1]);

		if (rs != xx[0] / xx[1]) {
			printf("ERR!! %llx / %llx = %llx : %llx\n",
				xx[0] , xx[1], xx[0] / xx[1], rs);
			return 1;
		}

		if (!(n %100000))
			printf("passed: %d\n", n);
	}
}

