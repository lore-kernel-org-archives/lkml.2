Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386Ab0KPMQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:16:29 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:34243 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325Ab0KPMQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:16:26 -0500
Subject: Re: [RFC][PATCH v2 1/7] taskstats: Add new taskstats command
 TASKSTATS_CMD_ATTR_PIDS
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <1289841705.2109.513.camel@laptop>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170813.527389224@linux.vnet.ibm.com>
	 <1289676005.2109.148.camel@laptop>
	 <1289836380.1916.41.camel@holzheu-laptop>
	 <1289837178.2109.504.camel@laptop>
	 <1289840968.1916.85.camel@holzheu-laptop>
	 <1289841705.2109.513.camel@laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Tue, 16 Nov 2010 13:16:19 +0100
Message-ID: <1289909779.1940.26.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On Mon, 2010-11-15 at 18:21 +0100, Peter Zijlstra wrote:
> On Mon, 2010-11-15 at 18:09 +0100, Michael Holzheu wrote:
> 
> > > That you should not use sched_clock(),
> > 
> > What should we use instead?
> 
> Depends on what you want, look at kernel/sched_clock.c
> 
> > > What does last departed mean? That is what timeline are you counting in?
> > > Do you want time as tasks see it, or time as your wallclock sees it?
> > 
> > "last_depart" should be the time stamp, where the task has left a CPU
> > the last time.
> > 
> > We assume that we can compare "last_depart" with "time_ns" in the
> > taskstats structure,
> 
> I think you assume I actually know anything about taskstat :-), its the
> thing I always say =n to in my config file and have so far happily
> ignored all code of.
> 
> >  if we use task_rq(t)->clock for last_depart and
> > sched_clock() for stats->time_ns.
> 
> Then you're up shit creek because rq->clock doesn't necessarily have any
> correlation to sched_clock().
> 
> >  We also assume that we get wallclock
> > intervals in nanoseconds, if we look at two sched_clock() timestamps.
> 
> Invalid assumption.

Ok, thanks. So sched_clock() seems to be a bad idea for our purposes.

An alternative approach could be to have a global counter for the task
snapshots, which is increased each time a snapshot is created for
userspace. In addition to that we had to add a snapshot counter field to
the task_struct that is set to the current value of the global counter
each time a task leaves a CPU. Then userspace could ask for all tasks
that have been active after snapshot number x. In the response userspace
gets all tasks that have a snapshot number bigger than x together with
the new snapshot number y that can be used for the next query.

Still it would be useful to add a timestamp of the creation of the
taskstats data in the response to userspace for calculating the interval
time between two snapshots. Would the usage of ktime_get() be valid for
that purpose?

Michael

