Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab1K3JA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:00:59 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52520 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab1K3JA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:00:56 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 30 Nov 2011 14:30:38 +0530
Message-Id: <20111130090038.23386.4505.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com>
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V3 4/4] kvm : pv-ticketlocks support for linux guests running on KVM hypervisor
x-cbid: 11113009-2398-0000-0000-000002641A02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends Linux guests running on KVM hypervisor to support
pv-ticketlocks. 
During smp_boot_cpus  paravirtualied KVM guest detects if the hypervisor has
required feature (KVM_FEATURE_KICK_VCPU) to support pv-ticketlocks. If so,
 support for pv-ticketlocks is registered via pv_lock_ops.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 8b1d65d..7e419ad 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -195,10 +195,21 @@ void kvm_async_pf_task_wait(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
-#else
-#define kvm_guest_init() do { } while (0)
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+void __init kvm_spinlock_init(void);
+#else /* CONFIG_PARAVIRT_SPINLOCKS */
+static void kvm_spinlock_init(void)
+{
+}
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
+
+#else /* CONFIG_KVM_GUEST */
+#define kvm_guest_init() do {} while (0)
 #define kvm_async_pf_task_wait(T) do {} while(0)
 #define kvm_async_pf_task_wake(T) do {} while(0)
+#define kvm_spinlock_init() do {} while (0)
+
 static inline u32 kvm_read_and_reset_pf_reason(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a9c2116..dffeea3 100644
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
@@ -545,6 +546,7 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 #endif
 	kvm_guest_cpu_init();
 	native_smp_prepare_boot_cpu();
+	kvm_spinlock_init();
 }
 
 static void __cpuinit kvm_guest_cpu_online(void *dummy)
@@ -627,3 +629,248 @@ static __init int activate_jump_labels(void)
 	return 0;
 }
 arch_initcall(activate_jump_labels);
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
+
+static struct kvm_spinlock_stats
+{
+	u32 contention_stats[NR_CONTENTION_STATS];
+
+#define HISTO_BUCKETS	30
+	u32 histo_spin_blocked[HISTO_BUCKETS+1];
+
+	u64 time_blocked;
+} spinlock_stats;
+
+static u8 zero_stats;
+
+static inline void check_zero(void)
+{
+	u8 ret;
+	u8 old = ACCESS_ONCE(zero_stats);
+	if (unlikely(old)) {
+		ret = cmpxchg(&zero_stats, old, 0);
+		/* This ensures only one fellow resets the stat */
+		if (ret == old)
+			memset(&spinlock_stats, 0, sizeof(spinlock_stats));
+	}
+}
+
+static inline void add_stats(enum kvm_contention_stat var, int val)
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
+	unsigned index = ilog2(delta);
+
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
+	u32 delta = sched_clock() - start;
+
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
+	struct dentry *d_kvm = kvm_init_debugfs();
+
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
+	struct kvm_lock_waiting *w = &__get_cpu_var(lock_waiting);
+	int cpu = smp_processor_id();
+	u64 start;
+	unsigned long flags;
+
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
+/* Kick a cpu */
+static inline void kvm_kick_cpu(int cpu)
+{
+	kvm_hypercall1(KVM_HC_KICK_CPU, cpu);
+}
+
+/* Kick vcpu waiting on @lock->head to reach value @ticket */
+static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
+{
+	int cpu;
+
+	add_stats(RELEASED_SLOW, 1);
+
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
+ * Setup pv_lock_ops to exploit KVM_FEATURE_KICK_VCPU if present.
+ */
+void __init kvm_spinlock_init(void)
+{
+	if (!kvm_para_available())
+		return;
+	/* Does host kernel support KVM_FEATURE_KICK_VCPU? */
+	if (!kvm_para_has_feature(KVM_FEATURE_KICK_VCPU))
+		return;
+
+	jump_label_inc(&paravirt_ticketlocks_enabled);
+
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
+	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+}
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8f4b6db..a89546b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1518,6 +1518,12 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 			kvm_make_request(KVM_REQ_UNHALT, vcpu);
 			break;
 		}
+		if (vcpu->kicked) {
+			vcpu->kicked = 0;
+			barrier();
+			kvm_make_request(KVM_REQ_UNHALT, vcpu);
+			break;
+		}
 		if (kvm_cpu_has_pending_timer(vcpu))
 			break;
 		if (signal_pending(current))

