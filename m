Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2IZNUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:20:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab2IZNUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:20:32 -0400
Date: Wed, 26 Sep 2012 15:20:14 +0200
From: Andrew Jones <drjones@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
Message-ID: <20120926132013.GB7633@turtle.usersys.redhat.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
 <1348486479.11847.46.camel@twins>
 <50604988.2030506@linux.vnet.ibm.com>
 <1348490165.11847.58.camel@twins>
 <50606050.309@linux.vnet.ibm.com>
 <1348494895.11847.64.camel@twins>
 <50608176.1040805@redhat.com>
 <1348502600.11847.90.camel@twins>
 <5060883C.4050901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5060883C.4050901@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 06:20:12PM +0200, Avi Kivity wrote:
> On 09/24/2012 06:03 PM, Peter Zijlstra wrote:
> > On Mon, 2012-09-24 at 17:51 +0200, Avi Kivity wrote:
> >> On 09/24/2012 03:54 PM, Peter Zijlstra wrote:
> >> > On Mon, 2012-09-24 at 18:59 +0530, Raghavendra K T wrote:
> >> >> However Rik had a genuine concern in the cases where runqueue is not
> >> >> equally distributed and lockholder might actually be on a different run 
> >> >> queue but not running.
> >> > 
> >> > Load should eventually get distributed equally -- that's what the
> >> > load-balancer is for -- so this is a temporary situation.
> >> 
> >> What's the expected latency?  This is the whole problem.  Eventually the
> >> scheduler would pick the lock holder as well, the problem is that it's
> >> in the millisecond scale while lock hold times are in the microsecond
> >> scale, leading to a 1000x slowdown.
> > 
> > Yeah I know.. Heisenberg's uncertainty applied to SMP computing becomes
> > something like accurate or fast, never both.
> > 
> >> If we want to yield, we really want to boost someone.
> > 
> > Now if only you knew which someone ;-) This non-modified guest nonsense
> > is such a snake pit.. but you know how I feel about all that.
> 
> Actually if I knew that in addition to boosting someone, I also unboost
> myself enough to be preempted, it wouldn't matter.  While boosting the
> lock holder is good, the main point is not spinning and doing useful
> work instead.  We can detect spinners and avoid boosting them.
> 
> That's the motivation for the "donate vruntime" approach I wanted earlier.

I'll probably get shot for the suggestion, but doesn't this problem merit
another scheduler class? We want FIFO order for a special class of tasks,
"spinners". Wouldn't a clean solution be to promote a task's scheduler
class to the spinner class when we PLE (or come from some special syscall
for userspace spinlocks?)? That class would be higher priority than the
fair class and would schedule in FIFO order, but it would only run its
tasks for short periods before switching. Also, after each task is run
its scheduler class would get reset down to its original class (fair).
At least at first thought this looks to me to be cleaner than the next
and skip hinting, plus it helps guarantee that the lock holder gets
scheduled before the tasks waiting on that lock.

Drew

> 
> > 
> >> > We already try and favour the non running vcpu in this case, that's what
> >> > yield_to_task_fair() is about. If its still not eligible to run, tough
> >> > luck.
> >> 
> >> Crazy idea: instead of yielding, just run that other vcpu in the thread
> >> that would otherwise spin.  I can see about a million objections to this
> >> already though.
> > 
> > Yah.. you want me to list a few? :-) It would require synchronization
> > with the other cpu to pull its task -- one really wants to avoid it also
> > running it.
> 
> Yeah, it's quite a horrible idea.
> 
> > 
> > Do this at a high enough frequency and you're dead too.
> > 
> > Anyway, you can do this inside the KVM stuff, simply flip the vcpu state
> > associated with a vcpu thread and use the preemption notifiers to sort
> > things against the scheduler or somesuch.
> 
> That's what I thought when I wrote this, but I can't, I might be
> preempted in random kvm code.  So my state includes the host stack and
> registers.  Maybe we can special-case when we interrupt guest mode.
> 
> > 
> >> >> Do you think instead of using rq->nr_running, we could get a global 
> >> >> sense of load using avenrun (something like avenrun/num_onlinecpus) 
> >> > 
> >> > To what purpose? Also, global stuff is expensive, so you should try and
> >> > stay away from it as hard as you possibly can.
> >> 
> >> Spinning is also expensive.  How about we do the global stuff every N
> >> times, to amortize the cost (and reduce contention)?
> > 
> > Nah, spinning isn't expensive, its a waste of time, similar end result
> > for someone who wants to do useful work though, but not the same cause.
> > 
> > Pick N and I'll come up with a scenario for which its wrong ;-)
> 
> Sure.  But if it's rare enough, then that's okay for us.
> 
> > Anyway, its an ugly problem and one I really want to contain inside the
> > insanity that created it (virt), lets not taint the rest of the kernel
> > more than we need to. 
> 
> Agreed.  Though given that postgres and others use userspace spinlocks,
> maybe it's not just virt.
> 
> -- 
> error compiling committee.c: too many arguments to function
