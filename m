Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655Ab0HFFVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:21:40 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33769 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770Ab0HFFPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:35 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 24/43] memblock: Add debug markers at the end of the array
Date: Fri,  6 Aug 2010 15:15:05 +1000
Message-Id: <1281071724-28740-25-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we allocate one more than needed, why not do a bit of sanity checking
here to ensure we don't walk past the end of the array ?

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 3c47450..a925866 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/poison.h>
 #include <linux/memblock.h>
 
 struct memblock memblock;
@@ -112,6 +113,10 @@ void __init memblock_init(void)
 	memblock.reserved.regions	= memblock_reserved_init_regions;
 	memblock.reserved.max	= INIT_MEMBLOCK_REGIONS;
 
+	/* Write a marker in the unused last array entry */
+	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
+	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
+
 	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
 	 * This simplifies the memblock_add() code below...
 	 */
@@ -131,6 +136,12 @@ void __init memblock_analyze(void)
 {
 	int i;
 
+	/* Check marker in the unused last array entry */
+	WARN_ON(memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS].base
+		!= (phys_addr_t)RED_INACTIVE);
+	WARN_ON(memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS].base
+		!= (phys_addr_t)RED_INACTIVE);
+
 	memblock.memory_size = 0;
 
 	for (i = 0; i < memblock.memory.cnt; i++)
-- 
1.7.0.4

