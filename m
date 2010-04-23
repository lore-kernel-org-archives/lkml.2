Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0DWC7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:59:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:35262 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab0DWC73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:59:29 -0400
Date: Fri, 23 Apr 2010 10:58:50 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: John Kacur <jkacur@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH] lockdep: Add nr_save_trace_invocations counter
Message-ID: <20100423025850.GA21328@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004222208310.3155@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 02:58:52.0669 (UTC) FILETIME=[E7DD52D0:01CAE290]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 10:15:48PM +0200, John Kacur wrote:
> NOT FOR INCLUSION
> 
> I created this patch as a result of Peter Zilstra's request to get more 
> info from lockdep. This patch is not for inclusion, at least in its 
> present form, because it adds some redunant info to /proc/lockdep_stats
> 
> However, some of the fields are new, and it is worth examining, and / or 
> applying if you are looking at the MAX_STACK_TRACE_ENTRIES too big 
> problem.
> 
> I generated this patch against a recent tip/master but it applies without 
> conflicts to the latest rt kernel as well. Comments are welcome, in fact 
> they are appreciated.
> 
> >From 5181c0296dd1549e4e706ff25a4cd81a1d90137d Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Thu, 22 Apr 2010 17:02:42 +0200
> Subject: [PATCH] lockdep: Add nr_save_trace_invocations counter
> 
> Add the nr_save_trace_invocations counter which counts the number of
> time save_trace() is invoked when relevant for trace enteries.
> 
> This means, those invocations from mark_lock() and add_lock_to_list()
> 
> When called from mark_lock() we break it down into LOCKSTATE categories.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Just take a rough look at it. I don't think this can give more info.

> +/* Calls to save_trace() from mark_lock() and add_lock_to_list() only*/
> +unsigned long nr_save_trace_invocations;

It will equal to nr_list_entries.

> +unsigned long nr_save_trace_invocations_type[LOCK_USAGE_STATES];

And each item in this array will equal to nr_hardirq_[un]safe,
nr_softirq_[un]safe and such things under lockdep_stats_show(). Right?

Thanks,
Yong

> +
>  static int save_trace(struct stack_trace *trace)
>  {
>  	trace->nr_entries = 0;
> @@ -410,6 +414,19 @@ static int save_trace(struct stack_trace *trace)
>  	return 1;
>  }
>  
> +/*
> + * This function is only called from mark_lock() and add_lock_to_list()
> + * which are only called when holding the graph_lock. This counter
> + * piggybacks off of that lock
> + */
> +static void inc_save_trace_invocations(enum lock_usage_bit new_bit)
> +{
> +	nr_save_trace_invocations++;
> +	if (WARN_ON(new_bit >= LOCK_USAGE_STATES))
> +		return;
> +	nr_save_trace_invocations_type[new_bit]++;
> +}
> +
>  unsigned int nr_hardirq_chains;
>  unsigned int nr_softirq_chains;
>  unsigned int nr_process_chains;
> @@ -449,6 +466,7 @@ static const char *usage_str[] =
>  #define LOCKDEP_STATE(__STATE) __USAGE(__STATE)
>  #include "lockdep_states.h"
>  #undef LOCKDEP_STATE
> +#undef __USAGE
>  	[LOCK_USED] = "INITIAL USE",
>  };
>  
> @@ -816,6 +834,7 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
>  	if (!entry)
>  		return 0;
>  
> +	nr_save_trace_invocations++;
>  	if (!save_trace(&entry->trace))
>  		return 0;
>  
> @@ -2615,6 +2634,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
>  
>  	hlock_class(this)->usage_mask |= new_mask;
>  
> +	inc_save_trace_invocations(new_bit);
>  	if (!save_trace(hlock_class(this)->usage_traces + new_bit))
>  		return 0;
>  
> diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
> index 8d7d4b6..6149358 100644
> --- a/kernel/lockdep_internals.h
> +++ b/kernel/lockdep_internals.h
> @@ -84,6 +84,8 @@ extern unsigned long nr_list_entries;
>  extern unsigned long nr_lock_chains;
>  extern int nr_chain_hlocks;
>  extern unsigned long nr_stack_trace_entries;
> +extern unsigned long nr_save_trace_invocations;
> +extern unsigned long nr_save_trace_invocations_type[LOCK_USAGE_STATES];
>  
>  extern unsigned int nr_hardirq_chains;
>  extern unsigned int nr_softirq_chains;
> diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
> index 59b76c8..ef5f372 100644
> --- a/kernel/lockdep_proc.c
> +++ b/kernel/lockdep_proc.c
> @@ -215,8 +215,24 @@ static void lockdep_stats_debug_show(struct seq_file *m)
>  #endif
>  }
>  
> +#define __USAGE(__STATE)	\
> +[LOCK_USED_IN_##__STATE] = "LOCK_USED_IN_"__stringify(__STATE),	\
> +[LOCK_ENABLED_##__STATE] = "LOCK_ENABLED_"__stringify(__STATE), \
> +[LOCK_USED_IN_##__STATE##_READ] = "LOCK_USED_IN_"__stringify(__STATE)"_READ", \
> +[LOCK_ENABLED_##__STATE##_READ] = "LOCK_ENABLED_"__stringify(__STATE)"_READ",
> +
> +static const char *lockstate_tostr[] =
> +{
> +#define LOCKDEP_STATE(__STATE) __USAGE(__STATE)
> +#include "lockdep_states.h"
> +#undef LOCKDEP_STATE
> +#undef __USAGE
> +	[LOCK_USED] = "LOCK_USED",
> +};
> +
>  static int lockdep_stats_show(struct seq_file *m, void *v)
>  {
> +	int bit;
>  	struct lock_class *class;
>  	unsigned long nr_unused = 0, nr_uncategorized = 0,
>  		      nr_irq_safe = 0, nr_irq_unsafe = 0,
> @@ -307,6 +323,13 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
>  			nr_process_chains);
>  	seq_printf(m, " stack-trace entries:           %11lu [max: %lu]\n",
>  			nr_stack_trace_entries, MAX_STACK_TRACE_ENTRIES);
> +	seq_printf(m, " stack-trace invocations: %lu\n",
> +			nr_save_trace_invocations);
> +
> +	for (bit=0; bit < LOCK_USAGE_STATES; bit++)
> +		seq_printf(m, "\t%s: %lu\n", lockstate_tostr[bit],
> +			       nr_save_trace_invocations_type[bit]);	
> +
>  	seq_printf(m, " combined max dependencies:     %11u\n",
>  			(nr_hardirq_chains + 1) *
>  			(nr_softirq_chains + 1) *
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
