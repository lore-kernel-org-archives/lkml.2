Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab1BUSah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 13:30:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54009 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751968Ab1BUSad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 13:30:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Put WM8994 into reset when suspending
Date: Mon, 21 Feb 2011 18:30:31 +0000
Message-Id: <1298313031-5132-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the chip is in the lowest power mode possible when suspended
by performing a soft reset on it. On early silicon revisions the lowest
power modes can't be entered without using reset so we can't achieve
equivalent results within the individual drivers.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index f4016a0..e673bda2 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -271,6 +271,11 @@ static int wm8994_suspend(struct device *dev)
 	if (ret < 0)
 		dev_err(dev, "Failed to save LDO registers: %d\n", ret);
 
+	/* Explicitly put the device into reset in case regulators
+	 * don't get disabled in order to ensure consistent restart.
+	 */
+	wm8994_reg_write(wm8994, WM8994_SOFTWARE_RESET, 0x8994);
+
 	wm8994->suspended = true;
 
 	ret = regulator_bulk_disable(wm8994->num_supplies,
-- 
1.7.2.3

