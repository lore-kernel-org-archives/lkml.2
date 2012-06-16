Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab2FPDMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 23:12:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49896 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2FPDMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 23:12:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] memblock: Make sure reserved.regions is freed really
Date: Fri, 15 Jun 2012 20:12:11 -0700
Message-Id: <1339816331-23284-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_free() would double reserved.regions too, so we could free
old range for reserved.regions.

So need to check that regions get doubled. If it is doubled, we need to
free it.

Cc: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/memblock.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -148,11 +148,26 @@ phys_addr_t __init_memblock memblock_fin
  */
 int __init_memblock memblock_free_reserved_regions(void)
 {
+	struct memblock_region *r;
+	int ret;
+
 	if (memblock.reserved.regions == memblock_reserved_init_regions)
 		return 0;
 
-	return memblock_free(__pa(memblock.reserved.regions),
-		 sizeof(struct memblock_region) * memblock.reserved.max);
+	/*
+	 * During memblock_free, reserved.regions could be doubled,
+	 * try to check with old one for checking, and need to free the new one.
+	 */
+	do {
+		r = memblock.reserved.regions;
+		ret = memblock_free(__pa(memblock.reserved.regions),
+			sizeof(struct memblock_region) * memblock.reserved.max);
+
+		if (ret)
+			break;
+	} while (memblock.reserved.regions != r);
+
+	return ret;
 }
 
 /*
@@ -163,6 +178,10 @@ int __init_memblock memblock_reserve_res
 	if (memblock.reserved.regions == memblock_reserved_init_regions)
 		return 0;
 
+	/*
+	 * Don't need to worry about if reserved.regions get updated later,
+	 * and it is big enough after memblock_free_reserved_regions().
+	 */
 	return memblock_reserve(__pa(memblock.reserved.regions),
 		 sizeof(struct memblock_region) * memblock.reserved.max);
 }
