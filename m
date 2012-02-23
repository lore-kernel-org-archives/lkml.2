Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2BWWjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:39:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2BWWjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:39:51 -0500
Date: Thu, 23 Feb 2012 23:39:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120223223933.GA7942@elte.hu>
References: <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
 <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
 <20120223100205.GD24310@elte.hu>
 <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com>
 <20120223223348.GA25513@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223223348.GA25513@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> So, a modified scheme would be:
> 
>         #include <linux/static_key.h>
> 
>         struct static_key key = STATIC_KEY_INIT_TRUE;
> 
>         if (static_key_false(&key))
>                 do unlikely code
>         else
>                 do likely code
> 
> Or:
> 
>         if (static_key_true(&key))
>                 do likely code
>         else
>                 do unlikely code
> 
> The static key is modified via:
> 
>         static_key_slow_inc(&key);
>         ...
>         static_key_slow_dec(&key);
> 
> Is that API fine? I'll rework the series to such an effect if 
> everyone agrees.

I.e. something like the patch below on top of 
tip:perf/jump-labels.

Untested - will test it and will refactor the series if 
everyone's happy.

Thanks,

	Ingo

diff --git a/Documentation/jump-label.txt b/Documentation/jump-label.txt
index ba67ca7..9570e22 100644
--- a/Documentation/jump-label.txt
+++ b/Documentation/jump-label.txt
@@ -32,7 +32,7 @@ the branch site to change the branch direction.
 
 For example, if we have a simple branch that is disabled by default:
 
-	if (very_unlikely(&key))
+	if (static_key_false(&key))
 		printk("I am the true branch\n");
 
 Thus, by default the 'printk' will not be emitted. And the code generated will
@@ -64,21 +64,21 @@ the stack or dynamically allocated at run-time.
 
 The key is then used in code as:
 
-        if (very_unlikely(&key))
+        if (static_key_false(&key))
                 do unlikely code
         else
                 do likely code
 
 Or:
 
-        if (very_likely(&key))
+        if (static_key_true(&key))
                 do likely code
         else
                 do unlikely code
 
 A key that is initialized via 'STATIC_KEY_INIT_FALSE', must be used in a
-'very_unlikely()' construct. Likewise, a key initialized via
-'STATIC_KEY_INIT_TRUE' must be used in a 'very_likely()' construct.
+'static_key_false()' construct. Likewise, a key initialized via
+'STATIC_KEY_INIT_TRUE' must be used in a 'static_key_true()' construct.
 A single key can be used in many branches, but all the branches must match
 the way that the key has been initialized.
 
