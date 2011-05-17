Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1EQVnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:43:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab1EQVnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:43:47 -0400
Date: Tue, 17 May 2011 23:43:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110517214332.GA7988@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Most of the diffstat is due to the two UV fixes, which do not affect other 
machines.

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      Revert "x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors"
      x86, AMD: Fix ARAT feature setting again

Cliff Wickman (1):
      x86: Fix UV BAU for non-consecutive nasids

Jack Steiner (1):
      x86, UV: Fix NMI handler for UV platforms

Julia Lawall (1):
      x86, mce, AMD: Fix leaving freed data in a list

Youquan Song (1):
      x86, apic: Fix spurious error interrupts triggering on all non-boot APs


 arch/x86/include/asm/apicdef.h           |    1 +
 arch/x86/include/asm/uv/uv_bau.h         |   17 ++++-
 arch/x86/include/asm/uv/uv_hub.h         |    2 +
 arch/x86/include/asm/uv/uv_mmrs.h        |   16 +++++-
 arch/x86/kernel/apic/x2apic_uv_x.c       |   48 ++++++++++++++--
 arch/x86/kernel/cpu/amd.c                |    4 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c     |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   12 ++--
 arch/x86/platform/uv/tlb_uv.c            |   92 ++++++++++++++++++++---------
 9 files changed, 147 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index d87988b..34595d5 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -78,6 +78,7 @@
 #define		APIC_DEST_LOGICAL	0x00800
 #define		APIC_DEST_PHYSICAL	0x00000
 #define		APIC_DM_FIXED		0x00000
+#define		APIC_DM_FIXED_MASK	0x00700
 #define		APIC_DM_LOWEST		0x00100
 #define		APIC_DM_SMI		0x00200
 #define		APIC_DM_REMRD		0x00300
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 3e094af..130f1ee 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -94,6 +94,8 @@
 /* after this # consecutive successes, bump up the throttle if it was lowered */
 #define COMPLETE_THRESHOLD 5
 
+#define UV_LB_SUBNODEID 0x10
+
 /*
  * number of entries in the destination side payload queue
  */
@@ -124,7 +126,7 @@
  * The distribution specification (32 bytes) is interpreted as a 256-bit
  * distribution vector. Adjacent bits correspond to consecutive even numbered
  * nodeIDs. The result of adding the index of a given bit to the 15-bit
