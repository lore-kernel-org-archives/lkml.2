Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2IQILE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:11:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab2IQIK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:10:58 -0400
Date: Mon, 17 Sep 2012 10:10:43 +0200
From: Andrew Jones <drjones@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: habanero@linux.vnet.ibm.com,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
Message-ID: <20120917081043.GB2104@turtle.usersys.redhat.com>
References: <1347283005.10325.55.camel@oc6622382223.ibm.com>
 <1347293035.2124.22.camel@twins>
 <20120910165653.GA28033@linux.vnet.ibm.com>
 <1347297124.2124.42.camel@twins>
 <1347307972.7332.78.camel@oc2024037011.ibm.com>
 <504ED54E.6040608@linux.vnet.ibm.com>
 <1347388061.19098.20.camel@oc2024037011.ibm.com>
 <20120913114813.GA11797@linux.vnet.ibm.com>
 <1347571858.5586.44.camel@oc2024037011.ibm.com>
 <50559400.8030203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50559400.8030203@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 11:55:28AM +0300, Avi Kivity wrote:
> On 09/14/2012 12:30 AM, Andrew Theurer wrote:
> 
> > The concern I have is that even though we have gone through changes to
> > help reduce the candidate vcpus we yield to, we still have a very poor
> > idea of which vcpu really needs to run.  The result is high cpu usage in
> > the get_pid_task and still some contention in the double runqueue lock.
> > To make this scalable, we either need to significantly reduce the
> > occurrence of the lock-holder preemption, or do a much better job of
> > knowing which vcpu needs to run (and not unnecessarily yielding to vcpus
> > which do not need to run).
> > 
> > On reducing the occurrence:  The worst case for lock-holder preemption
> > is having vcpus of same VM on the same runqueue.  This guarantees the
> > situation of 1 vcpu running while another [of the same VM] is not.  To
> > prove the point, I ran the same test, but with vcpus restricted to a
> > range of host cpus, such that any single VM's vcpus can never be on the
> > same runqueue.  In this case, all 10 VMs' vcpu-0's are on host cpus 0-4,
> > vcpu-1's are on host cpus 5-9, and so on.  Here is the result:
> > 
> > kvm_cpu_spin, and all
> > yield_to changes, plus
> > restricted vcpu placement:  8823 +/- 3.20%   much, much better
> > 
> > On picking a better vcpu to yield to:  I really hesitate to rely on
> > paravirt hint [telling us which vcpu is holding a lock], but I am not
> > sure how else to reduce the candidate vcpus to yield to.  I suspect we
> > are yielding to way more vcpus than are prempted lock-holders, and that
> > IMO is just work accomplishing nothing.  Trying to think of way to
> > further reduce candidate vcpus....
> 
> I wouldn't say that yielding to the "wrong" vcpu accomplishes nothing.
> That other vcpu gets work done (unless it is in pause loop itself) and
> the yielding vcpu gets put to sleep for a while, so it doesn't spend
> cycles spinning.  While we haven't fixed the problem at least the guest
> is accomplishing work, and meanwhile the real lock holder may get
> naturally scheduled and clear the lock.
> 
> The main problem with this theory is that the experiments don't seem to
> bear it out.  So maybe one of the assumptions is wrong - the yielding
> vcpu gets scheduled early.  That could be the case if the two vcpus are
> on different runqueues - you could be changing the relative priority of
> vcpus on the target runqueue, but still remain on top yourself.  Is this
> possible with the current code?
> 
> Maybe we should prefer vcpus on the same runqueue as yield_to targets,
> and only fall back to remote vcpus when we see it didn't help.

I thought about this a bit recently too, but didn't pursue it, because I
figured it would actually increase the get_pid_task and double_rq_lock
contention time if we have to hunt too long for a vcpu that matches a more
strict criteria. But, I guess if we can implement a special "reschedule"
to run on the current cpu which prioritizes runnable/non-running vcpus,
then it should be just as fast or faster for it to look through the
runqueue first, than it is to look through all the vcpus first.

Drew

> 
> Let's examine a few cases:
> 
> 1. spinner on cpu 0, lock holder on cpu 0
> 
> win!
> 
> 2. spinner on cpu 0, random vcpu(s) (or normal processes) on cpu 0
> 
> Spinner gets put to sleep, random vcpus get to work, low lock contention
> (no double_rq_lock), by the time spinner gets scheduled we might have won
> 
> 3. spinner on cpu 0, another spinner on cpu 0
> 
> Worst case, we'll just spin some more.  Need to detect this case and
> migrate something in.
> 
> 4. spinner on cpu 0, alone
> 
> Similar
> 
> 
> It seems we need to tie in to the load balancer.
> 
> Would changing the priority of the task while it is spinning help the
> load balancer?
> 
> -- 
> error compiling committee.c: too many arguments to function
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
