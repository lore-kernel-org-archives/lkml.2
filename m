Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2KYTJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 14:09:41 -0500
Received: from mail1.windriver.com ([147.11.146.13]:45169 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2KYTJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 14:09:39 -0500
Date: Sun, 25 Nov 2012 14:09:09 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3] cputime: Consolidate cputime adjustment code
Message-ID: <20121125190909.GA1866@windriver.com>
References: <1353680484-7302-1-git-send-email-fweisbec@gmail.com>
 <1353680484-7302-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1353680484-7302-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH 3/3] cputime: Consolidate cputime adjustment code] On 23/11/2012 (Fri 15:21) Frederic Weisbecker wrote:

> task_cputime_adjusted() and thread_group_cputime_adjusted()
> essentially share the same code. They just don't use the same
> source:
> 
> * The first function uses the cputime in the task struct and the
> previous adjusted snapshot that ensures monotonicity.
> 
> * The second adds the cputime of all tasks in the group and the
> previous adjusted snapshot of the whole group from the signal
> structure.
> 
> Just consolidate the common code that does the adjustment. These
> functions just need to fetch the values from the appropriate
> source.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/sched.h  |    9 +++++++--
>  kernel/fork.c          |    2 +-
>  kernel/sched/cputime.c |   46 +++++++++++++++++++++++-----------------------
>  3 files changed, 31 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index e75cab5..d23204f 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -433,6 +433,11 @@ struct cpu_itimer {
>  	u32 incr_error;
>  };
>  
> +struct cputime {
> +	cputime_t utime;
> +	cputime_t stime;
> +};
> +

Hi Frederic,

This new struct cputime is a 2/3 subset of the three variable struct
task_cputime we see right below.  Maybe this is a stupid question, but I
was wondering why you didn't re-use task_cputime, and ignore the
sum_exec_runtime field -- vs. introducing this very similar struct?

Or maybe there is another way to consolidate the structs?  With the
two being so similar, I wonder if it will be confusing when to use which
one of the two.

Thanks,
Paul.
--

/**
 * struct task_cputime - collected CPU time counts
 * @utime:		time spent in user mode, in &cputime_t units
 * @stime:              time spent in kernel mode, in &cputime_t units
 * @sum_exec_runtime:   total time spent on the CPU, in nanoseconds
 *
 * This structure groups together three kinds of CPU time that are
 * tracked for threads and thread groups.  Most things considering
 * CPU time want to group these counts together and treat all three
 * of them in parallel.
 */
struct task_cputime {
        cputime_t utime;
        cputime_t stime;
        unsigned long long sum_exec_runtime;
};

