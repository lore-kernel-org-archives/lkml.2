Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2D1Iv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:51:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:10536 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab2D1IvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:51:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="136429257"
From: Alex Shi <alex.shi@intel.com>
To: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com
Cc: riel@redhat.com, luto@mit.edu, alex.shi@intel.com, avi@redhat.com,
        len.brown@intel.com, paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86/tlb_info: get last level TLB entry number of CPU
Date: Sat, 28 Apr 2012 16:50:04 +0800
Message-Id: <1335603006-2572-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 4KB pages, x86 CPU has 2 or 1 level TLB, first level is data TLB and
instruction TLB, second level is shared TLB for both data and instructions.

For hupe page TLB, usually there is just one level and seperated by 2MB/4MB
and 1GB.

Although each levels TLB size is important for performance tuning, but for
genernal and rude optimizing, just last level TLB entry number is suitable.
And in fact, last level TLB has the biggest entry number.

This patch will get the biggest TLB entry number and use it in furture TLB
optimizing.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/processor.h |   12 +++
 arch/x86/kernel/cpu/common.c     |  163 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/cpu.h        |    1 +
 3 files changed, 176 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4fa7dcc..a91504b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -61,6 +61,18 @@ static inline void *current_text_addr(void)
 # define ARCH_MIN_MMSTRUCT_ALIGN	0
 #endif
 
