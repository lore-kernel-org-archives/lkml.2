Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2LUOsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:48:02 -0500
Received: from mga03.intel.com ([143.182.124.21]:45293 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab2LUOq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:46:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,329,1355126400"; 
   d="scan'208";a="235197520"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v5 02/12] x86/microcode_intel.h: Define functions and macros for early loading ucode
Date: Thu, 20 Dec 2012 23:44:22 -0800
Message-Id: <1356075872-3054-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Define some functions and macros that will be used in early loading ucode. Some
of them are moved from microcode_intel.c driver in order to be called in early
boot phase before module can be called.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/microcode_intel.h |  85 ++++++++++++++
 arch/x86/kernel/Makefile               |   3 +
 arch/x86/kernel/microcode_core.c       |   7 +-
 arch/x86/kernel/microcode_intel.c      | 198 +++++----------------------------
 4 files changed, 122 insertions(+), 171 deletions(-)
 create mode 100644 arch/x86/include/asm/microcode_intel.h

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
new file mode 100644
index 0000000..5356f92
--- /dev/null
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -0,0 +1,85 @@
+#ifndef _ASM_X86_MICROCODE_INTEL_H
+#define _ASM_X86_MICROCODE_INTEL_H
+
+#include <asm/microcode.h>
+
+struct microcode_header_intel {
+	unsigned int            hdrver;
+	unsigned int            rev;
+	unsigned int            date;
+	unsigned int            sig;
+	unsigned int            cksum;
+	unsigned int            ldrver;
+	unsigned int            pf;
+	unsigned int            datasize;
+	unsigned int            totalsize;
+	unsigned int            reserved[3];
+};
+
+struct microcode_intel {
+	struct microcode_header_intel hdr;
+	unsigned int            bits[0];
+};
+
+/* microcode format is extended from prescott processors */
+struct extended_signature {
+	unsigned int            sig;
+	unsigned int            pf;
+	unsigned int            cksum;
+};
+
+struct extended_sigtable {
+	unsigned int            count;
+	unsigned int            cksum;
+	unsigned int            reserved[3];
+	struct extended_signature sigs[0];
+};
+
+#define DEFAULT_UCODE_DATASIZE	(2000)
+#define MC_HEADER_SIZE		(sizeof(struct microcode_header_intel))
+#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
+#define EXT_HEADER_SIZE		(sizeof(struct extended_sigtable))
+#define EXT_SIGNATURE_SIZE	(sizeof(struct extended_signature))
+#define DWSIZE			(sizeof(u32))
+
+#define get_totalsize(mc) \
+	(((struct microcode_intel *)mc)->hdr.totalsize ? \
+	 ((struct microcode_intel *)mc)->hdr.totalsize : \
+	 DEFAULT_UCODE_TOTALSIZE)
+
+#define get_datasize(mc) \
+	(((struct microcode_intel *)mc)->hdr.datasize ? \
+	 ((struct microcode_intel *)mc)->hdr.datasize : DEFAULT_UCODE_DATASIZE)
+
+#define sigmatch(s1, s2, p1, p2) \
+	(((s1) == (s2)) && (((p1) & (p2)) || (((p1) == 0) && ((p2) == 0))))
+
+#define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
+
+extern int
+get_matching_microcode(unsigned int csig, int cpf, void *mc, int rev);
+extern int microcode_sanity_check(void *mc, int print_err);
+extern int get_matching_sig(unsigned int csig, int cpf, void *mc, int rev);
+extern int
+update_match_revision(struct microcode_header_intel *mc_header, int rev);
+
+#ifdef CONFIG_MICROCODE_INTEL_EARLY
+extern void __init load_ucode_intel_bsp(void);
+extern void __cpuinit load_ucode_intel_ap(void);
+extern void show_ucode_info_early(void);
+#else
+static inline __init void load_ucode_intel_bsp(void) {}
+static inline __cpuinit void load_ucode_intel_ap(void) {}
+static inline void show_ucode_info_early(void) {}
+#endif
+
+#if defined(CONFIG_MICROCODE_INTEL_EARLY) && defined(CONFIG_HOTPLUG_CPU)
+extern int save_mc_for_early(u8 *mc);
+#else
+static inline int save_mc_for_early(u8 *mc)
+{
+	return 0;
+}
+#endif
+
+#endif /* _ASM_X86_MICROCODE_INTEL_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 34e923a..052abee 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -88,6 +88,9 @@ obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
+obj-$(CONFIG_MICROCODE_EARLY)		+= microcode_core_early.o
+obj-$(CONFIG_MICROCODE_INTEL_EARLY)	+= microcode_intel_early.o
+obj-$(CONFIG_MICROCODE_INTEL_LIB)	+= microcode_intel_lib.o
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
 microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 3a04b22..22db92b 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -364,10 +364,7 @@ static struct attribute_group mc_attr_group = {
 
 static void microcode_fini_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
 	microcode_ops->microcode_fini_cpu(cpu);
-	uci->valid = 0;
 }
 
 static enum ucode_state microcode_resume_cpu(int cpu)
