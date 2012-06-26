Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab2FZPNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:13:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35677 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2FZPNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:13:13 -0400
Date: Tue, 26 Jun 2012 08:13:00 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-dc869f34dc890189aafcd1812d0823b8207e507c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1340604507-11214-2-git-send-email-alex.shi@intel.com>
References: <1340604507-11214-2-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/tlb_info: get last level TLB entry number of CPU
Git-Commit-ID: dc869f34dc890189aafcd1812d0823b8207e507c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 26 Jun 2012 08:13:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc869f34dc890189aafcd1812d0823b8207e507c
Gitweb:     http://git.kernel.org/tip/dc869f34dc890189aafcd1812d0823b8207e507c
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Mon, 25 Jun 2012 14:08:19 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 25 Jun 2012 20:53:13 -0700

x86/tlb_info: get last level TLB entry number of CPU

For 4KB pages, x86 CPU has 2 or 1 level TLB, first level is data TLB and
instruction TLB, second level is shared TLB for both data and instructions.

For hupe page TLB, usually there is just one level and seperated by 2MB/4MB
and 1GB.

Although each levels TLB size is important for performance tuning, but for
genernal and rude optimizing, last level TLB entry number is suitable. And
in fact, last level TLB always has the biggest entry number.

This patch will get the biggest TLB entry number and use it in furture TLB
optimizing.

Accroding Borislav's suggestion, except tlb_ll[i/d]_* array, other
function and data will be released after system boot up.

For all kinds of x86 vendor friendly, vendor specific code was moved to its
specific files.

[ hpa: http://lkml.kernel.org/r/1B4B44D9196EFF41AE41FDA404FC0A100BFF94@SHSMSX101.ccr.corp.intel.com
  has some performance numbers. ]

Signed-off-by: Alex Shi <alex.shi@intel.com>
Link: http://lkml.kernel.org/r/1340604507-11214-2-git-send-email-alex.shi@intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/processor.h |   11 +++
 arch/x86/kernel/cpu/common.c     |   21 ++++++
 arch/x86/kernel/cpu/cpu.h        |    9 +++
 arch/x86/kernel/cpu/intel.c      |  141 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 182 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 39bc577..39b2bd4 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -61,6 +61,17 @@ static inline void *current_text_addr(void)
 # define ARCH_MIN_MMSTRUCT_ALIGN	0
 #endif
 
+enum tlb_infos {
+	ENTRIES,
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
index 6b9333b..41acb77 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -452,6 +452,25 @@ void __cpuinit cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 	c->x86_cache_size = l2size;
 }
 
+u16 __read_mostly tlb_lli_4k[NR_INFO];
+u16 __read_mostly tlb_lli_2m[NR_INFO];
+u16 __read_mostly tlb_lli_4m[NR_INFO];
+u16 __read_mostly tlb_lld_4k[NR_INFO];
+u16 __read_mostly tlb_lld_2m[NR_INFO];
+u16 __read_mostly tlb_lld_4m[NR_INFO];
+
+void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
+{
+	if (c->x86_vendor == X86_VENDOR_INTEL)
+		intel_cpu_detect_tlb(c);
+
+	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
+		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n",
+		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
+		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
+		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES]);
+}
+
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
@@ -911,6 +930,8 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
+	if (boot_cpu_data.cpuid_level >= 2)
+		cpu_detect_tlb(&boot_cpu_data);
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 8bacc78..78db1d9 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -24,6 +24,14 @@ struct cpu_dev {
 	int		c_x86_vendor;
 };
 
+struct _tlb_table {
+	unsigned char descriptor;
+	char tlb_type;
+	unsigned int entries;
+	/* unsigned int ways; */
+	char info[128];
+};
+
 #define cpu_dev_register(cpu_devX) \
 	static const struct cpu_dev *const __cpu_dev_##cpu_devX __used \
 	__attribute__((__section__(".x86_cpu_dev.init"))) = \
