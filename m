Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0FAMUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:20:53 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:58058 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756167Ab0FAMUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:20:50 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Per Friden <per.friden@stericsson.com>,
       Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 03/18] DMAENGINE: ste_dma40: moved freeing of client owned desc
Date: Tue, 1 Jun 2010 14:20:44 +0200
Message-ID: <1275394844-26212-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Friden <per.friden@stericsson.com>

fixed typo and moved freeing of client owned desc to free_dma.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 1cd1ff7..2b5e876 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -374,7 +374,6 @@ static void d40_desc_remove(struct d40_desc *d40d)
 
 static struct d40_desc *d40_desc_get(struct d40_chan *d40c)
 {
-	struct d40_desc *desc;
 	struct d40_desc *d;
 	struct d40_desc *_d;
 
@@ -583,8 +582,6 @@ done:
 static void d40_term_all(struct d40_chan *d40c)
 {
 	struct d40_desc *d40d;
-	struct d40_desc *d;
-	struct d40_desc *_d;
 
 	/* Release active descriptors */
 	while ((d40d = d40_first_active_get(d40c))) {
@@ -602,15 +599,6 @@ static void d40_term_all(struct d40_chan *d40c)
 		d40_desc_free(d40c, d40d);
 	}
 
-	/* Release client owned descriptors */
-	if (!list_empty(&d40c->client))
-		list_for_each_entry_safe(d, _d, &d40c->client, node) {
-			d40_pool_lli_free(d);
-			d40_desc_remove(d);
-			/* Return desc to free-list */
-			d40_desc_free(d40c, d40d);
-		}
-
 	d40_lcla_id_put(d40c, &d40c->base->lcla_pool,
 			d40c->lcla.src_id);
 	d40_lcla_id_put(d40c, &d40c->base->lcla_pool,
@@ -1270,10 +1258,22 @@ static int d40_free_dma(struct d40_chan *d40c)
 	u32 event, dir;
 	struct d40_phy_res *phy = d40c->phy_chan;
 	bool is_src;
+	struct d40_desc *d;
+	struct d40_desc *_d;
+
 
 	/* Terminate all queued and active transfers */
 	d40_term_all(d40c);
 
+	/* Release client owned descriptors */
+	if (!list_empty(&d40c->client))
+		list_for_each_entry_safe(d, _d, &d40c->client, node) {
+			d40_pool_lli_free(d);
+			d40_desc_remove(d);
+			/* Return desc to free-list */
+			d40_desc_free(d40c, d);
+		}
+
 	if (phy == NULL) {
 		dev_err(&d40c->chan.dev->device, "[%s] phy == null\n",
 			__func__);
-- 
1.6.3.3

