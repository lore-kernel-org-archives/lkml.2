Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2DXUSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:18:47 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:55388 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2DXUSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:18:45 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2012 16:18:45 EDT
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/3] math128: Introduce {mult,add,cmp}_u128
References: <20120424161039.293018424@chello.nl>
	<20120424162224.526249106@chello.nl>
	<CA+55aFyvBTDh_DkXs6Z6zFmjyYxvWaAEm9-rJDXhvPx8CpDiKA@mail.gmail.com>
Date: Tue, 24 Apr 2012 21:12:20 +0100
In-Reply-To: <CA+55aFyvBTDh_DkXs6Z6zFmjyYxvWaAEm9-rJDXhvPx8CpDiKA@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 24 Apr 2012 12:37:53 -0700")
Message-ID: <yw1xy5pkj3dn.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Apr 24, 2012 at 9:10 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> Grow rudimentary u128 support without relying on gcc/libgcc.
>>
>> +#ifndef add_u128
>> +static inline u128 add_u128(u128 a, u128 b)
>> +{
>> +       u128 res;
>> +
>> +       res.hi = a.hi + b.hi;
>> +       res.lo = a.lo + b.lo;
>> +
>> +       if (res.lo < a.lo || res.lo < b.lo)
>> +               res.hi++;
>
> This is wrong. Or at least stupid.
>
> Just do one of the comparisons, not both. If overflow occurs, the
> result will be smaller than *either* of the added numbers, so
> comparing both is just silly and confused.
>
> So just pick one.
>
> Also, it might be worth looking at code generation, to see if it's
> better to just do
>
>    a.hi += b.hi;
>    a.low += b.low;
>    if (a.low < b.low)
>       a.hi++;
>    return a;

I have no idea if it makes a difference, but that if statement can be
written as a.hi += a.low < b.low.  Just an observation.

> because that might make it clear that there are fewer actual values
> live at any particular time. But gcc may not care. Try it.
>
> Also, for the multiply, please make sure gcc knows to do a "32x32->64"
> multiplication, rather than thinking it needs to do full 64x64
> multiplies..

On ARM it does the right thing at least since 4.3, which is the oldest
ARM compiler I have at hand.

-- 
Måns Rullgård
mans@mansr.com
