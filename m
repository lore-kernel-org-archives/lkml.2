Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1B1RxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:53:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:40671 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752608Ab1B1RxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:53:09 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1//d/EM/nL/+0AQt26B6dmyJ5MHN1b7tcVo2PIvXr
	2TLcVXYYqdV2sX
Date: Mon, 28 Feb 2011 18:53:03 +0100
From: torbenh <torbenh@gmx.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-audio-dev@music.columbia.edu,
        linux-audio-user@music.columbia.edu
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
Message-ID: <20110228175303.GG2977@siel.b>
Mail-Followup-To: Mike Galbraith <efault@gmx.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, linux-audio-dev@music.columbia.edu,
	linux-audio-user@music.columbia.edu
References: <1294810842.8370.7.camel@marge.simson.net>
 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
 <1294890890.8089.39.camel@marge.simson.net>
 <1295270160.30950.96.camel@laptop>
 <20110215154612.GI3055@siel.b>
 <1297788210.15382.51.camel@marge.simson.net>
 <20110218110955.GA3124@siel.b>
 <1298033412.8735.30.camel@marge.simson.net>
 <20110222122449.GC11548@siel.b>
 <1298386073.8036.49.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298386073.8036.49.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, Feb 22, 2011 at 03:47:53PM +0100, Mike Galbraith wrote:
> On Tue, 2011-02-22 at 13:24 +0100, torbenh wrote:
> > On Fri, Feb 18, 2011 at 01:50:12PM +0100, Mike Galbraith wrote:
> > > On Fri, 2011-02-18 at 12:09 +0100, torbenh wrote:
> > > > On Tue, Feb 15, 2011 at 05:43:30PM +0100, Mike Galbraith wrote:
> > > > > On Tue, 2011-02-15 at 16:46 +0100, torbenh wrote:
> > > > > > On Mon, Jan 17, 2011 at 02:16:00PM +0100, Peter Zijlstra wrote:
> > > > > > > On Thu, 2011-01-13 at 04:54 +0100, Mike Galbraith wrote:
> > > > > > > > sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
> > > > > > > > 
> > > > > > > > If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
> > > > > > > > not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
> > > > > > > > tasks to the root task group, and tell __sched_setscheduler() that it's ok.
> > > > > > > > 
> > > > > > > > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > > > > > > > Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > > > > > > 
> > > > > > > Thanks, applied!
> > > > > > 
> > > > > > while this behaviour is certeinly necessary, i think this is a hack.
> > > > > > it fixes the problem for autogroups.
> > > > > > But its not fixed for things which want to control the cfs shares via
> > > > > > normal cgroups.
> > > > > 
> > > > > You mean automated control ala systemd?  For a static set of groups, it
> > > > > works fine.  I was wondering how systemd would deal with it.
> > > > 
> > > > but i can not get the same behaviour as if CONFIG_RT_GROUP_SCHED was
> > > > off. iE N cgroups with different cpu.share values, but each with
> > > > rt_runtime_us=950000
> > > 
> > > ? if CONFIG_RT_GROUP_SCHED was a noop, it wouldn't exist.
> > > 
> > > > if the rt_runtime_us was in a different subsystem, its my understanding
> > > > that i could leave rt_runtime_us alone, and have all tasks in the root
> > > > group in the rt_runtime subsystem.
> > >  
> > > Sounds like you just want to turn CONFIG_RT_GROUP_SCHED off.
> > 
> > but distros turn it on.
> > we could prevent debian from turning it on. 
> > now opensuse 11.4 has turned it on.
> 
> If you or anyone else turns on RT_GROUP_SCHED, you will count your
> beans, and pay up front, or you will not play.  That's a very sensible
> policy for realtime.

this probably means that generic computer distros should not turn this
option on ?

> 
> > > > > The allocation problem was shamelessly punted back to the user, where I
> > > > > think it truly belongs.
> > > > 
> > > > sure it belongs to the user. but what if user wants to have different
> > > > cpu.shares, but full rt_runtime_us for all tasks ?
> > > 
> > > Then the user doesn't want CONFIG_RT_GROUP_SCHED set.
> > 
> > but distros force it onto the user.
> > if systemd shows up, and puts things into different cgroups, 
> > we end up with a pretty fragmented rt_runtime_us.
> 
> If systemd deals with it at all, seems to me it can only make a mess of
> it.  But who knows, maybe they made a clever allocator.  If they didn't,
> they'll need an escape hatch methinks.

the problem is that audio applications can not really pre allocate their
cpu needs. user can add processing plugins until he pushes his machine
to the limit. (or the cgroup where his process is running in)

we dont really have a mechanism for plugins to publish their needed
cycles. 


-- 
torben Hohn
