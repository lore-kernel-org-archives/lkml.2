Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1K1Tcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:32:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1K1Tcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:32:41 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/23] powerpc: Use HAVE_MEMBLOCK_NODE_MAP
Date: Mon, 28 Nov 2011 11:31:17 -0800
Message-Id: <1322508685-32532-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc doesn't access early_node_map[] directly and enabling
HAVE_MEMBLOCK_NODE_MAP is trivial - replacing add_active_range() calls
with memblock_set_node() and selecting HAVE_MEMBLOCK_NODE_MAP is
enough.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 arch/powerpc/Kconfig   |    1 +
 arch/powerpc/mm/mem.c  |    2 +-
 arch/powerpc/mm/numa.c |   10 ++++------
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 951e18f..8516477 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -117,6 +117,7 @@ config PPC
 	select HAVE_KRETPROBES
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select USE_GENERIC_SMP_HELPERS if SMP
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 2dd6bdd..8e2eb66 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -199,7 +199,7 @@ void __init do_init_bootmem(void)
 		unsigned long start_pfn, end_pfn;
 		start_pfn = memblock_region_memory_base_pfn(reg);
 		end_pfn = memblock_region_memory_end_pfn(reg);
-		add_active_range(0, start_pfn, end_pfn);
+		memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
 	}
 
 	/* Add all physical memory to the bootmem map, mark each area
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 261adbd..e6eea0a 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -690,9 +690,7 @@ static void __init parse_drconf_memory(struct device_node *memory)
 			node_set_online(nid);
 			sz = numa_enforce_memory_limit(base, size);
 			if (sz)
-				add_active_range(nid, base >> PAGE_SHIFT,
-						 (base >> PAGE_SHIFT)
-						 + (sz >> PAGE_SHIFT));
+				memblock_set_node(base, sz, nid);
 		} while (--ranges);
 	}
 }
@@ -782,8 +780,7 @@ new_range:
 				continue;
 		}
 
-		add_active_range(nid, start >> PAGE_SHIFT,
-				(start >> PAGE_SHIFT) + (size >> PAGE_SHIFT));
+		memblock_set_node(start, size, nid);
 
 		if (--ranges)
 			goto new_range;
@@ -819,7 +816,8 @@ static void __init setup_nonnuma(void)
 		end_pfn = memblock_region_memory_end_pfn(reg);
 
 		fake_numa_create_new_node(end_pfn, &nid);
-		add_active_range(nid, start_pfn, end_pfn);
+		memblock_set_node(PFN_PHYS(start_pfn),
+				  PFN_PHYS(end_pfn - start_pfn), nid);
 		node_set_online(nid);
 	}
 }
-- 
1.7.3.1

