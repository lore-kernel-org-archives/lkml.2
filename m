Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2KENk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:40:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41574 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2KENkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:40:25 -0500
From: Matthieu CASTET <matthieu.castet@parrot.com>
To: linux-kernel@vger.kernel.org
Cc: cl@linux.com, akpm@linux-foundation.org,
        Matthieu CASTET <matthieu.castet@parrot.com>
Subject: [PATCH] dmapool : make DMAPOOL_DEBUG detect corruption of free marker
Date: Mon,  5 Nov 2012 14:40:05 +0100
Message-Id: <1352122805-30099-1-git-send-email-matthieu.castet@parrot.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can help to catch case where hardware is writting after dma free.

Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
---
 mm/dmapool.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index c5ab33b..e10898a 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -346,6 +346,29 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
 #ifdef	DMAPOOL_DEBUG
+	{
+		int i;
+		u8 *data = retval;
+		/* page->offset is stored in first 4 bytes */
+		for (i = sizeof(int); i < pool->size; i++) {
+			if (data[i] != POOL_POISON_FREED) {
+				if (pool->dev)
+					dev_err(pool->dev,
+							"dma_pool_alloc %s, %p (corruped)\n",
+							pool->name, retval);
+				else
+					printk(KERN_ERR
+							"dma_pool_alloc %s, %p (corruped)\n",
+							pool->name, retval);
+
+				/* we dump the first 4 bytes even if there are not
+				   POOL_POISON_FREED */
+				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
+						data, pool->size, 1);
+				break;
+			}
+		}
+	}
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
  done:
-- 
1.7.10.4

