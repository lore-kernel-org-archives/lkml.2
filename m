Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0I3N4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:56:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60146 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab0I3N4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:56:46 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/4] dmaengine: add wrapper functions for device control functions
Date: Thu, 30 Sep 2010 15:56:33 +0200
Message-Id: <1285854995-6569-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de>
References: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add wrapper functions around the dma_device->device_control function
to bring back type safety. Also, add a wrapper function around
dma_async_tx_descriptor->tx_submit. This is named dmaengine_submit
instead of dmaengine_tx_submit to get rid of the confusing 'tx' in the
function name

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 include/linux/dmaengine.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 32cd84b..2218fdc 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -494,6 +494,40 @@ struct dma_device {
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
+static inline int dmaengine_pause(struct dma_chan *chan)
+{
+	return dmaengine_device_control(chan, DMA_PAUSE, 0);
+}
+
+static inline int dmaengine_resume(struct dma_chan *chan)
+{
+	return dmaengine_device_control(chan, DMA_RESUME, 0);
+}
+
+static inline int dmaengine_submit(struct dma_async_tx_descriptor *desc)
+{
+	return desc->tx_submit(desc);
+}
+
 static inline bool dmaengine_check_align(u8 align, size_t off1, size_t off2, size_t len)
 {
 	size_t mask;
-- 
1.7.2.3

