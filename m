Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2BTGtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:49:43 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19407 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2BTGrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 19 Feb 2012 22:46:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 11/20] pinctrl: Downgrade pinctrl_get warning when no maps are found
Date: Sun, 19 Feb 2012 23:45:51 -0700
Message-Id: <1329720360-23227-12-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may be perfectly legitimate. An IP block may get re-used
across SoCs. Not all of those SoCs may need pinmux settings for the
IP block, e.g. if one SoC dedicates pins to that function but
another doesn't. The driver won't know this, and will always
attempt to set up the pinmux. The mapping table defines whether any
HW programming is actually needed.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 37dfac7..54e24f7 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -542,13 +542,16 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		num_maps++;
 	}
 
-	/* We should have atleast one map, right */
-	if (!num_maps) {
-		pr_err("could not find any mux maps for device %s, ID %s\n",
-		       devname, name);
-		kfree(p);
-		return ERR_PTR(-EINVAL);
-	}
+	/*
+	 * This may be perfectly legitimate. An IP block may get re-used
+	 * across SoCs. Not all of those SoCs may need pinmux settings for the
+	 * IP block, e.g. if one SoC dedicates pins to that function but
+	 * another doesn't. The driver won't know this, and will always
+	 * attempt to set up the pinmux. The mapping table defines whether any
+	 * HW programming is actually needed.
+	 */
+	if (!num_maps)
+		dev_info(dev, "zero maps found for state %s\n", name);
 
 	pr_debug("found %u mux maps for device %s, UD %s\n",
 		 num_maps, devname, name);
-- 
1.7.5.4

