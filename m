Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab1DMXjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:39:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757284Ab1DMXjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <4DA6145D.9070703@kernel.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
 <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu>
 <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org>
 <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org>
 <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Apr 2011 16:39:21 -0700
Message-ID: <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
To: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@elte.hu>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 2:23 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> What are all the magic numbers, and why would 0x80000000 be special?
>
> that is the old value when kernel was doing bottom-up bootmem allocation.

I understand, BUT THAT IS STILL A TOTALLY MAGIC NUMBER!

It makes it come out the same ON THAT ONE MACHINE.  So no, it's not
"the old value". It's a random value that gets the old value in one
specific case.

>> Why don't we write code that just works?
>>
>> Or absent a "just works" set of patches, why don't we revert to code
>> that has years of testing?
>>
>> This kind of "I broke things, so now I will jiggle things randomly
>> until they unbreak" is not acceptable.
>>
>> Either explain why that fixes a real BUG (and why the magic constants
>> need to be what they are), or just revert the patch that caused the
>> problem, and go back to the allocation patters that have years of
>> experience.
>>
>> Guys, we've had this discussion before, in PCI allocation. We don't do
>> this. We tried switching the PCI region allocations to top-down, and
>> IT WAS A FAILURE. We reverted it to what we had years of testing with.
>>
>> Don't just make random changes. There really are only two acceptable
>> models of development: "think and analyze" or "years and years of
>> testing on thousands of machines". Those two really do work.
>
> We did do the analyzing, and only difference seems to be:

No.

Yinghai, we have had this discussion before, and dammit, you need to
understand the difference between "understanding the problem" and "put
in random values until it works on one machine".

There was absolutely _zero_ analysis done. You do not actually
understand WHY the numbers matter. You just look at two random
numbers, and one works, the other does not. That's not "analyzing".
That's just "random number games".

If you cannot see and understand the difference between an actual
analytical solution where you _understand_ what the code is doing and
why, and "random numbers that happen to work on one machine", I don't
know what to tell you.

> good one is using 0x80000000
> and bad one is using 0xa0000000.
>
> We try to figure out if it needs low address and it happen to work
> because kernel was doing bottom up allocation.

No.

Let me repeat my point one more time.

You have TWO choices. Not more, not less:

 - choice #1: go back to the old allocation model. It's tested. It
doesn't regress. Admittedly we may not know exactly _why_ it works,
and it might not work on all machines, but it doesn't cause
regressions (ie the machines it doesn't work on it _never_ worked on).

   And this doesn't mean "old value for that _one_ machine". It means
"old value for _every_ machine". So it means we revert the whole
bottom-down thing entirely. Not just "change one random number so that
the totally different allocation pattern happens to give the same
result on one particular machine".

   Quite frankly, I don't see the point of doing top-to-bottom anyway,
so I think we should do this regardless. Just revert the whole
"allocate from top". It didn't work for PCI, it's not working for this
case either. Stop doing it.

 - Choice #2: understand exactly _what_ goes wrong, and fix it
analytically (ie by _understanding_ the problem, and being able to
solve it exactly, and in a way you can argue about without having to
resort to "magic happens").

Now, the whole analytic approach (aka "computer sciency" approach),
where you can actually think about the problem without having any
pesky "reality" impact the solution is obviously the one we tend to
prefer. Sadly, it's seldom the one we can use in reality when it comes
to things like resource allocation, since we end up starting off with
often buggy approximations of what the actual hardware is all about
(ie broken firmware tables).

So I'd love to know exactly why one random number works, and why
another one doesn't. But as long as we do _not_ know the "Why" of it,
we will have to revert.

It really is that simple. It's _always_ that simple.

So the numbers shouldn't be "magic", they should have real
explanations. And in the absense of real explanation, the model that
works is "this is what we've always done". Including, very much, the
whole allocation order. Not just one random number on one random
machine.

                        Linus