- * 'base_dest_nodeid' field of the header corresponds to the
+ * 'base_dest_nasid' field of the header corresponds to the
  * destination nodeID associated with that specified bit.
  */
 struct bau_target_uvhubmask {
@@ -176,7 +178,7 @@ struct bau_msg_payload {
 struct bau_msg_header {
 	unsigned int dest_subnodeid:6;	/* must be 0x10, for the LB */
 	/* bits 5:0 */
-	unsigned int base_dest_nodeid:15; /* nasid of the */
+	unsigned int base_dest_nasid:15; /* nasid of the */
 	/* bits 20:6 */			  /* first bit in uvhub map */
 	unsigned int command:8;	/* message type */
 	/* bits 28:21 */
@@ -378,6 +380,10 @@ struct ptc_stats {
 	unsigned long d_rcanceled; /* number of messages canceled by resets */
 };
 
+struct hub_and_pnode {
+	short uvhub;
+	short pnode;
+};
 /*
  * one per-cpu; to locate the software tables
  */
@@ -399,10 +405,12 @@ struct bau_control {
 	int baudisabled;
 	int set_bau_off;
 	short cpu;
+	short osnode;
 	short uvhub_cpu;
 	short uvhub;
 	short cpus_in_socket;
 	short cpus_in_uvhub;
+	short partition_base_pnode;
 	unsigned short message_number;
 	unsigned short uvhub_quiesce;
 	short socket_acknowledge_count[DEST_Q_SIZE];
@@ -422,15 +430,16 @@ struct bau_control {
 	int congested_period;
 	cycles_t period_time;
 	long period_requests;
+	struct hub_and_pnode *target_hub_and_pnode;
 };
 
 static inline int bau_uvhub_isset(int uvhub, struct bau_target_uvhubmask *dstp)
 {
 	return constant_test_bit(uvhub, &dstp->bits[0]);
 }
-static inline void bau_uvhub_set(int uvhub, struct bau_target_uvhubmask *dstp)
+static inline void bau_uvhub_set(int pnode, struct bau_target_uvhubmask *dstp)
 {
-	__set_bit(uvhub, &dstp->bits[0]);
+	__set_bit(pnode, &dstp->bits[0]);
 }
 static inline void bau_uvhubs_clear(struct bau_target_uvhubmask *dstp,
 				    int nbits)
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index a501741..4298002 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -398,6 +398,8 @@ struct uv_blade_info {
 	unsigned short	nr_online_cpus;
 	unsigned short	pnode;
 	short		memory_nid;
+	spinlock_t	nmi_lock;
+	unsigned long	nmi_count;
 };
 extern struct uv_blade_info *uv_blade_info;
 extern short *uv_node_to_blade;
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index 20cafea..f5bb64a 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -5,7 +5,7 @@
  *
  * SGI UV MMR definitions
  *
- * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2011 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_MMRS_H
@@ -1099,5 +1099,19 @@ union uvh_rtc1_int_config_u {
     } s;
 };
 
+/* ========================================================================= */
+/*                               UVH_SCRATCH5                                */
+/* ========================================================================= */
+#define UVH_SCRATCH5 0x2d0200UL
+#define UVH_SCRATCH5_32 0x00778
+
+#define UVH_SCRATCH5_SCRATCH5_SHFT 0
+#define UVH_SCRATCH5_SCRATCH5_MASK 0xffffffffffffffffUL
+union uvh_scratch5_u {
+    unsigned long	v;
+    struct uvh_scratch5_s {
+	unsigned long	scratch5 : 64;  /* RW, W1CS */
+    } s;
+};
 
 #endif /* __ASM_UV_MMRS_X86_H__ */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 33b10a0..7acd2d2 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -37,6 +37,13 @@
 #include <asm/smp.h>
 #include <asm/x86_init.h>
 #include <asm/emergency-restart.h>
+#include <asm/nmi.h>
+
+/* BMC sets a bit this MMR non-zero before sending an NMI */
+#define UVH_NMI_MMR				UVH_SCRATCH5
+#define UVH_NMI_MMR_CLEAR			(UVH_NMI_MMR + 8)
+#define UV_NMI_PENDING_MASK			(1UL << 63)
+DEFINE_PER_CPU(unsigned long, cpu_last_nmi_count);
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
@@ -642,18 +649,46 @@ void __cpuinit uv_cpu_init(void)
  */
 int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 {
+	unsigned long real_uv_nmi;
+	int bid;
+
 	if (reason != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
 
 	if (in_crash_kexec)
 		/* do nothing if entering the crash kernel */
 		return NOTIFY_OK;
+
 	/*
-	 * Use a lock so only one cpu prints at a time
-	 * to prevent intermixed output.
+	 * Each blade has an MMR that indicates when an NMI has been sent
+	 * to cpus on the blade. If an NMI is detected, atomically
+	 * clear the MMR and update a per-blade NMI count used to
+	 * cause each cpu on the blade to notice a new NMI.
+	 */
+	bid = uv_numa_blade_id();
+	real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
+
+	if (unlikely(real_uv_nmi)) {
+		spin_lock(&uv_blade_info[bid].nmi_lock);
+		real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
+		if (real_uv_nmi) {
+			uv_blade_info[bid].nmi_count++;
+			uv_write_local_mmr(UVH_NMI_MMR_CLEAR, UV_NMI_PENDING_MASK);
+		}
+		spin_unlock(&uv_blade_info[bid].nmi_lock);
+	}
+
+	if (likely(__get_cpu_var(cpu_last_nmi_count) == uv_blade_info[bid].nmi_count))
+		return NOTIFY_DONE;
+
+	__get_cpu_var(cpu_last_nmi_count) = uv_blade_info[bid].nmi_count;
+
+	/*
+	 * Use a lock so only one cpu prints at a time.
+	 * This prevents intermixed output.
 	 */
 	spin_lock(&uv_nmi_lock);
-	pr_info("NMI stack dump cpu %u:\n", smp_processor_id());
+	pr_info("UV NMI stack dump cpu %u:\n", smp_processor_id());
 	dump_stack();
 	spin_unlock(&uv_nmi_lock);
 
@@ -661,7 +696,8 @@ int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 }
 
 static struct notifier_block uv_dump_stack_nmi_nb = {
-	.notifier_call	= uv_handle_nmi
+	.notifier_call	= uv_handle_nmi,
+	.priority = NMI_LOCAL_LOW_PRIOR - 1,
 };
 
 void uv_register_nmi_notifier(void)
@@ -720,8 +756,9 @@ void __init uv_system_init(void)
 	printk(KERN_DEBUG "UV: Found %d blades\n", uv_num_possible_blades());
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
-	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
+	uv_blade_info = kzalloc(bytes, GFP_KERNEL);
 	BUG_ON(!uv_blade_info);
+
 	for (blade = 0; blade < uv_num_possible_blades(); blade++)
 		uv_blade_info[blade].memory_nid = -1;
 
@@ -747,6 +784,7 @@ void __init uv_system_init(void)
 			uv_blade_info[blade].pnode = pnode;
 			uv_blade_info[blade].nr_possible_cpus = 0;
 			uv_blade_info[blade].nr_online_cpus = 0;
+			spin_lock_init(&uv_blade_info[blade].nmi_lock);
 			max_pnode = max(pnode, max_pnode);
 			blade++;
 		}
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bb9eb29..6f9d1f6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -613,7 +613,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 #endif
 
 	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*
@@ -698,7 +698,7 @@ cpu_dev_register(amd_cpu_dev);
  */
 
 const int amd_erratum_400[] =
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0x0f, 0x4, 0x2, 0xff, 0xf),
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 EXPORT_SYMBOL_GPL(amd_erratum_400);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 167f97b..bb0adad 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -509,6 +509,7 @@ recurse:
 out_free:
 	if (b) {
 		kobject_put(&b->kobj);
+		list_del(&b->miscj);
 		kfree(b);
 	}
 	return err;
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6f8c5e9..0f03446 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -446,18 +446,20 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	 */
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 
+	h = lvtthmr_init;
 	/*
 	 * The initial value of thermal LVT entries on all APs always reads
 	 * 0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
 	 * sequence to them and LVT registers are reset to 0s except for
 	 * the mask bits which are set to 1s when APs receive INIT IPI.
-	 * Always restore the value that BIOS has programmed on AP based on
-	 * BSP's info we saved since BIOS is always setting the same value
-	 * for all threads/cores
+	 * If BIOS takes over the thermal interrupt and sets its interrupt
+	 * delivery mode to SMI (not fixed), it restores the value that the
+	 * BIOS has programmed on AP based on BSP's info we saved since BIOS
+	 * is always setting the same value for all threads/cores.
 	 */
-	apic_write(APIC_LVTTHMR, lvtthmr_init);
+	if ((h & APIC_DM_FIXED_MASK) != APIC_DM_FIXED)
+		apic_write(APIC_LVTTHMR, lvtthmr_init);
 
-	h = lvtthmr_init;
 
 	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
 		printk(KERN_DEBUG
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 7cb6424..c58e0ea 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -699,16 +699,17 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 					  struct mm_struct *mm,
 					  unsigned long va, unsigned int cpu)
 {
-	int tcpu;
-	int uvhub;
 	int locals = 0;
 	int remotes = 0;
 	int hubs = 0;
+	int tcpu;
+	int tpnode;
 	struct bau_desc *bau_desc;
 	struct cpumask *flush_mask;
 	struct ptc_stats *stat;
 	struct bau_control *bcp;
 	struct bau_control *tbcp;
+	struct hub_and_pnode *hpp;
 
 	/* kernel was booted 'nobau' */
 	if (nobau)
@@ -750,11 +751,18 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 	bau_desc += UV_ITEMS_PER_DESCRIPTOR * bcp->uvhub_cpu;
 	bau_uvhubs_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
 
-	/* cpu statistics */
 	for_each_cpu(tcpu, flush_mask) {
-		uvhub = uv_cpu_to_blade_id(tcpu);
-		bau_uvhub_set(uvhub, &bau_desc->distribution);
-		if (uvhub == bcp->uvhub)
+		/*
+		 * The distribution vector is a bit map of pnodes, relative
+		 * to the partition base pnode (and the partition base nasid
+		 * in the header).
+		 * Translate cpu to pnode and hub using an array stored
+		 * in local memory.
+		 */
+		hpp = &bcp->socket_master->target_hub_and_pnode[tcpu];
+		tpnode = hpp->pnode - bcp->partition_base_pnode;
+		bau_uvhub_set(tpnode, &bau_desc->distribution);
+		if (hpp->uvhub == bcp->uvhub)
 			locals++;
 		else
 			remotes++;
@@ -855,7 +863,7 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
  * an interrupt, but causes an error message to be returned to
  * the sender.
  */
-static void uv_enable_timeouts(void)
+static void __init uv_enable_timeouts(void)
 {
 	int uvhub;
 	int nuvhubs;
@@ -1326,10 +1334,10 @@ static int __init uv_ptc_init(void)
 }
 
 /*
- * initialize the sending side's sending buffers
+ * Initialize the sending side's sending buffers.
  */
 static void
-uv_activation_descriptor_init(int node, int pnode)
+uv_activation_descriptor_init(int node, int pnode, int base_pnode)
 {
 	int i;
 	int cpu;
@@ -1352,11 +1360,11 @@ uv_activation_descriptor_init(int node, int pnode)
 	n = pa >> uv_nshift;
 	m = pa & uv_mmask;
 
+	/* the 14-bit pnode */
 	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE,
 			      (n << UV_DESC_BASE_PNODE_SHIFT | m));
-
 	/*
-	 * initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
+	 * Initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
 	 * cpu even though we only use the first one; one descriptor can
 	 * describe a broadcast to 256 uv hubs.
 	 */
@@ -1365,12 +1373,13 @@ uv_activation_descriptor_init(int node, int pnode)
 		memset(bd2, 0, sizeof(struct bau_desc));
 		bd2->header.sw_ack_flag = 1;
 		/*
-		 * base_dest_nodeid is the nasid of the first uvhub
-		 * in the partition. The bit map will indicate uvhub numbers,
-		 * which are 0-N in a partition. Pnodes are unique system-wide.
+		 * The base_dest_nasid set in the message header is the nasid
+		 * of the first uvhub in the partition. The bit map will
+		 * indicate destination pnode numbers relative to that base.
+		 * They may not be consecutive if nasid striding is being used.
 		 */
-		bd2->header.base_dest_nodeid = UV_PNODE_TO_NASID(uv_partition_base_pnode);
-		bd2->header.dest_subnodeid = 0x10; /* the LB */
+		bd2->header.base_dest_nasid = UV_PNODE_TO_NASID(base_pnode);
+		bd2->header.dest_subnodeid = UV_LB_SUBNODEID;
 		bd2->header.command = UV_NET_ENDPOINT_INTD;
 		bd2->header.int_both = 1;
 		/*
@@ -1442,7 +1451,7 @@ uv_payload_queue_init(int node, int pnode)
 /*
  * Initialization of each UV hub's structures
  */
-static void __init uv_init_uvhub(int uvhub, int vector)
+static void __init uv_init_uvhub(int uvhub, int vector, int base_pnode)
 {
 	int node;
 	int pnode;
@@ -1450,11 +1459,11 @@ static void __init uv_init_uvhub(int uvhub, int vector)
 
 	node = uvhub_to_first_node(uvhub);
 	pnode = uv_blade_to_pnode(uvhub);
-	uv_activation_descriptor_init(node, pnode);
+	uv_activation_descriptor_init(node, pnode, base_pnode);
 	uv_payload_queue_init(node, pnode);
 	/*
-	 * the below initialization can't be in firmware because the
-	 * messaging IRQ will be determined by the OS
+	 * The below initialization can't be in firmware because the
+	 * messaging IRQ will be determined by the OS.
 	 */
 	apicid = uvhub_to_first_apicid(uvhub) | uv_apicid_hibits;
 	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
@@ -1491,10 +1500,11 @@ calculate_destination_timeout(void)
 /*
  * initialize the bau_control structure for each cpu
  */
-static int __init uv_init_per_cpu(int nuvhubs)
+static int __init uv_init_per_cpu(int nuvhubs, int base_part_pnode)
 {
 	int i;
 	int cpu;
+	int tcpu;
 	int pnode;
 	int uvhub;
 	int have_hmaster;
@@ -1528,6 +1538,15 @@ static int __init uv_init_per_cpu(int nuvhubs)
 		bcp = &per_cpu(bau_control, cpu);
 		memset(bcp, 0, sizeof(struct bau_control));
 		pnode = uv_cpu_hub_info(cpu)->pnode;
+		if ((pnode - base_part_pnode) >= UV_DISTRIBUTION_SIZE) {
+			printk(KERN_EMERG
+				"cpu %d pnode %d-%d beyond %d; BAU disabled\n",
+				cpu, pnode, base_part_pnode,
+				UV_DISTRIBUTION_SIZE);
+			return 1;
+		}
+		bcp->osnode = cpu_to_node(cpu);
+		bcp->partition_base_pnode = uv_partition_base_pnode;
 		uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
 		*(uvhub_mask + (uvhub/8)) |= (1 << (uvhub%8));
 		bdp = &uvhub_descs[uvhub];
@@ -1536,7 +1555,7 @@ static int __init uv_init_per_cpu(int nuvhubs)
 		bdp->pnode = pnode;
 		/* kludge: 'assuming' one node per socket, and assuming that
 		   disabling a socket just leaves a gap in node numbers */
-		socket = (cpu_to_node(cpu) & 1);
+		socket = bcp->osnode & 1;
 		bdp->socket_mask |= (1 << socket);
 		sdp = &bdp->socket[socket];
 		sdp->cpu_number[sdp->num_cpus] = cpu;
@@ -1585,6 +1604,20 @@ static int __init uv_init_per_cpu(int nuvhubs)
 nextsocket:
 			socket++;
 			socket_mask = (socket_mask >> 1);
+			/* each socket gets a local array of pnodes/hubs */
+			bcp = smaster;
+			bcp->target_hub_and_pnode = kmalloc_node(
+				sizeof(struct hub_and_pnode) *
+				num_possible_cpus(), GFP_KERNEL, bcp->osnode);
+			memset(bcp->target_hub_and_pnode, 0,
+				sizeof(struct hub_and_pnode) *
+				num_possible_cpus());
+			for_each_present_cpu(tcpu) {
+				bcp->target_hub_and_pnode[tcpu].pnode =
+					uv_cpu_hub_info(tcpu)->pnode;
+				bcp->target_hub_and_pnode[tcpu].uvhub =
+					uv_cpu_hub_info(tcpu)->numa_blade_id;
+			}
 		}
 	}
 	kfree(uvhub_descs);
@@ -1637,21 +1670,22 @@ static int __init uv_bau_init(void)
 	spin_lock_init(&disable_lock);
 	congested_cycles = microsec_2_cycles(congested_response_us);
 
-	if (uv_init_per_cpu(nuvhubs)) {
-		nobau = 1;
-		return 0;
-	}
-
 	uv_partition_base_pnode = 0x7fffffff;
-	for (uvhub = 0; uvhub < nuvhubs; uvhub++)
+	for (uvhub = 0; uvhub < nuvhubs; uvhub++) {
 		if (uv_blade_nr_possible_cpus(uvhub) &&
 			(uv_blade_to_pnode(uvhub) < uv_partition_base_pnode))
 			uv_partition_base_pnode = uv_blade_to_pnode(uvhub);
+	}
+
+	if (uv_init_per_cpu(nuvhubs, uv_partition_base_pnode)) {
+		nobau = 1;
+		return 0;
+	}
 
 	vector = UV_BAU_MESSAGE;
 	for_each_possible_blade(uvhub)
 		if (uv_blade_nr_possible_cpus(uvhub))
-			uv_init_uvhub(uvhub, vector);
+			uv_init_uvhub(uvhub, vector, uv_partition_base_pnode);
 
 	uv_enable_timeouts();
 	alloc_intr_gate(vector, uv_bau_message_intr1);
