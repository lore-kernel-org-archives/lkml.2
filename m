Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162484Ab2GLW5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:57:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162133Ab2GLWnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [ 139/187] mm/memblock: cleanup on duplicate VA/PA conversion
Date: Thu, 12 Jul 2012 15:34:55 -0700
Message-Id: <20120712191535.277809408@linuxfoundation.org>
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

From: Gavin Shan <shangw@linux.vnet.ibm.com>

commit 4e2f07750d9a94e8f23e86408df5ab95be88bf11 upstream.

The overall memblock has been organized into the memory regions and
reserved regions.  Initially, the memory regions and reserved regions are
stored in the predetermined arrays of "struct memblock _region".  It's
possible for the arrays to be enlarged when we have newly added regions
for them, but no enough space there.  Under the situation, We will created
double-sized array to meet the requirement.  However, the original
implementation converted the VA (Virtual Address) of the newly allocated
array of regions to PA (Physical Address), then translate back when we
allocates the new array from slab.  That's actually unnecessary.

The patch removes the duplicate VA/PA conversion.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memblock.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -212,14 +212,15 @@ static int __init_memblock memblock_doub
 	if (use_slab) {
 		new_array = kmalloc(new_size, GFP_KERNEL);
 		addr = new_array ? __pa(new_array) : 0;
-	} else
+	} else {
 		addr = memblock_find_in_range(0, MEMBLOCK_ALLOC_ACCESSIBLE, new_size, sizeof(phys_addr_t));
+		new_array = addr ? __va(addr) : 0;
+	}
 	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
 		       memblock_type_name(type), type->max, type->max * 2);
 		return -1;
 	}
-	new_array = __va(addr);
 
 	memblock_dbg("memblock: %s array is doubled to %ld at [%#010llx-%#010llx]",
 		 memblock_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size - 1);


