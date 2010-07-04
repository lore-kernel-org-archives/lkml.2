Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab0GDAxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 20:53:18 -0400
Received: from amavis-smtp.knology.net ([75.76.199.6]:58852 "EHLO
	amavis-smtp.knology.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab0GDAxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 20:53:17 -0400
X-Greylist: delayed 1359 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jul 2010 20:53:17 EDT
Subject: Re: [PATCH] perf wrong branches event on AMD
From: David Dillow <dillowda@ornl.gov>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100703135408.GE26067@elte.hu>
References: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
	 <1278070727.1917.253.camel@laptop>
	 <alpine.DEB.2.00.1007020950420.29784@cl320.eecs.utk.edu>
	 <1278080613.1917.258.camel@laptop>
	 <alpine.DEB.2.00.1007021546150.3405@cl320.eecs.utk.edu>
	 <20100703135408.GE26067@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Jul 2010 20:30:23 -0400
Message-ID: <1278203423.4311.46.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-03 at 15:54 +0200, Ingo Molnar wrote:
> * Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> 
> > On Fri, 2 Jul 2010, Peter Zijlstra wrote:
> > 
> > > On Fri, 2010-07-02 at 09:56 -0400, Vince Weaver wrote:
> > > > You think I have root on this machine?
> > > 
> > > Well yeah,.. I'd not want a dev job and not have full access to the
> > > hardware. But then, maybe I'm picky.
> > 
> > I can see how this support call would go now.
> > 
> >   Me:  Hello, I need you to upgrade the kernel on the
> >        2.332 petaflop machine with 37,376 processors 
> >        so I can have the right branch counter on perf.
> >   Them: Umm... no.
> >   Me:  Well then can I have root so I can patch
> >        the kernel on the fly?
> >   Them: <click>
> 
> No, the way it would go, for this particular bug you reported, is something 
> like:
> 
>     Me:   Hello, I need you to upgrade the kernel on the
>           2.332 petaflop machine with 37,376 processors 
>           so I can have the right branch counter on perf.
> 
>     Them: Please wait for the next security/stability update of
>           the 2.6.32 kernel.
> 
>     Me:   Thanks.

You're both funny, though Vince is closer to reality for the scale of
machines he's talking about. The vendor kernel on these behemoths is a
patched SLES11 kernel based on 2.6.18, and paint does indeed dry faster
than changes to that kernel occur.

It pains me that this is the case, but the vendor doesn't have the
resources to keep up-to-date, and even if they did, it's not clear that
the users would want them to do so -- you take risk with the changes,
and a small performance regression can end up costing them hundreds of
thousand CPU-hours, which is a problem when you have a budget in the low
millions -- all of which are needed to reach your science goals. Sure,
you may get some improvements, but there's risk.

> Because i marked this fix for a -stable backport so it will automatically 
> propagate into all currently maintained stable kernels.

That's wonderful, but doesn't address the situation Vince finds himself
in, and he's not alone. We just don't get kernel updates, as much as we
might like to. If the behavior is in user-space, then the library
developers can fix it quickly, and users can pull it into their
applications without waiting for a scheduled maintenance period. We try
not to take maintenance periods unless we need to clean up hardware
issues, as the primary function of the machine is CPU-hours for science
runs. It takes an hour or more to reboot the machine without needing to
perform any software updates, and that hour equals 224,000 CPU-hours
that could be better spent.

> > As a performance counter library developer, it is a bit frustrating having 
> > to keep a compatibility matrix in my head of all the perf events 
> > shortcomings.  Especially since the users tend not to have admin access on 
> > their machines.  Need to have at least 2.6.33 if you want multiplexing.  
> 
> Admins of restrictive environments are very reluctant to update _any_ system 
> component, not just the kernel - and that includes instrumentation 
> tools/libraries.
> 
> In fact often the kernel gets updated more frequently, because it's so 
> central.

Quite the reverse here, we update compilers and libraries quite often,
and we have a system in place that keeps the old versions in place.
There are often odd interdependencies between the libraries, and
particular science applications often require a specific version to run.
Upgrading libraries is fairly painless for us, and we can do it without
making the system unavailable to users.

> The solution for that is to not use restrictive environments with obsolete 
> tools for bleeding-edge development - or to wait until the features you rely 
> on trickle down to that environment as well.

Unfortunately, bleeding-edge high-performance computing requires running
in the vendor-supported environment, restrictive as it may be. There's
no where else that you can run an application that requires scaling up
to that many processors and memory footprint.

> Also, our design targets far more developers than just those who are willing 
> to download the latest library and are willing to use LD_PRELOAD or other 
> tricks. In reality most developers will wait for updates if there's a bug in 
> the tool they are using.
> 
> You are a special case of a special case - _and_ you are limiting yourself by 
> being willing to update everything _but_ the kernel.

We're limiting ourselves by expecting to get support from the vendor
after paying many millions for the machine, and the vendor just doesn't
move very quickly in kernel space. I could probably make HEAD run on the
machine with some hacking on the machine specific device drivers, but
it'd never see production use -- it would void support and that's a
deal-killer.

Note that I'm not arguing for a design change -- I'm just trying to give
you some background on why people in the high-performance computing
sector keep saying how much easier it is for them if they can fix issues
with a new library rather than a new kernel.

Once the (very) downstream vendors catch up to a baseline kernel with
perf in it, fixing bugs like this will require at least partial machine
downtimes or rolling upgrades with ksplice. Both of those mechanisms
have their own drawbacks and will require an increased candy supply to
keep the system admins from picking up pitchforks. :)
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

