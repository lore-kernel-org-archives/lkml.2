Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab2HQQQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:16:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49034 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343Ab2HQQQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:16:03 -0400
Date: Fri, 17 Aug 2012 18:15:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Neuling <mikey@neuling.org>
Cc: K Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: powerpc/perf: hw breakpoints return ENOSPC
Message-ID: <20120817161554.GA3772@somewhere>
References: <28857.1345091034@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28857.1345091034@neuling.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 02:23:54PM +1000, Michael Neuling wrote:
> Hi,
> 
> I've been trying to get hardware breakpoints with perf to work on POWER7
> but I'm getting the following:
> 
>   % perf record -e mem:0x10000000 true
> 
>     Error: sys_perf_event_open() syscall returned with 28 (No space left on device).  /bin/dmesg may provide additional information.
> 
>     Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> 
>   true: Terminated
> 
> (FWIW adding -a and it works fine)
> 
> Debugging it seems that __reserve_bp_slot() is returning ENOSPC because
> it thinks there are no free breakpoint slots on this CPU.
> 
> I have a 2 CPUs, so perf userspace is doing two perf_event_open syscalls
> to add a counter to each CPU [1].  The first syscall succeeds but the
> second is failing.
> 
> On this second syscall, fetch_bp_busy_slots() sets slots.pinned to be 1,
> despite there being no breakpoint on this CPU.  This is because the call
> the task_bp_pinned, checks all CPUs, rather than just the current CPU.
> POWER7 only has one hardware breakpoint per CPU (ie. HBP_NUM=1), so we
> return ENOSPC.
> 
> The following patch fixes this by checking the associated CPU for each
> breakpoint in task_bp_pinned.  I'm not familiar with this code, so it's
> provided as a reference to the above issue.
> 
> Mikey
> 
> 1. not sure why it doesn't just do one syscall and specify all CPUs, but
> that's another issue.  Using two syscalls should work.

This patch seems to make sense. I'll try it and run some tests.
Can I have your Signed-off-by ?

Thanks.

> 
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index bb38c4d..e092daa 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -111,14 +111,16 @@ static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
>   * Count the number of breakpoints of the same type and same task.
>   * The given event must be not on the list.
>   */
> -static int task_bp_pinned(struct perf_event *bp, enum bp_type_idx type)
> +static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
>  {
>  	struct task_struct *tsk = bp->hw.bp_target;
>  	struct perf_event *iter;
>  	int count = 0;
>  
>  	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
> -		if (iter->hw.bp_target == tsk && find_slot_idx(iter) == type)
> +		if (iter->hw.bp_target == tsk &&
> +		    find_slot_idx(iter) == type &&
> +		    cpu == iter->cpu)
>  			count += hw_breakpoint_weight(iter);
>  	}
>  
> @@ -141,7 +143,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
>  		if (!tsk)
>  			slots->pinned += max_task_bp_pinned(cpu, type);
>  		else
> -			slots->pinned += task_bp_pinned(bp, type);
> +			slots->pinned += task_bp_pinned(cpu, bp, type);
>  		slots->flexible = per_cpu(nr_bp_flexible[type], cpu);
>  
>  		return;
> @@ -154,7 +156,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
>  		if (!tsk)
>  			nr += max_task_bp_pinned(cpu, type);
>  		else
> -			nr += task_bp_pinned(bp, type);
> +			nr += task_bp_pinned(cpu, bp, type);
>  
>  		if (nr > slots->pinned)
>  			slots->pinned = nr;
> @@ -188,7 +190,7 @@ static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
>  	int old_idx = 0;
>  	int idx = 0;
>  
> -	old_count = task_bp_pinned(bp, type);
> +	old_count = task_bp_pinned(cpu, bp, type);
>  	old_idx = old_count - 1;
>  	idx = old_idx + weight;
>  
