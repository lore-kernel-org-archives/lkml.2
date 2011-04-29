Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1D2Pb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:31:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759428Ab1D2P3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=aVqwaqNPFCevDlJsawf+aF9lGeDaVAsB77QN8JKRCd22maEdvb0aAuZ4ykE7i1QPLS
         fU8OGKyFja11RsaHk2DV6jLA8UkojC2490meMAvRZ2Zn7r0iJadaMXmkGzFlOu4VDoYJ
         4LP2psDmIo6obRtxkDTotg+dl4cR3kY5Ri3tI=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/25] x86, NUMA: Enable build of generic NUMA init code on 32bit
Date: Fri, 29 Apr 2011 17:28:36 +0200
Message-Id: <1304090924-8197-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic NUMA init code was moved to numa.c from numa_64.c but is still
guaraded by CONFIG_X86_64.  This patch removes the compile guard and
enables compiling on 32bit.

* numa_add_memblk() and numa_set_distance() clash with the shim
  implementation in numa_32.c and are left out.

* memory_add_physaddr_to_nid() clashes with 32bit implementation and
  is left out.

* MAX_DMA_PFN definition in dma.h moved out of !CONFIG_X86_32.

* node_data definition in numa_32.c removed in favor of the one in
  numa.c.

There are places where ulong is assumed to be 64bit.  The next patch
will fix them up.  Note that although the code is compiled it isn't
used yet and this patch doesn't cause any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/dma.h |    6 +++---
 arch/x86/mm/numa.c         |   10 ++++------
 arch/x86/mm/numa_32.c      |    3 ---
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
index 057099e..d1a314b 100644
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -69,6 +69,9 @@
 
 #define MAX_DMA_CHANNELS	8
 
+/* 16MB ISA DMA zone */
+#define MAX_DMA_PFN   ((16 * 1024 * 1024) >> PAGE_SHIFT)
+
 #ifdef CONFIG_X86_32
 
 /* The maximum address that we can perform a DMA transfer to on this platform */
@@ -76,9 +79,6 @@
 
 #else
 
-/* 16MB ISA DMA zone */
-#define MAX_DMA_PFN   ((16 * 1024 * 1024) >> PAGE_SHIFT)
-
 /* 4GB broken PCI/AGP hardware bus master zone */
 #define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 3b20547..22dc9ed 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -23,7 +23,6 @@
 int __initdata numa_off;
 nodemask_t numa_nodes_parsed __initdata;
 
-#ifdef CONFIG_X86_64
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
@@ -35,7 +34,6 @@ __initdata
 
 static int numa_distance_cnt;
 static u8 *numa_distance;
-#endif
 
 static __init int numa_setup(char *opt)
 {
@@ -134,7 +132,6 @@ void __init setup_node_to_cpumask_map(void)
 	pr_debug("Node to cpumask map for %d nodes\n", nr_node_ids);
 }
 
-#ifdef CONFIG_X86_64
 static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
 				     struct numa_meminfo *mi)
 {
@@ -176,6 +173,7 @@ void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
 		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
 }
 
+#ifdef CONFIG_X86_64
 /**
  * numa_add_memblk - Add one numa_memblk to numa_meminfo
  * @nid: NUMA node ID of the new memblk
@@ -191,6 +189,7 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 {
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
 }
+#endif
 
 /* Initialize bootmem allocator for a node */
 static void __init
@@ -402,6 +401,7 @@ static int __init numa_alloc_distance(void)
 	return 0;
 }
 
+#ifdef CONFIG_X86_64
 /**
  * numa_set_distance - Set NUMA distance from one NUMA to another
  * @from: the 'from' node to set distance
@@ -440,6 +440,7 @@ void __init numa_set_distance(int from, int to, int distance)
 
 	numa_distance[from * numa_distance_cnt + to] = distance;
 }
+#endif
 
 int __node_distance(int from, int to)
 {
@@ -518,7 +519,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 
 	return 0;
 }
-#endif
 
 /*
  * There are unfortunately some poorly designed mainboards around that
@@ -542,7 +542,6 @@ void __init numa_init_array(void)
 	}
 }
 
-#ifdef CONFIG_X86_64
 static int __init numa_init(int (*init_func)(void))
 {
 	int i;
@@ -627,7 +626,6 @@ void __init x86_numa_init(void)
 
 	numa_init(dummy_numa_init);
 }
-#endif
 
 static __init int find_near_online_node(int node)
 {
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 14135e5..975a76f 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -41,9 +41,6 @@
 #include <asm/bios_ebda.h>
 #include <asm/proto.h>
 
-struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL(node_data);
-
 /*
  * numa interface - we expect the numa architecture specific code to have
  *                  populated the following initialisation.
-- 
1.7.1

