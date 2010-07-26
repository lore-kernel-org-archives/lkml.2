Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0GZGP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 02:15:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39650 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0GZGP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 02:15:57 -0400
Date: Mon, 26 Jul 2010 11:45:37 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: avi@redhat.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de,
        Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
        bharata@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH RFC 3/4] Paravirtualized spinlock implementation for KVM
 guests
Message-ID: <20100726061537.GC8402@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20100726061150.GB21699@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726061150.GB21699@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paravirtual spinlock implementation for KVM guests, based heavily on Xen guest's
spinlock implementation.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 arch/x86/Kconfig         |    8 +
 arch/x86/kernel/head64.c |    3 
 arch/x86/kernel/kvm.c    |  293 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_para.h |    8 +
 4 files changed, 312 insertions(+)

Index: current/arch/x86/Kconfig
===================================================================
--- current.orig/arch/x86/Kconfig
+++ current/arch/x86/Kconfig
@@ -551,6 +551,14 @@ config KVM_GUEST
 	  This option enables various optimizations for running under the KVM
 	  hypervisor.
 
+config KVM_DEBUG_FS
+	bool "Enable debug information to be collected for KVM guests"
+	default n
+	depends on KVM_GUEST && EXPERIMENTAL
+	---help---
+	  This option will collect various debug information to be collected
+	  and displayed in debugfs of guest kernel.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT
Index: current/arch/x86/kernel/head64.c
===================================================================
--- current.orig/arch/x86/kernel/head64.c
+++ current/arch/x86/kernel/head64.c
@@ -12,6 +12,7 @@
 #include <linux/percpu.h>
 #include <linux/start_kernel.h>
 #include <linux/io.h>
+#include <linux/kvm_para.h>
 
 #include <asm/processor.h>
 #include <asm/proto.h>
