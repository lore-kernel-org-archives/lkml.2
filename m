Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab0KORWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:22:03 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58476 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab0KORWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:22:01 -0500
Subject: Re: [RFC][PATCH v2 1/7] taskstats: Add new taskstats command
 TASKSTATS_CMD_ATTR_PIDS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: holzheu@linux.vnet.ibm.com
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
In-Reply-To: <1289840968.1916.85.camel@holzheu-laptop>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170813.527389224@linux.vnet.ibm.com>
	 <1289676005.2109.148.camel@laptop>
	 <1289836380.1916.41.camel@holzheu-laptop>
	 <1289837178.2109.504.camel@laptop>
	 <1289840968.1916.85.camel@holzheu-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 18:21:45 +0100
Message-ID: <1289841705.2109.513.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 18:09 +0100, Michael Holzheu wrote:

> > That you should not use sched_clock(),
> 
> What should we use instead?

Depends on what you want, look at kernel/sched_clock.c

> > What does last departed mean? That is what timeline are you counting in?
> > Do you want time as tasks see it, or time as your wallclock sees it?
> 
> "last_depart" should be the time stamp, where the task has left a CPU
> the last time.
> 
> We assume that we can compare "last_depart" with "time_ns" in the
> taskstats structure,

I think you assume I actually know anything about taskstat :-), its the
thing I always say =n to in my config file and have so far happily
ignored all code of.

>  if we use task_rq(t)->clock for last_depart and
> sched_clock() for stats->time_ns.

Then you're up shit creek because rq->clock doesn't necessarily have any
correlation to sched_clock().

>  We also assume that we get wallclock
> intervals in nanoseconds, if we look at two sched_clock() timestamps.

Invalid assumption.

> "stats->time_ns" is used as timestamp for the next snapshot query and
> for calculation of the snapshot interval time. So there are three
> important timestamps:
> * struct task_struct:
>   sched_info.last_depart: Last time task has left CPU

So you're essentially replicating the data in
sched_entity::statistics::wait_start ?

> * struct taskstats:
>   time_ns: Timestamp where taskstats data is generated
> * sturuct cmd_pids:
>   time_ns: Timestamp for TASKSTATS_CMD_ATTR_PIDS command. 
> 
> Example:
> 1. Get initial snapshot with cmd_pids->time_ns=0:
>    - All tasks are returned.
>     snapshot_time = MIN(stats->time_ns) for all received taskstats
> 2. Get second snapshot with cmd_pids->time_ns = snapshot_time
>    - Only tasks that were active after "snapshot_time" are returned.

/me can only hope all this will only increase overhead for those of us
who actually use any of this..

I'm still upset over ->[us]timescaled existing, this patch set looks to
me like it will only upset me more.
