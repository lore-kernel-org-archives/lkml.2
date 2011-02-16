Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab1BPM07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:26:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082Ab1BPMVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Gaw+Npmk2gwtHrefMNznIhqI0eHUJcI8Yfrr7MVRXjbBE4wbKYkTkw5Sdmnu4araci
         Kly49jxubGwetoaq79ypOcG6cnthGUqdJuF6MX4aw7Cc9y3Ria9qbc+F/zxmKkpZpF3d
         MphuUzcx17czDZ8pRMrTw2Sr1WTIJhOzPDyiw=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/33] x86-64, NUMA: Kill {acpi|amd}_get_nodes()
Date: Wed, 16 Feb 2011 13:20:46 +0100
Message-Id: <1297858867-25981-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With common numa_nodes[], common code in numa_64.c can access it
directly.  Copy directly and kill {acpi|amd}_get_nodes().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h   |    2 --
 arch/x86/include/asm/amd_nb.h |    1 -
 arch/x86/mm/amdtopology_64.c  |   10 ----------
 arch/x86/mm/numa_64.c         |   23 ++++++++++-------------
 arch/x86/mm/srat_64.c         |   13 -------------
 5 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 06fb786..446a5b9 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -185,8 +185,6 @@ struct bootnode;
 
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
-extern void acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
-				unsigned long end);
 extern int x86_acpi_numa_init(void);
 extern int acpi_scan_nodes(void);
 #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index dc3c6e3..246cdc6 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -23,7 +23,6 @@ extern int amd_set_subcaches(int, int);
 
 #ifdef CONFIG_NUMA_EMU
 extern void amd_fake_nodes(const struct bootnode *nodes, int nr_nodes);
-extern void amd_get_nodes(struct bootnode *nodes);
 #endif
 
 struct amd_northbridge {
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index f049fa6..cf29527 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -204,16 +204,6 @@ static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
-void __init amd_get_nodes(struct bootnode *physnodes)
-{
-	int i;
-
-	for_each_node_mask(i, mem_nodes_parsed) {
-		physnodes[i].start = numa_nodes[i].start;
-		physnodes[i].end = numa_nodes[i].end;
-	}
-}
-
 static int __init find_node_by_addr(unsigned long addr)
 {
 	int ret = NUMA_NO_NODE;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index a6b899f..82ee308 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -257,21 +257,18 @@ void __init numa_emu_cmdline(char *str)
 	cmdline = str;
 }
 
-static int __init setup_physnodes(unsigned long start, unsigned long end,
-					int acpi, int amd)
+static int __init setup_physnodes(unsigned long start, unsigned long end)
 {
 	int ret = 0;
 	int i;
 
 	memset(physnodes, 0, sizeof(physnodes));
-#ifdef CONFIG_ACPI_NUMA
-	if (acpi)
-		acpi_get_nodes(physnodes, start, end);
-#endif
-#ifdef CONFIG_AMD_NUMA
-	if (amd)
-		amd_get_nodes(physnodes);
-#endif
+
+	for_each_node_mask(i, mem_nodes_parsed) {
+		physnodes[i].start = numa_nodes[i].start;
+		physnodes[i].end = numa_nodes[i].end;
+	}
+
 	/*
 	 * Basic sanity checking on the physical node map: there may be errors
 	 * if the SRAT or AMD code incorrectly reported the topology or the mem=
@@ -594,7 +591,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 	init_memory_mapping_high();
 	for_each_node_mask(i, node_possible_map)
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-	setup_physnodes(addr, max_addr, acpi, amd);
+	setup_physnodes(addr, max_addr);
 	fake_physnodes(acpi, amd, num_nodes);
 	numa_init_array();
 	return 0;
@@ -666,10 +663,10 @@ void __init initmem_init(void)
 			cutoff_node(j, 0, max_pfn << PAGE_SHIFT);
 
 #ifdef CONFIG_NUMA_EMU
-		setup_physnodes(0, max_pfn << PAGE_SHIFT, i == 0, i == 1);
+		setup_physnodes(0, max_pfn << PAGE_SHIFT);
 		if (cmdline && !numa_emulation(0, max_pfn, i == 0, i == 1))
 			return;
-		setup_physnodes(0, max_pfn << PAGE_SHIFT, i == 0, i == 1);
+		setup_physnodes(0, max_pfn << PAGE_SHIFT);
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
 #endif
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index bfa4a6a..82b1087 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -323,19 +323,6 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 
 void __init acpi_numa_arch_fixup(void) {}
 
-#ifdef CONFIG_NUMA_EMU
-void __init acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
-				unsigned long end)
-{
-	int i;
-
-	for_each_node_mask(i, mem_nodes_parsed) {
-		physnodes[i].start = numa_nodes[i].start;
-		physnodes[i].end = numa_nodes[i].end;
-	}
-}
-#endif /* CONFIG_NUMA_EMU */
-
 int __init x86_acpi_numa_init(void)
 {
 	int ret;
-- 
1.7.1

