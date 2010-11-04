Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0KDPLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:11:03 -0400
Received: from smtp.nokia.com ([147.243.128.24]:45990 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751661Ab0KDPK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:10:59 -0400
From: Heikki Krogerus <heikki.krogerus@nokia.com>
To: cbouatmailru@gmail.com
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com, heikki.krogerus@nokia.com
Subject: [PATCH 4/4] power_supply: isp1704: Detect charger after probe
Date: Thu,  4 Nov 2010 16:31:49 +0200
Message-Id: <1288881109-18222-5-git-send-email-heikki.krogerus@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
References: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device is booted up with cable connected, or the
module is loaded after plugging in the cable, the
notification has come and gone, so not relying on it at
probe time. Instead this checks the VBUS level manually
after probe.

Signed-off-by: Heikki Krogerus <heikki.krogerus@nokia.com>
---
 drivers/power/isp1704_charger.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 77c11f1..946e43c 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -422,6 +422,23 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
 
 	dev_info(isp->dev, "registered with product id %s\n", isp->model);
 
+	/*
+	 * Taking over the D+ pullup.
+	 *
+	 * FIXME: The device will be disconnected if the it was already
+	 * enumerated. The charger driver should be always loaded before any
+	 * gadget is loaded.
+	 */
+	if (isp->otg->gadget)
+		usb_gadget_disconnect(isp->otg->gadget);
+
+	/* Detect charger if VBUS is valid (the cable was already plugged). */
+	ret = otg_io_read(isp->otg, ULPI_USB_INT_STS);
+	if ((ret & ULPI_INT_VBUS_VALID) && !isp->otg->default_a) {
+		isp->event = USB_EVENT_VBUS;
+		schedule_work(&isp->work);
+	}
+
 	return 0;
 fail2:
 	power_supply_unregister(&isp->psy);
-- 
1.7.1

