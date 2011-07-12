Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1GLH63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:58:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53085 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1GLH60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:58:26 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] memblock: Use round_up/down() instead of memblock_align_up/down()
Date: Tue, 12 Jul 2011 09:58:08 +0200
Message-Id: <1310457490-3356-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310457490-3356-1-git-send-email-tj@kernel.org>
References: <1310457490-3356-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 87e512d..9882a88 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -41,17 +41,6 @@ static inline const char *memblock_type_name(struct memblock_type *type)
 /*
  * Address comparison utilities
  */
-
-static phys_addr_t __init_memblock memblock_align_down(phys_addr_t addr, phys_addr_t size)
-{
-	return addr & ~(size - 1);
-}
-
-static phys_addr_t __init_memblock memblock_align_up(phys_addr_t addr, phys_addr_t size)
-{
-	return (addr + (size - 1)) & ~(size - 1);
-}
-
 static unsigned long __init_memblock memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
 				       phys_addr_t base2, phys_addr_t size2)
 {
@@ -87,7 +76,7 @@ static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_
 	if (end < size)
 		return MEMBLOCK_ERROR;
 
-	base = memblock_align_down((end - size), align);
+	base = round_down(end - size, align);
 
 	/* Prevent allocations returning 0 as it's also used to
 	 * indicate an allocation failure
@@ -102,7 +91,7 @@ static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_
 		res_base = memblock.reserved.regions[j].base;
 		if (res_base < size)
 			break;
-		base = memblock_align_down(res_base - size, align);
+		base = round_down(res_base - size, align);
 	}
 
 	return MEMBLOCK_ERROR;
@@ -486,7 +475,7 @@ phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, ph
 	/* We align the size to limit fragmentation. Without this, a lot of
 	 * small allocs quickly eat up the whole reserve array on sparc
 	 */
-	size = memblock_align_up(size, align);
+	size = round_up(size, align);
 
 	found = memblock_find_base(size, align, 0, max_addr);
 	if (found != MEMBLOCK_ERROR &&
@@ -562,7 +551,7 @@ static phys_addr_t __init memblock_alloc_nid_region(struct memblock_region *mp,
 	start = mp->base;
 	end = start + mp->size;
 
-	start = memblock_align_up(start, align);
+	start = round_up(start, align);
 	while (start < end) {
 		phys_addr_t this_end;
 		int this_nid;
@@ -590,7 +579,7 @@ phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int n
 	/* We align the size to limit fragmentation. Without this, a lot of
 	 * small allocs quickly eat up the whole reserve array on sparc
 	 */
-	size = memblock_align_up(size, align);
+	size = round_up(size, align);
 
 	/* We do a bottom-up search for a region with the right
 	 * nid since that's easier considering how memblock_nid_range()
-- 
1.7.6

