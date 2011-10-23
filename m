Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1JWTIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:08:25 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50758 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1JWTIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:08:23 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Date: Mon, 24 Oct 2011 00:37:53 +0530
Message-Id: <20111023190753.16364.31164.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V2 5/5] kvm guest : pv-ticketlocks support for linux guests running on KVM hypervisor
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends Linux guests running on KVM hypervisor to support
pv-ticketlocks. Very early during bootup, paravirtualied KVM guest detects if 
the hypervisor has required feature (KVM_FEATURE_WAIT_FOR_KICK) to support 
pv-ticketlocks. If so, support for pv-ticketlocks is registered via pv_lock_ops.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 2874c19..c7f34b7 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -195,10 +195,18 @@ void kvm_async_pf_task_wait(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
-#else
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+void __init kvm_guest_early_init(void);
+#else /* CONFIG_PARAVIRT_SPINLOCKS */
+#define kvm_guest_early_init() do { } while (0)
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
+
+#else /* CONFIG_KVM_GUEST */
 #define kvm_guest_init() do { } while (0)
 #define kvm_async_pf_task_wait(T) do {} while(0)
 #define kvm_async_pf_task_wake(T) do {} while(0)
+#define kvm_guest_early_init() do { } while (0)
 static inline u32 kvm_read_and_reset_pf_reason(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 3bb0850..fb25bca 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -9,6 +9,7 @@
 #include <linux/start_kernel.h>
 #include <linux/mm.h>
 #include <linux/memblock.h>
+#include <linux/kvm_para.h>
 
 #include <asm/setup.h>
 #include <asm/sections.h>
@@ -59,6 +60,8 @@ void __init i386_start_kernel(void)
 		break;
 	}
 
+	 kvm_guest_early_init();
+
 	/*
 	 * At this point everything still needed from the boot loader
 	 * or BIOS or kernel text should be early reserved or marked not
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 5655c22..cabf8ec 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -13,6 +13,7 @@
 #include <linux/start_kernel.h>
 #include <linux/io.h>
 #include <linux/memblock.h>
+#include <linux/kvm_para.h>
 
 #include <asm/processor.h>
 #include <asm/proto.h>
@@ -115,6 +116,8 @@ void __init x86_64_start_reservations(char *real_mode_data)
 
 	reserve_ebda_region();
 
+	kvm_guest_early_init();
+
 	/*
 	 * At this point everything still needed from the boot loader
 	 * or BIOS or kernel text should be early reserved or marked not
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a9c2116..f4f341f 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -39,6 +39,16 @@
 #include <asm/desc.h>
 #include <asm/tlbflush.h>
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+#ifdef CONFIG_KVM_DEBUG_FS
+
+#include <linux/debugfs.h>
+
+#endif /* CONFIG_KVM_DEBUG_FS */
+
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
+
 #define MMU_QUEUE_SIZE 1024
 
 static int kvmapf = 1;
@@ -627,3 +637,240 @@ static __init int activate_jump_labels(void)
 	return 0;
 }
 arch_initcall(activate_jump_labels);
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+#ifdef CONFIG_KVM_DEBUG_FS
+
+static struct kvm_spinlock_stats
+{
+	u32 taken_slow;
+	u32 taken_slow_pickup;
+
+	u32 released_slow;
+	u32 released_slow_kicked;
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
+	if (unlikely(zero_stats)) {
+		memset(&spinlock_stats, 0, sizeof(spinlock_stats));
+		zero_stats = 0;
+	}
+}
+
+#define ADD_STATS(elem, val)			\
+	do { check_zero(); spinlock_stats.elem += (val); } while (0)
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
+			   &spinlock_stats.taken_slow);
+	debugfs_create_u32("taken_slow_pickup", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow_pickup);
+
+	debugfs_create_u32("released_slow", 0444, d_spin_debug,
+			   &spinlock_stats.released_slow);
+	debugfs_create_u32("released_slow_kicked", 0444, d_spin_debug,
+			   &spinlock_stats.released_slow_kicked);
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
+#define ADD_STATS(elem, val)	do { (void)(val); } while (0)
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
+static inline void kvm_wait_for_kick(void)
+{
+	kvm_hypercall0(KVM_HC_WAIT_FOR_KICK);
+}
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
+	ADD_STATS(taken_slow, 1);
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
+		ADD_STATS(taken_slow_pickup, 1);
+		goto out;
+	}
+
+	/* Allow interrupts while blocked */
+	local_irq_restore(flags);
+
+	kvm_wait_for_kick();
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
+	ADD_STATS(released_slow, 1);
+
+	for_each_cpu(cpu, &waiting_cpus) {
+		const struct kvm_lock_waiting *w = &per_cpu(lock_waiting, cpu);
+		if (ACCESS_ONCE(w->lock) == lock &&
+		    ACCESS_ONCE(w->want) == ticket) {
+			ADD_STATS(released_slow_kicked, 1);
+			kvm_kick_cpu(cpu);
+			break;
+		}
+	}
+}
+
+/*
+ * Setup pv_lock_ops to exploit KVM_FEATURE_WAIT_FOR_KICK if present.
+ * This needs to be setup really early in boot, before the first call to
+ * spinlock is issued!
+ */
+void __init kvm_guest_early_init(void)
+{
+	if (!kvm_para_available())
+		return;
+	/* Does host kernel support KVM_FEATURE_WAIT_FOR_KICK? */
+	if (!kvm_para_has_feature(KVM_FEATURE_WAIT_FOR_KICK))
+		return;
+
+	jump_label_inc(&paravirt_ticketlocks_enabled);
+
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
+	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+}
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
