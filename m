Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab1CaN5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:57:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64527 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab1CaN5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ohpHyl5ZFYtWb+UeAglhMeJQuYQtazS8ycfJGCMYNDl/jrGC+y8fjwtOvXq3s8ocTA
         zwUZ4nTdvBxvDaJQSWyZ8OPNLf9sD+ZX3FqvbGH+65BsV2p2GOB/zToMEZCjycnkEOPb
         P8eMz5tvqc6TXXW2h98wwHd+cly8ptE+IbmjQ=
Date: Thu, 31 Mar 2011 15:57:44 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH tip:x86/mm] x86-64, NUMA: Remove custom phys_to_nid()
 implementation
Message-ID: <20110331135744.GE3385@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

phys_to_nid() maps physical address to NUMA node id.  This is
implemented by building perfect hash in compute_hash_shift() during
initialization.

However, with SPARSE memory model, the nid is encoded in page flags.
The perfect hash implementation was for DISCONTIG memory model which
got removed years ago by b263295dbf (x86: 64-bit, make sparsemem
vmemmap the only memory model).

So, the perfect hash ends up being used only during initialization
when the core SPARSE code already provides perfectly acceptable
generic early_pfn_to_nid() implementation.

Drop phys_to_nid() and use the generic ealry_pfn_to_nid() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
If no one objects, will route through x86-mm.  Thanks.

 arch/x86/Kconfig                 |    4 -
 arch/x86/include/asm/mmzone_64.h |   23 -------
 arch/x86/mm/numa_64.c            |  123 ---------------------------------------
 3 files changed, 1 insertion(+), 149 deletions(-)

Index: work/arch/x86/include/asm/mmzone_64.h
===================================================================
--- work.orig/arch/x86/include/asm/mmzone_64.h
+++ work/arch/x86/include/asm/mmzone_64.h
@@ -4,36 +4,13 @@
 #ifndef _ASM_X86_MMZONE_64_H
 #define _ASM_X86_MMZONE_64_H
 
-
 #ifdef CONFIG_NUMA
 
 #include <linux/mmdebug.h>
-
 #include <asm/smp.h>
 
-/* Simple perfect hash to map physical addresses to node numbers */
-struct memnode {
-	int shift;
-	unsigned int mapsize;
-	s16 *map;
-	s16 embedded_map[64 - 8];
-} ____cacheline_aligned; /* total size = 128 bytes */
-extern struct memnode memnode;
-#define memnode_shift memnode.shift
-#define memnodemap memnode.map
-#define memnodemapsize memnode.mapsize
-
 extern struct pglist_data *node_data[];
 
-static inline __attribute__((pure)) int phys_to_nid(unsigned long addr)
-{
-	unsigned nid;
-	VIRTUAL_BUG_ON(!memnodemap);
-	nid = memnodemap[addr >> memnode_shift];
-	VIRTUAL_BUG_ON(nid >= MAX_NUMNODES || !node_data[nid]);
-	return nid;
-}
-
 #define NODE_DATA(nid)		(node_data[nid])
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
Index: work/arch/x86/mm/numa_64.c
===================================================================
--- work.orig/arch/x86/mm/numa_64.c
+++ work/arch/x86/mm/numa_64.c
@@ -28,125 +28,10 @@ EXPORT_SYMBOL(node_data);
 
 nodemask_t numa_nodes_parsed __initdata;
 
-struct memnode memnode;
-
-static unsigned long __initdata nodemap_addr;
-static unsigned long __initdata nodemap_size;
-
 static struct numa_meminfo numa_meminfo __initdata;
-
 static int numa_distance_cnt;
 static u8 *numa_distance;
 
