Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1H2Le0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:34:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34062 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1H2LeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:34:15 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 3/4] dmaengine/ste_dma40: fix Oops due to double free of client descriptor
Date: Mon, 29 Aug 2011 13:33:34 +0200
Message-Id: <1314617615-2394-4-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
References: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The client list may exist in two lists at the same time. This makes free
fail since the same desc is freed multiple times. Remove desc from
client list when adding it to the pending queue. Move free of client owned
descriptors from free_dma() to terminate_all().

Unable to handle kernel paging request at virtual address 00100104
pgd = dea8c000
[00100104] *pgd=1ea62831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT SMP
Modules linked in:
CPU: 0    Not tainted  (3.1.0-rc3+ #58)
PC is at d40_free_chan_resources+0x64/0x330

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/dma/ste_dma40.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 37388d1..92ec0a2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -644,8 +644,11 @@ static struct d40_desc *d40_first_active_get(struct d40_chan *d40c)
 	return d;
 }
 
+/* remove desc from current queue and add it to the pending_queue */
 static void d40_desc_queue(struct d40_chan *d40c, struct d40_desc *desc)
 {
+	d40_desc_remove(desc);
+	desc->is_in_client_list = false;
 	list_add_tail(&desc->node, &d40c->pending_queue);
 }
 
@@ -803,6 +806,7 @@ done:
 static void d40_term_all(struct d40_chan *d40c)
 {
 	struct d40_desc *d40d;
+	struct d40_desc *_d;
 
 	/* Release active descriptors */
 	while ((d40d = d40_first_active_get(d40c))) {
@@ -822,6 +826,14 @@ static void d40_term_all(struct d40_chan *d40c)
 		d40_desc_free(d40c, d40d);
 	}
 
+	/* Release client owned descriptors */
+	if (!list_empty(&d40c->client))
+		list_for_each_entry_safe(d40d, _d, &d40c->client, node) {
+			d40_desc_remove(d40d);
+			d40_desc_free(d40c, d40d);
+		}
+
+
 	d40c->pending_tx = 0;
 	d40c->busy = false;
 }
@@ -1594,20 +1606,10 @@ static int d40_free_dma(struct d40_chan *d40c)
 	u32 event;
 	struct d40_phy_res *phy = d40c->phy_chan;
 	bool is_src;
-	struct d40_desc *d;
-	struct d40_desc *_d;
-
 
 	/* Terminate all queued and active transfers */
 	d40_term_all(d40c);
 
-	/* Release client owned descriptors */
-	if (!list_empty(&d40c->client))
-		list_for_each_entry_safe(d, _d, &d40c->client, node) {
-			d40_desc_remove(d);
-			d40_desc_free(d40c, d);
-		}
-
 	if (phy == NULL) {
 		chan_err(d40c, "phy == null\n");
 		return -EINVAL;
-- 
1.7.4.1

