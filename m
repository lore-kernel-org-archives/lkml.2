Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2BTVdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:33:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50043 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871Ab2BTVc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:32:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        stable@vger.kernel.org
Subject: [PATCH 3.3] mfd: Test for jack detection when deciding if wm8994 should suspend
Date: Mon, 20 Feb 2012 21:32:32 +0000
Message-Id: <1329773552-22271-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The jack detection on WM1811 is often required during system suspend, add
it as another check when deciding if we should suspend.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org
---

Samuel, could you please add this to your for-linus branch?  It's been
sitting around unloved for some considerable time now...

 drivers/mfd/wm8994-core.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index f117e7f..a04b3c1 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -256,6 +256,20 @@ static int wm8994_suspend(struct device *dev)
 		break;
 	}
 
+	switch (wm8994->type) {
+	case WM1811:
+		ret = wm8994_reg_read(wm8994, WM8994_ANTIPOP_2);
+		if (ret < 0) {
+			dev_err(dev, "Failed to read jackdet: %d\n", ret);
+		} else if (ret & WM1811_JACKDET_MODE_MASK) {
+			dev_dbg(dev, "CODEC still active, ignoring suspend\n");
+			return 0;
+		}
+		break;
+	default:
+		break;
+	}
+
 	/* Disable LDO pulldowns while the device is suspended if we
 	 * don't know that something will be driving them. */
 	if (!wm8994->ldo_ena_always_driven)
-- 
1.7.9

