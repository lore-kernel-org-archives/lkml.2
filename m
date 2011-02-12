Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1BLRNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:13:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab1BLRLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ax60sJmNE3lciYjRsq3ar5H2gU93GmuUz4kB95AySsJ6ayDsFMyobGCqhV886zVCLE
         UldUjxbnxg0WAXEj2my8FqamdEGNjoECtpnQ1CGCrI66gYkeHDC0RKKo1IKfHRsznSMl
         4eM8nVIhae8OMRT3wnicsySymhIH4nGW4LRsU=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/26] x86-64, NUMA: Add common find_node_by_addr()
Date: Sat, 12 Feb 2011 18:10:59 +0100
Message-Id: <1297530663-26234-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

srat_64.c and amdtopology_64.c had their own versions of
find_node_by_addr() which were basically the same.  Add common one in
numa_64.c and remove the duplicates.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa_64.h |    1 +
 arch/x86/mm/amdtopology_64.c   |   13 -------------
 arch/x86/mm/numa_64.c          |   19 +++++++++++++++++++
 arch/x86/mm/srat_64.c          |   18 ------------------
 4 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index fbc9d33..867d41b 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -36,6 +36,7 @@ extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
 void numa_emu_cmdline(char *);
+int __init find_node_by_addr(unsigned long addr);
 #endif /* CONFIG_NUMA_EMU */
 #else
 static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 90cf297..8f7a5eb 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -205,19 +205,6 @@ static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
-static int __init find_node_by_addr(unsigned long addr)
-{
-	int ret = NUMA_NO_NODE;
-	int i;
-
-	for (i = 0; i < 8; i++)
-		if (addr >= numa_nodes[i].start && addr < numa_nodes[i].end) {
-			ret = i;
-			break;
-		}
-	return ret;
-}
-
 /*
  * For NUMA emulation, fake proximity domain (_PXM) to node id mappings must be
  * setup to represent the physical topology but reflect the emulated
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 1996ee7..ea3fb52 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -428,6 +428,25 @@ void __init numa_emu_cmdline(char *str)
 	cmdline = str;
 }
 
+int __init find_node_by_addr(unsigned long addr)
+{
+	int ret = NUMA_NO_NODE;
+	int i;
+
+	for_each_node_mask(i, mem_nodes_parsed) {
+		/*
+		 * Find the real node that this emulated node appears on.  For
+		 * the sake of simplicity, we only use a real node's starting
+		 * address to determine which emulated node it appears on.
+		 */
+		if (addr >= numa_nodes[i].start && addr < numa_nodes[i].end) {
+			ret = i;
+			break;
+		}
+	}
+	return ret;
+}
+
 static int __init setup_physnodes(unsigned long start, unsigned long end)
 {
 	int ret = 0;
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index d56eff8..51d0733 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -277,24 +277,6 @@ static int fake_node_to_pxm_map[MAX_NUMNODES] __initdata = {
 static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
-static int __init find_node_by_addr(unsigned long addr)
-{
-	int ret = NUMA_NO_NODE;
-	int i;
-
-	for_each_node_mask(i, mem_nodes_parsed) {
-		/*
-		 * Find the real node that this emulated node appears on.  For
-		 * the sake of simplicity, we only use a real node's starting
-		 * address to determine which emulated node it appears on.
-		 */
-		if (addr >= numa_nodes[i].start && addr < numa_nodes[i].end) {
-			ret = i;
-			break;
-		}
-	}
-	return ret;
-}
 
 /*
  * In NUMA emulation, we need to setup proximity domain (_PXM) to node ID
-- 
1.7.1

