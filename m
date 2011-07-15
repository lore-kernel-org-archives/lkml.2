Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1GOLer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 07:34:47 -0400
Received: from isc-mx.mymailwall.com ([91.212.136.3]:56142 "EHLO
	mx.mymailwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750980Ab1GOLeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 07:34:46 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jul 2011 07:34:46 EDT
X-MyMailWallStatus: Email scanned(37957944)
From: Michael Thalmeier <Michael.Thalmeier@sigmatek.at>
To: Florian Fainelli <florian@openwrt.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, michael@thalmeier.at,
        Michael Thalmeier <Michael.Thalmeier@sigmatek.at>
Subject: [PATCH 1/1] r6040: only disable RX interrupt if napi_schedule_prep is successful
Date: Fri, 15 Jul 2011 13:28:26 +0200
Message-Id: <1310729306-12190-1-git-send-email-Michael.Thalmeier@sigmatek.at>
X-Mailer: git-send-email 1.7.1
Reply-To: Michael.Thalmeier@sigmatek.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When receiving the first RX interrupt before the internal call
to napi_schedule_prep is successful the RX interrupt gets disabled
and is never enabled again as the poll function never gets executed.

Signed-off-by: Michael Thalmeier <Michael.Thalmeier@sigmatek.at>
---
 drivers/net/r6040.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
index 200a363..0ffec46 100644
--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -677,9 +677,11 @@ static irqreturn_t r6040_interrupt(int irq, void *dev_id)
 		if (status & RX_FIFO_FULL)
 			dev->stats.rx_fifo_errors++;
 
-		/* Mask off RX interrupt */
-		misr &= ~RX_INTS;
-		napi_schedule(&lp->napi);
+		if (likely(napi_schedule_prep(&lp->napi))) {
+			/* Mask off RX interrupt */
+			misr &= ~RX_INTS;
+			__napi_schedule(&lp->napi);
+		}
 	}
 
 	/* TX interrupt request */
-- 
1.7.1

