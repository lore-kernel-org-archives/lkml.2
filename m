Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1G2KxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:53:19 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:41234 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946Ab1G2KuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:50:06 -0400
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
Subject: [PATCH 07/18] dmaengine/amba-pl08x: Enable/Disable amba_pclk with channel requests
Date: Fri, 29 Jul 2011 16:19:17 +0530
Message-ID: <96781d46e41fa6ffc04b88527a25d73f5a59eda8.1311936524.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1311936523.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amba devices have interface clocks attached as adev->pclk. This is the only
clock associated with DMAC and it can be disabled when DMAC is not in use. This
patch adds support to enable/disable this clk as and when channels are requested
and freed. Also it disables this clock at the end of probe.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 53d722e..f1a25cf 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -881,11 +881,19 @@ static void pl08x_free_txd_list(struct pl08x_driver_data *pl08x,
  */
 static int pl08x_alloc_chan_resources(struct dma_chan *chan)
 {
+	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	struct pl08x_driver_data *pl08x = plchan->host;
+
+	amba_pclk_enable(pl08x->adev);
 	return 0;
 }
 
 static void pl08x_free_chan_resources(struct dma_chan *chan)
 {
+	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	struct pl08x_driver_data *pl08x = plchan->host;
+
+	amba_pclk_disable(pl08x->adev);
 }
 
 /*
@@ -1993,6 +2001,8 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	dev_info(&pl08x->adev->dev, "DMA: PL%03x rev%u at 0x%08llx irq %d\n",
 		 amba_part(adev), amba_rev(adev),
 		 (unsigned long long)adev->res.start, adev->irq[0]);
+
+	amba_pclk_disable(adev);
 	return 0;
 
 out_no_slave_reg:
-- 
1.7.2.2

