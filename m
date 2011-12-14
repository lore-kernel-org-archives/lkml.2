Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab1LNTf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:35:28 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:48641 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755103Ab1LNTfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:35:25 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: conjure names for unnamed pins
Date: Wed, 14 Dec 2011 20:34:59 +0100
Message-ID: <1323891299-31333-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

If pins with blank names are registered, we assign them names on-the-fly
on the form "PINn" where n is the pin number for that pin on the specific
controller.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c |   13 +++++++++++--
 drivers/pinctrl/core.h |    2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index f804d8e..fe3143b 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -158,6 +158,8 @@ static void pinctrl_free_pindescs(struct pinctrl_dev *pctldev,
 		if (pindesc != NULL) {
 			radix_tree_delete(&pctldev->pin_desc_tree,
 					  pins[i].number);
+			if (pindesc->dynamic_name)
+				kfree(pindesc->name);
 		}
 		kfree(pindesc);
 	}
@@ -186,13 +188,20 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 	pindesc->pctldev = pctldev;
 
 	/* Copy basic pin info */
-	pindesc->name = name;
+	if (pindesc->name) {
+		pindesc->name = name;
+	} else {
+		pindesc->name = kasprintf(GFP_KERNEL, "PIN%u", number);
+		if (pindesc->name == NULL)
+			return -ENOMEM;
+		pindesc->dynamic_name = true;
+	}
 
 	spin_lock(&pctldev->pin_desc_tree_lock);
 	radix_tree_insert(&pctldev->pin_desc_tree, number, pindesc);
 	spin_unlock(&pctldev->pin_desc_tree_lock);
 	pr_debug("registered pin %d (%s) on %s\n",
-		 number, name ? name : "(unnamed)", pctldev->desc->name);
+		 number, pindesc->name, pctldev->desc->name);
 	return 0;
 }
 
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 5375582..177a331 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -52,6 +52,7 @@ struct pinctrl_dev {
  * @pctldev: corresponding pin control device
  * @name: a name for the pin, e.g. the name of the pin/pad/finger on a
  *	datasheet or such
+ * @dynamic_name: if the name of this pin was dynamically allocated
  * @lock: a lock to protect the descriptor structure
  * @mux_requested: whether the pin is already requested by pinmux or not
  * @mux_function: a named muxing function for the pin that will be passed to
@@ -60,6 +61,7 @@ struct pinctrl_dev {
 struct pin_desc {
 	struct pinctrl_dev *pctldev;
 	const char *name;
+	bool dynamic_name;
 	spinlock_t lock;
 	/* These fields only added when supporting pinmux drivers */
 #ifdef CONFIG_PINMUX
-- 
1.7.3.2

