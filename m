Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2IOQMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 12:12:50 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40953 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2IOQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 12:12:47 -0400
Message-ID: <5054A816.1090807@linux.vnet.ibm.com>
Date: Sat, 15 Sep 2012 21:38:54 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Andrew Theurer <habanero@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
References: <20120908084345.GU30238@linux.vnet.ibm.com> <1347283005.10325.55.camel@oc6622382223.ibm.com> <1347293035.2124.22.camel@twins> <20120910165653.GA28033@linux.vnet.ibm.com> <1347297124.2124.42.camel@twins> <1347307972.7332.78.camel@oc2024037011.ibm.com> <504ED54E.6040608@linux.vnet.ibm.com> <1347388061.19098.20.camel@oc2024037011.ibm.com> <20120913114813.GA11797@linux.vnet.ibm.com> <1347571858.5586.44.camel@oc2024037011.ibm.com> <20120914171038.GB8834@turtle.usersys.redhat.com>
In-Reply-To: <20120914171038.GB8834@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12091516-1618-0000-0000-0000027BD17F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 10:40 PM, Andrew Jones wrote:
> On Thu, Sep 13, 2012 at 04:30:58PM -0500, Andrew Theurer wrote:
>> On Thu, 2012-09-13 at 17:18 +0530, Raghavendra K T wrote:
>>> * Andrew Theurer<habanero@linux.vnet.ibm.com>  [2012-09-11 13:27:41]:
>>>
[...]
>>
>> On picking a better vcpu to yield to:  I really hesitate to rely on
>> paravirt hint [telling us which vcpu is holding a lock], but I am not
>> sure how else to reduce the candidate vcpus to yield to.  I suspect we
>> are yielding to way more vcpus than are prempted lock-holders, and that
>> IMO is just work accomplishing nothing.  Trying to think of way to
>> further reduce candidate vcpus....
>>
>
> wrt to yielding to vcpus for the same cpu, I recently noticed that
> there's a bug in yield_to_task_fair. yield_task_fair() calls
> clear_buddies(), so if we're yielding to a task that has been running on
> the same cpu that we're currently running on, and thus is also on the
> current cfs runqueue, then our 'who to pick next' hint is getting cleared
> right after we set it.
>
> I had hoped that the patch below would show a general improvement in the
> vpu overcommit performance, however the results were variable - no worse,
> no better. Based on your results above showing good improvement from
> interleaving vcpus across the cpus, then that means there was a decent
> percent of these types of yields going on. So since the patch didn't
> change much that indicates that the next hinting isn't generally taken
> too seriously by the scheduler.  Anyway, the patch should correct the
> code per its design, and testing shows that it didn't make anything worse,
> so I'll post it soon. Also, in order to try and improve how far set-next
> can jump ahead in the queue, I tested a kernel with group scheduling
> compiled out (libvirt uses cgroups and I'm not sure autogroups may affect
> things). I did get slight improvement with that, but nothing to write home
> to mom about.
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c219bf8..7d8a21d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3037,11 +3037,12 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
>   	if (!se->on_rq || throttled_hierarchy(cfs_rq_of(se)))
>   		return false;
>
> +	/* We're yielding, so tell the scheduler we don't want to be picked */
> +	yield_task_fair(rq);
> +
>   	/* Tell the scheduler that we'd really like pse to run next. */
>   	set_next_buddy(se);
>
> -	yield_task_fair(rq);
> -
>   	return true;
>   }
>

Hi Drew,  Agree with your fix and tested the patch too.. results are
pretty much same.  puzzled why so.

thinking ... may be we hit this when #vcpu (of a  VM) > #pcpu?
(pigeonhole principle ;)).

