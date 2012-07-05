Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab2GEKbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:31:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2GEK3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:29:49 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API compatibility
Date: Thu,  5 Jul 2012 12:29:41 +0200
Message-Id: <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:Py6cFi+GVlHAICc5hO4ZEuQgUvT/XPu2YjCU7oVleet
 RUqR+RNxndynzIPP3jcgUtzsEbtCRCwtsk8BX4FOwXDmz21mlT
 Iz2sl00+wkphoef1RoiTCNp1Ckmk8EBIJVPLGH+aUzp2lKD3gE
 CWb37GvpsXoEHofs9g2j/ng29/Qe/imdNDUxYi6MPGEevQ4eJ1
 NX3EpUrTXlAiNdYyruOt0BCHQKErIf/3tGC50jt1iP95QjcRit
 y+XUgtl/PDzVa64LN+uFy47Qqpqv2MLlGIBGTzHgGmljo80E1t
 quKkhoEo34Pt7Bm7FCKid218pYcjqUIRGaq1YCQh5u3iUxy9q+
 Rvsh3YtXa+H32ybumM9Sp31Hlg2OIjgmUa8SjMaE9UlXg8W/E/
 b8fBMTGjxjvGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initially struct shdma_slave has been introduced with the only member - an
unsigned slave ID - to describe common properties of DMA slaves in an
extensible way. However, experience shows, that a slave ID is indeed the
only parameter, needed to identify DMA slaves. This is also, what is used
by the core dmaengine API in struct dma_slave_config. We switch to using
the slave_id directly, instead of passing a pointer to struct shdma_slave
to improve compatibility with the core. We also make the slave_id signed
for easier error checking.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/sh/shdma-base.c |   25 +++++++++++++------------
 drivers/dma/sh/shdma.c      |   12 ++++++------
 include/linux/sh_dma.h      |    8 ++++----
 include/linux/shdma-base.h  |    8 ++++----
 4 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index f75ebfa..73db282 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -76,7 +76,6 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 		container_of(tx, struct shdma_desc, async_tx),
 		*last = desc;
 	struct shdma_chan *schan = to_shdma_chan(tx->chan);
-	struct shdma_slave *slave = schan->slave;
 	dma_async_tx_callback callback = tx->callback;
 	dma_cookie_t cookie;
 	bool power_up;
@@ -138,7 +137,7 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 			 * Make it int then, on error remove chunks from the
 			 * queue again
 			 */
-			ops->setup_xfer(schan, slave);
+			ops->setup_xfer(schan, schan->slave_id);
 
 			if (schan->pm_state == SHDMA_PM_PENDING)
 				shdma_chan_xfer_ld_queue(schan);
@@ -186,7 +185,7 @@ static int shdma_alloc_chan_resources(struct dma_chan *chan)
 	 * never runs concurrently with itself or free_chan_resources.
 	 */
 	if (slave) {
-		if (slave->slave_id >= slave_num) {
+		if (slave->slave_id < 0 || slave->slave_id >= slave_num) {
 			ret = -EINVAL;
 			goto evalid;
 		}
@@ -196,9 +195,13 @@ static int shdma_alloc_chan_resources(struct dma_chan *chan)
 			goto etestused;
 		}
 
-		ret = ops->set_slave(schan, slave);
+		ret = ops->set_slave(schan, slave->slave_id);
 		if (ret < 0)
 			goto esetslave;
+
+		schan->slave_id = slave->slave_id;
+	} else {
+		schan->slave_id = -EINVAL;
 	}
 
 	schan->desc = kcalloc(NR_DESCS_PER_CHANNEL,
@@ -208,7 +211,6 @@ static int shdma_alloc_chan_resources(struct dma_chan *chan)
 		goto edescalloc;
 	}
 	schan->desc_num = NR_DESCS_PER_CHANNEL;
