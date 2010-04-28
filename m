Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab0D1K3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 06:29:51 -0400
Received: from mail.atmel.fr ([81.80.104.162]:63408 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab0D1K3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 06:29:50 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-usb@vger.kernel.org, avictor.za@gmail.com, david-b@pacbell.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Patrice Vilchez <patrice.vilchez@atmel.com>
Subject: [PATCH] USB: ohci-at91: fix power management hanging
Date: Wed, 28 Apr 2010 13:45:40 +0200
Message-Id: <1272455140-32686-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Vilchez <patrice.vilchez@atmel.com>

A hanging has been detected in ohci-at91 while going in suspend to ram. This is
due to asynchronous operations between ohci reset and ohci clocks shutdown.
This patch adds the reading of the control register between the reset of the
ohci and clocks stop. This "flush the writes" idea was taken from ohci-hcd.c
file (ohci_shutdown() function).

Signed-off-by: Patrice Vilchez <patrice.vilchez@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
This patch has been tested on at91sam9g10 and is working ok.

 drivers/usb/host/ohci-at91.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 68b83ab..944291e 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -331,6 +331,8 @@ ohci_hcd_at91_drv_suspend(struct platform_device *pdev, pm_message_t mesg)
 	 */
 	if (at91_suspend_entering_slow_clock()) {
 		ohci_usb_reset (ohci);
+		/* flush the writes */
+		(void) ohci_readl (ohci, &ohci->regs->control);
 		at91_stop_clock();
 	}
 
-- 
1.5.6.5

