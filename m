Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2EBKJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:09:58 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:57821 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab2EBKJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:09:55 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 May 2012 15:39:36 +0530
Message-Id: <20120502100936.13206.8094.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V8 16/17] kvm : Paravirtual ticketlocks support for linux guests running on KVM hypervisor
x-cbid: 12050210-2000-0000-0000-000007518922
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

During smp_boot_cpus  paravirtualied KVM guest detects if the hypervisor has
required feature (KVM_FEATURE_PV_UNHALT) to support pv-ticketlocks. If so,
 support for pv-ticketlocks is registered via pv_lock_ops.

Use KVM_HC_KICK_CPU hypercall to wakeup waiting/halted vcpu.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_para.h |   14 ++-
 arch/x86/kernel/kvm.c           |  256 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 268 insertions(+), 2 deletions(-)
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 5b647ea..77266d3 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -195,10 +195,20 @@ void kvm_async_pf_task_wait(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
-#else
-#define kvm_guest_init() do { } while (0)
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+void __init kvm_spinlock_init(void);
+#else /* !CONFIG_PARAVIRT_SPINLOCKS */
+static inline void kvm_spinlock_init(void)
+{
+}
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
+
+#else /* CONFIG_KVM_GUEST */
+#define kvm_guest_init() do {} while (0)
 #define kvm_async_pf_task_wait(T) do {} while(0)
 #define kvm_async_pf_task_wake(T) do {} while(0)
+
 static inline u32 kvm_read_and_reset_pf_reason(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ba6e4..7c46567 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -33,6 +33,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/kprobes.h>
+#include <linux/debugfs.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -368,6 +369,7 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 #endif
 	kvm_guest_cpu_init();
 	native_smp_prepare_boot_cpu();
+	kvm_spinlock_init();
 }
 
 static void __cpuinit kvm_guest_cpu_online(void *dummy)
@@ -450,3 +452,257 @@ static __init int activate_jump_labels(void)
 	return 0;
 }
 arch_initcall(activate_jump_labels);