+enum tlb_infos {
+	ENTRIES,
+	/* ASS_WAYS, */
+	NR_INFO
+};
+
+extern u16 __read_mostly tlb_lli_4k[NR_INFO];
+extern u16 __read_mostly tlb_lli_2m[NR_INFO];
+extern u16 __read_mostly tlb_lli_4m[NR_INFO];
+extern u16 __read_mostly tlb_lld_4k[NR_INFO];
+extern u16 __read_mostly tlb_lld_2m[NR_INFO];
+extern u16 __read_mostly tlb_lld_4m[NR_INFO];
 /*
  *  CPU type and hardware bug flags. Kept separately for each CPU.
  *  Members of this structure are referenced in head.S, so think twice
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cf79302..5f14a70 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -452,6 +452,167 @@ void __cpuinit cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 	c->x86_cache_size = l2size;
 }
 
+#define TLB_INST_4K	0x01
+#define TLB_INST_4M	0x02
+#define TLB_INST_2M_4M	0x03
+
+#define TLB_INST_ALL	0x05
+#define TLB_INST_1G	0x06
+
+#define TLB_DATA_4K	0x11
+#define TLB_DATA_4M	0x12
+#define TLB_DATA_2M_4M	0x13
+#define TLB_DATA_4K_4M	0x14
+
+#define TLB_DATA_1G	0x16
+
+#define TLB_DATA0_4K	0x21
+#define TLB_DATA0_4M	0x22
+#define TLB_DATA0_2M_4M	0x23
+
+#define STLB_4K		0x41
+
+struct _tlb_table {
+	unsigned char descriptor;
+	char tlb_type;
+	unsigned int entries;
+	/* unsigned int ways; */
+	char info[128];
+};
+
+static const struct _tlb_table tlb_table[] = {
+	{ 0x01, TLB_INST_4K,		32,	" TLB_INST 4 KByte pages, 4-way set associative" },
+	{ 0x02, TLB_INST_4M,		2,	" TLB_INST 4 MByte pages, full associative" },
+	{ 0x03, TLB_DATA_4K,		64,	" TLB_DATA 4 KByte pages, 4-way set associative" },
+	{ 0x04, TLB_DATA_4M,		8,	" TLB_DATA 4 MByte pages, 4-way set associative" },
+	{ 0x05, TLB_DATA_4M,		32,	" TLB_DATA 4 MByte pages, 4-way set associative" },
+	{ 0x0b, TLB_INST_4M,		4,	" TLB_INST 4 MByte pages, 4-way set associative" },
+	{ 0x4f, TLB_INST_4K,		32, 	" TLB_INST 4 KByte pages */" },
+	{ 0x50, TLB_INST_ALL,		64, 	" TLB_INST 4 KByte and 2-MByte or 4-MByte pages" },
+	{ 0x51, TLB_INST_ALL,		128,	" TLB_INST 4 KByte and 2-MByte or 4-MByte pages" },
+	{ 0x52, TLB_INST_ALL,		256,	" TLB_INST 4 KByte and 2-MByte or 4-MByte pages" },
+	{ 0x55, TLB_INST_2M_4M,		7, 	" TLB_INST 2-MByte or 4-MByte pages, fully associative" },
+	{ 0x56, TLB_DATA0_4M,		16,	" TLB_DATA0 4 MByte pages, 4-way set associative" },
+	{ 0x57, TLB_DATA0_4K,		16,	" TLB_DATA0 4 KByte pages, 4-way associative" },
+	{ 0x59, TLB_DATA0_4K,		16,	" TLB_DATA0 4 KByte pages, fully associative" },
+	{ 0x5a, TLB_DATA0_2M_4M,	32,	" TLB_DATA0 2-MByte or 4 MByte pages, 4-way set associative" },
+	{ 0x5b, TLB_DATA_4K_4M,		64,	" TLB_DATA 4 KByte and 4 MByte pages" },
+	{ 0x5c, TLB_DATA_4K_4M,		128,	" TLB_DATA 4 KByte and 4 MByte pages" },
+	{ 0x5d, TLB_DATA_4K_4M,		256,	" TLB_DATA 4 KByte and 4 MByte pages" },
+	{ 0xb0, TLB_INST_4K,		128,	" TLB_INST 4 KByte pages, 4-way set associative" },
+	{ 0xb1, TLB_INST_2M_4M,		4,	" TLB_INST 2M pages, 4-way, 8 entries or 4M pages, 4-way entries" },
+	{ 0xb2, TLB_INST_4K,		64,	" TLB_INST 4KByte pages, 4-way set associative" },
+	{ 0xb3, TLB_DATA_4K,		128,	" TLB_DATA 4 KByte pages, 4-way set associative" },
+	{ 0xb4, TLB_DATA_4K,		256,	" TLB_DATA 4 KByte pages, 4-way associative" },
+	{ 0xba, TLB_DATA_4K,		64,	" TLB_DATA 4 KByte pages, 4-way associative" },
+	{ 0xc0, TLB_DATA_4K_4M,		8,	" TLB_DATA 4 KByte and 4 MByte pages, 4-way associative" },
+	{ 0xca, STLB_4K,		512,	" STLB 4 KByte pages, 4-way associative" },
+	{ 0x00, 0, 0 }
+};
+
+u16 __read_mostly tlb_lli_4k[NR_INFO];
+u16 __read_mostly tlb_lli_2m[NR_INFO];
+u16 __read_mostly tlb_lli_4m[NR_INFO];
+u16 __read_mostly tlb_lld_4k[NR_INFO];
+u16 __read_mostly tlb_lld_2m[NR_INFO];
+u16 __read_mostly tlb_lld_4m[NR_INFO];
+
+void tlb_lookup(const unsigned char desc)
+{
+	unsigned char k;
+	if (desc == 0)
+		return;
+
+	/* look up this descriptor in the table */
+	for (k = 0; tlb_table[k].descriptor != desc && \
+			tlb_table[k].descriptor != 0; k++)
+		;
+
+	if (tlb_table[k].tlb_type == 0)
+		return;
+
+	switch (tlb_table[k].tlb_type) {
+	case STLB_4K:
+		if (tlb_lli_4k[ENTRIES] < tlb_table[k].entries)
+			tlb_lli_4k[ENTRIES] = tlb_table[k].entries;
+		if (tlb_lld_4k[ENTRIES] < tlb_table[k].entries)
+			tlb_lld_4k[ENTRIES] = tlb_table[k].entries;
+		break;
+	case TLB_INST_ALL:
+		if (tlb_lli_4k[ENTRIES] < tlb_table[k].entries)
+			tlb_lli_4k[ENTRIES] = tlb_table[k].entries;
+		if (tlb_lli_2m[ENTRIES] < tlb_table[k].entries)
+			tlb_lli_2m[ENTRIES] = tlb_table[k].entries;
+		if (tlb_lli_4m[ENTRIES] < tlb_table[k].entries)
+			tlb_lli_4m[ENTRIES] = tlb_table[k].entries;
+		break;
+	case TLB_INST_4K:
+		if (tlb_lli_4k[ENTRIES] < tlb_table[k].entries)
+			tlb_lli_4k[ENTRIES] = tlb_table[k].entries;
+		break;
+	case TLB_INST_4M:
+		if (tlb_lli_4m[ENTRIES] < tlb_table[k].entries)
+			tlb_lli_4m[ENTRIES] = tlb_table[k].entries;
+		break;
+	case TLB_INST_2M_4M:
+		if (tlb_lli_2m[ENTRIES] < tlb_table[k].entries)
+			tlb_lli_2m[ENTRIES] = tlb_table[k].entries;
+		if (tlb_lli_4m[ENTRIES] < tlb_table[k].entries)
+			tlb_lli_4m[ENTRIES] = tlb_table[k].entries;
+		break;
+	case TLB_DATA_4K:
+	case TLB_DATA0_4K:
+		if (tlb_lld_4k[ENTRIES] < tlb_table[k].entries)
+			tlb_lld_4k[ENTRIES] = tlb_table[k].entries;
+		break;
+	case TLB_DATA_4M:
+	case TLB_DATA0_4M:
+		if (tlb_lld_4m[ENTRIES] < tlb_table[k].entries)
+			tlb_lld_4m[ENTRIES] = tlb_table[k].entries;
+		break;
+	case TLB_DATA_2M_4M:
+	case TLB_DATA0_2M_4M:
+		if (tlb_lld_2m[ENTRIES] < tlb_table[k].entries)
+			tlb_lld_2m[ENTRIES] = tlb_table[k].entries;
+		if (tlb_lld_4m[ENTRIES] < tlb_table[k].entries)
+			tlb_lld_4m[ENTRIES] = tlb_table[k].entries;
+		break;
+	case TLB_DATA_4K_4M:
+		if (tlb_lld_4k[ENTRIES] < tlb_table[k].entries)
+			tlb_lld_4k[ENTRIES] = tlb_table[k].entries;
+		if (tlb_lld_4m[ENTRIES] < tlb_table[k].entries)
+			tlb_lld_4m[ENTRIES] = tlb_table[k].entries;
+		break;
+	}
+}
+void __cpuinit cpu_detect_tlb_sizes()
+{
+	int i, j, n;
+	unsigned int regs[4];
+	unsigned char *desc = (unsigned char *)regs;
+
+	/* Number of times to iterate */
+	n = cpuid_eax(2) & 0xFF;
+
+	for (i = 0 ; i < n ; i++) {
+		cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
+
+		/* If bit 31 is set, this is an unknown format */
+		for (j = 0 ; j < 3 ; j++)
+			if (regs[j] & (1 << 31))
+				regs[j] = 0;
+
+		/* Byte 0 is level count, not a descriptor */
+		for (j = 1 ; j < 16 ; j++)
+			tlb_lookup(desc[j]);
+	}
+	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
+		"Last level dTLB entires: 4KB %d, 2MB %d, 4MB %d\n",
+		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
+		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
+		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES]);
+}
+
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
@@ -911,6 +1072,8 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
+	if (boot_cpu_data.cpuid_level >= 2)
+		cpu_detect_tlb_sizes();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 8bacc78..a102ed1 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -34,4 +34,5 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
+extern void cpu_detect_tlb_sizes(void);
 #endif /* ARCH_X86_CPU_H */
-- 
1.7.5.4

