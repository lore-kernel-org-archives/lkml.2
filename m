Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2IJOqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:46:35 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:52600 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2IJOqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:46:32 -0400
Message-ID: <504DFC79.9010307@linux.vnet.ibm.com>
Date: Mon, 10 Sep 2012 20:13:05 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com> <500D2162.8010209@redhat.com> <1347023509.10325.53.camel@oc6622382223.ibm.com> <504A37B0.7020605@linux.vnet.ibm.com> <1347046931.7332.51.camel@oc2024037011.ibm.com>
In-Reply-To: <1347046931.7332.51.camel@oc2024037011.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12091014-1396-0000-0000-000001DA2222
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2012 01:12 AM, Andrew Theurer wrote:
> On Fri, 2012-09-07 at 23:36 +0530, Raghavendra K T wrote:
>> CCing PeterZ also.
>>
>> On 09/07/2012 06:41 PM, Andrew Theurer wrote:
>>> I have noticed recently that PLE/yield_to() is still not that scalable
>>> for really large guests, sometimes even with no CPU over-commit.  I have
>>> a small change that make a very big difference.
[...]
>> We are indeed avoiding CPUS in guest mode when we check
>> task->flags&  PF_VCPU in vcpu_on_spin path.  Doesn't that suffice?
> My understanding is that it checks if the candidate vcpu task is in
> guest mode (let's call this vcpu g1vcpuN), and that vcpu will not be a
> target to yield to if it is already in guest mode.  I am concerned about
> a different vcpu, possibly from a different VM (let's call it g2vcpuN),
> but it also located on the same runqueue as g1vcpuN -and- running.  That
> vcpu, g2vcpuN, may also be doing a directed yield, and it may already be
> holding the rq lock.  Or it could be in guest mode.  If it is in guest
> mode, then let's still target this rq, and try to yield to g1vcpuN.
> However, if g2vcpuN is not in guest mode, then don't bother trying.

- If a non vcpu task was currently running, this change can ignore 
request to yield to a target vcpu. The target vcpu could be the most 
eligible vcpu causing other vcpus to do ple exits.
Is it possible to modify the check to deal with only vcpu tasks?

- Should we use p_rq->cfs_rq->skip instead to let us know that some 
yield was active at this time?

-

Cpu 1              cpu2                     cpu3
a1                  a2                        a3
b1                  b2                        b3
                     c2(yield target of a1)    c3(yield target of a2)

If vcpu a1 is doing directed yield to vcpu c2; current vcpu a2 on target 
cpu is also doing a directed yield(to some vcpu c3). Then this change 
will only allow vcpu a2 will do a schedule() to b2 (if a2 -> c3 yield is 
successful). Do we miss yielding to a vcpu c2?
a1 might not find a suitable vcpu to yield and might go back to 
spinning. Is my understanding correct?

> Patch include below.
>
> Here's the new, v2 result with the previous two:
>
> 10 VMs, 16-way each, all running dbench (2x cpu over-commit)
>              throughput +/- stddev
>                   -----     -----
> ple on:           2552 +/- .70%
> ple on: w/fixv1:  4621 +/- 2.12%  (81% improvement)
> ple on: w/fixv2:  6115*           (139% improvement)
>

The numbers look great.

> [*] I do not have stdev yet because all 10 runs are not complete
>
> for v1 to v2, host CPU dropped from 60% to 50%.  Time in spin_lock() is
> also dropping:
>
[...]
>
> So this seems to be working.  However I wonder just how far we can take
> this.  Ideally we need to be in<3-4% in host for PLE work, like I
> observe for the 8-way VMs.  We are still way off.
>
> -Andrew
>
>
> signed-off-by: Andrew Theurer<habanero@linux.vnet.ibm.com>
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fbf1fd0..c767915 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4844,6 +4844,9 @@ bool __sched yield_to(struct task_struct *p, bool
> preempt)
>
>   again:
>   	p_rq = task_rq(p);
> +	if (task_running(p_rq, p) || p->state || !(p_rq->curr->flags&
> PF_VCPU)) {

While we are checking the flags of p_rq->curr task, the task p can 
migrate to some other runqueue. In this case will we miss yielding to 
the most eligible vcpu?

> +		goto out_no_unlock;
> +	}

Nit:
We dont need parenthesis above.

