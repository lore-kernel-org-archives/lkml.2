Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2BNRuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:50:46 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19907 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2BNRuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:50:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 14 Feb 2012 09:50:44 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: Make "hog" mapping table entries work
Date: Tue, 14 Feb 2012 10:50:41 -0700
Message-Id: <1329241841-21357-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 77a5988 "pinctrl: changes hog mechanism to be self-referential"
modified the way "hog" entries were represented in the mapping table.
However, the new representation failed some error checks in
pinctrl_hog_map(). Remove the now-bogus error-check, and fix the code
to solve the issue the error-check used to avoid.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index c5f76ad..8a91eb2 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -725,23 +725,11 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
 	struct pinctrl *p;
 	int ret;
 
-	if (map->dev_name) {
-		/*
-		 * TODO: the day we have device tree support, we can
-		 * traverse the device tree and hog to specific device nodes
-		 * without any problems, so then we can hog pinmuxes for
-		 * all devices that just want a static pin mux at this point.
-		 */
-		dev_err(pctldev->dev, "map %s wants to hog a non-system pinmux, this is not going to work\n",
-				map->name);
-		return -EINVAL;
-	}
-
 	hog = kzalloc(sizeof(struct pinctrl_hog), GFP_KERNEL);
 	if (!hog)
 		return -ENOMEM;
 
-	p = pinctrl_get(NULL, map->name);
+	p = pinctrl_get(pctldev->dev, map->name);
 	if (IS_ERR(p)) {
 		kfree(hog);
 		dev_err(pctldev->dev,
-- 
1.7.0.4

