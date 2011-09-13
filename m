Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1IMQ1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:27:23 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:42055 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755297Ab1IMQ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:27:22 -0400
Date: Tue, 13 Sep 2011 11:27:14 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched_rt: Migrate equal priority tasks to available CPUs
Message-ID: <20110913162713.GA2362@BohrerMBP.rgmadvisors.com>
References: <1315837684-18733-1-git-send-email-sbohrer@rgmadvisors.com>
 <1315919147.26295.1.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315919147.26295.1.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 09:05:46AM -0400, Steven Rostedt wrote:
> On Mon, 2011-09-12 at 09:28 -0500, Shawn Bohrer wrote:
> > Commit 43fa5460fe60dea5c610490a1d263415419c60f6 "sched: Try not to
> > migrate higher priority RT tasks" also introduced a change in behavior
> > which keeps RT tasks on the same CPU if there is an equal priority RT
> > task currently running even if there are empty CPUs available.  This can
> > cause unnecessary wakeup latencies, and can prevent the scheduler from
> > balancing all RT tasks across the available CPUs.
> > 
> > This change causes an RT task to search for a new CPU if an equal
> > priority RT task is already running on wakeup.  Lower priority tasks
> > will still have to wait on higher priority tasks, but the system should
> > still balance out because there is always the possibility that if there
> > are both a high and low priority RT tasks on a given CPU that the high
> > priority task could wakeup while the low priority task is running and
> > force it to search for a better runqueue.
> > 
> 
> Looks good, but do you have a test case that shows the issue? I like to
> have something that proves even the obvious before making changes to the
> schedule.

I don't have a test case that I can share at the moment, but this is an
issue that we were seeing with the workload on our production systems.
An example workload was with 24 SCHED_FIFO processes of equal priority
on a 24 hyperthread system.  Each process runs frequently but normally
for ~10us, and it is often possible to put 2-3 processes on a CPU with
few collisions.  The problem is that roughly every couple of milliseconds
one of the processes may run for ~200-300us.  If there are more than one
of these processes on a CPU during one of these longer runs then it
almost always results in the second process seeing a wakeup latency of
up to 250us.  When I'd capture some of these latencies with
trace-cmd/kernelshark you would see a couple processes all on the same
CPU and a couple of idle CPUs.

I'll also note that I did see cases where the process waiting in the run
queue would eventually migrate to a new CPU if the process currently
running took too long.  This seemed to happen around the 250us point.

> If not, I probably could write a test case to trigger this.

I played around a little this morning trying to make a simple test case
that reproduces the issue, but so far I've been unsuccessful.  My simple
test cases trying to simulate the workload above actually do get evenly
distributed across all CPUs.  If I get some more time I'll see if I can
get an example to trigger the issue, but feel free to see if you can
reproduce it as well.

Thanks,
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

