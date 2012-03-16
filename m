Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208Ab2CPKcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:32:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50354 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760368Ab2CPKcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:32:16 -0400
Date: Fri, 16 Mar 2012 10:31:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120316103158.GJ15988@n2100.arm.linux.org.uk>
References: <1331206459.4657.59.camel@vkoul-udesk3> <1331211513.4657.67.camel@vkoul-udesk3> <Pine.LNX.4.64.1203081412550.29847@axis700.grange> <1331284918.4657.69.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091022200.7852@axis700.grange> <1331285959.4657.76.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091049060.7852@axis700.grange> <1331520476.4657.79.camel@vkoul-udesk3> <Pine.LNX.4.64.1203161029490.13465@axis700.grange> <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 11:16:14AM +0100, Linus Walleij wrote:
> And Russell IIRC already suggested a request-and-config
> channel inline for the simple cases, and if you still need to
> explicitly runtime-reconfigure then that's for a good
> reason.

Here's a patch which does request-and-configure - untested at the moment
apart from build-testing for my Assabet platform.  Haven't converted any
drivers to use it yet either.

 drivers/dma/dmaengine.c   |   14 ++++++++++++--
 include/linux/dmaengine.h |   13 +++++++++----
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index a6c6051..9c920a6 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -485,7 +485,8 @@ static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_devic
  * @fn: optional callback to disposition available channels
  * @fn_param: opaque parameter to pass to dma_filter_fn
  */
-struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param)
+struct dma_chan *__dma_request_config_channel(dma_cap_mask_t *mask,
+	dma_filter_fn fn, void *fn_param, struct dma_slave_config *cfg)
 {
 	struct dma_device *device, *_d;
 	struct dma_chan *chan = NULL;
@@ -521,12 +522,21 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 	}
 	mutex_unlock(&dma_list_mutex);
 
+	if (chan && cfg) {
+		int ret = device->device_control(chan, DMA_SLAVE_CONFIG,
+				(unsigned long)cfg);
+		if (ret) {
+			dma_release_channel(chan);
+			chan = NULL;
+		}
+	}
+
 	pr_debug("%s: %s (%s)\n", __func__, chan ? "success" : "fail",
 		 chan ? dma_chan_name(chan) : NULL);
 
 	return chan;
 }
-EXPORT_SYMBOL_GPL(__dma_request_channel);
+EXPORT_SYMBOL_GPL(__dma_request_config_channel);
 
 void dma_release_channel(struct dma_chan *chan)
 {
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 4b17ca8..9a4e9e9 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -924,7 +924,8 @@ enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
-struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
+struct dma_chan *__dma_request_config_channel(dma_cap_mask_t *mask,
+	dma_filter_fn fn, void *fn_param, struct dma_slave_config *cfg);
 void dma_release_channel(struct dma_chan *chan);
 #else
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
@@ -934,8 +935,9 @@ static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descript
 static inline void dma_issue_pending_all(void)
 {
 }
-static inline struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask,
-					      dma_filter_fn fn, void *fn_param)
+static inline struct dma_chan *__dma_request_config_channel(
+	dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param,
+	struct dma_slave_config *cfg)
 {
 	return NULL;
 }
@@ -950,7 +952,10 @@ int dma_async_device_register(struct dma_device *device);
 void dma_async_device_unregister(struct dma_device *device);
 void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
 struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
-#define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
+#define dma_request_channel(mask, x, y)			\
+	__dma_request_config_channel(&(mask), x, y, NULL)
+#define dma_request_config_channel(mask, x, y, cfg)	\
+	__dma_request_config_channel(&(mask), x, y, cfg)
 
 /* --- Helper iov-locking functions --- */
 

