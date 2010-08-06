Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935394Ab0HFFZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:25:34 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41653 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933672Ab0HFFPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:33 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 05/43] memblock/arm: pfn_valid uses memblock_is_memory()
Date: Fri,  6 Aug 2010 15:14:46 +1000
Message-Id: <1281071724-28740-6-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation is pretty much similar. There is a -small- added
overhead by having another function call and the address shift.

If that becomes a concern, I suppose we could actually have memblock
itself expose a memblock_pfn_valid() which then ARM can use directly
with an appropriate #define...

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/arm/mm/init.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index d1496e6..e739223 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -237,20 +237,7 @@ static void __init arm_bootmem_free(struct meminfo *mi, unsigned long min,
 #ifndef CONFIG_SPARSEMEM
 int pfn_valid(unsigned long pfn)
 {
-	struct memblock_type *mem = &memblock.memory;
-	unsigned int left = 0, right = mem->cnt;
-
-	do {
-		unsigned int mid = (right + left) / 2;
-
-		if (pfn < memblock_start_pfn(mem, mid))
-			right = mid;
-		else if (pfn >= memblock_end_pfn(mem, mid))
-			left = mid + 1;
-		else
-			return 1;
-	} while (left < right);
-	return 0;
+	return memblock_is_memory(pfn << PAGE_SHIFT);
 }
 EXPORT_SYMBOL(pfn_valid);
 
-- 
1.7.0.4

