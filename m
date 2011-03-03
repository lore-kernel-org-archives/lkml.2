Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab1CCKTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:19:49 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:53967 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758008Ab1CCKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:18:41 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>,
        <jamie@jamieiles.com>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>,
        <hans-christian.egtvedt@atmel.com>
Subject: [PATCH V2 08/13] dw_dmac: Pass Channel Allocation Order from platform_data
Date: Thu, 3 Mar 2011 15:47:21 +0530
Message-ID: <ae9ffb45b87e19aabeba9321ffffb8ec2b5f5056.1299146382.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1299146382.git.viresh.kumar@st.com>
References: <cover.1299146382.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In SPEAr Platform channels 4-7 have more Fifo depth. So we must get better
channel first. This patch introduces concept of channel allocation order in
dw_dmac. If user doesn't pass anything or 0, than normal (ascending) channel
allocation will follow, else channels will be allocated in descending order.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c   |    6 +++++-
 include/linux/dw_dmac.h |    3 +++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 836c299..076a2fa 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1319,7 +1319,11 @@ static int __init dw_probe(struct platform_device *pdev)
 		dwc->chan.device = &dw->dma;
 		dwc->chan.cookie = dwc->completed = 1;
 		dwc->chan.chan_id = i;
-		list_add_tail(&dwc->chan.device_node, &dw->dma.channels);
+		if (pdata->chan_allocation_order == CHAN_ALLOCATION_ASCENDING)
+			list_add_tail(&dwc->chan.device_node,
+					&dw->dma.channels);
+		else
+			list_add(&dwc->chan.device_node, &dw->dma.channels);
 
 		dwc->ch_regs = &__dw_regs(dw)->CHAN[i];
 		spin_lock_init(&dwc->lock);
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index deec66b..a18c498 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -22,6 +22,9 @@
 struct dw_dma_platform_data {
 	unsigned int	nr_channels;
 	bool		is_private;
+#define CHAN_ALLOCATION_ASCENDING	0	/* zero to seven */
+#define CHAN_ALLOCATION_DESCENDING	1	/* seven to zero */
+	unsigned char	chan_allocation_order;
 };
 
 /**
-- 
1.7.2.2