@@ -34,4 +42,5 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
+extern void intel_cpu_detect_tlb(struct cpuinfo_x86 *c) __cpuinit;
 #endif /* ARCH_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3e6ff6c..28ecd1b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -491,6 +491,147 @@ static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned i
 }
 #endif
 
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
+static const struct _tlb_table intel_tlb_table[] __cpuinitconst = {
+	{ 0x01, TLB_INST_4K,		32,	" TLB_INST 4 KByte pages, 4-way set associative" },
+	{ 0x02, TLB_INST_4M,		2,	" TLB_INST 4 MByte pages, full associative" },
+	{ 0x03, TLB_DATA_4K,		64,	" TLB_DATA 4 KByte pages, 4-way set associative" },
+	{ 0x04, TLB_DATA_4M,		8,	" TLB_DATA 4 MByte pages, 4-way set associative" },
+	{ 0x05, TLB_DATA_4M,		32,	" TLB_DATA 4 MByte pages, 4-way set associative" },
+	{ 0x0b, TLB_INST_4M,		4,	" TLB_INST 4 MByte pages, 4-way set associative" },
+	{ 0x4f, TLB_INST_4K,		32,	" TLB_INST 4 KByte pages */" },
+	{ 0x50, TLB_INST_ALL,		64,	" TLB_INST 4 KByte and 2-MByte or 4-MByte pages" },
+	{ 0x51, TLB_INST_ALL,		128,	" TLB_INST 4 KByte and 2-MByte or 4-MByte pages" },
+	{ 0x52, TLB_INST_ALL,		256,	" TLB_INST 4 KByte and 2-MByte or 4-MByte pages" },
+	{ 0x55, TLB_INST_2M_4M,		7,	" TLB_INST 2-MByte or 4-MByte pages, fully associative" },
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
+static void __cpuinit intel_tlb_lookup(const unsigned char desc)
+{
+	unsigned char k;
+	if (desc == 0)
+		return;
+
+	/* look up this descriptor in the table */
+	for (k = 0; intel_tlb_table[k].descriptor != desc && \
+			intel_tlb_table[k].descriptor != 0; k++)
+		;
+
+	if (intel_tlb_table[k].tlb_type == 0)
+		return;
+
+	switch (intel_tlb_table[k].tlb_type) {
+	case STLB_4K:
+		if (tlb_lli_4k[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_4k[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lld_4k[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_4k[ENTRIES] = intel_tlb_table[k].entries;
+		break;
+	case TLB_INST_ALL:
+		if (tlb_lli_4k[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_4k[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lli_2m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_2m[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lli_4m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_4m[ENTRIES] = intel_tlb_table[k].entries;
+		break;
+	case TLB_INST_4K:
+		if (tlb_lli_4k[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_4k[ENTRIES] = intel_tlb_table[k].entries;
+		break;
+	case TLB_INST_4M:
+		if (tlb_lli_4m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_4m[ENTRIES] = intel_tlb_table[k].entries;
+		break;
+	case TLB_INST_2M_4M:
+		if (tlb_lli_2m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_2m[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lli_4m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_4m[ENTRIES] = intel_tlb_table[k].entries;
+		break;
+	case TLB_DATA_4K:
+	case TLB_DATA0_4K:
+		if (tlb_lld_4k[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_4k[ENTRIES] = intel_tlb_table[k].entries;
+		break;
+	case TLB_DATA_4M:
+	case TLB_DATA0_4M:
+		if (tlb_lld_4m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_4m[ENTRIES] = intel_tlb_table[k].entries;
+		break;
+	case TLB_DATA_2M_4M:
+	case TLB_DATA0_2M_4M:
+		if (tlb_lld_2m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_2m[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lld_4m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_4m[ENTRIES] = intel_tlb_table[k].entries;
+		break;
+	case TLB_DATA_4K_4M:
+		if (tlb_lld_4k[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_4k[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lld_4m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_4m[ENTRIES] = intel_tlb_table[k].entries;
+		break;
+	}
+}
+
+void __cpuinit intel_cpu_detect_tlb(struct cpuinfo_x86 *c)
+{
+	int i, j, n;
+	unsigned int regs[4];
+	unsigned char *desc = (unsigned char *)regs;
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
+			intel_tlb_lookup(desc[j]);
+	}
+}
+
 static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
 	.c_vendor	= "Intel",
 	.c_ident	= { "GenuineIntel" },