@@ -383,6 +380,10 @@ static enum ucode_state microcode_resume_cpu(int cpu)
 static enum ucode_state microcode_init_cpu(int cpu, bool refresh_fw)
 {
 	enum ucode_state ustate;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	if (uci && uci->valid)
+		return UCODE_OK;
 
 	if (collect_cpu_info(cpu))
 		return UCODE_ERROR;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 3544aed..5fb2ceb 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -79,7 +79,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 
-#include <asm/microcode.h>
+#include <asm/microcode_intel.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 
@@ -87,59 +87,6 @@ MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_LICENSE("GPL");
 
-struct microcode_header_intel {
-	unsigned int            hdrver;
-	unsigned int            rev;
-	unsigned int            date;
-	unsigned int            sig;
-	unsigned int            cksum;
-	unsigned int            ldrver;
-	unsigned int            pf;
-	unsigned int            datasize;
-	unsigned int            totalsize;
-	unsigned int            reserved[3];
-};
-
-struct microcode_intel {
-	struct microcode_header_intel hdr;
-	unsigned int            bits[0];
-};
-
-/* microcode format is extended from prescott processors */
-struct extended_signature {
-	unsigned int            sig;
-	unsigned int            pf;
-	unsigned int            cksum;
-};
-
-struct extended_sigtable {
-	unsigned int            count;
-	unsigned int            cksum;
-	unsigned int            reserved[3];
-	struct extended_signature sigs[0];
-};
-
-#define DEFAULT_UCODE_DATASIZE	(2000)
-#define MC_HEADER_SIZE		(sizeof(struct microcode_header_intel))
-#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
-#define EXT_HEADER_SIZE		(sizeof(struct extended_sigtable))
-#define EXT_SIGNATURE_SIZE	(sizeof(struct extended_signature))
-#define DWSIZE			(sizeof(u32))
-
-#define get_totalsize(mc) \
-	(((struct microcode_intel *)mc)->hdr.totalsize ? \
-	 ((struct microcode_intel *)mc)->hdr.totalsize : \
-	 DEFAULT_UCODE_TOTALSIZE)
-
-#define get_datasize(mc) \
-	(((struct microcode_intel *)mc)->hdr.datasize ? \
-	 ((struct microcode_intel *)mc)->hdr.datasize : DEFAULT_UCODE_DATASIZE)
-
-#define sigmatch(s1, s2, p1, p2) \
-	(((s1) == (s2)) && (((p1) & (p2)) || (((p1) == 0) && ((p2) == 0))))
-
-#define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
-
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
@@ -162,128 +109,25 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 	return 0;
 }
 
-static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
-{
-	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
-}
-
-static inline int
-update_match_revision(struct microcode_header_intel *mc_header, int rev)
-{
-	return (mc_header->rev <= rev) ? 0 : 1;
-}
-
-static int microcode_sanity_check(void *mc)
-{
-	unsigned long total_size, data_size, ext_table_size;
-	struct microcode_header_intel *mc_header = mc;
-	struct extended_sigtable *ext_header = NULL;
-	int sum, orig_sum, ext_sigcount = 0, i;
-	struct extended_signature *ext_sig;
-
-	total_size = get_totalsize(mc_header);
-	data_size = get_datasize(mc_header);
-
-	if (data_size + MC_HEADER_SIZE > total_size) {
-		pr_err("error! Bad data size in microcode data file\n");
-		return -EINVAL;
-	}
-
-	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
-		pr_err("error! Unknown microcode update format\n");
-		return -EINVAL;
-	}
-	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
-	if (ext_table_size) {
-		if ((ext_table_size < EXT_HEADER_SIZE)
-		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
-			pr_err("error! Small exttable size in microcode data file\n");
-			return -EINVAL;
-		}
-		ext_header = mc + MC_HEADER_SIZE + data_size;
-		if (ext_table_size != exttable_size(ext_header)) {
-			pr_err("error! Bad exttable size in microcode data file\n");
-			return -EFAULT;
-		}
-		ext_sigcount = ext_header->count;
-	}
-
-	/* check extended table checksum */
-	if (ext_table_size) {
-		int ext_table_sum = 0;
-		int *ext_tablep = (int *)ext_header;
-
-		i = ext_table_size / DWSIZE;
-		while (i--)
-			ext_table_sum += ext_tablep[i];
-		if (ext_table_sum) {
-			pr_warning("aborting, bad extended signature table checksum\n");
-			return -EINVAL;
-		}
-	}
-
-	/* calculate the checksum */
-	orig_sum = 0;
-	i = (MC_HEADER_SIZE + data_size) / DWSIZE;
-	while (i--)
-		orig_sum += ((int *)mc)[i];
-	if (orig_sum) {
-		pr_err("aborting, bad checksum\n");
-		return -EINVAL;
-	}
-	if (!ext_table_size)
-		return 0;
-	/* check extended signature checksum */
-	for (i = 0; i < ext_sigcount; i++) {
-		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
-			  EXT_SIGNATURE_SIZE * i;
-		sum = orig_sum
-			- (mc_header->sig + mc_header->pf + mc_header->cksum)
-			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
-		if (sum) {
-			pr_err("aborting, bad checksum\n");
-			return -EINVAL;
-		}
-	}
-	return 0;
-}
-
 /*
  * return 0 - no update found
  * return 1 - found update
  */
