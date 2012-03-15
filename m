Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031119Ab2COROr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:14:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab2COROp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:14:45 -0400
Date: Thu, 15 Mar 2012 13:14:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120315171405.GH3941@redhat.com>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
 <20120314161906.e53359d3.akpm@linux-foundation.org>
 <20120315080232.GA17163@tiehlicka.suse.cz>
 <20120315155413.GE3941@redhat.com>
 <20120315161422.GC19855@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315161422.GC19855@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 05:14:22PM +0100, Michal Hocko wrote:
> On Thu 15-03-12 11:54:13, Don Zickus wrote:
> > On Thu, Mar 15, 2012 at 09:02:32AM +0100, Michal Hocko wrote:
> > > On Wed 14-03-12 16:19:06, Andrew Morton wrote:
> > > > On Wed, 14 Mar 2012 16:38:45 -0400
> > > > Don Zickus <dzickus@redhat.com> wrote:
> > > > 
> > > > > From: Michal Hocko <mhocko@suse.cz>
> > > > 
> > > > This changelog is awful.
> > 
> > My apologies too, Andrew for not being more diligent.
> > 
> > Some nitpicks below (hopefully it isn't too picky :-( )
> 
> Thanks! Updated

I think it looks fine.  Is this ok now Andrew?  I can respin this.

Cheers,
Don

> ---
> From a8da58750ba78d737136a4df24af805cb936ee00 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Tue, 13 Mar 2012 10:34:44 +0100
> Subject: [PATCH] watchdog: make sure the watchdog thread gets CPU on loaded
>  system
> 
> If the system is heavily loaded while hotplugging a CPU, we might end up
> with a bogus hardlockup detection. This has been seen during LTP pounder
> test executed in parallel with the hotplug test.
> 
> Hard lockup detector consist of two parts
> 	- watchdog_overflow_callback (executed as a perf counter callback
> 	  from NMI) which checks whether per-cpu hrtimer_interrupts changed
> 	  since the last time it run and panics if not
> 	- watchdog kernel thread which starts watchdog_hrtimer which
> 	  periodically updates hrtimer_interrupts.
> 
> The main problem is that watchdog_enable (called when a CPU is brought up)
> registers a perf event but the hrtimer is started later when the watchdog
> thread gets a chance to run.
> 
> The watchdog thread starts with a normal priority currently and boosts
> itself as soon as it gets to a CPU. This might be, however, already too
> late as demonstrated with the LTP pounder test executed in parallel by
> LTP hotplug test. There are zillions of userspace processes sitting in
> the runque while the number of online CPUs gets down to 1. CPUs are
> onlined back in the second stage where the issue triggers.
> 
> When we online a CPU and create the watchdog kernel thread it will take
> some time until it gets to a CPU. On the other hand the perf counter
> callback is executed in the timely fashion so we explode the first time
> it finds out that the hrtimer_interrupts wasn't incremented.
> 
> Let's fix this by boosting the watchdog thread priority before we wake it up
> rather than when it's already running.
> This still doesn't handle a case where we have the same amount of high prio
> FIFO tasks but that doesn't seem to be common. The current implementation
> doesn't handle that case anyway so this is no worse at least.
> 
> Unfortunately, we cannot start perf counter from the watchdog thread
> because we could miss a real lock up and also we cannot start the
> hrtimer from watchdog_enable because we there is no way (at least I
> don't know any) to start a hrtimer from a different CPU.
> -- 
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9    
> Czech Republic
