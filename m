Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1B1Kmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:42:52 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:56701 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab1B1Kmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:42:49 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Viresh Kumar <viresh.kumar@st.com>, <shiraz.hashim@st.com>,
        <amit.goel@st.com>, <armando.visconti@st.com>
Subject: [PATCH 7/8 resend] dw_dmac.c: Pass Channel Allocation Order from platform_data
Date: Mon, 28 Feb 2011 16:11:22 +0530
Message-ID: <ffc35e090243231bf0b3808f2b722c69be2ce36f.1298889267.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1298889267.git.viresh.kumar@st.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In SPEAr Platform channels 4-7 have more Fifo depth. So we must get better
channel first. This patch introduces concept of channel allocation order in
dw_dmac. If user doesn't paas anything or 0, than normal (ascending) channel
allocation will follow, else channels will be allocated in descending order.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c   |    6 +++++-
 include/linux/dw_dmac.h |    3 +++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 01f783d..37ffd2c 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1314,7 +1314,11 @@ static int __init dw_probe(struct platform_device *pdev)
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
index c8aad71..057e883 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -19,6 +19,9 @@
  */
 struct dw_dma_platform_data {
 	unsigned int	nr_channels;
+#define CHAN_ALLOCATION_ASCENDING	0	/* zero to seven */
+#define CHAN_ALLOCATION_DESCENDING	1	/* seven to zero */
+	unsigned int	chan_allocation_order;
 };
 
 /**
-- 
1.7.2.2

