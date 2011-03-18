Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab1CRV6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:58:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17956 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab1CRV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:58:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80850392"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044939"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/20] video: msm: Add IRQ callback for MDP interface
Date: Fri, 18 Mar 2011 14:58:13 -0700
Message-Id: <1300485493-27399-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows interface client to setup notification for non-DMA irqs
(e.g. LCDC/TV-out frame start)

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c    |   41 +++++++++++++++++++++++++++++++++++++++++
 drivers/video/msm/mdp_hw.h |    9 +++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 15241b4..bdca2d9 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -130,6 +130,10 @@ static irqreturn_t mdp_isr(int irq, void *data)
 			}
 			wake_up(&out_if->dma_waitqueue);
 		}
+		if (status & out_if->irq_mask) {
+			out_if->irq_cb->func(out_if->irq_cb);
+			out_if->irq_cb = NULL;
+		}
 	}
 
 	if (status & DL0_ROI_DONE)
@@ -494,6 +498,43 @@ done:
 	return ret;
 }
 
+int mdp_out_if_req_irq(struct mdp_device *mdp_dev, int interface,
+		       uint32_t mask, struct msmfb_callback *cb)
+{
+	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+	unsigned long flags;
+	int ret = 0;
+
+	if (interface < 0 || interface >= MSM_MDP_NUM_INTERFACES) {
+		pr_err("%s: invalid interface (%d)\n", __func__, interface);
+		BUG();
+	} else if (!mdp->out_if[interface].registered) {
+		pr_err("%s: interface (%d) not registered\n", __func__,
+		       interface);
+		BUG();
+	}
+
+	spin_lock_irqsave(&mdp->lock, flags);
+
+	if (mask) {
+		ret = locked_enable_mdp_irq(mdp, mask);
+		if (ret) {
+			pr_err("%s: busy\n", __func__);
+			goto done;
+		}
+		mdp->out_if[interface].irq_mask = mask;
+		mdp->out_if[interface].irq_cb = cb;
+	} else {
+		locked_disable_mdp_irq(mdp, mask);
+		mdp->out_if[interface].irq_mask = 0;
+		mdp->out_if[interface].irq_cb = NULL;
+	}
+
+done:
+	spin_unlock_irqrestore(&mdp->lock, flags);
+	return ret;
+}
+
 int register_mdp_client(struct class_interface *cint)
 {
 	if (!mdp_class) {
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index cc48218..acb48f5 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -33,6 +33,11 @@ struct mdp_out_interface {
 
 	struct msmfb_callback	*dma_cb;
 	wait_queue_head_t	dma_waitqueue;
+
+	/* If the interface client wants to be notified of non-DMA irqs,
+	 * e.g. LCDC/TV-out frame start */
+	uint32_t		irq_mask;
+	struct msmfb_callback	*irq_cb;
 };
 
 struct mdp_info {
@@ -50,6 +55,10 @@ struct mdp_info {
 extern int mdp_out_if_register(struct mdp_device *mdp_dev, int interface,
 			       void *private_data, uint32_t dma_mask,
 			       mdp_dma_start_func_t dma_start);
+
+extern int mdp_out_if_req_irq(struct mdp_device *mdp_dev, int interface,
+			      uint32_t mask, struct msmfb_callback *cb);
+
 struct mdp_blit_req;
 struct mdp_device;
 int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

