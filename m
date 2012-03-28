Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2C1NL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:11:56 -0400
Received: from relay1.sgi.com ([192.48.179.29]:35273 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab2C1NLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:11:54 -0400
Date: Wed, 28 Mar 2012 08:11:49 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 08/32] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
Message-ID: <20120328131149.GA16417@sgi.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <1332338318-5958-10-git-send-email-fweisbec@gmail.com>
 <alpine.DEB.2.00.1203210950500.20482@router.home>
 <20120327105034.GA13196@somewhere>
 <alpine.DEB.2.00.1203271106130.1170@router.home>
 <1332866823.16159.246.camel@twins>
 <alpine.DEB.2.00.1203271943320.11825@router.home>
 <1332923983.2528.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332923983.2528.12.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 10:39:43AM +0200, Peter Zijlstra wrote:
> On Tue, 2012-03-27 at 20:12 -0500, Christoph Lameter wrote:
> > On Tue, 27 Mar 2012, Peter Zijlstra wrote:
> > 
> > > On Tue, 2012-03-27 at 11:08 -0500, Christoph Lameter wrote:
> > > >
> > > > I wish you would disentangle the nohz work from the cpusets. Cpusets is
> > > > aged and being replaced by cgroups. And the cgroup work is something that
> > > > is not suitable for many loads given the VM overhead added.
> > >
> > > What VM overhead? Are you talking about the memcg nonsense? That's
> > > entirely optional, you don't need to either build that or enable it.
> > 
> > cgroups in general cause a much more complex VM processing with multiple
> > LRUs and additional checks in various places.
> 
> Uhm, not if you don't have the memcg thing enabled, the controllers are
> separate.
> 
> > Even just adding cpusets enables the group scheduler functionality f.e.
> > which creates significantly larger scheduling latencies. Also complicates
> > key allocation VM paths etc etc.
> 
> No, you're mistaken.
> 
> Its perfectly possible to compile a kernel with
> 
> CONFIG_CGROUPS=y
> CONFIG_CPUSETS=y
> CONFIG_CGROUP_MEM_RES_CTLR=n
> CONFIG_CGROUP_SCHED=n
> 
> That will give you cpusets, but not the cpu (sched) controller crap and
> not the memcg (vm) controller muck.
> 
> > > And if we ever get rid of that multiple hierarchy nonsense I don't see a
> > > reason to get rid of cpuset at all. The only reason to want to replace
> > > it is to avoid the dis-joint-ness it has with the cpu controller (and
> > > possible the memcg one).
> > 
> > I like cpusets much more than cgroups. I agree with you.
> 
> cpusets is a cgroup controller..
> 
> > But I am not sure that cpusets are needed for nohz. We already have an
> > isolcpu set and it sounds to me that nohz is generally useful.
> 
> I really really want to kill isolcpu in favour of cpusets, the amount of
> disparity and overlap in features is driving me insane.
> 
> isolcpu will only create separate cpus, you can do the same with cpusets
> by creating 1 cpu sets and disabling load_balance on the root set.
> 
> The only difference is that isolcpu will never have had a task running
> on the cpu and hence its timer lists etc will be guaranteed empty. So
> once we add an interface to push away and/or wait for a cpu to quiesce
> we should end up with the same state.

That is the main reason why I've been in favor of keeping isolcpus.  If there
was some way to cleanup the timer lists, etc.. in a cpuset, then I would use
that in place of isolcpus.

However, I suggested something to move timers quite a while back and it
met with resistance (due to having to ensure that every timer was not somehow
constrained to a single cpu).

> 
> At that point I'll rip isolcpu out. 
> 
> > It would seem that the nohz patches would be much simpler if it would not
> > require cpusets to administer. The only thing that would be needed is to
> > have one cpu that is not subject to nohz. The logical choice is a
> > timekeeper cpu (which is usually cpu 0). Having that configurable would be
> > an extra bonus.
> 
> Like Frederic has been telling, the nohz stuff adds syscall overhead, it
> needs to timestamp on kernel entry/exit etc.. Making it unconditional
> will add this overhead to everybody and this might not be acceptable.
> 
> 
