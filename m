Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1GNVbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:31:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:33872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab1GNVbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:31:42 -0400
Date: Thu, 14 Jul 2011 21:31:34 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-ed7b56a799cade11f458cd83e1150af54a66b7e8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310462166-31469-2-git-send-email-tj@kernel.org>
References: <1310462166-31469-2-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Remove memblock_memory_can_coalesce()
Git-Commit-ID: ed7b56a799cade11f458cd83e1150af54a66b7e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:31:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed7b56a799cade11f458cd83e1150af54a66b7e8
Gitweb:     http://git.kernel.org/tip/ed7b56a799cade11f458cd83e1150af54a66b7e8
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 11:15:54 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:40 -0700

memblock: Remove memblock_memory_can_coalesce()

Arch could implement memblock_memor_can_coalesce() to veto merging of
adjacent or overlapping memblock regions; however, no arch did and any
vetoing would trigger WARN_ON().  Memblock regions are supposed to
deal with proper memory anyway.  Remove the unused hook.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310462166-31469-2-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/memblock.h |    4 ----
 mm/memblock.c            |   29 -----------------------------
 2 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 7400d02..aa5df9e 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -92,10 +92,6 @@ extern int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
 extern void memblock_dump_all(void);
 
-/* Provided by the architecture */
-extern int memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
-				   phys_addr_t addr2, phys_addr_t size2);
-
 /**
  * memblock_set_current_limit - Set the current allocation limit to allow
  *                         limiting allocations to what is currently
diff --git a/mm/memblock.c b/mm/memblock.c
index a8edb42..bd3a3a9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -251,12 +251,6 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 	return 0;
 }
 
-extern int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
-					  phys_addr_t addr2, phys_addr_t size2)
-{
-	return 1;
-}
-
 static long __init_memblock memblock_add_region(struct memblock_type *type,
 						phys_addr_t base, phys_addr_t size)
 {
@@ -282,17 +276,6 @@ static long __init_memblock memblock_add_region(struct memblock_type *type,
 		 * of a block.
 		 */
 		if (base < rgn->base && end >= rgn->base) {
-			/* If we can't coalesce, create a new block */
-			if (!memblock_memory_can_coalesce(base, size,
-							  rgn->base,
-							  rgn->size)) {
-				/* Overlap & can't coalesce are mutually
-				 * exclusive, if you do that, be prepared
-				 * for trouble
-				 */
-				WARN_ON(end != rgn->base);
-				goto new_block;
-			}
 			/* We extend the bottom of the block down to our
 			 * base
 			 */
@@ -316,17 +299,6 @@ static long __init_memblock memblock_add_region(struct memblock_type *type,
 		 * top of a block
 		 */
 		if (base <= rend && end >= rend) {
-			/* If we can't coalesce, create a new block */
-			if (!memblock_memory_can_coalesce(rgn->base,
-							  rgn->size,
-							  base, size)) {
-				/* Overlap & can't coalesce are mutually
-				 * exclusive, if you do that, be prepared
-				 * for trouble
-				 */
-				WARN_ON(rend != base);
-				goto new_block;
-			}
 			/* We adjust our base down to enclose the
 			 * original block and destroy it. It will be
 			 * part of our new allocation. Since we've
@@ -349,7 +321,6 @@ static long __init_memblock memblock_add_region(struct memblock_type *type,
 		return 0;
 	}
 
- new_block:
 	/* If we are out of space, we fail. It's too late to resize the array
 	 * but then this shouldn't have happened in the first place.
 	 */
