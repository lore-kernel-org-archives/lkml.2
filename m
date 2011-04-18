Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1DRKvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:51:11 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:43055 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab1DRKuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:50:46 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <jamie@jamieiles.com>, <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 3/6] dmaengine/dw_dmac: call dwc_descriptor_complete from dwc_control with lock held
Date: Mon, 18 Apr 2011 16:20:01 +0530
Message-ID: <66b3083da689c5e76d7322ca9f117d631fda08af.1303123511.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dwc_descriptor_complete must always be called with channel lock held. This patch
moves unlock code, in dwc_control(), untill after dwc_descriptor_complete is
called.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 69a9c9d..b49d7f3 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -830,12 +830,12 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	list_splice_init(&dwc->queue, &list);
 	list_splice_init(&dwc->active_list, &list);
 
-	spin_unlock_irqrestore(&dwc->lock, dw->flags);
-
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		dwc_descriptor_complete(dwc, desc);
 
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
+
 	return 0;
 }
 
-- 
1.7.2.2

