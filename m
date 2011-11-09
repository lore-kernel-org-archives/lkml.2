Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1KILhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:37:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57606 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1KILhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:37:35 -0500
Message-ID: <4EBA65FA.1010605@gmail.com>
Date: Wed, 09 Nov 2011 19:37:30 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: yinghai@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mm/memblock.c: eliminate potential memleak in memblock_double_array
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In memblock_double_array, we don't deal with old_array if we use
slab for new_array. So the memory used by old_array may be lost.
Add logic to try to free old_array when using slab for new_array.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mm/memblock.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 09ff05b..0e4248f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -250,13 +250,17 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 	type->regions = new_array;
 	type->max <<= 1;
 
-	/* If we use SLAB that's it, we are done */
-	if (use_slab)
+	if (use_slab) {
+		if (memblock_is_region_reserved(__pa(old_array), old_size))
+			goto old_memblock;
+		kfree(old_array);
 		return 0;
+	}
 
 	/* Add the new reserved region now. Should not fail ! */
 	BUG_ON(memblock_add_region(&memblock.reserved, addr, new_size));
 
+old_memblock:
 	/* If the array wasn't our static init one, then free it. We only do
 	 * that before SLAB is available as later on, we don't know whether
 	 * to use kfree or free_bootmem_pages(). Shouldn't be a big deal
-- 
1.7.1

