Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab2DXVgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:36:13 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:63518 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab2DXVgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:36:10 -0400
MIME-Version: 1.0
In-Reply-To: <1335303177.28150.235.camel@twins>
References: <20120424161039.293018424@chello.nl> <4F9717E6.8030506@amacapital.net>
 <1335303177.28150.235.camel@twins>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 24 Apr 2012 14:35:49 -0700
Message-ID: <CALCETrWJvQ6h=YaPX20pTGLQ39m1aFNEuubTb9f3cJczDPWy-g@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] gcc work-around and math128
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 2:32 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-04-24 at 14:15 -0700, Andy Lutomirski wrote:
>> > The second two implement a few u128 operations so we can do 128bit math.. I
>> > know a few people will die a little inside, but having nanosecond granularity
>> > time accounting leads to very big numbers very quickly and when you need to
>> > multiply them 64bit really isn't that much.
>>
>> I played with some of this stuff awhile ago, and for timekeeping, it
>> seemed like a 64x32->96 bit multiply followed by a right shift was
>> enough, and that operation is a lot faster on 32-bit architectures than
>> a full 64x64->128 multiply.
>
> The SCHED_DEADLINE use case is not that, it multiplies two time
> intervals. Basically it needs to evaluate if a task activation still
> fits in the old period or if it needs to shift the deadline and start a
> new period.
>
> It needs to do: runtime / (deadline - t) < budget / period
> which transforms into: (deadline - t) * period < budget * runtime
>
> hence the 64x64->128 mult and 128 compare.

Fair enough.

>
>> Something like:
>>
>> uint64_t mul_64_32_shift(uint64_t a, uint32_t mult, uint32_t shift)
>> {
>>   return (uint64_t)( ((__uint128_t)a * (__uint128_t)mult) >> shift );
>> }
>
> That looks a lot like what we grew mult_frac() for, it does:
>
> /*
>  * Multiplies an integer by a fraction, while avoiding unnecessary
>  * overflow or loss of precision.
>  */
> #define mult_frac(x, numer, denom)(                     \
> {                                                       \
>        typeof(x) quot = (x) / (denom);                 \
>        typeof(x) rem  = (x) % (denom);                 \
>        (quot * (numer)) + ((rem * (numer)) / (denom)); \
> }                                                       \
> )
>
>
> and is used in __cycles_2_ns() and friends.

Yeesh.  That looks way slower, and IIRC __cycles_2_ns overflows every
few seconds on modern machines.

gcc 4.6 generates this code:

mul_64_32_shift:
        pushq   %rbp
        movq    %rsp, %rbp
        movl    %edx, %ecx
        movl    %esi, %eax
        mulq    %rdi
        movq    %rdx, %rsi
        shrq    %cl, %rsi
        shrdq   %cl, %rdx, %rax
        testb   $64, %cl
        cmovneq %rsi, %rax
        popq    %rbp
        ret

which is a bit dumb if you can make assumptions about the shift.  See
http://gcc.gnu.org/PR46514.  Some use cases might be able to guarantee
that the shift is less than 32 bits, in which case hand-written
assembly would be a few cycles faster.

--Andy
