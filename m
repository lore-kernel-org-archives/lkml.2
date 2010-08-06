Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943Ab0HFCHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:07:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12363 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580Ab0HFCHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:07:40 -0400
Date: Fri, 06 Aug 2010 11:07:26 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH] regulator: Fix WM8994 LDO enable gpio set when probed
To: lrg@slimlogic.co.uk
Cc: broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Message-id: <1281060446-399-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 06 Aug 2010 02:07:39.0341 (UTC)
 FILETIME=[25646FD0:01CB350C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The enable time needs to enable WM8994 LDO, but WM8994 LDO is enabled
without the enable time at the probe function. This can cause the
problem to try i2c operation before LDO is enabled.

This patch sets to 0 WM8994 LDO enable gpio when probed then if it is
requested to enable WM8994 LDO, will be enabled by enable interface of
regulator core with enable time.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/regulator/wm8994-regulator.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 5a1dc8a..03713bc 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -219,8 +219,6 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 
 	ldo->wm8994 = wm8994;
 
-	ldo->is_enabled = true;
-
 	if (pdata->ldo[id].enable && gpio_is_valid(pdata->ldo[id].enable)) {
 		ldo->enable = pdata->ldo[id].enable;
 
@@ -237,7 +235,8 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 				ret);
 			goto err_gpio;
 		}
-	}
+	} else
+		ldo->is_enabled = true;
 
 	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &pdev->dev,
 					     pdata->ldo[id].init_data, ldo);
-- 
1.7.0.4

