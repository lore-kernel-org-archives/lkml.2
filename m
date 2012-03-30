Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188Ab2C3Wtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:49:40 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935016Ab2C3VGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:17 -0400
Message-Id: <201203302105.q2UL597x006310@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 16:01:48 -0400
Subject: [PATCH] arch/tile: fix hardwall for tilegx and generalize for idn and ipi
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:09.0850 (UTC) FILETIME=[CA8B23A0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardwall drain code was not properly implemented for tilegx,
just tilepro, so you couldn't reliably restart an application that
made use of the udn.

In addition, the code was only applicable to the udn (user dynamic
network).  On tilegx there is a second user network that is available
(the "idn"), and there is support for having I/O shims deliver
user-level interrupts to applications ("ipi") which functions in a
very similar way to the inter-core permissions used for udn/idn.
So this change also generalizes the code from supporting just the udn
to supports udn/idn/ipi on tilegx.

By default we now use /dev/hardwall/{udn,idn,ipi} with separate
minor numbers for the three devices.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/spr_def_32.h |   56 +++
 arch/tile/include/arch/spr_def_64.h |   43 ++
 arch/tile/include/asm/hardwall.h    |   18 +-
 arch/tile/include/asm/processor.h   |   17 +-
 arch/tile/include/asm/system.h      |   10 +-
 arch/tile/kernel/hardwall.c         |  754 +++++++++++++++++++++++------------
 arch/tile/kernel/intvec_64.S        |    2 +-
 arch/tile/kernel/process.c          |   16 +-
 8 files changed, 636 insertions(+), 280 deletions(-)

diff --git a/arch/tile/include/arch/spr_def_32.h b/arch/tile/include/arch/spr_def_32.h
index bbc1f4c..78bbce2 100644
--- a/arch/tile/include/arch/spr_def_32.h
+++ b/arch/tile/include/arch/spr_def_32.h
@@ -65,6 +65,31 @@
 #define SPR_EX_CONTEXT_2_1__ICS_RMASK 0x1
 #define SPR_EX_CONTEXT_2_1__ICS_MASK  0x4
 #define SPR_FAIL 0x4e09
+#define SPR_IDN_AVAIL_EN 0x3e05
+#define SPR_IDN_CA_DATA 0x0b00
+#define SPR_IDN_DATA_AVAIL 0x0b03
+#define SPR_IDN_DEADLOCK_TIMEOUT 0x3406
+#define SPR_IDN_DEMUX_CA_COUNT 0x0a05
+#define SPR_IDN_DEMUX_COUNT_0 0x0a06
+#define SPR_IDN_DEMUX_COUNT_1 0x0a07
+#define SPR_IDN_DEMUX_CTL 0x0a08
+#define SPR_IDN_DEMUX_QUEUE_SEL 0x0a0a
+#define SPR_IDN_DEMUX_STATUS 0x0a0b
+#define SPR_IDN_DEMUX_WRITE_FIFO 0x0a0c
+#define SPR_IDN_DIRECTION_PROTECT 0x2e05
+#define SPR_IDN_PENDING 0x0a0e
+#define SPR_IDN_REFILL_EN 0x0e05
+#define SPR_IDN_SP_FIFO_DATA 0x0a0f
+#define SPR_IDN_SP_FIFO_SEL 0x0a10
+#define SPR_IDN_SP_FREEZE 0x0a11
+#define SPR_IDN_SP_FREEZE__SP_FRZ_MASK  0x1
+#define SPR_IDN_SP_FREEZE__DEMUX_FRZ_MASK  0x2
+#define SPR_IDN_SP_FREEZE__NON_DEST_EXT_MASK  0x4
+#define SPR_IDN_SP_STATE 0x0a12
+#define SPR_IDN_TAG_0 0x0a13
+#define SPR_IDN_TAG_1 0x0a14
+#define SPR_IDN_TAG_VALID 0x0a15
+#define SPR_IDN_TILE_COORD 0x0a16
 #define SPR_INTCTRL_0_STATUS 0x4a07
 #define SPR_INTCTRL_1_STATUS 0x4807
 #define SPR_INTCTRL_2_STATUS 0x4607
@@ -87,12 +112,36 @@
 #define SPR_INTERRUPT_MASK_SET_1_1 0x480e
 #define SPR_INTERRUPT_MASK_SET_2_0 0x460c
 #define SPR_INTERRUPT_MASK_SET_2_1 0x460d
+#define SPR_MPL_AUX_PERF_COUNT_SET_0 0x6000
+#define SPR_MPL_AUX_PERF_COUNT_SET_1 0x6001
+#define SPR_MPL_AUX_PERF_COUNT_SET_2 0x6002
 #define SPR_MPL_DMA_CPL_SET_0 0x5800
 #define SPR_MPL_DMA_CPL_SET_1 0x5801
 #define SPR_MPL_DMA_CPL_SET_2 0x5802
 #define SPR_MPL_DMA_NOTIFY_SET_0 0x3800
 #define SPR_MPL_DMA_NOTIFY_SET_1 0x3801
 #define SPR_MPL_DMA_NOTIFY_SET_2 0x3802
+#define SPR_MPL_IDN_ACCESS_SET_0 0x0a00
+#define SPR_MPL_IDN_ACCESS_SET_1 0x0a01
+#define SPR_MPL_IDN_ACCESS_SET_2 0x0a02
+#define SPR_MPL_IDN_AVAIL_SET_0 0x3e00
+#define SPR_MPL_IDN_AVAIL_SET_1 0x3e01
+#define SPR_MPL_IDN_AVAIL_SET_2 0x3e02
+#define SPR_MPL_IDN_CA_SET_0 0x3a00
+#define SPR_MPL_IDN_CA_SET_1 0x3a01
+#define SPR_MPL_IDN_CA_SET_2 0x3a02
+#define SPR_MPL_IDN_COMPLETE_SET_0 0x1200
+#define SPR_MPL_IDN_COMPLETE_SET_1 0x1201
+#define SPR_MPL_IDN_COMPLETE_SET_2 0x1202
+#define SPR_MPL_IDN_FIREWALL_SET_0 0x2e00
+#define SPR_MPL_IDN_FIREWALL_SET_1 0x2e01
+#define SPR_MPL_IDN_FIREWALL_SET_2 0x2e02
+#define SPR_MPL_IDN_REFILL_SET_0 0x0e00
+#define SPR_MPL_IDN_REFILL_SET_1 0x0e01
+#define SPR_MPL_IDN_REFILL_SET_2 0x0e02
+#define SPR_MPL_IDN_TIMER_SET_0 0x3400
+#define SPR_MPL_IDN_TIMER_SET_1 0x3401
+#define SPR_MPL_IDN_TIMER_SET_2 0x3402
 #define SPR_MPL_INTCTRL_0_SET_0 0x4a00
 #define SPR_MPL_INTCTRL_0_SET_1 0x4a01
 #define SPR_MPL_INTCTRL_0_SET_2 0x4a02
@@ -102,6 +151,9 @@
 #define SPR_MPL_INTCTRL_2_SET_0 0x4600
 #define SPR_MPL_INTCTRL_2_SET_1 0x4601
 #define SPR_MPL_INTCTRL_2_SET_2 0x4602
+#define SPR_MPL_PERF_COUNT_SET_0 0x4200
+#define SPR_MPL_PERF_COUNT_SET_1 0x4201
+#define SPR_MPL_PERF_COUNT_SET_2 0x4202
 #define SPR_MPL_SN_ACCESS_SET_0 0x0800
 #define SPR_MPL_SN_ACCESS_SET_1 0x0801
 #define SPR_MPL_SN_ACCESS_SET_2 0x0802
@@ -181,6 +233,7 @@
 #define SPR_UDN_DEMUX_STATUS 0x0c0d
 #define SPR_UDN_DEMUX_WRITE_FIFO 0x0c0e
 #define SPR_UDN_DIRECTION_PROTECT 0x3005
+#define SPR_UDN_PENDING 0x0c10
 #define SPR_UDN_REFILL_EN 0x1005
 #define SPR_UDN_SP_FIFO_DATA 0x0c11
 #define SPR_UDN_SP_FIFO_SEL 0x0c12
@@ -195,6 +248,9 @@
 #define SPR_UDN_TAG_3 0x0c18
 #define SPR_UDN_TAG_VALID 0x0c19
 #define SPR_UDN_TILE_COORD 0x0c1a
+#define SPR_WATCH_CTL 0x4209
+#define SPR_WATCH_MASK 0x420a
+#define SPR_WATCH_VAL 0x420b
 
 #endif /* !defined(__ARCH_SPR_DEF_H__) */
 
diff --git a/arch/tile/include/arch/spr_def_64.h b/arch/tile/include/arch/spr_def_64.h
index cd3e5f9..0da86fa 100644
--- a/arch/tile/include/arch/spr_def_64.h
+++ b/arch/tile/include/arch/spr_def_64.h
@@ -52,6 +52,13 @@
 #define SPR_EX_CONTEXT_2_1__ICS_RMASK 0x1
 #define SPR_EX_CONTEXT_2_1__ICS_MASK  0x4
 #define SPR_FAIL 0x2707
+#define SPR_IDN_AVAIL_EN 0x1a05
+#define SPR_IDN_DATA_AVAIL 0x0a80
+#define SPR_IDN_DEADLOCK_TIMEOUT 0x1806
+#define SPR_IDN_DEMUX_COUNT_0 0x0a05
+#define SPR_IDN_DEMUX_COUNT_1 0x0a06
+#define SPR_IDN_DIRECTION_PROTECT 0x1405
+#define SPR_IDN_PENDING 0x0a08
 #define SPR_ILL_TRANS_REASON__I_STREAM_VA_RMASK 0x1
 #define SPR_INTCTRL_0_STATUS 0x2505
 #define SPR_INTCTRL_1_STATUS 0x2405
@@ -88,9 +95,27 @@
 #define SPR_IPI_MASK_SET_0 0x1f0a
 #define SPR_IPI_MASK_SET_1 0x1e0a
 #define SPR_IPI_MASK_SET_2 0x1d0a
+#define SPR_MPL_AUX_PERF_COUNT_SET_0 0x2100
+#define SPR_MPL_AUX_PERF_COUNT_SET_1 0x2101
+#define SPR_MPL_AUX_PERF_COUNT_SET_2 0x2102
 #define SPR_MPL_AUX_TILE_TIMER_SET_0 0x1700
 #define SPR_MPL_AUX_TILE_TIMER_SET_1 0x1701
 #define SPR_MPL_AUX_TILE_TIMER_SET_2 0x1702
+#define SPR_MPL_IDN_ACCESS_SET_0 0x0a00
+#define SPR_MPL_IDN_ACCESS_SET_1 0x0a01
+#define SPR_MPL_IDN_ACCESS_SET_2 0x0a02
+#define SPR_MPL_IDN_AVAIL_SET_0 0x1a00
+#define SPR_MPL_IDN_AVAIL_SET_1 0x1a01
+#define SPR_MPL_IDN_AVAIL_SET_2 0x1a02
+#define SPR_MPL_IDN_COMPLETE_SET_0 0x0500
+#define SPR_MPL_IDN_COMPLETE_SET_1 0x0501
+#define SPR_MPL_IDN_COMPLETE_SET_2 0x0502
+#define SPR_MPL_IDN_FIREWALL_SET_0 0x1400
+#define SPR_MPL_IDN_FIREWALL_SET_1 0x1401
+#define SPR_MPL_IDN_FIREWALL_SET_2 0x1402
+#define SPR_MPL_IDN_TIMER_SET_0 0x1800
+#define SPR_MPL_IDN_TIMER_SET_1 0x1801
+#define SPR_MPL_IDN_TIMER_SET_2 0x1802
 #define SPR_MPL_INTCTRL_0_SET_0 0x2500
 #define SPR_MPL_INTCTRL_0_SET_1 0x2501
 #define SPR_MPL_INTCTRL_0_SET_2 0x2502
@@ -100,6 +125,21 @@
 #define SPR_MPL_INTCTRL_2_SET_0 0x2300
 #define SPR_MPL_INTCTRL_2_SET_1 0x2301
 #define SPR_MPL_INTCTRL_2_SET_2 0x2302
+#define SPR_MPL_IPI_0 0x1f04
+#define SPR_MPL_IPI_0_SET_0 0x1f00
+#define SPR_MPL_IPI_0_SET_1 0x1f01
+#define SPR_MPL_IPI_0_SET_2 0x1f02
+#define SPR_MPL_IPI_1 0x1e04
+#define SPR_MPL_IPI_1_SET_0 0x1e00
+#define SPR_MPL_IPI_1_SET_1 0x1e01
+#define SPR_MPL_IPI_1_SET_2 0x1e02
+#define SPR_MPL_IPI_2 0x1d04
+#define SPR_MPL_IPI_2_SET_0 0x1d00
+#define SPR_MPL_IPI_2_SET_1 0x1d01
+#define SPR_MPL_IPI_2_SET_2 0x1d02
+#define SPR_MPL_PERF_COUNT_SET_0 0x2000
+#define SPR_MPL_PERF_COUNT_SET_1 0x2001
+#define SPR_MPL_PERF_COUNT_SET_2 0x2002
 #define SPR_MPL_UDN_ACCESS_SET_0 0x0b00
 #define SPR_MPL_UDN_ACCESS_SET_1 0x0b01
 #define SPR_MPL_UDN_ACCESS_SET_2 0x0b02
@@ -167,6 +207,9 @@
 #define SPR_UDN_DEMUX_COUNT_2 0x0b07
 #define SPR_UDN_DEMUX_COUNT_3 0x0b08
 #define SPR_UDN_DIRECTION_PROTECT 0x1505
+#define SPR_UDN_PENDING 0x0b0a
+#define SPR_WATCH_MASK 0x200a
+#define SPR_WATCH_VAL 0x200b
 
 #endif /* !defined(__ARCH_SPR_DEF_H__) */
 
diff --git a/arch/tile/include/asm/hardwall.h b/arch/tile/include/asm/hardwall.h
index 2ac4228..47514a5 100644
--- a/arch/tile/include/asm/hardwall.h
+++ b/arch/tile/include/asm/hardwall.h
@@ -11,12 +11,14 @@
  *   NON INFRINGEMENT.  See the GNU General Public License for
  *   more details.
  *
- * Provide methods for the HARDWALL_FILE for accessing the UDN.
+ * Provide methods for access control of per-cpu resources like
+ * UDN, IDN, or IPI.
  */
 
 #ifndef _ASM_TILE_HARDWALL_H
 #define _ASM_TILE_HARDWALL_H
 
+#include <arch/chip.h>
 #include <linux/ioctl.h>
 
 #define HARDWALL_IOCTL_BASE 0xa2
@@ -24,8 +26,9 @@
 /*
  * The HARDWALL_CREATE() ioctl is a macro with a "size" argument.
  * The resulting ioctl value is passed to the kernel in conjunction
- * with a pointer to a little-endian bitmask of cpus, which must be
- * physically in a rectangular configuration on the chip.
+ * with a pointer to a standard kernel bitmask of cpus.
+ * For network resources (UDN or IDN) the bitmask must physically
+ * represent a rectangular configuration on the chip.
  * The "size" is the number of bytes of cpu mask data.
  */
 #define _HARDWALL_CREATE 1
@@ -44,13 +47,7 @@
 #define HARDWALL_GET_ID \
  _IO(HARDWALL_IOCTL_BASE, _HARDWALL_GET_ID)
 
-#ifndef __KERNEL__
-
-/* This is the canonical name expected by userspace. */
-#define HARDWALL_FILE "/dev/hardwall"
-
-#else
-
+#ifdef __KERNEL__
 /* /proc hooks for hardwall. */
 struct proc_dir_entry;
 #ifdef CONFIG_HARDWALL
@@ -59,7 +56,6 @@ int proc_pid_hardwall(struct task_struct *task, char *buffer);
 #else
 static inline void proc_tile_hardwall_init(struct proc_dir_entry *root) {}
 #endif
-
 #endif
 
 #endif /* _ASM_TILE_HARDWALL_H */
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 34c1e01..e85a9af 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -76,6 +76,17 @@ struct async_tlb {
 
 #ifdef CONFIG_HARDWALL
 struct hardwall_info;
+struct hardwall_task {
+	/* Which hardwall is this task tied to? (or NULL if none) */
+	struct hardwall_info *info;
+	/* Chains this task into the list at info->task_head. */
+	struct list_head list;
+};
+#ifdef __tilepro__
+#define HARDWALL_TYPES 1   /* udn */
+#else
+#define HARDWALL_TYPES 3   /* udn, idn, and ipi */
+#endif
 #endif
 
 struct thread_struct {
@@ -116,10 +127,8 @@ struct thread_struct {
 	unsigned long dstream_pf;
 #endif
 #ifdef CONFIG_HARDWALL
-	/* Is this task tied to an activated hardwall? */
-	struct hardwall_info *hardwall;
-	/* Chains this task into the list at hardwall->list. */
-	struct list_head hardwall_list;
+	/* Hardwall information for various resources. */
+	struct hardwall_task hardwall[HARDWALL_TYPES];
 #endif
 #if CHIP_HAS_TILE_DMA()
 	/* Async DMA TLB fault information */
diff --git a/arch/tile/include/asm/system.h b/arch/tile/include/asm/system.h
index 23d1842..9a6f58e 100644
--- a/arch/tile/include/asm/system.h
+++ b/arch/tile/include/asm/system.h
@@ -223,14 +223,14 @@ void restrict_dma_mpls(void);
 #ifdef CONFIG_HARDWALL
 /* User-level network management functions */
 void reset_network_state(void);
-void grant_network_mpls(void);
-void restrict_network_mpls(void);
-int hardwall_deactivate(struct task_struct *task);
+void hardwall_switch_tasks(struct task_struct *prev, struct task_struct *next);
+void hardwall_deactivate_all(struct task_struct *task);
+int hardwall_ipi_valid(int cpu);
 
 /* Hook hardwall code into changes in affinity. */
 #define arch_set_cpus_allowed(p, new_mask) do { \
-	if (p->thread.hardwall && !cpumask_equal(&p->cpus_allowed, new_mask)) \
-		hardwall_deactivate(p); \
+	if (!cpumask_equal(&p->cpus_allowed, new_mask)) \
+		hardwall_deactivate_all(p); \
 } while (0)
 #endif
 
diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index 8c41891..20273ee 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -33,59 +33,157 @@
 
 
 /*
- * This data structure tracks the rectangle data, etc., associated
- * one-to-one with a "struct file *" from opening HARDWALL_FILE.
+ * Implement a per-cpu "hardwall" resource class such as UDN or IPI.
+ * We use "hardwall" nomenclature throughout for historical reasons.
+ * The lock here controls access to the list data structure as well as
+ * to the items on the list.
+ */
+struct hardwall_type {
+	int index;
+	int is_xdn;
+	int is_idn;
+	int disabled;
+	const char *name;
+	struct list_head list;
+	spinlock_t lock;
+	struct proc_dir_entry *proc_dir;
+};
+
+enum hardwall_index {
+	HARDWALL_UDN = 0,
+#ifndef __tilepro__
+	HARDWALL_IDN = 1,
+	HARDWALL_IPI = 2,
+#endif
+	_HARDWALL_TYPES
+};
+
+static struct hardwall_type hardwall_types[] = {
+	{  /* user-space access to UDN */
+		0,
+		1,
+		0,
+		0,
+		"udn",
+		LIST_HEAD_INIT(hardwall_types[HARDWALL_UDN].list),
+		__SPIN_LOCK_INITIALIZER(hardwall_types[HARDWALL_UDN].lock),
+		NULL
+	},
+#ifndef __tilepro__
+	{  /* user-space access to IDN */
+		1,
+		1,
+		1,
+		1,  /* disabled pending hypervisor support */
+		"idn",
+		LIST_HEAD_INIT(hardwall_types[HARDWALL_IDN].list),
+		__SPIN_LOCK_INITIALIZER(hardwall_types[HARDWALL_IDN].lock),
+		NULL
+	},
+	{  /* access to user-space IPI */
+		2,
+		0,
+		0,
+		0,
+		"ipi",
+		LIST_HEAD_INIT(hardwall_types[HARDWALL_IPI].list),
+		__SPIN_LOCK_INITIALIZER(hardwall_types[HARDWALL_IPI].lock),
+		NULL
+	},
+#endif
+};
+
+/*
+ * This data structure tracks the cpu data, etc., associated
+ * one-to-one with a "struct file *" from opening a hardwall device file.
  * Note that the file's private data points back to this structure.
  */
 struct hardwall_info {
-	struct list_head list;             /* "rectangles" list */
+	struct list_head list;             /* for hardwall_types.list */
 	struct list_head task_head;        /* head of tasks in this hardwall */
-	struct cpumask cpumask;            /* cpus in the rectangle */
+	struct hardwall_type *type;        /* type of this resource */
+	struct cpumask cpumask;            /* cpus reserved */
+	int id;                            /* integer id for this hardwall */
+	int teardown_in_progress;          /* are we tearing this one down? */
+
+	/* Remaining fields only valid for user-network resources. */
 	int ulhc_x;                        /* upper left hand corner x coord */
 	int ulhc_y;                        /* upper left hand corner y coord */
 	int width;                         /* rectangle width */
 	int height;                        /* rectangle height */
-	int id;                            /* integer id for this hardwall */
-	int teardown_in_progress;          /* are we tearing this one down? */
+#if CHIP_HAS_REV1_XDN()
+	atomic_t xdn_pending_count;        /* cores in phase 1 of drain */
+#endif
 };
 
-/* Currently allocated hardwall rectangles */
-static LIST_HEAD(rectangles);
 
 /* /proc/tile/hardwall */
 static struct proc_dir_entry *hardwall_proc_dir;
 
 /* Functions to manage files in /proc/tile/hardwall. */
-static void hardwall_add_proc(struct hardwall_info *rect);
-static void hardwall_remove_proc(struct hardwall_info *rect);
-
-/*
- * Guard changes to the hardwall data structures.
- * This could be finer grained (e.g. one lock for the list of hardwall
- * rectangles, then separate embedded locks for each one's list of tasks),
- * but there are subtle correctness issues when trying to start with
- * a task's "hardwall" pointer and lock the correct rectangle's embedded
- * lock in the presence of a simultaneous deactivation, so it seems
- * easier to have a single lock, given that none of these data
- * structures are touched very frequently during normal operation.
- */
-static DEFINE_SPINLOCK(hardwall_lock);
+static void hardwall_add_proc(struct hardwall_info *);
+static void hardwall_remove_proc(struct hardwall_info *);
 
 /* Allow disabling UDN access. */
-static int udn_disabled;
 static int __init noudn(char *str)
 {
 	pr_info("User-space UDN access is disabled\n");
-	udn_disabled = 1;
+	hardwall_types[HARDWALL_UDN].disabled = 1;
 	return 0;
 }
 early_param("noudn", noudn);
 
+#ifndef __tilepro__
+/* Allow disabling IDN access. */
+static int __init noidn(char *str)
+{
+	pr_info("User-space IDN access is disabled\n");
+	hardwall_types[HARDWALL_IDN].disabled = 1;
+	return 0;
+}
+early_param("noidn", noidn);
+
+/* Allow disabling IPI access. */
+static int __init noipi(char *str)
+{
+	pr_info("User-space IPI access is disabled\n");
+	hardwall_types[HARDWALL_IPI].disabled = 1;
+	return 0;
+}
+early_param("noipi", noipi);
+#endif
+
 
 /*
- * Low-level primitives
+ * Low-level primitives for UDN/IDN
  */
 
+#ifdef __tilepro__
+#define mtspr_XDN(hwt, name, val) \
+	do { (void)(hwt); __insn_mtspr(SPR_UDN_##name, (val)); } while (0)
+#define mtspr_MPL_XDN(hwt, name, val) \
+	do { (void)(hwt); __insn_mtspr(SPR_MPL_UDN_##name, (val)); } while (0)
+#define mfspr_XDN(hwt, name) \
+	((void)(hwt), __insn_mfspr(SPR_UDN_##name))
+#else
+#define mtspr_XDN(hwt, name, val)					\
+	do {								\
+		if ((hwt)->is_idn)					\
+			__insn_mtspr(SPR_IDN_##name, (val));		\
+		else							\
+			__insn_mtspr(SPR_UDN_##name, (val));		\
+	} while (0)
+#define mtspr_MPL_XDN(hwt, name, val)					\
+	do {								\
+		if ((hwt)->is_idn)					\
+			__insn_mtspr(SPR_MPL_IDN_##name, (val));	\
+		else							\
+			__insn_mtspr(SPR_MPL_UDN_##name, (val));	\
+	} while (0)
+#define mfspr_XDN(hwt, name) \
+  ((hwt)->is_idn ? __insn_mfspr(SPR_IDN_##name) : __insn_mfspr(SPR_UDN_##name))
+#endif
+
 /* Set a CPU bit if the CPU is online. */
 #define cpu_online_set(cpu, dst) do { \
 	if (cpu_online(cpu))          \
@@ -101,7 +199,7 @@ static int contains(struct hardwall_info *r, int x, int y)
 }
 
 /* Compute the rectangle parameters and validate the cpumask. */
-static int setup_rectangle(struct hardwall_info *r, struct cpumask *mask)
+static int check_rectangle(struct hardwall_info *r, struct cpumask *mask)
 {
 	int x, y, cpu, ulhc, lrhc;
 
@@ -114,8 +212,6 @@ static int setup_rectangle(struct hardwall_info *r, struct cpumask *mask)
 	r->ulhc_y = cpu_y(ulhc);
 	r->width = cpu_x(lrhc) - r->ulhc_x + 1;
 	r->height = cpu_y(lrhc) - r->ulhc_y + 1;
-	cpumask_copy(&r->cpumask, mask);
-	r->id = ulhc;   /* The ulhc cpu id can be the hardwall id. */
 
 	/* Width and height must be positive */
 	if (r->width <= 0 || r->height <= 0)
@@ -128,7 +224,7 @@ static int setup_rectangle(struct hardwall_info *r, struct cpumask *mask)
 				return -EINVAL;
 
 	/*
-	 * Note that offline cpus can't be drained when this UDN
+	 * Note that offline cpus can't be drained when this user network
 	 * rectangle eventually closes.  We used to detect this
 	 * situation and print a warning, but it annoyed users and
 	 * they ignored it anyway, so now we just return without a
@@ -137,16 +233,6 @@ static int setup_rectangle(struct hardwall_info *r, struct cpumask *mask)
 	return 0;
 }
 
-/* Do the two given rectangles overlap on any cpu? */
-static int overlaps(struct hardwall_info *a, struct hardwall_info *b)
-{
-	return a->ulhc_x + a->width > b->ulhc_x &&    /* A not to the left */
-		b->ulhc_x + b->width > a->ulhc_x &&   /* B not to the left */
-		a->ulhc_y + a->height > b->ulhc_y &&  /* A not above */
-		b->ulhc_y + b->height > a->ulhc_y;    /* B not above */
-}
-
-
 /*
  * Hardware management of hardwall setup, teardown, trapping,
  * and enabling/disabling PL0 access to the networks.
@@ -157,23 +243,35 @@ enum direction_protect {
 	N_PROTECT = (1 << 0),
 	E_PROTECT = (1 << 1),
 	S_PROTECT = (1 << 2),
-	W_PROTECT = (1 << 3)
+	W_PROTECT = (1 << 3),
+	C_PROTECT = (1 << 4),
 };
 
-static void enable_firewall_interrupts(void)
+static inline int xdn_which_interrupt(struct hardwall_type *hwt)
+{
+#ifndef __tilepro__
+	if (hwt->is_idn)
+		return INT_IDN_FIREWALL;
+#endif
+	return INT_UDN_FIREWALL;
+}
+
+static void enable_firewall_interrupts(struct hardwall_type *hwt)
 {
-	arch_local_irq_unmask_now(INT_UDN_FIREWALL);
+	arch_local_irq_unmask_now(xdn_which_interrupt(hwt));
 }
 
-static void disable_firewall_interrupts(void)
+static void disable_firewall_interrupts(struct hardwall_type *hwt)
 {
-	arch_local_irq_mask_now(INT_UDN_FIREWALL);
+	arch_local_irq_mask_now(xdn_which_interrupt(hwt));
 }
 
 /* Set up hardwall on this cpu based on the passed hardwall_info. */
-static void hardwall_setup_ipi_func(void *info)
+static void hardwall_setup_func(void *info)
 {
 	struct hardwall_info *r = info;
+	struct hardwall_type *hwt = r->type;
+
 	int cpu = smp_processor_id();
 	int x = cpu % smp_width;
 	int y = cpu / smp_width;
@@ -187,13 +285,12 @@ static void hardwall_setup_ipi_func(void *info)
 	if (y == r->ulhc_y + r->height - 1)
 		bits |= S_PROTECT;
 	BUG_ON(bits == 0);
-	__insn_mtspr(SPR_UDN_DIRECTION_PROTECT, bits);
-	enable_firewall_interrupts();
-
+	mtspr_XDN(hwt, DIRECTION_PROTECT, bits);
+	enable_firewall_interrupts(hwt);
 }
 
 /* Set up all cpus on edge of rectangle to enable/disable hardwall SPRs. */
-static void hardwall_setup(struct hardwall_info *r)
+static void hardwall_protect_rectangle(struct hardwall_info *r)
 {
 	int x, y, cpu, delta;
 	struct cpumask rect_cpus;
@@ -217,37 +314,50 @@ static void hardwall_setup(struct hardwall_info *r)
 	}
 
 	/* Then tell all the cpus to set up their protection SPR */
-	on_each_cpu_mask(&rect_cpus, hardwall_setup_ipi_func, r, 1);
+	on_each_cpu_mask(&rect_cpus, hardwall_setup_func, r, 1);
 }
 
 void __kprobes do_hardwall_trap(struct pt_regs* regs, int fault_num)
 {
 	struct hardwall_info *rect;
+	struct hardwall_type *hwt;
 	struct task_struct *p;
 	struct siginfo info;
-	int x, y;
 	int cpu = smp_processor_id();
 	int found_processes;
 	unsigned long flags;
-
 	struct pt_regs *old_regs = set_irq_regs(regs);
+
 	irq_enter();
 
+	/* Figure out which network trapped. */
+	switch (fault_num) {
+#ifndef __tilepro__
+	case INT_IDN_FIREWALL:
+		hwt = &hardwall_types[HARDWALL_IDN];
+		break;
+#endif
+	case INT_UDN_FIREWALL:
+		hwt = &hardwall_types[HARDWALL_UDN];
+		break;
+	default:
+		BUG();
+	}
+	BUG_ON(hwt->disabled);
+
 	/* This tile trapped a network access; find the rectangle. */
-	x = cpu % smp_width;
-	y = cpu / smp_width;
-	spin_lock_irqsave(&hardwall_lock, flags);
-	list_for_each_entry(rect, &rectangles, list) {
-		if (contains(rect, x, y))
+	spin_lock_irqsave(&hwt->lock, flags);
+	list_for_each_entry(rect, &hwt->list, list) {
+		if (cpumask_test_cpu(cpu, &rect->cpumask))
 			break;
 	}
 
 	/*
 	 * It shouldn't be possible not to find this cpu on the
 	 * rectangle list, since only cpus in rectangles get hardwalled.
-	 * The hardwall is only removed after the UDN is drained.
+	 * The hardwall is only removed after the user network is drained.
 	 */
-	BUG_ON(&rect->list == &rectangles);
+	BUG_ON(&rect->list == &hwt->list);
 
 	/*
 	 * If we already started teardown on this hardwall, don't worry;
@@ -255,30 +365,32 @@ void __kprobes do_hardwall_trap(struct pt_regs* regs, int fault_num)
 	 * to quiesce.
 	 */
 	if (rect->teardown_in_progress) {
-		pr_notice("cpu %d: detected hardwall violation %#lx"
+		pr_notice("cpu %d: detected %s hardwall violation %#lx"
 		       " while teardown already in progress\n",
-		       cpu, (long) __insn_mfspr(SPR_UDN_DIRECTION_PROTECT));
+			  cpu, hwt->name,
+			  (long)mfspr_XDN(hwt, DIRECTION_PROTECT));
 		goto done;
 	}
 
 	/*
 	 * Kill off any process that is activated in this rectangle.
 	 * We bypass security to deliver the signal, since it must be
-	 * one of the activated processes that generated the UDN
+	 * one of the activated processes that generated the user network
 	 * message that caused this trap, and all the activated
 	 * processes shared a single open file so are pretty tightly
 	 * bound together from a security point of view to begin with.
 	 */
 	rect->teardown_in_progress = 1;
 	wmb(); /* Ensure visibility of rectangle before notifying processes. */
-	pr_notice("cpu %d: detected hardwall violation %#lx...\n",
-	       cpu, (long) __insn_mfspr(SPR_UDN_DIRECTION_PROTECT));
+	pr_notice("cpu %d: detected %s hardwall violation %#lx...\n",
+		  cpu, hwt->name, (long)mfspr_XDN(hwt, DIRECTION_PROTECT));
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_HARDWALL;
 	found_processes = 0;
-	list_for_each_entry(p, &rect->task_head, thread.hardwall_list) {
-		BUG_ON(p->thread.hardwall != rect);
+	list_for_each_entry(p, &rect->task_head,
+			    thread.hardwall[hwt->index].list) {
+		BUG_ON(p->thread.hardwall[hwt->index].info != rect);
 		if (!(p->flags & PF_EXITING)) {
 			found_processes = 1;
 			pr_notice("hardwall: killing %d\n", p->pid);
@@ -289,7 +401,7 @@ void __kprobes do_hardwall_trap(struct pt_regs* regs, int fault_num)
 		pr_notice("hardwall: no associated processes!\n");
 
  done:
-	spin_unlock_irqrestore(&hardwall_lock, flags);
+	spin_unlock_irqrestore(&hwt->lock, flags);
 
 	/*
 	 * We have to disable firewall interrupts now, or else when we
@@ -298,48 +410,87 @@ void __kprobes do_hardwall_trap(struct pt_regs* regs, int fault_num)
 	 * haven't yet drained the network, and that would allow packets
 	 * to cross out of the hardwall region.
 	 */
-	disable_firewall_interrupts();
+	disable_firewall_interrupts(hwt);
 
 	irq_exit();
 	set_irq_regs(old_regs);
 }
 
-/* Allow access from user space to the UDN. */
-void grant_network_mpls(void)
+/* Allow access from user space to the user network. */
+void grant_hardwall_mpls(struct hardwall_type *hwt)
 {
-	__insn_mtspr(SPR_MPL_UDN_ACCESS_SET_0, 1);
-	__insn_mtspr(SPR_MPL_UDN_AVAIL_SET_0, 1);
-	__insn_mtspr(SPR_MPL_UDN_COMPLETE_SET_0, 1);
-	__insn_mtspr(SPR_MPL_UDN_TIMER_SET_0, 1);
+#ifndef __tilepro__
+	if (!hwt->is_xdn) {
+		__insn_mtspr(SPR_MPL_IPI_0_SET_0, 1);
+		return;
+	}
+#endif
+	mtspr_MPL_XDN(hwt, ACCESS_SET_0, 1);
+	mtspr_MPL_XDN(hwt, AVAIL_SET_0, 1);
+	mtspr_MPL_XDN(hwt, COMPLETE_SET_0, 1);
+	mtspr_MPL_XDN(hwt, TIMER_SET_0, 1);
 #if !CHIP_HAS_REV1_XDN()
-	__insn_mtspr(SPR_MPL_UDN_REFILL_SET_0, 1);
-	__insn_mtspr(SPR_MPL_UDN_CA_SET_0, 1);
+	mtspr_MPL_XDN(hwt, REFILL_SET_0, 1);
+	mtspr_MPL_XDN(hwt, CA_SET_0, 1);
 #endif
 }
 
-/* Deny access from user space to the UDN. */
-void restrict_network_mpls(void)
+/* Deny access from user space to the user network. */
+void restrict_hardwall_mpls(struct hardwall_type *hwt)
 {
-	__insn_mtspr(SPR_MPL_UDN_ACCESS_SET_1, 1);
-	__insn_mtspr(SPR_MPL_UDN_AVAIL_SET_1, 1);
-	__insn_mtspr(SPR_MPL_UDN_COMPLETE_SET_1, 1);
-	__insn_mtspr(SPR_MPL_UDN_TIMER_SET_1, 1);
+#ifndef __tilepro__
+	if (!hwt->is_xdn) {
+		__insn_mtspr(SPR_MPL_IPI_0_SET_1, 1);
+		return;
+	}
+#endif
+	mtspr_MPL_XDN(hwt, ACCESS_SET_1, 1);
+	mtspr_MPL_XDN(hwt, AVAIL_SET_1, 1);
+	mtspr_MPL_XDN(hwt, COMPLETE_SET_1, 1);
+	mtspr_MPL_XDN(hwt, TIMER_SET_1, 1);
 #if !CHIP_HAS_REV1_XDN()
-	__insn_mtspr(SPR_MPL_UDN_REFILL_SET_1, 1);
-	__insn_mtspr(SPR_MPL_UDN_CA_SET_1, 1);
+	mtspr_MPL_XDN(hwt, REFILL_SET_1, 1);
+	mtspr_MPL_XDN(hwt, CA_SET_1, 1);
 #endif
 }
 
+/* Restrict or deny as necessary for the task we're switching to. */
+void hardwall_switch_tasks(struct task_struct *prev,
+			   struct task_struct *next)
+{
+	int i;
+	for (i = 0; i < HARDWALL_TYPES; ++i) {
+		if (prev->thread.hardwall[i].info != NULL) {
+			if (next->thread.hardwall[i].info == NULL)
+				restrict_hardwall_mpls(&hardwall_types[i]);
+		} else if (next->thread.hardwall[i].info != NULL) {
+			grant_hardwall_mpls(&hardwall_types[i]);
+		}
+	}
+}
+
+/* Does this task have the right to IPI the given cpu? */
+int hardwall_ipi_valid(int cpu)
+{
+#ifdef __tilegx__
+	struct hardwall_info *info =
+		current->thread.hardwall[HARDWALL_IPI].info;
+	return info && cpumask_test_cpu(cpu, &info->cpumask);
+#else
+	return 0;
+#endif
+}
 
 /*
- * Code to create, activate, deactivate, and destroy hardwall rectangles.
+ * Code to create, activate, deactivate, and destroy hardwall resources.
  */
 
-/* Create a hardwall for the given rectangle */
-static struct hardwall_info *hardwall_create(
-	size_t size, const unsigned char __user *bits)
+/* Create a hardwall for the given resource */
+static struct hardwall_info *hardwall_create(struct hardwall_type *hwt,
+					     size_t size,
+					     const unsigned char __user *bits)
 {
-	struct hardwall_info *iter, *rect;
+	struct hardwall_info *iter, *info;
 	struct cpumask mask;
 	unsigned long flags;
 	int rc;
@@ -370,55 +521,62 @@ static struct hardwall_info *hardwall_create(
 		}
 	}
 
-	/* Allocate a new rectangle optimistically. */
-	rect = kmalloc(sizeof(struct hardwall_info),
+	/* Allocate a new hardwall_info optimistically. */
+	info = kmalloc(sizeof(struct hardwall_info),
 			GFP_KERNEL | __GFP_ZERO);
-	if (rect == NULL)
+	if (info == NULL)
 		return ERR_PTR(-ENOMEM);
-	INIT_LIST_HEAD(&rect->task_head);
+	INIT_LIST_HEAD(&info->task_head);
+	info->type = hwt;
 
 	/* Compute the rectangle size and validate that it's plausible. */
-	rc = setup_rectangle(rect, &mask);
-	if (rc != 0) {
-		kfree(rect);
-		return ERR_PTR(rc);
+	cpumask_copy(&info->cpumask, &mask);
+	info->id = find_first_bit(cpumask_bits(&mask), nr_cpumask_bits);
+	if (hwt->is_xdn) {
+		rc = check_rectangle(info, &mask);
+		if (rc != 0) {
+			kfree(info);
+			return ERR_PTR(rc);
+		}
 	}
 
 	/* Confirm it doesn't overlap and add it to the list. */
-	spin_lock_irqsave(&hardwall_lock, flags);
-	list_for_each_entry(iter, &rectangles, list) {
-		if (overlaps(iter, rect)) {
-			spin_unlock_irqrestore(&hardwall_lock, flags);
-			kfree(rect);
+	spin_lock_irqsave(&hwt->lock, flags);
+	list_for_each_entry(iter, &hwt->list, list) {
+		if (cpumask_intersects(&iter->cpumask, &info->cpumask)) {
+			spin_unlock_irqrestore(&hwt->lock, flags);
+			kfree(info);
 			return ERR_PTR(-EBUSY);
 		}
 	}
-	list_add_tail(&rect->list, &rectangles);
-	spin_unlock_irqrestore(&hardwall_lock, flags);
+	list_add_tail(&info->list, &hwt->list);
+	spin_unlock_irqrestore(&hwt->lock, flags);
 
 	/* Set up appropriate hardwalling on all affected cpus. */
-	hardwall_setup(rect);
+	if (hwt->is_xdn)
+		hardwall_protect_rectangle(info);
 
 	/* Create a /proc/tile/hardwall entry. */
-	hardwall_add_proc(rect);
+	hardwall_add_proc(info);
 
-	return rect;
+	return info;
 }
 
 /* Activate a given hardwall on this cpu for this process. */
-static int hardwall_activate(struct hardwall_info *rect)
+static int hardwall_activate(struct hardwall_info *info)
 {
-	int cpu, x, y;
+	int cpu;
 	unsigned long flags;
 	struct task_struct *p = current;
 	struct thread_struct *ts = &p->thread;
+	struct hardwall_type *hwt;
 
-	/* Require a rectangle. */
-	if (rect == NULL)
+	/* Require a hardwall. */
+	if (info == NULL)
 		return -ENODATA;
 
-	/* Not allowed to activate a rectangle that is being torn down. */
-	if (rect->teardown_in_progress)
+	/* Not allowed to activate a hardwall that is being torn down. */
+	if (info->teardown_in_progress)
 		return -EINVAL;
 
 	/*
@@ -428,78 +586,87 @@ static int hardwall_activate(struct hardwall_info *rect)
 	if (cpumask_weight(&p->cpus_allowed) != 1)
 		return -EPERM;
 
-	/* Make sure we are bound to a cpu in this rectangle. */
+	/* Make sure we are bound to a cpu assigned to this resource. */
 	cpu = smp_processor_id();
 	BUG_ON(cpumask_first(&p->cpus_allowed) != cpu);
-	x = cpu_x(cpu);
-	y = cpu_y(cpu);
-	if (!contains(rect, x, y))
+	if (!cpumask_test_cpu(cpu, &info->cpumask))
 		return -EINVAL;
 
 	/* If we are already bound to this hardwall, it's a no-op. */
-	if (ts->hardwall) {
-		BUG_ON(ts->hardwall != rect);
+	hwt = info->type;
+	if (ts->hardwall[hwt->index].info) {
+		BUG_ON(ts->hardwall[hwt->index].info != info);
 		return 0;
 	}
 
-	/* Success!  This process gets to use the user networks on this cpu. */
-	ts->hardwall = rect;
-	spin_lock_irqsave(&hardwall_lock, flags);
-	list_add(&ts->hardwall_list, &rect->task_head);
-	spin_unlock_irqrestore(&hardwall_lock, flags);
-	grant_network_mpls();
-	printk(KERN_DEBUG "Pid %d (%s) activated for hardwall: cpu %d\n",
-	       p->pid, p->comm, cpu);
+	/* Success!  This process gets to use the resource on this cpu. */
+	ts->hardwall[hwt->index].info = info;
+	spin_lock_irqsave(&hwt->lock, flags);
+	list_add(&ts->hardwall[hwt->index].list, &info->task_head);
+	spin_unlock_irqrestore(&hwt->lock, flags);
+	grant_hardwall_mpls(hwt);
+	printk(KERN_DEBUG "Pid %d (%s) activated for %s hardwall: cpu %d\n",
+	       p->pid, p->comm, hwt->name, cpu);
 	return 0;
 }
 
 /*
- * Deactivate a task's hardwall.  Must hold hardwall_lock.
+ * Deactivate a task's hardwall.  Must hold lock for hardwall_type.
  * This method may be called from free_task(), so we don't want to
  * rely on too many fields of struct task_struct still being valid.
  * We assume the cpus_allowed, pid, and comm fields are still valid.
  */
-static void _hardwall_deactivate(struct task_struct *task)
+static void _hardwall_deactivate(struct hardwall_type *hwt,
+				 struct task_struct *task)
 {
 	struct thread_struct *ts = &task->thread;
 
 	if (cpumask_weight(&task->cpus_allowed) != 1) {
-		pr_err("pid %d (%s) releasing networks with"
+		pr_err("pid %d (%s) releasing %s hardwall with"
 		       " an affinity mask containing %d cpus!\n",
-		       task->pid, task->comm,
+		       task->pid, task->comm, hwt->name,
 		       cpumask_weight(&task->cpus_allowed));
 		BUG();
 	}
 
-	BUG_ON(ts->hardwall == NULL);
-	ts->hardwall = NULL;
-	list_del(&ts->hardwall_list);
+	BUG_ON(ts->hardwall[hwt->index].info == NULL);
+	ts->hardwall[hwt->index].info = NULL;
+	list_del(&ts->hardwall[hwt->index].list);
 	if (task == current)
-		restrict_network_mpls();
+		restrict_hardwall_mpls(hwt);
 }
 
 /* Deactivate a task's hardwall. */
-int hardwall_deactivate(struct task_struct *task)
+static int hardwall_deactivate(struct hardwall_type *hwt,
+			       struct task_struct *task)
 {
 	unsigned long flags;
 	int activated;
 
-	spin_lock_irqsave(&hardwall_lock, flags);
-	activated = (task->thread.hardwall != NULL);
+	spin_lock_irqsave(&hwt->lock, flags);
+	activated = (task->thread.hardwall[hwt->index].info != NULL);
 	if (activated)
-		_hardwall_deactivate(task);
-	spin_unlock_irqrestore(&hardwall_lock, flags);
+		_hardwall_deactivate(hwt, task);
+	spin_unlock_irqrestore(&hwt->lock, flags);
 
 	if (!activated)
 		return -EINVAL;
 
-	printk(KERN_DEBUG "Pid %d (%s) deactivated for hardwall: cpu %d\n",
-	       task->pid, task->comm, smp_processor_id());
+	printk(KERN_DEBUG "Pid %d (%s) deactivated for %s hardwall: cpu %d\n",
+	       task->pid, task->comm, hwt->name, smp_processor_id());
 	return 0;
 }
 
-/* Stop a UDN switch before draining the network. */
-static void stop_udn_switch(void *ignored)
+void hardwall_deactivate_all(struct task_struct *task)
+{
+	int i;
+	for (i = 0; i < HARDWALL_TYPES; ++i)
+		if (task->thread.hardwall[i].info)
+			hardwall_deactivate(&hardwall_types[i], task);
+}
+
+/* Stop the switch before draining the network. */
+static void stop_xdn_switch(void *arg)
 {
 #if !CHIP_HAS_REV1_XDN()
 	/* Freeze the switch and the demux. */
@@ -507,13 +674,71 @@ static void stop_udn_switch(void *ignored)
 		     SPR_UDN_SP_FREEZE__SP_FRZ_MASK |
 		     SPR_UDN_SP_FREEZE__DEMUX_FRZ_MASK |
 		     SPR_UDN_SP_FREEZE__NON_DEST_EXT_MASK);
+#else
+	/*
+	 * Drop all packets bound for the core or off the edge.
+	 * We rely on the normal hardwall protection setup code
+	 * to have set the low four bits to trigger firewall interrupts,
+	 * and shift those bits up to trigger "drop on send" semantics,
+	 * plus adding "drop on send to core" for all switches.
+	 * In practice it seems the switches latch the DIRECTION_PROTECT
+	 * SPR so they won't start dropping if they're already
+	 * delivering the last message to the core, but it doesn't
+	 * hurt to enable it here.
+	 */
+	struct hardwall_type *hwt = arg;
+	unsigned long protect = mfspr_XDN(hwt, DIRECTION_PROTECT);
+	mtspr_XDN(hwt, DIRECTION_PROTECT, (protect | C_PROTECT) << 5);
 #endif
 }
 
+static void empty_xdn_demuxes(struct hardwall_type *hwt)
+{
+#ifndef __tilepro__
+	if (hwt->is_idn) {
+		while (__insn_mfspr(SPR_IDN_DATA_AVAIL) & (1 << 0))
+			(void) __tile_idn0_receive();
+		while (__insn_mfspr(SPR_IDN_DATA_AVAIL) & (1 << 1))
+			(void) __tile_idn1_receive();
+		return;
+	}
+#endif
+	while (__insn_mfspr(SPR_UDN_DATA_AVAIL) & (1 << 0))
+		(void) __tile_udn0_receive();
+	while (__insn_mfspr(SPR_UDN_DATA_AVAIL) & (1 << 1))
+		(void) __tile_udn1_receive();
+	while (__insn_mfspr(SPR_UDN_DATA_AVAIL) & (1 << 2))
+		(void) __tile_udn2_receive();
+	while (__insn_mfspr(SPR_UDN_DATA_AVAIL) & (1 << 3))
+		(void) __tile_udn3_receive();
+}
+
 /* Drain all the state from a stopped switch. */
-static void drain_udn_switch(void *ignored)
+static void drain_xdn_switch(void *arg)
 {
-#if !CHIP_HAS_REV1_XDN()
+	struct hardwall_info *info = arg;
+	struct hardwall_type *hwt = info->type;
+
+#if CHIP_HAS_REV1_XDN()
+	/*
+	 * The switches have been configured to drop any messages
+	 * destined for cores (or off the edge of the rectangle).
+	 * But the current message may continue to be delivered,
+	 * so we wait until all the cores have finished any pending
+	 * messages before we stop draining.
+	 */
+	int pending = mfspr_XDN(hwt, PENDING);
+	while (pending--) {
+		empty_xdn_demuxes(hwt);
+		if (hwt->is_idn)
+			__tile_idn_send(0);
+		else
+			__tile_udn_send(0);
+	}
+	atomic_dec(&info->xdn_pending_count);
+	while (atomic_read(&info->xdn_pending_count))
+		empty_xdn_demuxes(hwt);
+#else
 	int i;
 	int from_tile_words, ca_count;
 
@@ -533,15 +758,7 @@ static void drain_udn_switch(void *ignored)
 		(void) __insn_mfspr(SPR_UDN_DEMUX_WRITE_FIFO);
 
 	/* Empty out demuxes. */
-	while (__insn_mfspr(SPR_UDN_DATA_AVAIL) & (1 << 0))
-		(void) __tile_udn0_receive();
-	while (__insn_mfspr(SPR_UDN_DATA_AVAIL) & (1 << 1))
-		(void) __tile_udn1_receive();
-	while (__insn_mfspr(SPR_UDN_DATA_AVAIL) & (1 << 2))
-		(void) __tile_udn2_receive();
-	while (__insn_mfspr(SPR_UDN_DATA_AVAIL) & (1 << 3))
-		(void) __tile_udn3_receive();
-	BUG_ON((__insn_mfspr(SPR_UDN_DATA_AVAIL) & 0xF) != 0);
+	empty_xdn_demuxes(hwt);
 
 	/* Empty out catch all. */
 	ca_count = __insn_mfspr(SPR_UDN_DEMUX_CA_COUNT);
@@ -563,21 +780,25 @@ static void drain_udn_switch(void *ignored)
 #endif
 }
 
-/* Reset random UDN state registers at boot up and during hardwall teardown. */
-void reset_network_state(void)
+/* Reset random XDN state registers at boot up and during hardwall teardown. */
+static void reset_xdn_network_state(struct hardwall_type *hwt)
 {
-#if !CHIP_HAS_REV1_XDN()
-	/* Reset UDN coordinates to their standard value */
-	unsigned int cpu = smp_processor_id();
-	unsigned int x = cpu % smp_width;
-	unsigned int y = cpu / smp_width;
-#endif
-
-	if (udn_disabled)
+	if (hwt->disabled)
 		return;
 
+	/* Clear out other random registers so we have a clean slate. */
+	mtspr_XDN(hwt, DIRECTION_PROTECT, 0);
+	mtspr_XDN(hwt, AVAIL_EN, 0);
+	mtspr_XDN(hwt, DEADLOCK_TIMEOUT, 0);
+
 #if !CHIP_HAS_REV1_XDN()
-	__insn_mtspr(SPR_UDN_TILE_COORD, (x << 18) | (y << 7));
+	/* Reset UDN coordinates to their standard value */
+	{
+		unsigned int cpu = smp_processor_id();
+		unsigned int x = cpu % smp_width;
+		unsigned int y = cpu / smp_width;
+		__insn_mtspr(SPR_UDN_TILE_COORD, (x << 18) | (y << 7));
+	}
 
 	/* Set demux tags to predefined values and enable them. */
 	__insn_mtspr(SPR_UDN_TAG_VALID, 0xf);
@@ -585,56 +806,50 @@ void reset_network_state(void)
 	__insn_mtspr(SPR_UDN_TAG_1, (1 << 1));
 	__insn_mtspr(SPR_UDN_TAG_2, (1 << 2));
 	__insn_mtspr(SPR_UDN_TAG_3, (1 << 3));
-#endif
 
-	/* Clear out other random registers so we have a clean slate. */
-	__insn_mtspr(SPR_UDN_AVAIL_EN, 0);
-	__insn_mtspr(SPR_UDN_DEADLOCK_TIMEOUT, 0);
-#if !CHIP_HAS_REV1_XDN()
+	/* Set other rev0 random registers to a clean state. */
 	__insn_mtspr(SPR_UDN_REFILL_EN, 0);
 	__insn_mtspr(SPR_UDN_DEMUX_QUEUE_SEL, 0);
 	__insn_mtspr(SPR_UDN_SP_FIFO_SEL, 0);
-#endif
 
 	/* Start the switch and demux. */
-#if !CHIP_HAS_REV1_XDN()
 	__insn_mtspr(SPR_UDN_SP_FREEZE, 0);
 #endif
 }
 
-/* Restart a UDN switch after draining. */
-static void restart_udn_switch(void *ignored)
+void reset_network_state(void)
 {
-	reset_network_state();
-
-	/* Disable firewall interrupts. */
-	__insn_mtspr(SPR_UDN_DIRECTION_PROTECT, 0);
-	disable_firewall_interrupts();
+	reset_xdn_network_state(&hardwall_types[HARDWALL_UDN]);
+#ifndef __tilepro__
+	reset_xdn_network_state(&hardwall_types[HARDWALL_IDN]);
+#endif
 }
 
-/* Build a struct cpumask containing all valid tiles in bounding rectangle. */
-static void fill_mask(struct hardwall_info *r, struct cpumask *result)
+/* Restart an XDN switch after draining. */
+static void restart_xdn_switch(void *arg)
 {
-	int x, y, cpu;
+	struct hardwall_type *hwt = arg;
 
-	cpumask_clear(result);
+#if CHIP_HAS_REV1_XDN()
+	/* One last drain step to avoid races with injection and draining. */
+	empty_xdn_demuxes(hwt);
+#endif
 
-	cpu = r->ulhc_y * smp_width + r->ulhc_x;
-	for (y = 0; y < r->height; ++y, cpu += smp_width - r->width) {
-		for (x = 0; x < r->width; ++x, ++cpu)
-			cpu_online_set(cpu, result);
-	}
+	reset_xdn_network_state(hwt);
+
+	/* Disable firewall interrupts. */
+	disable_firewall_interrupts(hwt);
 }
 
 /* Last reference to a hardwall is gone, so clear the network. */
-static void hardwall_destroy(struct hardwall_info *rect)
+static void hardwall_destroy(struct hardwall_info *info)
 {
 	struct task_struct *task;
+	struct hardwall_type *hwt;
 	unsigned long flags;
-	struct cpumask mask;
 
-	/* Make sure this file actually represents a rectangle. */
-	if (rect == NULL)
+	/* Make sure this file actually represents a hardwall. */
+	if (info == NULL)
 		return;
 
 	/*
@@ -644,39 +859,53 @@ static void hardwall_destroy(struct hardwall_info *rect)
 	 * deactivate any remaining tasks before freeing the
 	 * hardwall_info object itself.
 	 */
-	spin_lock_irqsave(&hardwall_lock, flags);
-	list_for_each_entry(task, &rect->task_head, thread.hardwall_list)
-		_hardwall_deactivate(task);
-	spin_unlock_irqrestore(&hardwall_lock, flags);
-
-	/* Drain the UDN. */
-	printk(KERN_DEBUG "Clearing hardwall rectangle %dx%d %d,%d\n",
-	       rect->width, rect->height, rect->ulhc_x, rect->ulhc_y);
-	fill_mask(rect, &mask);
-	on_each_cpu_mask(&mask, stop_udn_switch, NULL, 1);
-	on_each_cpu_mask(&mask, drain_udn_switch, NULL, 1);
+	hwt = info->type;
+	info->teardown_in_progress = 1;
+	spin_lock_irqsave(&hwt->lock, flags);
+	list_for_each_entry(task, &info->task_head,
+			    thread.hardwall[hwt->index].list)
+		_hardwall_deactivate(hwt, task);
+	spin_unlock_irqrestore(&hwt->lock, flags);
+
+	if (hwt->is_xdn) {
+		/* Configure the switches for draining the user network. */
+		printk(KERN_DEBUG
+		       "Clearing %s hardwall rectangle %dx%d %d,%d\n",
+		       hwt->name, info->width, info->height,
+		       info->ulhc_x, info->ulhc_y);
+		on_each_cpu_mask(&info->cpumask, stop_xdn_switch, hwt, 1);
+
+		/* Drain the network. */
+#if CHIP_HAS_REV1_XDN()
+		atomic_set(&info->xdn_pending_count,
+			   cpumask_weight(&info->cpumask));
+		on_each_cpu_mask(&info->cpumask, drain_xdn_switch, info, 0);
+#else
+		on_each_cpu_mask(&info->cpumask, drain_xdn_switch, info, 1);
+#endif
 
-	/* Restart switch and disable firewall. */
-	on_each_cpu_mask(&mask, restart_udn_switch, NULL, 1);
+		/* Restart switch and disable firewall. */
+		on_each_cpu_mask(&info->cpumask, restart_xdn_switch, hwt, 1);
+	}
 
 	/* Remove the /proc/tile/hardwall entry. */
-	hardwall_remove_proc(rect);
-
-	/* Now free the rectangle from the list. */
-	spin_lock_irqsave(&hardwall_lock, flags);
-	BUG_ON(!list_empty(&rect->task_head));
-	list_del(&rect->list);
-	spin_unlock_irqrestore(&hardwall_lock, flags);
-	kfree(rect);
+	hardwall_remove_proc(info);
+
+	/* Now free the hardwall from the list. */
+	spin_lock_irqsave(&hwt->lock, flags);
+	BUG_ON(!list_empty(&info->task_head));
+	list_del(&info->list);
+	spin_unlock_irqrestore(&hwt->lock, flags);
+	kfree(info);
 }
 
 
 static int hardwall_proc_show(struct seq_file *sf, void *v)
 {
-	struct hardwall_info *rect = sf->private;
+	struct hardwall_info *info = sf->private;
 	char buf[256];
 
-	int rc = cpulist_scnprintf(buf, sizeof(buf), &rect->cpumask);
+	int rc = cpulist_scnprintf(buf, sizeof(buf), &info->cpumask);
 	buf[rc++] = '\n';
 	seq_write(sf, buf, rc);
 	return 0;
@@ -695,31 +924,45 @@ static const struct file_operations hardwall_proc_fops = {
 	.release	= single_release,
 };
 
-static void hardwall_add_proc(struct hardwall_info *rect)
+static void hardwall_add_proc(struct hardwall_info *info)
 {
 	char buf[64];
-	snprintf(buf, sizeof(buf), "%d", rect->id);
-	proc_create_data(buf, 0444, hardwall_proc_dir,
-			 &hardwall_proc_fops, rect);
+	snprintf(buf, sizeof(buf), "%d", info->id);
+	proc_create_data(buf, 0444, info->type->proc_dir,
+			 &hardwall_proc_fops, info);
 }
 
-static void hardwall_remove_proc(struct hardwall_info *rect)
+static void hardwall_remove_proc(struct hardwall_info *info)
 {
 	char buf[64];
-	snprintf(buf, sizeof(buf), "%d", rect->id);
-	remove_proc_entry(buf, hardwall_proc_dir);
+	snprintf(buf, sizeof(buf), "%d", info->id);
+	remove_proc_entry(buf, info->type->proc_dir);
 }
 
 int proc_pid_hardwall(struct task_struct *task, char *buffer)
 {
-	struct hardwall_info *rect = task->thread.hardwall;
-	return rect ? sprintf(buffer, "%d\n", rect->id) : 0;
+	int i;
+	int n = 0;
+	for (i = 0; i < HARDWALL_TYPES; ++i) {
+		struct hardwall_info *info = task->thread.hardwall[i].info;
+		if (info)
+			n += sprintf(&buffer[n], "%s: %d\n",
+				     info->type->name, info->id);
+	}
+	return n;
 }
 
 void proc_tile_hardwall_init(struct proc_dir_entry *root)
 {
-	if (!udn_disabled)
-		hardwall_proc_dir = proc_mkdir("hardwall", root);
+	int i;
+	for (i = 0; i < HARDWALL_TYPES; ++i) {
+		struct hardwall_type *hwt = &hardwall_types[i];
+		if (hwt->disabled)
+			continue;
+		if (hardwall_proc_dir == NULL)
+			hardwall_proc_dir = proc_mkdir("hardwall", root);
+		hwt->proc_dir = proc_mkdir(hwt->name, hardwall_proc_dir);
+	}
 }
 
 
@@ -729,34 +972,45 @@ void proc_tile_hardwall_init(struct proc_dir_entry *root)
 
 static long hardwall_ioctl(struct file *file, unsigned int a, unsigned long b)
 {
-	struct hardwall_info *rect = file->private_data;
+	struct hardwall_info *info = file->private_data;
+	int minor = iminor(file->f_mapping->host);
+	struct hardwall_type* hwt;
 
 	if (_IOC_TYPE(a) != HARDWALL_IOCTL_BASE)
 		return -EINVAL;
 
+	BUILD_BUG_ON(HARDWALL_TYPES != _HARDWALL_TYPES);
+	BUILD_BUG_ON(HARDWALL_TYPES !=
+		     sizeof(hardwall_types)/sizeof(hardwall_types[0]));
+
+	if (minor < 0 || minor >= HARDWALL_TYPES)
+		return -EINVAL;
+	hwt = &hardwall_types[minor];
+	WARN_ON(info && hwt != info->type);
+
 	switch (_IOC_NR(a)) {
 	case _HARDWALL_CREATE:
-		if (udn_disabled)
+		if (hwt->disabled)
 			return -ENOSYS;
-		if (rect != NULL)
+		if (info != NULL)
 			return -EALREADY;
-		rect = hardwall_create(_IOC_SIZE(a),
-					(const unsigned char __user *)b);
-		if (IS_ERR(rect))
-			return PTR_ERR(rect);
-		file->private_data = rect;
+		info = hardwall_create(hwt, _IOC_SIZE(a),
+				       (const unsigned char __user *)b);
+		if (IS_ERR(info))
+			return PTR_ERR(info);
+		file->private_data = info;
 		return 0;
 
 	case _HARDWALL_ACTIVATE:
-		return hardwall_activate(rect);
+		return hardwall_activate(info);
 
 	case _HARDWALL_DEACTIVATE:
-		if (current->thread.hardwall != rect)
+		if (current->thread.hardwall[hwt->index].info != info)
 			return -EINVAL;
-		return hardwall_deactivate(current);
+		return hardwall_deactivate(hwt, current);
 
 	case _HARDWALL_GET_ID:
-		return rect ? rect->id : -EINVAL;
+		return info ? info->id : -EINVAL;
 
 	default:
 		return -EINVAL;
@@ -775,26 +1029,28 @@ static long hardwall_compat_ioctl(struct file *file,
 /* The user process closed the file; revoke access to user networks. */
 static int hardwall_flush(struct file *file, fl_owner_t owner)
 {
-	struct hardwall_info *rect = file->private_data;
+	struct hardwall_info *info = file->private_data;
 	struct task_struct *task, *tmp;
 	unsigned long flags;
 
-	if (rect) {
+	if (info) {
 		/*
 		 * NOTE: if multiple threads are activated on this hardwall
 		 * file, the other threads will continue having access to the
-		 * UDN until they are context-switched out and back in again.
+		 * user network until they are context-switched out and back
+		 * in again.
 		 *
 		 * NOTE: A NULL files pointer means the task is being torn
 		 * down, so in that case we also deactivate it.
 		 */
-		spin_lock_irqsave(&hardwall_lock, flags);
-		list_for_each_entry_safe(task, tmp, &rect->task_head,
-					 thread.hardwall_list) {
+		struct hardwall_type *hwt = info->type;
+		spin_lock_irqsave(&hwt->lock, flags);
+		list_for_each_entry_safe(task, tmp, &info->task_head,
+					 thread.hardwall[hwt->index].list) {
 			if (task->files == owner || task->files == NULL)
-				_hardwall_deactivate(task);
+				_hardwall_deactivate(hwt, task);
 		}
-		spin_unlock_irqrestore(&hardwall_lock, flags);
+		spin_unlock_irqrestore(&hwt->lock, flags);
 	}
 
 	return 0;
@@ -824,11 +1080,11 @@ static int __init dev_hardwall_init(void)
 	int rc;
 	dev_t dev;
 
-	rc = alloc_chrdev_region(&dev, 0, 1, "hardwall");
+	rc = alloc_chrdev_region(&dev, 0, HARDWALL_TYPES, "hardwall");
 	if (rc < 0)
 		return rc;
 	cdev_init(&hardwall_dev, &dev_hardwall_fops);
-	rc = cdev_add(&hardwall_dev, dev, 1);
+	rc = cdev_add(&hardwall_dev, dev, HARDWALL_TYPES);
 	if (rc < 0)
 		return rc;
 
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index cbf7334..7fa656a 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -1226,7 +1226,7 @@ STD_ENTRY(fill_ra_stack)
 	int_hand     INT_UNALIGN_DATA, UNALIGN_DATA, int_unalign
 	int_hand     INT_DTLB_MISS, DTLB_MISS, do_page_fault
 	int_hand     INT_DTLB_ACCESS, DTLB_ACCESS, do_page_fault
-	int_hand     INT_IDN_FIREWALL, IDN_FIREWALL, bad_intr
+	int_hand     INT_IDN_FIREWALL, IDN_FIREWALL, do_hardwall_trap
 	int_hand     INT_UDN_FIREWALL, UDN_FIREWALL, do_hardwall_trap
 	int_hand     INT_TILE_TIMER, TILE_TIMER, do_timer_interrupt
 	int_hand     INT_IDN_TIMER, IDN_TIMER, bad_intr
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 3be7eb5..0caf686 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -145,10 +145,10 @@ void free_thread_info(struct thread_info *info)
 	 * Calling deactivate here just frees up the data structures.
 	 * If the task we're freeing held the last reference to a
 	 * hardwall fd, it would have been released prior to this point
-	 * anyway via exit_files(), and "hardwall" would be NULL by now.
+	 * anyway via exit_files(), and the hardwall_task.info pointers
+	 * would be NULL by now.
 	 */
-	if (info->task->thread.hardwall)
-		hardwall_deactivate(info->task);
+	hardwall_deactivate_all(info->task);
 #endif
 
 	if (step_state) {
@@ -264,7 +264,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
 #ifdef CONFIG_HARDWALL
 	/* New thread does not own any networks. */
-	p->thread.hardwall = NULL;
+	memset(&p->thread.hardwall[0], 0,
+	       sizeof(struct hardwall_task) * HARDWALL_TYPES);
 #endif
 
 
@@ -534,12 +535,7 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
 
 #ifdef CONFIG_HARDWALL
 	/* Enable or disable access to the network registers appropriately. */
-	if (prev->thread.hardwall != NULL) {
-		if (next->thread.hardwall == NULL)
-			restrict_network_mpls();
-	} else if (next->thread.hardwall != NULL) {
-		grant_network_mpls();
-	}
+	hardwall_switch_tasks(prev, next);
 #endif
 
 	/*
-- 
1.6.5.2

