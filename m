Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0FTWTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:19:32 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:36333 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194Ab0FTWTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:19:31 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] DMAENGINE: runtime config for slave channels
Date: Mon, 21 Jun 2010 00:19:16 +0200
Message-ID: <1277072356-18048-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an interface to the DMAengine to make it possible to
reconfigure a channel at runtime. We add a few foreseen config
parameters to the passed struct, with a void * pointer for custom
per-device or per-platform data.

Cc: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
OK at night I realized that maybe what we do for runtime
re-configuration of DMA for the AMBA PrimeCells is actually generic
and should maybe be lifted into the DMAengine instead.

This conclusion came from Viresh stating that the SPEAr platform
will need runtime reconfiguration for other things than PrimeCells,
(on the PL08x driver) and actually we will likely need it ourselves
too.

So before starting to abuse that PrimeCell interface for things
not PrimeCell, this way I suggest making this generic from day 1.

Doing so makes it possible for me to merge the runtime
re-configuration support for DMA40, COH 901 318 and the current
iteration of the PL08x driver as well, and break that out of the
PrimeCell series and drop the include/linux/amba/dma.h entirely
while still getting some real nice and generic functionality
in place.

The PrimeCell patchset can then be nicely wrapped around this.

More genric run-time configurations can be added to the struct if
they are really generic like these, else the private_config can
be used for local obscurities.

Need your help on how to proceed on this one Dan.
---
 include/linux/dmaengine.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5204f01..18f536c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -114,11 +114,17 @@ enum dma_ctrl_flags {
  * @DMA_TERMINATE_ALL: terminate all ongoing transfers
  * @DMA_PAUSE: pause ongoing transfers
  * @DMA_RESUME: resume paused transfer
+ * @DMA_SLAVE_CONFIG: this command is only implemented by DMA controllers
+ * that need to runtime reconfigure the slave channels (as opposed to passing
+ * configuration data in statically from the platform). An additional
+ * argument of struct dma_channel_config must be passed in with this
+ * command.
  */
 enum dma_ctrl_cmd {
 	DMA_TERMINATE_ALL,
 	DMA_PAUSE,
 	DMA_RESUME,
+	DMA_SLAVE_CONFIG,
 };
 
 /**
@@ -199,6 +205,39 @@ struct dma_chan_dev {
 	atomic_t *idr_ref;
 };
 
+/**
+ * struct dma_slave_channel_config - dma slave channel runtime config
+ * @addr: this is the physical address where DMA data should be
+ * read (RX) or written (TX)
+ * @addr_width: this is the width of the source (RX) or target
+ * (TX) register where DMA data shall be read/written, in bytes.
+ * legal values: 1, 2, 4, 8.
+ * @direction: whether the data goes in or out on this slave channel,
+ * right now.
+ * @maxburst: the maximum number of words (note: words, not bytes)
+ * that can be sent in one burst to the device. Typically something
+ * like half the FIFO depth on I/O peripherals so you don't
+ * overflow it.
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
+ */
+struct dma_slave_channel_config {
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
1.6.3.3

