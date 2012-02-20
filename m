Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2BTGta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:49:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19408 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2BTGrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 19 Feb 2012 22:46:17 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 14/20] pinctrl: Allocate sizeof(*p) instead of sizeof(struct foo)
Date: Sun, 19 Feb 2012 23:45:54 -0700
Message-Id: <1329720360-23227-15-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This hopefully makes it harder to take the sizeof the wrong type.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c   |    8 ++++----
 drivers/pinctrl/pinmux.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5a435f4..b8e6112 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -502,7 +502,7 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 	 * mapping, this is what consumers will get when requesting
 	 * a pin control handle with pinctrl_get()
 	 */
-	p = kzalloc(sizeof(struct pinctrl), GFP_KERNEL);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (p == NULL) {
 		dev_err(dev, "failed to alloc struct pinctrl\n");
 		return ERR_PTR(-ENOMEM);
@@ -522,7 +522,7 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 			pinmux_put(p);
 			kfree(p);
 			/* Eventually, this should trigger deferred probe */
-			return -ENODEV;
+			return ERR_PTR(-ENODEV);
 		}
 
 		dev_dbg(dev, "in map, found pctldev %s to handle function %s",
@@ -719,7 +719,7 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
 	struct pinctrl *p;
 	int ret;
 
-	hog = kzalloc(sizeof(struct pinctrl_hog), GFP_KERNEL);
+	hog = kzalloc(sizeof(*hog), GFP_KERNEL);
 	if (!hog) {
 		dev_err(pctldev->dev, "failed to alloc struct pinctrl_hog\n");
 		return -ENOMEM;
@@ -1153,7 +1153,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	if (pctldesc->name == NULL)
 		return NULL;
 
-	pctldev = kzalloc(sizeof(struct pinctrl_dev), GFP_KERNEL);
+	pctldev = kzalloc(sizeof(*pctldev), GFP_KERNEL);
 	if (pctldev == NULL) {
 		dev_err(dev, "failed to alloc struct pinctrl_dev\n");
 		return NULL;
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 2887897..98b89d6 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -491,7 +491,7 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 	p->func_selector = func_selector;
 
 	/* Now add this group selector, we may have many of them */
-	grp = kmalloc(sizeof(struct pinmux_group), GFP_KERNEL);
+	grp = kmalloc(sizeof(*grp), GFP_KERNEL);
 	if (!grp)
 		return -ENOMEM;
 	grp->group_selector = group_selector;
-- 
1.7.5.4

