Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2IPT5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 15:57:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47886 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2IPT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 15:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <1347770100.6952.31.camel@marge.simpson.net>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic> <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <1347680006.4340.142.camel@marge.simpson.net> <m24nmzz2f8.fsf@firstfloor.org>
 <1347727001.7029.37.camel@marge.simpson.net> <20120915223212.4174a314@pyramind.ukuu.org.uk>
 <1347770100.6952.31.camel@marge.simpson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Sep 2012 12:57:00 -0700
X-Google-Sender-Auth: F5FE1O1kQxFKDm5TeXBc8XoE4ZQ
Message-ID: <CA+55aFwTd+Nde=RfthE5XwFqGfZKVKKd9JfAeDUmwed1E634rQ@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Mike Galbraith <efault@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 9:35 PM, Mike Galbraith <efault@gmx.de> wrote:
>
> Oh, while I'm thinking about it, there's another scenario that could
> cause the select_idle_sibling() change to affect pgbench on largeish
> packages, but it boils down to preemption odds as well.

So here's a possible suggestion..

Let's assume that the scheduler code to find the next idle CPU on the
package is actually a good idea, and we shouldn't mess with the idea.

But at the same time, it's clearly an *expensive* idea, which is why
you introduced the "only test a single CPU buddy" approach instead.
But that didn't work, and you can come up with multiple reasons why it
wouldn't work. Plus, quite fundamentally, it's rather understandable
that "try to find an idle CPU on the same package" really would be a
good idea, right?

So instead of limiting the "try to find an idle CPU on the same
package" to "pick *one* idle CPU on the same package to try", how
about just trying to make the whole "find another idle CPU" much
cheaper, and much more scalable that way?

Quite frankly, the loop in select_idle_sibling() is insanely expensive
for what it really wants to do. All it really wants to do is:
 - iterate over idle processors on this package
 - make sure that idle processor is in the cpu's allowed.

Right?

But the whole use of "cpumask_intersects()" etc is quite expensive,
and there's that crazy double loop to do the above. So no wonder that
it's expensive and causes scalability problems. That would be
*especially* true if nr_cpumask_bits is big, and we have
CONFIG_CPUMASK_OFFSTACK defined.

So I would suggest:
 (a) revert the original commit (already done in my tree)
 (b) look at just making the loop *much* cheaper.

For example, all those "cpumask_intersects()" and "cpumask_first()"
things are *really* expensive, and expand to tons of code especially
for the OFFSTACK case (and aren't exactly free even for the smaller
case). And it really is all stupidly and badly done. I bet we can make
that code faster without really changing the  end result at all, just
changing the algorithm.

For example, what if we got rid of all the crazy "sd groups" crap at
run-time, and just built a single linked circular list of CPU's on the
same package?

Then we'd replace that crazy-expensive double loop over sd->groups and
for_each_cpu() crap (not to mention cpumask_first_and() etc) with just
a simple loop over that (and pick the *next* idle cpu, instead of
doing that crazy "pick first one in a bitmask after and'ing").

In fact, looking at select_idle_sibling(), I just want to puke. The
thing is crazy.

Why the hell isn't the *very* first thing that function does just a simple

    if (idle_cpu(target))
        return target;

instead it does totally f*cking insane things, and checks whether
"target == cpu && idle_cpu(cpu)".

The code is shit. Just fix the shit, instead of trying to come up with
some totally different model. Ok? I bet just fixing it to not have
insane double loops would already get 90% of the speedup that Mike's
original patch did, but without the downsides of having to pick just a
single idle-buddy.

We might also possibly add a "look at SMT buddy first" case, because
Mike is probably right that bouncing all over the package isn't
necessarily a good idea unless we really need to. But that would be a
different thing.

            Linus