-static int
-get_matching_microcode(struct cpu_signature *cpu_sig, void *mc, int rev)
+static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
 {
-	struct microcode_header_intel *mc_header = mc;
-	struct extended_sigtable *ext_header;
-	unsigned long total_size = get_totalsize(mc_header);
-	int ext_sigcount, i;
-	struct extended_signature *ext_sig;
-
-	if (!update_match_revision(mc_header, rev))
-		return 0;
-
-	if (update_match_cpu(cpu_sig, mc_header->sig, mc_header->pf))
-		return 1;
+	struct cpu_signature cpu_sig;
+	unsigned int csig, cpf, crev;
 
-	/* Look for ext. headers: */
-	if (total_size <= get_datasize(mc_header) + MC_HEADER_SIZE)
-		return 0;
+	collect_cpu_info(cpu, &cpu_sig);
 
-	ext_header = mc + get_datasize(mc_header) + MC_HEADER_SIZE;
-	ext_sigcount = ext_header->count;
-	ext_sig = (void *)ext_header + EXT_HEADER_SIZE;
+	csig = cpu_sig.sig;
+	cpf = cpu_sig.pf;
+	crev = cpu_sig.rev;
 
-	for (i = 0; i < ext_sigcount; i++) {
-		if (update_match_cpu(cpu_sig, ext_sig->sig, ext_sig->pf))
-			return 1;
-		ext_sig++;
-	}
-	return 0;
+	return get_matching_microcode(csig, cpf, mc_intel, crev);
 }
 
-static int apply_microcode(int cpu)
+int apply_microcode(int cpu)
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
@@ -300,6 +144,14 @@ static int apply_microcode(int cpu)
 	if (mc_intel == NULL)
 		return 0;
 
+	/*
+	 * Microcode on this CPU could be updated earlier. Only apply the
+	 * microcode patch in mc_intel when it is newer than the one on this
+	 * CPU.
+	 */
+	if (get_matching_mc(mc_intel, cpu) == 0)
+		return 0;
+
 	/* write microcode via MSR 0x79 */
 	wrmsr(MSR_IA32_UCODE_WRITE,
 	      (unsigned long) mc_intel->bits,
@@ -338,6 +190,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 	unsigned int leftover = size;
 	enum ucode_state state = UCODE_OK;
 	unsigned int curr_mc_size = 0;
+	unsigned int csig, cpf;
 
 	while (leftover) {
 		struct microcode_header_intel mc_header;
@@ -362,11 +215,13 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 		}
 
 		if (get_ucode_data(mc, ucode_ptr, mc_size) ||
-		    microcode_sanity_check(mc) < 0) {
+		    microcode_sanity_check(mc, 1) < 0) {
 			break;
 		}
 
-		if (get_matching_microcode(&uci->cpu_sig, mc, new_rev)) {
+		csig = uci->cpu_sig.sig;
+		cpf = uci->cpu_sig.pf;
+		if (get_matching_microcode(csig, cpf, mc, new_rev)) {
 			vfree(new_mc);
 			new_rev = mc_header.rev;
 			new_mc  = mc;
@@ -393,6 +248,13 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 	vfree(uci->mc);
 	uci->mc = (struct microcode_intel *)new_mc;
 
+	/*
+	 * If early loading microcode is supported, save this mc into
+	 * permanent memory. So it will be loaded early when a CPU is hot added
+	 * or resumes.
+	 */
+	save_mc_for_early(new_mc);
+
 	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
 		 cpu, new_rev, uci->cpu_sig.rev);
 out:
-- 
1.8.0.1

