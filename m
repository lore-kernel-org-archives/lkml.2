Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1E1QpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:45:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35242 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab1E1QpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:45:01 -0400
Date: Sat, 28 May 2011 18:44:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes/updates
Message-ID: <20110528164434.GA11176@elte.hu>
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

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

The uv_tlb cleanups make up 95% of the diffstat - it does not affect 
any other x86 platform.

 Thanks,

	Ingo

------------------>
Boris Ostrovsky (1):
      x86, amd: Do not enable ARAT feature on AMD processors below family 0x12

Cliff Wickman (1):
      x86, UV: Clean up uv_tlb.c

Ingo Molnar (1):
      x86, asm: Clean up desc.h a bit

Jack Steiner (1):
      x86, UV: Add support for SGI UV2 hub chip

KOSAKI Motohiro (1):
      x86: Move do_page_fault()'s error path under unlikely()

Kees Cook (1):
      x86, cpufeature: Update CPU feature RDRND to RDRAND

Matthew Garrett (1):
      x86, efi: Retain boot service code until after switching to virtual mode

Nikhil P Rao (1):
      x86: Remove unnecessary check in detect_ht()

Richard Kennedy (1):
      x86: Reorder mm_context_t to remove x86_64 alignment padding and thus shrink mm_struct


 arch/x86/include/asm/cpufeature.h  |    2 +-
 arch/x86/include/asm/desc.h        |  152 ++--
 arch/x86/include/asm/mmu.h         |    4 +-
 arch/x86/include/asm/uv/uv_bau.h   |  590 ++++++++++-----
 arch/x86/include/asm/uv/uv_hub.h   |   71 ++-
 arch/x86/include/asm/uv/uv_mmrs.h  | 1012 ++++++++++++++++++++-----
 arch/x86/kernel/apic/x2apic_uv_x.c |   40 +-
 arch/x86/kernel/cpu/amd.c          |    7 +-
 arch/x86/kernel/cpu/common.c       |    7 -
 arch/x86/kernel/setup.c            |    7 +
 arch/x86/mm/fault.c                |   35 +-
 arch/x86/platform/efi/efi.c        |   45 ++-
 arch/x86/platform/efi/efi_64.c     |    5 +-
 arch/x86/platform/uv/tlb_uv.c      | 1484 ++++++++++++++++++++----------------
 arch/x86/platform/uv/uv_time.c     |   16 +-
 include/linux/efi.h                |    1 +
 16 files changed, 2284 insertions(+), 1194 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 5dc6acc..71cc380 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -125,7 +125,7 @@
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
 #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
 #define X86_FEATURE_F16C	(4*32+29) /* 16-bit fp conversions */
-#define X86_FEATURE_RDRND	(4*32+30) /* The RDRAND instruction */
+#define X86_FEATURE_RDRAND	(4*32+30) /* The RDRAND instruction */
 #define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 617bd56..7b439d9 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -4,30 +4,33 @@
 #include <asm/desc_defs.h>
 #include <asm/ldt.h>
 #include <asm/mmu.h>
+
 #include <linux/smp.h>
 
-static inline void fill_ldt(struct desc_struct *desc,
-			    const struct user_desc *info)
-{
-	desc->limit0 = info->limit & 0x0ffff;
-	desc->base0 = info->base_addr & 0x0000ffff;
-
-	desc->base1 = (info->base_addr & 0x00ff0000) >> 16;
-	desc->type = (info->read_exec_only ^ 1) << 1;
-	desc->type |= info->contents << 2;
-	desc->s = 1;
-	desc->dpl = 0x3;
-	desc->p = info->seg_not_present ^ 1;
-	desc->limit = (info->limit & 0xf0000) >> 16;
-	desc->avl = info->useable;
-	desc->d = info->seg_32bit;
-	desc->g = info->limit_in_pages;
-	desc->base2 = (info->base_addr & 0xff000000) >> 24;
+static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *info)
+{
+	desc->limit0		= info->limit & 0x0ffff;
+
+	desc->base0		= (info->base_addr & 0x0000ffff);
+	desc->base1		= (info->base_addr & 0x00ff0000) >> 16;
+
+	desc->type		= (info->read_exec_only ^ 1) << 1;
+	desc->type	       |= info->contents << 2;
+
+	desc->s			= 1;
+	desc->dpl		= 0x3;
+	desc->p			= info->seg_not_present ^ 1;
+	desc->limit		= (info->limit & 0xf0000) >> 16;
+	desc->avl		= info->useable;
+	desc->d			= info->seg_32bit;
+	desc->g			= info->limit_in_pages;
+
+	desc->base2		= (info->base_addr & 0xff000000) >> 24;
 	/*
 	 * Don't allow setting of the lm bit. It is useless anyway
 	 * because 64bit system calls require __USER_CS:
 	 */
-	desc->l = 0;
+	desc->l			= 0;
 }
 
 extern struct desc_ptr idt_descr;
@@ -36,6 +39,7 @@ extern gate_desc idt_table[];
 struct gdt_page {
 	struct desc_struct gdt[GDT_ENTRIES];
 } __attribute__((aligned(PAGE_SIZE)));
+
 DECLARE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page);
 
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
@@ -48,16 +52,16 @@ static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
-	gate->offset_low = PTR_LOW(func);
-	gate->segment = __KERNEL_CS;
-	gate->ist = ist;
-	gate->p = 1;
-	gate->dpl = dpl;
-	gate->zero0 = 0;
-	gate->zero1 = 0;
-	gate->type = type;
-	gate->offset_middle = PTR_MIDDLE(func);
-	gate->offset_high = PTR_HIGH(func);
+	gate->offset_low	= PTR_LOW(func);
+	gate->segment		= __KERNEL_CS;
+	gate->ist		= ist;
+	gate->p			= 1;
+	gate->dpl		= dpl;
+	gate->zero0		= 0;
+	gate->zero1		= 0;
+	gate->type		= type;
+	gate->offset_middle	= PTR_MIDDLE(func);
+	gate->offset_high	= PTR_HIGH(func);
 }
 
 #else
@@ -66,8 +70,7 @@ static inline void pack_gate(gate_desc *gate, unsigned char type,
 			     unsigned short seg)
 {
 	gate->a = (seg << 16) | (base & 0xffff);
-	gate->b = (base & 0xffff0000) |
-		  (((0x80 | type | (dpl << 5)) & 0xff) << 8);
+	gate->b = (base & 0xffff0000) | (((0x80 | type | (dpl << 5)) & 0xff) << 8);
 }
 
 #endif
@@ -75,31 +78,29 @@ static inline void pack_gate(gate_desc *gate, unsigned char type,
 static inline int desc_empty(const void *ptr)
 {
 	const u32 *desc = ptr;
+
 	return !(desc[0] | desc[1]);
 }
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define load_TR_desc() native_load_tr_desc()
-#define load_gdt(dtr) native_load_gdt(dtr)
-#define load_idt(dtr) native_load_idt(dtr)
-#define load_tr(tr) asm volatile("ltr %0"::"m" (tr))
-#define load_ldt(ldt) asm volatile("lldt %0"::"m" (ldt))
-
-#define store_gdt(dtr) native_store_gdt(dtr)
-#define store_idt(dtr) native_store_idt(dtr)
-#define store_tr(tr) (tr = native_store_tr())
-
-#define load_TLS(t, cpu) native_load_tls(t, cpu)
-#define set_ldt native_set_ldt
-
-#define write_ldt_entry(dt, entry, desc)	\
-	native_write_ldt_entry(dt, entry, desc)
-#define write_gdt_entry(dt, entry, desc, type)		\
-	native_write_gdt_entry(dt, entry, desc, type)
-#define write_idt_entry(dt, entry, g)		\
-	native_write_idt_entry(dt, entry, g)
+#define load_TR_desc()				native_load_tr_desc()
+#define load_gdt(dtr)				native_load_gdt(dtr)
+#define load_idt(dtr)				native_load_idt(dtr)
+#define load_tr(tr)				asm volatile("ltr %0"::"m" (tr))
+#define load_ldt(ldt)				asm volatile("lldt %0"::"m" (ldt))
+
+#define store_gdt(dtr)				native_store_gdt(dtr)
+#define store_idt(dtr)				native_store_idt(dtr)
+#define store_tr(tr)				(tr = native_store_tr())
+
+#define load_TLS(t, cpu)			native_load_tls(t, cpu)
+#define set_ldt					native_set_ldt
+
+#define write_ldt_entry(dt, entry, desc)	native_write_ldt_entry(dt, entry, desc)
+#define write_gdt_entry(dt, entry, desc, type)	native_write_gdt_entry(dt, entry, desc, type)
+#define write_idt_entry(dt, entry, g)		native_write_idt_entry(dt, entry, g)
 
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
@@ -112,33 +113,27 @@ static inline void paravirt_free_ldt(struct desc_struct *ldt, unsigned entries)
 
 #define store_ldt(ldt) asm("sldt %0" : "=m"(ldt))
 
-static inline void native_write_idt_entry(gate_desc *idt, int entry,
-					  const gate_desc *gate)
+static inline void native_write_idt_entry(gate_desc *idt, int entry, const gate_desc *gate)
 {
 	memcpy(&idt[entry], gate, sizeof(*gate));
 }
 
-static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry,
-					  const void *desc)
+static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry, const void *desc)
 {
 	memcpy(&ldt[entry], desc, 8);
 }
 
-static inline void native_write_gdt_entry(struct desc_struct *gdt, int entry,
-					  const void *desc, int type)
+static inline void
+native_write_gdt_entry(struct desc_struct *gdt, int entry, const void *desc, int type)
 {
 	unsigned int size;
+
 	switch (type) {
-	case DESC_TSS:
-		size = sizeof(tss_desc);
-		break;
-	case DESC_LDT:
-		size = sizeof(ldt_desc);
-		break;
-	default:
-		size = sizeof(struct desc_struct);
-		break;
+	case DESC_TSS:	size = sizeof(tss_desc);	break;
+	case DESC_LDT:	size = sizeof(ldt_desc);	break;
+	default:	size = sizeof(*gdt);		break;
 	}
+
 	memcpy(&gdt[entry], desc, size);
 }
 
@@ -154,20 +149,21 @@ static inline void pack_descriptor(struct desc_struct *desc, unsigned long base,
 }
 
 
-static inline void set_tssldt_descriptor(void *d, unsigned long addr,
-					 unsigned type, unsigned size)
+static inline void set_tssldt_descriptor(void *d, unsigned long addr, unsigned type, unsigned size)
 {
 #ifdef CONFIG_X86_64
 	struct ldttss_desc64 *desc = d;
+
 	memset(desc, 0, sizeof(*desc));
-	desc->limit0 = size & 0xFFFF;
-	desc->base0 = PTR_LOW(addr);
-	desc->base1 = PTR_MIDDLE(addr) & 0xFF;
-	desc->type = type;
-	desc->p = 1;
-	desc->limit1 = (size >> 16) & 0xF;
-	desc->base2 = (PTR_MIDDLE(addr) >> 8) & 0xFF;
-	desc->base3 = PTR_HIGH(addr);
+
+	desc->limit0		= size & 0xFFFF;
+	desc->base0		= PTR_LOW(addr);
+	desc->base1		= PTR_MIDDLE(addr) & 0xFF;
+	desc->type		= type;
+	desc->p			= 1;
+	desc->limit1		= (size >> 16) & 0xF;
+	desc->base2		= (PTR_MIDDLE(addr) >> 8) & 0xFF;
+	desc->base3		= PTR_HIGH(addr);
 #else
 	pack_descriptor((struct desc_struct *)d, addr, size, 0x80 | type, 0);
 #endif
@@ -237,14 +233,16 @@ static inline void native_store_idt(struct desc_ptr *dtr)
 static inline unsigned long native_store_tr(void)
 {
 	unsigned long tr;
+
 	asm volatile("str %0":"=r" (tr));
+
 	return tr;
 }
 
 static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 {
-	unsigned int i;
 	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+	unsigned int i;
 
 	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
 		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
@@ -313,6 +311,7 @@ static inline void _set_gate(int gate, unsigned type, void *addr,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
 	gate_desc s;
+
 	pack_gate(&s, type, (unsigned long)addr, dpl, ist, seg);
 	/*
 	 * does not need to be atomic because it is only done once at
@@ -343,8 +342,9 @@ static inline void alloc_system_vector(int vector)
 		set_bit(vector, used_vectors);
 		if (first_system_vector > vector)
 			first_system_vector = vector;
-	} else
+	} else {
 		BUG();
+	}
 }
 
 static inline void alloc_intr_gate(unsigned int n, void *addr)
diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index aeff3e8..5f55e69 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -11,14 +11,14 @@
 typedef struct {
 	void *ldt;
 	int size;
-	struct mutex lock;
-	void *vdso;
 
 #ifdef CONFIG_X86_64
 	/* True if mm supports a task running in 32 bit compatibility mode. */
 	unsigned short ia32_compat;
 #endif
 
+	struct mutex lock;
+	void *vdso;
 } mm_context_t;
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 130f1ee..a291c40 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -5,7 +5,7 @@
  *
  * SGI UV Broadcast Assist Unit definitions
  *
- * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2008-2011 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_BAU_H
@@ -35,17 +35,20 @@
 
 #define MAX_CPUS_PER_UVHUB		64
 #define MAX_CPUS_PER_SOCKET		32
-#define UV_ADP_SIZE			64 /* hardware-provided max. */
-#define UV_CPUS_PER_ACT_STATUS		32 /* hardware-provided max. */
-#define UV_ITEMS_PER_DESCRIPTOR		8
+#define ADP_SZ				64 /* hardware-provided max. */
+#define UV_CPUS_PER_AS			32 /* hardware-provided max. */
+#define ITEMS_PER_DESC			8
 /* the 'throttle' to prevent the hardware stay-busy bug */
 #define MAX_BAU_CONCURRENT		3
 #define UV_ACT_STATUS_MASK		0x3
 #define UV_ACT_STATUS_SIZE		2
 #define UV_DISTRIBUTION_SIZE		256
 #define UV_SW_ACK_NPENDING		8
-#define UV_NET_ENDPOINT_INTD		0x38
-#define UV_DESC_BASE_PNODE_SHIFT	49
+#define UV1_NET_ENDPOINT_INTD		0x38
+#define UV2_NET_ENDPOINT_INTD		0x28
+#define UV_NET_ENDPOINT_INTD		(is_uv1_hub() ?			\
+			UV1_NET_ENDPOINT_INTD : UV2_NET_ENDPOINT_INTD)
+#define UV_DESC_PSHIFT			49
 #define UV_PAYLOADQ_PNODE_SHIFT		49
 #define UV_PTC_BASENAME			"sgi_uv/ptc_statistics"
 #define UV_BAU_BASENAME			"sgi_uv/bau_tunables"
@@ -53,29 +56,64 @@
 #define UV_BAU_TUNABLES_FILE		"bau_tunables"
 #define WHITESPACE			" \t\n"
 #define uv_physnodeaddr(x)		((__pa((unsigned long)(x)) & uv_mmask))
-#define UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT 15
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT 16
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD 0x0000000009UL
+#define cpubit_isset(cpu, bau_local_cpumask) \
+	test_bit((cpu), (bau_local_cpumask).bits)
+
 /* [19:16] SOFT_ACK timeout period  19: 1 is urgency 7  17:16 1 is multiplier */
-#define BAU_MISC_CONTROL_MULT_MASK 3
+/*
+ * UV2: Bit 19 selects between
+ *  (0): 10 microsecond timebase and
+ *  (1): 80 microseconds
+ *  we're using 655us, similar to UV1: 65 units of 10us
+ */
+#define UV1_INTD_SOFT_ACK_TIMEOUT_PERIOD (9UL)
+#define UV2_INTD_SOFT_ACK_TIMEOUT_PERIOD (65*10UL)
+
+#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD	(is_uv1_hub() ?			\
+		UV1_INTD_SOFT_ACK_TIMEOUT_PERIOD :			\
+		UV2_INTD_SOFT_ACK_TIMEOUT_PERIOD)
 
-#define UVH_AGING_PRESCALE_SEL 0x000000b000UL
+#define BAU_MISC_CONTROL_MULT_MASK	3
+
+#define UVH_AGING_PRESCALE_SEL		0x000000b000UL
 /* [30:28] URGENCY_7  an index into a table of times */
-#define BAU_URGENCY_7_SHIFT 28
-#define BAU_URGENCY_7_MASK 7
+#define BAU_URGENCY_7_SHIFT		28
+#define BAU_URGENCY_7_MASK		7
 
-#define UVH_TRANSACTION_TIMEOUT 0x000000b200UL
+#define UVH_TRANSACTION_TIMEOUT		0x000000b200UL
 /* [45:40] BAU - BAU transaction timeout select - a multiplier */
-#define BAU_TRANS_SHIFT 40
-#define BAU_TRANS_MASK 0x3f
+#define BAU_TRANS_SHIFT			40
+#define BAU_TRANS_MASK			0x3f
+
+/*
+ * shorten some awkward names
+ */
+#define AS_PUSH_SHIFT UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT
+#define SOFTACK_MSHIFT UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT
+#define SOFTACK_PSHIFT UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT
+#define SOFTACK_TIMEOUT_PERIOD UV_INTD_SOFT_ACK_TIMEOUT_PERIOD
+#define write_gmmr	uv_write_global_mmr64
+#define write_lmmr	uv_write_local_mmr
+#define read_lmmr	uv_read_local_mmr
+#define read_gmmr	uv_read_global_mmr64
 
 /*
  * bits in UVH_LB_BAU_SB_ACTIVATION_STATUS_0/1
  */
-#define DESC_STATUS_IDLE		0
-#define DESC_STATUS_ACTIVE		1
-#define DESC_STATUS_DESTINATION_TIMEOUT	2
-#define DESC_STATUS_SOURCE_TIMEOUT	3
+#define DS_IDLE				0
+#define DS_ACTIVE			1
+#define DS_DESTINATION_TIMEOUT		2
+#define DS_SOURCE_TIMEOUT		3
+/*
+ * bits put together from HRP_LB_BAU_SB_ACTIVATION_STATUS_0/1/2
+ * values 1 and 5 will not occur
+ */
+#define UV2H_DESC_IDLE			0
+#define UV2H_DESC_DEST_TIMEOUT		2
+#define UV2H_DESC_DEST_STRONG_NACK	3
+#define UV2H_DESC_BUSY			4
+#define UV2H_DESC_SOURCE_TIMEOUT	6
+#define UV2H_DESC_DEST_PUT_ERR		7
 
 /*
  * delay for 'plugged' timeout retries, in microseconds
@@ -86,15 +124,24 @@
  * threshholds at which to use IPI to free resources
  */
 /* after this # consecutive 'plugged' timeouts, use IPI to release resources */
-#define PLUGSB4RESET 100
+#define PLUGSB4RESET			100
 /* after this many consecutive timeouts, use IPI to release resources */
-#define TIMEOUTSB4RESET 1
+#define TIMEOUTSB4RESET			1
 /* at this number uses of IPI to release resources, giveup the request */
-#define IPI_RESET_LIMIT 1
+#define IPI_RESET_LIMIT			1
 /* after this # consecutive successes, bump up the throttle if it was lowered */
-#define COMPLETE_THRESHOLD 5
+#define COMPLETE_THRESHOLD		5
+
+#define UV_LB_SUBNODEID			0x10
 
-#define UV_LB_SUBNODEID 0x10
+/* these two are the same for UV1 and UV2: */
+#define UV_SA_SHFT UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT
+#define UV_SA_MASK UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_MASK
+/* 4 bits of software ack period */
+#define UV2_ACK_MASK			0x7UL
+#define UV2_ACK_UNITS_SHFT		3
+#define UV2_LEG_SHFT UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT
+#define UV2_EXT_SHFT UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT
 
 /*
  * number of entries in the destination side payload queue
@@ -115,9 +162,16 @@
 /*
  * tuning the action when the numalink network is extremely delayed
  */
-#define CONGESTED_RESPONSE_US 1000 /* 'long' response time, in microseconds */
-#define CONGESTED_REPS 10 /* long delays averaged over this many broadcasts */
-#define CONGESTED_PERIOD 30 /* time for the bau to be disabled, in seconds */
+#define CONGESTED_RESPONSE_US		1000	/* 'long' response time, in
+						   microseconds */
+#define CONGESTED_REPS			10	/* long delays averaged over
+						   this many broadcasts */
+#define CONGESTED_PERIOD		30	/* time for the bau to be
+						   disabled, in seconds */
+/* see msg_type: */
+#define MSG_NOOP			0
+#define MSG_REGULAR			1
+#define MSG_RETRY			2
 
 /*
  * Distribution: 32 bytes (256 bits) (bytes 0-0x1f of descriptor)
@@ -129,8 +183,8 @@
  * 'base_dest_nasid' field of the header corresponds to the
  * destination nodeID associated with that specified bit.
  */
