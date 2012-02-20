Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2BTGsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:48:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19436 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2BTGrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 19 Feb 2012 22:46:20 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 17/20] pinctrl: Add usecount to pins for muxing
Date: Sun, 19 Feb 2012 23:45:57 -0700
Message-Id: <1329720360-23227-18-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple mapping table entries could reference the same pin, and hence
"own" it. This would be unusual now that pinctrl_get() represents a single
state for a client device, but in the future when it represents all known
states for a device, this is quite likely. Implement reference counting
for pin ownership to handle this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.h   |    1 +
 drivers/pinctrl/pinmux.c |   29 ++++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 1290995..64ae1b8 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -92,6 +92,7 @@ struct pin_desc {
 	bool dynamic_name;
 	/* These fields only added when supporting pinmux drivers */
 #ifdef CONFIG_PINMUX
+	unsigned usecount;
 	const char *owner;
 #endif
 };
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 8d32380..359f6ac 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -83,11 +83,16 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 
-	if (desc->owner && strcmp(desc->owner, owner)) {
+	if (desc->usecount && strcmp(desc->owner, owner)) {
 		dev_err(pctldev->dev,
 			"pin already requested\n");
 		goto out;
 	}
+
+	desc->usecount++;
+	if (desc->usecount > 1)
+		return 0;
+
 	desc->owner = owner;
 
 	/* Let each pin increase references to this module */
@@ -100,9 +105,9 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	}
 
 	/*
-	 * If there is no kind of request function for the pin we just assume
-	 * we got it by default and proceed.
-	 */
+	* If there is no kind of request function for the pin we just assume
+	* we got it by default and proceed.
+	*/
 	if (gpio_range && ops->gpio_request_enable)
 		/* This requests and enables a single GPIO pin */
 		status = ops->gpio_request_enable(pctldev, gpio_range, pin);
@@ -111,12 +116,18 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	else
 		status = 0;
 
-	if (status)
+	if (status) {
 		dev_err(pctldev->dev, "->request on device %s failed for pin %d\n",
 		       pctldev->desc->name, pin);
+		module_put(pctldev->owner);
+	}
+
 out_free_pin:
-	if (status)
-		desc->owner = NULL;
+	if (status) {
+		desc->usecount--;
+		if (!desc->usecount)
+			desc->owner = NULL;
+	}
 out:
 	if (status)
 		dev_err(pctldev->dev, "pin-%d (%s) status %d\n",
@@ -150,6 +161,10 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 		return NULL;
 	}
 
+	desc->usecount--;
+	if (desc->usecount)
+		return NULL;
+
 	/*
 	 * If there is no kind of request function for the pin we just assume
 	 * we got it by default and proceed.
-- 
1.7.5.4

