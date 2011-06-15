Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1FOAkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:40:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52246 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab1FOAks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:40:48 -0400
Date: Tue, 14 Jun 2011 17:40:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Theurer <habanero@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] sched: Check if lowest_mask is initialized in
 find_lowest_rq
Message-ID: <20110615004045.GU2288@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110614223623.876681637@goodmis.org>
 <20110614223657.824872966@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614223657.824872966@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 06:36:25PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> On system boot up, the lowest_mask is initialized with early_initcall.
> But RT tasks may wake up on other early_initcall callers before the
> lowest_mask is initialized, causing a system crash.
> 
> The commit d72bce0e67 rcu: Cure load woes
> was the first commit to wake up RT tasks in early init. Before this
> commit this bug should not happen.

I never was able to reproduce this, but after adding Shaohua's patch, I
need this one too on some systems.  So:

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Reported-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
> Tested-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
> Link: http://lkml.kernel.org/r/1308014683.9218.107.camel@gandalf.stny.rr.com
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/sched_rt.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 9b8d5dc..10d0182 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1239,6 +1239,10 @@ static int find_lowest_rq(struct task_struct *task)
>  	int this_cpu = smp_processor_id();
>  	int cpu      = task_cpu(task);
> 
> +	/* Make sure the mask is initialized first */
> +	if (unlikely(!lowest_mask))
> +		return -1;
> +
>  	if (task->rt.nr_cpus_allowed == 1)
>  		return -1; /* No other targets possible */
> 
> -- 
> 1.7.4.4
> 
> 
