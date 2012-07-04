Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2GDQRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:17:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2GDQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:17:46 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dmaengine: shdma: prepare to stop using struct dma_chan::private
Date: Wed,  4 Jul 2012 18:17:40 +0200
Message-Id: <1341418663-24432-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341418663-24432-1-git-send-email-g.liakhovetski@gmx.de>
References: <1341418663-24432-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:O99wo4MS4eBjl9KkxObjFwi4XxaaMC0E/vpRMQR0uGa
 fT+/JmQsrlu9nRrUmOEqDFnZaGOEZ2KryfsrMNzyEoLf3KgldG
 3CbHO2pMJPlufo0b3n4niTUBIJCL08CKanV1QBBi4q11DtN99N
 8lYWALxNozlAT0swFK1HU9FpCJ4wE0tvSJvVPJUt2B0WPegg/n
 I7R+/3boVLGuStokpSvIMmmNhD33on2ANWcr/CrTQ1toQoBzy2
 GplOrO0A7PFJzJrbYT/kKPdrcD4BeOgGWflYaOIC4g7KVnmKhI
 4ptcKTbxQfrnAcbJW9uz21Je5uE8Rsu7kZqmmCTrGSeWE8p45M
 72KoL2eVRIYPyt62Y3rF1MIwwYR5AKaEGJcM1FuAK6r43KTLl+
 v0WFTlE5M4DXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using struct dma_chan::private is deprecated. To update the shdma driver to
stop using it we first have to eliminate internal runtime uses of it. After
that we will also be able to stop using it for channel configuration.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/sh/shdma-base.c |    9 +++++----
 drivers/dma/sh/shdma.c      |   24 ++++++++++--------------
 drivers/dma/sh/shdma.h      |    2 ++
 include/linux/sh_dma.h      |    2 --
 include/linux/shdma-base.h  |    1 +
 5 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index ff060d0..f75ebfa 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -76,7 +76,7 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 		container_of(tx, struct shdma_desc, async_tx),
 		*last = desc;
 	struct shdma_chan *schan = to_shdma_chan(tx->chan);
-	struct shdma_slave *slave = tx->chan->private;
+	struct shdma_slave *slave = schan->slave;
 	dma_async_tx_callback callback = tx->callback;
 	dma_cookie_t cookie;
 	bool power_up;
@@ -208,6 +208,7 @@ static int shdma_alloc_chan_resources(struct dma_chan *chan)
 		goto edescalloc;
 	}
 	schan->desc_num = NR_DESCS_PER_CHANNEL;
