Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab2IGJpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:45:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55833 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760249Ab2IGJpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:45:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] extcon: arizona: Use bypass mode for MICVDD
Date: Fri,  7 Sep 2012 17:44:51 +0800
Message-Id: <1347011091-32209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can perform microphone detection with MICVDD in bypass mode so try to
enable that during startup for minimal power - other users or machine
constraints will prevent bypass mode being activated if it is unsuitable.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This depends on the newly added regulator bypass support which will be
going in during the merge window so probably the easiest thing here is
if I apply this to the regulator tree?  I will be publishing a signed
tag if you want to pull it in but for a simple, non-invasive change like
this it seems like more trouble than it's worth.

 drivers/extcon/extcon-arizona.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index dc81d5f..cdab9e5 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -483,6 +483,11 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
 			   ARIZONA_JD1_ENA, ARIZONA_JD1_ENA);
 
+	ret = regulator_allow_bypass(info->micvdd, true);
+	if (ret != 0)
+		dev_warn(arizona->dev, "Failed to set MICVDD to bypass: %d\n",
+			 ret);
+
 	pm_runtime_put(&pdev->dev);
 
 	ret = input_register_device(info->input);
-- 
1.7.10.4

