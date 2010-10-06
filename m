Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab0JFIVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:21:12 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:35677 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758695Ab0JFIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:21:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/4] DMAENGINE: ste_dma40: fix desc_get
Date: Wed, 6 Oct 2010 10:20:37 +0200
Message-ID: <1286353238-13742-4-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286353238-13742-3-git-send-email-linus.walleij@stericsson.com>
References: <1286353238-13742-1-git-send-email-linus.walleij@stericsson.com>
 <1286353238-13742-2-git-send-email-linus.walleij@stericsson.com>
 <1286353238-13742-3-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Fix desc_get to alloc a descriptor from the cache if the ones in the
list are waiting for the ack.  Also, memzero the descriptor when
allocated from the list to ensure all fields are cleared.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 8596c31..554e294 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -419,24 +419,29 @@ static void d40_desc_remove(struct d40_desc *d40d)
 
 static struct d40_desc *d40_desc_get(struct d40_chan *d40c)
 {
-	struct d40_desc *d;
-	struct d40_desc *_d;
+	struct d40_desc *desc = NULL;
 
 	if (!list_empty(&d40c->client)) {
+		struct d40_desc *d;
+		struct d40_desc *_d;
+
 		list_for_each_entry_safe(d, _d, &d40c->client, node)
 			if (async_tx_test_ack(&d->txd)) {
 				d40_pool_lli_free(d);
 				d40_desc_remove(d);
+				desc = d;
+				memset(desc, 0, sizeof(*desc));
 				break;
 			}
-	} else {
-		d = kmem_cache_alloc(d40c->base->desc_slab, GFP_NOWAIT);
-		if (d != NULL) {
-			memset(d, 0, sizeof(struct d40_desc));
-			INIT_LIST_HEAD(&d->node);
-		}
 	}
-	return d;
+
+	if (!desc)
+		desc = kmem_cache_zalloc(d40c->base->desc_slab, GFP_NOWAIT);
+
+	if (desc)
+		INIT_LIST_HEAD(&desc->node);
+
+	return desc;
 }
 
 static void d40_desc_free(struct d40_chan *d40c, struct d40_desc *d40d)
-- 
1.6.3.3

