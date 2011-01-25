Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1AYKYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:24:15 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:45242 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291Ab1AYKTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:32 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 04/32] dma40: use helper for channel registers base
Date: Tue, 25 Jan 2011 11:18:07 +0100
Message-ID: <1295950715-22340-5-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The register offset computation for accessing channel registers is copy/pasted
in several places.  Create a helper function to do it.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   74 +++++++++++++++++++----------------------------
 1 files changed, 30 insertions(+), 44 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ed2a3eb..3d4cea3 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -306,6 +306,12 @@ static struct device *chan2dev(struct d40_chan *d40c)
 	return &d40c->chan.dev->device;
 }
 
+static void __iomem *chan_base(struct d40_chan *chan)
+{
+	return chan->base->virtbase + D40_DREG_PCBASE +
+	       chan->phy_chan->num * D40_DREG_PCDELTA;
+}
+
 static int d40_pool_lli_alloc(struct d40_desc *d40d,
 			      int lli_len, bool is_log)
 {
@@ -695,8 +701,7 @@ static void d40_term_all(struct d40_chan *d40c)
 static void __d40_config_set_event(struct d40_chan *d40c, bool enable,
 				   u32 event, int reg)
 {
-	void __iomem *addr = d40c->base->virtbase + D40_DREG_PCBASE
-			     + d40c->phy_chan->num * D40_DREG_PCDELTA + reg;
+	void __iomem *addr = chan_base(d40c) + reg;
 	int tries;
 
 	if (!enable) {
@@ -755,15 +760,12 @@ static void d40_config_set_event(struct d40_chan *d40c, bool do_enable)
 
 static u32 d40_chan_has_events(struct d40_chan *d40c)
 {
+	void __iomem *chanbase = chan_base(d40c);
 	u32 val;
 
-	val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
-		    d40c->phy_chan->num * D40_DREG_PCDELTA +
-		    D40_CHAN_REG_SSLNK);
+	val = readl(chanbase + D40_CHAN_REG_SSLNK);
+	val |= readl(chanbase + D40_CHAN_REG_SDLNK);
 
-	val |= readl(d40c->base->virtbase + D40_DREG_PCBASE +
-		     d40c->phy_chan->num * D40_DREG_PCDELTA +
-		     D40_CHAN_REG_SDLNK);
 	return val;
 }
 
@@ -810,29 +812,17 @@ static void d40_config_write(struct d40_chan *d40c)
 	writel(var, d40c->base->virtbase + D40_DREG_PRMOE + addr_base);
 
 	if (d40c->log_num != D40_PHY_CHAN) {
+		int lidx = (d40c->phy_chan->num << D40_SREG_ELEM_LOG_LIDX_POS)
+			   & D40_SREG_ELEM_LOG_LIDX_MASK;
+		void __iomem *chanbase = chan_base(d40c);
+
 		/* Set default config for CFG reg */
-		writel(d40c->src_def_cfg,
-		       d40c->base->virtbase + D40_DREG_PCBASE +
-		       d40c->phy_chan->num * D40_DREG_PCDELTA +
-		       D40_CHAN_REG_SSCFG);
-		writel(d40c->dst_def_cfg,
-		       d40c->base->virtbase + D40_DREG_PCBASE +
-		       d40c->phy_chan->num * D40_DREG_PCDELTA +
-		       D40_CHAN_REG_SDCFG);
+		writel(d40c->src_def_cfg, chanbase + D40_CHAN_REG_SSCFG);
+		writel(d40c->dst_def_cfg, chanbase + D40_CHAN_REG_SDCFG);
 
 		/* Set LIDX for lcla */
-		writel((d40c->phy_chan->num << D40_SREG_ELEM_LOG_LIDX_POS) &
-		       D40_SREG_ELEM_LOG_LIDX_MASK,
-		       d40c->base->virtbase + D40_DREG_PCBASE +
-		       d40c->phy_chan->num * D40_DREG_PCDELTA +
-		       D40_CHAN_REG_SDELT);
-
-		writel((d40c->phy_chan->num << D40_SREG_ELEM_LOG_LIDX_POS) &
-		       D40_SREG_ELEM_LOG_LIDX_MASK,
-		       d40c->base->virtbase + D40_DREG_PCBASE +
-		       d40c->phy_chan->num * D40_DREG_PCDELTA +
-		       D40_CHAN_REG_SSELT);
-
+		writel(lidx, chanbase + D40_CHAN_REG_SSELT);
+		writel(lidx, chanbase + D40_CHAN_REG_SDELT);
 	}
 }
 
@@ -843,12 +833,12 @@ static u32 d40_residue(struct d40_chan *d40c)
 	if (d40c->log_num != D40_PHY_CHAN)
 		num_elt = (readl(&d40c->lcpa->lcsp2) & D40_MEM_LCSP2_ECNT_MASK)
 			>> D40_MEM_LCSP2_ECNT_POS;
-	else
-		num_elt = (readl(d40c->base->virtbase + D40_DREG_PCBASE +
-				 d40c->phy_chan->num * D40_DREG_PCDELTA +
-				 D40_CHAN_REG_SDELT) &
-			   D40_SREG_ELEM_PHY_ECNT_MASK) >>
-			D40_SREG_ELEM_PHY_ECNT_POS;
+	else {
+		u32 val = readl(chan_base(d40c) + D40_CHAN_REG_SDELT);
+		num_elt = (val & D40_SREG_ELEM_PHY_ECNT_MASK)
+			  >> D40_SREG_ELEM_PHY_ECNT_POS;
+	}
+
 	return num_elt * (1 << d40c->dma_cfg.dst_info.data_width);
 }
 
@@ -859,10 +849,9 @@ static bool d40_tx_is_linked(struct d40_chan *d40c)
 	if (d40c->log_num != D40_PHY_CHAN)
 		is_link = readl(&d40c->lcpa->lcsp3) &  D40_MEM_LCSP3_DLOS_MASK;
 	else
-		is_link = readl(d40c->base->virtbase + D40_DREG_PCBASE +
-				d40c->phy_chan->num * D40_DREG_PCDELTA +
-				D40_CHAN_REG_SDLNK) &
-			D40_SREG_LNK_PHYS_LNK_MASK;
+		is_link = readl(chan_base(d40c) + D40_CHAN_REG_SDLNK)
+			  & D40_SREG_LNK_PHYS_LNK_MASK;
+
 	return is_link;
 }
 
@@ -1550,6 +1539,7 @@ static int d40_free_dma(struct d40_chan *d40c)
 
 static bool d40_is_paused(struct d40_chan *d40c)
 {
+	void __iomem *chanbase = chan_base(d40c);
 	bool is_paused = false;
 	unsigned long flags;
 	void __iomem *active_reg;
@@ -1576,14 +1566,10 @@ static bool d40_is_paused(struct d40_chan *d40c)
 	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
 	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
 		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
-		status = readl(d40c->base->virtbase + D40_DREG_PCBASE +
-			       d40c->phy_chan->num * D40_DREG_PCDELTA +
-			       D40_CHAN_REG_SDLNK);
+		status = readl(chanbase + D40_CHAN_REG_SDLNK);
 	} else if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM) {
 		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.src_dev_type);
-		status = readl(d40c->base->virtbase + D40_DREG_PCBASE +
-			       d40c->phy_chan->num * D40_DREG_PCDELTA +
-			       D40_CHAN_REG_SSLNK);
+		status = readl(chanbase + D40_CHAN_REG_SSLNK);
 	} else {
 		dev_err(&d40c->chan.dev->device,
 			"[%s] Unknown direction\n", __func__);
-- 
1.7.3.2

