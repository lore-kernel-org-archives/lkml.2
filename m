Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2F2Nzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:55:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55999 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab2F2Nzn (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Fri, 29 Jun 2012 09:55:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: wm8994: Also restore GPIO IRQ masks after reset
Date: Fri, 29 Jun 2012 14:55:40 +0100
Message-Id: <1340978140-11572-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340978140-11572-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340978140-11572-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures that if we are using a GPIO as a wake source it continues to
function while we're suspended.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 53293c7..eec74aa 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -293,6 +293,13 @@ static int wm8994_suspend(struct device *dev)
 	if (ret != 0)
 		dev_err(dev, "Failed to restore GPIO registers: %d\n", ret);
 
+	/* In case one of the GPIOs is used as a wake input. */
+	ret = regcache_sync_region(wm8994->regmap,
+				   WM8994_INTERRUPT_STATUS_1_MASK,
+				   WM8994_INTERRUPT_STATUS_1_MASK);
+	if (ret != 0)
+		dev_err(dev, "Failed to restore interrupt mask: %d\n", ret);
+
 	regcache_cache_only(wm8994->regmap, true);
 	wm8994->suspended = true;
 
-- 
1.7.10

