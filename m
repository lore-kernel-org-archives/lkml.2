Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab2EJWve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:51:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10462 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2EJWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:51:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6707"; a="189716168"
From: Stephen Boyd <sboyd@codeaurora.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] ks8851: Update link status during link change interrupt
Date: Thu, 10 May 2012 15:51:30 -0700
Message-Id: <1336690290-21304-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.1.553.gb7fbce0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a link change interrupt comes in we just clear the interrupt
and continue along without notifying the upper networking layers
that the link has changed. Use the mii_check_link() function to
update the link status whenever a link change interrupt occurs.

Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/net/ethernet/micrel/ks8851.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index f8dda00..5e313e9 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -618,10 +618,8 @@ static void ks8851_irq_work(struct work_struct *work)
 	netif_dbg(ks, intr, ks->netdev,
 		  "%s: status 0x%04x\n", __func__, status);
 
-	if (status & IRQ_LCI) {
-		/* should do something about checking link status */
+	if (status & IRQ_LCI)
 		handled |= IRQ_LCI;
-	}
 
 	if (status & IRQ_LDI) {
 		u16 pmecr = ks8851_rdreg16(ks, KS_PMECR);
@@ -684,6 +682,9 @@ static void ks8851_irq_work(struct work_struct *work)
 
 	mutex_unlock(&ks->lock);
 
+	if (status & IRQ_LCI)
+		mii_check_link(&ks->mii);
+
 	if (status & IRQ_TXI)
 		netif_wake_queue(ks->netdev);
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

