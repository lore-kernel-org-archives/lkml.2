Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1BQHob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:44:31 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:43100 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940Ab1BQHo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:44:29 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>
Cc: <shiraz.hashim@st.com>, <amit.goel@st.com>, <armando.visconti@st.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: [PATCH 7/7] dw_dmac.c: Pass Channel Allocation Priority from platform_data
Date: Thu, 17 Feb 2011 12:54:57 +0530
Message-ID: <f3bad0383f8463f4a42282d50ae0548d5191dd59.1297926678.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
References: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh KUMAR <viresh.kumar@st.com>

In SPEAr Platform channels 4-7 have more Fifo depth. So we must get better
channel first. This patch introduces concept of channel allocation priority in
dw_dmac. If user doesn't paas anything or 0, than normal (ascending) channel
allocation will follow, else channels will be allocated in descending order.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c   |    6 +++++-
 include/linux/dw_dmac.h |    3 +++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 01f783d..d4bf956 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1314,7 +1314,11 @@ static int __init dw_probe(struct platform_device *pdev)
 		dwc->chan.device = &dw->dma;
 		dwc->chan.cookie = dwc->completed = 1;
 		dwc->chan.chan_id = i;
-		list_add_tail(&dwc->chan.device_node, &dw->dma.channels);
+		if (pdata->chan_priority == CHAN_PRIO_ASCENDING)
+			list_add_tail(&dwc->chan.device_node,
+					&dw->dma.channels);
+		else
+			list_add(&dwc->chan.device_node, &dw->dma.channels);
 
 		dwc->ch_regs = &__dw_regs(dw)->CHAN[i];
 		spin_lock_init(&dwc->lock);
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index c8aad71..b1ab0b9 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -19,6 +19,9 @@
  */
 struct dw_dma_platform_data {
 	unsigned int	nr_channels;
+#define CHAN_PRIO_ASCENDING	0	/* zero to seven */
+#define CHAN_PRIO_DESCENDING	1	/* seven to zero */
+	unsigned int	chan_priority;
 };
 
 /**
-- 
1.7.2.2

