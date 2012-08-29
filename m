Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2H2Jt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 05:49:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:45110 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2H2JtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 05:49:25 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <stern@rowland.harvard.edu>, <linux-usb@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <gregkh@linuxfoundation.org>,
        <klaus.falkner@solectrix.de>, <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] USB: ohci-at91: fix PIO handling in relation with number of ports
Date: Wed, 29 Aug 2012 11:49:18 +0200
Message-ID: <1346233758-27009-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the number of ports present on the SoC/board is not the maximum
and that the platform data is not filled with all data, there is
an easy way to mess the PIO setup for this interface.
This quick fix addresses mis-configuration in USB host platform data
that is common in at91 boards since commit 0ee6d1e (USB: ohci-at91:
change maximum number of ports) that did not modified the associatd
board files.

Reported-by: Klaus Falkner <klaus.falkner@solectrix.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Stable <stable@vger.kernel.org> [3.4+]
---
 drivers/usb/host/ohci-at91.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index a665b3e..aaa8d2b 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -570,6 +570,16 @@ static int __devinit ohci_hcd_at91_drv_probe(struct platform_device *pdev)
 
 	if (pdata) {
 		at91_for_each_port(i) {
+			/*
+			 * do not configure PIO if not in relation with
+			 * real USB port on board
+			 */
+			if (i >= pdata->ports) {
+				pdata->vbus_pin[i] = -EINVAL;
+				pdata->overcurrent_pin[i] = -EINVAL;
+				break;
+			}
+
 			if (!gpio_is_valid(pdata->vbus_pin[i]))
 				continue;
 			gpio = pdata->vbus_pin[i];
-- 
1.7.10

