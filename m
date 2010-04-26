Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0DZGZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 02:25:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:64854 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab0DZGZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 02:25:16 -0400
Date: Mon, 26 Apr 2010 14:24:37 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       "David S. Miller" <davem@davemloft.net>,
       Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH] lockdep: reduce stack_trace usage
Message-ID: <20100426062437.GB4131@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
 <20100423025850.GA21328@windriver.com>
 <alpine.LFD.2.00.1004230907050.4151@localhost>
 <1272009915.1646.25.camel@laptop>
 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
 <20100423134044.GA2777@zhy-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100423134044.GA2777@zhy-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Apr 2010 06:24:39.0643 (UTC) FILETIME=[26794AB0:01CAE509]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 09:40:44PM +0800, Yong Zhang wrote:
> Hi John,
> 
> (checking mail at home).
> I find some place which can be hacked. Below is the patch.
> But I don't even compile it. Can you test it to see if it can smooth
> your problem.
> 
> ---cut here ---
> >From 6b9d513b7c417c0805ef0acc1cb3227bddba0889 Mon Sep 17 00:00:00 2001
> From: Yong Zhang <yong.zhang0@gmail.com>
> Date: Fri, 23 Apr 2010 21:13:54 +0800
> Subject: [PATCH] lockdep: reduce stack_trace usage
> 
> When calling check_prevs_add(), if all validations passed
> add_lock_to_list() will add new lock to dependency tree and
> alloc stack_trace for each list_entry. But at this time,
> we are always on the same stack, so stack_trace for each
> list_entry has the same value. This is redundant and eats up
> lots of memory which could lead to warning on low
> MAX_STACK_TRACE_ENTRIES.
> Using one copy of stack_trace instead.

With the following test patch running on my machine:
> cat /proc/lockdep_stats 
 lock-classes:                          564 [max: 8191]
 direct dependencies:                  2626 [max: 16384]
 indirect dependencies:                5951
 all direct dependencies:             48226
 dependency chains:                    2576 [max: 32768]
 dependency chain hlocks:              6740 [max: 163840]
 in-hardirq chains:                      18
 in-softirq chains:                     163
 in-process chains:                    2395
 stack-trace entries:                 63076 [max: 262144]
 duplicated stack-trace entries:       7592         <=========
 combined max dependencies:         7465936
 hardirq-safe locks:                     30
 hardirq-unsafe locks:                  380
 softirq-safe locks:                     82
 softirq-unsafe locks:                  305
 irq-safe locks:                         90
 irq-unsafe locks:                      380
 hardirq-read-safe locks:                 0
 hardirq-read-unsafe locks:              51
 softirq-read-safe locks:                11
 softirq-read-unsafe locks:              40
 irq-read-safe locks:                    11
 irq-read-unsafe locks:                  51
 uncategorized locks:                   112
 unused locks:                            1
 max locking depth:                      15
 max bfs queue depth:                    83
 debug_locks:                             1

We can see that about 12% stack_trace usage can be reduced.

Thanks,
Yong

------lockdep-duplicated-stack_trace-detect.patch------
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..dfd37ea 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -369,6 +369,7 @@ static int verbose(struct lock_class *class)
  * addresses. Protected by the graph_lock.
  */
 unsigned long nr_stack_trace_entries;
+unsigned long nr_duplicated_stack_trace_entries;
 static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
 
 static int save_trace(struct stack_trace *trace)
@@ -818,9 +819,14 @@ static struct lock_list *alloc_list_entry(void)
  * Add a new dependency to the head of the list:
  */
 static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
-			    struct list_head *head, unsigned long ip, int distance)
+			    struct list_head *head, unsigned long ip,
+			    int distance, struct held_lock *next)
 {
 	struct lock_list *entry;
+	static struct held_lock *hlock;
+	static struct stack_trace trace;
+	int i;
+
 	/*
 	 * Lock not present yet - get a new dependency struct and
 	 * add it to the list:
@@ -834,6 +840,20 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 
 	entry->class = this;
 	entry->distance = distance;
+
+	if (hlock != next) {
+		hlock = next;
+		trace = entry->trace;
+	} else if (trace.nr_entries == entry->trace.nr_entries &&
+		 trace.max_entries == entry->trace.max_entries) {
+		 /* start from 2 to skip the stack introduced by lockdep */
+		 for (i=2; i<trace.nr_entries; i++) {
+			if (trace.entries[i] != entry->trace.entries[i])
+				goto no_duplicated;
+		}
+		nr_duplicated_stack_trace_entries += trace.nr_entries;
+	}
+no_duplicated:
 	/*
 	 * Since we never remove from the dependency list, the list can
 	 * be walked lockless by other CPUs, it's only allocation
@@ -1694,14 +1714,14 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 */
 	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
 			       &hlock_class(prev)->locks_after,
