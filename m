Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1CHN2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:28:06 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:43169 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754469Ab1CHN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:28:03 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/dqQcK9Ijdmdu3ZhGpRkkE0qjYk7DXb4LL1m0vqu
	cZwI6yQLtpFugd
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1299588399.2308.1424.camel@twins>
References: <1299486101.14465.25.camel@marge.simson.net>
	 <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
	 <1299490414.14465.74.camel@marge.simson.net>
	 <1299508052.8093.1.camel@marge.simson.net>
	 <1299588399.2308.1424.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 14:27:58 +0100
Message-ID: <1299590878.7949.41.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 13:46 +0100, Peter Zijlstra wrote:
> On Mon, 2011-03-07 at 15:27 +0100, Mike Galbraith wrote:
> > sched: fix rt throttle runtime borrowing
> > 
> > If allowed to borrow up to rt_period, the throttle has no effect on an out
> > of control RT task, allowing it to consume 100% CPU indefinitely, blocking
> > system critical SCHED_NORMAL threads indefinitely.
> > 
> > To make the throttle a more effective safety mechanism, disable borrowing
> > by default. while providing an opt-in switch for those who know the risks.
> > Also fix the throttle such that it never silently bumps rt_runtime to the
> > point that it disables itself (rt_runtime >= rt_period).
> > 
> > Convert balance_runtime() and do_balance_runtime() to void since their
> > return values are never used.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> I'm very hesitant here, pretty much all of the sched_rt cgroup stuff
> needs to be thrown out and rewritten. Adding more knobs to it isn't
> going to make things much better.

Yeah, I already fed it to the bitwolf.

> (I'd myself much prefer to simply not support SCHED_FIFO/RR at all, but
> seeing as POSIX mandates that crap there's really no choice there).
> 
> Also, how much of a problem is it really? When I start a FIFO spinner on
> my machine I can still ssh in and kill the thing.

It's a problem if you have one box.  Also, try starting a hefty load
then having an rt task go nuts.  Nothing good happens here. 

> Not allowing 100% FIFO usage on SMP is going to make it very very hard
> to implement any kind of fifo-cgroup stuff.

The only thing I care much about is the default setup.  The safety net
should work, otherwise it's a waste.

Maybe only doing the borrow thing when there are active RT groups is the
right thing to do.  (minus knob) 

	-Mike