@@ -99,7 +99,7 @@ An example usage in the kernel is the implementation of tracepoints:
 
         static inline void trace_##name(proto)                          \
         {                                                               \
-                if (very_unlikely(&__tracepoint_##name.key))		\
+                if (static_key_false(&__tracepoint_##name.key))		\
                         __DO_TRACE(&__tracepoint_##name,                \
                                 TP_PROTO(data_proto),                   \
                                 TP_ARGS(data_args),                     \
@@ -145,7 +145,7 @@ SYSCALL_DEFINE0(getppid)
 {
         int pid;
 
-+        if (very_unlikely(&key))
++        if (static_key_false(&key))
 +                printk("I am the true branch\n");
 
         rcu_read_lock();
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index b21c123..ea7b4fd 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -250,7 +250,7 @@ static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 
 static inline void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
-	if (very_unlikely((&mmu_audit_key)))
+	if (static_key_false((&mmu_audit_key)))
 		__kvm_mmu_audit(vcpu, point);
 }
 
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 25c589b..30d0023 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -9,7 +9,7 @@
  *
  * Jump labels provide an interface to generate dynamic branches using
  * self-modifying code. Assuming toolchain and architecture support the result
- * of a "if (very_unlikely(&key))" statement is a unconditional branch (which
+ * of a "if (static_key_false(&key))" statement is a unconditional branch (which
  * defaults to false - and the true block is placed out of line).
  *
  * However at runtime we can change the branch target using
@@ -34,15 +34,15 @@
  *
  * struct static_key my_key = STATIC_KEY_INIT_TRUE;
  *
- *   if (very_likely(&my_key)) {
+ *   if (static_key_true(&my_key)) {
  *   }
  *
  * will result in the true case being in-line and starts the key with a single
- * reference. Mixing very_likely() and very_unlikely() on the same key is not
+ * reference. Mixing static_key_true() and static_key_false() on the same key is not
  * allowed.
  *
  * Not initializing the key (static data is initialized to 0s anyway) is the
- * same as using STATIC_KEY_INIT_FALSE and very_unlikely() is
+ * same as using STATIC_KEY_INIT_FALSE and static_key_false() is
  * equivalent with static_branch().
  *
 */
@@ -97,17 +97,17 @@ static inline bool jump_label_get_branch_default(struct static_key *key)
 	return false;
 }
 
-static __always_inline bool very_unlikely(struct static_key *key)
+static __always_inline bool static_key_false(struct static_key *key)
 {
 	return arch_static_branch(key);
 }
 
-static __always_inline bool very_likely(struct static_key *key)
+static __always_inline bool static_key_true(struct static_key *key)
 {
-	return !very_unlikely(key);
+	return !static_key_false(key);
 }
 
-/* Deprecated. Please use 'very_unlikely() instead. */
+/* Deprecated. Please use 'static_key_false() instead. */
 static __always_inline bool static_branch(struct static_key *key)
 {
 	return arch_static_branch(key);
@@ -153,21 +153,21 @@ struct static_key_deferred {
 	struct static_key  key;
 };
 
-static __always_inline bool very_unlikely(struct static_key *key)
+static __always_inline bool static_key_false(struct static_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
 
-static __always_inline bool very_likely(struct static_key *key)
+static __always_inline bool static_key_true(struct static_key *key)
 {
 	if (likely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
 
-/* Deprecated. Please use 'very_unlikely() instead. */
+/* Deprecated. Please use 'static_key_false() instead. */
 static __always_inline bool static_branch(struct static_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)) > 0)
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 9f10318..29734be 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -169,7 +169,7 @@ static inline bool nf_hooks_active(u_int8_t pf, unsigned int hook)
 {
 	if (__builtin_constant_p(pf) &&
 	    __builtin_constant_p(hook))
-		return very_unlikely(&nf_hooks_needed[pf][hook]);
+		return static_key_false(&nf_hooks_needed[pf][hook]);
 
 	return !list_empty(&nf_hooks[pf][hook]);
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 434b51b..0d21e6f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1066,7 +1066,7 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
-	if (very_unlikely(&perf_swevent_enabled[event_id])) {
+	if (static_key_false(&perf_swevent_enabled[event_id])) {
 		if (!regs) {
 			perf_fetch_caller_regs(&hot_regs);
 			regs = &hot_regs;
@@ -1080,7 +1080,7 @@ extern struct static_key_deferred perf_sched_events;
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
-	if (very_unlikely(&perf_sched_events.key))
+	if (static_key_false(&perf_sched_events.key))
 		__perf_event_task_sched_in(prev, task);
 }
 
@@ -1089,7 +1089,7 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
-	if (very_unlikely(&perf_sched_events.key))
+	if (static_key_false(&perf_sched_events.key))
 		__perf_event_task_sched_out(prev, next);
 }
 
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index ec28a94..bd96ecd 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -145,7 +145,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (very_unlikely(&__tracepoint_##name.key))		\
+		if (static_key_false(&__tracepoint_##name.key))		\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
diff --git a/include/net/sock.h b/include/net/sock.h
index 907bbe0..dcde2d9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -930,7 +930,7 @@ static inline struct cg_proto *parent_cg_proto(struct proto *proto,
 {
 	return proto->proto_cgroup(parent_mem_cgroup(cg_proto->memcg));
 }
-#define mem_cgroup_sockets_enabled very_unlikely(&memcg_socket_limit_enabled)
+#define mem_cgroup_sockets_enabled static_key_false(&memcg_socket_limit_enabled)
 #else
 #define mem_cgroup_sockets_enabled 0
 static inline struct cg_proto *parent_cg_proto(struct proto *proto,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1169246..26b02da 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -894,7 +894,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	delta -= irq_delta;
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-	if (very_unlikely((&paravirt_steal_rq_enabled))) {
+	if (static_key_false((&paravirt_steal_rq_enabled))) {
 		u64 st;
 
 		steal = paravirt_steal_clock(cpu_of(rq));
@@ -2755,7 +2755,7 @@ void account_idle_time(cputime_t cputime)
 static __always_inline bool steal_account_process_tick(void)
 {
 #ifdef CONFIG_PARAVIRT
-	if (very_unlikely(&paravirt_steal_enabled)) {
+	if (static_key_false(&paravirt_steal_enabled)) {
 		u64 steal, st = 0;
 
 		steal = paravirt_steal_clock(smp_processor_id());
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3c41bf0..34748d6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1405,7 +1405,7 @@ static struct static_key __cfs_bandwidth_used;
 
 static inline bool cfs_bandwidth_used(void)
 {
-	return very_unlikely(&__cfs_bandwidth_used);
+	return static_key_false(&__cfs_bandwidth_used);
 }
 
 void account_cfs_bandwidth_used(int enabled, int was_enabled)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 02a166f..7a1dc91 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -627,12 +627,12 @@ enum {
 #if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
 static __always_inline bool static_branch__true(struct static_key *key)
 {
-	return very_likely(key); /* Not out of line branch. */
+	return static_key_true(key); /* Not out of line branch. */
 }
 
 static __always_inline bool static_branch__false(struct static_key *key)
 {
-	return very_unlikely(key); /* Out of line branch. */
+	return static_key_false(key); /* Out of line branch. */
 }
 
 #define SCHED_FEAT(name, enabled)					\
diff --git a/net/core/dev.c b/net/core/dev.c
index dd7377f..6982bfd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1481,12 +1481,12 @@ EXPORT_SYMBOL(net_disable_timestamp);
 static inline void net_timestamp_set(struct sk_buff *skb)
 {
 	skb->tstamp.tv64 = 0;
-	if (very_unlikely(&netstamp_needed))
+	if (static_key_false(&netstamp_needed))
 		__net_timestamp(skb);
 }
 
 #define net_timestamp_check(COND, SKB)			\
-	if (very_unlikely(&netstamp_needed)) {		\
+	if (static_key_false(&netstamp_needed)) {		\
 		if ((COND) && !(SKB)->tstamp.tv64)	\
 			__net_timestamp(SKB);		\
 	}						\
@@ -2945,7 +2945,7 @@ int netif_rx(struct sk_buff *skb)
 
 	trace_netif_rx(skb);
 #ifdef CONFIG_RPS
-	if (very_unlikely(&rps_needed)) {
+	if (static_key_false(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu;
 
@@ -3309,7 +3309,7 @@ int netif_receive_skb(struct sk_buff *skb)
 		return NET_RX_SUCCESS;
 
 #ifdef CONFIG_RPS
-	if (very_unlikely(&rps_needed)) {
+	if (static_key_false(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu, ret;
 

