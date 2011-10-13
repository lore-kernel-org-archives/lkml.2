Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab1JMJwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:52:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:35044 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1JMJwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:52:20 -0400
Date: Thu, 13 Oct 2011 11:52:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.0.6-rt18
Message-ID: <alpine.LFD.2.02.1110131146370.3240@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.0.6-rt18 release.

Changes from 3.0.6-rt17 to 3.0.6-rt18

  * Fix a long standing slab thinko (Steven Rostedt)

  * Add missing debugobjects call to hrtimers (Yong Zhang)

  * Tracing updates (Steven Rostedt)

  * Minor fixes (Yong, myself)

Delta patch against 3.0.6-rt17

  https://tglx.de/~tglx/rt/patch-3.0.6-rt17-rt18.patch.gz

also appended below.


Patch against 3.0.6 can be found here:

  https://tglx.de/~tglx/rt/patch-3.0.6-rt18.patch.gz


The split quilt queue is available at:

  https://tglx.de/~tglx/rt/patches-3.0.6-rt18.tar.gz

Enjoy,

	tglx

--------------->
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -570,6 +570,7 @@ static void init_one_hpet_msi_clockevent
 static int __init dmi_disable_hpet_msi(const struct dmi_system_id *d)
 {
 	hpet_msi_disable = 1;
+	return 0;
 }
 
 static struct dmi_system_id __initdata dmi_hpet_table[] = {
Index: linux-2.6/include/linux/hardirq.h
===================================================================
--- linux-2.6.orig/include/linux/hardirq.h
+++ linux-2.6/include/linux/hardirq.h
@@ -84,7 +84,7 @@
 # define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
 # define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
 #else
-# define softirq_count()	(0U)
+# define softirq_count()	(0UL)
 extern int in_serving_softirq(void);
 #endif
 
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1040,6 +1040,7 @@ int __hrtimer_start_range_ns(struct hrti
 			 * remove it again and report a failure. This avoids
 			 * stale base->first entries.
 			 */
+			debug_deactivate(timer);
 			__remove_hrtimer(timer, new_base,
 					timer->state & HRTIMER_STATE_CALLBACK, 0);
 		}
Index: linux-2.6/kernel/trace/ftrace.c
===================================================================
--- linux-2.6.orig/kernel/trace/ftrace.c
+++ linux-2.6/kernel/trace/ftrace.c
@@ -1767,10 +1767,36 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
+static int ops_traces_mod(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash;
+
+	hash = ops->filter_hash;
+	return !!(!hash || !hash->count);
+}
+
 static int ftrace_update_code(struct module *mod)
 {
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
+	unsigned long ref = 0;
+
+	/*
+	 * When adding a module, we need to check if tracers are
+	 * currently enabled and if they are set to trace all functions.
+	 * If they are, we need to enable the module functions as well
+	 * as update the reference counts for those function records.
+	 */
+	if (mod) {
+		struct ftrace_ops *ops;
+
+		for (ops = ftrace_ops_list;
+		     ops != &ftrace_list_end; ops = ops->next) {
+			if (ops->flags & FTRACE_OPS_FL_ENABLED &&
+			    ops_traces_mod(ops))
+				ref++;
+		}
+	}
 
 	start = ftrace_now(raw_smp_processor_id());
 	ftrace_update_cnt = 0;
@@ -1783,7 +1809,7 @@ static int ftrace_update_code(struct mod
 
 		p = ftrace_new_addrs;
 		ftrace_new_addrs = p->newlist;
-		p->flags = 0L;
+		p->flags = ref;
 
 		/*
 		 * Do the initial record conversion from mcount jump
@@ -1806,7 +1832,7 @@ static int ftrace_update_code(struct mod
 		 * conversion puts the module to the correct state, thus
 		 * passing the ftrace_make_call check.
 		 */
-		if (ftrace_start_up) {
+		if (ftrace_start_up && ref) {
 			int failed = __ftrace_replace_code(p, 1);
 			if (failed) {
 				ftrace_bug(failed, p->ip);
@@ -2430,10 +2456,9 @@ ftrace_match_module_records(struct ftrac
  */
 
 static int
-ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
+ftrace_mod_callback(struct ftrace_hash *hash,
+		    char *func, char *cmd, char *param, int enable)
 {
-	struct ftrace_ops *ops = &global_ops;
-	struct ftrace_hash *hash;
 	char *mod;
 	int ret = -EINVAL;
 
@@ -2453,11 +2478,6 @@ ftrace_mod_callback(char *func, char *cm
 	if (!strlen(mod))
 		return ret;
 
-	if (enable)
-		hash = ops->filter_hash;
-	else
-		hash = ops->notrace_hash;
-
 	ret = ftrace_match_module_records(hash, func, mod);
 	if (!ret)
 		ret = -EINVAL;
@@ -2783,7 +2803,7 @@ static int ftrace_process_regex(struct f
 	mutex_lock(&ftrace_cmd_mutex);
 	list_for_each_entry(p, &ftrace_commands, list) {
 		if (strcmp(p->name, command) == 0) {
-			ret = p->func(func, command, next, enable);
+			ret = p->func(hash, func, command, next, enable);
 			goto out_unlock;
 		}
 	}
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt17
+-rt18
Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c
+++ linux-2.6/mm/slab.c
@@ -2601,7 +2601,7 @@ static void __do_drain(void *arg, unsign
 	struct array_cache *ac;
 	int node = cpu_to_mem(cpu);
 
-	ac = cpu_cache_get(cachep);
+	ac = cpu_cache_get_on_cpu(cachep, cpu);
 	spin_lock(&cachep->nodelists[node]->list_lock);
 	free_block(cachep, ac->entry, ac->avail, node);
 	spin_unlock(&cachep->nodelists[node]->list_lock);
Index: linux-2.6/include/linux/ftrace.h
===================================================================
--- linux-2.6.orig/include/linux/ftrace.h
+++ linux-2.6/include/linux/ftrace.h
@@ -123,7 +123,8 @@ stack_trace_sysctl(struct ctl_table *tab
 struct ftrace_func_command {
 	struct list_head	list;
 	char			*name;
-	int			(*func)(char *func, char *cmd,
+	int			(*func)(struct ftrace_hash *hash,
+					char *func, char *cmd,
 					char *params, int enable);
 };
 
Index: linux-2.6/kernel/trace/trace_functions.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_functions.c
+++ linux-2.6/kernel/trace/trace_functions.c
@@ -324,7 +324,8 @@ ftrace_trace_onoff_unreg(char *glob, cha
 }
 
 static int
-ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
+ftrace_trace_onoff_callback(struct ftrace_hash *hash,
+			    char *glob, char *cmd, char *param, int enable)
 {
 	struct ftrace_probe_ops *ops;
 	void *count = (void *)-1;