@@ -113,6 +114,8 @@ void __init x86_64_start_reservations(ch
 
 	reserve_ebda_region();
 
+	kvm_guest_early_init();
+
 	/*
 	 * At this point everything still needed from the boot loader
 	 * or BIOS or kernel text should be early reserved or marked not
Index: current/arch/x86/kernel/kvm.c
===================================================================
--- current.orig/arch/x86/kernel/kvm.c
+++ current/arch/x86/kernel/kvm.c
@@ -27,6 +27,8 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/hardirq.h>
+#include <linux/debugfs.h>
+#include <linux/sched.h>
 #include <asm/timer.h>
 
 #define MMU_QUEUE_SIZE 1024
@@ -238,3 +240,294 @@ void __init kvm_guest_init(void)
 
 	paravirt_ops_setup();
 }
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+#ifdef CONFIG_KVM_DEBUG_FS
+
+static struct spinlock_stats
+{
+	u64 taken;
+	u32 taken_slow;
+
+	u64 released;
+
+#define HISTO_BUCKETS	30
+	u32 histo_spin_total[HISTO_BUCKETS+1];
+	u32 histo_spin_spinning[HISTO_BUCKETS+1];
+	u32 histo_spin_blocked[HISTO_BUCKETS+1];
+
+	u64 time_total;
+	u64 time_spinning;
+	u64 time_blocked;
+} spinlock_stats;
+
+static u8 zero_stats;
+
+static unsigned lock_timeout = 1 << 10;
+#define TIMEOUT lock_timeout
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
+static inline void spin_time_accum_spinning(u64 start)
+{
+	u32 delta = sched_clock() - start;
+
+	__spin_time_accum(delta, spinlock_stats.histo_spin_spinning);
+	spinlock_stats.time_spinning += delta;
+}
+
+static inline void spin_time_accum_total(u64 start)
+{
+	u32 delta = sched_clock() - start;
+
+	__spin_time_accum(delta, spinlock_stats.histo_spin_total);
+	spinlock_stats.time_total += delta;
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
+
+static int __init kvm_spinlock_debugfs(void)
+{
+	struct dentry *d_parent;
+
+	d_parent = debugfs_create_dir("kvm", NULL);
+	if (IS_ERR(d_parent)) {
+		printk(KERN_WARNING "Could not create \"kvm\" directory in "\
+			"debugfs (errno = %li)\n", PTR_ERR(d_parent));
+		return PTR_ERR(d_parent);
+	}
+
+	d_spin_debug = debugfs_create_dir("spinlocks", d_parent);
+
+	debugfs_create_u8("zero_stats", 0644, d_spin_debug, &zero_stats);
+
+	debugfs_create_u32("timeout", 0644, d_spin_debug, &lock_timeout);
+
+	debugfs_create_u64("taken", 0444, d_spin_debug, &spinlock_stats.taken);
+	debugfs_create_u32("taken_slow", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow);
+
+	debugfs_create_u64("released", 0444, d_spin_debug,
+			   &spinlock_stats.released);
+
+	debugfs_create_u64("time_spinning", 0444, d_spin_debug,
+			   &spinlock_stats.time_spinning);
+	debugfs_create_u64("time_blocked", 0444, d_spin_debug,
+			   &spinlock_stats.time_blocked);
+	debugfs_create_u64("time_total", 0444, d_spin_debug,
+			   &spinlock_stats.time_total);
+
+	debugfs_create_u32_array("histo_total", 0444, d_spin_debug,
+		     spinlock_stats.histo_spin_total, HISTO_BUCKETS + 1);
+	debugfs_create_u32_array("histo_spinning", 0444, d_spin_debug,
+		     spinlock_stats.histo_spin_spinning, HISTO_BUCKETS + 1);
+	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
+		     spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
+
+	return 0;
+}
+fs_initcall(kvm_spinlock_debugfs);
+
+#else  /* CONFIG_KVM_DEBUG_FS */
+
+#define TIMEOUT			(1 << 10)
+#define ADD_STATS(elem, val)	do { (void)(val); } while (0)
+
+static inline u64 spin_time_start(void)
+{
+	return 0;
+}
+
+static inline void spin_time_accum_total(u64 start)
+{
+}
+
+static inline void spin_time_accum_spinning(u64 start)
+{
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+}
+
+#endif  /* CONFIG_KVM_DEBUG_FS */
+
+struct kvm_spinlock {
+	unsigned char lock;		/* 0 -> free; 1 -> locked */
+	unsigned short spinners;	/* count of waiting cpus */
+};
+
+/*
+ * Mark a cpu as interested in a lock.  Returns the CPU's previous
+ * lock of interest, in case we got preempted by an interrupt.
+ */
+static inline void spinning_lock(struct kvm_spinlock *pl)
+{
+	asm(LOCK_PREFIX " incw %0"
+	    : "+m" (pl->spinners) : : "memory");
+}
+
+/*
+ * Mark a cpu as no longer interested in a lock.  Restores previous
+ * lock of interest (NULL for none).
+ */
+static inline void unspinning_lock(struct kvm_spinlock *pl)
+{
+	asm(LOCK_PREFIX " decw %0"
+	    : "+m" (pl->spinners) : : "memory");
+}
+
+static int kvm_spin_is_locked(struct arch_spinlock *lock)
+{
+	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
+
+	return sl->lock != 0;
+}
+
+static int kvm_spin_is_contended(struct arch_spinlock *lock)
+{
+	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
+
+	/* Not strictly true; this is only the count of contended
+	   lock-takers entering the slow path. */
+	return sl->spinners != 0;
+}
+
+static int kvm_spin_trylock(struct arch_spinlock *lock)
+{
+	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
+	u8 old = 1;
+
+	asm("xchgb %b0,%1"
+	    : "+q" (old), "+m" (sl->lock) : : "memory");
+
+	return old == 0;
+}
+
+static noinline int kvm_spin_lock_slow(struct arch_spinlock *lock)
+{
+	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
+	u64 start;
+
+	ADD_STATS(taken_slow, 1);
+
+	/* announce we're spinning */
+	spinning_lock(sl);
+
+	start = spin_time_start();
+	kvm_hypercall0(KVM_HC_YIELD);
+	spin_time_accum_blocked(start);
+
+	unspinning_lock(sl);
+
+	return 0;
+}
+
+static inline void __kvm_spin_lock(struct arch_spinlock *lock)
+{
+	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
+	unsigned timeout;
+	u8 oldval;
+	u64 start_spin;
+
+	ADD_STATS(taken, 1);
+
+	start_spin = spin_time_start();
+
+	do {
+		u64 start_spin_fast = spin_time_start();
+
+		timeout = TIMEOUT;
+
+		asm("1: xchgb %1,%0\n"
+		    "   testb %1,%1\n"
+		    "   jz 3f\n"
+		    "2: rep;nop\n"
+		    "   cmpb $0,%0\n"
+		    "   je 1b\n"
+		    "   dec %2\n"
+		    "   jnz 2b\n"
+		    "3:\n"
+		    : "+m" (sl->lock), "=q" (oldval), "+r" (timeout)
+		    : "1" (1)
+		    : "memory");
+
+		spin_time_accum_spinning(start_spin_fast);
+
+	} while (unlikely(oldval != 0 &&
+		  (TIMEOUT == ~0 || !kvm_spin_lock_slow(lock))));
+
+	spin_time_accum_total(start_spin);
+}
+
+static void kvm_spin_lock(struct arch_spinlock *lock)
+{
+	__kvm_spin_lock(lock);
+}
+
+static void kvm_spin_lock_flags(struct arch_spinlock *lock, unsigned long flags)
+{
+	__kvm_spin_lock(lock);
+}
+
+static void kvm_spin_unlock(struct arch_spinlock *lock)
+{
+	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
+
+	ADD_STATS(released, 1);
+
+	smp_wmb();		/* make sure no writes get moved after unlock */
+	sl->lock = 0;		/* release lock */
+}
+
+void __init kvm_guest_early_init(void)
+{
+	if (!kvm_para_available())
+		return;
+
+	if (!kvm_para_has_feature(KVM_FEATURE_YIELD))
+		return;
+
+	pv_lock_ops.spin_is_locked = kvm_spin_is_locked;
+	pv_lock_ops.spin_is_contended = kvm_spin_is_contended;
+	pv_lock_ops.spin_lock = kvm_spin_lock;
+	pv_lock_ops.spin_lock_flags = kvm_spin_lock_flags;
+	pv_lock_ops.spin_trylock = kvm_spin_trylock;
+	pv_lock_ops.spin_unlock = kvm_spin_unlock;
+}
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
Index: current/include/linux/kvm_para.h
===================================================================
--- current.orig/include/linux/kvm_para.h
+++ current/include/linux/kvm_para.h
@@ -27,8 +27,16 @@
 #ifdef __KERNEL__
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
 
 static inline int kvm_para_has_feature(unsigned int feature)
