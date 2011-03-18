Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab1CRV76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:59:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8037 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874Ab1CRV7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:59:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80850565"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37045057"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/20] video: msm: Prevent framebuffer glitch during initialization
Date: Fri, 18 Mar 2011 14:59:34 -0700
Message-Id: <1300485574-27600-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holds a reference to the mdp_clk until lateinit, and moves the frambuffer
initialization to device_init.  The framebuffer lcdc driver will grab a
reference to mdp_clk, which prevents the clock from being disabled by
clock_late_init.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 0bb19fa..b3f334ad 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -38,6 +38,7 @@ struct class *mdp_class;
 
 static DECLARE_WAIT_QUEUE_HEAD(mdp_ppp_waitqueue);
 static unsigned int mdp_irq_mask;
+struct clk *mdp_clk_to_disable_later;
 DEFINE_MUTEX(mdp_mutex);
 
 static int locked_enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
@@ -670,6 +671,7 @@ int mdp_probe(struct platform_device *pdev)
 	disable_irq(mdp->irq);
 
 	clk_enable(mdp->clk);
+	mdp_clk_to_disable_later = mdp->clk;
 	mdp_hw_init(mdp);
 
 	/* register mdp device */
@@ -706,6 +708,13 @@ static struct platform_driver msm_mdp_driver = {
 	.driver = {.name = "msm_mdp"},
 };
 
+static int __init mdp_lateinit(void)
+{
+	if (mdp_clk_to_disable_later)
+		clk_disable(mdp_clk_to_disable_later);
+	return 0;
+}
+
 static int __init mdp_init(void)
 {
 	mdp_class = class_create(THIS_MODULE, "msm_mdp");
@@ -717,3 +726,4 @@ static int __init mdp_init(void)
 }
 
 subsys_initcall(mdp_init);
+late_initcall(mdp_lateinit);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