-/*
- * Given a shift value, try to populate memnodemap[]
- * Returns :
- * 1 if OK
- * 0 if memnodmap[] too small (of shift too small)
- * -1 if node overlap or lost ram (shift too big)
- */
-static int __init populate_memnodemap(const struct numa_meminfo *mi, int shift)
-{
-	unsigned long addr, end;
-	int i, res = -1;
-
-	memset(memnodemap, 0xff, sizeof(s16)*memnodemapsize);
-	for (i = 0; i < mi->nr_blks; i++) {
-		addr = mi->blk[i].start;
-		end = mi->blk[i].end;
-		if (addr >= end)
-			continue;
-		if ((end >> shift) >= memnodemapsize)
-			return 0;
-		do {
-			if (memnodemap[addr >> shift] != NUMA_NO_NODE)
-				return -1;
-			memnodemap[addr >> shift] = mi->blk[i].nid;
-			addr += (1UL << shift);
-		} while (addr < end);
-		res = 1;
-	}
-	return res;
-}
-
-static int __init allocate_cachealigned_memnodemap(void)
-{
-	unsigned long addr;
-
-	memnodemap = memnode.embedded_map;
-	if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
-		return 0;
-
-	addr = 0x8000;
-	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
-	nodemap_addr = memblock_find_in_range(addr, get_max_mapped(),
-				      nodemap_size, L1_CACHE_BYTES);
-	if (nodemap_addr == MEMBLOCK_ERROR) {
-		printk(KERN_ERR
-		       "NUMA: Unable to allocate Memory to Node hash map\n");
-		nodemap_addr = nodemap_size = 0;
-		return -1;
-	}
-	memnodemap = phys_to_virt(nodemap_addr);
-	memblock_x86_reserve_range(nodemap_addr, nodemap_addr + nodemap_size, "MEMNODEMAP");
-
-	printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
-	       nodemap_addr, nodemap_addr + nodemap_size);
-	return 0;
-}
-
-/*
- * The LSB of all start and end addresses in the node map is the value of the
- * maximum possible shift.
- */
-static int __init extract_lsb_from_nodes(const struct numa_meminfo *mi)
-{
-	int i, nodes_used = 0;
-	unsigned long start, end;
-	unsigned long bitfield = 0, memtop = 0;
-
-	for (i = 0; i < mi->nr_blks; i++) {
-		start = mi->blk[i].start;
-		end = mi->blk[i].end;
-		if (start >= end)
-			continue;
-		bitfield |= start;
-		nodes_used++;
-		if (end > memtop)
-			memtop = end;
-	}
-	if (nodes_used <= 1)
-		i = 63;
-	else
-		i = find_first_bit(&bitfield, sizeof(unsigned long)*8);
-	memnodemapsize = (memtop >> i)+1;
-	return i;
-}
-
-static int __init compute_hash_shift(const struct numa_meminfo *mi)
-{
-	int shift;
-
-	shift = extract_lsb_from_nodes(mi);
-	if (allocate_cachealigned_memnodemap())
-		return -1;
-	printk(KERN_DEBUG "NUMA: Using %d for the hash shift.\n",
-		shift);
-
-	if (populate_memnodemap(mi, shift) != 1) {
-		printk(KERN_INFO "Your memory is not aligned you need to "
-		       "rebuild your kernel with a bigger NODEMAPSIZE "
-		       "shift=%d\n", shift);
-		return -1;
-	}
-	return shift;
-}
-
-int __meminit  __early_pfn_to_nid(unsigned long pfn)
-{
-	return phys_to_nid(pfn << PAGE_SHIFT);
-}
-
 static void * __init early_node_mem(int nodeid, unsigned long start,
 				    unsigned long end, unsigned long size,
 				    unsigned long align)
@@ -270,7 +155,7 @@ setup_node_bootmem(int nodeid, unsigned
 	memblock_x86_reserve_range(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
 	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n", nodedata_phys,
 		nodedata_phys + pgdat_size - 1);
-	nid = phys_to_nid(nodedata_phys);
+	nid = early_pfn_to_nid(nodedata_phys >> PAGE_SHIFT);
 	if (nid != nodeid)
 		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nodeid, nid);
 
@@ -527,12 +412,6 @@ static int __init numa_register_memblks(
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
-	memnode_shift = compute_hash_shift(mi);
-	if (memnode_shift < 0) {
-		printk(KERN_ERR "NUMA: No NUMA node hash function found. Contact maintainer\n");
-		return -EINVAL;
-	}
-
 	for (i = 0; i < mi->nr_blks; i++)
 		memblock_x86_register_active_regions(mi->blk[i].nid,
 					mi->blk[i].start >> PAGE_SHIFT,
Index: work/arch/x86/Kconfig
===================================================================
--- work.orig/arch/x86/Kconfig
+++ work/arch/x86/Kconfig
@@ -1703,10 +1703,6 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 	depends on MEMORY_HOTPLUG
 
-config HAVE_ARCH_EARLY_PFN_TO_NID
-	def_bool X86_64
-	depends on NUMA
-
 config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
