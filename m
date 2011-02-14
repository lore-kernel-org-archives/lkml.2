Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1BNT36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:29:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54705 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1BNT2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:28:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=NEloWoJN3xR/ZZZGJamrP7mbiiqXKXQArTljFR40zOF94p//dcNwGeBTdw5SM6S8hy
         JJrelZmcfshuWxFLvpSP4cGk5viCNppvA8ab0gtCjOkEYV5ltA2xjlZ38CJW8h5+ZnEV
         70z/jWfQucJq50oBSeq63hgER8CZ6u/30/A8I=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] x86-64, NUMA: Trivial changes to prepare for emulation updates
Date: Mon, 14 Feb 2011 20:28:29 +0100
Message-Id: <1297711715-3086-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297711715-3086-1-git-send-email-tj@kernel.org>
References: <1297711715-3086-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Separate out numa_add_memblk_to() from numa_add_memblk() so that
  different numa_meminfo can be used.

* Rename cmdline to emu_cmdline.

* Drop @start/last_pfn from numa_emulation() and use max_pfn directly.

This patch doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index b3c1418..10544c2 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -193,10 +193,9 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 	return NULL;
 }
 
-int __init numa_add_memblk(int nid, u64 start, u64 end)
+static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
+				     struct numa_meminfo *mi)
 {
-	struct numa_meminfo *mi = &numa_meminfo;
-
 	/* ignore zero length blks */
 	if (start == end)
 		return 0;
@@ -227,6 +226,11 @@ static void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
 		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
 }
 
+int __init numa_add_memblk(int nid, u64 start, u64 end)
+{
+	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
+}
+
 /* Initialize bootmem allocator for a node */
 void __init
 setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
@@ -537,11 +541,11 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 /* Numa emulation */
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode physnodes[MAX_NUMNODES] __cpuinitdata;
-static char *cmdline __initdata;
+static char *emu_cmdline __initdata;
 
 void __init numa_emu_cmdline(char *str)
 {
-	cmdline = str;
+	emu_cmdline = str;
 }
 
 int __init find_node_by_addr(unsigned long addr)
@@ -859,12 +863,10 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
  * Sets up the system RAM area from start_pfn to last_pfn according to the
  * numa=fake command-line option.
  */
-static int __init numa_emulation(unsigned long start_pfn,
-			unsigned long last_pfn, int acpi, int amd)
+static int __init numa_emulation(int acpi, int amd)
 {
 	static struct numa_meminfo ei __initdata;
-	u64 addr = start_pfn << PAGE_SHIFT;
-	u64 max_addr = last_pfn << PAGE_SHIFT;
+	const u64 max_addr = max_pfn << PAGE_SHIFT;
 	int num_nodes;
 	int i;
 
@@ -873,16 +875,16 @@ static int __init numa_emulation(unsigned long start_pfn,
 	 * the fixed node size.  Otherwise, if it is just a single number N,
 	 * split the system RAM into N fake nodes.
 	 */
-	if (strchr(cmdline, 'M') || strchr(cmdline, 'G')) {
+	if (strchr(emu_cmdline, 'M') || strchr(emu_cmdline, 'G')) {
 		u64 size;
 
-		size = memparse(cmdline, &cmdline);
-		num_nodes = split_nodes_size_interleave(addr, max_addr, size);
+		size = memparse(emu_cmdline, &emu_cmdline);
+		num_nodes = split_nodes_size_interleave(0, max_addr, size);
 	} else {
 		unsigned long n;
 
-		n = simple_strtoul(cmdline, NULL, 0);
-		num_nodes = split_nodes_interleave(addr, max_addr, n);
+		n = simple_strtoul(emu_cmdline, NULL, 0);
+		num_nodes = split_nodes_interleave(0, max_addr, n);
 	}
 
 	if (num_nodes < 0)
@@ -913,7 +915,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 						nodes[i].end >> PAGE_SHIFT);
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
-	setup_physnodes(addr, max_addr);
+	setup_physnodes(0, max_addr);
 	fake_physnodes(acpi, amd, num_nodes);
 	numa_init_array();
 	numa_emu_dist = true;
@@ -969,7 +971,7 @@ void __init initmem_init(void)
 			continue;
 #ifdef CONFIG_NUMA_EMU
 		setup_physnodes(0, max_pfn << PAGE_SHIFT);
-		if (cmdline && !numa_emulation(0, max_pfn, i == 0, i == 1))
+		if (emu_cmdline && !numa_emulation(i == 0, i == 1))
 			return;
 		setup_physnodes(0, max_pfn << PAGE_SHIFT);
 		nodes_clear(node_possible_map);
-- 
1.7.1

