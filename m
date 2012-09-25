Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2IYQO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:14:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081Ab2IYQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:21 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 54/57] power: ab8500_charger: Use USBLink1Status Register
Date: Tue, 25 Sep 2012 10:12:51 -0600
Message-Id: <1348589574-25655-55-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

The newer AB's such as the AB8505, AB9540 etc include a
USBLink1 Status register which detects a larger range of
external devices. This should be used instead of the
USBLine Status register.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Yang QU <yang.qu@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 3a97012..7f8f362 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2258,8 +2258,13 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	 * to start the charging process. but by jumping
 	 * thru a few hoops it can be forced to start.
 	 */
-	ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
-			AB8500_USB_LINE_STAT_REG, &val);
+	if (is_ab8500(di->parent))
+		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
+					AB8500_USB_LINE_STAT_REG, &val);
+	else
+		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
+					AB8500_USB_LINK1_STAT_REG, &val);
+
 	if (ret >= 0)
 		dev_dbg(di->dev, "UsbLineStatus register = 0x%02x\n", val);
 	else
@@ -2299,10 +2304,15 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 						AB8500_MCH_IPT_CURLVL_REG,
 						0x01, 0x00);
 			/*Check link status*/
-			ret = abx500_get_register_interruptible(di->dev,
-						AB8500_USB,
-						AB8500_USB_LINE_STAT_REG,
-						&val);
+			if (is_ab8500(di->parent))
+				ret = abx500_get_register_interruptible(di->dev,
+					AB8500_USB, AB8500_USB_LINE_STAT_REG,
+					&val);
+			else
+				ret = abx500_get_register_interruptible(di->dev,
+					AB8500_USB, AB8500_USB_LINK1_STAT_REG,
+					&val);
+
 			dev_dbg(di->dev, "USB link status= 0x%02x\n",
 				(val & link_status) >> USB_LINK_STATUS_SHIFT);
 			di->invalid_charger_detect_state = 2;
-- 
1.7.5.4

