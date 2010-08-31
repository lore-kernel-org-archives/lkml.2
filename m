Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab0HaMNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:13:08 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:44645 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756898Ab0HaMNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:13:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 10/12] DMAENGINE: move the PL08X to full runtime allocation
Date: Tue, 31 Aug 2010 14:12:12 +0200
Message-ID: <1283256734-3408-11-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283256734-3408-10-git-send-email-linus.walleij@stericsson.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-4-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-5-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-6-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-7-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-8-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-9-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-10-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes the PL08X not being a singleton anymore, this
piece was missing earlier: we move the struct dma_device entries
into the driver state holder. Also flag channels as slaves and
fix up the channel freeing code.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/amba-pl08x.c   |  112 +++++++++++++++++++++++++-------------------
 include/linux/amba/pl08x.h |    2 +
 2 files changed, 66 insertions(+), 48 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index f80fc4b..4573189 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -110,6 +110,8 @@ struct lli {
 
 /**
  * struct pl08x_driver_data - the local state holder for the PL08x
+ * @slave: slave engine for this instance
+ * @memcpy: memcpy engine for this instance
  * @base: virtual memory base (remapped) for the PL08x
  * @adev: the corresponding AMBA (PrimeCell) bus entry
  * @vd: vendor data for this PL08x variant
@@ -120,6 +122,8 @@ struct lli {
  * @lock: a spinlock for this struct
  */
 struct pl08x_driver_data {
+	struct dma_device slave;
+	struct dma_device memcpy;
 	void __iomem *base;
 	struct amba_device *adev;
 	struct vendor_data *vd;
@@ -1691,38 +1695,6 @@ bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
 	return false;
 }
 
-static struct dma_device dmac_memcpy = {
-	.device_alloc_chan_resources	= pl08x_alloc_chan_resources,
-	.device_free_chan_resources	= pl08x_free_chan_resources,
-	.device_prep_dma_memcpy		= pl08x_prep_dma_memcpy,
-	.device_prep_dma_xor		= NULL,
-	.device_prep_dma_memset		= NULL,
-	.device_prep_dma_interrupt	= pl08x_prep_dma_interrupt,
-	.device_tx_status		= pl08x_dma_tx_status,
-	.device_issue_pending		= pl08x_issue_pending,
-	.device_control			= pl08x_control,
-	/*
-	 * Align to 4-byte boundary
-	 * This makes the DMAtests fail with grace on PB1176
-	 * broken DMA hardware instead of locking everything
-	 * up.
-	 */
-	/* .copy_align			= 2, */
-};
-
-static struct dma_device dmac_slave = {
-	.device_alloc_chan_resources	= pl08x_alloc_chan_resources,
-	.device_free_chan_resources	= pl08x_free_chan_resources,
-	.device_prep_dma_xor		= NULL,
-	.device_prep_dma_memset		= NULL,
-	.device_prep_dma_interrupt	= pl08x_prep_dma_interrupt,
-	.device_tx_status		= pl08x_dma_tx_status,
-	.device_issue_pending		= pl08x_issue_pending,
-	.device_prep_slave_sg		= pl08x_prep_slave_sg,
-	.device_control			= pl08x_control,
-};
-
-
 /*
  * Just check that the device is there and active
  * TODO: turn this bit on/off depending on the number of
@@ -1770,6 +1742,7 @@ static int pl08x_dma_init_virtual_channels(struct pl08x_driver_data *pl08x,
 		chan->host = pl08x;
 
 		if (slave) {
+			chan->slave = true;
 			chan->name = pl08x->pd->slave_channels[i].bus_id;
 			chan->cd = &pl08x->pd->slave_channels[i];
 		} else {
@@ -1800,10 +1773,23 @@ static int pl08x_dma_init_virtual_channels(struct pl08x_driver_data *pl08x,
 	return i;
 }
 
+static void pl08x_free_virtual_channels(struct dma_device *dmadev)
+{
+	struct pl08x_dma_chan *chan = NULL;
+	struct pl08x_dma_chan *next;
+
+	list_for_each_entry_safe(chan,
+				 next, &dmadev->channels, chan.device_node) {
+		list_del(&chan->chan.device_node);
+		kfree(chan);
+	}
+}
+
 #ifdef CONFIG_DEBUG_FS
 static int pl08x_debugfs_show(struct seq_file *s, void *data)
 {
 	struct pl08x_driver_data *pl08x = s->private;
+	struct pl08x_dma_chan *chan;
 	struct pl08x_phy_chan *ch;
 	unsigned long flags;
 	int i;
@@ -1824,6 +1810,21 @@ static int pl08x_debugfs_show(struct seq_file *s, void *data)
 
 		spin_unlock_irqrestore(&ch->lock, flags);
 	}
+
+	seq_printf(s, "\nPL08x virtual memcpy channels:\n");
+	seq_printf(s, "CHANNEL:\n");
+	seq_printf(s, "--------\n");
+	list_for_each_entry(chan, &pl08x->memcpy.channels, chan.device_node) {
+		seq_printf(s, "%s\n", chan->name);
+	}
+
+	seq_printf(s, "\nPL08x virtual slave channels:\n");
+	seq_printf(s, "CHANNEL:\n");
+	seq_printf(s, "--------\n");
+	list_for_each_entry(chan, &pl08x->slave.channels, chan.device_node) {
+		seq_printf(s, "%s\n", chan->name);
+	}
+
 	return 0;
 }
 
@@ -1845,7 +1846,6 @@ static void init_pl08x_debugfs(struct pl08x_driver_data *pl08x)
 	(void) debugfs_create_file(dev_name(&pl08x->adev->dev), S_IFREG | S_IRUGO,
 				   NULL, pl08x,
 				   &pl08x_debugfs_operations);
-	return 0;
 }
 
 #else
@@ -1872,6 +1872,28 @@ static int pl08x_probe(struct amba_device *adev, struct amba_id *id)
 		goto out_no_pl08x;
 	}
 
+	/* Initialize memcpy engine */
+	dma_cap_set(DMA_MEMCPY, pl08x->memcpy.cap_mask);
+	pl08x->memcpy.dev = &adev->dev;
+	pl08x->memcpy.device_alloc_chan_resources = pl08x_alloc_chan_resources;
+	pl08x->memcpy.device_free_chan_resources = pl08x_free_chan_resources;
+	pl08x->memcpy.device_prep_dma_memcpy = pl08x_prep_dma_memcpy;
+	pl08x->memcpy.device_prep_dma_interrupt = pl08x_prep_dma_interrupt;
+	pl08x->memcpy.device_tx_status = pl08x_dma_tx_status;
+	pl08x->memcpy.device_issue_pending = pl08x_issue_pending;
+	pl08x->memcpy.device_control = pl08x_control;
+
+	/* Initialize slave engine */
+	dma_cap_set(DMA_SLAVE, pl08x->slave.cap_mask);
+	pl08x->slave.dev = &adev->dev;
+	pl08x->slave.device_alloc_chan_resources = pl08x_alloc_chan_resources;
+	pl08x->slave.device_free_chan_resources = pl08x_free_chan_resources;
+	pl08x->slave.device_prep_dma_interrupt = pl08x_prep_dma_interrupt;
+	pl08x->slave.device_tx_status = pl08x_dma_tx_status;
+	pl08x->slave.device_issue_pending = pl08x_issue_pending;
+	pl08x->slave.device_prep_slave_sg = pl08x_prep_slave_sg;
+	pl08x->slave.device_control = pl08x_control;
+
 	/* Get the platform data */
 	pl08x->pd = dev_get_platdata(&adev->dev);
 	if (!pl08x->pd) {
@@ -1939,14 +1961,8 @@ static int pl08x_probe(struct amba_device *adev, struct amba_id *id)
 			 pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
 	}
 
-	/* Set caps */
-	dma_cap_set(DMA_MEMCPY, dmac_memcpy.cap_mask);
-	dma_cap_set(DMA_SLAVE, dmac_slave.cap_mask);
-	dmac_memcpy.dev = &adev->dev;
-	dmac_slave.dev = &adev->dev;
-
 	/* Register as many memcpy channels as there are physical channels */
-	ret = pl08x_dma_init_virtual_channels(pl08x, &dmac_memcpy,
+	ret = pl08x_dma_init_virtual_channels(pl08x, &pl08x->memcpy,
 					      pl08x->vd->channels, false);
 	if (ret <= 0) {
 		dev_warn(&pl08x->adev->dev,
@@ -1954,10 +1970,10 @@ static int pl08x_probe(struct amba_device *adev, struct amba_id *id)
 			 __func__, ret);
 		goto out_no_memcpy;
 	}
-	dmac_memcpy.chancnt = ret;
+	pl08x->memcpy.chancnt = ret;
 
 	/* Register slave channels */
-	ret = pl08x_dma_init_virtual_channels(pl08x, &dmac_slave,
+	ret = pl08x_dma_init_virtual_channels(pl08x, &pl08x->slave,
 					      pl08x->pd->num_slave_channels,
 					      true);
 	if (ret <= 0) {
@@ -1966,9 +1982,9 @@ static int pl08x_probe(struct amba_device *adev, struct amba_id *id)
 				__func__, ret);
 		goto out_no_slave;
 	}
-	dmac_slave.chancnt = ret;
+	pl08x->slave.chancnt = ret;
 
-	ret = dma_async_device_register(&dmac_memcpy);
+	ret = dma_async_device_register(&pl08x->memcpy);
 	if (ret) {
 		dev_warn(&pl08x->adev->dev,
 			"%s failed to register memcpy as an async device - %d\n",
@@ -1976,7 +1992,7 @@ static int pl08x_probe(struct amba_device *adev, struct amba_id *id)
 		goto out_no_memcpy_reg;
 	}
 
-	ret = dma_async_device_register(&dmac_slave);
+	ret = dma_async_device_register(&pl08x->slave);
 	if (ret) {
 		dev_warn(&pl08x->adev->dev,
 			"%s failed to register slave as an async device - %d\n",
@@ -1991,11 +2007,11 @@ static int pl08x_probe(struct amba_device *adev, struct amba_id *id)
 	return 0;
 
 out_no_slave_reg:
-	dma_async_device_unregister(&dmac_memcpy);
+	dma_async_device_unregister(&pl08x->memcpy);
 out_no_memcpy_reg:
-	/* FIXME: free slave channels */
+	pl08x_free_virtual_channels(&pl08x->slave);
 out_no_slave:
-	/* FIXME: free memcpy channels */
+	pl08x_free_virtual_channels(&pl08x->memcpy);
 out_no_memcpy:
 	kfree(pl08x->phy_chans);
 out_no_phychans:
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index 2bb7ac4..6db44f9 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -138,6 +138,7 @@ struct pl08x_txd {
  * @lock: a lock for this channel data
  * @host: a pointer to the host (internal use)
  * @paused: whether the channel is paused
+ * @slave: whether this channel is a device (slave) or for memcpy
  */
 struct pl08x_dma_chan {
 	struct dma_chan chan;
@@ -154,6 +155,7 @@ struct pl08x_dma_chan {
 	spinlock_t lock;
 	void *host;
 	bool paused;
+	bool slave;
 };
 
 /**
-- 
1.6.3.3

