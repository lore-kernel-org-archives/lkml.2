Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0HRQ5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:57:04 -0400
Received: from relay3.sgi.com ([192.48.152.1]:38887 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752558Ab0HRQ45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:56:57 -0400
Date: Wed, 18 Aug 2010 11:56:53 -0500
From: Robin Holt <holt@sgi.com>
To: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@ppc970.osdl.org>,
        Joerg Roedel <joerg.roedel@amd.com>, Andi Kleen <ak@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: [Patch] numa:x86_64: Cacheline aliasing makes
 for_each_populated_zone extremely expensive.
Message-ID: <20100818165653.GX3043@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [Patch] numa:x86_64: Cacheline aliasing makes for_each_populated_zone extremely expensive.

While testing on a 256 node, 4096 cpus system, Jack Steiner noticed
that we would use between 0.08% average and 0.8% max of every second
in vmstat_update.  This could be tuned using sysctl's stat_interval,
but that was simply reducing the impact of the problem.

When I investigated, I noticed that all the zone_data[] structures are
allocated precisely at the beginning of the individual node's physical
memory.  By simply staggering based upon nodeid, I reduced the average
down to 0.0006% of every second.

With this patch, the max value did not change.  I believe that is a
combination of cacheline contention updating the zone's vmstat information
combined with round_jiffies_common spattering unrelated cpus onto the same
jiffie for their next update.  I will investigate those issues seperately.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@ppc970.osdl.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Stable Maintainers <stable@kernel.org>

---

This patch applies cleanly to v2.6.34 and later.  It manually applies
to previous kernels but the x86-bootmem fixes introduce differences in
the surrounding areas.

I had no idea whether to ask stable@kernel.org to pull this back to the
stable releases.  My reading of the stable_kernel_rules.txt criteria is
only fuzzy as to whether this meets the "oh, that's not good" standard.
I personally think this meets that criteria, but I am unwilling to defend
that position too stridently.  In the end, I punted and added them to
the Cc list.  We will be asking both SuSE and RedHat to add this to
their upcoming update releases as we expect it to affect their customers.

 arch/x86/mm/numa_64.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: round_jiffies/arch/x86/mm/numa_64.c
===================================================================
--- round_jiffies.orig/arch/x86/mm/numa_64.c	2010-08-18 11:39:20.495141178 -0500
+++ round_jiffies/arch/x86/mm/numa_64.c	2010-08-18 11:47:18.391210989 -0500
@@ -198,6 +198,7 @@ setup_node_bootmem(int nodeid, unsigned
 	unsigned long start_pfn, last_pfn, nodedata_phys;
 	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	int nid;
+	int cache_alias_offset;
 #ifndef CONFIG_NO_BOOTMEM
 	unsigned long bootmap_start, bootmap_pages, bootmap_size;
 	void *bootmap;
@@ -221,9 +222,16 @@ setup_node_bootmem(int nodeid, unsigned
 	start_pfn = start >> PAGE_SHIFT;
 	last_pfn = end >> PAGE_SHIFT;
 
-	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
+	/*
+	 * Allocate an extra cacheline per node to reduce cacheline
+	 * aliasing when scanning all node's node_data.
+	 */
+	cache_alias_offset = nodeid * SMP_CACHE_BYTES;
+	node_data[nodeid] = cache_alias_offset +
+			    early_node_mem(nodeid, start, end,
+					   pgdat_size + cache_alias_offset,
 					   SMP_CACHE_BYTES);
-	if (node_data[nodeid] == NULL)
+	if (node_data[nodeid] == cache_alias_offset)
 		return;
 	nodedata_phys = __pa(node_data[nodeid]);
 	reserve_early(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
