Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0DTVKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:10:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992Ab0DTVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:10:46 -0400
Date: Tue, 20 Apr 2010 14:09:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Kacur <jkacur@gmail.com>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RFC: PATCH v2] lockdep: Make MAX_STACK_TRACE_ENTRIES
 configurable.
Message-Id: <20100420140941.d085007d.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004191841230.6259@localhost>
References: <alpine.LFD.2.00.1004161329030.11320@localhost.localdomain>
	<alpine.LFD.2.00.1004161727000.11320@localhost.localdomain>
	<alpine.LFD.2.00.1004191841230.6259@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 18:51:57 +0200 (CEST)
John Kacur <jkacur@gmail.com> wrote:

> Ingo, since nobody responded to my RFC, I am assuming that the change
> is not controversial, would you please consider pulling this into tip
> for 2.6.35?
> 
> What followed is v2 of the patch regenerated against the latest
> tip/master
> 
> ...
> 
> Certain configurations that have LOCKDEP turned on, run into the limit
> where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply
> turning of the locking correctness validator let the user configure this
> value to something reasonable for their system.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  kernel/lockdep.c           |    8 ++++----
>  kernel/lockdep_internals.h |    6 ------
>  kernel/lockdep_proc.c      |    2 +-
>  lib/Kconfig.debug          |    9 +++++++++
>  4 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 78325f8..2acc25d 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -369,12 +369,12 @@ static int verbose(struct lock_class *class)
>   * addresses. Protected by the graph_lock.
>   */
>  unsigned long nr_stack_trace_entries;
> -static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
> +static unsigned long stack_trace[CONFIG_MAX_STACK_TRACE_ENTRIES];
>  
>  static int save_trace(struct stack_trace *trace)
>  {
>  	trace->nr_entries = 0;
> -	trace->max_entries = MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries;
> +	trace->max_entries = CONFIG_MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries;
>  	trace->entries = stack_trace + nr_stack_trace_entries;
>  
>  	trace->skip = 3;
> @@ -396,11 +396,11 @@ static int save_trace(struct stack_trace *trace)
>  
>  	nr_stack_trace_entries += trace->nr_entries;
>  
> -	if (nr_stack_trace_entries >= MAX_STACK_TRACE_ENTRIES-1) {
> +	if (nr_stack_trace_entries >= CONFIG_MAX_STACK_TRACE_ENTRIES-1) {
>  		if (!debug_locks_off_graph_unlock())
>  			return 0;
>  
> -		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
> +		printk("BUG: CONFIG_MAX_STACK_TRACE_ENTRIES = %d too low!\n", CONFIG_MAX_STACK_TRACE_ENTRIES);
>  		printk("turning off the locking correctness validator.\n");
>  		dump_stack();
>  
> diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
> index 8d7d4b6..e2585ff 100644
> --- a/kernel/lockdep_internals.h
> +++ b/kernel/lockdep_internals.h
> @@ -61,12 +61,6 @@ enum {
>  
>  #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
>  
> -/*
> - * Stack-trace: tightly packed array of stack backtrace
> - * addresses. Protected by the hash_lock.
> - */
> -#define MAX_STACK_TRACE_ENTRIES	262144UL
> -
>  extern struct list_head all_lock_classes;
>  extern struct lock_chain lock_chains[];
>  
> diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
> index 59b76c8..924e0e9 100644
> --- a/kernel/lockdep_proc.c
> +++ b/kernel/lockdep_proc.c
> @@ -306,7 +306,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
>  	seq_printf(m, " in-process chains:             %11u\n",
>  			nr_process_chains);
>  	seq_printf(m, " stack-trace entries:           %11lu [max: %lu]\n",
> -			nr_stack_trace_entries, MAX_STACK_TRACE_ENTRIES);
> +			nr_stack_trace_entries, CONFIG_MAX_STACK_TRACE_ENTRIES);
>  	seq_printf(m, " combined max dependencies:     %11u\n",
>  			(nr_hardirq_chains + 1) *
>  			(nr_softirq_chains + 1) *

Note that MAX_STACK_TRACE_ENTRIES was `unsigned long', but
CONFIG_MAX_STACK_TRACE_ENTRIES is now an `int'.  AFACIT all the
comparisons will handle that OK, but please review them for this.

But this seq_printf() is now wrong, isn't it?  Didn't it generate a
long-vs-int compiler warning?

<tests it>

yup:

kernel/lockdep_proc.c: In function 'lockdep_stats_show':
kernel/lockdep_proc.c:309: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'int'

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 0bbd5c7..38d3bf3 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -533,6 +533,15 @@ config LOCKDEP
>  	select KALLSYMS
>  	select KALLSYMS_ALL
>  
> +config MAX_STACK_TRACE_ENTRIES
> +	int "MAX_STACK_TRACE_ENTRIES for LOCKDEP"
> +	depends on LOCKDEP
> +	default 262144
> +	help
> +	   This option allows you to change the default MAX_STACK_TRACE_ENTRIES
> +	   used for LOCKDEP. Warning, increasing this number will increase the
> +	   size of the stack_trace array, and thus the kernel size too.
> +
>  config LOCK_STAT
>  	bool "Lock usage statistics"
>  	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
> -- 
> 1.6.6.1
