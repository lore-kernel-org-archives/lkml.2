Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2H0TH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 15:07:59 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37724 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2H0TH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 15:07:57 -0400
Subject: Re: [RFC PATCH 1/1] fair.c: Add/Export find_idlest_perfer_cpu API
From: Shirley Ma <mashirle@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        sri@us.ibm.com, vivek@us.ibm.com
In-Reply-To: <1345532820.23018.81.camel@twins>
References: <1345232770.16533.234.camel@oc3660625478.ibm.com>
	 <1345464035.23018.38.camel@twins>
	 <1345501041.6378.10.camel@oc3660625478.ibm.com>
	 <1345532820.23018.81.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Aug 2012 12:07:34 -0700
Message-ID: <1346094454.4311.10.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082719-7408-0000-0000-000007F3935F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 09:07 +0200, Peter Zijlstra wrote:
> On Mon, 2012-08-20 at 15:17 -0700, Shirley Ma wrote:
> > On Mon, 2012-08-20 at 14:00 +0200, Peter Zijlstra wrote:
> > > On Fri, 2012-08-17 at 12:46 -0700, Shirley Ma wrote:
> > > > Add/Export a new API for per-cpu thread model networking device
> > > driver
> > > > to choose a preferred idlest cpu within allowed cpumask.
> > > > 
> > > > The receiving CPUs of a networking device are not under cgroup
> > > controls.
> > > > Normally the receiving work will be scheduled on the cpu on
> which
> > > the
> > > > interrupts are received. When such a networking device uses
> per-cpu
> > > > thread model, the cpu which is chose to process the packets
> might
> > > not be
> > > > part of cgroup cpusets without using such an API here. 
> > > > 
> > > > On NUMA system, by using the preferred cpumask from the same
> NUMA
> > > node
> > > > would help to reduce expensive cross memory access to/from the
> other
> > > > NUMA node.
> > > > 
> > > > KVM per-cpu vhost will be the first one to use this API. Any
> other
> > > > device driver which uses per-cpu thread model and has cgroup
> cpuset
> > > > control will use this API later.
> > > 
> > > How often will this be called and how do you obtain the cpumasks
> > > provided to the function? 
> > 
> > It depends. It might be called pretty often if the user keeps
> changing
> > cgroups control cpuset. It might be less called if the cgroups
> control
> > cpuset is stable, and the host scheduler always schedules the work
> on
> > the same NUMA node.
> This just doesn't make any sense, you're scanning for the least loaded
> cpu, this is unrelated to a change in cpuset. So tying the scan
> frequency to changes in configuration is just broken.

Thanks for your review. I am just back from my vacation. 

Why not? the caller knows the cpuset changes, and pass the right NUMA
node to choose the idlest cpu from that NUMA node. Practically, the VMs
don't change the cgroups. So it will not frequency to change the
configuration.

> > The preferred cpumasks are obtained from local numa node.
> 
> So why pass it as argument at all? Also, who says the current node is
> the right one? It might just be running there temporarily.

It leaves to the caller to make the right node choice. It tries to avoid
VMs running on the same cpu but on the same node with the host to
process the guest network packets.

> >  The allowed
> > cpumasks are obtained from caller's task allowed cpumasks (cgroups
> > control cpuset).
> 
> task->cpus_allowed != cpusets.. Also, since you're using
> task->cpus_allowed, pass a task_struct *, not a cpumask. 

Based on the documentation I read before, I thought the cpus_allowed ==
cgroups control cpuset. If not, where are the cgroups control cpusets
saved?

task->cpus_allowed = tsk_cpus_allowed(task_struct *p), which is
cpumask_t.

I can change the argument from cpumask to task_struct *, and call
tsk_cpus_allowed() instead of using task->cpus_allowed.

Thanks
Shirley



