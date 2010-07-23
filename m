Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0GWR2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:28:53 -0400
Received: from mail.df.lth.se ([194.47.250.12]:56748 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756656Ab0GWR2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:28:51 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Alan Cox <alan@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] DMAENGINE: generic slave channel control v3
Date: Fri, 23 Jul 2010 19:27:52 +0200
Message-Id: <1279906072-377-1-git-send-email-linus.walleij@stericsson.com>
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
Changes v2->v3:
- Drop the .private member since there is no users. We can always
  add it later if need be.
- Fix a few speling mistakes.

Remaining patches adding channel control to ste_dma40 and
coh901318 as well as the PL08x driver remain unaffected since
none of them make use of the private element.
---
 include/linux/dmaengine.h |   71 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5204f01..c61d4ca 100644
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
@@ -199,6 +205,71 @@ struct dma_chan_dev {
 	atomic_t *idr_ref;
 };
 
+/**
+ * enum dma_slave_buswidth - defines bus with of the DMA slave
+ * device, source or target buses
+ */
+enum dma_slave_buswidth {
+	DMA_SLAVE_BUSWIDTH_UNDEFINED = 0,
+	DMA_SLAVE_BUSWIDTH_1_BYTE = 1,
+	DMA_SLAVE_BUSWIDTH_2_BYTES = 2,
+	DMA_SLAVE_BUSWIDTH_4_BYTES = 4,
+	DMA_SLAVE_BUSWIDTH_8_BYTES = 8,
+};
+
+/**
+ * struct dma_slave_config - dma slave channel runtime config
+ * @direction: whether the data shall go in or out on this slave
+ * channel, right now. DMA_TO_DEVICE and DMA_FROM_DEVICE are
+ * legal values, DMA_BIDIRECTIONAL is not acceptable since we
+ * need to differentiate source and target addresses.
+ * @src_addr: this is the physical address where DMA slave data
+ * should be read (RX), if the source is memory this argument is
+ * ignored.
+ * @dst_addr: this is the physical address where DMA slave data
+ * should be written (TX), if the source is memory this argument
+ * is ignored.
+ * @src_addr_width: this is the width in bytes of the source (RX)
+ * register where DMA data shall be read. If the source
+ * is memory this may be ignored depending on architecture.
+ * Legal values: 1, 2, 4, 8.
+ * @dst_addr_width: same as src_addr_width but for destination
+ * target (TX) mutatis mutandis.
+ * @src_maxburst: the maximum number of words (note: words, as in
+ * units of the src_addr_width member, not bytes) that can be sent
+ * in one burst to the device. Typically something like half the
+ * FIFO depth on I/O peripherals so you don't overflow it. This
+ * may or may not be applicable on memory sources.
+ * @dst_maxburst: same as src_maxburst but for destination target
+ * mutatis mutandis.
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
+ * generic. If not: if it is fixed so that it be sent in static from
+ * the platform data, then prefer to do that. Else, if it is neither
+ * fixed at runtime, nor generic enough (such as bus mastership on
+ * some CPU family and whatnot) then create a custom slave config
+ * struct and pass that, then make this config a member of that
+ * struct, if applicable.
+ */
+struct dma_slave_config {
+	enum dma_data_direction direction;
+	dma_addr_t src_addr;
+	dma_addr_t dst_addr;
+	enum dma_slave_buswidth src_addr_width;
+	enum dma_slave_buswidth dst_addr_width;
+	u32 src_maxburst;
+	u32 dst_maxburst;
+};
+
 static inline const char *dma_chan_name(struct dma_chan *chan)
 {
 	return dev_name(&chan->dev->device);
-- 
1.7.1.1

