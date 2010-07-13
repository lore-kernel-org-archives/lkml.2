Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0GMHUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:20:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28749 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab0GMHQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:16:26 -0400
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
Subject: [PATCH 16/50] memblock: Add debug markers at the end of the array
Date: Tue, 13 Jul 2010 00:10:10 -0700
Message-Id: <1279005044-24777-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
References: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C3C129D.0066,ss=1,fgs=0
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

