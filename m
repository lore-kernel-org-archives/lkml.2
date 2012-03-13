Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2CMRXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:23:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34633 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758603Ab2CMRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:23:41 -0400
Date: Tue, 13 Mar 2012 10:23:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>, Paul Turner <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Robin Randhawa <Robin.Randhawa@arm.com>,
        linaro-sched-sig@lists.linaro.org
Subject: Re: [RFC PATCH 00/14] sched: entity load-tracking re-work
Message-ID: <20120313172325.GL2349@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120312103927.GB25134@e103034-lin.cambridge.arm.com>
 <20120313164403.GJ2349@linux.vnet.ibm.com>
 <CAJL_dMtfs8nu+1YD86iZqf_ozbvPMAjc58JF=J4+aH9dD_GD5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJL_dMtfs8nu+1YD86iZqf_ozbvPMAjc58JF=J4+aH9dD_GD5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031317-6148-0000-0000-000004382D5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 07:08:54PM +0200, Anca Emanuel wrote:
> @Paul E. McKenney: ups, that was some special pgp code ?

Not that I am aware of.  Here is the body of the message again.

							Thanx, Paul

------------------------------------------------------------------------

On Mon, Mar 12, 2012 at 10:39:27AM +0000, Morten Rasmussen wrote:
> On Thu, Feb 02, 2012 at 01:38:26AM +0000, Paul Turner wrote:
> > As referenced above this also allows us to potentially improve decisions within
> > the load-balancer, for both distribution and power-management.
> >
> > Exmaple: consider 1x80% task  and 2x40% tasks on a 2-core machine. It's
> > currently a bit of a gamble as to whether you get an {AB, B} or {A,
> > BB} split since they have equal weight (assume 1024).  With per-task
> > tracking we can actually consider them at their contributed weight and
> > see a stable ~{800,{400, 400}} load-split.  Likewise within balance_tasks we can
> > consider the load migrated to be that actually contributed.
> 
> Hi Paul (and LKML),

Hello, Morten!

> As a follow up to the discussions held during the scheduler mini-summit
> at the last Linaro Connect I would like to share what I (working for
> ARM) have observed so far in my experiments with big.LITTLE scheduling.
> 
> I see task affinity on big.LITTLE systems as a combination of
> user-space affinity (via cgroups+cpuset etc) and introspective affinity
> as result of intelligent load balancing in the scheduler. I see the
> entity load tracking in this patch set as a step towards the latter. I
> am very interested in better task profiling in the scheduler as this is
> crucial for selecting which tasks that should go on which type of core.
> 
> I am using the patches for some very crude experiments with scheduling
> on big.LITTLE to explore possibilities and learn about potential issues.
> What I want to achieve is that high priority CPU-intensive tasks will
> be scheduled on fast and less power-efficient big cores and background
> tasks will be scheduled on power-efficient little cores. At the same
> time I would also like to minimize the performance impact experienced
> by the user. The following is a summary of the observation that I have
> made so far. I would appreciate comments and suggestions on the best way
> to go from here.
> 
> I have set up two sched_domains on a 4-core ARM system with two cores
> each that represents big and little clusters and disabled load balancing
> between them. The aim is to separate heavy and high priority tasks from
> less important tasks using the two domains. Based on load_avg_contrib
> tasks will be assigned to one of the domains by select_task_rq().
> However, this does not work out very well. If a task in the little
> domain suddenly consumes more CPU time and never goes to sleep it will
> never get the chance to migrate to the big domain. On a homogeneous
> system it doesn't really matter _where_ a task goes if imbalance is
> unavoidable as all cores have equal performance. For heterogeneous
> systems like big.LITTLE it makes a huge difference. To mitigate this
> issue I am periodically checking the currently running task on each
> little core to see if a CPU-intensive task is stuck there. If there is
> it will be migrated to a core in the big domain using
> stop_one_cpu_nowait() similar to the active load balance mechanism. It
> is not a pretty solution, so I am open for suggestions. Furthermore, by
> only checking the current task there is a chance of missing busy tasks
> waiting on the runqueue but checking the entire runqueue seems too
> expensive.
> 
> My observations are based on a simple mobile workload modelling web
> browsing. That is basically two threads waking up occasionally to render
> a web page. Using my current setup the most CPU intensive of the two
> will be scheduled on the big cluster as intended. The remaining
> background threads are always on the little cluster leaving the big
> cluster idle when it is not rendering to save power. The
> task-stuck-on-little problem can most easily be observed with CPU
> intensive workloads such the sysbench CPU workload.
> 
> I have looked at traces of both runnable time and usage time trying to
> understand why you use runnable time as your load metric and not usage
> time which seems more intuitive. What I see is that runnable time
> depends on the total runqueue load. If you have many tasks on the
> runqueue they will wait longer and therefore have higher individual
> load_avg_contrib than they would if the were scheduled across more CPUs.
> Usage time is also affected by the number of tasks on the runqueue as
> more tasks means less CPU time. However, less usage can also just mean
> that the task does not execute very often. This would make a load
> contribution estimate based on usage time less accurate. Is this your
> reason for choosing runnable time?

It might be a tradeoff between accuracy of scheduling and CPU cost of
scheduling, but I have to defer to Peter Z, Paul Turner, and the rest
of the scheduler guys on this one.

							Thanx, Paul

> Do you have any thoughts or comments on how entity load tracking could
> be applied to introspectively select tasks for appropriate CPUs in
> system like big.LITTLE?
> 
> Best regards,
> Morten
> 

