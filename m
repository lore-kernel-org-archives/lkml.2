Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2BTGuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:50:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19403 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2BTGrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 19 Feb 2012 22:46:16 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 13/20] pinctrl: Error if mapping table's control dev can't be found
Date: Sun, 19 Feb 2012 23:45:53 -0700
Message-Id: <1329720360-23227-14-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a serious error, and the pin control system will not function
correctly if it ends up not programing the mapping table entries into
the HW. Instead of just ignoring this, error out.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index ce6016d..5a435f4 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -517,11 +517,12 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		 */
 		pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
 		if (!pctldev) {
-			dev_warn(dev, "unknown pinctrl device %s in map entry",
-				 map->ctrl_dev_name);
-
-			/* Continue to check the other mappings anyway... */
-			continue;
+			dev_err(dev, "unknown pinctrl device %s in map entry",
+				map->ctrl_dev_name);
+			pinmux_put(p);
+			kfree(p);
+			/* Eventually, this should trigger deferred probe */
+			return -ENODEV;
 		}
 
 		dev_dbg(dev, "in map, found pctldev %s to handle function %s",
-- 
1.7.5.4

