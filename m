Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2FPSNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 14:13:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2FPSNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 14:13:22 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] pinctrl/pinctrl-core: cleanup pinctrl_register
Date: Sat, 16 Jun 2012 23:43:16 +0530
Message-Id: <1339870396-6726-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lots of places the ret is used just for non zero cases
with out that also we can check the status of the function
calls.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---

This is _completely_ untested change and also non build tested (since
i dont have a cross compiler (arch?) to build with and it was not
selectable in make allyesconfig)

i didn't removed the one and only ret assignment
at pinctrl_register_pins because it became ugly while seeing at it.

 drivers/pinctrl/core.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 0cc053a..50d9c28 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1395,9 +1395,9 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	struct pinctrl_dev *pctldev;
 	int ret;
 
-	if (pctldesc == NULL)
+	if (!pctldesc)
 		return NULL;
-	if (pctldesc->name == NULL)
+	if (!pctldesc->name)
 		return NULL;
 
 	pctldev = kzalloc(sizeof(*pctldev), GFP_KERNEL);
@@ -1415,23 +1415,20 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	pctldev->dev = dev;
 
 	/* check core ops for sanity */
-	ret = pinctrl_check_ops(pctldev);
-	if (ret) {
+	if (pinctrl_check_ops(pctldev)) {
 		dev_err(dev, "pinctrl ops lacks necessary functions\n");
 		goto out_err;
 	}
 
 	/* If we're implementing pinmuxing, check the ops for sanity */
 	if (pctldesc->pmxops) {
-		ret = pinmux_check_ops(pctldev);
-		if (ret)
+		if (pinmux_check_ops(pctldev))
 			goto out_err;
 	}
 
 	/* If we're implementing pinconfig, check the ops for sanity */
 	if (pctldesc->confops) {
-		ret = pinconf_check_ops(pctldev);
-		if (ret)
+		if (pinconf_check_ops(pctldev))
 			goto out_err;
 	}
 
@@ -1457,11 +1454,9 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		if (IS_ERR(s)) {
 			dev_dbg(dev, "failed to lookup the default state\n");
 		} else {
-			ret = pinctrl_select_state_locked(pctldev->p, s);
-			if (ret) {
+			if (pinctrl_select_state_locked(pctldev->p, s))
 				dev_err(dev,
 					"failed to select default state\n");
-			}
 		}
 	}
 
-- 
1.7.9.5

