Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162313Ab2GLW50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:57:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61447 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162118Ab2GLWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Pearson <greg.pearson@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 141/187] mm/memblock: fix overlapping allocation when doubling reserved array
Date: Thu, 12 Jul 2012 15:34:57 -0700
Message-Id: <20120712191535.470178415@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Pearson <greg.pearson@hp.com>

commit 48c3b583bbddad2220ca4c22319ca5d1f78b2090 upstream.

__alloc_memory_core_early() asks memblock for a range of memory then try
to reserve it.  If the reserved region array lacks space for the new
range, memblock_double_array() is called to allocate more space for the
array.  If memblock is used to allocate memory for the new array it can
end up using a range that overlaps with the range originally allocated in
__alloc_memory_core_early(), leading to possible data corruption.

With this patch memblock_double_array() now calls memblock_find_in_range()
with a narrowed candidate range (in cases where the reserved.regions array
is being doubled) so any memory allocated will not overlap with the
original range that was being reserved.  The range is narrowed by passing
in the starting address and size of the previously allocated range.  Then
the range above the ending address is searched and if a candidate is not
found, the range below the starting address is searched.

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memblock.c |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -184,7 +184,24 @@ static void __init_memblock memblock_rem
 	}
 }
 
-static int __init_memblock memblock_double_array(struct memblock_type *type)
+/**
+ * memblock_double_array - double the size of the memblock regions array
+ * @type: memblock type of the regions array being doubled
+ * @new_area_start: starting address of memory range to avoid overlap with
+ * @new_area_size: size of memory range to avoid overlap with
+ *
+ * Double the size of the @type regions array. If memblock is being used to
+ * allocate memory for a new reserved regions array and there is a previously
+ * allocated memory range [@new_area_start,@new_area_start+@new_area_size]
+ * waiting to be reserved, ensure the memory used by the new array does
+ * not overlap.
+ *
+ * RETURNS:
+ * 0 on success, -1 on failure.
+ */
+static int __init_memblock memblock_double_array(struct memblock_type *type,
+						phys_addr_t new_area_start,
+						phys_addr_t new_area_size)
 {
 	struct memblock_region *new_array, *old_array;
 	phys_addr_t old_size, new_size, addr;
@@ -222,7 +239,18 @@ static int __init_memblock memblock_doub
 		new_array = kmalloc(new_size, GFP_KERNEL);
 		addr = new_array ? __pa(new_array) : 0;
 	} else {
-		addr = memblock_find_in_range(0, MEMBLOCK_ALLOC_ACCESSIBLE, new_size, sizeof(phys_addr_t));
+		/* only exclude range when trying to double reserved.regions */
+		if (type != &memblock.reserved)
+			new_area_start = new_area_size = 0;
+
+		addr = memblock_find_in_range(new_area_start + new_area_size,
+						memblock.current_limit,
+						new_size, sizeof(phys_addr_t));
+		if (!addr && new_area_size)
+			addr = memblock_find_in_range(0,
+					min(new_area_start, memblock.current_limit),
+					new_size, sizeof(phys_addr_t));
+
 		new_array = addr ? __va(addr) : 0;
 	}
 	if (!addr) {
@@ -399,7 +427,7 @@ repeat:
 	 */
 	if (!insert) {
 		while (type->cnt + nr_new > type->max)
-			if (memblock_double_array(type) < 0)
+			if (memblock_double_array(type, obase, size) < 0)
 				return -ENOMEM;
 		insert = true;
 		goto repeat;
@@ -450,7 +478,7 @@ static int __init_memblock memblock_isol
 
 	/* we'll create at most two more regions */
 	while (type->cnt + 2 > type->max)
-		if (memblock_double_array(type) < 0)
+		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
 	for (i = 0; i < type->cnt; i++) {


