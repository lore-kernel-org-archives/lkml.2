Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1GNDlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:41:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:57695 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab1GNDlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:41:11 -0400
Date: Thu, 14 Jul 2011 03:39:03 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-348968eb151e2569ad0ebe19b2f9c3c25b5c816a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310457490-3356-5-git-send-email-tj@kernel.org>
References: <1310457490-3356-5-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Use round_up/down() instead of memblock_align_up/down()
Git-Commit-ID: 348968eb151e2569ad0ebe19b2f9c3c25b5c816a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 03:39:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  348968eb151e2569ad0ebe19b2f9c3c25b5c816a
Gitweb:     http://git.kernel.org/tip/348968eb151e2569ad0ebe19b2f9c3c25b5c816a
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 09:58:08 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 16:35:59 -0700

memblock: Use round_up/down() instead of memblock_align_up/down()

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310457490-3356-5-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
