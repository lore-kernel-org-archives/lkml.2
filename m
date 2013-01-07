Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3AGHgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:36:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3AGHgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:36:51 -0500
Message-ID: <1357544184.5792.140.camel@marge.simpson.net>
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
From: Mike Galbraith <bitbucket@online.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Alex Shi <alex.shi@intel.com>,
        srikar@linux.vnet.ibm.com
Date: Mon, 07 Jan 2013 08:36:24 +0100
In-Reply-To: <50EA5D41.4090502@linux.vnet.ibm.com>
References: <50E3B61A.3040808@linux.vnet.ibm.com>
	 <1357114354.5586.39.camel@marge.simpson.net>
	 <50E55F99.6090104@linux.vnet.ibm.com>
	 <1357373590.5690.172.camel@marge.simpson.net>
	 <1357489955.5717.21.camel@marge.simpson.net>
	 <50EA5D41.4090502@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:b75sjKG6FIKnYKl2gaod4l5itiwfQfOEvPrRq/Gz+Zp
 Yg6XFJiXLokff36Ha/5F2rhpfGJi/5kAi9mmv4p0nQ25ty/xI3
 GFq54pC3+8cOFtXreM/qhofEj/TaNEJB+TNSyN4iHLlVBoOCUy
 c7S0hcNYOIaNz/nhlVujRfCQ1XZ30Y3jfxb32bCFbyQ7Lmz9n7
 QOVdbwcPXyW6+n0K+MZ7ruOtErI62Y39EQQUWF3h52X9B7Y1Bl
 y5q3PxqbfiGuw+S/e+mYfaSbp0Psd7BNa/tRWFer4qakYX//H0
 YV7xxPETH8Jc9wQbcQrbTmJDtUQoYLuL0Uq7dEg5VkHn2+RytJ
 WwDvGYP29915qkktPZeUa0wSJGgOtAzQGqQwPVFWvcjfIqqajt
 5jDtDmQ9ZY/ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 10:59 +0530, Preeti U Murthy wrote: 
> Hi Mike,
> Thank you very much for your inputs.Just a few thoughts so that we are
> clear with the problems so far in the scheduler scalability and in what
> direction we ought to move to correct them.
> 
> 1. During fork or exec,the scheduler goes through find_idlest_group()
> and find_idlest_cpu() in select_task_rq_fair() by iterating through all
> domains.Why then was a similar approach not followed for wake up
> balancing? What was so different about wake ups (except that the woken
> up task had to remain close to the prev/waking cpu) that we had to
> introduce select_idle_sibling() in the first place?

Cost.  select_idle_sibling() was introduced specifically to recoup
overlap via placing wakee in a shared L2 where there is no pain really,
it's all gain.  L3 ain't the same deal, but it still does a good job,
even for fast movers (on Intel) if you're not bouncing them all over the
place.  Breakeven depends on architecture, but critical for fast movers
on all is no bounce allowed.  Wakeup is a whole different thing than
fork/exec balancing, there, you just want to spread to seed your future,
and it doesn't matter much where you send wakees.  With wakeup of fast
movers, you lose on every migration, so buddies really really need to
find each other fast, and stay put, so you really do recoup overlap
instead of just paying again and again.  My old Q6600 kicks the snot out
of that 10 core Westmere CPU in a common desktop box cross core
scheduling scenario.  That's sick.

> 2.To the best of my knowlege,the concept of buddy cpu was introduced in
> select_idle_sibling() so as to avoid the entire package traversal and
> restrict it to the buddy cpus alone.But even during fork or exec,we
> iterate through all the sched domains,like I have mentioned above.Why
> did not the buddy cpu solution come to the rescue here as well?

I'm looking (well, pondering) fork/exec.  It may be a common case win
too, but I kinda doubt it'll matter.  It's the 1:1 waker/wakee relation
that suffers mightily.  The buddy was introduced specifically to bind
1:1 sw buddies (common) in hw as well.  They are one, make it so.  It
was the simplest solution I could think of to both kill the evil, and
cut cost to restore select_idle_sibling() to the optimization it was
intended to be vs the pessimization it has turned into on large L3 CPUs.
I took it back to it's functional roots.  Weld two modern cores
together, create core2duo on steroids, optimization works again and is
cheap again.

That the current behavior has its upsides too is.. most unfortunate :)

> 3.So the correct problem stands at avoid iterating through the entire
> package at the cost of less aggression in finding the idle cpu or
> iterate through the package with an intention of finding the idlest
> cpu.To the best of my understanding the former is your approach or
> commit 37407ea7,the latter is what I tried to do.But as you have rightly
> pointed out my approach will have scaling issues.In this light,how does
> your best_combined patch(below) look like?

It doesn't exist anymore, morphed into ever less wonderful as the day
went on.  Integration needs to fiddle with find_* to cut some wasted
cycles, and methinks reordered groups _may_ make it usable with no
idle-buddy hint.  Using the idle-buddy first looked promising, but
bottom line is that at higher load, you use it for a modest fee, buddy
was busy, so you then do the full scan paying a bigger fee on top of it,
which of course crops the high end.  Reorder should kill the low load
horror, but you've still got the problem that as you approach
saturation, the less value any search has.  That, and the logic is not
necessarily as light as it must be when targeting wakeups, where every
scheduler cycle detracts substantially from fast/light task performance.

> Do you introduce a cut off value on the loads to decide on which
> approach to take?

I fiddled with that, but then whacked it, because the result needs to be
nice to 1:1 and 1:N which may need to spread at high frequency, so the
cutoff would be harmful.  Seems likely either a cutoff or 1:1 vs 1:N
detection or _something_ will be needed to cut cost when it's flat not
affordable.  With 1:N pgbench (and ilk), there's no such thing as too
expensive a search, but for fast/light network stuff there is.

-Mike

