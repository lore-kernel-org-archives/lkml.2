Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab1CHOZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 09:25:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:54606 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750931Ab1CHOZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:25:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Ju1wWx6YJr64UhAbeBdPcdINtbH86T55tjEviVC
	w4uGnPPNGsB1pp
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1299591983.2308.1502.camel@twins>
References: <1299486101.14465.25.camel@marge.simson.net>
	 <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
	 <1299490414.14465.74.camel@marge.simson.net>
	 <1299508052.8093.1.camel@marge.simson.net>
	 <1299588399.2308.1424.camel@twins>
	 <1299590878.7949.41.camel@marge.simson.net>
	 <1299591983.2308.1502.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 15:25:04 +0100
Message-ID: <1299594304.7938.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 14:46 +0100, Peter Zijlstra wrote:
> On Tue, 2011-03-08 at 14:27 +0100, Mike Galbraith wrote:
> 
> > > Also, how much of a problem is it really? When I start a FIFO spinner on
> > > my machine I can still ssh in and kill the thing.
> > 
> > It's a problem if you have one box.  Also, try starting a hefty load
> > then having an rt task go nuts.  Nothing good happens here. 
> 
> Right, so I think we're not aggressive enough to migrate tasks away from
> very small cpu_power CPUs, trapping tasks on such CPUs.

I don't think that's it at all.  I just tried (again) with virgin tip.
Start a kbuild, start an RT hog.  Instant frozen box.  If you're in a
console shell, you may or may not save the box, but the desktop is
instantly toast, and there is no ssh possibility.  I can ping the box,
but that's it.  It's a pingable doorstop.

> Of course, this is no help for pinned tasks.. but then you get what you
> asked for isn't it ;-)

But events/N are pinned, and kinda critical.

> > > Not allowing 100% FIFO usage on SMP is going to make it very very hard
> > > to implement any kind of fifo-cgroup stuff.
> > 
> > The only thing I care much about is the default setup.  The safety net
> > should work, otherwise it's a waste.
> 
> Right, but how much trouble can be avoided by making the sched_fair
> load-balancer migrate tasks away from very small cpu_power CPUs?

I don't think that's the issue.  I think when any events is blocked
forever, it's game over.

> It won't avoid actual deadlocks when someone tries to wait for workqueue
> broadcasts and the like, but how much of that is actually happening?

Mmmmm.. enough to kill my box every time I test? :)

> > Maybe only doing the borrow thing when there are active RT groups is the
> > right thing to do.  (minus knob) 
> 
> Thing is the whole borrowing needs to go, Dario and me finally came up
> with a 'sane' way to implement fifo-cgroups, but that does include
> explicitly allowing starving CPUs.

Hm, borrowing going away sounds great.  Dunno about that starving CPUs
bit, that has never led to anything but BRB poking here.

> Not allowing that very quickly degenerates into massive trouble like
> gang-scheduling or bouncing tasks around like mad and generally messing
> up the 'load-balancer'.

If the problematic code is going away anyway, I'll just leave it. It's
the same problem that has existed since the dawn of time.  RT hogs can
be utterly deadly a while longer I suppose :)

	-Mike

