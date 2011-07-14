Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1GNDkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:40:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:58786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab1GNDkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:40:04 -0400
Date: Thu, 14 Jul 2011 03:39:58 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-fc769a8e70a3348d5de49e5f69f6aff810157360@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310457490-3356-7-git-send-email-tj@kernel.org>
References: <1310457490-3356-7-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Replace memblock_find_base() with memblock_find_in_range()
Git-Commit-ID: fc769a8e70a3348d5de49e5f69f6aff810157360
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 03:39:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc769a8e70a3348d5de49e5f69f6aff810157360
Gitweb:     http://git.kernel.org/tip/fc769a8e70a3348d5de49e5f69f6aff810157360
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 09:58:10 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 16:36:02 -0700

memblock: Replace memblock_find_base() with memblock_find_in_range()

memblock_find_base() is a static function with two callers in
memblock.c and memblock_find_in_range() is a wrapper around it which
just changes the types and order of parameters.

Make memblock_find_in_range() take phys_addr_t instead of u64 for
consistency and replace memblock_find_base() with it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310457490-3356-7-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/memblock.h |    3 ++-
 mm/memblock.c            |   19 +++++++------------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d235ec5..3496888 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -46,7 +46,8 @@ extern int memblock_can_resize;
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
-u64 memblock_find_in_range(u64 start, u64 end, u64 size, u64 align);
+phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
+				   phys_addr_t size, phys_addr_t align);
 int memblock_free_reserved_regions(void);
 int memblock_reserve_reserved_regions(void);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 1969936..0f9626f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -97,8 +97,11 @@ static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_
 	return 0;
 }
 
-static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
-			phys_addr_t align, phys_addr_t start, phys_addr_t end)
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+phys_addr_t __init_memblock memblock_find_in_range(phys_addr_t start, phys_addr_t end,
+					phys_addr_t size, phys_addr_t align)
 {
 	long i;
 
@@ -133,14 +136,6 @@ static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
 }
 
 /*
- * Find a free area with specified alignment in a specific range.
- */
-u64 __init_memblock memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
-{
-	return memblock_find_base(size, align, start, end);
-}
-
-/*
  * Free memblock.reserved.regions
  */
 int __init_memblock memblock_free_reserved_regions(void)
@@ -216,7 +211,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 		new_array = kmalloc(new_size, GFP_KERNEL);
 		addr = new_array ? __pa(new_array) : 0;
 	} else
-		addr = memblock_find_base(new_size, sizeof(phys_addr_t), 0, MEMBLOCK_ALLOC_ACCESSIBLE);
+		addr = memblock_find_in_range(0, MEMBLOCK_ALLOC_ACCESSIBLE, new_size, sizeof(phys_addr_t));
 	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
 		       memblock_type_name(type), type->max, type->max * 2);
@@ -477,7 +472,7 @@ phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, ph
 	 */
 	size = round_up(size, align);
 
-	found = memblock_find_base(size, align, 0, max_addr);
+	found = memblock_find_in_range(0, max_addr, size, align);
 	if (found && !memblock_add_region(&memblock.reserved, found, size))
 		return found;
 
