Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab2EAROY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:14:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35573 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab2EAROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:14:23 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: add more info to error msgs in pin_request
Date: Tue,  1 May 2012 11:14:15 -0600
Message-Id: <1335892455-10155-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Additionally print which pin the request failed for, which entity already
claimed it, and what entity was trying to claim it.

Remove duplicate device name from a debug message.

Clean up some indentation.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinmux.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 2df7535..220fa49 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -92,7 +92,8 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
 		dev_err(pctldev->dev,
-			"pin is not registered so it cannot be requested\n");
+			"pin %d is not registered so it cannot be requested\n",
+			pin);
 		goto out;
 	}
 
@@ -103,7 +104,8 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		/* There's no need to support multiple GPIO requests */
 		if (desc->gpio_owner) {
 			dev_err(pctldev->dev,
-				"pin already requested\n");
+				"pin %s already requested by %s; cannot claim for %s\n",
+				desc->name, desc->gpio_owner, owner);
 			goto out;
 		}
 
@@ -111,7 +113,8 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	} else {
 		if (desc->mux_usecount && strcmp(desc->mux_owner, owner)) {
 			dev_err(pctldev->dev,
-				"pin already requested\n");
+				"pin %s already requested by %s; cannot claim for %s\n",
+				desc->name, desc->mux_owner, owner);
 			goto out;
 		}
 
@@ -144,8 +147,7 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		status = 0;
 
 	if (status) {
-		dev_err(pctldev->dev, "request on device %s failed for pin %d\n",
-		       pctldev->desc->name, pin);
+		dev_err(pctldev->dev, "request() failed for pin %d\n", pin);
 		module_put(pctldev->owner);
 	}
 
@@ -162,7 +164,7 @@ out_free_pin:
 out:
 	if (status)
 		dev_err(pctldev->dev, "pin-%d (%s) status %d\n",
-		       pin, owner, status);
+			pin, owner, status);
 
 	return status;
 }
-- 
1.7.0.4