-	schan->slave = slave;
 
 	for (i = 0; i < NR_DESCS_PER_CHANNEL; i++) {
 		desc = ops->embedded_desc(schan->desc, i);
@@ -366,10 +368,9 @@ static void shdma_free_chan_resources(struct dma_chan *chan)
 	if (!list_empty(&schan->ld_queue))
 		shdma_chan_ld_cleanup(schan, true);
 
-	if (schan->slave) {
+	if (schan->slave_id >= 0) {
 		/* The caller is holding dma_list_mutex */
-		struct shdma_slave *slave = schan->slave;
-		clear_bit(slave->slave_id, shdma_slave_used);
+		clear_bit(schan->slave_id, shdma_slave_used);
 		chan->private = NULL;
 	}
 
@@ -559,7 +560,7 @@ static struct dma_async_tx_descriptor *shdma_prep_slave_sg(
 	struct shdma_chan *schan = to_shdma_chan(chan);
 	struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
 	const struct shdma_ops *ops = sdev->ops;
-	struct shdma_slave *slave = schan->slave;
+	int slave_id = schan->slave_id;
 	dma_addr_t slave_addr;
 
 	if (!chan)
@@ -568,9 +569,9 @@ static struct dma_async_tx_descriptor *shdma_prep_slave_sg(
 	BUG_ON(!schan->desc_num);
 
 	/* Someone calling slave DMA on a generic channel? */
-	if (!slave || !sg_len) {
-		dev_warn(schan->dev, "%s: bad parameter: %p, %d, %d\n",
-			 __func__, slave, sg_len, slave ? slave->slave_id : -1);
+	if (slave_id < 0 || !sg_len) {
+		dev_warn(schan->dev, "%s: bad parameter: len=%d, id=%d\n",
+			 __func__, sg_len, slave_id);
 		return NULL;
 	}
 
diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index 9f0a2e5..9a10d8b 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -285,12 +285,12 @@ static bool sh_dmae_channel_busy(struct shdma_chan *schan)
 }
 
 static void sh_dmae_setup_xfer(struct shdma_chan *schan,
-			       struct shdma_slave *sslave)
+			       int slave_id)
 {
 	struct sh_dmae_chan *sh_chan = container_of(schan, struct sh_dmae_chan,
 						    shdma_chan);
 
-	if (sslave) {
+	if (slave_id >= 0) {
 		const struct sh_dmae_slave_config *cfg =
 			sh_chan->config;
 
@@ -302,7 +302,7 @@ static void sh_dmae_setup_xfer(struct shdma_chan *schan,
 }
 
 static const struct sh_dmae_slave_config *dmae_find_slave(
-	struct sh_dmae_chan *sh_chan, unsigned int slave_id)
+	struct sh_dmae_chan *sh_chan, int slave_id)
 {
 	struct sh_dmae_device *shdev = to_sh_dev(sh_chan);
 	struct sh_dmae_pdata *pdata = shdev->pdata;
@@ -320,11 +320,11 @@ static const struct sh_dmae_slave_config *dmae_find_slave(
 }
 
 static int sh_dmae_set_slave(struct shdma_chan *schan,
-			     struct shdma_slave *sslave)
+			     int slave_id)
 {
 	struct sh_dmae_chan *sh_chan = container_of(schan, struct sh_dmae_chan,
 						    shdma_chan);
-	const struct sh_dmae_slave_config *cfg = dmae_find_slave(sh_chan, sslave->slave_id);
+	const struct sh_dmae_slave_config *cfg = dmae_find_slave(sh_chan, slave_id);
 	if (!cfg)
 		return -ENODEV;
 
@@ -579,7 +579,7 @@ static int sh_dmae_resume(struct device *dev)
 		if (!sh_chan->shdma_chan.desc_num)
 			continue;
 
-		if (sh_chan->shdma_chan.slave) {
+		if (sh_chan->shdma_chan.slave_id >= 0) {
 			const struct sh_dmae_slave_config *cfg = sh_chan->config;
 			dmae_set_dmars(sh_chan, cfg->mid_rid);
 			dmae_set_chcr(sh_chan, cfg->chcr);
diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index a79f10a..4e83f3e 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -27,10 +27,10 @@ struct sh_dmae_slave {
  * a certain peripheral
  */
 struct sh_dmae_slave_config {
-	unsigned int			slave_id;
-	dma_addr_t			addr;
-	u32				chcr;
-	char				mid_rid;
+	int		slave_id;
+	dma_addr_t	addr;
+	u32		chcr;
+	char		mid_rid;
 };
 
 struct sh_dmae_channel {
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index c3a19e9..6263ad2 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -43,7 +43,7 @@ struct device;
  */
 
 struct shdma_slave {
-	unsigned int slave_id;
+	int slave_id;
 };
 
 struct shdma_desc {
@@ -66,7 +66,7 @@ struct shdma_chan {
 	size_t max_xfer_len;		/* max transfer length */
 	int id;				/* Raw id of this channel */
 	int irq;			/* Channel IRQ */
-	struct shdma_slave *slave;	/* Client data for slave DMA */
+	int slave_id;			/* Client ID for slave DMA */
 	enum shdma_pm_state pm_state;
 };
 
@@ -93,8 +93,8 @@ struct shdma_ops {
 	dma_addr_t (*slave_addr)(struct shdma_chan *);
 	int (*desc_setup)(struct shdma_chan *, struct shdma_desc *,
 			  dma_addr_t, dma_addr_t, size_t *);
-	int (*set_slave)(struct shdma_chan *, struct shdma_slave *);
-	void (*setup_xfer)(struct shdma_chan *, struct shdma_slave *);
+	int (*set_slave)(struct shdma_chan *, int);
+	void (*setup_xfer)(struct shdma_chan *, int);
 	void (*start_xfer)(struct shdma_chan *, struct shdma_desc *);
 	struct shdma_desc *(*embedded_desc)(void *, int);
 	bool (*chan_irq)(struct shdma_chan *, int);
-- 
1.7.2.5

