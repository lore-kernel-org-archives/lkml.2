Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1ASRSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:18:05 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55404 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab1ASRSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:18:03 -0500
Date: Wed, 19 Jan 2011 22:47:57 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: [PATCH 3/3] kvm guest : Add support for pv-ticketlocks
Message-ID: <20110119171757.GC726@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <20110119164432.GA30669@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119164432.GA30669@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends Linux guests running on KVM hypervisor to support
pv-ticketlocks. Very early during bootup, paravirtualied KVM guest detects if 
the hypervisor has required feature (KVM_FEATURE_WAIT_FOR_KICK) to support 
pv-ticketlocks. If so, support for pv-ticketlocks is registered via pv_lock_ops.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>

---
 arch/x86/Kconfig                |    9 +
 arch/x86/include/asm/kvm_para.h |    8 +
 arch/x86/kernel/head64.c        |    3 
 arch/x86/kernel/kvm.c           |  208 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 228 insertions(+)

Index: linux-2.6.37/arch/x86/Kconfig
===================================================================
--- linux-2.6.37.orig/arch/x86/Kconfig
+++ linux-2.6.37/arch/x86/Kconfig
@@ -508,6 +508,15 @@ config KVM_GUEST
 	  This option enables various optimizations for running under the KVM
 	  hypervisor.
 
+config KVM_DEBUG_FS
+	bool "Enable debug information for KVM Guests in debugfs"
+	depends on KVM_GUEST
+	default n
+	---help---
+	  This option enables collection of various statistics for KVM guest.
+   	  Statistics are displayed in debugfs filesystem. Enabling this option
+	  may incur significant overhead.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT
Index: linux-2.6.37/arch/x86/include/asm/kvm_para.h
===================================================================
--- linux-2.6.37.orig/arch/x86/include/asm/kvm_para.h
+++ linux-2.6.37/arch/x86/include/asm/kvm_para.h
@@ -162,8 +162,16 @@ static inline unsigned int kvm_arch_para
 
 #ifdef CONFIG_KVM_GUEST
 void __init kvm_guest_init(void);
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+void __init kvm_guest_early_init(void);
+#else
+#define kvm_guest_early_init() do { } while (0)
+#endif
+
 #else
 #define kvm_guest_init() do { } while (0)
+#define kvm_guest_early_init() do { } while (0)
 #endif
 
 #endif /* __KERNEL__ */
Index: linux-2.6.37/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.37.orig/arch/x86/kernel/head64.c
+++ linux-2.6.37/arch/x86/kernel/head64.c
@@ -13,6 +13,7 @@
 #include <linux/start_kernel.h>
 #include <linux/io.h>
 #include <linux/memblock.h>
+#include <linux/kvm_para.h>
 
 #include <asm/processor.h>
 #include <asm/proto.h>
@@ -118,6 +119,8 @@ void __init x86_64_start_reservations(ch
 
 	reserve_ebda_region();
 
+	kvm_guest_early_init();
+
 	/*
 	 * At this point everything still needed from the boot loader
 	 * or BIOS or kernel text should be early reserved or marked not
Index: linux-2.6.37/arch/x86/kernel/kvm.c
===================================================================
--- linux-2.6.37.orig/arch/x86/kernel/kvm.c
+++ linux-2.6.37/arch/x86/kernel/kvm.c
@@ -238,3 +238,211 @@ void __init kvm_guest_init(void)
 
 	paravirt_ops_setup();
 }
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+#ifdef CONFIG_KVM_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/sched.h>
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
+static void kvm_lock_spinning(struct arch_spinlock *lock, unsigned want)
+{
+	struct kvm_lock_waiting *w = &__get_cpu_var(lock_waiting);
+	int cpu = smp_processor_id();
+	u64 start;
+
+	start = spin_time_start();
+
+	w->want = want;
+	w->lock = lock;
+
+	ADD_STATS(taken_slow, 1);
+
+	cpumask_set_cpu(cpu, &waiting_cpus);
+
+	/* Mark entry to slowpath before doing the pickup test to make
+	   sure we don't deadlock with an unlocker. */
+	__ticket_enter_slowpath(lock);
+
+	/* check again make sure it didn't become free while
+	   we weren't looking  */
+	if (ACCESS_ONCE(lock->tickets.head) == want) {
+		ADD_STATS(taken_slow_pickup, 1);
+		goto out;
+	}
+
+	kvm_wait_for_kick();
+
+out:
+	cpumask_clear_cpu(cpu, &waiting_cpus);
+	w->lock = NULL;
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
+static void kvm_unlock_kick(struct arch_spinlock *lock, unsigned ticket)
+{
+	int cpu;
+
+	ADD_STATS(released_slow, 1);
+
+	for_each_cpu(cpu, &waiting_cpus) {
+		const struct kvm_lock_waiting *w = &per_cpu(lock_waiting, cpu);
+		if (w->lock == lock && w->want == ticket) {
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
+
+	/* Does host kernel support KVM_FEATURE_WAIT_FOR_KICK? */
+	if (!kvm_para_has_feature(KVM_FEATURE_WAIT_FOR_KICK))
+		return;
+
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
+	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+}
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
