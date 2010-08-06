Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872Ab0HFFP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:15:58 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59793 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815Ab0HFFPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:38 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 40/43] memblock: Make MEMBLOCK_ERROR be 0
Date: Fri,  6 Aug 2010 15:15:21 +1000
Message-Id: <1281071724-28740-41-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And ensure we don't hand out 0 as a valid allocation. We put the
low limit at PAGE_SIZE arbitrarily.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    2 +-
 mm/memblock.c            |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 1a9c29c..dfa6449 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -19,7 +19,7 @@
 #include <asm/memblock.h>
 
 #define INIT_MEMBLOCK_REGIONS	128
-#define MEMBLOCK_ERROR		(~(phys_addr_t)0)
+#define MEMBLOCK_ERROR		0
 
 struct memblock_region {
 	phys_addr_t base;
diff --git a/mm/memblock.c b/mm/memblock.c
index 85cfa1d..cb520df 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -105,6 +105,12 @@ static phys_addr_t __init memblock_find_region(phys_addr_t start, phys_addr_t en
 	phys_addr_t base, res_base;
 	long j;
 
+	/* Prevent allocations returning 0 as it's also used to
+	 * indicate an allocation failure
+	 */
+	if (start == 0)
+		start = PAGE_SIZE;
+
 	base = memblock_align_down((end - size), align);
 	while (start <= base) {
 		j = memblock_overlaps_region(&memblock.reserved, base, size);
-- 
1.7.0.4

