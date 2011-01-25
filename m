Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1AYKY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:24:56 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:35616 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258Ab1AYKT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:28 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 08/32] dma40: allow realtime and priority for event lines
Date: Tue, 25 Jan 2011 11:18:11 +0100
Message-ID: <1295950715-22340-9-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

DB8500v2's DMA40 (revision 3) allows setting event lines as high priority and
real time.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    3 ++
 drivers/dma/ste_dma40.c                        |   34 ++++++++++++++++++++++++
 drivers/dma/ste_dma40_ll.h                     |   16 +++++++++++
 3 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 4d6dd4c..8358f85 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -104,6 +104,8 @@ struct stedma40_half_channel_info {
  *
  * @dir: MEM 2 MEM, PERIPH 2 MEM , MEM 2 PERIPH, PERIPH 2 PERIPH
  * @high_priority: true if high-priority
+ * @realtime: true if realtime mode is to be enabled.  Only available on DMA40
+ * version 3+, i.e DB8500v2+
  * @mode: channel mode: physical, logical, or operation
  * @mode_opt: options for the chosen channel mode
  * @src_dev_type: Src device type
@@ -119,6 +121,7 @@ struct stedma40_half_channel_info {
 struct stedma40_chan_cfg {
 	enum stedma40_xfer_dir			 dir;
 	bool					 high_priority;
+	bool					 realtime;
 	enum stedma40_mode			 mode;
 	enum stedma40_mode_opt			 mode_opt;
 	int					 src_dev_type;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0faae66..ce55162 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1724,6 +1724,38 @@ bool stedma40_filter(struct dma_chan *chan, void *data)
 }
 EXPORT_SYMBOL(stedma40_filter);
 
+static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
+{
+	bool realtime = d40c->dma_cfg.realtime;
+	bool highprio = d40c->dma_cfg.high_priority;
+	u32 prioreg = highprio ? D40_DREG_PSEG1 : D40_DREG_PCEG1;
+	u32 rtreg = realtime ? D40_DREG_RSEG1 : D40_DREG_RCEG1;
+	u32 event = D40_TYPE_TO_EVENT(dev_type);
+	u32 group = D40_TYPE_TO_GROUP(dev_type);
+	u32 bit = 1 << event;
+
+	/* Destination event lines are stored in the upper halfword */
+	if (!src)
+		bit <<= 16;
+
+	writel(bit, d40c->base->virtbase + prioreg + group * 4);
+	writel(bit, d40c->base->virtbase + rtreg + group * 4);
+}
+
+static void d40_set_prio_realtime(struct d40_chan *d40c)
+{
+	if (d40c->base->rev < 3)
+		return;
+
+	if ((d40c->dma_cfg.dir ==  STEDMA40_PERIPH_TO_MEM) ||
+	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH))
+		__d40_set_prio_rt(d40c, d40c->dma_cfg.src_dev_type, true);
+
+	if ((d40c->dma_cfg.dir ==  STEDMA40_MEM_TO_PERIPH) ||
+	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH))
+		__d40_set_prio_rt(d40c, d40c->dma_cfg.dst_dev_type, false);
+}
+
 /* DMA ENGINE functions */
 static int d40_alloc_chan_resources(struct dma_chan *chan)
 {
@@ -1756,6 +1788,8 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
 		    &d40c->dst_def_cfg, chan_is_logical(d40c));
 
+	d40_set_prio_realtime(d40c);
+
 	if (chan_is_logical(d40c)) {
 		d40_log_cfg(&d40c->dma_cfg,
 			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 9cc4349..e93f394 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -163,6 +163,22 @@
 #define D40_DREG_LCEIS1		0x0B4
 #define D40_DREG_LCEIS2		0x0B8
 #define D40_DREG_LCEIS3		0x0BC
+#define D40_DREG_PSEG1		0x110
+#define D40_DREG_PSEG2		0x114
+#define D40_DREG_PSEG3		0x118
+#define D40_DREG_PSEG4		0x11C
+#define D40_DREG_PCEG1		0x120
+#define D40_DREG_PCEG2		0x124
+#define D40_DREG_PCEG3		0x128
+#define D40_DREG_PCEG4		0x12C
+#define D40_DREG_RSEG1		0x130
+#define D40_DREG_RSEG2		0x134
+#define D40_DREG_RSEG3		0x138
+#define D40_DREG_RSEG4		0x13C
+#define D40_DREG_RCEG1		0x140
+#define D40_DREG_RCEG2		0x144
+#define D40_DREG_RCEG3		0x148
+#define D40_DREG_RCEG4		0x14C
 #define D40_DREG_STFU		0xFC8
 #define D40_DREG_ICFG		0xFCC
 #define D40_DREG_PERIPHID0	0xFE0
-- 
1.7.3.2

