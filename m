Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0F2APf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:15:35 -0400
Received: from mail.df.lth.se ([194.47.250.12]:63444 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752072Ab0F2APd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:15:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/3] DMAENGINE: generic slave channel control
Date: Tue, 29 Jun 2010 02:16:17 +0200
Message-Id: <1277770577-11024-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an interface to the DMAengine to make it possible to
reconfigure a slave channel at runtime. We add a few foreseen
config parameters to the passed struct, with a void * pointer
for custom per-device or per-platform runtime slave data.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 include/linux/dmaengine.h |   48 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5204f01..e2601bd 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -114,11 +114,17 @@ enum dma_ctrl_flags {
  * @DMA_TERMINATE_ALL: terminate all ongoing transfers
  * @DMA_PAUSE: pause ongoing transfers
  * @DMA_RESUME: resume paused transfer
+ * @DMA_SLAVE_CONFIG: this command is only implemented by DMA controllers
+ * that need to runtime reconfigure the slave channels (as opposed to passing
+ * configuration data in statically from the platform). An additional
+ * argument of struct dma_slave_config must be passed in with this
+ * command.
  */
 enum dma_ctrl_cmd {
 	DMA_TERMINATE_ALL,
 	DMA_PAUSE,
 	DMA_RESUME,
+	DMA_SLAVE_CONFIG,
 };
 
 /**
@@ -199,6 +205,48 @@ struct dma_chan_dev {
 	atomic_t *idr_ref;
 };
 
+/**
+ * struct dma_slave_config - dma slave channel runtime config
+ * @addr: this is the physical address where DMA slave data should be
+ * read (RX) or written (TX)
+ * @addr_width: this is the width of the source (RX) or target
+ * (TX) register where DMA data shall be read/written, in bytes.
+ * legal values: 1, 2, 4, 8.
+ * @direction: whether the data shall go in or out on this slave
+ * channel, right now.
+ * @maxburst: the maximum number of words (note: words, as in units
+ * of the addr_width member, not bytes) that can be sent in one burst
+ * to the device. Typically something like half the FIFO depth on
+ * I/O peripherals so you don't overflow it.
+ * @private_config: if you need to pass in specialized configuration
+ * at runtime, apart from the generic things supported in this
+ * struct, you provide it in this pointer and dereference it inside
+ * your dmaengine driver to get the proper configuration bits out.
+ *
+ * This struct is passed in as configuration data to a DMA engine
+ * in order to set up a certain channel for DMA transport at runtime.
+ * The DMA device/engine has to provide support for an additional
+ * command in the channel config interface, DMA_SLAVE_CONFIG
+ * and this struct will then be passed in as an argument to the
+ * DMA engine device_control() function.
+ *
+ * The rationale for adding configuration information to this struct
+ * is as follows: if it is likely that most DMA slave controllers in
+ * the world will support the configuration option, then make it
+ * generic. If not, if it is fixed so that it be sent in static from
+ * the platform data, then prefer to do that. Else, if it is neither
+ * fixed, not generic enough (such as bus mastership on some CPU
+ * family and whatnot) then pass it in the private_config member
+ * and dereference it to some per-device struct in your driver.
+ */
+struct dma_slave_config {
+	dma_addr_t addr;
+	u8 addr_width:4;
+	enum dma_data_direction direction;
+	int maxburst;
+	void *private_config;
+};
+
 static inline const char *dma_chan_name(struct dma_chan *chan)
 {
 	return dev_name(&chan->dev->device);
-- 
1.7.0.1

