Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab1LARVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:21:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab1LARVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:21:45 -0500
Date: Thu, 1 Dec 2011 12:16:28 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Subject: Re: [PATCH] jump_label: jump_label for boot options.
Message-ID: <20111201171628.GC2443@redhat.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
 <20111201154036.GA2443@redhat.com>
 <1322756898.4699.30.camel@twins>
 <20111201165009.GB2443@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201165009.GB2443@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 11:50:09AM -0500, Jason Baron wrote:
> On Thu, Dec 01, 2011 at 05:28:18PM +0100, Peter Zijlstra wrote:
> > On Thu, 2011-12-01 at 10:40 -0500, Jason Baron wrote:
> > > I should probably rename
> > > static_branch() -> 'static_branch_default_false()' to make that clear.
> > 
> > The rename doesn't really make sense until you can also provide
> > static_branch_true() also:
> 
> I think its just a matter of reversing the true and false returns.
> That is, instead of:
> 
> static __always_inline bool arch_static_branch_default_false(struct jump_label_key
> *key)
> {
>         asm goto("1:"
>                 JUMP_LABEL_INITIAL_NOP
>                 ".pushsection __jump_table,  \"aw\" \n\t"
>                 _ASM_ALIGN "\n\t"
>                 _ASM_PTR "1b, %l[l_yes], %c0 \n\t"
>                 ".popsection \n\t"
>                 : :  "i" (key) : : l_yes);
>         return false;
> l_yes:
>         return true;
> }
> 
> We just have (untested):
> 
> static __always_inline bool arch_static_branch_default_true(struct jump_label_key
> *key)
> {
>         asm goto("1:"
>                 JUMP_LABEL_INITIAL_NOP
>                 ".pushsection __jump_table,  \"aw\" \n\t"
>                 _ASM_ALIGN "\n\t"
>                 _ASM_PTR "1b, %l[l_no], %c0 \n\t"
>                 ".popsection \n\t"
>                 : :  "i" (key) : : l_no);
>         return true;
> l_no:
>         return false;
> }
> 
> jump_label_inc/dec(), don't need to be changed, they just mean reverse
> the branch on 0, 1 transitions. Although using the same key in both
> static_branch_true, and static_branch_false, might be confusing. Maybe
> we rename jump_label_inc/dec to static_branch_reverse_inc()/dec()?
> 
> > 
> > > Maybe we need an unbiased static_branch() too, but I'm not sure excatly
> > > how to implement it... 
> > 
> > I'd think the same way we got in this situation in the first place, go
> > kick some GCC people ;-)
> 
> If you think this is a useful case, I'll try and see how to implement it.
> Then we can add static_branch_default_true/false_unbiased() :)
> 
> -Jason

Actually, here's a version to imlement static_branch_true/false, that doesn't
touch any arch code. 


diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 388b0d4..411cd54 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -33,11 +33,16 @@ struct module;
 #define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL}
 #endif
 
-static __always_inline bool static_branch(struct jump_label_key *key)
+static __always_inline bool static_branch_default_false(struct jump_label_key *key)
 {
 	return arch_static_branch(key);
 }
 
+static __always_inline bool static_branch_default_true(struct jump_label_key *key)
+{
+	return !arch_static_branch(key);
+}
+
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
@@ -68,13 +73,20 @@ static __always_inline void jump_label_init(void)
 {
 }
 
-static __always_inline bool static_branch(struct jump_label_key *key)
+static __always_inline bool static_branch_default_false(struct jump_label_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)))
 		return true;
 	return false;
 }
 
+static __always_inline bool static_branch_default_true(struct jump_label_key *key)
+{
+	if (likely(atomic_read(&key->enabled)))
+		return true;
+	return false;
+}
+
 static inline void jump_label_inc(struct jump_label_key *key)
 {
 	atomic_inc(&key->enabled);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1e9ebe5..05a4f92 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1053,7 +1053,7 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
-	if (static_branch(&perf_swevent_enabled[event_id])) {
+	if (static_branch_default_false(&perf_swevent_enabled[event_id])) {
 		if (!regs) {
 			perf_fetch_caller_regs(&hot_regs);
 			regs = &hot_regs;
@@ -1067,7 +1067,7 @@ extern struct jump_label_key perf_sched_events;
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
-	if (static_branch(&perf_sched_events))
+	if (static_branch_default_false(&perf_sched_events))
 		__perf_event_task_sched_in(prev, task);
 }
 
@@ -1076,7 +1076,7 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
-	if (static_branch(&perf_sched_events))
+	if (static_branch_default_false(&perf_sched_events))
 		__perf_event_task_sched_out(prev, next);
 }
 
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index df0a779..31c5d64 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -143,7 +143,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (static_branch(&__tracepoint_##name.key))		\
+		if (static_branch_default_false(&__tracepoint_##name.key))\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
diff --git a/kernel/sched.c b/kernel/sched.c
index 0e9344a..c818b01 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2129,7 +2129,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	delta -= irq_delta;
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-	if (static_branch((&paravirt_steal_rq_enabled))) {
+	if (static_branch_default_false((&paravirt_steal_rq_enabled))) {
 		u64 st;
 
 		steal = paravirt_steal_clock(cpu_of(rq));
@@ -4001,7 +4001,7 @@ void account_idle_time(cputime_t cputime)
 static __always_inline bool steal_account_process_tick(void)
 {
 #ifdef CONFIG_PARAVIRT
-	if (static_branch(&paravirt_steal_enabled)) {
+	if (static_branch_default_false(&paravirt_steal_enabled)) {
 		u64 steal, st = 0;
 
 		steal = paravirt_steal_clock(smp_processor_id());
