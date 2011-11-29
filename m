Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1K2H1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:27:18 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:35902 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099Ab1K2H1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:27:16 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH] dmaengine/amba-pl08x: Config ccfg and increment phychan_hold if phychan is true
Date: Tue, 29 Nov 2011 12:56:50 +0530
Message-ID: <fc4d77e6355cc462cfc2e700415cd56b9db816cb.1322551469.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if plchan->phychan is true, we return immediately from
prep_phy_chan(). We must configure txd->ccfg and increment phychan_hold before
returning. Otherwise, request line number wouldn't be configured in this txd.

Reported-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 41c62fd..9ebceca 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -854,8 +854,10 @@ static int prep_phy_channel(struct pl08x_dma_chan *plchan,
 	int ret;
 
 	/* Check if we already have a channel */
-	if (plchan->phychan)
-		return 0;
+	if (plchan->phychan) {
+		ch = plchan->phychan;
+		goto got_channel;
+	}
 
 	ch = pl08x_get_phy_channel(pl08x, plchan);
 	if (!ch) {
@@ -880,21 +882,22 @@ static int prep_phy_channel(struct pl08x_dma_chan *plchan,
 			return -EBUSY;
 		}
 		ch->signal = ret;
-
-		/* Assign the flow control signal to this channel */
-		if (txd->direction == DMA_MEM_TO_DEV)
-			txd->ccfg |= ch->signal << PL080_CONFIG_DST_SEL_SHIFT;
-		else if (txd->direction == DMA_DEV_TO_MEM)
-			txd->ccfg |= ch->signal << PL080_CONFIG_SRC_SEL_SHIFT;
 	}
 
+	plchan->phychan = ch;
 	dev_dbg(&pl08x->adev->dev, "allocated physical channel %d and signal %d for xfer on %s\n",
 		 ch->id,
 		 ch->signal,
 		 plchan->name);
 
+got_channel:
+	/* Assign the flow control signal to this channel */
+	if (txd->direction == DMA_MEM_TO_DEV)
+		txd->ccfg |= ch->signal << PL080_CONFIG_DST_SEL_SHIFT;
+	else if (txd->direction == DMA_DEV_TO_MEM)
+		txd->ccfg |= ch->signal << PL080_CONFIG_SRC_SEL_SHIFT;
+
 	plchan->phychan_hold++;
-	plchan->phychan = ch;
 
 	return 0;
 }
-- 
1.7.2.2

