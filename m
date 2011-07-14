Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1GNVcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:32:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:33902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab1GNVcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:32:11 -0400
Date: Thu, 14 Jul 2011 21:32:02 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-784656f9c680d334e7b4cdb6951c5c913e5a26bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310462166-31469-3-git-send-email-tj@kernel.org>
References: <1310462166-31469-3-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Reimplement memblock_add_region()
Git-Commit-ID: 784656f9c680d334e7b4cdb6951c5c913e5a26bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:32:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  784656f9c680d334e7b4cdb6951c5c913e5a26bf
Gitweb:     http://git.kernel.org/tip/784656f9c680d334e7b4cdb6951c5c913e5a26bf
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 11:15:55 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:41 -0700

memblock: Reimplement memblock_add_region()

memblock_add_region() carefully checked for merge and overlap
conditions while adding a new region, which is complicated and makes
it difficult to allow arbitrary overlaps or add more merge conditions
(e.g. node ID).

This re-implements memblock_add_region() such that insertion is done
in two steps - all non-overlapping portions of new area are inserted
as separate regions first and then memblock_merge_regions() scan and
merge all neighbouring compatible regions.

This makes addition logic simpler and more versatile and enables
adding node information to memblock.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310462166-31469-3-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 mm/memblock.c |  197 ++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 111 insertions(+), 86 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index bd3a3a9..992aa18 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -251,117 +251,142 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 	return 0;
 }
 
