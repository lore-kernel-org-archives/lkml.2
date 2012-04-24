Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2DXUoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:44:12 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37021 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab2DXUoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:44:11 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] rtc: Fix possible null pointer dereference in rtc-mpc5121.c
Date: Tue, 24 Apr 2012 13:43:35 -0700
Message-Id: <1335300215-21427-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042420-6148-0000-0000-0000054A76EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	This is against tip/timers/urgent for 3.4
thanks
-john

Mark Loard pointed out:
"For example, this beauty from rtc-mpc5121.c in the same update:
   ...
   rtc->rtc = rtc_device_register("mpc5200-rtc", &op->dev,
                                   &mpc5200_rtc_ops, THIS_MODULE);
   ...

   rtc->rtc->uie_unsupported = 1;    // <<<< Ooops NULL pointer >>>>

   if (IS_ERR(rtc->rtc)) {           // <<<< this needs to be earlier >>>>
           err = PTR_ERR(rtc->rtc);
           goto out_free_irq;
   }
   ..."
This patch moves setting the uie_unsupported flag to after
we validate the rtc->rtc pointer to resolve this.

CC: Thomas Gleixner <tglx@linutronix.de>
Reported by: Mark Lord <kernel@teksavvy.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-mpc5121.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 42f5f82..029e421 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -360,12 +360,11 @@ static int __devinit mpc5121_rtc_probe(struct platform_device *op)
 						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
-	rtc->rtc->uie_unsupported = 1;
-
 	if (IS_ERR(rtc->rtc)) {
 		err = PTR_ERR(rtc->rtc);
 		goto out_free_irq;
 	}
+	rtc->rtc->uie_unsupported = 1;
 
 	return 0;
 
-- 
1.7.3.2.146.gca209

