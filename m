Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab1D2Pah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:30:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47758 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150Ab1D2Pad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AiQS66Oejlkm4WFhTSuneT1+xRsMlQJmxykqs9zq1jrykwVyijHiVY1nxMlHRcqhRE
         +XKb2gf4oZE1gr4si5XyMTR5HNbDsm1ERK5TZ9JH014vLD9EcUBdqpquuTJmRV81QTC6
         NzFHo2uWiy68rsoGUtW2WeJqa6VL803POKbeg=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/25] x86, NUMA: Enable CONFIG_AMD_NUMA on 32bit too
Date: Fri, 29 Apr 2011 17:28:43 +0200
Message-Id: <1304090924-8197-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that NUMA init path is unified, amdtopology can be enabled on
32bit.  Make amdtopology.c safe on 32bit by explicitly using u64 and
drop X86_64 dependency from Kconfig.

Inclusion of bootmem.h is added for max_pfn declaration.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig          |    2 +-
 arch/x86/mm/amdtopology.c |   21 +++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8db4fbf..50cb68d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1174,7 +1174,7 @@ comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 config AMD_NUMA
 	def_bool y
 	prompt "Old style AMD Opteron NUMA detection"
-	depends on X86_64 && NUMA && PCI
+	depends on NUMA && PCI
 	---help---
 	  Enable AMD NUMA node topology detection.  You should say Y here if
 	  you have a multi processor AMD system. This uses an old method to
diff --git a/arch/x86/mm/amdtopology.c b/arch/x86/mm/amdtopology.c
index 0919c26..5247d01 100644
--- a/arch/x86/mm/amdtopology.c
+++ b/arch/x86/mm/amdtopology.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/nodemask.h>
 #include <linux/memblock.h>
+#include <linux/bootmem.h>
 
 #include <asm/io.h>
 #include <linux/pci_ids.h>
@@ -69,10 +70,10 @@ static __init void early_get_boot_cpu_id(void)
 
 int __init amd_numa_init(void)
 {
-	unsigned long start = PFN_PHYS(0);
-	unsigned long end = PFN_PHYS(max_pfn);
+	u64 start = PFN_PHYS(0);
+	u64 end = PFN_PHYS(max_pfn);
 	unsigned numnodes;
-	unsigned long prevbase;
+	u64 prevbase;
 	int i, j, nb;
 	u32 nodeid, reg;
 	unsigned int bits, cores, apicid_base;
@@ -95,7 +96,7 @@ int __init amd_numa_init(void)
 
 	prevbase = 0;
 	for (i = 0; i < 8; i++) {
-		unsigned long base, limit;
+		u64 base, limit;
 
 		base = read_pci_config(0, nb, 1, 0x40 + i*8);
 		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
@@ -107,18 +108,18 @@ int __init amd_numa_init(void)
 			continue;
 		}
 		if (nodeid >= numnodes) {
-			pr_info("Ignoring excess node %d (%lx:%lx)\n", nodeid,
+			pr_info("Ignoring excess node %d (%Lx:%Lx)\n", nodeid,
 				base, limit);
 			continue;
 		}
 
 		if (!limit) {
-			pr_info("Skipping node entry %d (base %lx)\n",
+			pr_info("Skipping node entry %d (base %Lx)\n",
 				i, base);
 			continue;
 		}
 		if ((base >> 8) & 3 || (limit >> 8) & 3) {
-			pr_err("Node %d using interleaving mode %lx/%lx\n",
+			pr_err("Node %d using interleaving mode %Lx/%Lx\n",
 			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
 			return -EINVAL;
 		}
@@ -150,19 +151,19 @@ int __init amd_numa_init(void)
 			continue;
 		}
 		if (limit < base) {
-			pr_err("Node %d bogus settings %lx-%lx.\n",
+			pr_err("Node %d bogus settings %Lx-%Lx.\n",
 			       nodeid, base, limit);
 			continue;
 		}
 
 		/* Could sort here, but pun for now. Should not happen anyroads. */
 		if (prevbase > base) {
-			pr_err("Node map not sorted %lx,%lx\n",
+			pr_err("Node map not sorted %Lx,%Lx\n",
 			       prevbase, base);
 			return -EINVAL;
 		}
 
-		pr_info("Node %d MemBase %016lx Limit %016lx\n",
+		pr_info("Node %d MemBase %016Lx Limit %016Lx\n",
 			nodeid, base, limit);
 
 		prevbase = base;
-- 
1.7.1

