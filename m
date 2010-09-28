Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0I1Qug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:50:36 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:49814 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab0I1Quf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:50:35 -0400
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: balbir@linux.vnet.ibm.com
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100928082105.GC4128@balbir.in.ibm.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
	 <1285250541.1837.95.camel@holzheu-laptop>
	 <20100928082105.GC4128@balbir.in.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Tue, 28 Sep 2010 18:50:30 +0200
Message-ID: <1285692630.1866.74.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Balbir,

On Tue, 2010-09-28 at 13:51 +0530, Balbir Singh wrote:
> * Michael Holzheu <holzheu@linux.vnet.ibm.com> [2010-09-23 16:02:21]:
> 
> > Subject: [PATCH] taskstats: Fix exit CPU time accounting
> > 
> > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > Currently there are code pathes (e.g. for kthreads) where the consumed
> > CPU time is not accounted to the parents cumulative counters.
> > Now CPU time is accounted to the parent, if the exit accounting has not
> > been done correctly.
> >
> 
> Does this impact account of the init process? Why do we care about
> accounting the time to the parent? In the case of tgid, all threads
> data makes sense. What is the benefit or gap we are trying to address
> in terms of lost data or accountability?

We care about the cumulative times because we wanted to write
a top command that can get 100% of all consumed CPU time in an
interval without using exit events.

I tried to write the idea down. Hopefully it is clear enough...

HOWTO calculate 100% consumed CPU time between two taskstats snapshots
======================================================================

In the following the idea of getting 100% of consumed CPU time between two
taskstats snapshots without using exit events is described. For simplicity we
use CPU-time as synonym for "user time", "system time" and "steal time".

In order to show the consumed CPU time in an interval a top tool has to:

* Collect snapshot 1 of all running tasks
* Wait interval
* Collect snapshot 2 of all running tasks

A snapshot contains the following data for each task:

 * time-task:    CPU time that has been consumed by task itself:
                 task->(u/s/st-time)
 * time-child:   CPU time that has been consumed by dead children of task:
                 task->signal->(cu/cs/cst-time)
 * time-thread:  CPU time that has been consumed by dead threads of
                 thread group of thread group leader:
                 task->signal->(u/s/st-time)

All consumed CPU time in the interval can be calculated as follows:
 
  For all tasks that are in snapshot 1 AND in snapshot 2:

    (time-task[2] - time-task[1]) +
    (time-child[2] - time-child[1]) +
    (time-thread[2] - time-thread[1] {for thread group leader})

  minus

  For all tasks that are in snapshot 1 but NOT in snapshot 2 (tasks that have
  been exited):

    time-task[1] +
    time-child[1] +
    time-thread[1] (if thread group has exited)

    We have to subtract those CPU times in order to get the CPU time
    of the exited tasks that has been consumed in the last interval.

To provide a consistent view, the top tool could show the following fields:
 * user:  task utime per interval
 * sys:   task stime per interval
 * ste:   task sttime per interval
 * cuser: utime of exited children per interval
 * csys:  stime of exited children per interval
 * cste:  sttime of exited children per interval
 * tuser: utime of exited threads per interval (only for thread group leader)
 * tsys:  stime of exited threads per interval (only for thread group leader)
 * tste:  sttime of exited threads per interval (only for thread group leader)
 * total: Sum of all above fields

If the top command notices that a PID disappeared between snapshot 1
and snapshot 2, it has to do the following:

If task is not the thread group leader (pid != tgid):
  Find its thread group leader and subtract the CPU times from snapshot 1
  of the dead task from the thread group leader's time-thread interval
  difference.
else
  Find its parent and subtract the CPU times from snapshot 1 of the dead child
  from the parents time-child interval difference.

Example output:
---------------
pid     user   sys  ste  cuser  csys cste tuser tsys tste total  Name
(#)      (%)   (%)  (%)    (%)   (%)  (%)   (%)  (%)  (%)   (%)  (str)
17944   0.10  0.01 0.00  54.29 14.36 0.22  0.00 0.00 0.00 68.98  make
18006   0.10  0.01 0.00  55.79 12.23 0.12  0.00 0.00 0.00 68.26  make
18041  48.18  1.51 0.29   0.00  0.00 0.00  0.00 0.00 0.00 49.98  cc1
...

The sum of all "total" CPU counters on a system that is 100% busy should
be exactly the number CPUs multiplied by the interval time. A good testcase
for this is to start a loop program for each CPU and then in parallel
starting a kernel build with "-j 5".

OPEN ISSUE:

A current problem with the Linux kernel is that CPU time can disappear,
if a child of a parent that ignores (SIGCHLD) dies.

Michael

