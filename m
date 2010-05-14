Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab0ENTIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:08:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:39624 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab0ENTIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:08:22 -0400
Date: Fri, 14 May 2010 19:07:04 GMT
Message-Id: <201005141907.o4EJ74Ck008623@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.34/2.6.34-rc8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       David Rientjes <rientjes@google.com>,
       Frank Arnold <frank.arnold@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 May 2010 19:07:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Four more x86 fixes.  Two of them are very recent commits, but are in
fact patches that are cherry-picked from another -tip branch -- they
arrived as part of a larger patchset, but fix issues currently in
mainline.

The following changes since commit 722154e4cacf015161efe60009ae9be23d492296:
  Linus Torvalds (1):
        Merge branch 'zerolen' of git://git.kernel.org/.../jgarzik/misc-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Andreas Herrmann (1):
      x86, amd: Check X86_FEATURE_OSVW bit before accessing OSVW MSRs

Borislav Petkov (1):
      x86, k8: Fix build error when K8_NB is disabled

David Rientjes (1):
      x86: Fix fake apicid to node mapping for numa emulation

Frank Arnold (1):
      x86, cacheinfo: Turn off L3 cache index disable feature in virtualized environments

 arch/x86/include/asm/k8.h             |    5 +++++
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++++
 arch/x86/kernel/process.c             |   12 +++++++-----
 arch/x86/mm/srat_64.c                 |    3 ++-
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index f70e600..af00bd1 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -16,11 +16,16 @@ extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int k8_scan_nodes(void);
 
 #ifdef CONFIG_K8_NB
+extern int num_k8_northbridges;
+
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
 	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
 }
+
 #else
+#define num_k8_northbridges 0
+
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
 	return NULL;
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index b3eeb66..95962a9 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -340,6 +340,10 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	     (boot_cpu_data.x86_mask  < 0x1)))
 		return;
 
+	/* not in virtualized environments */
+	if (num_k8_northbridges == 0)
+		return;
+
 	this_leaf->can_disable = true;
 	this_leaf->l3_indices  = amd_calc_l3_indices();
 }
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 28ad9f4..0415c3e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -546,11 +546,13 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 		 * check OSVW bit for CPUs that are not affected
 		 * by erratum #400
 		 */
-		rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
-		if (val >= 2) {
-			rdmsrl(MSR_AMD64_OSVW_STATUS, val);
-			if (!(val & BIT(1)))
-				goto no_c1e_idle;
+		if (cpu_has(c, X86_FEATURE_OSVW)) {
+			rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
+			if (val >= 2) {
+				rdmsrl(MSR_AMD64_OSVW_STATUS, val);
+				if (!(val & BIT(1)))
+					goto no_c1e_idle;
+			}
 		}
 		return 1;
 	}
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 28c6876..38512d0 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -461,7 +461,8 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 		 * node, it must now point to the fake node ID.
 		 */
 		for (j = 0; j < MAX_LOCAL_APIC; j++)
-			if (apicid_to_node[j] == nid)
+			if (apicid_to_node[j] == nid &&
+			    fake_apicid_to_node[j] == NUMA_NO_NODE)
 				fake_apicid_to_node[j] = i;
 	}
 	for (i = 0; i < num_nodes; i++)
