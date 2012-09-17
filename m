Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2IQNtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:49:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab2IQNtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:49:12 -0400
Date: Mon, 17 Sep 2012 15:48:36 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Andrew Theurer <habanero@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
Message-ID: <20120917134836.GA9770@turtle.usersys.redhat.com>
References: <1347293035.2124.22.camel@twins>
 <20120910165653.GA28033@linux.vnet.ibm.com>
 <1347297124.2124.42.camel@twins>
 <1347307972.7332.78.camel@oc2024037011.ibm.com>
 <504ED54E.6040608@linux.vnet.ibm.com>
 <1347388061.19098.20.camel@oc2024037011.ibm.com>
 <20120913114813.GA11797@linux.vnet.ibm.com>
 <1347571858.5586.44.camel@oc2024037011.ibm.com>
 <20120914171038.GB8834@turtle.usersys.redhat.com>
 <5054A816.1090807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5054A816.1090807@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 09:38:54PM +0530, Raghavendra K T wrote:
> On 09/14/2012 10:40 PM, Andrew Jones wrote:
> >On Thu, Sep 13, 2012 at 04:30:58PM -0500, Andrew Theurer wrote:
> >>On Thu, 2012-09-13 at 17:18 +0530, Raghavendra K T wrote:
> >>>* Andrew Theurer<habanero@linux.vnet.ibm.com>  [2012-09-11 13:27:41]:
> >>>
> [...]
> >>
> >>On picking a better vcpu to yield to:  I really hesitate to rely on
> >>paravirt hint [telling us which vcpu is holding a lock], but I am not
> >>sure how else to reduce the candidate vcpus to yield to.  I suspect we
> >>are yielding to way more vcpus than are prempted lock-holders, and that
> >>IMO is just work accomplishing nothing.  Trying to think of way to
> >>further reduce candidate vcpus....
> >>
> >
> >wrt to yielding to vcpus for the same cpu, I recently noticed that
> >there's a bug in yield_to_task_fair. yield_task_fair() calls
> >clear_buddies(), so if we're yielding to a task that has been running on
> >the same cpu that we're currently running on, and thus is also on the
> >current cfs runqueue, then our 'who to pick next' hint is getting cleared
> >right after we set it.
> >
> >I had hoped that the patch below would show a general improvement in the
> >vpu overcommit performance, however the results were variable - no worse,
> >no better. Based on your results above showing good improvement from
> >interleaving vcpus across the cpus, then that means there was a decent
> >percent of these types of yields going on. So since the patch didn't
> >change much that indicates that the next hinting isn't generally taken
> >too seriously by the scheduler.  Anyway, the patch should correct the
> >code per its design, and testing shows that it didn't make anything worse,
> >so I'll post it soon. Also, in order to try and improve how far set-next
> >can jump ahead in the queue, I tested a kernel with group scheduling
> >compiled out (libvirt uses cgroups and I'm not sure autogroups may affect
> >things). I did get slight improvement with that, but nothing to write home
> >to mom about.
> >
> >diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >index c219bf8..7d8a21d 100644
> >--- a/kernel/sched/fair.c
> >+++ b/kernel/sched/fair.c
> >@@ -3037,11 +3037,12 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
> >  	if (!se->on_rq || throttled_hierarchy(cfs_rq_of(se)))
> >  		return false;
> >
> >+	/* We're yielding, so tell the scheduler we don't want to be picked */
> >+	yield_task_fair(rq);
> >+
> >  	/* Tell the scheduler that we'd really like pse to run next. */
> >  	set_next_buddy(se);
> >
> >-	yield_task_fair(rq);
> >-
> >  	return true;
> >  }
> >
> 
> Hi Drew,  Agree with your fix and tested the patch too.. results are
> pretty much same.  puzzled why so.

Looking at the code I see that the next hint might be used more frequently
if we bump up sysctl/kernel.sched_wakeup_granularity_ns. I also just found
out that some virt tuned profiles do that, so maybe I should try running
with one of those profiles.

> 
> thinking ... may be we hit this when #vcpu (of a  VM) > #pcpu?
> (pigeonhole principle ;)).

Not sure, but I haven't done any experiments where a single VM has >
#vcpus than the system as pcpus. For my vcpu overcommit I increase the
VM count, where each VM has #vcpus <= #pcpus.

Drew
