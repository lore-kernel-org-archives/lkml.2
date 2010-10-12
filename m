Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab0JLNBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:01:15 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:56040 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374Ab0JLNBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:01:13 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/7] ste_dma40: add variable to indicate valid dma_cfg
Date: Tue, 12 Oct 2010 15:00:49 +0200
Message-ID: <1286888455-11385-2-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
References: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Since we want to reduce the amount of required channel
configuration and remove channel_type, don't depend on it
to indicate whether the configuration is valid.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3f76cd9..535bff8 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -175,6 +175,7 @@ struct d40_base;
  * @active: Active descriptor.
  * @queue: Queued jobs.
  * @dma_cfg: The client configuration of this dma channel.
+ * @configured: whether the dma_cfg configuration is valid
  * @base: Pointer to the device instance struct.
  * @src_def_cfg: Default cfg register setting for src.
  * @dst_def_cfg: Default cfg register setting for dst.
@@ -198,6 +199,7 @@ struct d40_chan {
 	struct list_head		 active;
 	struct list_head		 queue;
 	struct stedma40_chan_cfg	 dma_cfg;
+	bool				 configured;
 	struct d40_base			*base;
 	/* Default register configurations */
 	u32				 src_def_cfg;
@@ -1518,8 +1520,7 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return res;
 	}
 	d40c->phy_chan = NULL;
-	/* Invalidate channel type */
-	d40c->dma_cfg.channel_type = 0;
+	d40c->configured = false;
 	d40c->base->lookup_phy_chans[phy->num] = NULL;
 
 	return 0;
@@ -1704,6 +1705,9 @@ bool stedma40_filter(struct dma_chan *chan, void *data)
 	} else
 		err = d40_config_memcpy(d40c);
 
+	if (!err)
+		d40c->configured = true;
+
 	return err == 0;
 }
 EXPORT_SYMBOL(stedma40_filter);
@@ -1720,12 +1724,8 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 
 	d40c->completed = chan->cookie = 1;
 
-	/*
-	 * If no dma configuration is set (channel_type == 0)
-	 * use default configuration (memcpy)
-	 */
-	if (d40c->dma_cfg.channel_type == 0) {
-
+	/* If no dma configuration is set use default configuration (memcpy) */
+	if (!d40c->configured) {
 		err = d40_config_memcpy(d40c);
 		if (err) {
 			dev_err(&d40c->chan.dev->device,
-- 
1.6.3.3

