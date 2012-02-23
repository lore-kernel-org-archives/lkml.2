Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2BWQWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:22:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab2BWQWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:22:18 -0500
Date: Thu, 23 Feb 2012 11:21:59 -0500
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, a.p.zijlstra@chello.nl,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120223162158.GA2401@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
 <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
 <20120223100205.GD24310@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223100205.GD24310@elte.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 11:02:05AM +0100, Ingo Molnar wrote:
> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > On Wed, Feb 22, 2012 at 09:18:55AM +0100, Ingo Molnar wrote:
> > 
> > > The problem with static_branch_def_false/def_true was that the 
> > > very intuitively visible bias that we see with 
> > > likely()/unlikely() is confused in jump label constructs through 
> > > two layers of modifiers. And the fix is so easy, a simple rename 
> > > in most cases ;-)
> > > 
> > > So instead of that, in this series we have:
> > > 
> > > +       if (very_unlikely(&perf_sched_events.key))
> > > 
> > > which is a heck of an improvement IMO. I'd still up its 
> > > readability a notch, by also signalling the overhead of the 
> > > update path by making it:
> > > 
> > > +       if (very_unlikely(&perf_sched_events.slow_flag))
> > > 
> > > ... but I don't want to be that much of a readability nazi ;-)
> > 
> > I have to say I don't like the "very_unlikely" name.  It's 
> > confusing because the condition being evaluated appears to be 
> > the address of something, i.e. &perf_sched_events.key in your 
> > example, and that looks to me to be very very likely to be 
> > true, i.e. non-zero.  But the code is telling me that's very 
> > *un*likely, which is confusing.
> 
> Having to take the address gives us type safety - i.e. it will 
> not be possible to accidentally pass in a non-jump-label key and 
> get it misinterpreted.
> 
> If some macro magic could be used to remove the address taking 
> I'd be in favor of such a simplification, i.e.:
> 
> 	if (very_unlikely(perf_sched_events.key))
> 
> which should address your observation.
> 
> Thanks,
> 
> 	Ingo

So, we could get rid of the '&' with something as simple as:

#define very_unlikely(key) __very_unlikely(&key)

However, it does seem potentially more error prone, b/c if 'key' is
passed to a function, and they we do the very_unlikely() we end up with
the address parameter (due to pass by value). That said, it doesn't look
like anybody is using very_unlikely() in that manner in the tree, and we
could document the usage.

In any case, I did the conversion, to see what it would look like, if
anybody is interested:


diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index f0c6fd6..d4cd771 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -438,9 +438,9 @@ void __init kvm_guest_init(void)
 static __init int activate_jump_labels(void)
 {
 	if (has_steal_clock) {
-		jump_label_inc(&paravirt_steal_enabled);
+		jump_label_inc(paravirt_steal_enabled);
 		if (steal_acc)
-			jump_label_inc(&paravirt_steal_rq_enabled);
+			jump_label_inc(paravirt_steal_rq_enabled);
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 7709e02..d4cf406 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -250,7 +250,7 @@ static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 
 static inline void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
-	if (very_unlikely((&mmu_audit_key)))
+	if (very_unlikely((mmu_audit_key)))
 		__kvm_mmu_audit(vcpu, point);
 }
 
@@ -259,7 +259,7 @@ static void mmu_audit_enable(void)
 	if (mmu_audit)
 		return;
 
-	jump_label_inc(&mmu_audit_key);
+	jump_label_inc(mmu_audit_key);
 	mmu_audit = true;
 }
 
@@ -268,7 +268,7 @@ static void mmu_audit_disable(void)
 	if (!mmu_audit)
 		return;
 