+	schan->slave = slave;
 
 	for (i = 0; i < NR_DESCS_PER_CHANNEL; i++) {
 		desc = ops->embedded_desc(schan->desc, i);
@@ -365,9 +366,9 @@ static void shdma_free_chan_resources(struct dma_chan *chan)
 	if (!list_empty(&schan->ld_queue))
 		shdma_chan_ld_cleanup(schan, true);
 
-	if (chan->private) {
+	if (schan->slave) {
 		/* The caller is holding dma_list_mutex */
-		struct shdma_slave *slave = chan->private;
+		struct shdma_slave *slave = schan->slave;
 		clear_bit(slave->slave_id, shdma_slave_used);
 		chan->private = NULL;
 	}
@@ -558,7 +559,7 @@ static struct dma_async_tx_descriptor *shdma_prep_slave_sg(
 	struct shdma_chan *schan = to_shdma_chan(chan);
 	struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
 	const struct shdma_ops *ops = sdev->ops;
-	struct shdma_slave *slave = chan->private;
+	struct shdma_slave *slave = schan->slave;
 	dma_addr_t slave_addr;
 
 	if (!chan)
diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index f06906f..9f0a2e5 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -291,10 +291,8 @@ static void sh_dmae_setup_xfer(struct shdma_chan *schan,
 						    shdma_chan);
 
 	if (sslave) {
-		struct sh_dmae_slave *slave = container_of(sslave,
-					struct sh_dmae_slave, shdma_slave);
 		const struct sh_dmae_slave_config *cfg =
-			slave->config;
+			sh_chan->config;
 
 		dmae_set_dmars(sh_chan, cfg->mid_rid);
 		dmae_set_chcr(sh_chan, cfg->chcr);
@@ -326,13 +324,11 @@ static int sh_dmae_set_slave(struct shdma_chan *schan,
 {
 	struct sh_dmae_chan *sh_chan = container_of(schan, struct sh_dmae_chan,
 						    shdma_chan);
-	struct sh_dmae_slave *slave = container_of(sslave, struct sh_dmae_slave,
-						   shdma_slave);
 	const struct sh_dmae_slave_config *cfg = dmae_find_slave(sh_chan, sslave->slave_id);
 	if (!cfg)
 		return -ENODEV;
 
-	slave->config = cfg;
+	sh_chan->config = cfg;
 
 	return 0;
 }
@@ -579,13 +575,12 @@ static int sh_dmae_resume(struct device *dev)
 
 	for (i = 0; i < shdev->pdata->channel_num; i++) {
 		struct sh_dmae_chan *sh_chan = shdev->chan[i];
-		struct sh_dmae_slave *param = sh_chan->shdma_chan.dma_chan.private;
 
 		if (!sh_chan->shdma_chan.desc_num)
 			continue;
 
-		if (param) {
-			const struct sh_dmae_slave_config *cfg = param->config;
+		if (sh_chan->shdma_chan.slave) {
+			const struct sh_dmae_slave_config *cfg = sh_chan->config;
 			dmae_set_dmars(sh_chan, cfg->mid_rid);
 			dmae_set_chcr(sh_chan, cfg->chcr);
 		} else {
@@ -609,14 +604,15 @@ const struct dev_pm_ops sh_dmae_pm = {
 
 static dma_addr_t sh_dmae_slave_addr(struct shdma_chan *schan)
 {
-	struct sh_dmae_slave *param = schan->dma_chan.private;
+	struct sh_dmae_chan *sh_chan = container_of(schan,
+					struct sh_dmae_chan, shdma_chan);
 
 	/*
-	 * Implicit BUG_ON(!param)
-	 * if (param != NULL), this is a successfully requested slave channel,
-	 * therefore param->config != NULL too.
+	 * Implicit BUG_ON(!sh_chan->config)
+	 * This is an exclusive slave DMA operation, may only be called after a
+	 * successful slave configuration.
 	 */
-	return param->config->addr;
+	return sh_chan->config->addr;
 }
 
 static struct shdma_desc *sh_dmae_embedded_desc(void *buf, int i)
diff --git a/drivers/dma/sh/shdma.h b/drivers/dma/sh/shdma.h
index 840e47d..9314e93 100644
--- a/drivers/dma/sh/shdma.h
+++ b/drivers/dma/sh/shdma.h
@@ -13,6 +13,7 @@
 #ifndef __DMA_SHDMA_H
 #define __DMA_SHDMA_H
 
+#include <linux/sh_dma.h>
 #include <linux/shdma-base.h>
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
@@ -25,6 +26,7 @@ struct device;
 
 struct sh_dmae_chan {
 	struct shdma_chan shdma_chan;
+	const struct sh_dmae_slave_config *config; /* Slave DMA configuration */
 	int xmit_shift;			/* log_2(bytes_per_xfer) */
 	u32 __iomem *base;
 	char dev_id[16];		/* unique name per DMAC of channel */
diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index 7c8ca41..a79f10a 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -20,8 +20,6 @@ struct device;
 /* Used by slave DMA clients to request DMA to/from a specific peripheral */
 struct sh_dmae_slave {
 	struct shdma_slave		shdma_slave;	/* Set by the platform */
-	struct device			*dma_dev;	/* Set by the platform */
-	const struct sh_dmae_slave_config *config;	/* Set by the driver */
 };
 
 /*
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index 83efd13..c3a19e9 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -66,6 +66,7 @@ struct shdma_chan {
 	size_t max_xfer_len;		/* max transfer length */
 	int id;				/* Raw id of this channel */
 	int irq;			/* Channel IRQ */
+	struct shdma_slave *slave;	/* Client data for slave DMA */
 	enum shdma_pm_state pm_state;
 };
 
-- 
1.7.2.5

