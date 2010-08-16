Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0HPLIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:08:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58958 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0HPLH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:07:56 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/3] dmaengine: add wrapper functions for dmaengine
Date: Mon, 16 Aug 2010 13:07:49 +0200
Message-Id: <1281956870-12463-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently dmaengine users have to explicitely dereference function
pointers in struct dma_device. For the convenience of drivers and
to be more flexible when changing the dmaengine later add static
inline wrapper functions for the dma commands.

This patch is not complete yet. If there's consensus on this patch
I'll provide an updated patch with the missing functions.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 include/linux/dmaengine.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0df7864..635c60b 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -491,6 +491,47 @@ struct dma_device {
 	void (*device_issue_pending)(struct dma_chan *chan);
 };
 
+static inline int dmaengine_device_control(struct dma_chan *chan,
+					   enum dma_ctrl_cmd cmd,
+					   unsigned long arg)
+{
+	return chan->device->device_control(chan, cmd, arg);
+}
+
+static inline int dmaengine_slave_config(struct dma_chan *chan,
+					  struct dma_slave_config *config)
+{
+	return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
+			(unsigned long)config);
+}
+
+static inline int dmaengine_terminate_all(struct dma_chan *chan)
+{
+	return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
+}
+
+static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
+		struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned long flags)
+{
+	return chan->device->device_prep_slave_sg(chan, sgl, sg_len, direction,
+			flags);
+}
+
+static inline struct dma_async_tx_descriptor *dmaengine_prep_cyclic(
+		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+		size_t period_len, enum dma_data_direction direction)
+{
+	return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
+			period_len, direction);
+}
+
+static inline int dmaengine_tx_submit(struct dma_async_tx_descriptor *desc)
+{
+	return desc->tx_submit(desc);
+}
+
 static inline bool dmaengine_check_align(u8 align, size_t off1, size_t off2, size_t len)
 {
 	size_t mask;
-- 
1.7.1

