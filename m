Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2LLTyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:54:09 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:42013 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690Ab2LLTyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:54:07 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2 v2] pinctrl: skip deferral of hogs
Date: Wed, 12 Dec 2012 20:53:47 +0100
Message-ID: <1355342027-2287-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Up until now, as hogs were always taken at the end of the
pin control device registration, it didn't cause any problem.
But when starting to hog pins from the device core it will
cause deferral of the pin controller device itself since the
default pin fetch is done *before* the device probes, so
let's fix this annoyance (which is also aesthetically ugly).

Also take some care to make sure that if any one map entry
results in a deferral rather than a failure, then that
deferral will take precedence.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Make deferral take precedence.
---
 drivers/pinctrl/core.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 59f5a96..5b4885c 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -609,13 +609,16 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
 
 	setting->pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
 	if (setting->pctldev == NULL) {
-		dev_info(p->dev, "unknown pinctrl device %s in map entry, deferring probe",
-			map->ctrl_dev_name);
 		kfree(setting);
+		/* Do not defer probing of hogs (circular loop) */
+		if (!strcmp(map->ctrl_dev_name, map->dev_name))
+			return -ENODEV;
 		/*
 		 * OK let us guess that the driver is not there yet, and
 		 * let's defer obtaining this pinctrl handle to later...
 		 */
+		dev_info(p->dev, "unknown pinctrl device %s in map entry, deferring probe",
+			map->ctrl_dev_name);
 		return -EPROBE_DEFER;
 	}
 
@@ -694,11 +697,29 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 			continue;
 
 		ret = add_setting(p, map);
-		if (ret < 0) {
+		/*
+		 * At this point the adding of a setting may:
+		 *
+		 * - Defer, if the pinctrl device is not yet available
+		 * - Fail, if the pinctrl device is not yet available,
+		 *   AND the setting is a hog. We cannot defer that, since
+		 *   the hog will kick in immediately after the device
+		 *   is registered.
+		 *
+		 * If the error returned was not -EPROBE_DEFER then we
+		 * accumulate the errors to see if we end up with
+		 * an -EPROBE_DEFER later, as that is the worst case.
+		 */
+		if (ret == -EPROBE_DEFER) {
 			pinctrl_put_locked(p, false);
 			return ERR_PTR(ret);
 		}
 	}
+	if (ret < 0) {
+		/* If some other error than deferral occured, return here */
+		pinctrl_put_locked(p, false);
+		return ERR_PTR(ret);
+	}
 
 	/* Add the pinctrl handle to the global list */
 	list_add_tail(&p->node, &pinctrl_list);
-- 
1.7.11.3

