Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1DZFjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:39:48 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49589 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259Ab1DZFi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:38:29 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 resend 2/7] dmaengine/dw_dmac: Enable resubmission from callback routine.
Date: Tue, 26 Apr 2011 11:08:10 +0530
Message-ID: <80d88f1c48496acbb6caa9628ec2854c3a44effc.1303796005.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303796005.git.viresh.kumar@st.com>
References: <cover.1303796005.git.viresh.kumar@st.com>
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
index 4f4df9f..dbe8203 100644
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

