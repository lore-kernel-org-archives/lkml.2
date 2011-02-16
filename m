Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1BPMVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:21:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab1BPMVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YuA+j/mZMFfKnPDaKIU7PhuTc2epINAl+gm+n3xr+xIfwg0NQzoT3t8I8iCUSchfaw
         4V8u8NvLj2+3mDxzEmHxSJ4KCm+lUAU9cKRxSGbPH4nCm0p12BXmut0P96W2tw7mMt4/
         7O+xWpEoExZD13O0MAsN8oy0pVjp2RZJejG3I=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/33] x86-64, NUMA: Kill {acpi|amd|dummy}_scan_nodes()
Date: Wed, 16 Feb 2011 13:20:50 +0100
Message-Id: <1297858867-25981-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are empty now.  Kill them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h   |    1 -
 arch/x86/include/asm/amd_nb.h |    1 -
 arch/x86/mm/amdtopology_64.c  |    5 -----
 arch/x86/mm/numa_64.c         |   11 -----------
 arch/x86/mm/srat_64.c         |    8 --------
 5 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 12bd1fd..cfa3d5c 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -186,7 +186,6 @@ struct bootnode;
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
 extern int x86_acpi_numa_init(void);
-extern int acpi_scan_nodes(void);
 
 #ifdef CONFIG_NUMA_EMU
 extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 246cdc6..384d118 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -17,7 +17,6 @@ extern int early_is_amd_nb(u32 value);
 extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
 extern int amd_numa_init(void);
-extern int amd_scan_nodes(void);
 extern int amd_get_subcaches(int);
 extern int amd_set_subcaches(int, int);
 
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 9c9f46a..90cf297 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -259,8 +259,3 @@ void __init amd_fake_nodes(const struct bootnode *nodes, int nr_nodes)
 	memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
 }
 #endif /* CONFIG_NUMA_EMU */
-
-int __init amd_scan_nodes(void)
-{
-	return 0;
-}
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 748c6b5..e211c00 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -772,25 +772,17 @@ static int dummy_numa_init(void)
 	return 0;
 }
 
-static int dummy_scan_nodes(void)
-{
-	return 0;
-}
-
 void __init initmem_init(void)
 {
 	int (*numa_init[])(void) = { [2] = dummy_numa_init };
-	int (*scan_nodes[])(void) = { [2] = dummy_scan_nodes };
 	int i, j;
 
 	if (!numa_off) {
 #ifdef CONFIG_ACPI_NUMA
 		numa_init[0] = x86_acpi_numa_init;
-		scan_nodes[0] = acpi_scan_nodes;
 #endif
 #ifdef CONFIG_AMD_NUMA
 		numa_init[1] = amd_numa_init;
-		scan_nodes[1] = amd_scan_nodes;
 #endif
 	}
 
@@ -834,9 +826,6 @@ void __init initmem_init(void)
 		if (numa_register_memblks() < 0)
 			continue;
 
-		if (scan_nodes[i]() < 0)
-			continue;
-
 		for (j = 0; j < nr_cpu_ids; j++) {
 			int nid = early_cpu_to_node(j);
 
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 4a2c33b..d56eff8 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -270,14 +270,6 @@ int __init x86_acpi_numa_init(void)
 	return srat_disabled() ? -EINVAL : 0;
 }
 
-/* Use the information discovered above to actually set up the nodes. */
-int __init acpi_scan_nodes(void)
-{
-	if (acpi_numa <= 0)
-		return -1;
-	return 0;
-}
-
 #ifdef CONFIG_NUMA_EMU
 static int fake_node_to_pxm_map[MAX_NUMNODES] __initdata = {
 	[0 ... MAX_NUMNODES-1] = PXM_INVAL
-- 
1.7.1

