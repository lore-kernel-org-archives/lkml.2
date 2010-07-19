Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029Ab0GTABX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:01:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16445 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967259Ab0GTABD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:01:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 15/49] memblock: Add debug markers at the end of the array
Date: Mon, 19 Jul 2010 16:56:24 -0700
Message-Id: <1279583818-14249-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C44E6A9.0097,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Since we allocate one more than needed, why not do a bit of sanity checking
here to ensure we don't walk past the end of the array ?

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index e1c5ce3..21ba089 100644
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
1.6.4.2

