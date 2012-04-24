Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2DXVdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:33:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39193 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab2DXVdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:33:10 -0400
Message-ID: <1335303177.28150.235.camel@twins>
Subject: Re: [RFC][PATCH 0/3] gcc work-around and math128
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>
Date: Tue, 24 Apr 2012 23:32:57 +0200
In-Reply-To: <4F9717E6.8030506@amacapital.net>
References: <20120424161039.293018424@chello.nl>
	 <4F9717E6.8030506@amacapital.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 14:15 -0700, Andy Lutomirski wrote:
> > The second two implement a few u128 operations so we can do 128bit math.. I
> > know a few people will die a little inside, but having nanosecond granularity
> > time accounting leads to very big numbers very quickly and when you need to
> > multiply them 64bit really isn't that much.
> 
> I played with some of this stuff awhile ago, and for timekeeping, it
> seemed like a 64x32->96 bit multiply followed by a right shift was
> enough, and that operation is a lot faster on 32-bit architectures than
> a full 64x64->128 multiply. 

The SCHED_DEADLINE use case is not that, it multiplies two time
intervals. Basically it needs to evaluate if a task activation still
fits in the old period or if it needs to shift the deadline and start a
new period.

It needs to do: runtime / (deadline - t) < budget / period
which transforms into: (deadline - t) * period < budget * runtime

hence the 64x64->128 mult and 128 compare.

> Something like:
> 
> uint64_t mul_64_32_shift(uint64_t a, uint32_t mult, uint32_t shift)
> {
>   return (uint64_t)( ((__uint128_t)a * (__uint128_t)mult) >> shift );
> }

That looks a lot like what we grew mult_frac() for, it does:

/*              
 * Multiplies an integer by a fraction, while avoiding unnecessary
 * overflow or loss of precision.
 */
#define mult_frac(x, numer, denom)(                     \
{                                                       \
        typeof(x) quot = (x) / (denom);                 \
        typeof(x) rem  = (x) % (denom);                 \
        (quot * (numer)) + ((rem * (numer)) / (denom)); \
}                                                       \
)


and is used in __cycles_2_ns() and friends.
