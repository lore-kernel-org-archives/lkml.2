Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1K1Tbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:31:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1K1Tbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:31:42 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/23] memblock: Use memblock_reserve() in memblock internal functions
Date: Mon, 28 Nov 2011 11:31:05 -0800
Message-Id: <1322508685-32532-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make memblock_double_array(), __memblock_alloc_base() and
memblock_alloc_nid() use memblock_reserve() instead of calling
memblock_add_region() with reserved array directly.  This eases
debugging and updates to memblock_add_region().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 9480367..d050618 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -175,9 +175,6 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
 	}
 }
 
-/* Defined below but needed now */
-static int memblock_add_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size);
-
 static int __init_memblock memblock_double_array(struct memblock_type *type)
 {
 	struct memblock_region *new_array, *old_array;
@@ -235,7 +232,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 		return 0;
 
 	/* Add the new reserved region now. Should not fail ! */
-	BUG_ON(memblock_add_region(&memblock.reserved, addr, new_size));
+	BUG_ON(memblock_reserve(addr, new_size));
 
 	/* If the array wasn't our static init one, then free it. We only do
 	 * that before SLAB is available as later on, we don't know whether
@@ -652,7 +649,7 @@ phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, ph
 	size = round_up(size, align);
 
 	found = memblock_find_in_range(0, max_addr, size, align);
-	if (found && !memblock_add_region(&memblock.reserved, found, size))
+	if (found && !memblock_reserve(found, size))
 		return found;
 
 	return 0;
@@ -748,7 +745,7 @@ phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int n
 
 	found = memblock_find_in_range_node(0, MEMBLOCK_ALLOC_ACCESSIBLE,
 					    size, align, nid);
-	if (found && !memblock_add_region(&memblock.reserved, found, size))
+	if (found && !memblock_reserve(found, size))
 		return found;
 
 	return 0;
-- 
1.7.3.1