-	jump_label_dec(&mmu_audit_key);
+	jump_label_dec(mmu_audit_key);
 	mmu_audit = false;
 }
 
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 757d8dc..06e29f2 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -79,6 +79,16 @@ enum jump_label_type {
 
 struct module;
 
+
+/* this defines the usage interface, maybe separate header ? */
+#define very_likely(key) __very_likely(&key)
+#define very_unlikely(key) __very_unlikely(&key)
+#define jump_label_inc(key) __jump_label_inc(&key)
+#define jump_label_dec(key) __jump_label_dec(&key)
+#define jump_label_dec_deferred(key) __jump_label_dec_deferred(&key)
+#define jump_label_true(key) __jump_label_true(&key)
+#define jump_label_rate_limit(key, rl) __jump_label_rate_limit(&key, rl)
+
 #ifdef HAVE_JUMP_LABEL
 
 #define JUMP_LABEL_TRUE_BRANCH 1UL
@@ -97,14 +107,18 @@ static inline bool jump_label_get_branch_default(struct jump_label_key *key)
 	return false;
 }
 
-static __always_inline bool very_unlikely(struct jump_label_key *key)
+#define very_unlikely(key) __very_unlikely(&key) 
+
+static __always_inline bool __very_unlikely(struct jump_label_key *key)
 {
 	return arch_static_branch(key);
 }
 
-static __always_inline bool very_likely(struct jump_label_key *key)
+#define very_likely(key) __very_likely(&key) 
+
+static __always_inline bool __very_likely(struct jump_label_key *key)
 {
-	return !very_unlikely(key);
+	return !__very_unlikely(key);
 }
 
 /* Deprecated. Please use 'very_unlikely() instead. */