-			       next->acquire_ip, distance);
+			       next->acquire_ip, distance, next);
 
 	if (!ret)
 		return 0;
 
 	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
 			       &hlock_class(next)->locks_before,
-			       next->acquire_ip, distance);
+			       next->acquire_ip, distance, next);
 	if (!ret)
 		return 0;
 
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2ee95a..d00fe7b 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -84,6 +84,7 @@ extern unsigned long nr_list_entries;
 extern unsigned long nr_lock_chains;
 extern int nr_chain_hlocks;
 extern unsigned long nr_stack_trace_entries;
+extern unsigned long nr_duplicated_stack_trace_entries;
 
 extern unsigned int nr_hardirq_chains;
 extern unsigned int nr_softirq_chains;
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d4aba4f..32cb9a3 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -307,6 +307,8 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_process_chains);
 	seq_printf(m, " stack-trace entries:           %11lu [max: %lu]\n",
 			nr_stack_trace_entries, MAX_STACK_TRACE_ENTRIES);
+	seq_printf(m, " duplicated stack-trace entries:%11lu\n",
+			nr_duplicated_stack_trace_entries);
 	seq_printf(m, " combined max dependencies:     %11u\n",
 			(nr_hardirq_chains + 1) *
 			(nr_softirq_chains + 1) *
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  kernel/lockdep.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 2594e1c..097d5fb 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -818,7 +818,8 @@ static struct lock_list *alloc_list_entry(void)
>   * Add a new dependency to the head of the list:
>   */
>  static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
> -			    struct list_head *head, unsigned long ip, int distance)
> +			    struct list_head *head, unsigned long ip,
> +			    int distance, struct stack_trace *trace)
>  {
>  	struct lock_list *entry;
>  	/*
> @@ -829,11 +830,9 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
>  	if (!entry)
>  		return 0;
>  
> -	if (!save_trace(&entry->trace))
> -		return 0;
> -
>  	entry->class = this;
>  	entry->distance = distance;
> +	entry->trace = *trace;
>  	/*
>  	 * Since we never remove from the dependency list, the list can
>  	 * be walked lockless by other CPUs, it's only allocation
> @@ -1635,7 +1634,7 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
>   */
>  static int
>  check_prev_add(struct task_struct *curr, struct held_lock *prev,
> -	       struct held_lock *next, int distance)
> +	       struct held_lock *next, int distance, struct stack_trace *trace)
>  {
>  	struct lock_list *entry;
>  	int ret;
> @@ -1694,14 +1693,14 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
>  	 */
>  	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
>  			       &hlock_class(prev)->locks_after,
> -			       next->acquire_ip, distance);
> +			       next->acquire_ip, distance, trace);
>  
>  	if (!ret)
>  		return 0;
>  
>  	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
>  			       &hlock_class(next)->locks_before,
> -			       next->acquire_ip, distance);
> +			       next->acquire_ip, distance, trace);
>  	if (!ret)
>  		return 0;
>  
> @@ -1732,6 +1731,7 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
>  {
>  	int depth = curr->lockdep_depth;
>  	struct held_lock *hlock;
> +	struct stack_trace trace;
>  
>  	/*
>  	 * Debugging checks.
> @@ -1748,6 +1748,9 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
>  			curr->held_locks[depth-1].irq_context)
>  		goto out_bug;
>  
> +	if (!save_trace(&trace))
> +		return 0;
> +
>  	for (;;) {
>  		int distance = curr->lockdep_depth - depth + 1;
>  		hlock = curr->held_locks + depth-1;
> @@ -1756,7 +1759,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
>  		 * added:
>  		 */
>  		if (hlock->read != 2) {
> -			if (!check_prev_add(curr, hlock, next, distance))
> +			if (!check_prev_add(curr, hlock, next,
> +						distance, &trace))
>  				return 0;
>  			/*
>  			 * Stop after the first non-trylock entry,
> -- 
> 1.6.3.3
