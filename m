Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1K1TcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:32:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1K1TcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:32:11 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/23] memblock: Make memblock functions handle overflowing range @size
Date: Mon, 28 Nov 2011 11:31:11 -0800
Message-Id: <1322508685-32532-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow memblock users to specify range where @base + @size overflows
and automatically cap it at maximum.  This makes the interface more
robust and specifying till-the-end-of-memory easier.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index fffe68b..945dc31 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -49,6 +49,12 @@ static inline const char *memblock_type_name(struct memblock_type *type)
 		return "unknown";
 }
 
+/* adjust *@size so that (@base + *@size) doesn't overflow, return new size */
+static inline phys_addr_t memblock_cap_size(phys_addr_t base, phys_addr_t *size)
+{
+	return *size = min(*size, (phys_addr_t)ULLONG_MAX - base);
+}
+
 /*
  * Address comparison utilities
  */
@@ -328,7 +334,8 @@ static int __init_memblock memblock_add_region(struct memblock_type *type,
 					       phys_addr_t base, phys_addr_t size)
 {
 	bool insert = false;
-	phys_addr_t obase = base, end = base + size;
+	phys_addr_t obase = base;
+	phys_addr_t end = base + memblock_cap_size(base, &size);
 	int i, nr_new;
 
 	/* special case for empty array */
@@ -420,7 +427,7 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 					phys_addr_t base, phys_addr_t size,
 					int *start_rgn, int *end_rgn)
 {
-	phys_addr_t end = base + size;
+	phys_addr_t end = base + memblock_cap_size(base, &size);
 	int i;
 
 	*start_rgn = *end_rgn = 0;
@@ -868,16 +875,18 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
 int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
 	int idx = memblock_search(&memblock.memory, base);
+	phys_addr_t end = base + memblock_cap_size(base, &size);
 
 	if (idx == -1)
 		return 0;
 	return memblock.memory.regions[idx].base <= base &&
 		(memblock.memory.regions[idx].base +
-		 memblock.memory.regions[idx].size) >= (base + size);
+		 memblock.memory.regions[idx].size) >= end;
 }
 
 int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
+	memblock_cap_size(base, &size);
 	return memblock_overlaps_region(&memblock.reserved, base, size) >= 0;
 }
 
-- 
1.7.3.1

