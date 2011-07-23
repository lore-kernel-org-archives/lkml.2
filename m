Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1GWNc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 09:32:56 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50293 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1GWNcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 09:32:52 -0400
Date: Sat, 23 Jul 2011 15:32:44 +0200
From: Tejun Heo <tj@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH tip:x86/memblock RFC] powerpc: Use HAVE_MEMBLOCK_NODE_MAP
Message-ID: <20110723133244.GA28497@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc doesn't access early_node_map[] directly and enabling
HAVE_MEMBLOCK_NODE_MAP is trivial - replacing add_active_range() calls
with memblock_set_node() and selecting HAVE_MEMBLOCK_NODE_MAP is
enough.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
benh, the proposed memblock changes are now in tip:x86/memblock, which
is probably scheduled for the next merge window.  This patch converts
powerpc to drop early_node_map[] and put NUMA information in memblock.
I'm planning on converting all early_node_map[] users and dropping the
code.  I don't have access to ppc NUMA machine so the patch is tested
only on a non-NUMA SMP machine.  It builds fine for all valid
combinations of of 32/64 [!]SMP [!]NUMA.

If this change is okay, how should this patch be routed?  ppc tree
pulls from x86/memblock and puts this patch on top of it?

Thanks.

 arch/powerpc/Kconfig   |    1 +
 arch/powerpc/mm/mem.c  |    2 +-
 arch/powerpc/mm/numa.c |   10 ++++------
 3 files changed, 6 insertions(+), 7 deletions(-)

Index: work/arch/powerpc/Kconfig
===================================================================
--- work.orig/arch/powerpc/Kconfig
+++ work/arch/powerpc/Kconfig
@@ -117,6 +117,7 @@ config PPC
 	select HAVE_KRETPROBES
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select USE_GENERIC_SMP_HELPERS if SMP
Index: work/arch/powerpc/mm/mem.c
===================================================================
--- work.orig/arch/powerpc/mm/mem.c
+++ work/arch/powerpc/mm/mem.c
@@ -197,7 +197,7 @@ void __init do_init_bootmem(void)
 		unsigned long start_pfn, end_pfn;
 		start_pfn = memblock_region_memory_base_pfn(reg);
 		end_pfn = memblock_region_memory_end_pfn(reg);
-		add_active_range(0, start_pfn, end_pfn);
+		memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
 	}
 
 	/* Add all physical memory to the bootmem map, mark each area
Index: work/arch/powerpc/mm/numa.c
===================================================================
--- work.orig/arch/powerpc/mm/numa.c
+++ work/arch/powerpc/mm/numa.c
@@ -680,9 +680,7 @@ static void __init parse_drconf_memory(s
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
@@ -772,8 +770,7 @@ new_range:
 				continue;
 		}
 
-		add_active_range(nid, start >> PAGE_SHIFT,
-				(start >> PAGE_SHIFT) + (size >> PAGE_SHIFT));
+		memblock_set_node(start, size, nid);
 
 		if (--ranges)
 			goto new_range;
@@ -808,7 +805,8 @@ static void __init setup_nonnuma(void)
 		end_pfn = memblock_region_memory_end_pfn(reg);
 
 		fake_numa_create_new_node(end_pfn, &nid);
-		add_active_range(nid, start_pfn, end_pfn);
+		memblock_set_node(PFN_PHYS(start_pfn),
+				  PFN_PHYS(end_pfn - start_pfn), nid);
 		node_set_online(nid);
 	}
 }
