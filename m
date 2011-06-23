Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab1FWVBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:01:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50781 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822Ab1FWVBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fQtYO9P+ZCuiKl3Gb4bof748m4xPgXViwtWYrJ1sYBDmAiilT5wSRmtCpVBbT65ZlA
         MYsU6O2dFYa1OqwWXNH7J3SlbHIpIPnVLHRwt+uTXSUwXuhYH+8fpE/KUhN/5zBeKSm+
         gS4XTkDReFfmIQA/tBWf2SYMIPj8y4W3jdEZ8=
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ti@lists.linaro.org, Keshava_mgowda@ti.com, parthab@india.ti.com,
        sameo@linux.intel.com, gadiyar@ti.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH] mfd: omap: Restore TLL initialization
Date: Fri, 24 Jun 2011 02:31:34 +0530
Message-Id: <1308862894-13802-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit
  7e6502d577106fb5b202bbaac64c5f1b065 'mfd: Add omap-usbhs runtime PM support'
besides moving to RPM, removes necessary TLL initialization as well.

Restore the TLL initialization, without which device detection fails.

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/mfd/omap-usb-host.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 8552195..12ca77b 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -640,6 +640,7 @@ static int usbhs_enable(struct device *dev)
 	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
 	unsigned long			flags = 0;
 	int				ret = 0;
+	unsigned long			timeout;
 	unsigned			reg;
 
 	dev_dbg(dev, "starting TI HSUSB Controller\n");
@@ -676,6 +677,47 @@ static int usbhs_enable(struct device *dev)
 	omap->usbhs_rev = usbhs_read(omap->uhh_base, OMAP_UHH_REVISION);
 	dev_dbg(dev, "OMAP UHH_REVISION 0x%x\n", omap->usbhs_rev);
 
+	/* perform TLL soft reset, and wait until reset is complete */
+	usbhs_write(omap->tll_base, OMAP_USBTLL_SYSCONFIG,
+			OMAP_USBTLL_SYSCONFIG_SOFTRESET);
+
+	/* Wait for TLL reset to complete */
+	timeout = jiffies + msecs_to_jiffies(1000);
+	while (!(usbhs_read(omap->tll_base, OMAP_USBTLL_SYSSTATUS)
+			& OMAP_USBTLL_SYSSTATUS_RESETDONE)) {
+		cpu_relax();
+
+		if (time_after(jiffies, timeout)) {
+			dev_dbg(dev, "operation timed out\n");
+			ret = -EINVAL;
+			goto err_tll;
+		}
+	}
+	dev_dbg(dev, "TLL RESET DONE\n");
+
+	/* (1<<3) = no idle mode only for initial debugging */
+	usbhs_write(omap->tll_base, OMAP_USBTLL_SYSCONFIG,
+			OMAP_USBTLL_SYSCONFIG_ENAWAKEUP |
+			OMAP_USBTLL_SYSCONFIG_SIDLEMODE |
+			OMAP_USBTLL_SYSCONFIG_AUTOIDLE);
+
+	/* Put UHH in NoIdle/NoStandby mode */
+	reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
+	if (is_omap_usbhs_rev1(omap)) {
+		reg |= (OMAP_UHH_SYSCONFIG_ENAWAKEUP
+				| OMAP_UHH_SYSCONFIG_SIDLEMODE
+				| OMAP_UHH_SYSCONFIG_CACTIVITY
+				| OMAP_UHH_SYSCONFIG_MIDLEMODE);
+		reg &= ~OMAP_UHH_SYSCONFIG_AUTOIDLE;
+	} else if (is_omap_usbhs_rev2(omap)) {
+		reg &= ~OMAP4_UHH_SYSCONFIG_IDLEMODE_CLEAR;
+		reg |= OMAP4_UHH_SYSCONFIG_NOIDLE;
+		reg &= ~OMAP4_UHH_SYSCONFIG_STDBYMODE_CLEAR;
+		reg |= OMAP4_UHH_SYSCONFIG_NOSTDBY;
+	}
+
+	usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG, reg);
+
 	reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
 	/* setup ULPI bypass and burst configurations */
 	reg |= (OMAP_UHH_HOSTCONFIG_INCR4_BURST_EN
-- 
1.7.4.1

