Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1HAJlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:41:50 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:47230 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521Ab1HAJjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:31 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>
Subject: [PATCH V2 11/20] dmaengine/amba-pl08x: Schedule tasklet in case of error interrupt
Date: Mon, 1 Aug 2011 15:07:21 +0530
Message-ID: <b41e57cfc9f7a7c35eba0305320e334e8600f158.1312190881.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if error interrupt occurs, nothing is done in interrupt handler (just
clearing the interrupts). We must somehow indicate this to the user that DMA is
over, due to ERR interrupt or TC interrupt.

So, this patch just schedules existing tasklet, with a print showing error
interrupt has occurred on which channels.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c |   44 +++++++++++++++++++++++---------------------
 1 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index f463841..1b7a60f 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1624,38 +1624,40 @@ static void pl08x_tasklet(unsigned long data)
 static irqreturn_t pl08x_irq(int irq, void *dev)
 {
 	struct pl08x_driver_data *pl08x = dev;
-	u32 mask = 0;
-	u32 val;
-	int i;
-
-	val = readl(pl08x->base + PL080_ERR_STATUS);
-	if (val) {
-		/* An error interrupt (on one or more channels) */
-		dev_err(&pl08x->adev->dev,
-			"%s error interrupt, register value 0x%08x\n",
-				__func__, val);
-		/*
-		 * Simply clear ALL PL08X error interrupts,
-		 * regardless of channel and cause
-		 * FIXME: should be 0x00000003 on PL081 really.
-		 */
-		writel(0x000000FF, pl08x->base + PL080_ERR_CLEAR);
+	u32 mask = 0, err, tc, i;
+
+	/* check & clear - ERR & TC interrupts */
+	err = readl(pl08x->base + PL080_ERR_STATUS);
+	if (err) {
+		dev_err(&pl08x->adev->dev, "%s error interrupt, register value 0x%08x\n",
+			__func__, err);
+		writel(err, pl08x->base + PL080_ERR_CLEAR);
 	}
-	val = readl(pl08x->base + PL080_INT_STATUS);
+	tc = readl(pl08x->base + PL080_INT_STATUS);
+	if (tc)
+		writel(tc, pl08x->base + PL080_TC_CLEAR);
+
+	if (!err && !tc)
+		return IRQ_NONE;
+
 	for (i = 0; i < pl08x->vd->channels; i++) {
-		if ((1 << i) & val) {
+		if (((1 << i) & err) || ((1 << i) & tc)) {
 			/* Locate physical channel */
 			struct pl08x_phy_chan *phychan = &pl08x->phy_chans[i];
 			struct pl08x_dma_chan *plchan = phychan->serving;
 
+			if (!plchan) {
+				dev_err(&pl08x->adev->dev,
+					"%s Error TC interrupt on unused channel: 0x%08x\n",
+					__func__, i);
+				continue;
+			}
+
 			/* Schedule tasklet on this channel */
 			tasklet_schedule(&plchan->tasklet);
-
 			mask |= (1 << i);
 		}
 	}
-	/* Clear only the terminal interrupts on channels we processed */
-	writel(mask, pl08x->base + PL080_TC_CLEAR);
 
 	return mask ? IRQ_HANDLED : IRQ_NONE;
 }
-- 
1.7.2.2

