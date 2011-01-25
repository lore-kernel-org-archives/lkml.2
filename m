Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1AYKWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:22:52 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:60640 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab1AYKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:43 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 21/32] dma40: move lli_load to main source file
Date: Tue, 25 Jan 2011 11:18:24 +0100
Message-ID: <1295950715-22340-22-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

These register writes are better placed in the main source file rather than
ll.c.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |   22 ++++++++++++++++++----
 drivers/dma/ste_dma40_ll.c |   26 --------------------------
 drivers/dma/ste_dma40_ll.h |    5 -----
 3 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4e9d6c5..6a7a00d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -504,15 +504,29 @@ static void d40_desc_submit(struct d40_chan *d40c, struct d40_desc *desc)
 	list_add_tail(&desc->node, &d40c->active);
 }
 
+static void d40_phy_lli_load(struct d40_chan *chan, struct d40_desc *desc)
+{
+	struct d40_phy_lli *lli_dst = desc->lli_phy.dst;
+	struct d40_phy_lli *lli_src = desc->lli_phy.src;
+	void __iomem *base = chan_base(chan);
+
+	writel(lli_src->reg_cfg, base + D40_CHAN_REG_SSCFG);
+	writel(lli_src->reg_elt, base + D40_CHAN_REG_SSELT);
+	writel(lli_src->reg_ptr, base + D40_CHAN_REG_SSPTR);
+	writel(lli_src->reg_lnk, base + D40_CHAN_REG_SSLNK);
+
+	writel(lli_dst->reg_cfg, base + D40_CHAN_REG_SDCFG);
+	writel(lli_dst->reg_elt, base + D40_CHAN_REG_SDELT);
+	writel(lli_dst->reg_ptr, base + D40_CHAN_REG_SDPTR);
+	writel(lli_dst->reg_lnk, base + D40_CHAN_REG_SDLNK);
+}
+
 static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
 {
 	int curr_lcla = -EINVAL, next_lcla;
 
 	if (chan_is_physical(d40c)) {
-		d40_phy_lli_write(d40c->base->virtbase,
-				  d40c->phy_chan->num,
-				  d40d->lli_phy.dst,
-				  d40d->lli_phy.src);
+		d40_phy_lli_load(d40c, d40d);
 		d40d->lli_current = d40d->lli_len;
 	} else {
 
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 552c597..fd75251 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -295,32 +295,6 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 }
 
 
-void d40_phy_lli_write(void __iomem *virtbase,
-		       u32 phy_chan_num,
-		       struct d40_phy_lli *lli_dst,
-		       struct d40_phy_lli *lli_src)
-{
-
-	writel(lli_src->reg_cfg, virtbase + D40_DREG_PCBASE +
-	       phy_chan_num * D40_DREG_PCDELTA + D40_CHAN_REG_SSCFG);
-	writel(lli_src->reg_elt, virtbase + D40_DREG_PCBASE +
-	       phy_chan_num * D40_DREG_PCDELTA + D40_CHAN_REG_SSELT);
-	writel(lli_src->reg_ptr, virtbase + D40_DREG_PCBASE +
-	       phy_chan_num * D40_DREG_PCDELTA + D40_CHAN_REG_SSPTR);
-	writel(lli_src->reg_lnk, virtbase + D40_DREG_PCBASE +
-	       phy_chan_num * D40_DREG_PCDELTA + D40_CHAN_REG_SSLNK);
-
-	writel(lli_dst->reg_cfg, virtbase + D40_DREG_PCBASE +
-	       phy_chan_num * D40_DREG_PCDELTA + D40_CHAN_REG_SDCFG);
-	writel(lli_dst->reg_elt, virtbase + D40_DREG_PCBASE +
-	       phy_chan_num * D40_DREG_PCDELTA + D40_CHAN_REG_SDELT);
-	writel(lli_dst->reg_ptr, virtbase + D40_DREG_PCBASE +
-	       phy_chan_num * D40_DREG_PCDELTA + D40_CHAN_REG_SDPTR);
-	writel(lli_dst->reg_lnk, virtbase + D40_DREG_PCBASE +
-	       phy_chan_num * D40_DREG_PCDELTA + D40_CHAN_REG_SDLNK);
-
-}
-
 /* DMA logical lli operations */
 
 static void d40_log_lli_link(struct d40_log_lli *lli_dst,
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index a5d7171..46578a66 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -312,11 +312,6 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      u32 data_width2,
 		      int psize);
 
-void d40_phy_lli_write(void __iomem *virtbase,
-		       u32 phy_chan_num,
-		       struct d40_phy_lli *lli_dst,
-		       struct d40_phy_lli *lli_src);
-
 /* Logical channels */
 
 struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
-- 
1.7.3.2

