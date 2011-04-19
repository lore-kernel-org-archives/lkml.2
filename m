Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1DSIcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:32:42 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:58667 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771Ab1DSIch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:32:37 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <linus.walleij@linaro.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 2/7] dmaengine/dw_dmac: Enable resubmission from callback routine.
Date: Tue, 19 Apr 2011 14:02:07 +0530
Message-ID: <1643d6236b00c03b39186c8789be7d75839c8d91.1303194835.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303194835.git.viresh.kumar@st.com>
References: <cover.1303194835.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmission of new transfer must be allowed from callbacks. For this release
lock before calling callback routine and enable them again.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c4040dd..66d7f1b 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -197,8 +197,8 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 static void
 dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 {
-	dma_async_tx_callback		callback;
-	void				*param;
+	dma_async_tx_callback		callback = NULL;
+	void				*param = NULL;
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 	struct dw_desc			*child;
 
@@ -238,12 +238,10 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 		}
 	}
 
-	/*
-	 * The API requires that no submissions are done from a
-	 * callback, so we don't need to drop the lock here
-	 */
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 	if (callback)
 		callback(param);
+	spin_lock_irqsave(&dwc->lock, dw->flags);
 }
 
 static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
-- 
1.7.2.2

