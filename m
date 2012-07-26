Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab2GZJXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:23:52 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:60179 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab2GZJXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:23:51 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2012 05:23:51 EDT
From: Hauke Mehrtens <hauke@hauke-m.de>
To: torvalds@linux-foundation.org
Cc: linville@tuxdriver.com, davem@davemloft.net,
        brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.forshee@canonical.com, pieterpg@broadcom.com,
        brudley@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>,
        Arend van Spriel <arend@broadcom.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: fix regression in pmu workaround reg masks
Date: Thu, 26 Jul 2012 11:15:51 +0200
Message-Id: <1343294151-5691-1-git-send-email-hauke@hauke-m.de>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression introduced in:
commit b9562545ef0b13c0440ccd8d6dd4111fb77cb17a
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Sat Jun 30 01:44:41 2012 +0200

    bcma: complete workaround for BCMA43224 and BCM4313

The regression broke reading of the sprom from the chip and seamed to
cause a change of the pci id on a BCMA43224 device so that it is
rejected by brcmsmac. If this problem occurred, after applying this
patch, a cold boot is needed to make the device work again.

In the original patch the workaround set the intended bits in the chip
common core chip control registers, but the patch also unset all the
other bits in that register, because of a wrong mask. The original
patch was based on code from brcmsmac and there was an additional
inversing of the mask in the code setting these regs which was missing
here. Now the regs are set like brcmsmac did it before.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_pmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 4432617..c9a4f46 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -110,7 +110,7 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 		/* enable 12 mA drive strenth for 4313 and set chipControl
 		   register bit 1 */
 		bcma_chipco_chipctl_maskset(cc, 0,
-					    BCMA_CCTRL_4313_12MA_LED_DRIVE,
+					    ~BCMA_CCTRL_4313_12MA_LED_DRIVE,
 					    BCMA_CCTRL_4313_12MA_LED_DRIVE);
 		break;
 	case BCMA_CHIP_ID_BCM4331:
@@ -124,14 +124,14 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 		   register bit 15 */
 		if (bus->chipinfo.rev == 0) {
 			bcma_cc_maskset32(cc, BCMA_CC_CHIPCTL,
-					  BCMA_CCTRL_43224_GPIO_TOGGLE,
+					  ~BCMA_CCTRL_43224_GPIO_TOGGLE,
 					  BCMA_CCTRL_43224_GPIO_TOGGLE);
 			bcma_chipco_chipctl_maskset(cc, 0,
-						    BCMA_CCTRL_43224A0_12MA_LED_DRIVE,
+						    ~BCMA_CCTRL_43224A0_12MA_LED_DRIVE,
 						    BCMA_CCTRL_43224A0_12MA_LED_DRIVE);
 		} else {
 			bcma_chipco_chipctl_maskset(cc, 0,
-						    BCMA_CCTRL_43224B0_12MA_LED_DRIVE,
+						    ~BCMA_CCTRL_43224B0_12MA_LED_DRIVE,
 						    BCMA_CCTRL_43224B0_12MA_LED_DRIVE);
 		}
 		break;
-- 
1.7.9.5

