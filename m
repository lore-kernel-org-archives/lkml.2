Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1GYVUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:20:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34671 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752769Ab1GYVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:20:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/6] regulator: Bootstrap wm831x DVS VSEL value from ON VSEL if not already set
Date: Mon, 25 Jul 2011 22:20:33 +0100
Message-Id: <1311628834-31939-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't have a DVS VSEL value already set when we start up then start
it off with the value currently being used for ON.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 95249f7..2c5d54b 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -491,6 +491,20 @@ static __devinit void wm831x_buckv_dvs_init(struct wm831x_dcdc *dcdc,
 		return;
 	}
 
+	/* If DVS_VSEL is set to the minimum value then raise it to ON_VSEL
+	 * to make bootstrapping a bit smoother.
+	 */
+	if (!dcdc->dvs_vsel) {
+		ret = wm831x_set_bits(wm831x,
+				      dcdc->base + WM831X_DCDC_DVS_CONTROL,
+				      WM831X_DC1_DVS_VSEL_MASK, dcdc->on_vsel);
+		if (ret == 0)
+			dcdc->dvs_vsel = dcdc->on_vsel;
+		else
+			dev_warn(wm831x->dev, "Failed to set DVS_VSEL: %d\n",
+				 ret);
+	}
+
 	ret = wm831x_set_bits(wm831x, dcdc->base + WM831X_DCDC_DVS_CONTROL,
 			      WM831X_DC1_DVS_SRC_MASK, ctrl);
 	if (ret < 0) {
-- 
1.7.5.4

