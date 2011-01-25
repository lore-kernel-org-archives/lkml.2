Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1AYKTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:06 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:60329 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab1AYKTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:04 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 02/32] dma40: ensure event lines get enabled
Date: Tue, 25 Jan 2011 11:18:05 +0100
Message-ID: <1295950715-22340-3-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The controller sometimes fails to register the enable of the event line when
both src and dst event lines are used on the same logical channel.  Implement
the recommended software workaround, which is to retry the write until it
works.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   63 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 52013ed..42c88fc 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -303,6 +303,11 @@ struct d40_reg_val {
 	unsigned int val;
 };
 
+static struct device *chan2dev(struct d40_chan *d40c)
+{
+	return &d40c->chan.dev->device;
+}
+
 static int d40_pool_lli_alloc(struct d40_desc *d40d,
 			      int lli_len, bool is_log)
 {
@@ -701,17 +706,46 @@ static void d40_term_all(struct d40_chan *d40c)
 	d40c->busy = false;
 }
 
+static void __d40_config_set_event(struct d40_chan *d40c, bool enable,
+				   u32 event, int reg)
+{
+	void __iomem *addr = d40c->base->virtbase + D40_DREG_PCBASE
+			     + d40c->phy_chan->num * D40_DREG_PCDELTA + reg;
+	int tries;
+
+	if (!enable) {
+		writel((D40_DEACTIVATE_EVENTLINE << D40_EVENTLINE_POS(event))
+		       | ~D40_EVENTLINE_MASK(event), addr);
+		return;
+	}
+
+	/*
+	 * The hardware sometimes doesn't register the enable when src and dst
+	 * event lines are active on the same logical channel.  Retry to ensure
+	 * it does.  Usually only one retry is sufficient.
+	 */
+	tries = 100;
+	while (--tries) {
+		writel((D40_ACTIVATE_EVENTLINE << D40_EVENTLINE_POS(event))
+		       | ~D40_EVENTLINE_MASK(event), addr);
+
+		if (readl(addr) & D40_EVENTLINE_MASK(event))
+			break;
+	}
+
+	if (tries != 99)
+		dev_dbg(chan2dev(d40c),
+			"[%s] workaround enable S%cLNK (%d tries)\n",
+			__func__, reg == D40_CHAN_REG_SSLNK ? 'S' : 'D',
+			100 - tries);
+
+	WARN_ON(!tries);
+}
+
 static void d40_config_set_event(struct d40_chan *d40c, bool do_enable)
 {
-	u32 val;
 	unsigned long flags;
 
-	/* Notice, that disable requires the physical channel to be stopped */
-	if (do_enable)
-		val = D40_ACTIVATE_EVENTLINE;
-	else
-		val = D40_DEACTIVATE_EVENTLINE;
-
 	spin_lock_irqsave(&d40c->phy_chan->lock, flags);
 
 	/* Enable event line connected to device (or memcpy) */
@@ -719,20 +753,15 @@ static void d40_config_set_event(struct d40_chan *d40c, bool do_enable)
 	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH)) {
 		u32 event = D40_TYPE_TO_EVENT(d40c->dma_cfg.src_dev_type);
 
-		writel((val << D40_EVENTLINE_POS(event)) |
-		       ~D40_EVENTLINE_MASK(event),
-		       d40c->base->virtbase + D40_DREG_PCBASE +
-		       d40c->phy_chan->num * D40_DREG_PCDELTA +
-		       D40_CHAN_REG_SSLNK);
+		__d40_config_set_event(d40c, do_enable, event,
+				       D40_CHAN_REG_SSLNK);
 	}
+
 	if (d40c->dma_cfg.dir !=  STEDMA40_PERIPH_TO_MEM) {
 		u32 event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
 
-		writel((val << D40_EVENTLINE_POS(event)) |
-		       ~D40_EVENTLINE_MASK(event),
-		       d40c->base->virtbase + D40_DREG_PCBASE +
-		       d40c->phy_chan->num * D40_DREG_PCDELTA +
-		       D40_CHAN_REG_SDLNK);
+		__d40_config_set_event(d40c, do_enable, event,
+				       D40_CHAN_REG_SDLNK);
 	}
 
 	spin_unlock_irqrestore(&d40c->phy_chan->lock, flags);
-- 
1.7.3.2