-struct bau_target_uvhubmask {
-	unsigned long bits[BITS_TO_LONGS(UV_DISTRIBUTION_SIZE)];
+struct bau_targ_hubmask {
+	unsigned long		bits[BITS_TO_LONGS(UV_DISTRIBUTION_SIZE)];
 };
 
 /*
@@ -139,7 +193,7 @@ struct bau_target_uvhubmask {
  *  enough bits for max. cpu's per uvhub)
  */
 struct bau_local_cpumask {
-	unsigned long bits;
+	unsigned long		bits;
 };
 
 /*
@@ -160,14 +214,14 @@ struct bau_local_cpumask {
  * The payload is software-defined for INTD transactions
  */
 struct bau_msg_payload {
-	unsigned long address;		/* signifies a page or all TLB's
-						of the cpu */
+	unsigned long	address;		/* signifies a page or all
+						   TLB's of the cpu */
 	/* 64 bits */
-	unsigned short sending_cpu;	/* filled in by sender */
+	unsigned short	sending_cpu;		/* filled in by sender */
 	/* 16 bits */
-	unsigned short acknowledge_count;/* filled in by destination */
+	unsigned short	acknowledge_count;	/* filled in by destination */
 	/* 16 bits */
-	unsigned int reserved1:32;	/* not usable */
+	unsigned int	reserved1:32;		/* not usable */
 };
 
 
@@ -176,93 +230,96 @@ struct bau_msg_payload {
  * see table 4.2.3.0.1 in broacast_assist spec.
  */
 struct bau_msg_header {
-	unsigned int dest_subnodeid:6;	/* must be 0x10, for the LB */
+	unsigned int	dest_subnodeid:6;	/* must be 0x10, for the LB */
 	/* bits 5:0 */
-	unsigned int base_dest_nasid:15; /* nasid of the */
-	/* bits 20:6 */			  /* first bit in uvhub map */
-	unsigned int command:8;	/* message type */
+	unsigned int	base_dest_nasid:15;	/* nasid of the first bit */
+	/* bits 20:6 */				/* in uvhub map */
+	unsigned int	command:8;		/* message type */
 	/* bits 28:21 */
-				/* 0x38: SN3net EndPoint Message */
-	unsigned int rsvd_1:3;	/* must be zero */
+	/* 0x38: SN3net EndPoint Message */
+	unsigned int	rsvd_1:3;		/* must be zero */
 	/* bits 31:29 */
-				/* int will align on 32 bits */
-	unsigned int rsvd_2:9;	/* must be zero */
+	/* int will align on 32 bits */
+	unsigned int	rsvd_2:9;		/* must be zero */
 	/* bits 40:32 */
-				/* Suppl_A is 56-41 */
-	unsigned int sequence:16;/* message sequence number */
-	/* bits 56:41 */	/* becomes bytes 16-17 of msg */
-				/* Address field (96:57) is never used as an
-				   address (these are address bits 42:3) */
-
-	unsigned int rsvd_3:1;	/* must be zero */
+	/* Suppl_A is 56-41 */
+	unsigned int	sequence:16;		/* message sequence number */
+	/* bits 56:41 */			/* becomes bytes 16-17 of msg */
+						/* Address field (96:57) is
+						   never used as an address
+						   (these are address bits
+						   42:3) */
+
+	unsigned int	rsvd_3:1;		/* must be zero */
 	/* bit 57 */
-				/* address bits 27:4 are payload */
+	/* address bits 27:4 are payload */
 	/* these next 24  (58-81) bits become bytes 12-14 of msg */
-
 	/* bits 65:58 land in byte 12 */
-	unsigned int replied_to:1;/* sent as 0 by the source to byte 12 */
+	unsigned int	replied_to:1;		/* sent as 0 by the source to
+						   byte 12 */
 	/* bit 58 */
-	unsigned int msg_type:3; /* software type of the message*/
+	unsigned int	msg_type:3;		/* software type of the
+						   message */
 	/* bits 61:59 */
-	unsigned int canceled:1; /* message canceled, resource to be freed*/
+	unsigned int	canceled:1;		/* message canceled, resource
+						   is to be freed*/
 	/* bit 62 */
-	unsigned int payload_1a:1;/* not currently used */
+	unsigned int	payload_1a:1;		/* not currently used */
 	/* bit 63 */
-	unsigned int payload_1b:2;/* not currently used */
+	unsigned int	payload_1b:2;		/* not currently used */
 	/* bits 65:64 */
 
 	/* bits 73:66 land in byte 13 */
-	unsigned int payload_1ca:6;/* not currently used */
+	unsigned int	payload_1ca:6;		/* not currently used */
 	/* bits 71:66 */
-	unsigned int payload_1c:2;/* not currently used */
+	unsigned int	payload_1c:2;		/* not currently used */
 	/* bits 73:72 */
 
 	/* bits 81:74 land in byte 14 */
-	unsigned int payload_1d:6;/* not currently used */
+	unsigned int	payload_1d:6;		/* not currently used */
 	/* bits 79:74 */
-	unsigned int payload_1e:2;/* not currently used */
+	unsigned int	payload_1e:2;		/* not currently used */
 	/* bits 81:80 */
 
-	unsigned int rsvd_4:7;	/* must be zero */
+	unsigned int	rsvd_4:7;		/* must be zero */
 	/* bits 88:82 */
-	unsigned int sw_ack_flag:1;/* software acknowledge flag */
+	unsigned int	swack_flag:1;		/* software acknowledge flag */
 	/* bit 89 */
-				/* INTD trasactions at destination are to
-				   wait for software acknowledge */
-	unsigned int rsvd_5:6;	/* must be zero */
+						/* INTD trasactions at
+						   destination are to wait for
+						   software acknowledge */
+	unsigned int	rsvd_5:6;		/* must be zero */
 	/* bits 95:90 */
-	unsigned int rsvd_6:5;	/* must be zero */
+	unsigned int	rsvd_6:5;		/* must be zero */
 	/* bits 100:96 */
-	unsigned int int_both:1;/* if 1, interrupt both sockets on the uvhub */
+	unsigned int	int_both:1;		/* if 1, interrupt both sockets
+						   on the uvhub */
 	/* bit 101*/
-	unsigned int fairness:3;/* usually zero */
+	unsigned int	fairness:3;		/* usually zero */
 	/* bits 104:102 */
-	unsigned int multilevel:1;	/* multi-level multicast format */
+	unsigned int	multilevel:1;		/* multi-level multicast
+						   format */
 	/* bit 105 */
-				/* 0 for TLB: endpoint multi-unicast messages */
-	unsigned int chaining:1;/* next descriptor is part of this activation*/
+	/* 0 for TLB: endpoint multi-unicast messages */
+	unsigned int	chaining:1;		/* next descriptor is part of
+						   this activation*/
 	/* bit 106 */
-	unsigned int rsvd_7:21;	/* must be zero */
+	unsigned int	rsvd_7:21;		/* must be zero */
 	/* bits 127:107 */
 };
 
-/* see msg_type: */
-#define MSG_NOOP 0
-#define MSG_REGULAR 1
-#define MSG_RETRY 2
-
 /*
  * The activation descriptor:
  * The format of the message to send, plus all accompanying control
  * Should be 64 bytes
  */
 struct bau_desc {
-	struct bau_target_uvhubmask distribution;
+	struct bau_targ_hubmask	distribution;
 	/*
 	 * message template, consisting of header and payload:
 	 */
-	struct bau_msg_header header;
-	struct bau_msg_payload payload;
+	struct bau_msg_header		header;
+	struct bau_msg_payload		payload;
 };
 /*
  *   -payload--    ---------header------
@@ -281,59 +338,51 @@ struct bau_desc {
  * are 32 bytes (2 micropackets) (256 bits) in length, but contain only 17
  * bytes of usable data, including the sw ack vector in byte 15 (bits 127:120)
  * (12 bytes come from bau_msg_payload, 3 from payload_1, 2 from
- *  sw_ack_vector and payload_2)
+ *  swack_vec and payload_2)
  * "Enabling Software Acknowledgment mode (see Section 4.3.3 Software
  *  Acknowledge Processing) also selects 32 byte (17 bytes usable) payload
  *  operation."
  */
-struct bau_payload_queue_entry {
-	unsigned long address;		/* signifies a page or all TLB's
-						of the cpu */
+struct bau_pq_entry {
+	unsigned long	address;	/* signifies a page or all TLB's
+					   of the cpu */
 	/* 64 bits, bytes 0-7 */
-
-	unsigned short sending_cpu;	/* cpu that sent the message */
+	unsigned short	sending_cpu;	/* cpu that sent the message */
 	/* 16 bits, bytes 8-9 */
-
-	unsigned short acknowledge_count; /* filled in by destination */
+	unsigned short	acknowledge_count; /* filled in by destination */
 	/* 16 bits, bytes 10-11 */
-
 	/* these next 3 bytes come from bits 58-81 of the message header */
-	unsigned short replied_to:1;    /* sent as 0 by the source */
-	unsigned short msg_type:3;      /* software message type */
-	unsigned short canceled:1;      /* sent as 0 by the source */
-	unsigned short unused1:3;       /* not currently using */
+	unsigned short	replied_to:1;	/* sent as 0 by the source */
+	unsigned short	msg_type:3;	/* software message type */
+	unsigned short	canceled:1;	/* sent as 0 by the source */
+	unsigned short	unused1:3;	/* not currently using */
 	/* byte 12 */
-
-	unsigned char unused2a;		/* not currently using */
+	unsigned char	unused2a;	/* not currently using */
 	/* byte 13 */
-	unsigned char unused2;		/* not currently using */
+	unsigned char	unused2;	/* not currently using */
 	/* byte 14 */
-
-	unsigned char sw_ack_vector;	/* filled in by the hardware */
+	unsigned char	swack_vec;	/* filled in by the hardware */
 	/* byte 15 (bits 127:120) */
-
-	unsigned short sequence;	/* message sequence number */
+	unsigned short	sequence;	/* message sequence number */
 	/* bytes 16-17 */
-	unsigned char unused4[2];	/* not currently using bytes 18-19 */
+	unsigned char	unused4[2];	/* not currently using bytes 18-19 */
 	/* bytes 18-19 */
-
-	int number_of_cpus;		/* filled in at destination */
+	int		number_of_cpus;	/* filled in at destination */
 	/* 32 bits, bytes 20-23 (aligned) */
-
-	unsigned char unused5[8];       /* not using */
+	unsigned char	unused5[8];	/* not using */
 	/* bytes 24-31 */
 };
 
 struct msg_desc {
-	struct bau_payload_queue_entry *msg;
-	int msg_slot;
-	int sw_ack_slot;
-	struct bau_payload_queue_entry *va_queue_first;
-	struct bau_payload_queue_entry *va_queue_last;
+	struct bau_pq_entry	*msg;
+	int			msg_slot;
+	int			swack_slot;
+	struct bau_pq_entry	*queue_first;
+	struct bau_pq_entry	*queue_last;
 };
 
 struct reset_args {
-	int sender;
+	int			sender;
 };
 
 /*
@@ -341,112 +390,226 @@ struct reset_args {
  */
 struct ptc_stats {
 	/* sender statistics */
-	unsigned long s_giveup; /* number of fall backs to IPI-style flushes */
-	unsigned long s_requestor; /* number of shootdown requests */
-	unsigned long s_stimeout; /* source side timeouts */
-	unsigned long s_dtimeout; /* destination side timeouts */
-	unsigned long s_time; /* time spent in sending side */
-	unsigned long s_retriesok; /* successful retries */
-	unsigned long s_ntargcpu; /* total number of cpu's targeted */
-	unsigned long s_ntargself; /* times the sending cpu was targeted */
-	unsigned long s_ntarglocals; /* targets of cpus on the local blade */
-	unsigned long s_ntargremotes; /* targets of cpus on remote blades */
-	unsigned long s_ntarglocaluvhub; /* targets of the local hub */
-	unsigned long s_ntargremoteuvhub; /* remotes hubs targeted */
-	unsigned long s_ntarguvhub; /* total number of uvhubs targeted */
-	unsigned long s_ntarguvhub16; /* number of times target hubs >= 16*/
-	unsigned long s_ntarguvhub8; /* number of times target hubs >= 8 */
-	unsigned long s_ntarguvhub4; /* number of times target hubs >= 4 */
-	unsigned long s_ntarguvhub2; /* number of times target hubs >= 2 */
-	unsigned long s_ntarguvhub1; /* number of times target hubs == 1 */
-	unsigned long s_resets_plug; /* ipi-style resets from plug state */
-	unsigned long s_resets_timeout; /* ipi-style resets from timeouts */
-	unsigned long s_busy; /* status stayed busy past s/w timer */
-	unsigned long s_throttles; /* waits in throttle */
-	unsigned long s_retry_messages; /* retry broadcasts */
-	unsigned long s_bau_reenabled; /* for bau enable/disable */
-	unsigned long s_bau_disabled; /* for bau enable/disable */
+	unsigned long	s_giveup;		/* number of fall backs to
+						   IPI-style flushes */
+	unsigned long	s_requestor;		/* number of shootdown
+						   requests */
+	unsigned long	s_stimeout;		/* source side timeouts */
+	unsigned long	s_dtimeout;		/* destination side timeouts */
+	unsigned long	s_time;			/* time spent in sending side */
+	unsigned long	s_retriesok;		/* successful retries */
+	unsigned long	s_ntargcpu;		/* total number of cpu's
+						   targeted */
+	unsigned long	s_ntargself;		/* times the sending cpu was
+						   targeted */
+	unsigned long	s_ntarglocals;		/* targets of cpus on the local
+						   blade */
+	unsigned long	s_ntargremotes;		/* targets of cpus on remote
+						   blades */
+	unsigned long	s_ntarglocaluvhub;	/* targets of the local hub */
+	unsigned long	s_ntargremoteuvhub;	/* remotes hubs targeted */
+	unsigned long	s_ntarguvhub;		/* total number of uvhubs
+						   targeted */
+	unsigned long	s_ntarguvhub16;		/* number of times target
+						   hubs >= 16*/
+	unsigned long	s_ntarguvhub8;		/* number of times target
+						   hubs >= 8 */
+	unsigned long	s_ntarguvhub4;		/* number of times target
+						   hubs >= 4 */
+	unsigned long	s_ntarguvhub2;		/* number of times target
+						   hubs >= 2 */
+	unsigned long	s_ntarguvhub1;		/* number of times target
+						   hubs == 1 */
+	unsigned long	s_resets_plug;		/* ipi-style resets from plug
+						   state */
+	unsigned long	s_resets_timeout;	/* ipi-style resets from
+						   timeouts */
+	unsigned long	s_busy;			/* status stayed busy past
+						   s/w timer */
+	unsigned long	s_throttles;		/* waits in throttle */
+	unsigned long	s_retry_messages;	/* retry broadcasts */
+	unsigned long	s_bau_reenabled;	/* for bau enable/disable */
+	unsigned long	s_bau_disabled;		/* for bau enable/disable */
 	/* destination statistics */
-	unsigned long d_alltlb; /* times all tlb's on this cpu were flushed */
-	unsigned long d_onetlb; /* times just one tlb on this cpu was flushed */
-	unsigned long d_multmsg; /* interrupts with multiple messages */
-	unsigned long d_nomsg; /* interrupts with no message */
-	unsigned long d_time; /* time spent on destination side */
-	unsigned long d_requestee; /* number of messages processed */
-	unsigned long d_retries; /* number of retry messages processed */
-	unsigned long d_canceled; /* number of messages canceled by retries */
-	unsigned long d_nocanceled; /* retries that found nothing to cancel */
-	unsigned long d_resets; /* number of ipi-style requests processed */
-	unsigned long d_rcanceled; /* number of messages canceled by resets */
+	unsigned long	d_alltlb;		/* times all tlb's on this
+						   cpu were flushed */
+	unsigned long	d_onetlb;		/* times just one tlb on this
+						   cpu was flushed */
+	unsigned long	d_multmsg;		/* interrupts with multiple
+						   messages */
+	unsigned long	d_nomsg;		/* interrupts with no message */
+	unsigned long	d_time;			/* time spent on destination
+						   side */
+	unsigned long	d_requestee;		/* number of messages
+						   processed */
+	unsigned long	d_retries;		/* number of retry messages
+						   processed */
+	unsigned long	d_canceled;		/* number of messages canceled
+						   by retries */
+	unsigned long	d_nocanceled;		/* retries that found nothing
+						   to cancel */
+	unsigned long	d_resets;		/* number of ipi-style requests
+						   processed */
+	unsigned long	d_rcanceled;		/* number of messages canceled
+						   by resets */
+};
+
+struct tunables {
+	int			*tunp;
+	int			deflt;
 };
 
 struct hub_and_pnode {
-	short uvhub;
-	short pnode;
+	short			uvhub;
+	short			pnode;
 };
+
+struct socket_desc {
+	short			num_cpus;
+	short			cpu_number[MAX_CPUS_PER_SOCKET];
+};
+
+struct uvhub_desc {
+	unsigned short		socket_mask;
+	short			num_cpus;
+	short			uvhub;
+	short			pnode;
+	struct socket_desc	socket[2];
+};
+
 /*
  * one per-cpu; to locate the software tables
  */
 struct bau_control {
-	struct bau_desc *descriptor_base;
-	struct bau_payload_queue_entry *va_queue_first;
-	struct bau_payload_queue_entry *va_queue_last;
-	struct bau_payload_queue_entry *bau_msg_head;
-	struct bau_control *uvhub_master;
-	struct bau_control *socket_master;
-	struct ptc_stats *statp;
-	unsigned long timeout_interval;
-	unsigned long set_bau_on_time;
-	atomic_t active_descriptor_count;
-	int plugged_tries;
-	int timeout_tries;
-	int ipi_attempts;
-	int conseccompletes;
-	int baudisabled;
-	int set_bau_off;
-	short cpu;
-	short osnode;
-	short uvhub_cpu;
-	short uvhub;
-	short cpus_in_socket;
-	short cpus_in_uvhub;
-	short partition_base_pnode;
-	unsigned short message_number;
-	unsigned short uvhub_quiesce;
-	short socket_acknowledge_count[DEST_Q_SIZE];
-	cycles_t send_message;
-	spinlock_t uvhub_lock;
-	spinlock_t queue_lock;
+	struct bau_desc		*descriptor_base;
+	struct bau_pq_entry	*queue_first;
+	struct bau_pq_entry	*queue_last;
+	struct bau_pq_entry	*bau_msg_head;
+	struct bau_control	*uvhub_master;
+	struct bau_control	*socket_master;
+	struct ptc_stats	*statp;
+	unsigned long		timeout_interval;
+	unsigned long		set_bau_on_time;
+	atomic_t		active_descriptor_count;
+	int			plugged_tries;
+	int			timeout_tries;
+	int			ipi_attempts;
+	int			conseccompletes;
+	int			baudisabled;
+	int			set_bau_off;
+	short			cpu;
+	short			osnode;
+	short			uvhub_cpu;
+	short			uvhub;
+	short			cpus_in_socket;
+	short			cpus_in_uvhub;
+	short			partition_base_pnode;
+	unsigned short		message_number;
+	unsigned short		uvhub_quiesce;
+	short			socket_acknowledge_count[DEST_Q_SIZE];
+	cycles_t		send_message;
+	spinlock_t		uvhub_lock;
+	spinlock_t		queue_lock;
 	/* tunables */
-	int max_bau_concurrent;
-	int max_bau_concurrent_constant;
-	int plugged_delay;
-	int plugsb4reset;
-	int timeoutsb4reset;
-	int ipi_reset_limit;
-	int complete_threshold;
-	int congested_response_us;
-	int congested_reps;
-	int congested_period;
-	cycles_t period_time;
-	long period_requests;
-	struct hub_and_pnode *target_hub_and_pnode;
+	int			max_concurr;
+	int			max_concurr_const;
+	int			plugged_delay;
+	int			plugsb4reset;
+	int			timeoutsb4reset;
+	int			ipi_reset_limit;
+	int			complete_threshold;
+	int			cong_response_us;
+	int			cong_reps;
+	int			cong_period;
+	cycles_t		period_time;
+	long			period_requests;
+	struct hub_and_pnode	*thp;
 };
 
-static inline int bau_uvhub_isset(int uvhub, struct bau_target_uvhubmask *dstp)
+static unsigned long read_mmr_uv2_status(void)
+{
+	return read_lmmr(UV2H_LB_BAU_SB_ACTIVATION_STATUS_2);
+}
+
+static void write_mmr_data_broadcast(int pnode, unsigned long mmr_image)
+{
+	write_gmmr(pnode, UVH_BAU_DATA_BROADCAST, mmr_image);
+}
+
+static void write_mmr_descriptor_base(int pnode, unsigned long mmr_image)
+{
+	write_gmmr(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE, mmr_image);
+}
+
+static void write_mmr_activation(unsigned long index)
+{
+	write_lmmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
+}
+
+static void write_gmmr_activation(int pnode, unsigned long mmr_image)
+{
+	write_gmmr(pnode, UVH_LB_BAU_SB_ACTIVATION_CONTROL, mmr_image);
+}
+
+static void write_mmr_payload_first(int pnode, unsigned long mmr_image)
+{
+	write_gmmr(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST, mmr_image);
+}
+
+static void write_mmr_payload_tail(int pnode, unsigned long mmr_image)
+{
+	write_gmmr(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL, mmr_image);
+}
+
+static void write_mmr_payload_last(int pnode, unsigned long mmr_image)
+{
+	write_gmmr(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST, mmr_image);
+}
+
+static void write_mmr_misc_control(int pnode, unsigned long mmr_image)
+{
+	write_gmmr(pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+}
+
+static unsigned long read_mmr_misc_control(int pnode)
+{
+	return read_gmmr(pnode, UVH_LB_BAU_MISC_CONTROL);
+}
+
+static void write_mmr_sw_ack(unsigned long mr)
+{
+	uv_write_local_mmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, mr);
+}
+
+static unsigned long read_mmr_sw_ack(void)
+{
+	return read_lmmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
+}
+
+static unsigned long read_gmmr_sw_ack(int pnode)
+{
+	return read_gmmr(pnode, UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
+}
+
+static void write_mmr_data_config(int pnode, unsigned long mr)
+{
+	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG, mr);
+}
+
+static inline int bau_uvhub_isset(int uvhub, struct bau_targ_hubmask *dstp)
 {
 	return constant_test_bit(uvhub, &dstp->bits[0]);
 }
-static inline void bau_uvhub_set(int pnode, struct bau_target_uvhubmask *dstp)
+static inline void bau_uvhub_set(int pnode, struct bau_targ_hubmask *dstp)
 {
 	__set_bit(pnode, &dstp->bits[0]);
 }
-static inline void bau_uvhubs_clear(struct bau_target_uvhubmask *dstp,
+static inline void bau_uvhubs_clear(struct bau_targ_hubmask *dstp,
 				    int nbits)
 {
 	bitmap_zero(&dstp->bits[0], nbits);
 }
-static inline int bau_uvhub_weight(struct bau_target_uvhubmask *dstp)
+static inline int bau_uvhub_weight(struct bau_targ_hubmask *dstp)
 {
 	return bitmap_weight((unsigned long *)&dstp->bits[0],
 				UV_DISTRIBUTION_SIZE);
@@ -457,9 +620,6 @@ static inline void bau_cpubits_clear(struct bau_local_cpumask *dstp, int nbits)
 	bitmap_zero(&dstp->bits, nbits);
 }
 
-#define cpubit_isset(cpu, bau_local_cpumask) \
-	test_bit((cpu), (bau_local_cpumask).bits)
-
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
 
@@ -467,7 +627,7 @@ struct atomic_short {
 	short counter;
 };
 
-/**
+/*
  * atomic_read_short - read a short atomic variable
  * @v: pointer of type atomic_short
  *
@@ -478,14 +638,14 @@ static inline int atomic_read_short(const struct atomic_short *v)
 	return v->counter;
 }
 
-/**
- * atomic_add_short_return - add and return a short int
+/*
+ * atom_asr - add and return a short int
  * @i: short value to add
  * @v: pointer of type atomic_short
  *
  * Atomically adds @i to @v and returns @i + @v
  */
-static inline int atomic_add_short_return(short i, struct atomic_short *v)
+static inline int atom_asr(short i, struct atomic_short *v)
 {
 	short __i = i;
 	asm volatile(LOCK_PREFIX "xaddw %0, %1"
@@ -494,4 +654,26 @@ static inline int atomic_add_short_return(short i, struct atomic_short *v)
 	return i + __i;
 }
 
+/*
+ * conditionally add 1 to *v, unless *v is >= u
+ * return 0 if we cannot add 1 to *v because it is >= u
+ * return 1 if we can add 1 to *v because it is < u
+ * the add is atomic
+ *
+ * This is close to atomic_add_unless(), but this allows the 'u' value
+ * to be lowered below the current 'v'.  atomic_add_unless can only stop
+ * on equal.
+ */
+static inline int atomic_inc_unless_ge(spinlock_t *lock, atomic_t *v, int u)
+{
+	spin_lock(lock);
+	if (atomic_read(v) >= u) {
+		spin_unlock(lock);
+		return 0;
+	}
+	atomic_inc(v);
+	spin_unlock(lock);
+	return 1;
+}
+
 #endif /* _ASM_X86_UV_UV_BAU_H */
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 4298002..f26544a 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -77,8 +77,9 @@
  *
  *		1111110000000000
  *		5432109876543210
- *		pppppppppplc0cch	Nehalem-EX
- *		ppppppppplcc0cch	Westmere-EX
+ *		pppppppppplc0cch	Nehalem-EX (12 bits in hdw reg)
+ *		ppppppppplcc0cch	Westmere-EX (12 bits in hdw reg)
+ *		pppppppppppcccch	SandyBridge (15 bits in hdw reg)
  *		sssssssssss
  *
  *			p  = pnode bits
@@ -87,7 +88,7 @@
  *			h  = hyperthread
  *			s  = bits that are in the SOCKET_ID CSR
  *
- *	Note: Processor only supports 12 bits in the APICID register. The ACPI
+ *	Note: Processor may support fewer bits in the APICID register. The ACPI
  *	      tables hold all 16 bits. Software needs to be aware of this.
  *
  *	      Unless otherwise specified, all references to APICID refer to
@@ -138,6 +139,8 @@ struct uv_hub_info_s {
 	unsigned long		global_mmr_base;
 	unsigned long		gpa_mask;
 	unsigned int		gnode_extra;
+	unsigned char		hub_revision;
+	unsigned char		apic_pnode_shift;
 	unsigned long		gnode_upper;
 	unsigned long		lowmem_remap_top;
 	unsigned long		lowmem_remap_base;
@@ -149,13 +152,31 @@ struct uv_hub_info_s {
 	unsigned char		m_val;
 	unsigned char		n_val;
 	struct uv_scir_s	scir;
-	unsigned char		apic_pnode_shift;
 };
 
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define uv_hub_info		(&__get_cpu_var(__uv_hub_info))
 #define uv_cpu_hub_info(cpu)	(&per_cpu(__uv_hub_info, cpu))
 
+/*
+ * Hub revisions less than UV2_HUB_REVISION_BASE are UV1 hubs. All UV2
+ * hubs have revision numbers greater than or equal to UV2_HUB_REVISION_BASE.
+ * This is a software convention - NOT the hardware revision numbers in
+ * the hub chip.
+ */
+#define UV1_HUB_REVISION_BASE		1
+#define UV2_HUB_REVISION_BASE		3
+
+static inline int is_uv1_hub(void)
+{
+	return uv_hub_info->hub_revision < UV2_HUB_REVISION_BASE;
+}
+
+static inline int is_uv2_hub(void)
+{
+	return uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE;
+}
+
 union uvh_apicid {
     unsigned long       v;
     struct uvh_apicid_s {
@@ -180,11 +201,25 @@ union uvh_apicid {
 #define UV_PNODE_TO_GNODE(p)		((p) |uv_hub_info->gnode_extra)
 #define UV_PNODE_TO_NASID(p)		(UV_PNODE_TO_GNODE(p) << 1)
 
-#define UV_LOCAL_MMR_BASE		0xf4000000UL
-#define UV_GLOBAL_MMR32_BASE		0xf8000000UL
+#define UV1_LOCAL_MMR_BASE		0xf4000000UL
+#define UV1_GLOBAL_MMR32_BASE		0xf8000000UL
+#define UV1_LOCAL_MMR_SIZE		(64UL * 1024 * 1024)
+#define UV1_GLOBAL_MMR32_SIZE		(64UL * 1024 * 1024)
+
+#define UV2_LOCAL_MMR_BASE		0xfa000000UL
+#define UV2_GLOBAL_MMR32_BASE		0xfc000000UL
+#define UV2_LOCAL_MMR_SIZE		(32UL * 1024 * 1024)
+#define UV2_GLOBAL_MMR32_SIZE		(32UL * 1024 * 1024)
+
+#define UV_LOCAL_MMR_BASE		(is_uv1_hub() ? UV1_LOCAL_MMR_BASE     \
+						: UV2_LOCAL_MMR_BASE)
+#define UV_GLOBAL_MMR32_BASE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_BASE  \
+						: UV2_GLOBAL_MMR32_BASE)
+#define UV_LOCAL_MMR_SIZE		(is_uv1_hub() ? UV1_LOCAL_MMR_SIZE :   \
+						UV2_LOCAL_MMR_SIZE)
+#define UV_GLOBAL_MMR32_SIZE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_SIZE :\
+						UV2_GLOBAL_MMR32_SIZE)
 #define UV_GLOBAL_MMR64_BASE		(uv_hub_info->global_mmr_base)
-#define UV_LOCAL_MMR_SIZE		(64UL * 1024 * 1024)
-#define UV_GLOBAL_MMR32_SIZE		(64UL * 1024 * 1024)
 
 #define UV_GLOBAL_GRU_MMR_BASE		0x4000000
 
@@ -301,6 +336,17 @@ static inline int uv_apicid_to_pnode(int apicid)
 }
 
 /*
+ * Convert an apicid to the socket number on the blade
+ */
+static inline int uv_apicid_to_socket(int apicid)
+{
+	if (is_uv1_hub())
+		return (apicid >> (uv_hub_info->apic_pnode_shift - 1)) & 1;
+	else
+		return 0;
+}
+
+/*
  * Access global MMRs using the low memory MMR32 space. This region supports
  * faster MMR access but not all MMRs are accessible in this space.
  */
@@ -519,14 +565,13 @@ static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 
 /*
  * Get the minimum revision number of the hub chips within the partition.
- *     1 - initial rev 1.0 silicon
- *     2 - rev 2.0 production silicon
+ *     1 - UV1 rev 1.0 initial silicon
+ *     2 - UV1 rev 2.0 production silicon
+ *     3 - UV2 rev 1.0 initial silicon
  */
 static inline int uv_get_min_hub_revision_id(void)
 {
-	extern int uv_min_hub_revision_id;
-
-	return uv_min_hub_revision_id;
+	return uv_hub_info->hub_revision;
 }
 
 #endif /* CONFIG_X86_64 */
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index f5bb64a..4be52c8 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -11,13 +11,64 @@
 #ifndef _ASM_X86_UV_UV_MMRS_H
 #define _ASM_X86_UV_UV_MMRS_H
 
+/*
+ * This file contains MMR definitions for both UV1 & UV2 hubs.
+ *
+ * In general, MMR addresses and structures are identical on both hubs.
+ * These MMRs are identified as:
+ *	#define UVH_xxx		<address>
+ *	union uvh_xxx {
+ *		unsigned long       v;
+ *		struct uvh_int_cmpd_s {
+ *		} s;
+ *	};
+ *
+ * If the MMR exists on both hub type but has different addresses or
+ * contents, the MMR definition is similar to:
+ *	#define UV1H_xxx	<uv1 address>
+ *	#define UV2H_xxx	<uv2address>
+ *	#define UVH_xxx		(is_uv1_hub() ? UV1H_xxx : UV2H_xxx)
+ *	union uvh_xxx {
+ *		unsigned long       v;
+ *		struct uv1h_int_cmpd_s {	 (Common fields only)
+ *		} s;
+ *		struct uv1h_int_cmpd_s {	 (Full UV1 definition)
+ *		} s1;
+ *		struct uv2h_int_cmpd_s {	 (Full UV2 definition)
+ *		} s2;
+ *	};
+ *
+ * Only essential difference are enumerated. For example, if the address is
+ * the same for both UV1 & UV2, only a single #define is generated. Likewise,
+ * if the contents is the same for both hubs, only the "s" structure is
+ * generated.
+ *
+ * If the MMR exists on ONLY 1 type of hub, no generic definition is
+ * generated:
+ *	#define UVnH_xxx	<uvn address>
+ *	union uvnh_xxx {
+ *		unsigned long       v;
+ *		struct uvh_int_cmpd_s {
+ *		} sn;
+ *	};
+ */
+
 #define UV_MMR_ENABLE		(1UL << 63)
 
+#define UV1_HUB_PART_NUMBER	0x88a5
+#define UV2_HUB_PART_NUMBER	0x8eb8
+
+/* Compat: if this #define is present, UV headers support UV2 */
+#define UV2_HUB_IS_SUPPORTED	1
+
+/* KABI compat: if this #define is present, KABI hacks are present */
+#define UV2_HUB_KABI_HACKS	1
+
 /* ========================================================================= */
 /*                          UVH_BAU_DATA_BROADCAST                           */
 /* ========================================================================= */
 #define UVH_BAU_DATA_BROADCAST 0x61688UL
-#define UVH_BAU_DATA_BROADCAST_32 0x0440
+#define UVH_BAU_DATA_BROADCAST_32 0x440
 
 #define UVH_BAU_DATA_BROADCAST_ENABLE_SHFT 0
 #define UVH_BAU_DATA_BROADCAST_ENABLE_MASK 0x0000000000000001UL
@@ -34,7 +85,7 @@ union uvh_bau_data_broadcast_u {
 /*                           UVH_BAU_DATA_CONFIG                             */
 /* ========================================================================= */
 #define UVH_BAU_DATA_CONFIG 0x61680UL
-#define UVH_BAU_DATA_CONFIG_32 0x0438
+#define UVH_BAU_DATA_CONFIG_32 0x438
 
 #define UVH_BAU_DATA_CONFIG_VECTOR_SHFT 0
 #define UVH_BAU_DATA_CONFIG_VECTOR_MASK 0x00000000000000ffUL
@@ -73,125 +124,245 @@ union uvh_bau_data_config_u {
 /*                           UVH_EVENT_OCCURRED0                             */
 /* ========================================================================= */
 #define UVH_EVENT_OCCURRED0 0x70000UL
-#define UVH_EVENT_OCCURRED0_32 0x005e8
-
-#define UVH_EVENT_OCCURRED0_LB_HCERR_SHFT 0
-#define UVH_EVENT_OCCURRED0_LB_HCERR_MASK 0x0000000000000001UL
-#define UVH_EVENT_OCCURRED0_GR0_HCERR_SHFT 1
-#define UVH_EVENT_OCCURRED0_GR0_HCERR_MASK 0x0000000000000002UL
-#define UVH_EVENT_OCCURRED0_GR1_HCERR_SHFT 2
-#define UVH_EVENT_OCCURRED0_GR1_HCERR_MASK 0x0000000000000004UL
-#define UVH_EVENT_OCCURRED0_LH_HCERR_SHFT 3
-#define UVH_EVENT_OCCURRED0_LH_HCERR_MASK 0x0000000000000008UL
-#define UVH_EVENT_OCCURRED0_RH_HCERR_SHFT 4
-#define UVH_EVENT_OCCURRED0_RH_HCERR_MASK 0x0000000000000010UL
-#define UVH_EVENT_OCCURRED0_XN_HCERR_SHFT 5
-#define UVH_EVENT_OCCURRED0_XN_HCERR_MASK 0x0000000000000020UL
-#define UVH_EVENT_OCCURRED0_SI_HCERR_SHFT 6
-#define UVH_EVENT_OCCURRED0_SI_HCERR_MASK 0x0000000000000040UL
-#define UVH_EVENT_OCCURRED0_LB_AOERR0_SHFT 7
-#define UVH_EVENT_OCCURRED0_LB_AOERR0_MASK 0x0000000000000080UL
-#define UVH_EVENT_OCCURRED0_GR0_AOERR0_SHFT 8
-#define UVH_EVENT_OCCURRED0_GR0_AOERR0_MASK 0x0000000000000100UL
-#define UVH_EVENT_OCCURRED0_GR1_AOERR0_SHFT 9
-#define UVH_EVENT_OCCURRED0_GR1_AOERR0_MASK 0x0000000000000200UL
-#define UVH_EVENT_OCCURRED0_LH_AOERR0_SHFT 10
-#define UVH_EVENT_OCCURRED0_LH_AOERR0_MASK 0x0000000000000400UL
-#define UVH_EVENT_OCCURRED0_RH_AOERR0_SHFT 11
-#define UVH_EVENT_OCCURRED0_RH_AOERR0_MASK 0x0000000000000800UL
-#define UVH_EVENT_OCCURRED0_XN_AOERR0_SHFT 12
-#define UVH_EVENT_OCCURRED0_XN_AOERR0_MASK 0x0000000000001000UL
-#define UVH_EVENT_OCCURRED0_SI_AOERR0_SHFT 13
-#define UVH_EVENT_OCCURRED0_SI_AOERR0_MASK 0x0000000000002000UL
-#define UVH_EVENT_OCCURRED0_LB_AOERR1_SHFT 14
-#define UVH_EVENT_OCCURRED0_LB_AOERR1_MASK 0x0000000000004000UL
-#define UVH_EVENT_OCCURRED0_GR0_AOERR1_SHFT 15
-#define UVH_EVENT_OCCURRED0_GR0_AOERR1_MASK 0x0000000000008000UL
-#define UVH_EVENT_OCCURRED0_GR1_AOERR1_SHFT 16
-#define UVH_EVENT_OCCURRED0_GR1_AOERR1_MASK 0x0000000000010000UL
-#define UVH_EVENT_OCCURRED0_LH_AOERR1_SHFT 17
-#define UVH_EVENT_OCCURRED0_LH_AOERR1_MASK 0x0000000000020000UL
-#define UVH_EVENT_OCCURRED0_RH_AOERR1_SHFT 18
-#define UVH_EVENT_OCCURRED0_RH_AOERR1_MASK 0x0000000000040000UL
-#define UVH_EVENT_OCCURRED0_XN_AOERR1_SHFT 19
-#define UVH_EVENT_OCCURRED0_XN_AOERR1_MASK 0x0000000000080000UL
-#define UVH_EVENT_OCCURRED0_SI_AOERR1_SHFT 20
-#define UVH_EVENT_OCCURRED0_SI_AOERR1_MASK 0x0000000000100000UL
-#define UVH_EVENT_OCCURRED0_RH_VPI_INT_SHFT 21
-#define UVH_EVENT_OCCURRED0_RH_VPI_INT_MASK 0x0000000000200000UL
-#define UVH_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_SHFT 22
-#define UVH_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_MASK 0x0000000000400000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_0_SHFT 23
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_0_MASK 0x0000000000800000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_1_SHFT 24
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_1_MASK 0x0000000001000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_2_SHFT 25
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_2_MASK 0x0000000002000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_3_SHFT 26
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_3_MASK 0x0000000004000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_4_SHFT 27
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_4_MASK 0x0000000008000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_5_SHFT 28
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_5_MASK 0x0000000010000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_6_SHFT 29
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_6_MASK 0x0000000020000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_7_SHFT 30
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_7_MASK 0x0000000040000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_8_SHFT 31
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_8_MASK 0x0000000080000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_9_SHFT 32
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_9_MASK 0x0000000100000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_10_SHFT 33
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_10_MASK 0x0000000200000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_11_SHFT 34
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_11_MASK 0x0000000400000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_12_SHFT 35
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_12_MASK 0x0000000800000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_13_SHFT 36
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_13_MASK 0x0000001000000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_14_SHFT 37
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_14_MASK 0x0000002000000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_15_SHFT 38
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_15_MASK 0x0000004000000000UL
-#define UVH_EVENT_OCCURRED0_L1_NMI_INT_SHFT 39
-#define UVH_EVENT_OCCURRED0_L1_NMI_INT_MASK 0x0000008000000000UL
-#define UVH_EVENT_OCCURRED0_STOP_CLOCK_SHFT 40
-#define UVH_EVENT_OCCURRED0_STOP_CLOCK_MASK 0x0000010000000000UL
-#define UVH_EVENT_OCCURRED0_ASIC_TO_L1_SHFT 41
-#define UVH_EVENT_OCCURRED0_ASIC_TO_L1_MASK 0x0000020000000000UL
-#define UVH_EVENT_OCCURRED0_L1_TO_ASIC_SHFT 42
-#define UVH_EVENT_OCCURRED0_L1_TO_ASIC_MASK 0x0000040000000000UL
-#define UVH_EVENT_OCCURRED0_LTC_INT_SHFT 43
-#define UVH_EVENT_OCCURRED0_LTC_INT_MASK 0x0000080000000000UL
-#define UVH_EVENT_OCCURRED0_LA_SEQ_TRIGGER_SHFT 44
-#define UVH_EVENT_OCCURRED0_LA_SEQ_TRIGGER_MASK 0x0000100000000000UL
-#define UVH_EVENT_OCCURRED0_IPI_INT_SHFT 45
-#define UVH_EVENT_OCCURRED0_IPI_INT_MASK 0x0000200000000000UL
-#define UVH_EVENT_OCCURRED0_EXTIO_INT0_SHFT 46
-#define UVH_EVENT_OCCURRED0_EXTIO_INT0_MASK 0x0000400000000000UL
-#define UVH_EVENT_OCCURRED0_EXTIO_INT1_SHFT 47
-#define UVH_EVENT_OCCURRED0_EXTIO_INT1_MASK 0x0000800000000000UL
-#define UVH_EVENT_OCCURRED0_EXTIO_INT2_SHFT 48
-#define UVH_EVENT_OCCURRED0_EXTIO_INT2_MASK 0x0001000000000000UL
-#define UVH_EVENT_OCCURRED0_EXTIO_INT3_SHFT 49
-#define UVH_EVENT_OCCURRED0_EXTIO_INT3_MASK 0x0002000000000000UL
-#define UVH_EVENT_OCCURRED0_PROFILE_INT_SHFT 50
-#define UVH_EVENT_OCCURRED0_PROFILE_INT_MASK 0x0004000000000000UL
-#define UVH_EVENT_OCCURRED0_RTC0_SHFT 51
-#define UVH_EVENT_OCCURRED0_RTC0_MASK 0x0008000000000000UL
-#define UVH_EVENT_OCCURRED0_RTC1_SHFT 52
-#define UVH_EVENT_OCCURRED0_RTC1_MASK 0x0010000000000000UL
-#define UVH_EVENT_OCCURRED0_RTC2_SHFT 53
-#define UVH_EVENT_OCCURRED0_RTC2_MASK 0x0020000000000000UL
-#define UVH_EVENT_OCCURRED0_RTC3_SHFT 54
-#define UVH_EVENT_OCCURRED0_RTC3_MASK 0x0040000000000000UL
-#define UVH_EVENT_OCCURRED0_BAU_DATA_SHFT 55
-#define UVH_EVENT_OCCURRED0_BAU_DATA_MASK 0x0080000000000000UL
-#define UVH_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_SHFT 56
-#define UVH_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_MASK 0x0100000000000000UL
+#define UVH_EVENT_OCCURRED0_32 0x5e8
+
+#define UV1H_EVENT_OCCURRED0_LB_HCERR_SHFT 0
+#define UV1H_EVENT_OCCURRED0_LB_HCERR_MASK 0x0000000000000001UL
+#define UV1H_EVENT_OCCURRED0_GR0_HCERR_SHFT 1
+#define UV1H_EVENT_OCCURRED0_GR0_HCERR_MASK 0x0000000000000002UL
+#define UV1H_EVENT_OCCURRED0_GR1_HCERR_SHFT 2
+#define UV1H_EVENT_OCCURRED0_GR1_HCERR_MASK 0x0000000000000004UL
+#define UV1H_EVENT_OCCURRED0_LH_HCERR_SHFT 3
+#define UV1H_EVENT_OCCURRED0_LH_HCERR_MASK 0x0000000000000008UL
+#define UV1H_EVENT_OCCURRED0_RH_HCERR_SHFT 4
+#define UV1H_EVENT_OCCURRED0_RH_HCERR_MASK 0x0000000000000010UL
+#define UV1H_EVENT_OCCURRED0_XN_HCERR_SHFT 5
+#define UV1H_EVENT_OCCURRED0_XN_HCERR_MASK 0x0000000000000020UL
+#define UV1H_EVENT_OCCURRED0_SI_HCERR_SHFT 6
+#define UV1H_EVENT_OCCURRED0_SI_HCERR_MASK 0x0000000000000040UL
+#define UV1H_EVENT_OCCURRED0_LB_AOERR0_SHFT 7
+#define UV1H_EVENT_OCCURRED0_LB_AOERR0_MASK 0x0000000000000080UL
+#define UV1H_EVENT_OCCURRED0_GR0_AOERR0_SHFT 8
+#define UV1H_EVENT_OCCURRED0_GR0_AOERR0_MASK 0x0000000000000100UL
+#define UV1H_EVENT_OCCURRED0_GR1_AOERR0_SHFT 9
+#define UV1H_EVENT_OCCURRED0_GR1_AOERR0_MASK 0x0000000000000200UL
+#define UV1H_EVENT_OCCURRED0_LH_AOERR0_SHFT 10
+#define UV1H_EVENT_OCCURRED0_LH_AOERR0_MASK 0x0000000000000400UL
+#define UV1H_EVENT_OCCURRED0_RH_AOERR0_SHFT 11
+#define UV1H_EVENT_OCCURRED0_RH_AOERR0_MASK 0x0000000000000800UL
+#define UV1H_EVENT_OCCURRED0_XN_AOERR0_SHFT 12
+#define UV1H_EVENT_OCCURRED0_XN_AOERR0_MASK 0x0000000000001000UL
+#define UV1H_EVENT_OCCURRED0_SI_AOERR0_SHFT 13
+#define UV1H_EVENT_OCCURRED0_SI_AOERR0_MASK 0x0000000000002000UL
+#define UV1H_EVENT_OCCURRED0_LB_AOERR1_SHFT 14
+#define UV1H_EVENT_OCCURRED0_LB_AOERR1_MASK 0x0000000000004000UL
+#define UV1H_EVENT_OCCURRED0_GR0_AOERR1_SHFT 15
+#define UV1H_EVENT_OCCURRED0_GR0_AOERR1_MASK 0x0000000000008000UL
+#define UV1H_EVENT_OCCURRED0_GR1_AOERR1_SHFT 16
+#define UV1H_EVENT_OCCURRED0_GR1_AOERR1_MASK 0x0000000000010000UL
+#define UV1H_EVENT_OCCURRED0_LH_AOERR1_SHFT 17
+#define UV1H_EVENT_OCCURRED0_LH_AOERR1_MASK 0x0000000000020000UL
+#define UV1H_EVENT_OCCURRED0_RH_AOERR1_SHFT 18
+#define UV1H_EVENT_OCCURRED0_RH_AOERR1_MASK 0x0000000000040000UL
+#define UV1H_EVENT_OCCURRED0_XN_AOERR1_SHFT 19
+#define UV1H_EVENT_OCCURRED0_XN_AOERR1_MASK 0x0000000000080000UL
+#define UV1H_EVENT_OCCURRED0_SI_AOERR1_SHFT 20
+#define UV1H_EVENT_OCCURRED0_SI_AOERR1_MASK 0x0000000000100000UL
+#define UV1H_EVENT_OCCURRED0_RH_VPI_INT_SHFT 21
+#define UV1H_EVENT_OCCURRED0_RH_VPI_INT_MASK 0x0000000000200000UL
+#define UV1H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_SHFT 22
+#define UV1H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_MASK 0x0000000000400000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_0_SHFT 23
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_0_MASK 0x0000000000800000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_1_SHFT 24
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_1_MASK 0x0000000001000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_2_SHFT 25
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_2_MASK 0x0000000002000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_3_SHFT 26
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_3_MASK 0x0000000004000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_4_SHFT 27
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_4_MASK 0x0000000008000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_5_SHFT 28
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_5_MASK 0x0000000010000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_6_SHFT 29
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_6_MASK 0x0000000020000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_7_SHFT 30
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_7_MASK 0x0000000040000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_8_SHFT 31
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_8_MASK 0x0000000080000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_9_SHFT 32
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_9_MASK 0x0000000100000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_10_SHFT 33
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_10_MASK 0x0000000200000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_11_SHFT 34
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_11_MASK 0x0000000400000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_12_SHFT 35
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_12_MASK 0x0000000800000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_13_SHFT 36
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_13_MASK 0x0000001000000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_14_SHFT 37
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_14_MASK 0x0000002000000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_15_SHFT 38
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_15_MASK 0x0000004000000000UL
+#define UV1H_EVENT_OCCURRED0_L1_NMI_INT_SHFT 39
+#define UV1H_EVENT_OCCURRED0_L1_NMI_INT_MASK 0x0000008000000000UL
+#define UV1H_EVENT_OCCURRED0_STOP_CLOCK_SHFT 40
+#define UV1H_EVENT_OCCURRED0_STOP_CLOCK_MASK 0x0000010000000000UL
+#define UV1H_EVENT_OCCURRED0_ASIC_TO_L1_SHFT 41
+#define UV1H_EVENT_OCCURRED0_ASIC_TO_L1_MASK 0x0000020000000000UL
+#define UV1H_EVENT_OCCURRED0_L1_TO_ASIC_SHFT 42
+#define UV1H_EVENT_OCCURRED0_L1_TO_ASIC_MASK 0x0000040000000000UL
+#define UV1H_EVENT_OCCURRED0_LTC_INT_SHFT 43
+#define UV1H_EVENT_OCCURRED0_LTC_INT_MASK 0x0000080000000000UL
+#define UV1H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_SHFT 44
+#define UV1H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_MASK 0x0000100000000000UL
+#define UV1H_EVENT_OCCURRED0_IPI_INT_SHFT 45
+#define UV1H_EVENT_OCCURRED0_IPI_INT_MASK 0x0000200000000000UL
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT0_SHFT 46
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT0_MASK 0x0000400000000000UL
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT1_SHFT 47
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT1_MASK 0x0000800000000000UL
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT2_SHFT 48
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT2_MASK 0x0001000000000000UL
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT3_SHFT 49
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT3_MASK 0x0002000000000000UL
+#define UV1H_EVENT_OCCURRED0_PROFILE_INT_SHFT 50
+#define UV1H_EVENT_OCCURRED0_PROFILE_INT_MASK 0x0004000000000000UL
+#define UV1H_EVENT_OCCURRED0_RTC0_SHFT 51
+#define UV1H_EVENT_OCCURRED0_RTC0_MASK 0x0008000000000000UL
+#define UV1H_EVENT_OCCURRED0_RTC1_SHFT 52
+#define UV1H_EVENT_OCCURRED0_RTC1_MASK 0x0010000000000000UL
+#define UV1H_EVENT_OCCURRED0_RTC2_SHFT 53
+#define UV1H_EVENT_OCCURRED0_RTC2_MASK 0x0020000000000000UL
+#define UV1H_EVENT_OCCURRED0_RTC3_SHFT 54
+#define UV1H_EVENT_OCCURRED0_RTC3_MASK 0x0040000000000000UL
+#define UV1H_EVENT_OCCURRED0_BAU_DATA_SHFT 55
+#define UV1H_EVENT_OCCURRED0_BAU_DATA_MASK 0x0080000000000000UL
+#define UV1H_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_SHFT 56
+#define UV1H_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_MASK 0x0100000000000000UL
+
+#define UV2H_EVENT_OCCURRED0_LB_HCERR_SHFT 0
+#define UV2H_EVENT_OCCURRED0_LB_HCERR_MASK 0x0000000000000001UL
+#define UV2H_EVENT_OCCURRED0_QP_HCERR_SHFT 1
+#define UV2H_EVENT_OCCURRED0_QP_HCERR_MASK 0x0000000000000002UL
+#define UV2H_EVENT_OCCURRED0_RH_HCERR_SHFT 2
+#define UV2H_EVENT_OCCURRED0_RH_HCERR_MASK 0x0000000000000004UL
+#define UV2H_EVENT_OCCURRED0_LH0_HCERR_SHFT 3
+#define UV2H_EVENT_OCCURRED0_LH0_HCERR_MASK 0x0000000000000008UL
+#define UV2H_EVENT_OCCURRED0_LH1_HCERR_SHFT 4
+#define UV2H_EVENT_OCCURRED0_LH1_HCERR_MASK 0x0000000000000010UL
+#define UV2H_EVENT_OCCURRED0_GR0_HCERR_SHFT 5
+#define UV2H_EVENT_OCCURRED0_GR0_HCERR_MASK 0x0000000000000020UL
+#define UV2H_EVENT_OCCURRED0_GR1_HCERR_SHFT 6
+#define UV2H_EVENT_OCCURRED0_GR1_HCERR_MASK 0x0000000000000040UL
+#define UV2H_EVENT_OCCURRED0_NI0_HCERR_SHFT 7
+#define UV2H_EVENT_OCCURRED0_NI0_HCERR_MASK 0x0000000000000080UL
+#define UV2H_EVENT_OCCURRED0_NI1_HCERR_SHFT 8
+#define UV2H_EVENT_OCCURRED0_NI1_HCERR_MASK 0x0000000000000100UL
+#define UV2H_EVENT_OCCURRED0_LB_AOERR0_SHFT 9
+#define UV2H_EVENT_OCCURRED0_LB_AOERR0_MASK 0x0000000000000200UL
+#define UV2H_EVENT_OCCURRED0_QP_AOERR0_SHFT 10
+#define UV2H_EVENT_OCCURRED0_QP_AOERR0_MASK 0x0000000000000400UL
+#define UV2H_EVENT_OCCURRED0_RH_AOERR0_SHFT 11
+#define UV2H_EVENT_OCCURRED0_RH_AOERR0_MASK 0x0000000000000800UL
+#define UV2H_EVENT_OCCURRED0_LH0_AOERR0_SHFT 12
+#define UV2H_EVENT_OCCURRED0_LH0_AOERR0_MASK 0x0000000000001000UL
+#define UV2H_EVENT_OCCURRED0_LH1_AOERR0_SHFT 13
+#define UV2H_EVENT_OCCURRED0_LH1_AOERR0_MASK 0x0000000000002000UL
+#define UV2H_EVENT_OCCURRED0_GR0_AOERR0_SHFT 14
+#define UV2H_EVENT_OCCURRED0_GR0_AOERR0_MASK 0x0000000000004000UL
+#define UV2H_EVENT_OCCURRED0_GR1_AOERR0_SHFT 15
+#define UV2H_EVENT_OCCURRED0_GR1_AOERR0_MASK 0x0000000000008000UL
+#define UV2H_EVENT_OCCURRED0_XB_AOERR0_SHFT 16
+#define UV2H_EVENT_OCCURRED0_XB_AOERR0_MASK 0x0000000000010000UL
+#define UV2H_EVENT_OCCURRED0_RT_AOERR0_SHFT 17
+#define UV2H_EVENT_OCCURRED0_RT_AOERR0_MASK 0x0000000000020000UL
+#define UV2H_EVENT_OCCURRED0_NI0_AOERR0_SHFT 18
+#define UV2H_EVENT_OCCURRED0_NI0_AOERR0_MASK 0x0000000000040000UL
+#define UV2H_EVENT_OCCURRED0_NI1_AOERR0_SHFT 19
+#define UV2H_EVENT_OCCURRED0_NI1_AOERR0_MASK 0x0000000000080000UL
+#define UV2H_EVENT_OCCURRED0_LB_AOERR1_SHFT 20
+#define UV2H_EVENT_OCCURRED0_LB_AOERR1_MASK 0x0000000000100000UL
+#define UV2H_EVENT_OCCURRED0_QP_AOERR1_SHFT 21
+#define UV2H_EVENT_OCCURRED0_QP_AOERR1_MASK 0x0000000000200000UL
+#define UV2H_EVENT_OCCURRED0_RH_AOERR1_SHFT 22
+#define UV2H_EVENT_OCCURRED0_RH_AOERR1_MASK 0x0000000000400000UL
+#define UV2H_EVENT_OCCURRED0_LH0_AOERR1_SHFT 23
+#define UV2H_EVENT_OCCURRED0_LH0_AOERR1_MASK 0x0000000000800000UL
+#define UV2H_EVENT_OCCURRED0_LH1_AOERR1_SHFT 24
+#define UV2H_EVENT_OCCURRED0_LH1_AOERR1_MASK 0x0000000001000000UL
+#define UV2H_EVENT_OCCURRED0_GR0_AOERR1_SHFT 25
+#define UV2H_EVENT_OCCURRED0_GR0_AOERR1_MASK 0x0000000002000000UL
+#define UV2H_EVENT_OCCURRED0_GR1_AOERR1_SHFT 26
+#define UV2H_EVENT_OCCURRED0_GR1_AOERR1_MASK 0x0000000004000000UL
+#define UV2H_EVENT_OCCURRED0_XB_AOERR1_SHFT 27
+#define UV2H_EVENT_OCCURRED0_XB_AOERR1_MASK 0x0000000008000000UL
+#define UV2H_EVENT_OCCURRED0_RT_AOERR1_SHFT 28
+#define UV2H_EVENT_OCCURRED0_RT_AOERR1_MASK 0x0000000010000000UL
+#define UV2H_EVENT_OCCURRED0_NI0_AOERR1_SHFT 29
+#define UV2H_EVENT_OCCURRED0_NI0_AOERR1_MASK 0x0000000020000000UL
+#define UV2H_EVENT_OCCURRED0_NI1_AOERR1_SHFT 30
+#define UV2H_EVENT_OCCURRED0_NI1_AOERR1_MASK 0x0000000040000000UL
+#define UV2H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_SHFT 31
+#define UV2H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_MASK 0x0000000080000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_0_SHFT 32
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_0_MASK 0x0000000100000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_1_SHFT 33
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_1_MASK 0x0000000200000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_2_SHFT 34
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_2_MASK 0x0000000400000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_3_SHFT 35
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_3_MASK 0x0000000800000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_4_SHFT 36
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_4_MASK 0x0000001000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_5_SHFT 37
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_5_MASK 0x0000002000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_6_SHFT 38
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_6_MASK 0x0000004000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_7_SHFT 39
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_7_MASK 0x0000008000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_8_SHFT 40
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_8_MASK 0x0000010000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_9_SHFT 41
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_9_MASK 0x0000020000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_10_SHFT 42
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_10_MASK 0x0000040000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_11_SHFT 43
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_11_MASK 0x0000080000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_12_SHFT 44
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_12_MASK 0x0000100000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_13_SHFT 45
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_13_MASK 0x0000200000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_14_SHFT 46
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_14_MASK 0x0000400000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_15_SHFT 47
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_15_MASK 0x0000800000000000UL
+#define UV2H_EVENT_OCCURRED0_L1_NMI_INT_SHFT 48
+#define UV2H_EVENT_OCCURRED0_L1_NMI_INT_MASK 0x0001000000000000UL
+#define UV2H_EVENT_OCCURRED0_STOP_CLOCK_SHFT 49
+#define UV2H_EVENT_OCCURRED0_STOP_CLOCK_MASK 0x0002000000000000UL
+#define UV2H_EVENT_OCCURRED0_ASIC_TO_L1_SHFT 50
+#define UV2H_EVENT_OCCURRED0_ASIC_TO_L1_MASK 0x0004000000000000UL
+#define UV2H_EVENT_OCCURRED0_L1_TO_ASIC_SHFT 51
+#define UV2H_EVENT_OCCURRED0_L1_TO_ASIC_MASK 0x0008000000000000UL
+#define UV2H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_SHFT 52
+#define UV2H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_MASK 0x0010000000000000UL
+#define UV2H_EVENT_OCCURRED0_IPI_INT_SHFT 53
+#define UV2H_EVENT_OCCURRED0_IPI_INT_MASK 0x0020000000000000UL
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT0_SHFT 54
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT0_MASK 0x0040000000000000UL
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT1_SHFT 55
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT1_MASK 0x0080000000000000UL
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT2_SHFT 56
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT2_MASK 0x0100000000000000UL
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT3_SHFT 57
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT3_MASK 0x0200000000000000UL
+#define UV2H_EVENT_OCCURRED0_PROFILE_INT_SHFT 58
+#define UV2H_EVENT_OCCURRED0_PROFILE_INT_MASK 0x0400000000000000UL
+
 union uvh_event_occurred0_u {
     unsigned long	v;
-    struct uvh_event_occurred0_s {
+    struct uv1h_event_occurred0_s {
 	unsigned long	lb_hcerr             :  1;  /* RW, W1C */
 	unsigned long	gr0_hcerr            :  1;  /* RW, W1C */
 	unsigned long	gr1_hcerr            :  1;  /* RW, W1C */
@@ -250,14 +421,76 @@ union uvh_event_occurred0_u {
 	unsigned long	bau_data             :  1;  /* RW, W1C */
 	unsigned long	power_management_req :  1;  /* RW, W1C */
 	unsigned long	rsvd_57_63           :  7;  /*    */
-    } s;
+    } s1;
+    struct uv2h_event_occurred0_s {
+	unsigned long	lb_hcerr            :  1;  /* RW */
+	unsigned long	qp_hcerr            :  1;  /* RW */
+	unsigned long	rh_hcerr            :  1;  /* RW */
+	unsigned long	lh0_hcerr           :  1;  /* RW */
+	unsigned long	lh1_hcerr           :  1;  /* RW */
+	unsigned long	gr0_hcerr           :  1;  /* RW */
+	unsigned long	gr1_hcerr           :  1;  /* RW */
+	unsigned long	ni0_hcerr           :  1;  /* RW */
+	unsigned long	ni1_hcerr           :  1;  /* RW */
+	unsigned long	lb_aoerr0           :  1;  /* RW */
+	unsigned long	qp_aoerr0           :  1;  /* RW */
+	unsigned long	rh_aoerr0           :  1;  /* RW */
+	unsigned long	lh0_aoerr0          :  1;  /* RW */
+	unsigned long	lh1_aoerr0          :  1;  /* RW */
+	unsigned long	gr0_aoerr0          :  1;  /* RW */
+	unsigned long	gr1_aoerr0          :  1;  /* RW */
+	unsigned long	xb_aoerr0           :  1;  /* RW */
+	unsigned long	rt_aoerr0           :  1;  /* RW */
+	unsigned long	ni0_aoerr0          :  1;  /* RW */
+	unsigned long	ni1_aoerr0          :  1;  /* RW */
+	unsigned long	lb_aoerr1           :  1;  /* RW */
+	unsigned long	qp_aoerr1           :  1;  /* RW */
+	unsigned long	rh_aoerr1           :  1;  /* RW */
+	unsigned long	lh0_aoerr1          :  1;  /* RW */
+	unsigned long	lh1_aoerr1          :  1;  /* RW */
+	unsigned long	gr0_aoerr1          :  1;  /* RW */
+	unsigned long	gr1_aoerr1          :  1;  /* RW */
+	unsigned long	xb_aoerr1           :  1;  /* RW */
+	unsigned long	rt_aoerr1           :  1;  /* RW */
+	unsigned long	ni0_aoerr1          :  1;  /* RW */
+	unsigned long	ni1_aoerr1          :  1;  /* RW */
+	unsigned long	system_shutdown_int :  1;  /* RW */
+	unsigned long	lb_irq_int_0        :  1;  /* RW */
+	unsigned long	lb_irq_int_1        :  1;  /* RW */
+	unsigned long	lb_irq_int_2        :  1;  /* RW */
+	unsigned long	lb_irq_int_3        :  1;  /* RW */
+	unsigned long	lb_irq_int_4        :  1;  /* RW */
+	unsigned long	lb_irq_int_5        :  1;  /* RW */
+	unsigned long	lb_irq_int_6        :  1;  /* RW */
+	unsigned long	lb_irq_int_7        :  1;  /* RW */
+	unsigned long	lb_irq_int_8        :  1;  /* RW */
+	unsigned long	lb_irq_int_9        :  1;  /* RW */
+	unsigned long	lb_irq_int_10       :  1;  /* RW */
+	unsigned long	lb_irq_int_11       :  1;  /* RW */
+	unsigned long	lb_irq_int_12       :  1;  /* RW */
+	unsigned long	lb_irq_int_13       :  1;  /* RW */
+	unsigned long	lb_irq_int_14       :  1;  /* RW */
+	unsigned long	lb_irq_int_15       :  1;  /* RW */
+	unsigned long	l1_nmi_int          :  1;  /* RW */
+	unsigned long	stop_clock          :  1;  /* RW */
+	unsigned long	asic_to_l1          :  1;  /* RW */
+	unsigned long	l1_to_asic          :  1;  /* RW */
+	unsigned long	la_seq_trigger      :  1;  /* RW */
+	unsigned long	ipi_int             :  1;  /* RW */
+	unsigned long	extio_int0          :  1;  /* RW */
+	unsigned long	extio_int1          :  1;  /* RW */
+	unsigned long	extio_int2          :  1;  /* RW */
+	unsigned long	extio_int3          :  1;  /* RW */
+	unsigned long	profile_int         :  1;  /* RW */
+	unsigned long	rsvd_59_63          :  5;  /*    */
+    } s2;
 };
 
 /* ========================================================================= */
 /*                        UVH_EVENT_OCCURRED0_ALIAS                          */
 /* ========================================================================= */
 #define UVH_EVENT_OCCURRED0_ALIAS 0x0000000000070008UL
-#define UVH_EVENT_OCCURRED0_ALIAS_32 0x005f0
+#define UVH_EVENT_OCCURRED0_ALIAS_32 0x5f0
 
 /* ========================================================================= */
 /*                         UVH_GR0_TLB_INT0_CONFIG                           */
@@ -432,8 +665,16 @@ union uvh_int_cmpb_u {
 /* ========================================================================= */
 #define UVH_INT_CMPC 0x22100UL
 
-#define UVH_INT_CMPC_REAL_TIME_CMPC_SHFT 0
-#define UVH_INT_CMPC_REAL_TIME_CMPC_MASK 0x00ffffffffffffffUL
+#define UV1H_INT_CMPC_REAL_TIME_CMPC_SHFT	0
+#define UV2H_INT_CMPC_REAL_TIME_CMPC_SHFT	0
+#define UVH_INT_CMPC_REAL_TIME_CMPC_SHFT	(is_uv1_hub() ?		\
+			UV1H_INT_CMPC_REAL_TIME_CMPC_SHFT :	\
+			UV2H_INT_CMPC_REAL_TIME_CMPC_SHFT)
+#define UV1H_INT_CMPC_REAL_TIME_CMPC_MASK	0xffffffffffffffUL
+#define UV2H_INT_CMPC_REAL_TIME_CMPC_MASK	0xffffffffffffffUL
+#define UVH_INT_CMPC_REAL_TIME_CMPC_MASK	(is_uv1_hub() ?		\
+			UV1H_INT_CMPC_REAL_TIME_CMPC_MASK :	\
+			UV2H_INT_CMPC_REAL_TIME_CMPC_MASK)
 
 union uvh_int_cmpc_u {
     unsigned long	v;
@@ -448,8 +689,16 @@ union uvh_int_cmpc_u {
 /* ========================================================================= */
 #define UVH_INT_CMPD 0x22180UL
 
-#define UVH_INT_CMPD_REAL_TIME_CMPD_SHFT 0
-#define UVH_INT_CMPD_REAL_TIME_CMPD_MASK 0x00ffffffffffffffUL
+#define UV1H_INT_CMPD_REAL_TIME_CMPD_SHFT	0
+#define UV2H_INT_CMPD_REAL_TIME_CMPD_SHFT	0
+#define UVH_INT_CMPD_REAL_TIME_CMPD_SHFT	(is_uv1_hub() ?		\
+			UV1H_INT_CMPD_REAL_TIME_CMPD_SHFT :	\
+			UV2H_INT_CMPD_REAL_TIME_CMPD_SHFT)
+#define UV1H_INT_CMPD_REAL_TIME_CMPD_MASK	0xffffffffffffffUL
+#define UV2H_INT_CMPD_REAL_TIME_CMPD_MASK	0xffffffffffffffUL
+#define UVH_INT_CMPD_REAL_TIME_CMPD_MASK	(is_uv1_hub() ?		\
+			UV1H_INT_CMPD_REAL_TIME_CMPD_MASK :	\
+			UV2H_INT_CMPD_REAL_TIME_CMPD_MASK)
 
 union uvh_int_cmpd_u {
     unsigned long	v;
@@ -463,7 +712,7 @@ union uvh_int_cmpd_u {
 /*                               UVH_IPI_INT                                 */
 /* ========================================================================= */
 #define UVH_IPI_INT 0x60500UL
-#define UVH_IPI_INT_32 0x0348
+#define UVH_IPI_INT_32 0x348
 
 #define UVH_IPI_INT_VECTOR_SHFT 0
 #define UVH_IPI_INT_VECTOR_MASK 0x00000000000000ffUL
@@ -493,7 +742,7 @@ union uvh_ipi_int_u {
 /*                   UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST                     */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST 0x320050UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_32 0x009c0
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_32 0x9c0
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_ADDRESS_MASK 0x000007fffffffff0UL
@@ -515,7 +764,7 @@ union uvh_lb_bau_intd_payload_queue_first_u {
 /*                    UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST                     */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST 0x320060UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_32 0x009c8
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_32 0x9c8
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_ADDRESS_MASK 0x000007fffffffff0UL
@@ -533,7 +782,7 @@ union uvh_lb_bau_intd_payload_queue_last_u {
 /*                    UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL                     */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL 0x320070UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_32 0x009d0
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_32 0x9d0
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_ADDRESS_MASK 0x000007fffffffff0UL
@@ -551,7 +800,7 @@ union uvh_lb_bau_intd_payload_queue_tail_u {
 /*                   UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE                    */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE 0x320080UL
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_32 0x0a68
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_32 0xa68
 
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_0_SHFT 0
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_0_MASK 0x0000000000000001UL
@@ -585,6 +834,7 @@ union uvh_lb_bau_intd_payload_queue_tail_u {
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_TIMEOUT_6_MASK 0x0000000000004000UL
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_TIMEOUT_7_SHFT 15
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_TIMEOUT_7_MASK 0x0000000000008000UL
+
 union uvh_lb_bau_intd_software_acknowledge_u {
     unsigned long	v;
     struct uvh_lb_bau_intd_software_acknowledge_s {
@@ -612,13 +862,13 @@ union uvh_lb_bau_intd_software_acknowledge_u {
 /*                UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS                 */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS 0x0000000000320088UL
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32 0x0a70
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32 0xa70
 
 /* ========================================================================= */
 /*                         UVH_LB_BAU_MISC_CONTROL                           */
 /* ========================================================================= */
 #define UVH_LB_BAU_MISC_CONTROL 0x320170UL
-#define UVH_LB_BAU_MISC_CONTROL_32 0x00a10
+#define UVH_LB_BAU_MISC_CONTROL_32 0xa10
 
 #define UVH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT 0
 #define UVH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK 0x00000000000000ffUL
@@ -628,8 +878,8 @@ union uvh_lb_bau_intd_software_acknowledge_u {
 #define UVH_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK 0x0000000000000200UL
 #define UVH_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_SHFT 10
 #define UVH_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_MASK 0x0000000000000400UL
-#define UVH_LB_BAU_MISC_CONTROL_CSI_AGENT_PRESENCE_VECTOR_SHFT 11
-#define UVH_LB_BAU_MISC_CONTROL_CSI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
+#define UVH_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_SHFT 11
+#define UVH_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
 #define UVH_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_SHFT 14
 #define UVH_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_MASK 0x0000000000004000UL
 #define UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT 15
@@ -650,8 +900,86 @@ union uvh_lb_bau_intd_software_acknowledge_u {
 #define UVH_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
 #define UVH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
 #define UVH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
-#define UVH_LB_BAU_MISC_CONTROL_FUN_SHFT 48
-#define UVH_LB_BAU_MISC_CONTROL_FUN_MASK 0xffff000000000000UL
+
+#define UV1H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT 0
+#define UV1H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK 0x00000000000000ffUL
+#define UV1H_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT 8
+#define UV1H_LB_BAU_MISC_CONTROL_APIC_MODE_MASK 0x0000000000000100UL
+#define UV1H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_SHFT 9
+#define UV1H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK 0x0000000000000200UL
+#define UV1H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_SHFT 10
+#define UV1H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_MASK 0x0000000000000400UL
+#define UV1H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_SHFT 11
+#define UV1H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
+#define UV1H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_SHFT 14
+#define UV1H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_MASK 0x0000000000004000UL
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT 15
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_MASK 0x0000000000008000UL
+#define UV1H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT 16
+#define UV1H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_MASK 0x00000000000f0000UL
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_SHFT 20
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_MASK 0x0000000000100000UL
+#define UV1H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_SHFT 21
+#define UV1H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_MASK 0x0000000000200000UL
+#define UV1H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_SHFT 22
+#define UV1H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_MASK 0x0000000000400000UL
+#define UV1H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_SHFT 23
+#define UV1H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_MASK 0x0000000000800000UL
+#define UV1H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_SHFT 24
+#define UV1H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000007000000UL
+#define UV1H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_SHFT 27
+#define UV1H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
+#define UV1H_LB_BAU_MISC_CONTROL_FUN_SHFT 48
+#define UV1H_LB_BAU_MISC_CONTROL_FUN_MASK 0xffff000000000000UL
+
+#define UV2H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT 0
+#define UV2H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK 0x00000000000000ffUL
+#define UV2H_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT 8
+#define UV2H_LB_BAU_MISC_CONTROL_APIC_MODE_MASK 0x0000000000000100UL
+#define UV2H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_SHFT 9
+#define UV2H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK 0x0000000000000200UL
+#define UV2H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_SHFT 10
+#define UV2H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_MASK 0x0000000000000400UL
+#define UV2H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_SHFT 11
+#define UV2H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
+#define UV2H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_SHFT 14
+#define UV2H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_MASK 0x0000000000004000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT 15
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_MASK 0x0000000000008000UL
+#define UV2H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT 16
+#define UV2H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_MASK 0x00000000000f0000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_SHFT 20
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_MASK 0x0000000000100000UL
+#define UV2H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_SHFT 21
+#define UV2H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_MASK 0x0000000000200000UL
+#define UV2H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_SHFT 22
+#define UV2H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_MASK 0x0000000000400000UL
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_SHFT 23
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_MASK 0x0000000000800000UL
+#define UV2H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_SHFT 24
+#define UV2H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000007000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_SHFT 27
+#define UV2H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_AUTOMATIC_APIC_MODE_SELECTION_SHFT 29
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_AUTOMATIC_APIC_MODE_SELECTION_MASK 0x0000000020000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_APIC_MODE_STATUS_SHFT 30
+#define UV2H_LB_BAU_MISC_CONTROL_APIC_MODE_STATUS_MASK 0x0000000040000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_INTERRUPTS_TO_SELF_SHFT 31
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_INTERRUPTS_TO_SELF_MASK 0x0000000080000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_LOCK_BASED_SYSTEM_FLUSH_SHFT 32
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_LOCK_BASED_SYSTEM_FLUSH_MASK 0x0000000100000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT 33
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_MASK 0x0000000200000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_INT_PRIO_UDT_TO_SELF_SHFT 34
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_INT_PRIO_UDT_TO_SELF_MASK 0x0000000400000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT 35
+#define UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_MASK 0x0000000800000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_FUN_SHFT 48
+#define UV2H_LB_BAU_MISC_CONTROL_FUN_MASK 0xffff000000000000UL
 
 union uvh_lb_bau_misc_control_u {
     unsigned long	v;
@@ -660,7 +988,25 @@ union uvh_lb_bau_misc_control_u {
 	unsigned long	apic_mode                          :  1;  /* RW */
 	unsigned long	force_broadcast                    :  1;  /* RW */
 	unsigned long	force_lock_nop                     :  1;  /* RW */
-	unsigned long	csi_agent_presence_vector          :  3;  /* RW */
+	unsigned long	qpi_agent_presence_vector          :  3;  /* RW */
+	unsigned long	descriptor_fetch_mode              :  1;  /* RW */
+	unsigned long	enable_intd_soft_ack_mode          :  1;  /* RW */
+	unsigned long	intd_soft_ack_timeout_period       :  4;  /* RW */
+	unsigned long	enable_dual_mapping_mode           :  1;  /* RW */
+	unsigned long	vga_io_port_decode_enable          :  1;  /* RW */
+	unsigned long	vga_io_port_16_bit_decode          :  1;  /* RW */
+	unsigned long	suppress_dest_registration         :  1;  /* RW */
+	unsigned long	programmed_initial_priority        :  3;  /* RW */
+	unsigned long	use_incoming_priority              :  1;  /* RW */
+	unsigned long	enable_programmed_initial_priority :  1;  /* RW */
+	unsigned long	rsvd_29_63    : 35;
+    } s;
+    struct uv1h_lb_bau_misc_control_s {
+	unsigned long	rejection_delay                    :  8;  /* RW */
+	unsigned long	apic_mode                          :  1;  /* RW */
+	unsigned long	force_broadcast                    :  1;  /* RW */
+	unsigned long	force_lock_nop                     :  1;  /* RW */
+	unsigned long	qpi_agent_presence_vector          :  3;  /* RW */
 	unsigned long	descriptor_fetch_mode              :  1;  /* RW */
 	unsigned long	enable_intd_soft_ack_mode          :  1;  /* RW */
 	unsigned long	intd_soft_ack_timeout_period       :  4;  /* RW */
@@ -673,14 +1019,40 @@ union uvh_lb_bau_misc_control_u {
 	unsigned long	enable_programmed_initial_priority :  1;  /* RW */
 	unsigned long	rsvd_29_47                         : 19;  /*    */
 	unsigned long	fun                                : 16;  /* RW */
-    } s;
+    } s1;
+    struct uv2h_lb_bau_misc_control_s {
+	unsigned long	rejection_delay                      :  8;  /* RW */
+	unsigned long	apic_mode                            :  1;  /* RW */
+	unsigned long	force_broadcast                      :  1;  /* RW */
+	unsigned long	force_lock_nop                       :  1;  /* RW */
+	unsigned long	qpi_agent_presence_vector            :  3;  /* RW */
+	unsigned long	descriptor_fetch_mode                :  1;  /* RW */
+	unsigned long	enable_intd_soft_ack_mode            :  1;  /* RW */
+	unsigned long	intd_soft_ack_timeout_period         :  4;  /* RW */
+	unsigned long	enable_dual_mapping_mode             :  1;  /* RW */
+	unsigned long	vga_io_port_decode_enable            :  1;  /* RW */
+	unsigned long	vga_io_port_16_bit_decode            :  1;  /* RW */
+	unsigned long	suppress_dest_registration           :  1;  /* RW */
+	unsigned long	programmed_initial_priority          :  3;  /* RW */
+	unsigned long	use_incoming_priority                :  1;  /* RW */
+	unsigned long	enable_programmed_initial_priority   :  1;  /* RW */
+	unsigned long	enable_automatic_apic_mode_selection :  1;  /* RW */
+	unsigned long	apic_mode_status                     :  1;  /* RO */
+	unsigned long	suppress_interrupts_to_self          :  1;  /* RW */
+	unsigned long	enable_lock_based_system_flush       :  1;  /* RW */
+	unsigned long	enable_extended_sb_status            :  1;  /* RW */
+	unsigned long	suppress_int_prio_udt_to_self        :  1;  /* RW */
+	unsigned long	use_legacy_descriptor_formats        :  1;  /* RW */
+	unsigned long	rsvd_36_47                           : 12;  /*    */
+	unsigned long	fun                                  : 16;  /* RW */
+    } s2;
 };
 
 /* ========================================================================= */
 /*                     UVH_LB_BAU_SB_ACTIVATION_CONTROL                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL 0x320020UL
-#define UVH_LB_BAU_SB_ACTIVATION_CONTROL_32 0x009a8
+#define UVH_LB_BAU_SB_ACTIVATION_CONTROL_32 0x9a8
 
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL_INDEX_SHFT 0
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL_INDEX_MASK 0x000000000000003fUL
@@ -703,7 +1075,7 @@ union uvh_lb_bau_sb_activation_control_u {
 /*                    UVH_LB_BAU_SB_ACTIVATION_STATUS_0                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0 0x320030UL
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_32 0x009b0
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_32 0x9b0
 
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_STATUS_SHFT 0
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_STATUS_MASK 0xffffffffffffffffUL
@@ -719,7 +1091,7 @@ union uvh_lb_bau_sb_activation_status_0_u {
 /*                    UVH_LB_BAU_SB_ACTIVATION_STATUS_1                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1 0x320040UL
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_32 0x009b8
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_32 0x9b8
 
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_STATUS_SHFT 0
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_STATUS_MASK 0xffffffffffffffffUL
@@ -735,7 +1107,7 @@ union uvh_lb_bau_sb_activation_status_1_u {
 /*                      UVH_LB_BAU_SB_DESCRIPTOR_BASE                        */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE 0x320010UL
-#define UVH_LB_BAU_SB_DESCRIPTOR_BASE_32 0x009a0
+#define UVH_LB_BAU_SB_DESCRIPTOR_BASE_32 0x9a0
 
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE_PAGE_ADDRESS_SHFT 12
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE_PAGE_ADDRESS_MASK 0x000007fffffff000UL
@@ -754,23 +1126,6 @@ union uvh_lb_bau_sb_descriptor_base_u {
 };
 
 /* ========================================================================= */
-/*                   UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK                     */
-/* ========================================================================= */
-#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK 0x320130UL
-#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_32 0x009f0
-
-#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_SHFT 0
-#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_MASK 0x00000000ffffffffUL
-
-union uvh_lb_target_physical_apic_id_mask_u {
-	unsigned long v;
-	struct uvh_lb_target_physical_apic_id_mask_s {
-		unsigned long bit_enables : 32;  /* RW */
-		unsigned long rsvd_32_63  : 32;  /*    */
-	} s;
-};
-
-/* ========================================================================= */
 /*                               UVH_NODE_ID                                 */
 /* ========================================================================= */
 #define UVH_NODE_ID 0x0UL
@@ -785,10 +1140,36 @@ union uvh_lb_target_physical_apic_id_mask_u {
 #define UVH_NODE_ID_REVISION_MASK 0x00000000f0000000UL
 #define UVH_NODE_ID_NODE_ID_SHFT 32
 #define UVH_NODE_ID_NODE_ID_MASK 0x00007fff00000000UL
-#define UVH_NODE_ID_NODES_PER_BIT_SHFT 48
-#define UVH_NODE_ID_NODES_PER_BIT_MASK 0x007f000000000000UL
-#define UVH_NODE_ID_NI_PORT_SHFT 56
-#define UVH_NODE_ID_NI_PORT_MASK 0x0f00000000000000UL
+
+#define UV1H_NODE_ID_FORCE1_SHFT 0
+#define UV1H_NODE_ID_FORCE1_MASK 0x0000000000000001UL
+#define UV1H_NODE_ID_MANUFACTURER_SHFT 1
+#define UV1H_NODE_ID_MANUFACTURER_MASK 0x0000000000000ffeUL
+#define UV1H_NODE_ID_PART_NUMBER_SHFT 12
+#define UV1H_NODE_ID_PART_NUMBER_MASK 0x000000000ffff000UL
+#define UV1H_NODE_ID_REVISION_SHFT 28
+#define UV1H_NODE_ID_REVISION_MASK 0x00000000f0000000UL
+#define UV1H_NODE_ID_NODE_ID_SHFT 32
+#define UV1H_NODE_ID_NODE_ID_MASK 0x00007fff00000000UL
+#define UV1H_NODE_ID_NODES_PER_BIT_SHFT 48
+#define UV1H_NODE_ID_NODES_PER_BIT_MASK 0x007f000000000000UL
+#define UV1H_NODE_ID_NI_PORT_SHFT 56
+#define UV1H_NODE_ID_NI_PORT_MASK 0x0f00000000000000UL
+
+#define UV2H_NODE_ID_FORCE1_SHFT 0
+#define UV2H_NODE_ID_FORCE1_MASK 0x0000000000000001UL
+#define UV2H_NODE_ID_MANUFACTURER_SHFT 1
+#define UV2H_NODE_ID_MANUFACTURER_MASK 0x0000000000000ffeUL
+#define UV2H_NODE_ID_PART_NUMBER_SHFT 12
+#define UV2H_NODE_ID_PART_NUMBER_MASK 0x000000000ffff000UL
+#define UV2H_NODE_ID_REVISION_SHFT 28
+#define UV2H_NODE_ID_REVISION_MASK 0x00000000f0000000UL
+#define UV2H_NODE_ID_NODE_ID_SHFT 32
+#define UV2H_NODE_ID_NODE_ID_MASK 0x00007fff00000000UL
+#define UV2H_NODE_ID_NODES_PER_BIT_SHFT 50
+#define UV2H_NODE_ID_NODES_PER_BIT_MASK 0x01fc000000000000UL
+#define UV2H_NODE_ID_NI_PORT_SHFT 57
+#define UV2H_NODE_ID_NI_PORT_MASK 0x3e00000000000000UL
 
 union uvh_node_id_u {
     unsigned long	v;
@@ -798,12 +1179,31 @@ union uvh_node_id_u {
 	unsigned long	part_number   : 16;  /* RO */
 	unsigned long	revision      :  4;  /* RO */
 	unsigned long	node_id       : 15;  /* RW */
+	unsigned long	rsvd_47_63    : 17;
+    } s;
+    struct uv1h_node_id_s {
+	unsigned long	force1        :  1;  /* RO */
+	unsigned long	manufacturer  : 11;  /* RO */
+	unsigned long	part_number   : 16;  /* RO */
+	unsigned long	revision      :  4;  /* RO */
+	unsigned long	node_id       : 15;  /* RW */
 	unsigned long	rsvd_47       :  1;  /*    */
 	unsigned long	nodes_per_bit :  7;  /* RW */
 	unsigned long	rsvd_55       :  1;  /*    */
 	unsigned long	ni_port       :  4;  /* RO */
 	unsigned long	rsvd_60_63    :  4;  /*    */
-    } s;
+    } s1;
+    struct uv2h_node_id_s {
+	unsigned long	force1        :  1;  /* RO */
+	unsigned long	manufacturer  : 11;  /* RO */
+	unsigned long	part_number   : 16;  /* RO */
+	unsigned long	revision      :  4;  /* RO */
+	unsigned long	node_id       : 15;  /* RW */
+	unsigned long	rsvd_47_49    :  3;  /*    */
+	unsigned long	nodes_per_bit :  7;  /* RO */
+	unsigned long	ni_port       :  5;  /* RO */
+	unsigned long	rsvd_62_63    :  2;  /*    */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -954,18 +1354,38 @@ union uvh_rh_gam_alias210_redirect_config_2_mmr_u {
 #define UVH_RH_GAM_CONFIG_MMR_M_SKT_MASK 0x000000000000003fUL
 #define UVH_RH_GAM_CONFIG_MMR_N_SKT_SHFT 6
 #define UVH_RH_GAM_CONFIG_MMR_N_SKT_MASK 0x00000000000003c0UL
-#define UVH_RH_GAM_CONFIG_MMR_MMIOL_CFG_SHFT 12
-#define UVH_RH_GAM_CONFIG_MMR_MMIOL_CFG_MASK 0x0000000000001000UL
+
+#define UV1H_RH_GAM_CONFIG_MMR_M_SKT_SHFT 0
+#define UV1H_RH_GAM_CONFIG_MMR_M_SKT_MASK 0x000000000000003fUL
+#define UV1H_RH_GAM_CONFIG_MMR_N_SKT_SHFT 6
+#define UV1H_RH_GAM_CONFIG_MMR_N_SKT_MASK 0x00000000000003c0UL
+#define UV1H_RH_GAM_CONFIG_MMR_MMIOL_CFG_SHFT 12
+#define UV1H_RH_GAM_CONFIG_MMR_MMIOL_CFG_MASK 0x0000000000001000UL
+
+#define UV2H_RH_GAM_CONFIG_MMR_M_SKT_SHFT 0
+#define UV2H_RH_GAM_CONFIG_MMR_M_SKT_MASK 0x000000000000003fUL
+#define UV2H_RH_GAM_CONFIG_MMR_N_SKT_SHFT 6
+#define UV2H_RH_GAM_CONFIG_MMR_N_SKT_MASK 0x00000000000003c0UL
 
 union uvh_rh_gam_config_mmr_u {
     unsigned long	v;
     struct uvh_rh_gam_config_mmr_s {
 	unsigned long	m_skt     :  6;  /* RW */
 	unsigned long	n_skt     :  4;  /* RW */
+	unsigned long	rsvd_10_63    : 54;
+    } s;
+    struct uv1h_rh_gam_config_mmr_s {
+	unsigned long	m_skt     :  6;  /* RW */
+	unsigned long	n_skt     :  4;  /* RW */
 	unsigned long	rsvd_10_11:  2;  /*    */
 	unsigned long	mmiol_cfg :  1;  /* RW */
 	unsigned long	rsvd_13_63: 51;  /*    */
-    } s;
+    } s1;
+    struct uv2h_rh_gam_config_mmr_s {
+	unsigned long	m_skt :  6;  /* RW */
+	unsigned long	n_skt :  4;  /* RW */
+	unsigned long	rsvd_10_63: 54;  /*    */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -975,25 +1395,49 @@ union uvh_rh_gam_config_mmr_u {
 
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT 28
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffff0000000UL
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_SHFT 48
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_MASK 0x0001000000000000UL
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT 52
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK 0x00f0000000000000UL
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT 28
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffff0000000UL
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_SHFT 48
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_MASK 0x0001000000000000UL
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT 52
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK 0x00f0000000000000UL
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT 28
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffff0000000UL
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT 52
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK 0x00f0000000000000UL
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_gru_overlay_config_mmr_u {
     unsigned long	v;
     struct uvh_rh_gam_gru_overlay_config_mmr_s {
 	unsigned long	rsvd_0_27: 28;  /*    */
 	unsigned long	base   : 18;  /* RW */
+	unsigned long	rsvd_46_62    : 17;
+	unsigned long	enable :  1;  /* RW */
+    } s;
+    struct uv1h_rh_gam_gru_overlay_config_mmr_s {
+	unsigned long	rsvd_0_27: 28;  /*    */
+	unsigned long	base   : 18;  /* RW */
 	unsigned long	rsvd_46_47:  2;  /*    */
 	unsigned long	gr4    :  1;  /* RW */
 	unsigned long	rsvd_49_51:  3;  /*    */
 	unsigned long	n_gru  :  4;  /* RW */
 	unsigned long	rsvd_56_62:  7;  /*    */
 	unsigned long	enable :  1;  /* RW */
-    } s;
+    } s1;
+    struct uv2h_rh_gam_gru_overlay_config_mmr_s {
+	unsigned long	rsvd_0_27: 28;  /*    */
+	unsigned long	base   : 18;  /* RW */
+	unsigned long	rsvd_46_51:  6;  /*    */
+	unsigned long	n_gru  :  4;  /* RW */
+	unsigned long	rsvd_56_62:  7;  /*    */
+	unsigned long	enable :  1;  /* RW */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -1001,25 +1445,42 @@ union uvh_rh_gam_gru_overlay_config_mmr_u {
 /* ========================================================================= */
 #define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR 0x1600030UL
 
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT 30
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003fffc0000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT 46
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_MASK 0x000fc00000000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_SHFT 52
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_MASK 0x00f0000000000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT 30
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003fffc0000000UL
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT 46
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_MASK 0x000fc00000000000UL
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_SHFT 52
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_MASK 0x00f0000000000000UL
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT 27
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffff8000000UL
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT 46
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_MASK 0x000fc00000000000UL
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_SHFT 52
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_MASK 0x00f0000000000000UL
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_mmioh_overlay_config_mmr_u {
     unsigned long	v;
-    struct uvh_rh_gam_mmioh_overlay_config_mmr_s {
+    struct uv1h_rh_gam_mmioh_overlay_config_mmr_s {
 	unsigned long	rsvd_0_29: 30;  /*    */
 	unsigned long	base   : 16;  /* RW */
 	unsigned long	m_io   :  6;  /* RW */
 	unsigned long	n_io   :  4;  /* RW */
 	unsigned long	rsvd_56_62:  7;  /*    */
 	unsigned long	enable :  1;  /* RW */
-    } s;
+    } s1;
+    struct uv2h_rh_gam_mmioh_overlay_config_mmr_s {
+	unsigned long	rsvd_0_26: 27;  /*    */
+	unsigned long	base   : 19;  /* RW */
+	unsigned long	m_io   :  6;  /* RW */
+	unsigned long	n_io   :  4;  /* RW */
+	unsigned long	rsvd_56_62:  7;  /*    */
+	unsigned long	enable :  1;  /* RW */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -1029,20 +1490,40 @@ union uvh_rh_gam_mmioh_overlay_config_mmr_u {
 
 #define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT 26
 #define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffffc000000UL
-#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_SHFT 46
-#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_MASK 0x0000400000000000UL
-#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
-#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT 26
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffffc000000UL
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_SHFT 46
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_MASK 0x0000400000000000UL
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT 26
+#define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffffc000000UL
+#define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_mmr_overlay_config_mmr_u {
     unsigned long	v;
     struct uvh_rh_gam_mmr_overlay_config_mmr_s {
 	unsigned long	rsvd_0_25: 26;  /*    */
 	unsigned long	base     : 20;  /* RW */
+	unsigned long	rsvd_46_62    : 17;
+	unsigned long	enable   :  1;  /* RW */
+    } s;
+    struct uv1h_rh_gam_mmr_overlay_config_mmr_s {
+	unsigned long	rsvd_0_25: 26;  /*    */
+	unsigned long	base     : 20;  /* RW */
 	unsigned long	dual_hub :  1;  /* RW */
 	unsigned long	rsvd_47_62: 16;  /*    */
 	unsigned long	enable   :  1;  /* RW */
-    } s;
+    } s1;
+    struct uv2h_rh_gam_mmr_overlay_config_mmr_s {
+	unsigned long	rsvd_0_25: 26;  /*    */
+	unsigned long	base   : 20;  /* RW */
+	unsigned long	rsvd_46_62: 17;  /*    */
+	unsigned long	enable :  1;  /* RW */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -1103,10 +1584,11 @@ union uvh_rtc1_int_config_u {
 /*                               UVH_SCRATCH5                                */
 /* ========================================================================= */
 #define UVH_SCRATCH5 0x2d0200UL
-#define UVH_SCRATCH5_32 0x00778
+#define UVH_SCRATCH5_32 0x778
 
 #define UVH_SCRATCH5_SCRATCH5_SHFT 0
 #define UVH_SCRATCH5_SCRATCH5_MASK 0xffffffffffffffffUL
+
 union uvh_scratch5_u {
     unsigned long	v;
     struct uvh_scratch5_s {
@@ -1114,4 +1596,154 @@ union uvh_scratch5_u {
     } s;
 };
 
+/* ========================================================================= */
+/*                           UV2H_EVENT_OCCURRED2                            */
+/* ========================================================================= */
+#define UV2H_EVENT_OCCURRED2 0x70100UL
+#define UV2H_EVENT_OCCURRED2_32 0xb68
+
+#define UV2H_EVENT_OCCURRED2_RTC_0_SHFT 0
+#define UV2H_EVENT_OCCURRED2_RTC_0_MASK 0x0000000000000001UL
+#define UV2H_EVENT_OCCURRED2_RTC_1_SHFT 1
+#define UV2H_EVENT_OCCURRED2_RTC_1_MASK 0x0000000000000002UL
+#define UV2H_EVENT_OCCURRED2_RTC_2_SHFT 2
+#define UV2H_EVENT_OCCURRED2_RTC_2_MASK 0x0000000000000004UL
+#define UV2H_EVENT_OCCURRED2_RTC_3_SHFT 3
+#define UV2H_EVENT_OCCURRED2_RTC_3_MASK 0x0000000000000008UL
+#define UV2H_EVENT_OCCURRED2_RTC_4_SHFT 4
+#define UV2H_EVENT_OCCURRED2_RTC_4_MASK 0x0000000000000010UL
+#define UV2H_EVENT_OCCURRED2_RTC_5_SHFT 5
+#define UV2H_EVENT_OCCURRED2_RTC_5_MASK 0x0000000000000020UL
+#define UV2H_EVENT_OCCURRED2_RTC_6_SHFT 6
+#define UV2H_EVENT_OCCURRED2_RTC_6_MASK 0x0000000000000040UL
+#define UV2H_EVENT_OCCURRED2_RTC_7_SHFT 7
+#define UV2H_EVENT_OCCURRED2_RTC_7_MASK 0x0000000000000080UL
+#define UV2H_EVENT_OCCURRED2_RTC_8_SHFT 8
+#define UV2H_EVENT_OCCURRED2_RTC_8_MASK 0x0000000000000100UL
+#define UV2H_EVENT_OCCURRED2_RTC_9_SHFT 9
+#define UV2H_EVENT_OCCURRED2_RTC_9_MASK 0x0000000000000200UL
+#define UV2H_EVENT_OCCURRED2_RTC_10_SHFT 10
+#define UV2H_EVENT_OCCURRED2_RTC_10_MASK 0x0000000000000400UL
+#define UV2H_EVENT_OCCURRED2_RTC_11_SHFT 11
+#define UV2H_EVENT_OCCURRED2_RTC_11_MASK 0x0000000000000800UL
+#define UV2H_EVENT_OCCURRED2_RTC_12_SHFT 12
+#define UV2H_EVENT_OCCURRED2_RTC_12_MASK 0x0000000000001000UL
+#define UV2H_EVENT_OCCURRED2_RTC_13_SHFT 13
+#define UV2H_EVENT_OCCURRED2_RTC_13_MASK 0x0000000000002000UL
+#define UV2H_EVENT_OCCURRED2_RTC_14_SHFT 14
+#define UV2H_EVENT_OCCURRED2_RTC_14_MASK 0x0000000000004000UL
+#define UV2H_EVENT_OCCURRED2_RTC_15_SHFT 15
+#define UV2H_EVENT_OCCURRED2_RTC_15_MASK 0x0000000000008000UL
+#define UV2H_EVENT_OCCURRED2_RTC_16_SHFT 16
+#define UV2H_EVENT_OCCURRED2_RTC_16_MASK 0x0000000000010000UL
+#define UV2H_EVENT_OCCURRED2_RTC_17_SHFT 17
+#define UV2H_EVENT_OCCURRED2_RTC_17_MASK 0x0000000000020000UL
+#define UV2H_EVENT_OCCURRED2_RTC_18_SHFT 18
+#define UV2H_EVENT_OCCURRED2_RTC_18_MASK 0x0000000000040000UL
+#define UV2H_EVENT_OCCURRED2_RTC_19_SHFT 19
+#define UV2H_EVENT_OCCURRED2_RTC_19_MASK 0x0000000000080000UL
+#define UV2H_EVENT_OCCURRED2_RTC_20_SHFT 20
+#define UV2H_EVENT_OCCURRED2_RTC_20_MASK 0x0000000000100000UL
+#define UV2H_EVENT_OCCURRED2_RTC_21_SHFT 21
+#define UV2H_EVENT_OCCURRED2_RTC_21_MASK 0x0000000000200000UL
+#define UV2H_EVENT_OCCURRED2_RTC_22_SHFT 22
+#define UV2H_EVENT_OCCURRED2_RTC_22_MASK 0x0000000000400000UL
+#define UV2H_EVENT_OCCURRED2_RTC_23_SHFT 23
+#define UV2H_EVENT_OCCURRED2_RTC_23_MASK 0x0000000000800000UL
+#define UV2H_EVENT_OCCURRED2_RTC_24_SHFT 24
+#define UV2H_EVENT_OCCURRED2_RTC_24_MASK 0x0000000001000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_25_SHFT 25
+#define UV2H_EVENT_OCCURRED2_RTC_25_MASK 0x0000000002000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_26_SHFT 26
+#define UV2H_EVENT_OCCURRED2_RTC_26_MASK 0x0000000004000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_27_SHFT 27
+#define UV2H_EVENT_OCCURRED2_RTC_27_MASK 0x0000000008000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_28_SHFT 28
+#define UV2H_EVENT_OCCURRED2_RTC_28_MASK 0x0000000010000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_29_SHFT 29
+#define UV2H_EVENT_OCCURRED2_RTC_29_MASK 0x0000000020000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_30_SHFT 30
+#define UV2H_EVENT_OCCURRED2_RTC_30_MASK 0x0000000040000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_31_SHFT 31
+#define UV2H_EVENT_OCCURRED2_RTC_31_MASK 0x0000000080000000UL
+
+union uv2h_event_occurred2_u {
+    unsigned long	v;
+    struct uv2h_event_occurred2_s {
+	unsigned long	rtc_0  :  1;  /* RW */
+	unsigned long	rtc_1  :  1;  /* RW */
+	unsigned long	rtc_2  :  1;  /* RW */
+	unsigned long	rtc_3  :  1;  /* RW */
+	unsigned long	rtc_4  :  1;  /* RW */
+	unsigned long	rtc_5  :  1;  /* RW */
+	unsigned long	rtc_6  :  1;  /* RW */
+	unsigned long	rtc_7  :  1;  /* RW */
+	unsigned long	rtc_8  :  1;  /* RW */
+	unsigned long	rtc_9  :  1;  /* RW */
+	unsigned long	rtc_10 :  1;  /* RW */
+	unsigned long	rtc_11 :  1;  /* RW */
+	unsigned long	rtc_12 :  1;  /* RW */
+	unsigned long	rtc_13 :  1;  /* RW */
+	unsigned long	rtc_14 :  1;  /* RW */
+	unsigned long	rtc_15 :  1;  /* RW */
+	unsigned long	rtc_16 :  1;  /* RW */
+	unsigned long	rtc_17 :  1;  /* RW */
+	unsigned long	rtc_18 :  1;  /* RW */
+	unsigned long	rtc_19 :  1;  /* RW */
+	unsigned long	rtc_20 :  1;  /* RW */
+	unsigned long	rtc_21 :  1;  /* RW */
+	unsigned long	rtc_22 :  1;  /* RW */
+	unsigned long	rtc_23 :  1;  /* RW */
+	unsigned long	rtc_24 :  1;  /* RW */
+	unsigned long	rtc_25 :  1;  /* RW */
+	unsigned long	rtc_26 :  1;  /* RW */
+	unsigned long	rtc_27 :  1;  /* RW */
+	unsigned long	rtc_28 :  1;  /* RW */
+	unsigned long	rtc_29 :  1;  /* RW */
+	unsigned long	rtc_30 :  1;  /* RW */
+	unsigned long	rtc_31 :  1;  /* RW */
+	unsigned long	rsvd_32_63: 32;  /*    */
+    } s1;
+};
+
+/* ========================================================================= */
+/*                        UV2H_EVENT_OCCURRED2_ALIAS                         */
+/* ========================================================================= */
+#define UV2H_EVENT_OCCURRED2_ALIAS 0x70108UL
+#define UV2H_EVENT_OCCURRED2_ALIAS_32 0xb70
+
+/* ========================================================================= */
+/*                    UV2H_LB_BAU_SB_ACTIVATION_STATUS_2                     */
+/* ========================================================================= */
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2 0x320130UL
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_32 0x9f0
+
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_SHFT 0
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_MASK 0xffffffffffffffffUL
+
+union uv2h_lb_bau_sb_activation_status_2_u {
+    unsigned long	v;
+    struct uv2h_lb_bau_sb_activation_status_2_s {
+	unsigned long	aux_error : 64;  /* RW */
+    } s1;
+};
+
+/* ========================================================================= */
+/*                   UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK                    */
+/* ========================================================================= */
+#define UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK 0x320130UL
+#define UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK_32 0x9f0
+
+#define UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_SHFT 0
+#define UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_MASK 0x00000000ffffffffUL
+
+union uv1h_lb_target_physical_apic_id_mask_u {
+    unsigned long	v;
+    struct uv1h_lb_target_physical_apic_id_mask_s {
+	unsigned long	bit_enables : 32;  /* RW */
+	unsigned long	rsvd_32_63  : 32;  /*    */
+    } s1;
+};
+
+
 #endif /* __ASM_UV_MMRS_X86_H__ */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f450b68..b511a01 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -91,6 +91,10 @@ static int __init early_get_pnodeid(void)
 	m_n_config.v = uv_early_read_mmr(UVH_RH_GAM_CONFIG_MMR);
 	uv_min_hub_revision_id = node_id.s.revision;
 
+	if (node_id.s.part_number == UV2_HUB_PART_NUMBER)
+		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
+
+	uv_hub_info->hub_revision = uv_min_hub_revision_id;
 	pnode = (node_id.s.node_id >> 1) & ((1 << m_n_config.s.n_skt) - 1);
 	return pnode;
 }
@@ -112,17 +116,25 @@ static void __init early_get_apic_pnode_shift(void)
  */
 static void __init uv_set_apicid_hibit(void)
 {
-	union uvh_lb_target_physical_apic_id_mask_u apicid_mask;
+	union uv1h_lb_target_physical_apic_id_mask_u apicid_mask;
 
-	apicid_mask.v = uv_early_read_mmr(UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK);
-	uv_apicid_hibits = apicid_mask.s.bit_enables & UV_APICID_HIBIT_MASK;
+	if (is_uv1_hub()) {
+		apicid_mask.v =
+			uv_early_read_mmr(UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK);
+		uv_apicid_hibits =
+			apicid_mask.s1.bit_enables & UV_APICID_HIBIT_MASK;
+	}
 }
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int pnodeid;
+	int pnodeid, is_uv1, is_uv2;
 
-	if (!strcmp(oem_id, "SGI")) {
+	is_uv1 = !strcmp(oem_id, "SGI");
+	is_uv2 = !strcmp(oem_id, "SGI2");
+	if (is_uv1 || is_uv2) {
+		uv_hub_info->hub_revision =
+			is_uv1 ? UV1_HUB_REVISION_BASE : UV2_HUB_REVISION_BASE;
 		pnodeid = early_get_pnodeid();
 		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
@@ -484,12 +496,19 @@ static __init void map_mmr_high(int max_pnode)
 static __init void map_mmioh_high(int max_pnode)
 {
 	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
-	int shift = UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
+	int shift;
 
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
-	if (mmioh.s.enable)
-		map_high("MMIOH", mmioh.s.base, shift, mmioh.s.m_io,
+	if (is_uv1_hub() && mmioh.s1.enable) {
+		shift = UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
+		map_high("MMIOH", mmioh.s1.base, shift, mmioh.s1.m_io,
+			max_pnode, map_uc);
+	}
+	if (is_uv2_hub() && mmioh.s2.enable) {
+		shift = UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
+		map_high("MMIOH", mmioh.s2.base, shift, mmioh.s2.m_io,
 			max_pnode, map_uc);
+	}
 }
 
 static __init void map_low_mmrs(void)
@@ -736,13 +755,14 @@ void __init uv_system_init(void)
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask, pnode_io_mask;
 
+	printk(KERN_INFO "UV: Found %s hub\n", is_uv1_hub() ? "UV1" : "UV2");
 	map_low_mmrs();
 
 	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
-	n_io = mmioh.s.n_io;
+	n_io = is_uv1_hub() ? mmioh.s1.n_io : mmioh.s2.n_io;
 	mmr_base =
 	    uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
 	    ~UV_MMR_ENABLE;
@@ -811,6 +831,8 @@ void __init uv_system_init(void)
 		 */
 		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->apic_pnode_shift = uvh_apicid.s.pnode_shift;
+		uv_cpu_hub_info(cpu)->hub_revision = uv_hub_info->hub_revision;
+
 		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 8f5cabb..b13ed39 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -612,8 +612,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
-	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	/*
+	 * Family 0x12 and above processors have APIC timer
+	 * running in deep C states.
+	 */
+	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c8b4162..53f02f5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -477,13 +477,6 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 	if (smp_num_siblings <= 1)
 		goto out;
 
-	if (smp_num_siblings > nr_cpu_ids) {
-		pr_warning("CPU: Unsupported number of siblings %d",
-			   smp_num_siblings);
-		smp_num_siblings = 1;
-		return;
-	}
-
 	index_msb = get_count_order(smp_num_siblings);
 	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, index_msb);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a3e5948..afaf384 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -910,6 +910,13 @@ void __init setup_arch(char **cmdline_p)
 	memblock.current_limit = get_max_mapped();
 	memblock_x86_fill();
 
+	/*
+	 * The EFI specification says that boot service code won't be called
+	 * after ExitBootServices(). This is, in fact, a lie.
+	 */
+	if (efi_enabled)
+		efi_reserve_boot_services();
+
 	/* preallocate 4k for mptable mpc */
 	early_reserve_e820_mpc_new();
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f7a2a05..2dbf6bf 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -823,16 +823,30 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	force_sig_info_fault(SIGBUS, code, address, tsk, fault);
 }
 
-static noinline void
+static noinline int
 mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 	       unsigned long address, unsigned int fault)
 {
+	/*
+	 * Pagefault was interrupted by SIGKILL. We have no reason to
+	 * continue pagefault.
+	 */
+	if (fatal_signal_pending(current)) {
+		if (!(fault & VM_FAULT_RETRY))
+			up_read(&current->mm->mmap_sem);
+		if (!(error_code & PF_USER))
+			no_context(regs, error_code, address);
+		return 1;
+	}
+	if (!(fault & VM_FAULT_ERROR))
+		return 0;
+
 	if (fault & VM_FAULT_OOM) {
 		/* Kernel mode? Handle exceptions or die: */
 		if (!(error_code & PF_USER)) {
 			up_read(&current->mm->mmap_sem);
 			no_context(regs, error_code, address);
-			return;
+			return 1;
 		}
 
 		out_of_memory(regs, error_code, address);
@@ -843,6 +857,7 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 		else
 			BUG();
 	}
+	return 1;
 }
 
 static int spurious_fault_check(unsigned long error_code, pte_t *pte)
@@ -1133,19 +1148,9 @@ good_area:
 	 */
 	fault = handle_mm_fault(mm, vma, address, flags);
 
-	if (unlikely(fault & VM_FAULT_ERROR)) {
-		mm_fault_error(regs, error_code, address, fault);
-		return;
-	}
-
-	/*
-	 * Pagefault was interrupted by SIGKILL. We have no reason to
-	 * continue pagefault.
-	 */
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)) {
-		if (!(error_code & PF_USER))
-			no_context(regs, error_code, address);
-		return;
+	if (unlikely(fault & (VM_FAULT_RETRY|VM_FAULT_ERROR))) {
+		if (mm_fault_error(regs, error_code, address, fault))
+			return;
 	}
 
 	/*
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b30aa26..0d3a4fa 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -304,6 +304,40 @@ static void __init print_efi_memmap(void)
 }
 #endif  /*  EFI_DEBUG  */
 
+void __init efi_reserve_boot_services(void)
+{
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		unsigned long long start = md->phys_addr;
+		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		memblock_x86_reserve_range(start, start + size, "EFI Boot");
+	}
+}
+
+static void __init efi_free_boot_services(void)
+{
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		unsigned long long start = md->phys_addr;
+		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		free_bootmem_late(start, size);
+	}
+}
+
 void __init efi_init(void)
 {
 	efi_config_table_t *config_tables;
@@ -536,7 +570,9 @@ void __init efi_enter_virtual_mode(void)
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
@@ -593,6 +629,13 @@ void __init efi_enter_virtual_mode(void)
 	}
 
 	/*
+	 * Thankfully, it does seem that no runtime services other than
+	 * SetVirtualAddressMap() will touch boot services code, so we can
+	 * get rid of it all at this point
+	 */
+	efi_free_boot_services();
+
+	/*
 	 * Now that EFI is in virtual mode, update the function
 	 * pointers in the runtime service table to the new virtual addresses.
 	 *
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 2649426..ac3aa54 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -49,10 +49,11 @@ static void __init early_code_mapping_set_exec(int executable)
 	if (!(__supported_pte_mask & _PAGE_NX))
 		return;
 
-	/* Make EFI runtime service code area executable */
+	/* Make EFI service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (md->type == EFI_RUNTIME_SERVICES_CODE)
+		if (md->type == EFI_RUNTIME_SERVICES_CODE ||
+		    md->type == EFI_BOOT_SERVICES_CODE)
 			efi_set_executable(md, executable);
 	}
 }
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index c58e0ea..68e467f 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1,7 +1,7 @@
 /*
  *	SGI UltraViolet TLB flush routines.
  *
- *	(c) 2008-2010 Cliff Wickman <cpw@sgi.com>, SGI.
+ *	(c) 2008-2011 Cliff Wickman <cpw@sgi.com>, SGI.
  *
  *	This code is released under the GNU General Public License version 2 or
  *	later.
@@ -35,6 +35,7 @@ static int timeout_base_ns[] = {
 		5242880,
 		167772160
 };
+
 static int timeout_us;
 static int nobau;
 static int baudisabled;
@@ -42,20 +43,70 @@ static spinlock_t disable_lock;
 static cycles_t congested_cycles;
 
 /* tunables: */
-static int max_bau_concurrent = MAX_BAU_CONCURRENT;
-static int max_bau_concurrent_constant = MAX_BAU_CONCURRENT;
-static int plugged_delay = PLUGGED_DELAY;
-static int plugsb4reset = PLUGSB4RESET;
-static int timeoutsb4reset = TIMEOUTSB4RESET;
-static int ipi_reset_limit = IPI_RESET_LIMIT;
-static int complete_threshold = COMPLETE_THRESHOLD;
-static int congested_response_us = CONGESTED_RESPONSE_US;
-static int congested_reps = CONGESTED_REPS;
-static int congested_period = CONGESTED_PERIOD;
+static int max_concurr		= MAX_BAU_CONCURRENT;
+static int max_concurr_const	= MAX_BAU_CONCURRENT;
+static int plugged_delay	= PLUGGED_DELAY;
+static int plugsb4reset		= PLUGSB4RESET;
+static int timeoutsb4reset	= TIMEOUTSB4RESET;
+static int ipi_reset_limit	= IPI_RESET_LIMIT;
+static int complete_threshold	= COMPLETE_THRESHOLD;
+static int congested_respns_us	= CONGESTED_RESPONSE_US;
+static int congested_reps	= CONGESTED_REPS;
+static int congested_period	= CONGESTED_PERIOD;
+
+static struct tunables tunables[] = {
+	{&max_concurr, MAX_BAU_CONCURRENT}, /* must be [0] */
+	{&plugged_delay, PLUGGED_DELAY},
+	{&plugsb4reset, PLUGSB4RESET},
+	{&timeoutsb4reset, TIMEOUTSB4RESET},
+	{&ipi_reset_limit, IPI_RESET_LIMIT},
+	{&complete_threshold, COMPLETE_THRESHOLD},
+	{&congested_respns_us, CONGESTED_RESPONSE_US},
+	{&congested_reps, CONGESTED_REPS},
+	{&congested_period, CONGESTED_PERIOD}
+};
+
 static struct dentry *tunables_dir;
 static struct dentry *tunables_file;
 
-static int __init setup_nobau(char *arg)
+/* these correspond to the statistics printed by ptc_seq_show() */
+static char *stat_description[] = {
+	"sent:     number of shootdown messages sent",
+	"stime:    time spent sending messages",
+	"numuvhubs: number of hubs targeted with shootdown",
+	"numuvhubs16: number times 16 or more hubs targeted",
+	"numuvhubs8: number times 8 or more hubs targeted",
+	"numuvhubs4: number times 4 or more hubs targeted",
+	"numuvhubs2: number times 2 or more hubs targeted",
+	"numuvhubs1: number times 1 hub targeted",
+	"numcpus:  number of cpus targeted with shootdown",
+	"dto:      number of destination timeouts",
+	"retries:  destination timeout retries sent",
+	"rok:   :  destination timeouts successfully retried",
+	"resetp:   ipi-style resource resets for plugs",
+	"resett:   ipi-style resource resets for timeouts",
+	"giveup:   fall-backs to ipi-style shootdowns",
+	"sto:      number of source timeouts",
+	"bz:       number of stay-busy's",
+	"throt:    number times spun in throttle",
+	"swack:   image of UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE",
+	"recv:     shootdown messages received",
+	"rtime:    time spent processing messages",
+	"all:      shootdown all-tlb messages",
+	"one:      shootdown one-tlb messages",
+	"mult:     interrupts that found multiple messages",
+	"none:     interrupts that found no messages",
+	"retry:    number of retry messages processed",
+	"canc:     number messages canceled by retries",
+	"nocan:    number retries that found nothing to cancel",
+	"reset:    number of ipi-style reset requests processed",
+	"rcan:     number messages canceled by reset requests",
+	"disable:  number times use of the BAU was disabled",
+	"enable:   number times use of the BAU was re-enabled"
+};
+
+static int __init
+setup_nobau(char *arg)
 {
 	nobau = 1;
 	return 0;
@@ -63,7 +114,7 @@ static int __init setup_nobau(char *arg)
 early_param("nobau", setup_nobau);
 
 /* base pnode in this partition */
-static int uv_partition_base_pnode __read_mostly;
+static int uv_base_pnode __read_mostly;
 /* position of pnode (which is nasid>>1): */
 static int uv_nshift __read_mostly;
 static unsigned long uv_mmask __read_mostly;
@@ -109,60 +160,52 @@ static int __init uvhub_to_first_apicid(int uvhub)
  * clear of the Timeout bit (as well) will free the resource. No reply will
  * be sent (the hardware will only do one reply per message).
  */
-static inline void uv_reply_to_message(struct msg_desc *mdp,
-				       struct bau_control *bcp)
+static void reply_to_message(struct msg_desc *mdp, struct bau_control *bcp)
 {
 	unsigned long dw;
-	struct bau_payload_queue_entry *msg;
+	struct bau_pq_entry *msg;
 
 	msg = mdp->msg;
 	if (!msg->canceled) {
-		dw = (msg->sw_ack_vector << UV_SW_ACK_NPENDING) |
-						msg->sw_ack_vector;
-		uv_write_local_mmr(
-				UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, dw);
+		dw = (msg->swack_vec << UV_SW_ACK_NPENDING) | msg->swack_vec;
+		write_mmr_sw_ack(dw);
 	}
 	msg->replied_to = 1;
-	msg->sw_ack_vector = 0;
+	msg->swack_vec = 0;
 }
 
 /*
  * Process the receipt of a RETRY message
  */
-static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
-					    struct bau_control *bcp)
+static void bau_process_retry_msg(struct msg_desc *mdp,
+					struct bau_control *bcp)
 {
 	int i;
 	int cancel_count = 0;
-	int slot2;
 	unsigned long msg_res;
 	unsigned long mmr = 0;
-	struct bau_payload_queue_entry *msg;
-	struct bau_payload_queue_entry *msg2;
-	struct ptc_stats *stat;
+	struct bau_pq_entry *msg = mdp->msg;
+	struct bau_pq_entry *msg2;
+	struct ptc_stats *stat = bcp->statp;
 
-	msg = mdp->msg;
-	stat = bcp->statp;
 	stat->d_retries++;
 	/*
 	 * cancel any message from msg+1 to the retry itself
 	 */
 	for (msg2 = msg+1, i = 0; i < DEST_Q_SIZE; msg2++, i++) {
-		if (msg2 > mdp->va_queue_last)
-			msg2 = mdp->va_queue_first;
+		if (msg2 > mdp->queue_last)
+			msg2 = mdp->queue_first;
 		if (msg2 == msg)
 			break;
 
-		/* same conditions for cancellation as uv_do_reset */
+		/* same conditions for cancellation as do_reset */
 		if ((msg2->replied_to == 0) && (msg2->canceled == 0) &&
-		    (msg2->sw_ack_vector) && ((msg2->sw_ack_vector &
-			msg->sw_ack_vector) == 0) &&
+		    (msg2->swack_vec) && ((msg2->swack_vec &
+			msg->swack_vec) == 0) &&
 		    (msg2->sending_cpu == msg->sending_cpu) &&
 		    (msg2->msg_type != MSG_NOOP)) {
-			slot2 = msg2 - mdp->va_queue_first;
-			mmr = uv_read_local_mmr
-				(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
-			msg_res = msg2->sw_ack_vector;
+			mmr = read_mmr_sw_ack();
+			msg_res = msg2->swack_vec;
 			/*
 			 * This is a message retry; clear the resources held
 			 * by the previous message only if they timed out.
@@ -170,6 +213,7 @@ static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
 			 * situation to report.
 			 */
 			if (mmr & (msg_res << UV_SW_ACK_NPENDING)) {
+				unsigned long mr;
 				/*
 				 * is the resource timed out?
 				 * make everyone ignore the cancelled message.
@@ -177,10 +221,8 @@ static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
 				msg2->canceled = 1;
 				stat->d_canceled++;
 				cancel_count++;
-				uv_write_local_mmr(
-				    UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS,
-					(msg_res << UV_SW_ACK_NPENDING) |
-					 msg_res);
+				mr = (msg_res << UV_SW_ACK_NPENDING) | msg_res;
+				write_mmr_sw_ack(mr);
 			}
 		}
 	}
@@ -192,20 +234,19 @@ static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
  * Do all the things a cpu should do for a TLB shootdown message.
  * Other cpu's may come here at the same time for this message.
  */
-static void uv_bau_process_message(struct msg_desc *mdp,
-				   struct bau_control *bcp)
+static void bau_process_message(struct msg_desc *mdp,
+					struct bau_control *bcp)
 {
-	int msg_ack_count;
 	short socket_ack_count = 0;
-	struct ptc_stats *stat;
-	struct bau_payload_queue_entry *msg;
+	short *sp;
+	struct atomic_short *asp;
+	struct ptc_stats *stat = bcp->statp;
+	struct bau_pq_entry *msg = mdp->msg;
 	struct bau_control *smaster = bcp->socket_master;
 
 	/*
 	 * This must be a normal message, or retry of a normal message
 	 */
-	msg = mdp->msg;
-	stat = bcp->statp;
 	if (msg->address == TLB_FLUSH_ALL) {
 		local_flush_tlb();
 		stat->d_alltlb++;
@@ -222,30 +263,32 @@ static void uv_bau_process_message(struct msg_desc *mdp,
 	 * cpu number.
 	 */
 	if (msg->msg_type == MSG_RETRY && bcp == bcp->uvhub_master)
-		uv_bau_process_retry_msg(mdp, bcp);
+		bau_process_retry_msg(mdp, bcp);
 
 	/*
-	 * This is a sw_ack message, so we have to reply to it.
+	 * This is a swack message, so we have to reply to it.
 	 * Count each responding cpu on the socket. This avoids
 	 * pinging the count's cache line back and forth between
 	 * the sockets.
 	 */
-	socket_ack_count = atomic_add_short_return(1, (struct atomic_short *)
-			&smaster->socket_acknowledge_count[mdp->msg_slot]);
+	sp = &smaster->socket_acknowledge_count[mdp->msg_slot];
+	asp = (struct atomic_short *)sp;
+	socket_ack_count = atom_asr(1, asp);
 	if (socket_ack_count == bcp->cpus_in_socket) {
+		int msg_ack_count;
 		/*
 		 * Both sockets dump their completed count total into
 		 * the message's count.
 		 */
 		smaster->socket_acknowledge_count[mdp->msg_slot] = 0;
-		msg_ack_count = atomic_add_short_return(socket_ack_count,
-				(struct atomic_short *)&msg->acknowledge_count);
+		asp = (struct atomic_short *)&msg->acknowledge_count;
+		msg_ack_count = atom_asr(socket_ack_count, asp);
 
 		if (msg_ack_count == bcp->cpus_in_uvhub) {
 			/*
 			 * All cpus in uvhub saw it; reply
 			 */
-			uv_reply_to_message(mdp, bcp);
+			reply_to_message(mdp, bcp);
 		}
 	}
 
@@ -268,62 +311,51 @@ static int uvhub_to_first_cpu(int uvhub)
  * Last resort when we get a large number of destination timeouts is
  * to clear resources held by a given cpu.
  * Do this with IPI so that all messages in the BAU message queue
- * can be identified by their nonzero sw_ack_vector field.
+ * can be identified by their nonzero swack_vec field.
  *
  * This is entered for a single cpu on the uvhub.
  * The sender want's this uvhub to free a specific message's
- * sw_ack resources.
+ * swack resources.
  */
-static void
-uv_do_reset(void *ptr)
+static void do_reset(void *ptr)
 {
 	int i;
-	int slot;
-	int count = 0;
-	unsigned long mmr;
-	unsigned long msg_res;
-	struct bau_control *bcp;
-	struct reset_args *rap;
-	struct bau_payload_queue_entry *msg;
-	struct ptc_stats *stat;
+	struct bau_control *bcp = &per_cpu(bau_control, smp_processor_id());
+	struct reset_args *rap = (struct reset_args *)ptr;
+	struct bau_pq_entry *msg;
+	struct ptc_stats *stat = bcp->statp;
 
-	bcp = &per_cpu(bau_control, smp_processor_id());
-	rap = (struct reset_args *)ptr;
-	stat = bcp->statp;
 	stat->d_resets++;
-
 	/*
 	 * We're looking for the given sender, and
-	 * will free its sw_ack resource.
+	 * will free its swack resource.
 	 * If all cpu's finally responded after the timeout, its
 	 * message 'replied_to' was set.
 	 */
-	for (msg = bcp->va_queue_first, i = 0; i < DEST_Q_SIZE; msg++, i++) {
-		/* uv_do_reset: same conditions for cancellation as
-		   uv_bau_process_retry_msg() */
+	for (msg = bcp->queue_first, i = 0; i < DEST_Q_SIZE; msg++, i++) {
+		unsigned long msg_res;
+		/* do_reset: same conditions for cancellation as
+		   bau_process_retry_msg() */
 		if ((msg->replied_to == 0) &&
 		    (msg->canceled == 0) &&
 		    (msg->sending_cpu == rap->sender) &&
-		    (msg->sw_ack_vector) &&
+		    (msg->swack_vec) &&
 		    (msg->msg_type != MSG_NOOP)) {
+			unsigned long mmr;
+			unsigned long mr;
 			/*
 			 * make everyone else ignore this message
 			 */
 			msg->canceled = 1;
-			slot = msg - bcp->va_queue_first;
-			count++;
 			/*
 			 * only reset the resource if it is still pending
 			 */
-			mmr = uv_read_local_mmr
-					(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
-			msg_res = msg->sw_ack_vector;
+			mmr = read_mmr_sw_ack();
+			msg_res = msg->swack_vec;
+			mr = (msg_res << UV_SW_ACK_NPENDING) | msg_res;
 			if (mmr & msg_res) {
 				stat->d_rcanceled++;
-				uv_write_local_mmr(
-				    UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS,
-					(msg_res << UV_SW_ACK_NPENDING) |
-					 msg_res);
+				write_mmr_sw_ack(mr);
 			}
 		}
 	}
@@ -334,39 +366,38 @@ uv_do_reset(void *ptr)
  * Use IPI to get all target uvhubs to release resources held by
  * a given sending cpu number.
  */
-static void uv_reset_with_ipi(struct bau_target_uvhubmask *distribution,
-			      int sender)
+static void reset_with_ipi(struct bau_targ_hubmask *distribution, int sender)
 {
 	int uvhub;
-	int cpu;
+	int maskbits;
 	cpumask_t mask;
 	struct reset_args reset_args;
 
 	reset_args.sender = sender;
-
 	cpus_clear(mask);
 	/* find a single cpu for each uvhub in this distribution mask */
-	for (uvhub = 0;
-		    uvhub < sizeof(struct bau_target_uvhubmask) * BITSPERBYTE;
-		    uvhub++) {
+	maskbits = sizeof(struct bau_targ_hubmask) * BITSPERBYTE;
+	for (uvhub = 0; uvhub < maskbits; uvhub++) {
+		int cpu;
 		if (!bau_uvhub_isset(uvhub, distribution))
 			continue;
 		/* find a cpu for this uvhub */
 		cpu = uvhub_to_first_cpu(uvhub);
 		cpu_set(cpu, mask);
 	}
-	/* IPI all cpus; Preemption is already disabled */
-	smp_call_function_many(&mask, uv_do_reset, (void *)&reset_args, 1);
+
+	/* IPI all cpus; preemption is already disabled */
+	smp_call_function_many(&mask, do_reset, (void *)&reset_args, 1);
 	return;
 }
 
-static inline unsigned long
-cycles_2_us(unsigned long long cyc)
+static inline unsigned long cycles_2_us(unsigned long long cyc)
 {
 	unsigned long long ns;
 	unsigned long us;
-	ns =  (cyc * per_cpu(cyc2ns, smp_processor_id()))
-						>> CYC2NS_SCALE_FACTOR;
+	int cpu = smp_processor_id();
+
+	ns =  (cyc * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR;
 	us = ns / 1000;
 	return us;
 }
@@ -376,56 +407,56 @@ cycles_2_us(unsigned long long cyc)
  * leaves uvhub_quiesce set so that no new broadcasts are started by
  * bau_flush_send_and_wait()
  */
-static inline void
-quiesce_local_uvhub(struct bau_control *hmaster)
+static inline void quiesce_local_uvhub(struct bau_control *hmaster)
 {
-	atomic_add_short_return(1, (struct atomic_short *)
-		 &hmaster->uvhub_quiesce);
+	atom_asr(1, (struct atomic_short *)&hmaster->uvhub_quiesce);
 }
 
 /*
  * mark this quiet-requestor as done
  */
-static inline void
-end_uvhub_quiesce(struct bau_control *hmaster)
+static inline void end_uvhub_quiesce(struct bau_control *hmaster)
 {
-	atomic_add_short_return(-1, (struct atomic_short *)
-		&hmaster->uvhub_quiesce);
+	atom_asr(-1, (struct atomic_short *)&hmaster->uvhub_quiesce);
+}
+
+static unsigned long uv1_read_status(unsigned long mmr_offset, int right_shift)
+{
+	unsigned long descriptor_status;
+
+	descriptor_status = uv_read_local_mmr(mmr_offset);
+	descriptor_status >>= right_shift;
+	descriptor_status &= UV_ACT_STATUS_MASK;
+	return descriptor_status;
 }
 
 /*
  * Wait for completion of a broadcast software ack message
  * return COMPLETE, RETRY(PLUGGED or TIMEOUT) or GIVEUP
  */
-static int uv_wait_completion(struct bau_desc *bau_desc,
-	unsigned long mmr_offset, int right_shift, int this_cpu,
-	struct bau_control *bcp, struct bau_control *smaster, long try)
+static int uv1_wait_completion(struct bau_desc *bau_desc,
+				unsigned long mmr_offset, int right_shift,
+				struct bau_control *bcp, long try)
 {
 	unsigned long descriptor_status;
-	cycles_t ttime;
+	cycles_t ttm;
 	struct ptc_stats *stat = bcp->statp;
-	struct bau_control *hmaster;
-
-	hmaster = bcp->uvhub_master;
 
+	descriptor_status = uv1_read_status(mmr_offset, right_shift);
 	/* spin on the status MMR, waiting for it to go idle */
-	while ((descriptor_status = (((unsigned long)
-		uv_read_local_mmr(mmr_offset) >>
-			right_shift) & UV_ACT_STATUS_MASK)) !=
-			DESC_STATUS_IDLE) {
+	while ((descriptor_status != DS_IDLE)) {
 		/*
-		 * Our software ack messages may be blocked because there are
-		 * no swack resources available.  As long as none of them
-		 * has timed out hardware will NACK our message and its
-		 * state will stay IDLE.
+		 * Our software ack messages may be blocked because
+		 * there are no swack resources available.  As long
+		 * as none of them has timed out hardware will NACK
+		 * our message and its state will stay IDLE.
 		 */
-		if (descriptor_status == DESC_STATUS_SOURCE_TIMEOUT) {
+		if (descriptor_status == DS_SOURCE_TIMEOUT) {
 			stat->s_stimeout++;
 			return FLUSH_GIVEUP;
-		} else if (descriptor_status ==
-					DESC_STATUS_DESTINATION_TIMEOUT) {
+		} else if (descriptor_status == DS_DESTINATION_TIMEOUT) {
 			stat->s_dtimeout++;
-			ttime = get_cycles();
+			ttm = get_cycles();
 
 			/*
 			 * Our retries may be blocked by all destination
@@ -433,8 +464,7 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
 			 * pending.  In that case hardware returns the
 			 * ERROR that looks like a destination timeout.
 			 */
-			if (cycles_2_us(ttime - bcp->send_message) <
-							timeout_us) {
+			if (cycles_2_us(ttm - bcp->send_message) < timeout_us) {
 				bcp->conseccompletes = 0;
 				return FLUSH_RETRY_PLUGGED;
 			}
@@ -447,80 +477,160 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
 			 */
 			cpu_relax();
 		}
+		descriptor_status = uv1_read_status(mmr_offset, right_shift);
 	}
 	bcp->conseccompletes++;
 	return FLUSH_COMPLETE;
 }
 
-static inline cycles_t
-sec_2_cycles(unsigned long sec)
+/*
+ * UV2 has an extra bit of status in the ACTIVATION_STATUS_2 register.
+ */
+static unsigned long uv2_read_status(unsigned long offset, int rshft, int cpu)
 {
-	unsigned long ns;
-	cycles_t cyc;
+	unsigned long descriptor_status;
+	unsigned long descriptor_status2;
 
-	ns = sec * 1000000000;
-	cyc = (ns << CYC2NS_SCALE_FACTOR)/(per_cpu(cyc2ns, smp_processor_id()));
-	return cyc;
+	descriptor_status = ((read_lmmr(offset) >> rshft) & UV_ACT_STATUS_MASK);
+	descriptor_status2 = (read_mmr_uv2_status() >> cpu) & 0x1UL;
+	descriptor_status = (descriptor_status << 1) | descriptor_status2;
+	return descriptor_status;
+}
+
+static int uv2_wait_completion(struct bau_desc *bau_desc,
+				unsigned long mmr_offset, int right_shift,
+				struct bau_control *bcp, long try)
+{
+	unsigned long descriptor_stat;
+	cycles_t ttm;
+	int cpu = bcp->uvhub_cpu;
+	struct ptc_stats *stat = bcp->statp;
+
+	descriptor_stat = uv2_read_status(mmr_offset, right_shift, cpu);
+
+	/* spin on the status MMR, waiting for it to go idle */
+	while (descriptor_stat != UV2H_DESC_IDLE) {
+		/*
+		 * Our software ack messages may be blocked because
+		 * there are no swack resources available.  As long
+		 * as none of them has timed out hardware will NACK
+		 * our message and its state will stay IDLE.
+		 */
+		if ((descriptor_stat == UV2H_DESC_SOURCE_TIMEOUT) ||
+		    (descriptor_stat == UV2H_DESC_DEST_STRONG_NACK) ||
+		    (descriptor_stat == UV2H_DESC_DEST_PUT_ERR)) {
+			stat->s_stimeout++;
+			return FLUSH_GIVEUP;
+		} else if (descriptor_stat == UV2H_DESC_DEST_TIMEOUT) {
+			stat->s_dtimeout++;
+			ttm = get_cycles();
+			/*
+			 * Our retries may be blocked by all destination
+			 * swack resources being consumed, and a timeout
+			 * pending.  In that case hardware returns the
+			 * ERROR that looks like a destination timeout.
+			 */
+			if (cycles_2_us(ttm - bcp->send_message) < timeout_us) {
+				bcp->conseccompletes = 0;
+				return FLUSH_RETRY_PLUGGED;
+			}
+			bcp->conseccompletes = 0;
+			return FLUSH_RETRY_TIMEOUT;
+		} else {
+			/*
+			 * descriptor_stat is still BUSY
+			 */
+			cpu_relax();
+		}
+		descriptor_stat = uv2_read_status(mmr_offset, right_shift, cpu);
+	}
+	bcp->conseccompletes++;
+	return FLUSH_COMPLETE;
 }
 
 /*
- * conditionally add 1 to *v, unless *v is >= u
- * return 0 if we cannot add 1 to *v because it is >= u
- * return 1 if we can add 1 to *v because it is < u
- * the add is atomic
- *
- * This is close to atomic_add_unless(), but this allows the 'u' value
- * to be lowered below the current 'v'.  atomic_add_unless can only stop
- * on equal.
+ * There are 2 status registers; each and array[32] of 2 bits. Set up for
+ * which register to read and position in that register based on cpu in
+ * current hub.
  */
-static inline int atomic_inc_unless_ge(spinlock_t *lock, atomic_t *v, int u)
+static int wait_completion(struct bau_desc *bau_desc,
+				struct bau_control *bcp, long try)
 {
-	spin_lock(lock);
-	if (atomic_read(v) >= u) {
-		spin_unlock(lock);
-		return 0;
+	int right_shift;
+	unsigned long mmr_offset;
+	int cpu = bcp->uvhub_cpu;
+
+	if (cpu < UV_CPUS_PER_AS) {
+		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_0;
+		right_shift = cpu * UV_ACT_STATUS_SIZE;
+	} else {
+		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_1;
+		right_shift = ((cpu - UV_CPUS_PER_AS) * UV_ACT_STATUS_SIZE);
 	}
-	atomic_inc(v);
-	spin_unlock(lock);
-	return 1;
+
+	if (is_uv1_hub())
+		return uv1_wait_completion(bau_desc, mmr_offset, right_shift,
+								bcp, try);
+	else
+		return uv2_wait_completion(bau_desc, mmr_offset, right_shift,
+								bcp, try);
+}
+
+static inline cycles_t sec_2_cycles(unsigned long sec)
+{
+	unsigned long ns;
+	cycles_t cyc;
+
+	ns = sec * 1000000000;
+	cyc = (ns << CYC2NS_SCALE_FACTOR)/(per_cpu(cyc2ns, smp_processor_id()));
+	return cyc;
 }
 
 /*
- * Our retries are blocked by all destination swack resources being
+ * Our retries are blocked by all destination sw ack resources being
  * in use, and a timeout is pending. In that case hardware immediately
  * returns the ERROR that looks like a destination timeout.
  */
-static void
-destination_plugged(struct bau_desc *bau_desc, struct bau_control *bcp,
+static void destination_plugged(struct bau_desc *bau_desc,
+			struct bau_control *bcp,
 			struct bau_control *hmaster, struct ptc_stats *stat)
 {
 	udelay(bcp->plugged_delay);
 	bcp->plugged_tries++;
+
 	if (bcp->plugged_tries >= bcp->plugsb4reset) {
 		bcp->plugged_tries = 0;
+
 		quiesce_local_uvhub(hmaster);
+
 		spin_lock(&hmaster->queue_lock);
-		uv_reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		reset_with_ipi(&bau_desc->distribution, bcp->cpu);
 		spin_unlock(&hmaster->queue_lock);
+
 		end_uvhub_quiesce(hmaster);
+
 		bcp->ipi_attempts++;
 		stat->s_resets_plug++;
 	}
 }
 
-static void
-destination_timeout(struct bau_desc *bau_desc, struct bau_control *bcp,
-			struct bau_control *hmaster, struct ptc_stats *stat)
+static void destination_timeout(struct bau_desc *bau_desc,
+			struct bau_control *bcp, struct bau_control *hmaster,
+			struct ptc_stats *stat)
 {
-	hmaster->max_bau_concurrent = 1;
+	hmaster->max_concurr = 1;
 	bcp->timeout_tries++;
 	if (bcp->timeout_tries >= bcp->timeoutsb4reset) {
 		bcp->timeout_tries = 0;
+
 		quiesce_local_uvhub(hmaster);
+
 		spin_lock(&hmaster->queue_lock);
-		uv_reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		reset_with_ipi(&bau_desc->distribution, bcp->cpu);
 		spin_unlock(&hmaster->queue_lock);
+
 		end_uvhub_quiesce(hmaster);
+
 		bcp->ipi_attempts++;
 		stat->s_resets_timeout++;
 	}
@@ -530,34 +640,104 @@ destination_timeout(struct bau_desc *bau_desc, struct bau_control *bcp,
  * Completions are taking a very long time due to a congested numalink
  * network.
  */
-static void
-disable_for_congestion(struct bau_control *bcp, struct ptc_stats *stat)
+static void disable_for_congestion(struct bau_control *bcp,
+					struct ptc_stats *stat)
 {
-	int tcpu;
-	struct bau_control *tbcp;
-
 	/* let only one cpu do this disabling */
 	spin_lock(&disable_lock);
+
 	if (!baudisabled && bcp->period_requests &&
 	    ((bcp->period_time / bcp->period_requests) > congested_cycles)) {
+		int tcpu;
+		struct bau_control *tbcp;
 		/* it becomes this cpu's job to turn on the use of the
 		   BAU again */
 		baudisabled = 1;
 		bcp->set_bau_off = 1;
-		bcp->set_bau_on_time = get_cycles() +
-			sec_2_cycles(bcp->congested_period);
+		bcp->set_bau_on_time = get_cycles();
+		bcp->set_bau_on_time += sec_2_cycles(bcp->cong_period);
 		stat->s_bau_disabled++;
 		for_each_present_cpu(tcpu) {
 			tbcp = &per_cpu(bau_control, tcpu);
-				tbcp->baudisabled = 1;
+			tbcp->baudisabled = 1;
 		}
 	}
+
 	spin_unlock(&disable_lock);
 }
 
-/**
- * uv_flush_send_and_wait
- *
+static void count_max_concurr(int stat, struct bau_control *bcp,
+				struct bau_control *hmaster)
+{
+	bcp->plugged_tries = 0;
+	bcp->timeout_tries = 0;
+	if (stat != FLUSH_COMPLETE)
+		return;
+	if (bcp->conseccompletes <= bcp->complete_threshold)
+		return;
+	if (hmaster->max_concurr >= hmaster->max_concurr_const)
+		return;
+	hmaster->max_concurr++;
+}
+
+static void record_send_stats(cycles_t time1, cycles_t time2,
+		struct bau_control *bcp, struct ptc_stats *stat,
+		int completion_status, int try)
+{
+	cycles_t elapsed;
+
+	if (time2 > time1) {
+		elapsed = time2 - time1;
+		stat->s_time += elapsed;
+
+		if ((completion_status == FLUSH_COMPLETE) && (try == 1)) {
+			bcp->period_requests++;
+			bcp->period_time += elapsed;
+			if ((elapsed > congested_cycles) &&
+			    (bcp->period_requests > bcp->cong_reps))
+				disable_for_congestion(bcp, stat);
+		}
+	} else
+		stat->s_requestor--;
+
+	if (completion_status == FLUSH_COMPLETE && try > 1)
+		stat->s_retriesok++;
+	else if (completion_status == FLUSH_GIVEUP)
+		stat->s_giveup++;
+}
+
+/*
+ * Because of a uv1 hardware bug only a limited number of concurrent
+ * requests can be made.
+ */
+static void uv1_throttle(struct bau_control *hmaster, struct ptc_stats *stat)
+{
+	spinlock_t *lock = &hmaster->uvhub_lock;
+	atomic_t *v;
+
+	v = &hmaster->active_descriptor_count;
+	if (!atomic_inc_unless_ge(lock, v, hmaster->max_concurr)) {
+		stat->s_throttles++;
+		do {
+			cpu_relax();
+		} while (!atomic_inc_unless_ge(lock, v, hmaster->max_concurr));
+	}
+}
+
+/*
+ * Handle the completion status of a message send.
+ */
+static void handle_cmplt(int completion_status, struct bau_desc *bau_desc,
+			struct bau_control *bcp, struct bau_control *hmaster,
+			struct ptc_stats *stat)
+{
+	if (completion_status == FLUSH_RETRY_PLUGGED)
+		destination_plugged(bau_desc, bcp, hmaster, stat);
+	else if (completion_status == FLUSH_RETRY_TIMEOUT)
+		destination_timeout(bau_desc, bcp, hmaster, stat);
+}
+
+/*
  * Send a broadcast and wait for it to complete.
  *
  * The flush_mask contains the cpus the broadcast is to be sent to including
@@ -568,44 +748,23 @@ disable_for_congestion(struct bau_control *bcp, struct ptc_stats *stat)
  * returned to the kernel.
  */
 int uv_flush_send_and_wait(struct bau_desc *bau_desc,
-			   struct cpumask *flush_mask, struct bau_control *bcp)
+			struct cpumask *flush_mask, struct bau_control *bcp)
 {
-	int right_shift;
-	int completion_status = 0;
 	int seq_number = 0;
+	int completion_stat = 0;
 	long try = 0;
-	int cpu = bcp->uvhub_cpu;
-	int this_cpu = bcp->cpu;
-	unsigned long mmr_offset;
 	unsigned long index;
 	cycles_t time1;
 	cycles_t time2;
-	cycles_t elapsed;
 	struct ptc_stats *stat = bcp->statp;
-	struct bau_control *smaster = bcp->socket_master;
 	struct bau_control *hmaster = bcp->uvhub_master;
 
-	if (!atomic_inc_unless_ge(&hmaster->uvhub_lock,
-			&hmaster->active_descriptor_count,
-			hmaster->max_bau_concurrent)) {
-		stat->s_throttles++;
-		do {
-			cpu_relax();
-		} while (!atomic_inc_unless_ge(&hmaster->uvhub_lock,
-			&hmaster->active_descriptor_count,
-			hmaster->max_bau_concurrent));
-	}
+	if (is_uv1_hub())
+		uv1_throttle(hmaster, stat);
+
 	while (hmaster->uvhub_quiesce)
 		cpu_relax();
 
-	if (cpu < UV_CPUS_PER_ACT_STATUS) {
-		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_0;
-		right_shift = cpu * UV_ACT_STATUS_SIZE;
-	} else {
-		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_1;
-		right_shift =
-		    ((cpu - UV_CPUS_PER_ACT_STATUS) * UV_ACT_STATUS_SIZE);
-	}
 	time1 = get_cycles();
 	do {
 		if (try == 0) {
@@ -615,64 +774,134 @@ int uv_flush_send_and_wait(struct bau_desc *bau_desc,
 			bau_desc->header.msg_type = MSG_RETRY;
 			stat->s_retry_messages++;
 		}
+
 		bau_desc->header.sequence = seq_number;
-		index = (1UL << UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT) |
-			bcp->uvhub_cpu;
+		index = (1UL << AS_PUSH_SHIFT) | bcp->uvhub_cpu;
 		bcp->send_message = get_cycles();
-		uv_write_local_mmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
+
+		write_mmr_activation(index);
+
 		try++;
-		completion_status = uv_wait_completion(bau_desc, mmr_offset,
-			right_shift, this_cpu, bcp, smaster, try);
+		completion_stat = wait_completion(bau_desc, bcp, try);
+
+		handle_cmplt(completion_stat, bau_desc, bcp, hmaster, stat);
 
-		if (completion_status == FLUSH_RETRY_PLUGGED) {
-			destination_plugged(bau_desc, bcp, hmaster, stat);
-		} else if (completion_status == FLUSH_RETRY_TIMEOUT) {
-			destination_timeout(bau_desc, bcp, hmaster, stat);
-		}
 		if (bcp->ipi_attempts >= bcp->ipi_reset_limit) {
 			bcp->ipi_attempts = 0;
-			completion_status = FLUSH_GIVEUP;
+			completion_stat = FLUSH_GIVEUP;
 			break;
 		}
 		cpu_relax();
-	} while ((completion_status == FLUSH_RETRY_PLUGGED) ||
-		 (completion_status == FLUSH_RETRY_TIMEOUT));
+	} while ((completion_stat == FLUSH_RETRY_PLUGGED) ||
+		 (completion_stat == FLUSH_RETRY_TIMEOUT));
+
 	time2 = get_cycles();
-	bcp->plugged_tries = 0;
-	bcp->timeout_tries = 0;
-	if ((completion_status == FLUSH_COMPLETE) &&
-	    (bcp->conseccompletes > bcp->complete_threshold) &&
-	    (hmaster->max_bau_concurrent <
-					hmaster->max_bau_concurrent_constant))
-			hmaster->max_bau_concurrent++;
+
+	count_max_concurr(completion_stat, bcp, hmaster);
+
 	while (hmaster->uvhub_quiesce)
 		cpu_relax();
+
 	atomic_dec(&hmaster->active_descriptor_count);
-	if (time2 > time1) {
-		elapsed = time2 - time1;
-		stat->s_time += elapsed;
-		if ((completion_status == FLUSH_COMPLETE) && (try == 1)) {
-			bcp->period_requests++;
-			bcp->period_time += elapsed;
-			if ((elapsed > congested_cycles) &&
-			    (bcp->period_requests > bcp->congested_reps)) {
-				disable_for_congestion(bcp, stat);
+
+	record_send_stats(time1, time2, bcp, stat, completion_stat, try);
+
+	if (completion_stat == FLUSH_GIVEUP)
+		return 1;
+	return 0;
+}
+
+/*
+ * The BAU is disabled. When the disabled time period has expired, the cpu
+ * that disabled it must re-enable it.
+ * Return 0 if it is re-enabled for all cpus.
+ */
+static int check_enable(struct bau_control *bcp, struct ptc_stats *stat)
+{
+	int tcpu;
+	struct bau_control *tbcp;
+
+	if (bcp->set_bau_off) {
+		if (get_cycles() >= bcp->set_bau_on_time) {
+			stat->s_bau_reenabled++;
+			baudisabled = 0;
+			for_each_present_cpu(tcpu) {
+				tbcp = &per_cpu(bau_control, tcpu);
+				tbcp->baudisabled = 0;
+				tbcp->period_requests = 0;
+				tbcp->period_time = 0;
 			}
+			return 0;
 		}
+	}
+	return -1;
+}
+
+static void record_send_statistics(struct ptc_stats *stat, int locals, int hubs,
+				int remotes, struct bau_desc *bau_desc)
+{
+	stat->s_requestor++;
+	stat->s_ntargcpu += remotes + locals;
+	stat->s_ntargremotes += remotes;
+	stat->s_ntarglocals += locals;
+
+	/* uvhub statistics */
+	hubs = bau_uvhub_weight(&bau_desc->distribution);
+	if (locals) {
+		stat->s_ntarglocaluvhub++;
+		stat->s_ntargremoteuvhub += (hubs - 1);
 	} else
-		stat->s_requestor--;
-	if (completion_status == FLUSH_COMPLETE && try > 1)
-		stat->s_retriesok++;
-	else if (completion_status == FLUSH_GIVEUP) {
-		stat->s_giveup++;
-		return 1;
+		stat->s_ntargremoteuvhub += hubs;
+
+	stat->s_ntarguvhub += hubs;
+
+	if (hubs >= 16)
+		stat->s_ntarguvhub16++;
+	else if (hubs >= 8)
+		stat->s_ntarguvhub8++;
+	else if (hubs >= 4)
+		stat->s_ntarguvhub4++;
+	else if (hubs >= 2)
+		stat->s_ntarguvhub2++;
+	else
+		stat->s_ntarguvhub1++;
+}
+
+/*
+ * Translate a cpu mask to the uvhub distribution mask in the BAU
+ * activation descriptor.
+ */
+static int set_distrib_bits(struct cpumask *flush_mask, struct bau_control *bcp,
+			struct bau_desc *bau_desc, int *localsp, int *remotesp)
+{
+	int cpu;
+	int pnode;
+	int cnt = 0;
+	struct hub_and_pnode *hpp;
+
+	for_each_cpu(cpu, flush_mask) {
+		/*
+		 * The distribution vector is a bit map of pnodes, relative
+		 * to the partition base pnode (and the partition base nasid
+		 * in the header).
+		 * Translate cpu to pnode and hub using a local memory array.
+		 */
+		hpp = &bcp->socket_master->thp[cpu];
+		pnode = hpp->pnode - bcp->partition_base_pnode;
+		bau_uvhub_set(pnode, &bau_desc->distribution);
+		cnt++;
+		if (hpp->uvhub == bcp->uvhub)
+			(*localsp)++;
+		else
+			(*remotesp)++;
 	}
+	if (!cnt)
+		return 1;
 	return 0;
 }
 
-/**
- * uv_flush_tlb_others - globally purge translation cache of a virtual
- * address or all TLB's
+/*
+ * globally purge translation cache of a virtual address or all TLB's
  * @cpumask: mask of all cpu's in which the address is to be removed
  * @mm: mm_struct containing virtual address range
  * @va: virtual address to be removed (or TLB_FLUSH_ALL for all TLB's on cpu)
@@ -696,20 +925,16 @@ int uv_flush_send_and_wait(struct bau_desc *bau_desc,
  * done.  The returned pointer is valid till preemption is re-enabled.
  */
 const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
-					  struct mm_struct *mm,
-					  unsigned long va, unsigned int cpu)
+				struct mm_struct *mm, unsigned long va,
+				unsigned int cpu)
 {
 	int locals = 0;
 	int remotes = 0;
 	int hubs = 0;
-	int tcpu;
-	int tpnode;
 	struct bau_desc *bau_desc;
 	struct cpumask *flush_mask;
 	struct ptc_stats *stat;
 	struct bau_control *bcp;
-	struct bau_control *tbcp;
-	struct hub_and_pnode *hpp;
 
 	/* kernel was booted 'nobau' */
 	if (nobau)
@@ -720,20 +945,8 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 
 	/* bau was disabled due to slow response */
 	if (bcp->baudisabled) {
-		/* the cpu that disabled it must re-enable it */
-		if (bcp->set_bau_off) {
-			if (get_cycles() >= bcp->set_bau_on_time) {
-				stat->s_bau_reenabled++;
-				baudisabled = 0;
-				for_each_present_cpu(tcpu) {
-					tbcp = &per_cpu(bau_control, tcpu);
-					tbcp->baudisabled = 0;
-					tbcp->period_requests = 0;
-					tbcp->period_time = 0;
-				}
-			}
-		}
-		return cpumask;
+		if (check_enable(bcp, stat))
+			return cpumask;
 	}
 
 	/*
@@ -744,59 +957,20 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 	flush_mask = (struct cpumask *)per_cpu(uv_flush_tlb_mask, cpu);
 	/* don't actually do a shootdown of the local cpu */
 	cpumask_andnot(flush_mask, cpumask, cpumask_of(cpu));
+
 	if (cpu_isset(cpu, *cpumask))
 		stat->s_ntargself++;
 
 	bau_desc = bcp->descriptor_base;
-	bau_desc += UV_ITEMS_PER_DESCRIPTOR * bcp->uvhub_cpu;
+	bau_desc += ITEMS_PER_DESC * bcp->uvhub_cpu;
 	bau_uvhubs_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
-
-	for_each_cpu(tcpu, flush_mask) {
-		/*
-		 * The distribution vector is a bit map of pnodes, relative
-		 * to the partition base pnode (and the partition base nasid
-		 * in the header).
-		 * Translate cpu to pnode and hub using an array stored
-		 * in local memory.
-		 */
-		hpp = &bcp->socket_master->target_hub_and_pnode[tcpu];
-		tpnode = hpp->pnode - bcp->partition_base_pnode;
-		bau_uvhub_set(tpnode, &bau_desc->distribution);
-		if (hpp->uvhub == bcp->uvhub)
-			locals++;
-		else
-			remotes++;
-	}
-	if ((locals + remotes) == 0)
+	if (set_distrib_bits(flush_mask, bcp, bau_desc, &locals, &remotes))
 		return NULL;
-	stat->s_requestor++;
-	stat->s_ntargcpu += remotes + locals;
-	stat->s_ntargremotes += remotes;
-	stat->s_ntarglocals += locals;
-	remotes = bau_uvhub_weight(&bau_desc->distribution);
 
-	/* uvhub statistics */
-	hubs = bau_uvhub_weight(&bau_desc->distribution);
-	if (locals) {
-		stat->s_ntarglocaluvhub++;
-		stat->s_ntargremoteuvhub += (hubs - 1);
-	} else
-		stat->s_ntargremoteuvhub += hubs;
-	stat->s_ntarguvhub += hubs;
-	if (hubs >= 16)
-		stat->s_ntarguvhub16++;
-	else if (hubs >= 8)
-		stat->s_ntarguvhub8++;
-	else if (hubs >= 4)
-		stat->s_ntarguvhub4++;
-	else if (hubs >= 2)
-		stat->s_ntarguvhub2++;
-	else
-		stat->s_ntarguvhub1++;
+	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 
 	bau_desc->payload.address = va;
 	bau_desc->payload.sending_cpu = cpu;
-
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
 	 * or 1 if it gave up and the original cpumask should be returned.
@@ -825,26 +999,31 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
 {
 	int count = 0;
 	cycles_t time_start;
-	struct bau_payload_queue_entry *msg;
+	struct bau_pq_entry *msg;
 	struct bau_control *bcp;
 	struct ptc_stats *stat;
 	struct msg_desc msgdesc;
 
 	time_start = get_cycles();
+
 	bcp = &per_cpu(bau_control, smp_processor_id());
 	stat = bcp->statp;
-	msgdesc.va_queue_first = bcp->va_queue_first;
-	msgdesc.va_queue_last = bcp->va_queue_last;
+
+	msgdesc.queue_first = bcp->queue_first;
+	msgdesc.queue_last = bcp->queue_last;
+
 	msg = bcp->bau_msg_head;
-	while (msg->sw_ack_vector) {
+	while (msg->swack_vec) {
 		count++;
-		msgdesc.msg_slot = msg - msgdesc.va_queue_first;
-		msgdesc.sw_ack_slot = ffs(msg->sw_ack_vector) - 1;
+
+		msgdesc.msg_slot = msg - msgdesc.queue_first;
+		msgdesc.swack_slot = ffs(msg->swack_vec) - 1;
 		msgdesc.msg = msg;
-		uv_bau_process_message(&msgdesc, bcp);
+		bau_process_message(&msgdesc, bcp);
+
 		msg++;
-		if (msg > msgdesc.va_queue_last)
-			msg = msgdesc.va_queue_first;
+		if (msg > msgdesc.queue_last)
+			msg = msgdesc.queue_first;
 		bcp->bau_msg_head = msg;
 	}
 	stat->d_time += (get_cycles() - time_start);
@@ -852,18 +1031,17 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
 		stat->d_nomsg++;
 	else if (count > 1)
 		stat->d_multmsg++;
+
 	ack_APIC_irq();
 }
 
 /*
- * uv_enable_timeouts
- *
- * Each target uvhub (i.e. a uvhub that has no cpu's) needs to have
+ * Each target uvhub (i.e. a uvhub that has cpu's) needs to have
  * shootdown message timeouts enabled.  The timeout does not cause
  * an interrupt, but causes an error message to be returned to
  * the sender.
  */
-static void __init uv_enable_timeouts(void)
+static void __init enable_timeouts(void)
 {
 	int uvhub;
 	int nuvhubs;
@@ -877,47 +1055,44 @@ static void __init uv_enable_timeouts(void)
 			continue;
 
 		pnode = uv_blade_to_pnode(uvhub);
-		mmr_image =
-		    uv_read_global_mmr64(pnode, UVH_LB_BAU_MISC_CONTROL);
+		mmr_image = read_mmr_misc_control(pnode);
 		/*
 		 * Set the timeout period and then lock it in, in three
 		 * steps; captures and locks in the period.
 		 *
 		 * To program the period, the SOFT_ACK_MODE must be off.
 		 */
-		mmr_image &= ~((unsigned long)1 <<
-		    UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT);
-		uv_write_global_mmr64
-		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+		mmr_image &= ~(1L << SOFTACK_MSHIFT);
+		write_mmr_misc_control(pnode, mmr_image);
 		/*
 		 * Set the 4-bit period.
 		 */
-		mmr_image &= ~((unsigned long)0xf <<
-		     UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT);
-		mmr_image |= (UV_INTD_SOFT_ACK_TIMEOUT_PERIOD <<
-		     UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT);
-		uv_write_global_mmr64
-		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+		mmr_image &= ~((unsigned long)0xf << SOFTACK_PSHIFT);
+		mmr_image |= (SOFTACK_TIMEOUT_PERIOD << SOFTACK_PSHIFT);
+		write_mmr_misc_control(pnode, mmr_image);
 		/*
+		 * UV1:
 		 * Subsequent reversals of the timebase bit (3) cause an
 		 * immediate timeout of one or all INTD resources as
 		 * indicated in bits 2:0 (7 causes all of them to timeout).
 		 */
-		mmr_image |= ((unsigned long)1 <<
-		    UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT);
-		uv_write_global_mmr64
-		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+		mmr_image |= (1L << SOFTACK_MSHIFT);
+		if (is_uv2_hub()) {
+			mmr_image |= (1L << UV2_LEG_SHFT);
+			mmr_image |= (1L << UV2_EXT_SHFT);
+		}
+		write_mmr_misc_control(pnode, mmr_image);
 	}
 }
 
-static void *uv_ptc_seq_start(struct seq_file *file, loff_t *offset)
+static void *ptc_seq_start(struct seq_file *file, loff_t *offset)
 {
 	if (*offset < num_possible_cpus())
 		return offset;
 	return NULL;
 }
 
-static void *uv_ptc_seq_next(struct seq_file *file, void *data, loff_t *offset)
+static void *ptc_seq_next(struct seq_file *file, void *data, loff_t *offset)
 {
 	(*offset)++;
 	if (*offset < num_possible_cpus())
@@ -925,12 +1100,11 @@ static void *uv_ptc_seq_next(struct seq_file *file, void *data, loff_t *offset)
 	return NULL;
 }
 
-static void uv_ptc_seq_stop(struct seq_file *file, void *data)
+static void ptc_seq_stop(struct seq_file *file, void *data)
 {
 }
 
-static inline unsigned long long
-microsec_2_cycles(unsigned long microsec)
+static inline unsigned long long usec_2_cycles(unsigned long microsec)
 {
 	unsigned long ns;
 	unsigned long long cyc;
@@ -941,29 +1115,27 @@ microsec_2_cycles(unsigned long microsec)
 }
 
 /*
- * Display the statistics thru /proc.
+ * Display the statistics thru /proc/sgi_uv/ptc_statistics
  * 'data' points to the cpu number
+ * Note: see the descriptions in stat_description[].
  */
-static int uv_ptc_seq_show(struct seq_file *file, void *data)
+static int ptc_seq_show(struct seq_file *file, void *data)
 {
 	struct ptc_stats *stat;
 	int cpu;
 
 	cpu = *(loff_t *)data;
-
 	if (!cpu) {
 		seq_printf(file,
 			"# cpu sent stime self locals remotes ncpus localhub ");
 		seq_printf(file,
 			"remotehub numuvhubs numuvhubs16 numuvhubs8 ");
 		seq_printf(file,
-			"numuvhubs4 numuvhubs2 numuvhubs1 dto ");
-		seq_printf(file,
-			"retries rok resetp resett giveup sto bz throt ");
+			"numuvhubs4 numuvhubs2 numuvhubs1 dto retries rok ");
 		seq_printf(file,
-			"sw_ack recv rtime all ");
+			"resetp resett giveup sto bz throt swack recv rtime ");
 		seq_printf(file,
-			"one mult none retry canc nocan reset rcan ");
+			"all one mult none retry canc nocan reset rcan ");
 		seq_printf(file,
 			"disable enable\n");
 	}
@@ -990,8 +1162,7 @@ static int uv_ptc_seq_show(struct seq_file *file, void *data)
 		/* destination side statistics */
 		seq_printf(file,
 			   "%lx %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld ",
-			   uv_read_global_mmr64(uv_cpu_to_pnode(cpu),
-					UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE),
+			   read_gmmr_sw_ack(uv_cpu_to_pnode(cpu)),
 			   stat->d_requestee, cycles_2_us(stat->d_time),
 			   stat->d_alltlb, stat->d_onetlb, stat->d_multmsg,
 			   stat->d_nomsg, stat->d_retries, stat->d_canceled,
@@ -1000,7 +1171,6 @@ static int uv_ptc_seq_show(struct seq_file *file, void *data)
 		seq_printf(file, "%ld %ld\n",
 			stat->s_bau_disabled, stat->s_bau_reenabled);
 	}
-
 	return 0;
 }
 
@@ -1008,18 +1178,18 @@ static int uv_ptc_seq_show(struct seq_file *file, void *data)
  * Display the tunables thru debugfs
  */
 static ssize_t tunables_read(struct file *file, char __user *userbuf,
-						size_t count, loff_t *ppos)
+				size_t count, loff_t *ppos)
 {
 	char *buf;
 	int ret;
 
 	buf = kasprintf(GFP_KERNEL, "%s %s %s\n%d %d %d %d %d %d %d %d %d\n",
-		"max_bau_concurrent plugged_delay plugsb4reset",
+		"max_concur plugged_delay plugsb4reset",
 		"timeoutsb4reset ipi_reset_limit complete_threshold",
 		"congested_response_us congested_reps congested_period",
-		max_bau_concurrent, plugged_delay, plugsb4reset,
+		max_concurr, plugged_delay, plugsb4reset,
 		timeoutsb4reset, ipi_reset_limit, complete_threshold,
-		congested_response_us, congested_reps, congested_period);
+		congested_respns_us, congested_reps, congested_period);
 
 	if (!buf)
 		return -ENOMEM;
@@ -1030,13 +1200,16 @@ static ssize_t tunables_read(struct file *file, char __user *userbuf,
 }
 
 /*
- * -1: resetf the statistics
+ * handle a write to /proc/sgi_uv/ptc_statistics
+ * -1: reset the statistics
  *  0: display meaning of the statistics
  */
-static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
-				 size_t count, loff_t *data)
+static ssize_t ptc_proc_write(struct file *file, const char __user *user,
+				size_t count, loff_t *data)
 {
 	int cpu;
+	int i;
+	int elements;
 	long input_arg;
 	char optstr[64];
 	struct ptc_stats *stat;
@@ -1046,79 +1219,18 @@ static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
 	if (copy_from_user(optstr, user, count))
 		return -EFAULT;
 	optstr[count - 1] = '\0';
+
 	if (strict_strtol(optstr, 10, &input_arg) < 0) {
 		printk(KERN_DEBUG "%s is invalid\n", optstr);
 		return -EINVAL;
 	}
 
 	if (input_arg == 0) {
+		elements = sizeof(stat_description)/sizeof(*stat_description);
 		printk(KERN_DEBUG "# cpu:      cpu number\n");
 		printk(KERN_DEBUG "Sender statistics:\n");
-		printk(KERN_DEBUG
-		"sent:     number of shootdown messages sent\n");
-		printk(KERN_DEBUG
-		"stime:    time spent sending messages\n");
-		printk(KERN_DEBUG
-		"numuvhubs: number of hubs targeted with shootdown\n");
-		printk(KERN_DEBUG
-		"numuvhubs16: number times 16 or more hubs targeted\n");
-		printk(KERN_DEBUG
-		"numuvhubs8: number times 8 or more hubs targeted\n");
-		printk(KERN_DEBUG
-		"numuvhubs4: number times 4 or more hubs targeted\n");
-		printk(KERN_DEBUG
-		"numuvhubs2: number times 2 or more hubs targeted\n");
-		printk(KERN_DEBUG
-		"numuvhubs1: number times 1 hub targeted\n");
-		printk(KERN_DEBUG
-		"numcpus:  number of cpus targeted with shootdown\n");
-		printk(KERN_DEBUG
-		"dto:      number of destination timeouts\n");
-		printk(KERN_DEBUG
-		"retries:  destination timeout retries sent\n");
-		printk(KERN_DEBUG
-		"rok:   :  destination timeouts successfully retried\n");
-		printk(KERN_DEBUG
-		"resetp:   ipi-style resource resets for plugs\n");
-		printk(KERN_DEBUG
-		"resett:   ipi-style resource resets for timeouts\n");
-		printk(KERN_DEBUG
-		"giveup:   fall-backs to ipi-style shootdowns\n");
-		printk(KERN_DEBUG
-		"sto:      number of source timeouts\n");
-		printk(KERN_DEBUG
-		"bz:       number of stay-busy's\n");
-		printk(KERN_DEBUG
-		"throt:    number times spun in throttle\n");
-		printk(KERN_DEBUG "Destination side statistics:\n");
-		printk(KERN_DEBUG
-		"sw_ack:   image of UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE\n");
-		printk(KERN_DEBUG
-		"recv:     shootdown messages received\n");
-		printk(KERN_DEBUG
-		"rtime:    time spent processing messages\n");
-		printk(KERN_DEBUG
-		"all:      shootdown all-tlb messages\n");
-		printk(KERN_DEBUG
-		"one:      shootdown one-tlb messages\n");
-		printk(KERN_DEBUG
-		"mult:     interrupts that found multiple messages\n");
-		printk(KERN_DEBUG
-		"none:     interrupts that found no messages\n");
-		printk(KERN_DEBUG
-		"retry:    number of retry messages processed\n");
-		printk(KERN_DEBUG
-		"canc:     number messages canceled by retries\n");
-		printk(KERN_DEBUG
-		"nocan:    number retries that found nothing to cancel\n");
-		printk(KERN_DEBUG
-		"reset:    number of ipi-style reset requests processed\n");
-		printk(KERN_DEBUG
-		"rcan:     number messages canceled by reset requests\n");
-		printk(KERN_DEBUG
-		"disable:  number times use of the BAU was disabled\n");
-		printk(KERN_DEBUG
-		"enable:   number times use of the BAU was re-enabled\n");
+		for (i = 0; i < elements; i++)
+			printk(KERN_DEBUG "%s\n", stat_description[i]);
 	} else if (input_arg == -1) {
 		for_each_present_cpu(cpu) {
 			stat = &per_cpu(ptcstats, cpu);
@@ -1145,27 +1257,18 @@ static int local_atoi(const char *name)
 }
 
 /*
- * set the tunables
- * 0 values reset them to defaults
+ * Parse the values written to /sys/kernel/debug/sgi_uv/bau_tunables.
+ * Zero values reset them to defaults.
  */
-static ssize_t tunables_write(struct file *file, const char __user *user,
-				 size_t count, loff_t *data)
+static int parse_tunables_write(struct bau_control *bcp, char *instr,
+				int count)
 {
-	int cpu;
-	int cnt = 0;
-	int val;
 	char *p;
 	char *q;
-	char instr[64];
-	struct bau_control *bcp;
-
-	if (count == 0 || count > sizeof(instr)-1)
-		return -EINVAL;
-	if (copy_from_user(instr, user, count))
-		return -EFAULT;
+	int cnt = 0;
+	int val;
+	int e = sizeof(tunables) / sizeof(*tunables);
 
-	instr[count] = '\0';
-	/* count the fields */
 	p = instr + strspn(instr, WHITESPACE);
 	q = p;
 	for (; *p; p = q + strspn(q, WHITESPACE)) {
@@ -1174,8 +1277,8 @@ static ssize_t tunables_write(struct file *file, const char __user *user,
 		if (q == p)
 			break;
 	}
-	if (cnt != 9) {
-		printk(KERN_INFO "bau tunable error: should be 9 numbers\n");
+	if (cnt != e) {
+		printk(KERN_INFO "bau tunable error: should be %d values\n", e);
 		return -EINVAL;
 	}
 
@@ -1187,97 +1290,80 @@ static ssize_t tunables_write(struct file *file, const char __user *user,
 		switch (cnt) {
 		case 0:
 			if (val == 0) {
-				max_bau_concurrent = MAX_BAU_CONCURRENT;
-				max_bau_concurrent_constant =
-							MAX_BAU_CONCURRENT;
+				max_concurr = MAX_BAU_CONCURRENT;
+				max_concurr_const = MAX_BAU_CONCURRENT;
 				continue;
 			}
-			bcp = &per_cpu(bau_control, smp_processor_id());
 			if (val < 1 || val > bcp->cpus_in_uvhub) {
 				printk(KERN_DEBUG
 				"Error: BAU max concurrent %d is invalid\n",
 				val);
 				return -EINVAL;
 			}
-			max_bau_concurrent = val;
-			max_bau_concurrent_constant = val;
-			continue;
-		case 1:
-			if (val == 0)
-				plugged_delay = PLUGGED_DELAY;
-			else
-				plugged_delay = val;
-			continue;
-		case 2:
-			if (val == 0)
-				plugsb4reset = PLUGSB4RESET;
-			else
-				plugsb4reset = val;
-			continue;
-		case 3:
-			if (val == 0)
-				timeoutsb4reset = TIMEOUTSB4RESET;
-			else
-				timeoutsb4reset = val;
-			continue;
-		case 4:
-			if (val == 0)
-				ipi_reset_limit = IPI_RESET_LIMIT;
-			else
-				ipi_reset_limit = val;
-			continue;
-		case 5:
-			if (val == 0)
-				complete_threshold = COMPLETE_THRESHOLD;
-			else
-				complete_threshold = val;
-			continue;
-		case 6:
-			if (val == 0)
-				congested_response_us = CONGESTED_RESPONSE_US;
-			else
-				congested_response_us = val;
-			continue;
-		case 7:
-			if (val == 0)
-				congested_reps = CONGESTED_REPS;
-			else
-				congested_reps = val;
+			max_concurr = val;
+			max_concurr_const = val;
 			continue;
-		case 8:
+		default:
 			if (val == 0)
-				congested_period = CONGESTED_PERIOD;
+				*tunables[cnt].tunp = tunables[cnt].deflt;
 			else
-				congested_period = val;
+				*tunables[cnt].tunp = val;
 			continue;
 		}
 		if (q == p)
 			break;
 	}
+	return 0;
+}
+
+/*
+ * Handle a write to debugfs. (/sys/kernel/debug/sgi_uv/bau_tunables)
+ */
+static ssize_t tunables_write(struct file *file, const char __user *user,
+				size_t count, loff_t *data)
+{
+	int cpu;
+	int ret;
+	char instr[100];
+	struct bau_control *bcp;
+
+	if (count == 0 || count > sizeof(instr)-1)
+		return -EINVAL;
+	if (copy_from_user(instr, user, count))
+		return -EFAULT;
+
+	instr[count] = '\0';
+
+	bcp = &per_cpu(bau_control, smp_processor_id());
+
+	ret = parse_tunables_write(bcp, instr, count);
+	if (ret)
+		return ret;
+
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
-		bcp->max_bau_concurrent = max_bau_concurrent;
-		bcp->max_bau_concurrent_constant = max_bau_concurrent;
-		bcp->plugged_delay = plugged_delay;
-		bcp->plugsb4reset = plugsb4reset;
-		bcp->timeoutsb4reset = timeoutsb4reset;
-		bcp->ipi_reset_limit = ipi_reset_limit;
-		bcp->complete_threshold = complete_threshold;
-		bcp->congested_response_us = congested_response_us;
-		bcp->congested_reps = congested_reps;
-		bcp->congested_period = congested_period;
+		bcp->max_concurr =		max_concurr;
+		bcp->max_concurr_const =	max_concurr;
+		bcp->plugged_delay =		plugged_delay;
+		bcp->plugsb4reset =		plugsb4reset;
+		bcp->timeoutsb4reset =		timeoutsb4reset;
+		bcp->ipi_reset_limit =		ipi_reset_limit;
+		bcp->complete_threshold =	complete_threshold;
+		bcp->cong_response_us =		congested_respns_us;
+		bcp->cong_reps =		congested_reps;
+		bcp->cong_period =		congested_period;
 	}
 	return count;
 }
 
 static const struct seq_operations uv_ptc_seq_ops = {
-	.start		= uv_ptc_seq_start,
-	.next		= uv_ptc_seq_next,
-	.stop		= uv_ptc_seq_stop,
-	.show		= uv_ptc_seq_show
+	.start		= ptc_seq_start,
+	.next		= ptc_seq_next,
+	.stop		= ptc_seq_stop,
+	.show		= ptc_seq_show
 };
 
-static int uv_ptc_proc_open(struct inode *inode, struct file *file)
+static int ptc_proc_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &uv_ptc_seq_ops);
 }
@@ -1288,9 +1374,9 @@ static int tunables_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations proc_uv_ptc_operations = {
-	.open		= uv_ptc_proc_open,
+	.open		= ptc_proc_open,
 	.read		= seq_read,
-	.write		= uv_ptc_proc_write,
+	.write		= ptc_proc_write,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
@@ -1324,7 +1410,7 @@ static int __init uv_ptc_init(void)
 		return -EINVAL;
 	}
 	tunables_file = debugfs_create_file(UV_BAU_TUNABLES_FILE, 0600,
-			tunables_dir, NULL, &tunables_fops);
+					tunables_dir, NULL, &tunables_fops);
 	if (!tunables_file) {
 		printk(KERN_ERR "unable to create debugfs file %s\n",
 		       UV_BAU_TUNABLES_FILE);
@@ -1336,24 +1422,24 @@ static int __init uv_ptc_init(void)
 /*
  * Initialize the sending side's sending buffers.
  */
-static void
-uv_activation_descriptor_init(int node, int pnode, int base_pnode)
+static void activation_descriptor_init(int node, int pnode, int base_pnode)
 {
 	int i;
 	int cpu;
 	unsigned long pa;
 	unsigned long m;
 	unsigned long n;
+	size_t dsize;
 	struct bau_desc *bau_desc;
 	struct bau_desc *bd2;
 	struct bau_control *bcp;
 
 	/*
-	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
-	 * per cpu; and one per cpu on the uvhub (UV_ADP_SIZE)
+	 * each bau_desc is 64 bytes; there are 8 (ITEMS_PER_DESC)
+	 * per cpu; and one per cpu on the uvhub (ADP_SZ)
 	 */
-	bau_desc = kmalloc_node(sizeof(struct bau_desc) * UV_ADP_SIZE
-				* UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
+	dsize = sizeof(struct bau_desc) * ADP_SZ * ITEMS_PER_DESC;
+	bau_desc = kmalloc_node(dsize, GFP_KERNEL, node);
 	BUG_ON(!bau_desc);
 
 	pa = uv_gpa(bau_desc); /* need the real nasid*/
@@ -1361,27 +1447,25 @@ uv_activation_descriptor_init(int node, int pnode, int base_pnode)
 	m = pa & uv_mmask;
 
 	/* the 14-bit pnode */
-	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE,
-			      (n << UV_DESC_BASE_PNODE_SHIFT | m));
+	write_mmr_descriptor_base(pnode, (n << UV_DESC_PSHIFT | m));
 	/*
-	 * Initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
+	 * Initializing all 8 (ITEMS_PER_DESC) descriptors for each
 	 * cpu even though we only use the first one; one descriptor can
 	 * describe a broadcast to 256 uv hubs.
 	 */
-	for (i = 0, bd2 = bau_desc; i < (UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR);
-		i++, bd2++) {
+	for (i = 0, bd2 = bau_desc; i < (ADP_SZ * ITEMS_PER_DESC); i++, bd2++) {
 		memset(bd2, 0, sizeof(struct bau_desc));
-		bd2->header.sw_ack_flag = 1;
+		bd2->header.swack_flag =	1;
 		/*
 		 * The base_dest_nasid set in the message header is the nasid
 		 * of the first uvhub in the partition. The bit map will
 		 * indicate destination pnode numbers relative to that base.
 		 * They may not be consecutive if nasid striding is being used.
 		 */
-		bd2->header.base_dest_nasid = UV_PNODE_TO_NASID(base_pnode);
-		bd2->header.dest_subnodeid = UV_LB_SUBNODEID;
-		bd2->header.command = UV_NET_ENDPOINT_INTD;
-		bd2->header.int_both = 1;
+		bd2->header.base_dest_nasid =	UV_PNODE_TO_NASID(base_pnode);
+		bd2->header.dest_subnodeid =	UV_LB_SUBNODEID;
+		bd2->header.command =		UV_NET_ENDPOINT_INTD;
+		bd2->header.int_both =		1;
 		/*
 		 * all others need to be set to zero:
 		 *   fairness chaining multilevel count replied_to
@@ -1401,57 +1485,55 @@ uv_activation_descriptor_init(int node, int pnode, int base_pnode)
  * - node is first node (kernel memory notion) on the uvhub
  * - pnode is the uvhub's physical identifier
  */
-static void
-uv_payload_queue_init(int node, int pnode)
+static void pq_init(int node, int pnode)
 {
-	int pn;
 	int cpu;
+	size_t plsize;
 	char *cp;
-	unsigned long pa;
-	struct bau_payload_queue_entry *pqp;
-	struct bau_payload_queue_entry *pqp_malloc;
+	void *vp;
+	unsigned long pn;
+	unsigned long first;
+	unsigned long pn_first;
+	unsigned long last;
+	struct bau_pq_entry *pqp;
 	struct bau_control *bcp;
 
-	pqp = kmalloc_node((DEST_Q_SIZE + 1)
-			   * sizeof(struct bau_payload_queue_entry),
-			   GFP_KERNEL, node);
+	plsize = (DEST_Q_SIZE + 1) * sizeof(struct bau_pq_entry);
+	vp = kmalloc_node(plsize, GFP_KERNEL, node);
+	pqp = (struct bau_pq_entry *)vp;
 	BUG_ON(!pqp);
-	pqp_malloc = pqp;
 
 	cp = (char *)pqp + 31;
-	pqp = (struct bau_payload_queue_entry *)(((unsigned long)cp >> 5) << 5);
+	pqp = (struct bau_pq_entry *)(((unsigned long)cp >> 5) << 5);
 
 	for_each_present_cpu(cpu) {
 		if (pnode != uv_cpu_to_pnode(cpu))
 			continue;
 		/* for every cpu on this pnode: */
 		bcp = &per_cpu(bau_control, cpu);
-		bcp->va_queue_first = pqp;
-		bcp->bau_msg_head = pqp;
-		bcp->va_queue_last = pqp + (DEST_Q_SIZE - 1);
+		bcp->queue_first	= pqp;
+		bcp->bau_msg_head	= pqp;
+		bcp->queue_last		= pqp + (DEST_Q_SIZE - 1);
 	}
 	/*
 	 * need the pnode of where the memory was really allocated
 	 */
-	pa = uv_gpa(pqp);
-	pn = pa >> uv_nshift;
-	uv_write_global_mmr64(pnode,
-			      UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
-			      ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) |
-			      uv_physnodeaddr(pqp));
-	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL,
-			      uv_physnodeaddr(pqp));
-	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST,
-			      (unsigned long)
-			      uv_physnodeaddr(pqp + (DEST_Q_SIZE - 1)));
+	pn = uv_gpa(pqp) >> uv_nshift;
+	first = uv_physnodeaddr(pqp);
+	pn_first = ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) | first;
+	last = uv_physnodeaddr(pqp + (DEST_Q_SIZE - 1));
+	write_mmr_payload_first(pnode, pn_first);
+	write_mmr_payload_tail(pnode, first);
+	write_mmr_payload_last(pnode, last);
+
 	/* in effect, all msg_type's are set to MSG_NOOP */
-	memset(pqp, 0, sizeof(struct bau_payload_queue_entry) * DEST_Q_SIZE);
+	memset(pqp, 0, sizeof(struct bau_pq_entry) * DEST_Q_SIZE);
 }
 
 /*
  * Initialization of each UV hub's structures
  */
-static void __init uv_init_uvhub(int uvhub, int vector, int base_pnode)
+static void __init init_uvhub(int uvhub, int vector, int base_pnode)
 {
 	int node;
 	int pnode;
@@ -1459,24 +1541,24 @@ static void __init uv_init_uvhub(int uvhub, int vector, int base_pnode)
 
 	node = uvhub_to_first_node(uvhub);
 	pnode = uv_blade_to_pnode(uvhub);
-	uv_activation_descriptor_init(node, pnode, base_pnode);
-	uv_payload_queue_init(node, pnode);
+
+	activation_descriptor_init(node, pnode, base_pnode);
+
+	pq_init(node, pnode);
 	/*
 	 * The below initialization can't be in firmware because the
 	 * messaging IRQ will be determined by the OS.
 	 */
 	apicid = uvhub_to_first_apicid(uvhub) | uv_apicid_hibits;
-	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
-				      ((apicid << 32) | vector));
+	write_mmr_data_config(pnode, ((apicid << 32) | vector));
 }
 
 /*
  * We will set BAU_MISC_CONTROL with a timeout period.
  * But the BIOS has set UVH_AGING_PRESCALE_SEL and UVH_TRANSACTION_TIMEOUT.
- * So the destination timeout period has be be calculated from them.
+ * So the destination timeout period has to be calculated from them.
  */
-static int
-calculate_destination_timeout(void)
+static int calculate_destination_timeout(void)
 {
 	unsigned long mmr_image;
 	int mult1;
@@ -1486,73 +1568,92 @@ calculate_destination_timeout(void)
 	int ret;
 	unsigned long ts_ns;
 
-	mult1 = UV_INTD_SOFT_ACK_TIMEOUT_PERIOD & BAU_MISC_CONTROL_MULT_MASK;
-	mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
-	index = (mmr_image >> BAU_URGENCY_7_SHIFT) & BAU_URGENCY_7_MASK;
-	mmr_image = uv_read_local_mmr(UVH_TRANSACTION_TIMEOUT);
-	mult2 = (mmr_image >> BAU_TRANS_SHIFT) & BAU_TRANS_MASK;
-	base = timeout_base_ns[index];
-	ts_ns = base * mult1 * mult2;
-	ret = ts_ns / 1000;
+	if (is_uv1_hub()) {
+		mult1 = SOFTACK_TIMEOUT_PERIOD & BAU_MISC_CONTROL_MULT_MASK;
+		mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
+		index = (mmr_image >> BAU_URGENCY_7_SHIFT) & BAU_URGENCY_7_MASK;
+		mmr_image = uv_read_local_mmr(UVH_TRANSACTION_TIMEOUT);
+		mult2 = (mmr_image >> BAU_TRANS_SHIFT) & BAU_TRANS_MASK;
+		base = timeout_base_ns[index];
+		ts_ns = base * mult1 * mult2;
+		ret = ts_ns / 1000;
+	} else {
+		/* 4 bits  0/1 for 10/80us, 3 bits of multiplier */
+		mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
+		mmr_image = (mmr_image & UV_SA_MASK) >> UV_SA_SHFT;
+		if (mmr_image & (1L << UV2_ACK_UNITS_SHFT))
+			mult1 = 80;
+		else
+			mult1 = 10;
+		base = mmr_image & UV2_ACK_MASK;
+		ret = mult1 * base;
+	}
 	return ret;
 }
 
+static void __init init_per_cpu_tunables(void)
+{
+	int cpu;
+	struct bau_control *bcp;
+
+	for_each_present_cpu(cpu) {
+		bcp = &per_cpu(bau_control, cpu);
+		bcp->baudisabled		= 0;
+		bcp->statp			= &per_cpu(ptcstats, cpu);
+		/* time interval to catch a hardware stay-busy bug */
+		bcp->timeout_interval		= usec_2_cycles(2*timeout_us);
+		bcp->max_concurr		= max_concurr;
+		bcp->max_concurr_const		= max_concurr;
+		bcp->plugged_delay		= plugged_delay;
+		bcp->plugsb4reset		= plugsb4reset;
+		bcp->timeoutsb4reset		= timeoutsb4reset;
+		bcp->ipi_reset_limit		= ipi_reset_limit;
+		bcp->complete_threshold		= complete_threshold;
+		bcp->cong_response_us		= congested_respns_us;
+		bcp->cong_reps			= congested_reps;
+		bcp->cong_period		= congested_period;
+	}
+}
+
 /*
- * initialize the bau_control structure for each cpu
+ * Scan all cpus to collect blade and socket summaries.
  */
-static int __init uv_init_per_cpu(int nuvhubs, int base_part_pnode)
+static int __init get_cpu_topology(int base_pnode,
+					struct uvhub_desc *uvhub_descs,
+					unsigned char *uvhub_mask)
 {
-	int i;
 	int cpu;
-	int tcpu;
 	int pnode;
 	int uvhub;
-	int have_hmaster;
-	short socket = 0;
-	unsigned short socket_mask;
-	unsigned char *uvhub_mask;
+	int socket;
 	struct bau_control *bcp;
 	struct uvhub_desc *bdp;
 	struct socket_desc *sdp;
-	struct bau_control *hmaster = NULL;
-	struct bau_control *smaster = NULL;
-	struct socket_desc {
-		short num_cpus;
-		short cpu_number[MAX_CPUS_PER_SOCKET];
-	};
-	struct uvhub_desc {
-		unsigned short socket_mask;
-		short num_cpus;
-		short uvhub;
-		short pnode;
-		struct socket_desc socket[2];
-	};
-	struct uvhub_desc *uvhub_descs;
-
-	timeout_us = calculate_destination_timeout();
 
-	uvhub_descs = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
-	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
-	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
+
 		memset(bcp, 0, sizeof(struct bau_control));
+
 		pnode = uv_cpu_hub_info(cpu)->pnode;
-		if ((pnode - base_part_pnode) >= UV_DISTRIBUTION_SIZE) {
+		if ((pnode - base_pnode) >= UV_DISTRIBUTION_SIZE) {
 			printk(KERN_EMERG
 				"cpu %d pnode %d-%d beyond %d; BAU disabled\n",
-				cpu, pnode, base_part_pnode,
-				UV_DISTRIBUTION_SIZE);
+				cpu, pnode, base_pnode, UV_DISTRIBUTION_SIZE);
 			return 1;
 		}
+
 		bcp->osnode = cpu_to_node(cpu);
-		bcp->partition_base_pnode = uv_partition_base_pnode;
+		bcp->partition_base_pnode = base_pnode;
+
 		uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
 		*(uvhub_mask + (uvhub/8)) |= (1 << (uvhub%8));
 		bdp = &uvhub_descs[uvhub];
+
 		bdp->num_cpus++;
 		bdp->uvhub = uvhub;
 		bdp->pnode = pnode;
+
 		/* kludge: 'assuming' one node per socket, and assuming that
 		   disabling a socket just leaves a gap in node numbers */
 		socket = bcp->osnode & 1;
@@ -1561,84 +1662,129 @@ static int __init uv_init_per_cpu(int nuvhubs, int base_part_pnode)
 		sdp->cpu_number[sdp->num_cpus] = cpu;
 		sdp->num_cpus++;
 		if (sdp->num_cpus > MAX_CPUS_PER_SOCKET) {
-			printk(KERN_EMERG "%d cpus per socket invalid\n", sdp->num_cpus);
+			printk(KERN_EMERG "%d cpus per socket invalid\n",
+				sdp->num_cpus);
 			return 1;
 		}
 	}
+	return 0;
+}
+
+/*
+ * Each socket is to get a local array of pnodes/hubs.
+ */
+static void make_per_cpu_thp(struct bau_control *smaster)
+{
+	int cpu;
+	size_t hpsz = sizeof(struct hub_and_pnode) * num_possible_cpus();
+
+	smaster->thp = kmalloc_node(hpsz, GFP_KERNEL, smaster->osnode);
+	memset(smaster->thp, 0, hpsz);
+	for_each_present_cpu(cpu) {
+		smaster->thp[cpu].pnode = uv_cpu_hub_info(cpu)->pnode;
+		smaster->thp[cpu].uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
+	}
+}
+
+/*
+ * Initialize all the per_cpu information for the cpu's on a given socket,
+ * given what has been gathered into the socket_desc struct.
+ * And reports the chosen hub and socket masters back to the caller.
+ */
+static int scan_sock(struct socket_desc *sdp, struct uvhub_desc *bdp,
+			struct bau_control **smasterp,
+			struct bau_control **hmasterp)
+{
+	int i;
+	int cpu;
+	struct bau_control *bcp;
+
+	for (i = 0; i < sdp->num_cpus; i++) {
+		cpu = sdp->cpu_number[i];
+		bcp = &per_cpu(bau_control, cpu);
+		bcp->cpu = cpu;
+		if (i == 0) {
+			*smasterp = bcp;
+			if (!(*hmasterp))
+				*hmasterp = bcp;
+		}
+		bcp->cpus_in_uvhub = bdp->num_cpus;
+		bcp->cpus_in_socket = sdp->num_cpus;
+		bcp->socket_master = *smasterp;
+		bcp->uvhub = bdp->uvhub;
+		bcp->uvhub_master = *hmasterp;
+		bcp->uvhub_cpu = uv_cpu_hub_info(cpu)->blade_processor_id;
+		if (bcp->uvhub_cpu >= MAX_CPUS_PER_UVHUB) {
+			printk(KERN_EMERG "%d cpus per uvhub invalid\n",
+				bcp->uvhub_cpu);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Summarize the blade and socket topology into the per_cpu structures.
+ */
+static int __init summarize_uvhub_sockets(int nuvhubs,
+			struct uvhub_desc *uvhub_descs,
+			unsigned char *uvhub_mask)
+{
+	int socket;
+	int uvhub;
+	unsigned short socket_mask;
+
 	for (uvhub = 0; uvhub < nuvhubs; uvhub++) {
+		struct uvhub_desc *bdp;
+		struct bau_control *smaster = NULL;
+		struct bau_control *hmaster = NULL;
+
 		if (!(*(uvhub_mask + (uvhub/8)) & (1 << (uvhub%8))))
 			continue;
-		have_hmaster = 0;
+
 		bdp = &uvhub_descs[uvhub];
 		socket_mask = bdp->socket_mask;
 		socket = 0;
 		while (socket_mask) {
-			if (!(socket_mask & 1))
-				goto nextsocket;
-			sdp = &bdp->socket[socket];
-			for (i = 0; i < sdp->num_cpus; i++) {
-				cpu = sdp->cpu_number[i];
-				bcp = &per_cpu(bau_control, cpu);
-				bcp->cpu = cpu;
-				if (i == 0) {
-					smaster = bcp;
-					if (!have_hmaster) {
-						have_hmaster++;
-						hmaster = bcp;
-					}
-				}
-				bcp->cpus_in_uvhub = bdp->num_cpus;
-				bcp->cpus_in_socket = sdp->num_cpus;
-				bcp->socket_master = smaster;
-				bcp->uvhub = bdp->uvhub;
-				bcp->uvhub_master = hmaster;
-				bcp->uvhub_cpu = uv_cpu_hub_info(cpu)->
-						blade_processor_id;
-				if (bcp->uvhub_cpu >= MAX_CPUS_PER_UVHUB) {
-					printk(KERN_EMERG
-						"%d cpus per uvhub invalid\n",
-						bcp->uvhub_cpu);
+			struct socket_desc *sdp;
+			if ((socket_mask & 1)) {
+				sdp = &bdp->socket[socket];
+				if (scan_sock(sdp, bdp, &smaster, &hmaster))
 					return 1;
-				}
 			}
-nextsocket:
 			socket++;
 			socket_mask = (socket_mask >> 1);
-			/* each socket gets a local array of pnodes/hubs */
-			bcp = smaster;
-			bcp->target_hub_and_pnode = kmalloc_node(
-				sizeof(struct hub_and_pnode) *
-				num_possible_cpus(), GFP_KERNEL, bcp->osnode);
-			memset(bcp->target_hub_and_pnode, 0,
-				sizeof(struct hub_and_pnode) *
-				num_possible_cpus());
-			for_each_present_cpu(tcpu) {
-				bcp->target_hub_and_pnode[tcpu].pnode =
-					uv_cpu_hub_info(tcpu)->pnode;
-				bcp->target_hub_and_pnode[tcpu].uvhub =
-					uv_cpu_hub_info(tcpu)->numa_blade_id;
-			}
+			make_per_cpu_thp(smaster);
 		}
 	}
+	return 0;
+}
+
+/*
+ * initialize the bau_control structure for each cpu
+ */
+static int __init init_per_cpu(int nuvhubs, int base_part_pnode)
+{
+	unsigned char *uvhub_mask;
+	void *vp;
+	struct uvhub_desc *uvhub_descs;
+
+	timeout_us = calculate_destination_timeout();
+
+	vp = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
+	uvhub_descs = (struct uvhub_desc *)vp;
+	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
+	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
+
+	if (get_cpu_topology(base_part_pnode, uvhub_descs, uvhub_mask))
+		return 1;
+
+	if (summarize_uvhub_sockets(nuvhubs, uvhub_descs, uvhub_mask))
+		return 1;
+
 	kfree(uvhub_descs);
 	kfree(uvhub_mask);
-	for_each_present_cpu(cpu) {
-		bcp = &per_cpu(bau_control, cpu);
-		bcp->baudisabled = 0;
-		bcp->statp = &per_cpu(ptcstats, cpu);
-		/* time interval to catch a hardware stay-busy bug */
-		bcp->timeout_interval = microsec_2_cycles(2*timeout_us);
-		bcp->max_bau_concurrent = max_bau_concurrent;
-		bcp->max_bau_concurrent_constant = max_bau_concurrent;
-		bcp->plugged_delay = plugged_delay;
-		bcp->plugsb4reset = plugsb4reset;
-		bcp->timeoutsb4reset = timeoutsb4reset;
-		bcp->ipi_reset_limit = ipi_reset_limit;
-		bcp->complete_threshold = complete_threshold;
-		bcp->congested_response_us = congested_response_us;
-		bcp->congested_reps = congested_reps;
-		bcp->congested_period = congested_period;
-	}
+	init_per_cpu_tunables();
 	return 0;
 }
 
@@ -1651,8 +1797,9 @@ static int __init uv_bau_init(void)
 	int pnode;
 	int nuvhubs;
 	int cur_cpu;
+	int cpus;
 	int vector;
-	unsigned long mmr;
+	cpumask_var_t *mask;
 
 	if (!is_uv_system())
 		return 0;
@@ -1660,24 +1807,25 @@ static int __init uv_bau_init(void)
 	if (nobau)
 		return 0;
 
-	for_each_possible_cpu(cur_cpu)
-		zalloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
-				       GFP_KERNEL, cpu_to_node(cur_cpu));
+	for_each_possible_cpu(cur_cpu) {
+		mask = &per_cpu(uv_flush_tlb_mask, cur_cpu);
+		zalloc_cpumask_var_node(mask, GFP_KERNEL, cpu_to_node(cur_cpu));
+	}
 
 	uv_nshift = uv_hub_info->m_val;
 	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nuvhubs = uv_num_possible_blades();
 	spin_lock_init(&disable_lock);
-	congested_cycles = microsec_2_cycles(congested_response_us);
+	congested_cycles = usec_2_cycles(congested_respns_us);
 
-	uv_partition_base_pnode = 0x7fffffff;
+	uv_base_pnode = 0x7fffffff;
 	for (uvhub = 0; uvhub < nuvhubs; uvhub++) {
-		if (uv_blade_nr_possible_cpus(uvhub) &&
-			(uv_blade_to_pnode(uvhub) < uv_partition_base_pnode))
-			uv_partition_base_pnode = uv_blade_to_pnode(uvhub);
+		cpus = uv_blade_nr_possible_cpus(uvhub);
+		if (cpus && (uv_blade_to_pnode(uvhub) < uv_base_pnode))
+			uv_base_pnode = uv_blade_to_pnode(uvhub);
 	}
 
-	if (uv_init_per_cpu(nuvhubs, uv_partition_base_pnode)) {
+	if (init_per_cpu(nuvhubs, uv_base_pnode)) {
 		nobau = 1;
 		return 0;
 	}
@@ -1685,21 +1833,21 @@ static int __init uv_bau_init(void)
 	vector = UV_BAU_MESSAGE;
 	for_each_possible_blade(uvhub)
 		if (uv_blade_nr_possible_cpus(uvhub))
-			uv_init_uvhub(uvhub, vector, uv_partition_base_pnode);
+			init_uvhub(uvhub, vector, uv_base_pnode);
 
-	uv_enable_timeouts();
+	enable_timeouts();
 	alloc_intr_gate(vector, uv_bau_message_intr1);
 
 	for_each_possible_blade(uvhub) {
 		if (uv_blade_nr_possible_cpus(uvhub)) {
+			unsigned long val;
+			unsigned long mmr;
 			pnode = uv_blade_to_pnode(uvhub);
 			/* INIT the bau */
-			uv_write_global_mmr64(pnode,
-					UVH_LB_BAU_SB_ACTIVATION_CONTROL,
-					((unsigned long)1 << 63));
+			val = 1L << 63;
+			write_gmmr_activation(pnode, val);
 			mmr = 1; /* should be 1 to broadcast to both sockets */
-			uv_write_global_mmr64(pnode, UVH_BAU_DATA_BROADCAST,
-						mmr);
+			write_mmr_data_broadcast(pnode, mmr);
 		}
 	}
 
diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 0eb9018..9f29a01 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -99,8 +99,12 @@ static void uv_rtc_send_IPI(int cpu)
 /* Check for an RTC interrupt pending */
 static int uv_intr_pending(int pnode)
 {
-	return uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
-		UVH_EVENT_OCCURRED0_RTC1_MASK;
+	if (is_uv1_hub())
+		return uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
+			UV1H_EVENT_OCCURRED0_RTC1_MASK;
+	else
+		return uv_read_global_mmr64(pnode, UV2H_EVENT_OCCURRED2) &
+			UV2H_EVENT_OCCURRED2_RTC_1_MASK;
 }
 
 /* Setup interrupt and return non-zero if early expiration occurred. */
@@ -114,8 +118,12 @@ static int uv_setup_intr(int cpu, u64 expires)
 		UVH_RTC1_INT_CONFIG_M_MASK);
 	uv_write_global_mmr64(pnode, UVH_INT_CMPB, -1L);
 
-	uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
-		UVH_EVENT_OCCURRED0_RTC1_MASK);
+	if (is_uv1_hub())
+		uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
+				UV1H_EVENT_OCCURRED0_RTC1_MASK);
+	else
+		uv_write_global_mmr64(pnode, UV2H_EVENT_OCCURRED2_ALIAS,
+				UV2H_EVENT_OCCURRED2_RTC_1_MASK);
 
 	val = (X86_PLATFORM_IPI_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
 		((u64)apicid << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 33fa120..e376270 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -299,6 +299,7 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
+extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
 /**
