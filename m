Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161432Ab2CPUzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:55:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50306 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965274Ab2CPUyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:54:55 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 4/8] pinctrl: implement pinctrl_check_ops
Date: Fri, 16 Mar 2012 14:54:25 -0600
Message-Id: <1331931269-12262-4-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
References: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most code assumes that the pinctrl ops are present. Validate this when
registering a pinctrl driver. Remove the one place in the code that
was checking whether one of these non-optional ops was present.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/pinctrl/core.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index ec3b8cc..df6296c 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -908,10 +908,6 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
 	unsigned selector = 0;
 
-	/* No grouping */
-	if (!ops)
-		return 0;
-
 	mutex_lock(&pinctrl_mutex);
 
 	seq_puts(s, "registered pin groups:\n");
@@ -1225,6 +1221,19 @@ static void pinctrl_remove_device_debugfs(struct pinctrl_dev *pctldev)
 
 #endif
 
+static int pinctrl_check_ops(struct pinctrl_dev *pctldev)
+{
+	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
+
+	if (!ops ||
+	    !ops->list_groups ||
+	    !ops->get_group_name ||
+	    !ops->get_group_pins)
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * pinctrl_register() - register a pin controller device
  * @pctldesc: descriptor for this pin controller
@@ -1256,6 +1265,14 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	INIT_LIST_HEAD(&pctldev->gpio_ranges);
 	pctldev->dev = dev;
 
+	/* check core ops for sanity */
+	ret = pinctrl_check_ops(pctldev);
+	if (ret) {
+		pr_err("%s pinctrl ops lacks necessary functions\n",
+			pctldesc->name);
+		goto out_err;
+	}
+
 	/* If we're implementing pinmuxing, check the ops for sanity */
 	if (pctldesc->pmxops) {
 		ret = pinmux_check_ops(pctldev);
-- 
1.7.0.4

