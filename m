Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2IPIzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 04:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab2IPIzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 04:55:46 -0400
Message-ID: <50559400.8030203@redhat.com>
Date: Sun, 16 Sep 2012 11:55:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
References: <504A37B0.7020605@linux.vnet.ibm.com>  <1347046931.7332.51.camel@oc2024037011.ibm.com>  <20120908084345.GU30238@linux.vnet.ibm.com>  <1347283005.10325.55.camel@oc6622382223.ibm.com>  <1347293035.2124.22.camel@twins>  <20120910165653.GA28033@linux.vnet.ibm.com>  <1347297124.2124.42.camel@twins>  <1347307972.7332.78.camel@oc2024037011.ibm.com>  <504ED54E.6040608@linux.vnet.ibm.com>  <1347388061.19098.20.camel@oc2024037011.ibm.com>  <20120913114813.GA11797@linux.vnet.ibm.com> <1347571858.5586.44.camel@oc2024037011.ibm.com>
In-Reply-To: <1347571858.5586.44.camel@oc2024037011.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 12:30 AM, Andrew Theurer wrote:

> The concern I have is that even though we have gone through changes to
> help reduce the candidate vcpus we yield to, we still have a very poor
> idea of which vcpu really needs to run.  The result is high cpu usage in
> the get_pid_task and still some contention in the double runqueue lock.
> To make this scalable, we either need to significantly reduce the
> occurrence of the lock-holder preemption, or do a much better job of
> knowing which vcpu needs to run (and not unnecessarily yielding to vcpus
> which do not need to run).
> 
> On reducing the occurrence:  The worst case for lock-holder preemption
> is having vcpus of same VM on the same runqueue.  This guarantees the
> situation of 1 vcpu running while another [of the same VM] is not.  To
> prove the point, I ran the same test, but with vcpus restricted to a
> range of host cpus, such that any single VM's vcpus can never be on the
> same runqueue.  In this case, all 10 VMs' vcpu-0's are on host cpus 0-4,
> vcpu-1's are on host cpus 5-9, and so on.  Here is the result:
> 
> kvm_cpu_spin, and all
> yield_to changes, plus
> restricted vcpu placement:  8823 +/- 3.20%   much, much better
> 
> On picking a better vcpu to yield to:  I really hesitate to rely on
> paravirt hint [telling us which vcpu is holding a lock], but I am not
> sure how else to reduce the candidate vcpus to yield to.  I suspect we
> are yielding to way more vcpus than are prempted lock-holders, and that
> IMO is just work accomplishing nothing.  Trying to think of way to
> further reduce candidate vcpus....

I wouldn't say that yielding to the "wrong" vcpu accomplishes nothing.
That other vcpu gets work done (unless it is in pause loop itself) and
the yielding vcpu gets put to sleep for a while, so it doesn't spend
cycles spinning.  While we haven't fixed the problem at least the guest
is accomplishing work, and meanwhile the real lock holder may get
naturally scheduled and clear the lock.

The main problem with this theory is that the experiments don't seem to
bear it out.  So maybe one of the assumptions is wrong - the yielding
vcpu gets scheduled early.  That could be the case if the two vcpus are
on different runqueues - you could be changing the relative priority of
vcpus on the target runqueue, but still remain on top yourself.  Is this
possible with the current code?

Maybe we should prefer vcpus on the same runqueue as yield_to targets,
and only fall back to remote vcpus when we see it didn't help.

Let's examine a few cases:

1. spinner on cpu 0, lock holder on cpu 0

win!

2. spinner on cpu 0, random vcpu(s) (or normal processes) on cpu 0

Spinner gets put to sleep, random vcpus get to work, low lock contention
(no double_rq_lock), by the time spinner gets scheduled we might have won

3. spinner on cpu 0, another spinner on cpu 0

Worst case, we'll just spin some more.  Need to detect this case and
migrate something in.

4. spinner on cpu 0, alone

Similar


It seems we need to tie in to the load balancer.

Would changing the priority of the task while it is spinning help the
load balancer?

-- 
error compiling committee.c: too many arguments to function
