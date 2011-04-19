Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1DSIcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:32:48 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:51033 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab1DSIch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:32:37 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <linus.walleij@linaro.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 3/7] dmaengine/dw_dmac: call dwc_descriptor_complete from dwc_control with lock held
Date: Tue, 19 Apr 2011 14:02:08 +0530
Message-ID: <c19b6c33e8a04b652e78252fa96021bcd39047e4.1303194835.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303194835.git.viresh.kumar@st.com>
References: <cover.1303194835.git.viresh.kumar@st.com>
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
index 66d7f1b..c211460 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -825,12 +825,12 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	list_splice_init(&dwc->queue, &list);
 	list_splice_init(&dwc->active_list, &list);
 
-	spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
-
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		dwc_descriptor_complete(dwc, desc);
 
+	spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
+
 	return 0;
 }
 
-- 
1.7.2.2

