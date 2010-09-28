Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819Ab0I1IgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:36:22 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47906 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759289Ab0I1IgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:36:20 -0400
Date: Tue, 28 Sep 2010 14:06:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
Message-ID: <20100928083602.GD4128@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1285249681.1837.28.camel@holzheu-laptop>
 <1285250541.1837.95.camel@holzheu-laptop>
 <20100923171025.GA26623@redhat.com>
 <1285330688.2179.305.camel@holzheu-laptop>
 <20100926181127.GA26985@redhat.com>
 <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin Schwidefsky <schwidefsky@de.ibm.com> [2010-09-27 15:42:57]:

> On Sun, 26 Sep 2010 20:11:27 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > Hi,
> > 
> > On 09/24, Michael Holzheu wrote:
> > >
> > > On Thu, 2010-09-23 at 19:10 +0200, Oleg Nesterov wrote:
> > > >
> > > > On 09/23, Michael Holzheu wrote:
> > > > >
> > > > > Currently there are code pathes (e.g. for kthreads) where the consumed
> > > > > CPU time is not accounted to the parents cumulative counters.
> > > >
> > > > Could you explain more?
> > >
> > > I think one place was "khelper" (kmod.c). It is created with
> > > kernel_thread() and it exits without having accounted the times with
> > > sys_wait() to the parent's ctimes
> > 
> > No. Well yes, it is not accounted, but this is not because it is
> > kthread.
> 
> We noticed that behavior with kernel threads but as you point out
> the problem is bigger than that.
> 
> > To simplify the discussion, lets talk about utime/cutime only,
> > and lets forget about the multithreading.
> > 
> > It is very simple, currently linux accounts the exiting task's
> > utime and adds its to ->cutime _only_ if parent does do_wait().
> > If parent ignores SIGCHLD, the child reaps itself and it is not
> > accounted.
> > 
> > I do not know why it was done this way, but I'm afraid we can't
> > change this historical behaviour.
> 
> Why? I would consider it to be a BUG() that the time is not accounted.
> Independent of the fact that a parent wants to see the SIGCHLD and
> the exit status of its child the process time of the child should be
> accounted, no? And I'm not a particular fan of the "this has always
> been that way" reasoning.
> 
> > > Ok, the problem is that I did not consider exiting threads that are no
> > > thread group leaders. When they exit the ctime of the parent is not
> > > updated. Instead the time is accumulated in the signal struct.
> > 
> > I think I am a bit confused, but see above. With or without threads
> > the whole process can exit without accounting.
> 
> Got the part about self-reaping processes. But there is another issue:
> consider an exiting thread where the group leader is still active.
> The time for the thread will be added to the utime/stime fields in
> the signal structure. Taskstats will happily ignore that time while
> the group leader is still running.
>

Why do you say that? Not sure your comment is very clean, in
fill_tgid, we do

1. Accumulate signal stats (contains stats for dead threads)
2. Accumulate stats for current threads

fill_tgid_exit does something similar
 
> Please keep in mind that we want to get to a point where it is
> possible to get a 100% coverage of cpu cycles in the last snapshot
> cycle through the taskstats interface. Otherwise the precise top
> would not be very precise ..

-- 
	Three Cheers,
	Balbir
