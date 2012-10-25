Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2JYW00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 18:26:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43589 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2JYW0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 18:26:24 -0400
MIME-Version: 1.0
In-Reply-To: <1351172849.12171.10.camel@twins>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com> <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
 <1351172849.12171.10.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Oct 2012 15:26:03 -0700
X-Google-Sender-Auth: oybzN7e5SxtGcvvpqT8HDjmCEzI
Message-ID: <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 6:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-10-24 at 16:18 -0700, Linus Torvalds wrote:
>>
>> So please, explain what the pressing need is that is so worthwhile
>> that this is worth it. Maybe it was in a 00/16 cover letter, but not
>> only was that not sent out to the people who got 01, you'd still want
>> it in the commit message.
>
> There's two use cases:
>
>  1) the proposed SCHED_DEADLINE needs to do some u64xu64 math, it
>     ends up having to multiply a deadline (in usec) with runtime (also
>     in usec).
>
>  2) the infrastructure adds mul_u64_u32_shr(), which is something we
>     do a lot of with all the time manipulation, apply a multiplier to
>     some u64 clock value.
>
>     We can do better on some archs than we can in generic, so this
>     interface could give a win there.

So I have no objection to the mul_u64_u32_shr() model, exactly because

 - it doesn't actually use u128 anywhere (except perhaps internally,
but that is totally about the implementation, not visible anywhere
else).

 - it is fundamentally optimizable especially on 32-bit architectures
where it doesn't need to do a full 64x64 multiply.

it's the *rest* of the "u128" math I really object to. I also wonder
about the u64xu64 math case for SCHED_DEADLINE, because I assume that
it doesn't actually end up using the 128-bit result in that form, but
scales it down again some way?

In other words, the thing I really object to is exactly the whole
"generic 128-bit math". That's the part that can easily get very
expensive in 32-bit environments. Even for the "u64xu64" multiply for
SCHED_DEADLINE, how could it possibly be true 64-bit values (even if
your "usec" was wrong, and it's "nsec").

At what point does the scheduler talk/think about billions of seconds
in nanoseconds? Seriously?

That's a perfect example of where "true 128-bit math" is potentially
stupidly expensive on 32-bit platforms, when a 48x48->96 bit multiply
might be cheaper. And if we're talking about some fixed-point
arithmetic, and the thing actually gets shifted down again (like the
mul_u64_u32_shr) so that the final result is actually guaranteed to
fit in (say) 64 bits, then that would be cheaper yet.

I realize that some people seem to think that being "generic" is
superior, and think that maybe somebody wants to do 128-bit arithmetic
for other things. And I think that is exactly the wrong way to think,
because it just encourages people to do exactly the wrong thing,
because "look, 128-bit arithmetic is easily available so I can do
fancy things", and then it just happens to go really fast on x86-64,
and then sucks everywhere else.

                Linus
