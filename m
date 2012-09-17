Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2IQIId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:08:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:43350 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754492Ab2IQII2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:08:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/y6SVibHvyaYLF5QdbsyDjsGs9yP0+9txUE1Sp8b
	Kqckjw8FFG78F7
Message-ID: <1347869299.6955.156.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Mon, 17 Sep 2012 10:08:19 +0200
In-Reply-To: <CA+55aFwTd+Nde=RfthE5XwFqGfZKVKKd9JfAeDUmwed1E634rQ@mail.gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <1347680006.4340.142.camel@marge.simpson.net>
	 <m24nmzz2f8.fsf@firstfloor.org>
	 <1347727001.7029.37.camel@marge.simpson.net>
	 <20120915223212.4174a314@pyramind.ukuu.org.uk>
	 <1347770100.6952.31.camel@marge.simpson.net>
	 <CA+55aFwTd+Nde=RfthE5XwFqGfZKVKKd9JfAeDUmwed1E634rQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-16 at 12:57 -0700, Linus Torvalds wrote: 
> On Sat, Sep 15, 2012 at 9:35 PM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > Oh, while I'm thinking about it, there's another scenario that could
> > cause the select_idle_sibling() change to affect pgbench on largeish
> > packages, but it boils down to preemption odds as well.
> 
> So here's a possible suggestion..
> 
> Let's assume that the scheduler code to find the next idle CPU on the
> package is actually a good idea, and we shouldn't mess with the idea.

We should definitely mess with the idea, as it causes some problems.

> But at the same time, it's clearly an *expensive* idea, which is why
> you introduced the "only test a single CPU buddy" approach instead.
> But that didn't work, and you can come up with multiple reasons why it
> wouldn't work. Plus, quite fundamentally, it's rather understandable
> that "try to find an idle CPU on the same package" really would be a
> good idea, right?

I would argue that it did work, it shut down the primary source of pain,
which I do not believe to be the traversal cost, rather the bouncing.

    4 socket 40 core + SMT Westmere box, single 30 sec tbench runs, higher is better:
    
     clients     1       2       4        8       16       32       64      128
     ..........................................................................
     pre        30      41     118      645     3769     6214    12233    14312
     post      299     603    1211     2418     4697     6847    11606    14557

10x at 1 pair shouldn't be traversal, the whole box is otherwise idle.
We'll do a lot more (ever more futile) traversal as load increases, but
at the same time, our futile attempts fail more frequently, so we shoot
ourselves in the foot less frequently.

The down side is (appears to be) that I also shut down some ~odd case
preemption salvation, salvation that only large packages will receive.

The problem as I see it is that we're making light tasks _too_ mobile,
turning an optimization into a pessimization for light tasks.  For
longer running tasks this mobility within a large package isn't such a
big deal, but for fast movers, it hurts a lot.

> So instead of limiting the "try to find an idle CPU on the same
> package" to "pick *one* idle CPU on the same package to try", how
> about just trying to make the whole "find another idle CPU" much
> cheaper, and much more scalable that way?

I'm all for anything that makes the fastpath lighter.  We're too fat.

> Quite frankly, the loop in select_idle_sibling() is insanely expensive
> for what it really wants to do. All it really wants to do is:
>  - iterate over idle processors on this package
>  - make sure that idle processor is in the cpu's allowed.
> 
> Right?

For longish running tasks, yeah.  For the problematic loads mentioned,
you'd be better off killing select_idle_sibling() entirely, and turning
WAKE_BALANCE on methinks, that would buy them more preemption salvation.

> But the whole use of "cpumask_intersects()" etc is quite expensive,
> and there's that crazy double loop to do the above. So no wonder that
> it's expensive and causes scalability problems. That would be
> *especially* true if nr_cpumask_bits is big, and we have
> CONFIG_CPUMASK_OFFSTACK defined.
> 
> So I would suggest:
>  (a) revert the original commit (already done in my tree)
>  (b) look at just making the loop *much* cheaper.
> 
> For example, all those "cpumask_intersects()" and "cpumask_first()"
> things are *really* expensive, and expand to tons of code especially
> for the OFFSTACK case (and aren't exactly free even for the smaller
> case). And it really is all stupidly and badly done. I bet we can make
> that code faster without really changing the  end result at all, just
> changing the algorithm.
> 
> For example, what if we got rid of all the crazy "sd groups" crap at
> run-time, and just built a single linked circular list of CPU's on the
> same package?
> 
> Then we'd replace that crazy-expensive double loop over sd->groups and
> for_each_cpu() crap (not to mention cpumask_first_and() etc) with just
> a simple loop over that (and pick the *next* idle cpu, instead of
> doing that crazy "pick first one in a bitmask after and'ing").

Agreed, cheaper traversal should be doable, and would be nice.

> In fact, looking at select_idle_sibling(), I just want to puke. The
> thing is crazy.
> 
> Why the hell isn't the *very* first thing that function does just a simple
> 
>     if (idle_cpu(target))
>         return target;
> 
> instead it does totally f*cking insane things, and checks whether
> "target == cpu && idle_cpu(cpu)".

Hm, in the current incarnation, target is either this_cpu or task_cpu()
if wake_affine() said "no", so yeah, seems you're right.

> The code is shit. Just fix the shit, instead of trying to come up with
> some totally different model. Ok? I bet just fixing it to not have
> insane double loops would already get 90% of the speedup that Mike's
> original patch did, but without the downsides of having to pick just a
> single idle-buddy.

I'm skeptical, but would love to be wrong about that.

> We might also possibly add a "look at SMT buddy first" case, because
> Mike is probably right that bouncing all over the package isn't
> necessarily a good idea unless we really need to. But that would be a
> different thing.

The code used to do that, was recently modified to look for an idle core
first.  Testing that in enterprise, because I desperately needed to
combat throughput loss 2.6.32->3.0 is how I landed here.  What I found
while integrating was Dr. Jekyll and Mr. Hyde.  Less balancing is more..
until it's not enough.  Damn.  I beat up select_idle_sibling() to turn
regression into the needed progression.

Box _regressed_ only in that finding an idle SMT sibling could save us
from ourselves before if box _had_ SMT, but the bounce problem was lying
there from day one.  I didn't see it before, because I didn't go looking
for evilness on enterprise hardware, used to have no access to sexy
hardware, and didn't know things like "opterons suck" and "L3 is not
nearly as wonderful as shared L2".

On an opteron, best thing you can do for fast mover loads is to turn
select_idle_sibling() off, you need a lot of overlap to win.  On Intel
hardware otoh, 3.0 kernel now kicks the snot out of 2.6.32 at fast mover
localhost _and_ aim7 compute.  Opterons don't respond to much of
anything other than "if load is fast mover, turn it the hell off", but
large Intel packages much appreciated Mr. Hyde having his fangs pulled.

You're welcome to keep the fully fanged version of Mr. Hyde ;-) but I
now know beyond doubt that he's one evil SOB, so I will keep this patch
until better psychopath therapy kit comes along, and already have knobs
set such that LAST_BUDDY provides preemption salvation.

-Mike