-static long __init_memblock memblock_add_region(struct memblock_type *type,
-						phys_addr_t base, phys_addr_t size)
+/**
+ * memblock_merge_regions - merge neighboring compatible regions
+ * @type: memblock type to scan
+ *
+ * Scan @type and merge neighboring compatible regions.
+ */
+static void __init_memblock memblock_merge_regions(struct memblock_type *type)
 {
-	phys_addr_t end = base + size;
-	int i, slot = -1;
+	int i = 0;
 
-	/* First try and coalesce this MEMBLOCK with others */
-	for (i = 0; i < type->cnt; i++) {
-		struct memblock_region *rgn = &type->regions[i];
-		phys_addr_t rend = rgn->base + rgn->size;
+	/* cnt never goes below 1 */
+	while (i < type->cnt - 1) {
+		struct memblock_region *this = &type->regions[i];
+		struct memblock_region *next = &type->regions[i + 1];
 
-		/* Exit if there's no possible hits */
-		if (rgn->base > end || rgn->size == 0)
-			break;
-
-		/* Check if we are fully enclosed within an existing
-		 * block
-		 */
-		if (rgn->base <= base && rend >= end)
-			return 0;
+		if (this->base + this->size != next->base) {
+			BUG_ON(this->base + this->size > next->base);
+			i++;
+			continue;
+		}
 
-		/* Check if we overlap or are adjacent with the bottom
-		 * of a block.
-		 */
-		if (base < rgn->base && end >= rgn->base) {
-			/* We extend the bottom of the block down to our
-			 * base
-			 */
-			rgn->base = base;
-			rgn->size = rend - base;
+		this->size += next->size;
+		memmove(next, next + 1, (type->cnt - (i + 1)) * sizeof(*next));
+		type->cnt--;
+	}
+}
 
-			/* Return if we have nothing else to allocate
-			 * (fully coalesced)
-			 */
-			if (rend >= end)
-				return 0;
+/**
+ * memblock_insert_region - insert new memblock region
+ * @type: memblock type to insert into
+ * @idx: index for the insertion point
+ * @base: base address of the new region
+ * @size: size of the new region
+ *
+ * Insert new memblock region [@base,@base+@size) into @type at @idx.
+ * @type must already have extra room to accomodate the new region.
+ */
+static void __init_memblock memblock_insert_region(struct memblock_type *type,
+						   int idx, phys_addr_t base,
+						   phys_addr_t size)
+{
+	struct memblock_region *rgn = &type->regions[idx];
 
-			/* We continue processing from the end of the
-			 * coalesced block.
-			 */
-			base = rend;
-			size = end - base;
-		}
+	BUG_ON(type->cnt >= type->max);
+	memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
+	rgn->base = base;
+	rgn->size = size;
+	type->cnt++;
+}
 
-		/* Now check if we overlap or are adjacent with the
-		 * top of a block
-		 */
-		if (base <= rend && end >= rend) {
-			/* We adjust our base down to enclose the
-			 * original block and destroy it. It will be
-			 * part of our new allocation. Since we've
-			 * freed an entry, we know we won't fail
-			 * to allocate one later, so we won't risk
-			 * losing the original block allocation.
-			 */
-			size += (base - rgn->base);
-			base = rgn->base;
-			memblock_remove_region(type, i--);
-		}
-	}
+/**
+ * memblock_add_region - add new memblock region
+ * @type: memblock type to add new region into
+ * @base: base address of the new region
+ * @size: size of the new region
+ *
+ * Add new memblock region [@base,@base+@size) into @type.  The new region
+ * is allowed to overlap with existing ones - overlaps don't affect already
+ * existing regions.  @type is guaranteed to be minimal (all neighbouring
+ * compatible regions are merged) after the addition.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static long __init_memblock memblock_add_region(struct memblock_type *type,
+						phys_addr_t base, phys_addr_t size)
+{
+	bool insert = false;
+	phys_addr_t obase = base, end = base + size;
+	int i, nr_new;
 
-	/* If the array is empty, special case, replace the fake
-	 * filler region and return
-	 */
-	if ((type->cnt == 1) && (type->regions[0].size == 0)) {
+	/* special case for empty array */
+	if (type->regions[0].size == 0) {
+		WARN_ON(type->cnt != 1);
 		type->regions[0].base = base;
 		type->regions[0].size = size;
 		return 0;
 	}
-
-	/* If we are out of space, we fail. It's too late to resize the array
-	 * but then this shouldn't have happened in the first place.
+repeat:
+	/*
+	 * The following is executed twice.  Once with %false @insert and
+	 * then with %true.  The first counts the number of regions needed
+	 * to accomodate the new area.  The second actually inserts them.
 	 */
-	if (WARN_ON(type->cnt >= type->max))
-		return -1;
+	base = obase;
+	nr_new = 0;
+
+	for (i = 0; i < type->cnt; i++) {
+		struct memblock_region *rgn = &type->regions[i];
+		phys_addr_t rbase = rgn->base;
+		phys_addr_t rend = rbase + rgn->size;
 
-	/* Couldn't coalesce the MEMBLOCK, so add it to the sorted table. */
-	for (i = type->cnt - 1; i >= 0; i--) {
-		if (base < type->regions[i].base) {
-			type->regions[i+1].base = type->regions[i].base;
-			type->regions[i+1].size = type->regions[i].size;
-		} else {
-			type->regions[i+1].base = base;
-			type->regions[i+1].size = size;
-			slot = i + 1;
+		if (rbase >= end)
 			break;
+		if (rend <= base)
+			continue;
+		/*
+		 * @rgn overlaps.  If it separates the lower part of new
+		 * area, insert that portion.
+		 */
+		if (rbase > base) {
+			nr_new++;
+			if (insert)
+				memblock_insert_region(type, i++, base,
+						       rbase - base);
 		}
+		/* area below @rend is dealt with, forget about it */
+		base = min(rend, end);
 	}
-	if (base < type->regions[0].base) {
-		type->regions[0].base = base;
-		type->regions[0].size = size;
-		slot = 0;
+
+	/* insert the remaining portion */
+	if (base < end) {
+		nr_new++;
+		if (insert)
+			memblock_insert_region(type, i, base, end - base);
 	}
-	type->cnt++;
 
-	/* The array is full ? Try to resize it. If that fails, we undo
-	 * our allocation and return an error
+	/*
+	 * If this was the first round, resize array and repeat for actual
+	 * insertions; otherwise, merge and return.
 	 */
-	if (type->cnt == type->max && memblock_double_array(type)) {
-		BUG_ON(slot < 0);
-		memblock_remove_region(type, slot);
-		return -1;
+	if (!insert) {
+		while (type->cnt + nr_new > type->max)
+			if (memblock_double_array(type) < 0)
+				return -ENOMEM;
+		insert = true;
+		goto repeat;
+	} else {
+		memblock_merge_regions(type);
+		return 0;
 	}
-
-	return 0;
 }
 
 long __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 {
 	return memblock_add_region(&memblock.memory, base, size);
-
 }
 
 static long __init_memblock __memblock_remove(struct memblock_type *type,
