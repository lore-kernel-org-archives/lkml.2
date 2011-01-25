Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1AYKX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:23:29 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:38911 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341Ab1AYKTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:35 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 05/32] dma40: use helpers for channel type check
Date: Tue, 25 Jan 2011 11:18:08 +0100
Message-ID: <1295950715-22340-6-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The somewhat confusing check

	d40c->log_num == D40_PHY_CHAN

and its variants are used in several places to check if a channel is logical or
physical.  Use appropriately named helpers to do this to make the code more
readable.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   54 +++++++++++++++++++++++++++-------------------
 1 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3d4cea3..0073988 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -306,6 +306,16 @@ static struct device *chan2dev(struct d40_chan *d40c)
 	return &d40c->chan.dev->device;
 }
 
+static bool chan_is_physical(struct d40_chan *chan)
+{
+	return chan->log_num == D40_PHY_CHAN;
+}
+
+static bool chan_is_logical(struct d40_chan *chan)
+{
+	return !chan_is_physical(chan);
+}
+
 static void __iomem *chan_base(struct d40_chan *chan)
 {
 	return chan->base->virtbase + D40_DREG_PCBASE +
@@ -400,7 +410,7 @@ static int d40_lcla_free_all(struct d40_chan *d40c,
 	int i;
 	int ret = -EINVAL;
 
-	if (d40c->log_num == D40_PHY_CHAN)
+	if (chan_is_physical(d40c))
 		return 0;
 
 	spin_lock_irqsave(&d40c->base->lcla_pool.lock, flags);
@@ -472,7 +482,7 @@ static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
 {
 	int curr_lcla = -EINVAL, next_lcla;
 
-	if (d40c->log_num == D40_PHY_CHAN) {
+	if (chan_is_physical(d40c)) {
 		d40_phy_lli_write(d40c->base->virtbase,
 				  d40c->phy_chan->num,
 				  d40d->lli_phy.dst,
@@ -788,7 +798,7 @@ static u32 d40_get_prmo(struct d40_chan *d40c)
 			= D40_DREG_PRMO_LCHAN_SRC_LOG_DST_LOG,
 	};
 
-	if (d40c->log_num == D40_PHY_CHAN)
+	if (chan_is_physical(d40c))
 		return phy_map[d40c->dma_cfg.mode_opt];
 	else
 		return log_map[d40c->dma_cfg.mode_opt];
@@ -802,7 +812,7 @@ static void d40_config_write(struct d40_chan *d40c)
 	/* Odd addresses are even addresses + 4 */
 	addr_base = (d40c->phy_chan->num % 2) * 4;
 	/* Setup channel mode to logical or physical */
-	var = ((u32)(d40c->log_num != D40_PHY_CHAN) + 1) <<
+	var = ((u32)(chan_is_logical(d40c)) + 1) <<
 		D40_CHAN_POS(d40c->phy_chan->num);
 	writel(var, d40c->base->virtbase + D40_DREG_PRMSE + addr_base);
 
@@ -811,7 +821,7 @@ static void d40_config_write(struct d40_chan *d40c)
 
 	writel(var, d40c->base->virtbase + D40_DREG_PRMOE + addr_base);
 
-	if (d40c->log_num != D40_PHY_CHAN) {
+	if (chan_is_logical(d40c)) {
 		int lidx = (d40c->phy_chan->num << D40_SREG_ELEM_LOG_LIDX_POS)
 			   & D40_SREG_ELEM_LOG_LIDX_MASK;
 		void __iomem *chanbase = chan_base(d40c);
@@ -830,7 +840,7 @@ static u32 d40_residue(struct d40_chan *d40c)
 {
 	u32 num_elt;
 
-	if (d40c->log_num != D40_PHY_CHAN)
+	if (chan_is_logical(d40c))
 		num_elt = (readl(&d40c->lcpa->lcsp2) & D40_MEM_LCSP2_ECNT_MASK)
 			>> D40_MEM_LCSP2_ECNT_POS;
 	else {
@@ -846,7 +856,7 @@ static bool d40_tx_is_linked(struct d40_chan *d40c)
 {
 	bool is_link;
 
-	if (d40c->log_num != D40_PHY_CHAN)
+	if (chan_is_logical(d40c))
 		is_link = readl(&d40c->lcpa->lcsp3) &  D40_MEM_LCSP3_DLOS_MASK;
 	else
 		is_link = readl(chan_base(d40c) + D40_CHAN_REG_SDLNK)
@@ -869,7 +879,7 @@ static int d40_pause(struct dma_chan *chan)
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 	if (res == 0) {
-		if (d40c->log_num != D40_PHY_CHAN) {
+		if (chan_is_logical(d40c)) {
 			d40_config_set_event(d40c, false);
 			/* Resume the other logical channels if any */
 			if (d40_chan_has_events(d40c))
@@ -895,7 +905,7 @@ static int d40_resume(struct dma_chan *chan)
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	if (d40c->base->rev == 0)
-		if (d40c->log_num != D40_PHY_CHAN) {
+		if (chan_is_logical(d40c)) {
 			res = d40_channel_execute_command(d40c,
 							  D40_DMA_SUSPEND_REQ);
 			goto no_suspend;
@@ -904,7 +914,7 @@ static int d40_resume(struct dma_chan *chan)
 	/* If bytes left to transfer or linked tx resume job */
 	if (d40_residue(d40c) || d40_tx_is_linked(d40c)) {
 
-		if (d40c->log_num != D40_PHY_CHAN)
+		if (chan_is_logical(d40c))
 			d40_config_set_event(d40c, true);
 
 		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
@@ -944,7 +954,7 @@ static int d40_start(struct d40_chan *d40c)
 	if (d40c->base->rev == 0) {
 		int err;
 
-		if (d40c->log_num != D40_PHY_CHAN) {
+		if (chan_is_logical(d40c)) {
 			err = d40_channel_execute_command(d40c,
 							  D40_DMA_SUSPEND_REQ);
 			if (err)
@@ -952,7 +962,7 @@ static int d40_start(struct d40_chan *d40c)
 		}
 	}
 
-	if (d40c->log_num != D40_PHY_CHAN)
+	if (chan_is_logical(d40c))
 		d40_config_set_event(d40c, true);
 
 	return d40_channel_execute_command(d40c, D40_DMA_RUN);
@@ -1495,7 +1505,7 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return res;
 	}
 
-	if (d40c->log_num != D40_PHY_CHAN) {
+	if (chan_is_logical(d40c)) {
 		/* Release logical channel, deactivate the event line */
 
 		d40_config_set_event(d40c, false);
@@ -1548,7 +1558,7 @@ static bool d40_is_paused(struct d40_chan *d40c)
 
 	spin_lock_irqsave(&d40c->lock, flags);
 
-	if (d40c->log_num == D40_PHY_CHAN) {
+	if (chan_is_physical(d40c)) {
 		if (d40c->phy_chan->num % 2 == 0)
 			active_reg = d40c->base->virtbase + D40_DREG_ACTIVE;
 		else
@@ -1638,7 +1648,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 	d40d->lli_current = 0;
 	d40d->txd.flags = dma_flags;
 
-	if (d40c->log_num != D40_PHY_CHAN) {
+	if (chan_is_logical(d40c)) {
 
 		if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
 			dev_err(&d40c->chan.dev->device,
@@ -1765,9 +1775,9 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 
 	/* Fill in basic CFG register values */
 	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
-		    &d40c->dst_def_cfg, d40c->log_num != D40_PHY_CHAN);
+		    &d40c->dst_def_cfg, chan_is_logical(d40c));
 
-	if (d40c->log_num != D40_PHY_CHAN) {
+	if (chan_is_logical(d40c)) {
 		d40_log_cfg(&d40c->dma_cfg,
 			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
 
@@ -1857,7 +1867,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 
 	d40d->txd.tx_submit = d40_tx_submit;
 
-	if (d40c->log_num != D40_PHY_CHAN) {
+	if (chan_is_logical(d40c)) {
 
 		if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
 			dev_err(&d40c->chan.dev->device,
@@ -2093,7 +2103,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 	if (d40d == NULL)
 		goto err;
 
-	if (d40c->log_num != D40_PHY_CHAN)
+	if (chan_is_logical(d40c))
 		err = d40_prep_slave_sg_log(d40d, d40c, sgl, sg_len,
 					    direction, dma_flags);
 	else
@@ -2103,7 +2113,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 		dev_err(&d40c->chan.dev->device,
 			"[%s] Failed to prepare %s slave sg job: %d\n",
 			__func__,
-			d40c->log_num != D40_PHY_CHAN ? "log" : "phy", err);
+			chan_is_logical(d40c) ? "log" : "phy", err);
 		goto err;
 	}
 
@@ -2253,7 +2263,7 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 		return;
 	}
 
-	if (d40c->log_num != D40_PHY_CHAN) {
+	if (chan_is_logical(d40c)) {
 		if (config_maxburst >= 16)
 			psize = STEDMA40_PSIZE_LOG_16;
 		else if (config_maxburst >= 8)
@@ -2286,7 +2296,7 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 	cfg->dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL;
 
 	/* Fill in register values */
-	if (d40c->log_num != D40_PHY_CHAN)
+	if (chan_is_logical(d40c))
 		d40_log_cfg(cfg, &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
 	else
 		d40_phy_cfg(cfg, &d40c->src_def_cfg,
-- 
1.7.3.2

