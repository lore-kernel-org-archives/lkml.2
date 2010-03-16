Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab0CPUc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:32:27 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:59473 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab0CPUcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:32:25 -0400
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 16:32:25 EDT
From: Kevin Hilman <khilman@deeprootsystems.com>
To: rtc-linux@googlegroups.com
Cc: Sekhar Nori <nsekhar@ti.com>, Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: omap: let device wakeup capability be configured from chip init logic
Date: Tue, 16 Mar 2010 13:20:54 -0700
Message-Id: <1268770854-5530-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sekhar Nori <nsekhar@ti.com>

The rtc-omap driver currently hardcodes the RTC wakeup capability
to be "not capable". While this seems to be true for existing OMAP1
boards which are not wired for this, the DA850/OMAP-L138 SoC, the
RTC can always be wake up source from its "deep sleep" mode.

This patch lets the wakeup capability to be set from platform data and
does not override the setting from the driver. For DA850/OMAP-L138, this
is done from arch/arm/mach-davinci/devices-da8xx.c:da8xx_register_rtc()

Note that this patch does not change the behavior on any existing OMAP1
board since the platform device registration sets the wakeup capability
to 0 by default.

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---

Alessandro, with your ack, I can merge this one as well via the davinci 
tree.

 drivers/rtc/rtc-omap.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 64d9727..73377b0 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -34,7 +34,8 @@
  * Board-specific wiring options include using split power mode with
  * RTC_OFF_NOFF used as the reset signal (so the RTC won't be reset),
  * and wiring RTC_WAKE_INT (so the RTC alarm can wake the system from
- * low power modes).  See the BOARD-SPECIFIC CUSTOMIZATION comment.
+ * low power modes) for OMAP1 boards (OMAP-L138 has this built into
+ * the SoC). See the BOARD-SPECIFIC CUSTOMIZATION comment.
  */
 
 #define OMAP_RTC_BASE			0xfffb4800
@@ -401,16 +402,17 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 
 	/* BOARD-SPECIFIC CUSTOMIZATION CAN GO HERE:
 	 *
-	 *  - Boards wired so that RTC_WAKE_INT does something, and muxed
-	 *    right (W13_1610_RTC_WAKE_INT is the default after chip reset),
-	 *    should initialize the device wakeup flag appropriately.
+	 *  - Device wake-up capability setting should come through chip
+	 *    init logic. OMAP1 boards should initialize the "wakeup capable"
+	 *    flag in the platform device if the board is wired right for
+	 *    being woken up by RTC alarm. For OMAP-L138, this capability
+	 *    is built into the SoC by the "Deep Sleep" capability.
 	 *
 	 *  - Boards wired so RTC_ON_nOFF is used as the reset signal,
 	 *    rather than nPWRON_RESET, should forcibly enable split
 	 *    power mode.  (Some chip errata report that RTC_CTRL_SPLIT
 	 *    is write-only, and always reads as zero...)
 	 */
-	device_init_wakeup(&pdev->dev, 0);
 
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
-- 
1.7.0.2

