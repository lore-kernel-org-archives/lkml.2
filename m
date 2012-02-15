Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2BOL7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:59:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:39612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2BOL7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:59:42 -0500
Message-ID: <1329307161.2293.66.camel@twins>
Subject: Re: sched: Performance of Trade workload running inside VM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 12:59:21 +0100
In-Reply-To: <20120214112827.GA22653@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 16:58 +0530, Srivatsa Vaddagiri wrote:

> This lead me to investigate the wakeup code path closely and in
> particular select_idle_sibling(). select_idle_sibling() looks for a core
> that is fully idle, failing which causes the task to wakeup on prev_cpu
> (or cur_cpu). In particular, it does not go hunt for the least loaded
> cpu, which is what SD_BALANCE_WAKE provides.
> 
> It seemed to me that we could have SD_BALANCE_WAKE enabled in SMT/MC
> domains atleast without losing on cache benefits. However Peterz seems
> to have noted that SD_BALANCE_WAKE can hurt sysbench.


> I have tried coming up with something that allows us to keep
> SD_BALANCE_WAKE enabled at smt/mc domains, not hurt sysbench and
> also help the Trade benchmark that I had begun investigating. The patch
> falls back to SD_BALANCE_WAKE type balance when the cpu returned by
> select_idle_cpu() is not idle.


> Index: linux-3.3-rc3-tip-a80142eb/kernel/sched/fair.c
> ===================================================================
> --- linux-3.3-rc3-tip-a80142eb.orig/kernel/sched/fair.c
> +++ linux-3.3-rc3-tip-a80142eb/kernel/sched/fair.c
> @@ -2783,7 +2783,9 @@ select_task_rq_fair(struct task_struct *
>  			prev_cpu = cpu;
>  
>  		new_cpu = select_idle_sibling(p, prev_cpu);
> -		goto unlock;
> +		if (idle_cpu(new_cpu))
> +			goto unlock;
> +		sd = rcu_dereference(per_cpu(sd_llc, prev_cpu));
>  	}
>  
>  	while (sd) {

Right, so the problem with this is that it might defeat wake_affine,
wake_affine tries to pull a task towards it wakeup source (irrespective
of idleness thereof).

Also, wake_balance is somewhat expensive, which seems like a bad thing
considering your workload is already wakeup heavy.

That said, there was a lot of text in your email which hid what your
actual problem was. So please try again, less words, more actual content
please.