@@ -124,13 +138,13 @@ extern void arch_jump_label_transform(struct jump_entry *entry,
 extern void arch_jump_label_transform_static(struct jump_entry *entry,
 					     enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
-extern void jump_label_inc(struct jump_label_key *key);
-extern void jump_label_dec(struct jump_label_key *key);
-extern void jump_label_dec_deferred(struct jump_label_key_deferred *key);
-extern bool jump_label_true(struct jump_label_key *key);
+extern void __jump_label_inc(struct jump_label_key *key);
+extern void __jump_label_dec(struct jump_label_key *key);
+extern void __jump_label_dec_deferred(struct jump_label_key_deferred *key);
+extern bool __jump_label_true(struct jump_label_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 extern void
-jump_label_rate_limit(struct jump_label_key_deferred *key, unsigned long rl);
+__jump_label_rate_limit(struct jump_label_key_deferred *key, unsigned long rl);
 
 #define JUMP_LABEL_INIT_TRUE ((struct jump_label_key) \
 	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
@@ -153,14 +167,18 @@ struct jump_label_key_deferred {
 	struct jump_label_key  key;
 };
 
-static __always_inline bool very_unlikely(struct jump_label_key *key)
+#define very_unlikely(key) __very_unlikely(&key)
+
+static __always_inline bool __very_unlikely(struct jump_label_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
 
-static __always_inline bool very_likely(struct jump_label_key *key)
+#define very_likely(key) __very_likely(&key)
+
+static __always_inline bool __very_likely(struct jump_label_key *key)
 {
 	if (likely(atomic_read(&key->enabled)) > 0)
 		return true;
@@ -175,19 +193,19 @@ static __always_inline bool static_branch(struct jump_label_key *key)
 	return false;
 }
 
-static inline void jump_label_inc(struct jump_label_key *key)
+static inline void __jump_label_inc(struct jump_label_key *key)
 {
 	atomic_inc(&key->enabled);
 }
 
-static inline void jump_label_dec(struct jump_label_key *key)
+static inline void __jump_label_dec(struct jump_label_key *key)
 {
 	atomic_dec(&key->enabled);
 }
 
-static inline void jump_label_dec_deferred(struct jump_label_key_deferred *key)
+static inline void __jump_label_dec_deferred(struct jump_label_key_deferred *key)
 {
-	jump_label_dec(&key->key);
+	__jump_label_dec(&key->key);
 }
 
 static inline int jump_label_text_reserved(void *start, void *end)
@@ -198,7 +216,7 @@ static inline int jump_label_text_reserved(void *start, void *end)
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-static inline bool jump_label_true(struct jump_label_key *key)
+static inline bool __jump_label_true(struct jump_label_key *key)
 {
 	return (atomic_read(&key->enabled) > 0);
 }
@@ -209,7 +227,7 @@ static inline int jump_label_apply_nops(struct module *mod)
 }
 
 static inline void
-jump_label_rate_limit(struct jump_label_key_deferred *key,
+__jump_label_rate_limit(struct jump_label_key_deferred *key,
 		unsigned long rl)
 {
 }
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 43d0cc0..6255b3e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -169,7 +169,7 @@ static inline bool nf_hooks_active(u_int8_t pf, unsigned int hook)
 {
 	if (__builtin_constant_p(pf) &&
 	    __builtin_constant_p(hook))
-		return very_unlikely(&nf_hooks_needed[pf][hook]);
+		return very_unlikely(nf_hooks_needed[pf][hook]);
 
 	return !list_empty(&nf_hooks[pf][hook]);
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 041d02b..b96df28 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1066,7 +1066,7 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
-	if (very_unlikely(&perf_swevent_enabled[event_id])) {
+	if (very_unlikely(perf_swevent_enabled[event_id])) {
 		if (!regs) {
 			perf_fetch_caller_regs(&hot_regs);
 			regs = &hot_regs;
@@ -1080,7 +1080,7 @@ extern struct jump_label_key_deferred perf_sched_events;
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
-	if (very_unlikely(&perf_sched_events.key))
+	if (very_unlikely(perf_sched_events.key))
 		__perf_event_task_sched_in(prev, task);
 }
 
@@ -1089,7 +1089,7 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
-	if (very_unlikely(&perf_sched_events.key))
+	if (very_unlikely(perf_sched_events.key))
 		__perf_event_task_sched_out(prev, next);
 }
 
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 282cf59..86717cd 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -143,7 +143,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (very_unlikely(&__tracepoint_##name.key))		\
+		if (very_unlikely(__tracepoint_##name.key))		\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
diff --git a/include/net/sock.h b/include/net/sock.h
index 1d16574..af4b58a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -930,7 +930,7 @@ static inline struct cg_proto *parent_cg_proto(struct proto *proto,
 {
 	return proto->proto_cgroup(parent_mem_cgroup(cg_proto->memcg));
 }
-#define mem_cgroup_sockets_enabled very_unlikely(&memcg_socket_limit_enabled)
+#define mem_cgroup_sockets_enabled very_unlikely(memcg_socket_limit_enabled)
 #else
 #define mem_cgroup_sockets_enabled 0
 static inline struct cg_proto *parent_cg_proto(struct proto *proto,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7c3b9de..31a80f2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2769,7 +2769,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec_deferred(&perf_sched_events);
+			jump_label_dec_deferred(perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2780,7 +2780,7 @@ static void free_event(struct perf_event *event)
 			put_callchain_buffers();
 		if (is_cgroup_event(event)) {
 			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
-			jump_label_dec_deferred(&perf_sched_events);
+			jump_label_dec_deferred(perf_sched_events);
 		}
 	}
 
@@ -4990,7 +4990,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 	WARN_ON(event->parent);
 
-	jump_label_dec(&perf_swevent_enabled[event_id]);
+	jump_label_dec(perf_swevent_enabled[event_id]);
 	swevent_hlist_put(event);
 }
 
@@ -5020,7 +5020,7 @@ static int perf_swevent_init(struct perf_event *event)
 		if (err)
 			return err;
 
-		jump_label_inc(&perf_swevent_enabled[event_id]);
+		jump_label_inc(perf_swevent_enabled[event_id]);
 		event->destroy = sw_perf_event_destroy;
 	}
 
@@ -5843,7 +5843,7 @@ done:
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_sched_events.key);
+			jump_label_inc(perf_sched_events.key);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -6081,7 +6081,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * - that may need work on context switch
 		 */
 		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_inc(&perf_sched_events.key);
+		jump_label_inc(perf_sched_events.key);
 	}
 
 	/*
@@ -6929,7 +6929,7 @@ void __init perf_event_init(void)
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
 
 	/* do not patch jump label more than once per second */
-	jump_label_rate_limit(&perf_sched_events, HZ);
+	jump_label_rate_limit(perf_sched_events, HZ);
 }
 
 static int __init perf_event_sysfs_init(void)
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 2b55284..d45d9e0 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -29,11 +29,11 @@ void jump_label_unlock(void)
 	mutex_unlock(&jump_label_mutex);
 }
 
-bool jump_label_true(struct jump_label_key *key)
+bool __jump_label_true(struct jump_label_key *key)
 {
 	return (atomic_read(&key->enabled) > 0);
 }
-EXPORT_SYMBOL_GPL(jump_label_true);
+EXPORT_SYMBOL_GPL(__jump_label_true);
 
 static int jump_label_cmp(const void *a, const void *b)
 {
@@ -61,7 +61,7 @@ jump_label_sort_entries(struct jump_entry *start, struct jump_entry *stop)
 
 static void jump_label_update(struct jump_label_key *key, int enable);
 
-void jump_label_inc(struct jump_label_key *key)
+void __jump_label_inc(struct jump_label_key *key)
 {
 	if (atomic_inc_not_zero(&key->enabled))
 		return;
@@ -76,9 +76,9 @@ void jump_label_inc(struct jump_label_key *key)
 	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
-EXPORT_SYMBOL_GPL(jump_label_inc);
+EXPORT_SYMBOL_GPL(__jump_label_inc);
 
-static void __jump_label_dec(struct jump_label_key *key,
+static void ____jump_label_dec(struct jump_label_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
 {
 	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
@@ -103,22 +103,22 @@ static void jump_label_update_timeout(struct work_struct *work)
 {
 	struct jump_label_key_deferred *key =
 		container_of(work, struct jump_label_key_deferred, work.work);
-	__jump_label_dec(&key->key, 0, NULL);
+	____jump_label_dec(&key->key, 0, NULL);
 }
 
-void jump_label_dec(struct jump_label_key *key)
+void __jump_label_dec(struct jump_label_key *key)
 {
-	__jump_label_dec(key, 0, NULL);
+	____jump_label_dec(key, 0, NULL);
 }
-EXPORT_SYMBOL_GPL(jump_label_dec);
+EXPORT_SYMBOL_GPL(__jump_label_dec);
 
-void jump_label_dec_deferred(struct jump_label_key_deferred *key)
+void __jump_label_dec_deferred(struct jump_label_key_deferred *key)
 {
-	__jump_label_dec(&key->key, key->timeout, &key->work);
+	____jump_label_dec(&key->key, key->timeout, &key->work);
 }
-EXPORT_SYMBOL_GPL(jump_label_dec_deferred);
+EXPORT_SYMBOL_GPL(__jump_label_dec_deferred);
 
-void jump_label_rate_limit(struct jump_label_key_deferred *key,
+void __jump_label_rate_limit(struct jump_label_key_deferred *key,
 		unsigned long rl)
 {
 	key->timeout = rl;
@@ -181,7 +181,7 @@ static void __jump_label_update(struct jump_label_key *key,
 static enum jump_label_type jump_label_type(struct jump_label_key *key)
 {
 	bool true_branch = jump_label_get_branch_default(key);
-	bool state = jump_label_true(key);
+	bool state = __jump_label_true(key);
 
 	if ((!true_branch && state) || (true_branch && !state))
 		return JUMP_LABEL_ENABLE;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a357dbf..8288984 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -176,14 +176,14 @@ struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR] = {
 
 static void sched_feat_disable(int i)
 {
-	if (jump_label_true(&sched_feat_keys[i]))
-		jump_label_dec(&sched_feat_keys[i]);
+	if (jump_label_true(sched_feat_keys[i]))
+		jump_label_dec(sched_feat_keys[i]);
 }
 
 static void sched_feat_enable(int i)
 {
-	if (!jump_label_true(&sched_feat_keys[i]))
-		jump_label_inc(&sched_feat_keys[i]);
+	if (!jump_label_true(sched_feat_keys[i]))
+		jump_label_inc(sched_feat_keys[i]);
 }
 #else
 static void sched_feat_disable(int i) { };
@@ -894,7 +894,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	delta -= irq_delta;
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-	if (very_unlikely((&paravirt_steal_rq_enabled))) {
+	if (very_unlikely((paravirt_steal_rq_enabled))) {
 		u64 st;
 
 		steal = paravirt_steal_clock(cpu_of(rq));
@@ -2756,7 +2756,7 @@ void account_idle_time(cputime_t cputime)
 static __always_inline bool steal_account_process_tick(void)
 {
 #ifdef CONFIG_PARAVIRT
-	if (very_unlikely(&paravirt_steal_enabled)) {
+	if (very_unlikely(paravirt_steal_enabled)) {
 		u64 steal, st = 0;
 
 		steal = paravirt_steal_clock(smp_processor_id());
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 67206ae..075c707 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1403,16 +1403,16 @@ static struct jump_label_key __cfs_bandwidth_used;
 
 static inline bool cfs_bandwidth_used(void)
 {
-	return very_unlikely(&__cfs_bandwidth_used);
+	return very_unlikely(__cfs_bandwidth_used);
 }
 
 void account_cfs_bandwidth_used(int enabled, int was_enabled)
 {
 	/* only need to count groups transitioning between enabled/!enabled */
 	if (enabled && !was_enabled)
-		jump_label_inc(&__cfs_bandwidth_used);
+		jump_label_inc(__cfs_bandwidth_used);
 	else if (!enabled && was_enabled)
-		jump_label_dec(&__cfs_bandwidth_used);
+		jump_label_dec(__cfs_bandwidth_used);
 }
 #else /* HAVE_JUMP_LABEL */
 static bool cfs_bandwidth_used(void)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index addeb9e..cc00d2a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -632,12 +632,12 @@ enum {
 #if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
 static __always_inline bool static_branch__true(struct jump_label_key *key)
 {
-	return very_likely(key); /* Not out of line branch. */
+	return __very_likely(key); /* Not out of line branch. */
 }
 
 static __always_inline bool static_branch__false(struct jump_label_key *key)
 {
-	return very_unlikely(key); /* Out of line branch. */
+	return __very_unlikely(key); /* Out of line branch. */
 }
 
 #define SCHED_FEAT(name, enabled)					\
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index ad32493..f3e40fc 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -256,9 +256,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
-	if (elem->regfunc && !jump_label_true(&elem->key) && active)
+	if (elem->regfunc && !jump_label_true(elem->key) && active)
 		elem->regfunc();
-	else if (elem->unregfunc && jump_label_true(&elem->key) && !active)
+	else if (elem->unregfunc && jump_label_true(elem->key) && !active)
 		elem->unregfunc();
 
 	/*
@@ -269,10 +269,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	if (active && !jump_label_true(&elem->key))
-		jump_label_inc(&elem->key);
-	else if (!active && jump_label_true(&elem->key))
-		jump_label_dec(&elem->key);
+	if (active && !jump_label_true(elem->key))
+		jump_label_inc(elem->key);
+	else if (!active && jump_label_true(elem->key))
+		jump_label_dec(elem->key);
 }
 
 /*
@@ -283,11 +283,11 @@ static void set_tracepoint(struct tracepoint_entry **entry,
  */
 static void disable_tracepoint(struct tracepoint *elem)
 {
-	if (elem->unregfunc && jump_label_true(&elem->key))
+	if (elem->unregfunc && jump_label_true(elem->key))
 		elem->unregfunc();
 
-	if (jump_label_true(&elem->key))
-		jump_label_dec(&elem->key);
+	if (jump_label_true(elem->key))
+		jump_label_dec(elem->key);
 	rcu_assign_pointer(elem->funcs, NULL);
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 6503c14..5f6ad5f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1457,12 +1457,12 @@ void net_enable_timestamp(void)
 
 	if (deferred) {
 		while (--deferred)
-			jump_label_dec(&netstamp_needed);
+			jump_label_dec(netstamp_needed);
 		return;
 	}
 #endif
 	WARN_ON(in_interrupt());
-	jump_label_inc(&netstamp_needed);
+	jump_label_inc(netstamp_needed);
 }
 EXPORT_SYMBOL(net_enable_timestamp);
 
@@ -1474,19 +1474,19 @@ void net_disable_timestamp(void)
 		return;
 	}
 #endif
-	jump_label_dec(&netstamp_needed);
+	jump_label_dec(netstamp_needed);
 }
 EXPORT_SYMBOL(net_disable_timestamp);
 
 static inline void net_timestamp_set(struct sk_buff *skb)
 {
 	skb->tstamp.tv64 = 0;
-	if (very_unlikely(&netstamp_needed))
+	if (very_unlikely(netstamp_needed))
 		__net_timestamp(skb);
 }
 
 #define net_timestamp_check(COND, SKB)			\
-	if (very_unlikely(&netstamp_needed)) {		\
+	if (very_unlikely(netstamp_needed)) {		\
 		if ((COND) && !(SKB)->tstamp.tv64)	\
 			__net_timestamp(SKB);		\
 	}						\
@@ -2945,7 +2945,7 @@ int netif_rx(struct sk_buff *skb)
 
 	trace_netif_rx(skb);
 #ifdef CONFIG_RPS
-	if (very_unlikely(&rps_needed)) {
+	if (very_unlikely(rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu;
 
@@ -3309,7 +3309,7 @@ int netif_receive_skb(struct sk_buff *skb)
 		return NET_RX_SUCCESS;
 
 #ifdef CONFIG_RPS
-	if (very_unlikely(&rps_needed)) {
+	if (very_unlikely(rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu, ret;
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index a1727cd..a70d56e 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -608,10 +608,10 @@ static ssize_t store_rps_map(struct netdev_rx_queue *queue,
 	spin_unlock(&rps_map_lock);
 
 	if (map)
-		jump_label_inc(&rps_needed);
+		jump_label_inc(rps_needed);
 	if (old_map) {
 		kfree_rcu(old_map, rcu);
-		jump_label_dec(&rps_needed);
+		jump_label_dec(rps_needed);
 	}
 	free_cpumask_var(mask);
 	return len;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d05559d..f3e0d88 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -69,9 +69,9 @@ static int rps_sock_flow_sysctl(ctl_table *table, int write,
 		if (sock_table != orig_sock_table) {
 			rcu_assign_pointer(rps_sock_flow_table, sock_table);
 			if (sock_table)
-				jump_label_inc(&rps_needed);
+				jump_label_inc(rps_needed);
 			if (orig_sock_table) {
-				jump_label_dec(&rps_needed);
+				jump_label_dec(rps_needed);
 				synchronize_rcu();
 				vfree(orig_sock_table);
 			}
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index 4997878..6b7f7eb 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -111,7 +111,7 @@ void tcp_destroy_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	val = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_LIMIT);
 
 	if (val != RESOURCE_MAX)
-		jump_label_dec(&memcg_socket_limit_enabled);
+		jump_label_dec(memcg_socket_limit_enabled);
 }
 EXPORT_SYMBOL(tcp_destroy_cgroup);
 
@@ -143,9 +143,9 @@ static int tcp_update_limit(struct mem_cgroup *memcg, u64 val)
 					     net->ipv4.sysctl_tcp_mem[i]);
 
 	if (val == RESOURCE_MAX && old_lim != RESOURCE_MAX)
-		jump_label_dec(&memcg_socket_limit_enabled);
+		jump_label_dec(memcg_socket_limit_enabled);
 	else if (old_lim == RESOURCE_MAX && val != RESOURCE_MAX)
-		jump_label_inc(&memcg_socket_limit_enabled);
+		jump_label_inc(memcg_socket_limit_enabled);
 
 	return 0;
 }
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b4e8ff0..f968784 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -77,7 +77,7 @@ int nf_register_hook(struct nf_hook_ops *reg)
 	list_add_rcu(&reg->list, elem->list.prev);
 	mutex_unlock(&nf_hook_mutex);
 #if defined(CONFIG_JUMP_LABEL)
-	jump_label_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
+	jump_label_inc(nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
 	return 0;
 }
@@ -89,7 +89,7 @@ void nf_unregister_hook(struct nf_hook_ops *reg)
 	list_del_rcu(&reg->list);
 	mutex_unlock(&nf_hook_mutex);
 #if defined(CONFIG_JUMP_LABEL)
-	jump_label_dec(&nf_hooks_needed[reg->pf][reg->hooknum]);
+	jump_label_dec(nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
 	synchronize_net();
 }
