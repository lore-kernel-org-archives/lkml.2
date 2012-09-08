Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2IHIrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 04:47:14 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51010 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2IHIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 04:47:11 -0400
Date: Sat, 8 Sep 2012 14:13:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Andrew Theurer <habanero@linux.vnet.ibm.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE
 handler
Message-ID: <20120908084345.GU30238@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
 <500D2162.8010209@redhat.com>
 <1347023509.10325.53.camel@oc6622382223.ibm.com>
 <504A37B0.7020605@linux.vnet.ibm.com>
 <1347046931.7332.51.camel@oc2024037011.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1347046931.7332.51.camel@oc2024037011.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12090808-8878-0000-0000-000003EDFF1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> signed-off-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fbf1fd0..c767915 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4844,6 +4844,9 @@ bool __sched yield_to(struct task_struct *p, bool
> preempt)
> 
>  again:
>  	p_rq = task_rq(p);
> +	if (task_running(p_rq, p) || p->state || !(p_rq->curr->flags &
> PF_VCPU)) {
> +		goto out_no_unlock;
> +	}
>  	double_rq_lock(rq, p_rq);
>  	while (task_rq(p) != p_rq) {
>  		double_rq_unlock(rq, p_rq);
> @@ -4856,8 +4859,6 @@ again:
>  	if (curr->sched_class != p->sched_class)
>  		goto out;
> 
> -	if (task_running(p_rq, p) || p->state)
> -		goto out;

Is it possible that by this time the current thread takes double rq
lock, thread p could actually be running?  i.e is there merit to keep
this check around even with your similar check above?

> 
>  	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
>  	if (yielded) {
> @@ -4879,6 +4880,7 @@ again:
> 
>  out:
>  	double_rq_unlock(rq, p_rq);
> +out_no_unlock:
>  	local_irq_restore(flags);
> 
>  	if (yielded)
> 
> 

-- 
thanks and regards
Srikar

