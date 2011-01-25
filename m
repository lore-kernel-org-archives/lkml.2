Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1AYKUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:20:32 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:53649 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961Ab1AYKU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:20:29 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 30/32] dma40: fix DMA_SG capability and channels
Date: Tue, 25 Jan 2011 11:18:33 +0100
Message-ID: <1295950715-22340-31-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The DMA_SG cap is enabled on the wrong channel, and the pointers are repeatedly
set incorrectly.  Fix it and combine the ops settings to a common function.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   71 ++++++++++++++++++++++------------------------
 1 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b8cce85..929fd8f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2238,6 +2238,32 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 	}
 }
 
+static void d40_ops_init(struct d40_base *base, struct dma_device *dev)
+{
+	if (dma_has_cap(DMA_SLAVE, dev->cap_mask))
+		dev->device_prep_slave_sg = d40_prep_slave_sg;
+
+	if (dma_has_cap(DMA_MEMCPY, dev->cap_mask)) {
+		dev->device_prep_dma_memcpy = d40_prep_memcpy;
+
+		/*
+		 * This controller can only access address at even
+		 * 32bit boundaries, i.e. 2^2
+		 */
+		dev->copy_align = 2;
+	}
+
+	if (dma_has_cap(DMA_SG, dev->cap_mask))
+		dev->device_prep_dma_sg = d40_prep_memcpy_sg;
+
+	dev->device_alloc_chan_resources = d40_alloc_chan_resources;
+	dev->device_free_chan_resources = d40_free_chan_resources;
+	dev->device_issue_pending = d40_issue_pending;
+	dev->device_tx_status = d40_tx_status;
+	dev->device_control = d40_control;
+	dev->dev = base->dev;
+}
+
 static int __init d40_dmaengine_init(struct d40_base *base,
 				     int num_reserved_chans)
 {
@@ -2249,15 +2275,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_zero(base->dma_slave.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_slave.cap_mask);
 
-	base->dma_slave.device_alloc_chan_resources = d40_alloc_chan_resources;
-	base->dma_slave.device_free_chan_resources = d40_free_chan_resources;
-	base->dma_slave.device_prep_dma_memcpy = d40_prep_memcpy;
-	base->dma_slave.device_prep_dma_sg = d40_prep_memcpy_sg;
-	base->dma_slave.device_prep_slave_sg = d40_prep_slave_sg;
-	base->dma_slave.device_tx_status = d40_tx_status;
-	base->dma_slave.device_issue_pending = d40_issue_pending;
-	base->dma_slave.device_control = d40_control;
-	base->dma_slave.dev = base->dev;
+	d40_ops_init(base, &base->dma_slave);
 
 	err = dma_async_device_register(&base->dma_slave);
 
@@ -2271,22 +2289,9 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 
 	dma_cap_zero(base->dma_memcpy.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_memcpy.cap_mask);
-	dma_cap_set(DMA_SG, base->dma_slave.cap_mask);
-
-	base->dma_memcpy.device_alloc_chan_resources = d40_alloc_chan_resources;
-	base->dma_memcpy.device_free_chan_resources = d40_free_chan_resources;
-	base->dma_memcpy.device_prep_dma_memcpy = d40_prep_memcpy;
-	base->dma_slave.device_prep_dma_sg = d40_prep_memcpy_sg;
-	base->dma_memcpy.device_prep_slave_sg = d40_prep_slave_sg;
-	base->dma_memcpy.device_tx_status = d40_tx_status;
-	base->dma_memcpy.device_issue_pending = d40_issue_pending;
-	base->dma_memcpy.device_control = d40_control;
-	base->dma_memcpy.dev = base->dev;
-	/*
-	 * This controller can only access address at even
-	 * 32bit boundaries, i.e. 2^2
-	 */
-	base->dma_memcpy.copy_align = 2;
+	dma_cap_set(DMA_SG, base->dma_memcpy.cap_mask);
+
+	d40_ops_init(base, &base->dma_memcpy);
 
 	err = dma_async_device_register(&base->dma_memcpy);
 
@@ -2302,18 +2307,10 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_zero(base->dma_both.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
-	dma_cap_set(DMA_SG, base->dma_slave.cap_mask);
-
-	base->dma_both.device_alloc_chan_resources = d40_alloc_chan_resources;
-	base->dma_both.device_free_chan_resources = d40_free_chan_resources;
-	base->dma_both.device_prep_dma_memcpy = d40_prep_memcpy;
-	base->dma_slave.device_prep_dma_sg = d40_prep_memcpy_sg;
-	base->dma_both.device_prep_slave_sg = d40_prep_slave_sg;
-	base->dma_both.device_tx_status = d40_tx_status;
-	base->dma_both.device_issue_pending = d40_issue_pending;
-	base->dma_both.device_control = d40_control;
-	base->dma_both.dev = base->dev;
-	base->dma_both.copy_align = 2;
+	dma_cap_set(DMA_SG, base->dma_both.cap_mask);
+
+	d40_ops_init(base, &base->dma_both);
+
 	err = dma_async_device_register(&base->dma_both);
 
 	if (err) {
-- 
1.7.3.2

