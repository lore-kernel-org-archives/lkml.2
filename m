Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab0CaKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:25:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:50497 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab0CaKZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:25:24 -0400
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100308221946.842728363@sbs-t61.sc.intel.com>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 12:25:19 +0200
Message-ID: <1270031119.5003.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 14:19 -0800, Suresh Siddha wrote:
> plain text document attachment (fix_wake_affine.patch)
> On a single cpu system with SMT, in the scenario of one SMT thread being
> idle with another SMT thread running a task and doing a non sync wakeup of
> another task, we see (from the traces) that the woken up task ends up running
> on the busy thread instead of the idle thread. Idle balancing that comes
> in little bit later is fixing the scernaio.
> 
> But fixing this wake balance and running the woken up task directly on the
> idle SMT thread improved the performance (phoronix 7zip compression workload)
> by ~9% on an atom platform.
> 
> During the process wakeup, select_task_rq_fair() and wake_affine() makes
> the decision to wakeup the task either on the previous cpu that the task
> ran or the cpu that the task is currently woken up.
> 
> select_task_rq_fair() also goes through to see if there are any idle siblings
> for the cpu that the task is woken up on. This is to ensure that we select
> any idle sibling rather than choose a busy cpu.
> 
> In the above load scenario, it so happens that the prev_cpu (that the
> task ran before) and this_cpu (where it is woken up currently) are the same. And
> in this case, it looks like wake_affine() returns 0 and ultimately not selecting
> the idle sibling chosen by select_idle_sibling() in select_task_rq_fair().
> Further down the path of select_task_rq_fair(), we ultimately select
> the currently running cpu (busy SMT thread instead of the idle SMT thread).
> 
> Check for prev_cpu == this_cpu before calling wake_affine() and no need to do
> any fancy stuff(and ultimately taking wrong decisions) in this case.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> Changes from v1:
>    Move the "this_cpu == prev_cpu" check before calling wake_affine()
> ---
>  kernel/sched_fair.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Index: tip/kernel/sched_fair.c
> ===================================================================
> --- tip.orig/kernel/sched_fair.c
> +++ tip/kernel/sched_fair.c
> @@ -1454,6 +1454,7 @@ static int select_task_rq_fair(struct ta
>  	int want_affine = 0;
>  	int want_sd = 1;
>  	int sync = wake_flags & WF_SYNC;
> +	int this_cpu = cpu;
>  
>  	if (sd_flag & SD_BALANCE_WAKE) {
>  		if (sched_feat(AFFINE_WAKEUPS) &&
> @@ -1545,8 +1546,10 @@ static int select_task_rq_fair(struct ta
>  			update_shares(tmp);
>  	}
>  
> -	if (affine_sd && wake_affine(affine_sd, p, sync))
> -		return cpu;
> +	if (affine_sd) {
> +		if (this_cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> +			return cpu;
> +	}
>  
>  	while (sd) {
>  		int load_idx = sd->forkexec_idx;
> 

Right, so we since merged 8b911acd, in which Mike did almost this but
not quite, the question is over: cpu == prev_cpu vs this_cpu ==
prev_cpu.

Mike seems to see some workloads regress with the this_cpu check, does
your workload work with the cpu == prev_cpu one?

