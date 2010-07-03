Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab0GCNyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 09:54:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52286 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0GCNyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 09:54:23 -0400
Date: Sat, 3 Jul 2010 15:54:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf wrong branches event on AMD
Message-ID: <20100703135408.GE26067@elte.hu>
References: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
 <1278070727.1917.253.camel@laptop>
 <alpine.DEB.2.00.1007020950420.29784@cl320.eecs.utk.edu>
 <1278080613.1917.258.camel@laptop>
 <alpine.DEB.2.00.1007021546150.3405@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007021546150.3405@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4989]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Fri, 2 Jul 2010, Peter Zijlstra wrote:
> 
> > On Fri, 2010-07-02 at 09:56 -0400, Vince Weaver wrote:
> > > You think I have root on this machine?
> > 
> > Well yeah,.. I'd not want a dev job and not have full access to the
> > hardware. But then, maybe I'm picky.
> 
> I can see how this support call would go now.
> 
>   Me:  Hello, I need you to upgrade the kernel on the
>        2.332 petaflop machine with 37,376 processors 
>        so I can have the right branch counter on perf.
>   Them: Umm... no.
>   Me:  Well then can I have root so I can patch
>        the kernel on the fly?
>   Them: <click>

No, the way it would go, for this particular bug you reported, is something 
like:

    Me:   Hello, I need you to upgrade the kernel on the
          2.332 petaflop machine with 37,376 processors 
          so I can have the right branch counter on perf.

    Them: Please wait for the next security/stability update of
          the 2.6.32 kernel.

    Me:   Thanks.

Because i marked this fix for a -stable backport so it will automatically 
propagate into all currently maintained stable kernels.

> As a performance counter library developer, it is a bit frustrating having 
> to keep a compatibility matrix in my head of all the perf events 
> shortcomings.  Especially since the users tend not to have admin access on 
> their machines.  Need to have at least 2.6.33 if you want multiplexing.  

Admins of restrictive environments are very reluctant to update _any_ system 
component, not just the kernel - and that includes instrumentation 
tools/libraries.

In fact often the kernel gets updated more frequently, because it's so 
central.

The solution for that is to not use restrictive environments with obsolete 
tools for bleeding-edge development - or to wait until the features you rely 
on trickle down to that environment as well.

Also, our design targets far more developers than just those who are willing 
to download the latest library and are willing to use LD_PRELOAD or other 
tricks. In reality most developers will wait for updates if there's a bug in 
the tool they are using.

You are a special case of a special case - _and_ you are limiting yourself by 
being willing to update everything _but_ the kernel.

Anyway, our design results out of our first-hand experience of laggy updates 
and limited capabilities of a user-centric performance-analysis library, and 
we wrote perf events to address those problems.

Claiming that we need a user-space-centric approach for the special case where 
you exclude the kernel from the components that may be updated in a system 
doesnt look like a strong reason to change the design.

> Need to have 2.6.34 if you want Nehalem-EX.  Need 2.6.35 if you want Pentium 
> 4. [...]

You wouldnt have gotten that any faster with a more user-space centric design 
either. Something like Pentium-4 support needs kernel help. So if you are 
stuck with an old kernel you wont have it - no matter what approach is used.

> [...] Now I'll have to remember whatever kenel the AMD branches fix is 
> committed at.  And there still isn't the Uncore support that everyone is 
> clamoring for.

You are very much welcome to help out with uncore events, if you are 
interested in them. The reason why they arent there yet is because so far 
people were more interested in adding support for say Pentium-4 events than in 
adding uncore events. If you want to change that then you either need to 
convince developers to implement it, or you need to do it yourself.

> > You can stick the knowledge in perf if you really want to.. something like 
> > the below, add something that parses cpuid or /proc/cpuinfo and you should 
> > be good.
> 
> again though, doesn't this defeat the purpose of the whole idea of common 
> named events?

You claimed there's no solution if there's a kernel update is not possible. 
Peter gave you such a solution and you are now claiming that it's no good 
because the better solution is to update the kernel? That argument seems 
either somewhat circular or somewhat contraditory.

> > And how would it be different if it the data table lived in userspace? 
> > They'd still get the wrong thing unless they updated.
> 
> because compiling and running an updated user-version of a library is 
> possible.  You can compile it in your home directory and link your tools 
> against it.  No need to bug the sysadmin.  You can even use LD_PRELOAD to 
> get other apps to link against it.  Getting a kernel update installed is 
> many orders of magnitude harder out in the real world.

Even in the restrictive-environment worst-case situation you mention (which, 
btw., is not that common at all), the kernel gets updated in a timely manner, 
with stability and security fixes. Your fix will be in .32-stable once it hits 
upstream.

And have you considered the counter argument: that with pure user-space 
libraries and tables there's a higher likelyhood that people will just sit on 
their fixes - because it's so easy to update the tables or add small hacks to 
fix the library?

With the perf events support code in the kernel they are encouraged to work 
with us and are encouraged to submit fixes - which will reach a far larger 
audience that way.

So our model will [obviously] lead to slower updates in those special 
situations where a super-high-end performance developer can do everything but 
upgrade the kernel, but otherwise common code is good for pretty much everyone 
else. We hurt more if it's buggy or incomplete, but in turn this creates 
pressure to keep that code correct.

Thanks,

	Ingo
