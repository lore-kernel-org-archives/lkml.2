Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab0JLUYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 16:24:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:49419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab0JLUYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 16:24:34 -0400
Date: Tue, 12 Oct 2010 20:22:28 GMT
Message-Id: <201010122022.o9CKMSJL023932@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.36
Cc: <stable@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Brown Len <len.brown@intel.com>, David Rientjes <rientjes@google.com>,
        Fenghua Yu <fenghua.yu@initel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Jean Delvare <khali@linux-fr.org>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 20:22:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As previously discussed, the last set of bug fixes for 2.6.36.  The
important one is the NUMA fix, of course.

The following changes since commit 0acc1b2afb6ded060b7d6b1b5e6ac8a00ec47547:

  Merge branch 'kvm-updates/2.6.36' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2010-10-12 09:16:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Borislav Petkov (1):
      x86, AMD, MCE thresholding: Fix the MCi_MISCj iteration order

Jin Dongming (1):
      x86, mce, therm_throt.c: Fix missing curly braces in error handling logic

Yinghai Lu (1):
      x86, numa: For each node, register the memory blocks actually used

 arch/x86/kernel/cpu/mcheck/mce_amd.c     |    9 +++------
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 ++-
 arch/x86/mm/srat_64.c                    |    8 +++++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 5e97529..39aaee5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -141,6 +141,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 				address = (low & MASK_BLKPTR_LO) >> 21;
 				if (!address)
 					break;
+
 				address += MCG_XBLK_ADDR;
 			} else
 				++address;
@@ -148,12 +149,8 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			if (rdmsr_safe(address, &low, &high))
 				break;
 
-			if (!(high & MASK_VALID_HI)) {
-				if (block)
-					continue;
-				else
-					break;
-			}
+			if (!(high & MASK_VALID_HI))
+				continue;
 
 			if (!(high & MASK_CNTP_HI)  ||
 			     (high & MASK_LOCKED_HI))
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index d9368ee..169d880 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -216,7 +216,7 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
 		err = sysfs_add_file_to_group(&sys_dev->kobj,
 					      &attr_core_power_limit_count.attr,
 					      thermal_attr_group.name);
-	if (cpu_has(c, X86_FEATURE_PTS))
+	if (cpu_has(c, X86_FEATURE_PTS)) {
 		err = sysfs_add_file_to_group(&sys_dev->kobj,
 					      &attr_package_throttle_count.attr,
 					      thermal_attr_group.name);
@@ -224,6 +224,7 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
 			err = sysfs_add_file_to_group(&sys_dev->kobj,
 					&attr_package_power_limit_count.attr,
 					thermal_attr_group.name);
+	}
 
 	return err;
 }
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index f9897f7..9c0d0d3 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -420,9 +420,11 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 	}
 
-	for_each_node_mask(i, nodes_parsed)
-		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
-						nodes[i].end >> PAGE_SHIFT);
+	for (i = 0; i < num_node_memblks; i++)
+		e820_register_active_regions(memblk_nodeid[i],
+				node_memblk_range[i].start >> PAGE_SHIFT,
+				node_memblk_range[i].end >> PAGE_SHIFT);
+
 	/* for out of order entries in SRAT */
 	sort_node_map();
 	if (!nodes_cover_memory(nodes)) {
