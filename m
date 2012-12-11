Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2LKJ6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:58:52 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:6512 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab2LKJ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:58:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,258,1355094000"; 
   d="scan'208";a="165432955"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: kernel-janitors@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/pinctrl/pinctrl-at91.c: convert kfree to devm_kfree
Date: Tue, 11 Dec 2012 11:58:45 +0100
Message-Id: <1355223525-19165-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The function at91_dt_node_to_map is ultimately called by the function
pinctrl_get, which is an exported function.  Since it is possible that this
function is not called from within a probe function, for safety, the kfree
is converted to a devm_kfree, to both free the data and remove it from the
device in a failure situation.

A newline is added in the call to devm_kfree to avoid exceeding the 80
character limit.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/pinctrl/pinctrl-at91.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index c5e7571..0da8a5f 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -255,7 +255,8 @@ static int at91_dt_node_to_map(struct pinctrl_dev *pctldev,
 	}
 
 	map_num += grp->npins;
-	new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num, GFP_KERNEL);
+	new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num,
+			       GFP_KERNEL);
 	if (!new_map)
 		return -ENOMEM;
 
@@ -265,7 +266,7 @@ static int at91_dt_node_to_map(struct pinctrl_dev *pctldev,
 	/* create mux map */
 	parent = of_get_parent(np);
 	if (!parent) {
-		kfree(new_map);
+		devm_kfree(pctldev->dev, new_map);
 		return -EINVAL;
 	}
 	new_map[0].type = PIN_MAP_TYPE_MUX_GROUP;

