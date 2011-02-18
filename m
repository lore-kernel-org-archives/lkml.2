Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1BRN6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:58:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34346 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab1BRN6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:58:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pNMR4ve72BuulX8xhu5EnAQRPGrPvKvs//1AeMQ1StWmewrk3oQzPr2rDsMVk5MeX+
         S464Y1bsESJn3BWAQyIX/7VJ8vBHqbFbBLmkZHg4vOBjdT+O2sBDcYRBF3mB46JgqyYL
         B1NsSsBZ7VMN9T8bQoBoNM15tnQWLOwu6waFA=
Date: Fri, 18 Feb 2011 14:58:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 1/3 tip:x86/mm] x86-64, NUMA: Prepare numa_emulation() for
 moving NUMA emulation into a separate file
Message-ID: <20110218135836.GG21209@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update numa_emulation() such that, it

- takes @numa_meminfo and @numa_dist_cnt instead of directly
  referencing the global variables.

- copies the distance table by iterating each distance with
  node_distance() instead of memcpy'ing the distance table.

- tests emu_cmdline to determine whether emulation is requested and
  fills emu_nid_to_phys[] with identity mapping if emulation is not
  used.  This allows the caller to call numa_emulation()
  unconditionally and makes return value unncessary.

- defines dummy version if CONFIG_NUMA_EMU is disabled.

This patch doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
These three patches move NUMA emulation into a separate file.  Once
reviewed, I'll push them through misc#x86-numa branch.

Thanks.

 arch/x86/mm/numa_64.c |   56 +++++++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

Index: work/arch/x86/mm/numa_64.c
===================================================================
--- work.orig/arch/x86/mm/numa_64.c
+++ work/arch/x86/mm/numa_64.c
@@ -797,17 +797,20 @@ static int __init split_nodes_size_inter
  * Sets up the system RAM area from start_pfn to last_pfn according to the
  * numa=fake command-line option.
  */
-static bool __init numa_emulation(void)
+static void __init numa_emulation(struct numa_meminfo *numa_meminfo,
+				  int numa_dist_cnt)
 {
 	static struct numa_meminfo ei __initdata;
 	static struct numa_meminfo pi __initdata;
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
-	int phys_dist_cnt = numa_distance_cnt;
 	u8 *phys_dist = NULL;
 	int i, j, ret;
 
+	if (!emu_cmdline)
+		goto no_emu;
+
 	memset(&ei, 0, sizeof(ei));
-	pi = numa_meminfo;
+	pi = *numa_meminfo;
 
 	for (i = 0; i < MAX_NUMNODES; i++)
 		emu_nid_to_phys[i] = NUMA_NO_NODE;
@@ -830,19 +833,19 @@ static bool __init numa_emulation(void)
 	}
 
 	if (ret < 0)
-		return false;
+		goto no_emu;
 
 	if (numa_cleanup_meminfo(&ei) < 0) {
 		pr_warning("NUMA: Warning: constructed meminfo invalid, disabling emulation\n");
-		return false;
+		goto no_emu;
 	}
 
 	/*
 	 * Copy the original distance table.  It's temporary so no need to
 	 * reserve it.
 	 */
-	if (phys_dist_cnt) {
-		size_t size = phys_dist_cnt * sizeof(numa_distance[0]);
+	if (numa_dist_cnt) {
+		size_t size = numa_dist_cnt * sizeof(phys_dist[0]);
 		u64 phys;
 
 		phys = memblock_find_in_range(0,
@@ -850,14 +853,18 @@ static bool __init numa_emulation(void)
 					      size, PAGE_SIZE);
 		if (phys == MEMBLOCK_ERROR) {
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
-			return false;
+			goto no_emu;
 		}
 		phys_dist = __va(phys);
-		memcpy(phys_dist, numa_distance, size);
+
+		for (i = 0; i < numa_dist_cnt; i++)
+			for (j = 0; j < numa_dist_cnt; j++)
+				phys_dist[i * numa_dist_cnt + j] =
+					node_distance(i, j);
 	}
 
 	/* commit */
-	numa_meminfo = ei;
+	*numa_meminfo = ei;
 
 	/*
 	 * Transform __apicid_to_node table to use emulated nids by
@@ -886,18 +893,27 @@ static bool __init numa_emulation(void)
 			int physj = emu_nid_to_phys[j];
 			int dist;
 
-			if (physi >= phys_dist_cnt || physj >= phys_dist_cnt)
+			if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
 				dist = physi == physj ?
 					LOCAL_DISTANCE : REMOTE_DISTANCE;
 			else
-				dist = phys_dist[physi * phys_dist_cnt + physj];
+				dist = phys_dist[physi * numa_dist_cnt + physj];
 
 			numa_set_distance(i, j, dist);
 		}
 	}
-	return true;
+	return;
+
+no_emu:
+	/* No emulation.  Build identity emu_nid_to_phys[] for numa_add_cpu() */
+	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
+		emu_nid_to_phys[i] = i;
 }
-#endif /* CONFIG_NUMA_EMU */
+#else	/* CONFIG_NUMA_EMU */
+static inline void numa_emulation(struct numa_meminfo *numa_meminfo,
+				  int numa_dist_cnt)
+{ }
+#endif	/* CONFIG_NUMA_EMU */
 
 static int __init dummy_numa_init(void)
 {
@@ -945,15 +961,9 @@ void __init initmem_init(void)
 
 		if (numa_cleanup_meminfo(&numa_meminfo) < 0)
 			continue;
-#ifdef CONFIG_NUMA_EMU
-		/*
-		 * If requested, try emulation.  If emulation is not used,
-		 * build identity emu_nid_to_phys[] for numa_add_cpu()
-		 */
-		if (!emu_cmdline || !numa_emulation())
-			for (j = 0; j < ARRAY_SIZE(emu_nid_to_phys); j++)
-				emu_nid_to_phys[j] = j;
-#endif
+
+		numa_emulation(&numa_meminfo, numa_distance_cnt);
+
 		if (numa_register_memblks(&numa_meminfo) < 0)
 			continue;
 
