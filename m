Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1K3Nu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:50:58 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:47903 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717Ab1K3Nu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:50:56 -0500
From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>
Cc: <linus.walleij@stericsson.com>,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH] dmaengine/ste_dma40: allow fixed physical channel
Date: Wed, 30 Nov 2011 19:20:42 +0530
Message-ID: <1322661042-18645-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow logical channels to specify the physical channel they want to use.
This is needed to avoid two peripherals operating on the same physical
channel during some special use-cases. (like mmc and usb during a
usb mass storage case).

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    6 ++-
 drivers/dma/ste_dma40.c                        |   51 +++++++++++++++++++----
 2 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 3177bed..fd0ee84 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -113,7 +113,8 @@ struct stedma40_half_channel_info {
  * @dst_dev_type: Dst device type
  * @src_info: Parameters for dst half channel
  * @dst_info: Parameters for dst half channel
- *
+ * @use_fixed_channel: if true, use physical channel specified by phy_channel
+ * @phy_channel: physical channel to use, only if use_fixed_channel is true
  *
  * This structure has to be filled by the client drivers.
  * It is recommended to do all dma configurations for clients in the machine.
@@ -129,6 +130,9 @@ struct stedma40_chan_cfg {
 	int					 dst_dev_type;
 	struct stedma40_half_channel_info	 src_info;
 	struct stedma40_half_channel_info	 dst_info;
+
+	bool					 use_fixed_channel;
+	int					 phy_channel;
 };
 
 /**
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index aff128a..972dc35 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1545,11 +1545,16 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	return res;
 }
 
-static bool d40_alloc_mask_set(struct d40_phy_res *phy, bool is_src,
-			       int log_event_line, bool is_log)
+static bool d40_alloc_mask_set(struct d40_phy_res *phy,
+			       bool is_src, int log_event_line, bool is_log,
+			       bool *first_user)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&phy->lock, flags);
+
+	*first_user = ((phy->allocated_src | phy->allocated_dst)
+			== D40_ALLOC_FREE);
+
 	if (!is_log) {
 		/* Physical interrupts are masked per physical full channel */
 		if (phy->allocated_src == D40_ALLOC_FREE &&
@@ -1630,7 +1635,7 @@ out:
 	return is_free;
 }
 
-static int d40_allocate_channel(struct d40_chan *d40c)
+static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 {
 	int dev_type;
 	int event_group;
@@ -1666,7 +1671,8 @@ static int d40_allocate_channel(struct d40_chan *d40c)
 			for (i = 0; i < d40c->base->num_phy_chans; i++) {
 
 				if (d40_alloc_mask_set(&phys[i], is_src,
-						       0, is_log))
+						       0, is_log,
+						       first_phy_user))
 					goto found_phy;
 			}
 		} else
@@ -1676,7 +1682,8 @@ static int d40_allocate_channel(struct d40_chan *d40c)
 					if (d40_alloc_mask_set(&phys[i],
 							       is_src,
 							       0,
-							       is_log))
+							       is_log,
+							       first_phy_user))
 						goto found_phy;
 				}
 			}
@@ -1692,6 +1699,25 @@ found_phy:
 	/* Find logical channel */
 	for (j = 0; j < d40c->base->num_phy_chans; j += 8) {
 		int phy_num = j + event_group * 2;
+
+		if (d40c->dma_cfg.use_fixed_channel) {
+			i = d40c->dma_cfg.phy_channel;
+
+			if ((i != phy_num) && (i != phy_num + 1)) {
+				dev_err(chan2dev(d40c),
+					"invalid fixed phy channel %d\n", i);
+				return -EINVAL;
+			}
+
+			if (d40_alloc_mask_set(&phys[i], is_src, event_line,
+					       is_log, first_phy_user))
+				goto found_log;
+
+			dev_err(chan2dev(d40c),
+				"could not allocate fixed phy channel %d\n", i);
+			return -EINVAL;
+		}
+
 		/*
 		 * Spread logical channels across all available physical rather
 		 * than pack every logical channel at the first available phy
@@ -1700,13 +1726,15 @@ found_phy:
 		if (is_src) {
 			for (i = phy_num; i < phy_num + 2; i++) {
 				if (d40_alloc_mask_set(&phys[i], is_src,
-						       event_line, is_log))
+						       event_line, is_log,
+						       first_phy_user))
 					goto found_log;
 			}
 		} else {
 			for (i = phy_num + 1; i >= phy_num; i--) {
 				if (d40_alloc_mask_set(&phys[i], is_src,
-						       event_line, is_log))
+						       event_line, is_log,
+						       first_phy_user))
 					goto found_log;
 			}
 		}
@@ -2160,9 +2188,8 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 			goto fail;
 		}
 	}
-	is_free_phy = (d40c->phy_chan == NULL);
 
-	err = d40_allocate_channel(d40c);
+	err = d40_allocate_channel(d40c, &is_free_phy);
 	if (err) {
 		chan_err(d40c, "Failed to allocate channel\n");
 		d40c->configured = false;
@@ -2189,6 +2216,12 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 			  D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
 	}
 
+	dev_dbg(chan2dev(d40c), "allocated %s channel (phy %d%s)\n",
+		 chan_is_logical(d40c) ? "logical" : "physical",
+		 d40c->phy_chan->num,
+		 d40c->dma_cfg.use_fixed_channel ? ", fixed" : "");
+
+
 	/*
 	 * Only write channel configuration to the DMA if the physical
 	 * resource is free. In case of multiple logical channels
-- 
1.7.4.3

