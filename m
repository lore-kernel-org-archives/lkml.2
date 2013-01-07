Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3AGLZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:25:33 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40173 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab3AGLZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:25:27 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Subject: [PATCH 14/16] dmaengine: ste_dma40: add software lli support
Date: Mon,  7 Jan 2013 12:21:56 +0100
Message-Id: <1357557718-15676-15-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support to manage LLI by SW for select phy channels.

There is a HW issue in certain controllers due to which on certain
occassions HW LLI cannot be used on some physical channels.  To avoid
the HW issue on a specific phy channel, the phy channel number can be
added to the list of soft_lli_channels and there after all the transfers
on that channel will use software LLI, for peripheral to memory
transfers.

SoftLLI introduces relink overhead, that could impact performace for
certain use cases.

This is based on a previous patch of Narayanan Gopalakrishnan.

Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c                     | 20 +++++++++++++++++++-
 include/linux/platform_data/dma-ste-dma40.h |  8 ++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index e317deb..2ecefb7 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -355,6 +355,7 @@ struct d40_lcla_pool {
  * @allocated_dst: Same as for src but is dst.
  * allocated_dst and allocated_src uses the D40_ALLOC* defines as well as
  * event line number.
+ * @use_soft_lli: To mark if the linked lists of channel are managed by SW.
  */
 struct d40_phy_res {
 	spinlock_t lock;
@@ -362,6 +363,7 @@ struct d40_phy_res {
 	int	   num;
 	u32	   allocated_src;
 	u32	   allocated_dst;
+	bool	   use_soft_lli;
 };
 
 struct d40_base;
@@ -783,7 +785,16 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 	 * can't link back to the one in LCPA space
 	 */
 	if (linkback || (lli_len - lli_current > 1)) {
-		curr_lcla = d40_lcla_alloc_one(chan, desc);
+		/*
+		 * If the channel is expected to use only soft_lli don't
+		 * allocate a lcla. This is to avoid a HW issue that exists
+		 * in some controller during a peripheral to memory transfer
+		 * that uses linked lists.
+		 */
+		if (!(chan->phy_chan->use_soft_lli &&
+			chan->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM))
+			curr_lcla = d40_lcla_alloc_one(chan, desc);
+
 		first_lcla = curr_lcla;
 	}
 
@@ -3063,6 +3074,13 @@ static int __init d40_phy_res_init(struct d40_base *base)
 		num_phy_chans_avail--;
 	}
 
+	/* Mark soft_lli channels */
+	for (i = 0; i < base->plat_data->num_of_soft_lli_chans; i++) {
+		int chan = base->plat_data->soft_lli_chans[i];
+
+		base->phy_res[chan].use_soft_lli = true;
+	}
+
 	dev_info(base->dev, "%d of %d physical DMA channels available\n",
 		 num_phy_chans_avail, base->num_phy_chans);
 
diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index b99024b..4b78101 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -147,6 +147,12 @@ struct stedma40_chan_cfg {
  * @memcpy_conf_log: default configuration of logical channel memcpy
  * @disabled_channels: A vector, ending with -1, that marks physical channels
  * that are for different reasons not available for the driver.
+ * @soft_lli_chans: A vector, that marks physical channels will use LLI by SW
+ * which avoids HW bug that exists in some versions of the controller.
+ * SoftLLI introduces relink overhead that could impact performace for
+ * certain use cases.
+ * @num_of_soft_lli_chans: The number of channels that needs to be configured
+ * to use SoftLLI.
  * @use_esram_lcla: flag for mapping the lcla into esram region
  * @num_of_phy_chans: The number of physical channels implemented in HW.
  * 0 means reading the number of channels from DMA HW but this is only valid
@@ -161,6 +167,8 @@ struct stedma40_platform_data {
 	struct stedma40_chan_cfg	*memcpy_conf_phy;
 	struct stedma40_chan_cfg	*memcpy_conf_log;
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
+	int				*soft_lli_chans;
+	int				 num_of_soft_lli_chans;
 	bool				 use_esram_lcla;
 	int				 num_of_phy_chans;
 };
-- 
1.7.12.1

