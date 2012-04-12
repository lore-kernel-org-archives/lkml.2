Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047Ab2DLHCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:02:00 -0400
Received: from mail.df.lth.se ([194.47.250.12]:35297 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945Ab2DLHB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:01:59 -0400
From: "Linus Walleij" <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: [PATCH 2/2 v3] dma/amba-pl08x: add support for the Nomadik variant
Date: Thu, 12 Apr 2012 09:01:49 +0200
Message-Id: <1334214109-15644-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Nomadik PL080 variant has some extra protection bits that
may be set, so we need to check these bits to see if the
channels are actually available for the DMAengine to use.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alim Akhtar <alim.akhtar@gmail.com>
Cc: Alessandro Rubini <rubini@gnudd.com>
Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Fixed these review comments from Viresh Kumar
- Use kzalloc to allocate the physical channel structs so
  we don't have to assign values to everything and can assume
  booleans are default false
- unbreak long error message.
ChangeLog v2->v3:
- Remove an extraneous NULL assignment now that we have
  kzalloc for the physical channel info.
---
 arch/arm/include/asm/hardware/pl080.h |    2 +
 drivers/dma/amba-pl08x.c              |   44 +++++++++++++++++++++++++++-----
 include/linux/amba/pl08x.h            |    3 ++
 3 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/hardware/pl080.h b/arch/arm/include/asm/hardware/pl080.h
index 33c78d7..4eea210 100644
--- a/arch/arm/include/asm/hardware/pl080.h
+++ b/arch/arm/include/asm/hardware/pl080.h
@@ -102,6 +102,8 @@
 #define PL080_WIDTH_16BIT			(0x1)
 #define PL080_WIDTH_32BIT			(0x2)
 
+#define PL080N_CONFIG_ITPROT			(1 << 20)
+#define PL080N_CONFIG_SECPROT			(1 << 19)
 #define PL080_CONFIG_HALT			(1 << 18)
 #define PL080_CONFIG_ACTIVE			(1 << 17)  /* RO */
 #define PL080_CONFIG_LOCK			(1 << 16)
diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 08589c6..629250e 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -95,10 +95,14 @@ static struct amba_driver pl08x_amba_driver;
  * struct vendor_data - vendor-specific config parameters for PL08x derivatives
  * @channels: the number of channels available in this variant
  * @dualmaster: whether this version supports dual AHB masters or not.
+ * @nomadik: whether the channels have Nomadik security extension bits
+ *	that need to be checked for permission before use and some registers are
+ *	missing
  */
 struct vendor_data {
 	u8 channels;
 	bool dualmaster;
+	bool nomadik;
 };
 
 /*
@@ -385,7 +389,7 @@ pl08x_get_phy_channel(struct pl08x_driver_data *pl08x,
 
 		spin_lock_irqsave(&ch->lock, flags);
 
-		if (!ch->serving) {
+		if (!ch->locked && !ch->serving) {
 			ch->serving = virt_chan;
 			ch->signal = -1;
 			spin_unlock_irqrestore(&ch->lock, flags);
@@ -1483,6 +1487,9 @@ bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
  */
 static void pl08x_ensure_on(struct pl08x_driver_data *pl08x)
 {
+	/* The Nomadik variant does not have the config register */
+	if (pl08x->vd->nomadik)
+		return;
 	writel(PL080_CONFIG_ENABLE, pl08x->base + PL080_CONFIG);
 }
 
@@ -1772,8 +1779,10 @@ static int pl08x_debugfs_show(struct seq_file *s, void *data)
 		spin_lock_irqsave(&ch->lock, flags);
 		virt_chan = ch->serving;
 
-		seq_printf(s, "%d\t\t%s\n",
-			   ch->id, virt_chan ? virt_chan->name : "(none)");
+		seq_printf(s, "%d\t\t%s%s\n",
+			   ch->id,
+			   virt_chan ? virt_chan->name : "(none)",
+			   ch->locked ? " LOCKED" : "");
 
 		spin_unlock_irqrestore(&ch->lock, flags);
 	}
@@ -1917,7 +1926,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	/* Initialize physical channels */
-	pl08x->phy_chans = kmalloc((vd->channels * sizeof(*pl08x->phy_chans)),
+	pl08x->phy_chans = kzalloc((vd->channels * sizeof(*pl08x->phy_chans)),
 			GFP_KERNEL);
 	if (!pl08x->phy_chans) {
 		dev_err(&adev->dev, "%s failed to allocate "
@@ -1932,8 +1941,23 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		ch->id = i;
 		ch->base = pl08x->base + PL080_Cx_BASE(i);
 		spin_lock_init(&ch->lock);
-		ch->serving = NULL;
 		ch->signal = -1;
+
+		/*
+		 * Nomadik variants can have channels that are locked
+		 * down for the secure world only. Lock up these channels
+		 * by perpetually serving a dummy virtual channel.
+		 */
+		if (vd->nomadik) {
+			u32 val;
+
+			val = readl(ch->base + PL080_CH_CONFIG);
+			if (val & (PL080N_CONFIG_ITPROT | PL080N_CONFIG_SECPROT)) {
+				dev_info(&adev->dev, "physical channel %d reserved for secure access only\n", i);
+				ch->locked = true;
+			}
+		}
+
 		dev_dbg(&adev->dev, "physical channel %d is %s\n",
 			i, pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
 	}
@@ -2016,6 +2040,12 @@ static struct vendor_data vendor_pl080 = {
 	.dualmaster = true,
 };
 
+static struct vendor_data vendor_nomadik = {
+	.channels = 8,
+	.dualmaster = true,
+	.nomadik = true,
+};
+
 static struct vendor_data vendor_pl081 = {
 	.channels = 2,
 	.dualmaster = false,
@@ -2036,9 +2066,9 @@ static struct amba_id pl08x_ids[] = {
 	},
 	/* Nomadik 8815 PL080 variant */
 	{
-		.id	= 0x00280880,
+		.id	= 0x00280080,
 		.mask	= 0x00ffffff,
-		.data	= &vendor_pl080,
+		.data	= &vendor_nomadik,
 	},
 	{ 0, 0 },
 };
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index e64ce2c..0254901 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -92,6 +92,8 @@ struct pl08x_bus_data {
  * right now
  * @serving: the virtual channel currently being served by this physical
  * channel
+ * @locked: channel unavailable for the system, e.g. dedicated to secure
+ * world
  */
 struct pl08x_phy_chan {
 	unsigned int id;
@@ -99,6 +101,7 @@ struct pl08x_phy_chan {
 	spinlock_t lock;
 	int signal;
 	struct pl08x_dma_chan *serving;
+	bool locked;
 };
 
 /**
-- 
1.7.7.6