+
+/* Kick a cpu by its apicid. Used to wake up a halted vcpu */
+void kvm_kick_cpu(int cpu)
+{
+	int apicid;
+
+	apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	kvm_hypercall1(KVM_HC_KICK_CPU, apicid);
+}
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+enum kvm_contention_stat {
+	TAKEN_SLOW,
+	TAKEN_SLOW_PICKUP,
+	RELEASED_SLOW,
+	RELEASED_SLOW_KICKED,
+	NR_CONTENTION_STATS
+};
+
+#ifdef CONFIG_KVM_DEBUG_FS
+#define HISTO_BUCKETS	30
+
+static struct kvm_spinlock_stats
+{
+	u32 contention_stats[NR_CONTENTION_STATS];
+	u32 histo_spin_blocked[HISTO_BUCKETS+1];
+	u64 time_blocked;
+} spinlock_stats;
+
+static u8 zero_stats;
+
+static inline void check_zero(void)
+{
+	u8 ret;
+	u8 old;
+
+	old = ACCESS_ONCE(zero_stats);
+	if (unlikely(old)) {
+		ret = cmpxchg(&zero_stats, old, 0);
+		/* This ensures only one fellow resets the stat */
+		if (ret == old)
+			memset(&spinlock_stats, 0, sizeof(spinlock_stats));
+	}
+}
+
+static inline void add_stats(enum kvm_contention_stat var, u32 val)
+{
+	check_zero();
+	spinlock_stats.contention_stats[var] += val;
+}
+
+
+static inline u64 spin_time_start(void)
+{
+	return sched_clock();
+}
+
+static void __spin_time_accum(u64 delta, u32 *array)
+{
+	unsigned index;
+
+	index = ilog2(delta);
+	check_zero();
+
+	if (index < HISTO_BUCKETS)
+		array[index]++;
+	else
+		array[HISTO_BUCKETS]++;
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+	u32 delta;
+
+	delta = sched_clock() - start;
+	__spin_time_accum(delta, spinlock_stats.histo_spin_blocked);
+	spinlock_stats.time_blocked += delta;
+}
+
+static struct dentry *d_spin_debug;
+static struct dentry *d_kvm_debug;
+
+struct dentry *kvm_init_debugfs(void)
+{
+	d_kvm_debug = debugfs_create_dir("kvm", NULL);
+	if (!d_kvm_debug)
+		printk(KERN_WARNING "Could not create 'kvm' debugfs directory\n");
+
+	return d_kvm_debug;
+}
+
+static int __init kvm_spinlock_debugfs(void)
+{
+	struct dentry *d_kvm;
+
+	d_kvm = kvm_init_debugfs();
+	if (d_kvm == NULL)
+		return -ENOMEM;
+
+	d_spin_debug = debugfs_create_dir("spinlocks", d_kvm);
+
+	debugfs_create_u8("zero_stats", 0644, d_spin_debug, &zero_stats);
+
+	debugfs_create_u32("taken_slow", 0444, d_spin_debug,
+		   &spinlock_stats.contention_stats[TAKEN_SLOW]);
+	debugfs_create_u32("taken_slow_pickup", 0444, d_spin_debug,
+		   &spinlock_stats.contention_stats[TAKEN_SLOW_PICKUP]);
+
+	debugfs_create_u32("released_slow", 0444, d_spin_debug,
+		   &spinlock_stats.contention_stats[RELEASED_SLOW]);
+	debugfs_create_u32("released_slow_kicked", 0444, d_spin_debug,
+		   &spinlock_stats.contention_stats[RELEASED_SLOW_KICKED]);
+
+	debugfs_create_u64("time_blocked", 0444, d_spin_debug,
+			   &spinlock_stats.time_blocked);
+
+	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
+		     spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
+
+	return 0;
+}
+fs_initcall(kvm_spinlock_debugfs);
+#else  /* !CONFIG_KVM_DEBUG_FS */
+#define TIMEOUT			(1 << 10)
+static inline void add_stats(enum kvm_contention_stat var, u32 val)
+{
+}
+
+static inline u64 spin_time_start(void)
+{
+	return 0;
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+}
+#endif  /* CONFIG_KVM_DEBUG_FS */
+
+struct kvm_lock_waiting {
+	struct arch_spinlock *lock;
+	__ticket_t want;
+};
+
+/* cpus 'waiting' on a spinlock to become available */
+static cpumask_t waiting_cpus;
+
+/* Track spinlock on which a cpu is waiting */
+static DEFINE_PER_CPU(struct kvm_lock_waiting, lock_waiting);
+
+static void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
+{
+	struct kvm_lock_waiting *w;
+	int cpu;
+	u64 start;
+	unsigned long flags;
+
+	w = &__get_cpu_var(lock_waiting);
+	cpu = smp_processor_id();
+	start = spin_time_start();
+
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+
+	/*
+	 * The ordering protocol on this is that the "lock" pointer
+	 * may only be set non-NULL if the "want" ticket is correct.
+	 * If we're updating "want", we must first clear "lock".
+	 */
+	w->lock = NULL;
+	smp_wmb();
+	w->want = want;
+	smp_wmb();
+	w->lock = lock;
+
+	add_stats(TAKEN_SLOW, 1);
+
+	/*
+	 * This uses set_bit, which is atomic but we should not rely on its
+	 * reordering gurantees. So barrier is needed after this call.
+	 */
+	cpumask_set_cpu(cpu, &waiting_cpus);
+
+	barrier();
+
+	/*
+	 * Mark entry to slowpath before doing the pickup test to make
+	 * sure we don't deadlock with an unlocker.
+	 */
+	__ticket_enter_slowpath(lock);
+
+	/*
+	 * check again make sure it didn't become free while
+	 * we weren't looking.
+	 */
+	if (ACCESS_ONCE(lock->tickets.head) == want) {
+		add_stats(TAKEN_SLOW_PICKUP, 1);
+		goto out;
+	}
+
+	/* Allow interrupts while blocked */
+	local_irq_restore(flags);
+
+	/* halt until it's our turn and kicked. */
+	halt();
+
+	local_irq_save(flags);
+out:
+	cpumask_clear_cpu(cpu, &waiting_cpus);
+	w->lock = NULL;
+	local_irq_restore(flags);
+	spin_time_accum_blocked(start);
+}
+PV_CALLEE_SAVE_REGS_THUNK(kvm_lock_spinning);
+
+/* Kick vcpu waiting on @lock->head to reach value @ticket */
+static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
+{
+	int cpu;
+
+	add_stats(RELEASED_SLOW, 1);
+	for_each_cpu(cpu, &waiting_cpus) {
+		const struct kvm_lock_waiting *w = &per_cpu(lock_waiting, cpu);
+		if (ACCESS_ONCE(w->lock) == lock &&
+		    ACCESS_ONCE(w->want) == ticket) {
+			add_stats(RELEASED_SLOW_KICKED, 1);
+			kvm_kick_cpu(cpu);
+			break;
+		}
+	}
+}
+
+/*
+ * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
+ */
+void __init kvm_spinlock_init(void)
+{
+	if (!kvm_para_available())
+		return;
+	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
+	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
+		return;
+
+	printk(KERN_INFO"KVM setup paravirtual spinlock\n");
+
+	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
+	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+}
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */

