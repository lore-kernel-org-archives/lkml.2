Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2FIMBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 08:01:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61415 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2FIMBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 08:01:33 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/2] pinctrl: pinctrl-mxs: Take care of frees if the kzalloc fails
Date: Sat,  9 Jun 2012 17:31:23 +0530
Message-Id: <1339243283-28068-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if there is no purecfg , the group pointer is allocated using kzalloc and if it
fails to allocate, we wont free the new_map,

if config is true, we call kmemdup and if it
fails to do so we wont free the allocated group if there is no purecfg.

fix this by doing the frees of new_map pointer and group pointers.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/pinctrl/pinctrl-mxs.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index 556e45a..9d46303 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -107,8 +107,10 @@ static int mxs_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 		/* Compose group name */
 		group = kzalloc(length, GFP_KERNEL);
-		if (!group)
-			return -ENOMEM;
+		if (!group) {
+			ret = -ENOMEM;
+			goto free;
+		}
 		snprintf(group, length, "%s.%d", np->name, reg);
 		new_map[i].data.mux.group = group;
 		i++;
@@ -118,7 +120,7 @@ static int mxs_dt_node_to_map(struct pinctrl_dev *pctldev,
 		pconfig = kmemdup(&config, sizeof(config), GFP_KERNEL);
 		if (!pconfig) {
 			ret = -ENOMEM;
-			goto free;
+			goto free_group;
 		}
 
 		new_map[i].type = PIN_MAP_TYPE_CONFIGS_GROUP;
@@ -133,6 +135,9 @@ static int mxs_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 	return 0;
 
+free_group:
+	if (!purecfg)
+		free(group);
 free:
 	kfree(new_map);
 	return ret;
-- 
1.7.9.5

