Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2EWNUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:20:00 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:5171 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175Ab2EWNT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:19:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH RFC v3 1/3] pinctrl: remove pinctrl_remove_gpio_range
Date: Wed, 23 May 2012 21:22:40 +0800
Message-ID: <1337779362-31259-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The gpio ranges will be automatically removed when the pinctrl
driver is unregistered.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
I greped the lastes torvalds tree, it seems no other pinctrl drivers
are using pinctrl_remove_gpio_range. It may be safe to merge this
through pinctrl tree.
---
 drivers/pinctrl/core.c          |   19 +++++--------------
 drivers/pinctrl/pinctrl-tegra.c |    1 -
 drivers/pinctrl/pinctrl-u300.c  |    2 --
 include/linux/pinctrl/pinctrl.h |    2 --
 4 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index c3b331b..e16529e 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -333,20 +333,6 @@ void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 EXPORT_SYMBOL_GPL(pinctrl_add_gpio_range);
 
 /**
- * pinctrl_remove_gpio_range() - remove a range of GPIOs fro a pin controller
- * @pctldev: pin controller device to remove the range from
- * @range: the GPIO range to remove
- */
-void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
-			       struct pinctrl_gpio_range *range)
-{
-	mutex_lock(&pinctrl_mutex);
-	list_del(&range->node);
-	mutex_unlock(&pinctrl_mutex);
-}
-EXPORT_SYMBOL_GPL(pinctrl_remove_gpio_range);
-
-/**
  * pinctrl_get_group_selector() - returns the group selector for a group
  * @pctldev: the pin controller handling the group
  * @pin_group: the pin group to look up
@@ -1485,6 +1471,7 @@ EXPORT_SYMBOL_GPL(pinctrl_register);
  */
 void pinctrl_unregister(struct pinctrl_dev *pctldev)
 {
+	struct pinctrl_gpio_range *range, *n;
 	if (pctldev == NULL)
 		return;
 
@@ -1500,6 +1487,10 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 	/* Destroy descriptor tree */
 	pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
 			      pctldev->desc->npins);
+	/* remove gpio ranges map */
+	list_for_each_entry_safe(range, n, &pctldev->gpio_ranges, node)
+		list_del(&range->node);
+
 	kfree(pctldev);
 
 	mutex_unlock(&pinctrl_mutex);
diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 2c98fba..47bd452 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -702,7 +702,6 @@ static int __devexit tegra_pinctrl_remove(struct platform_device *pdev)
 {
 	struct tegra_pmx *pmx = platform_get_drvdata(pdev);
 
-	pinctrl_remove_gpio_range(pmx->pctl, &tegra_pinctrl_gpio_range);
 	pinctrl_unregister(pmx->pctl);
 
 	return 0;
diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 05d0299..10de43c 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1177,8 +1177,6 @@ static int __devexit u300_pmx_remove(struct platform_device *pdev)
 	struct u300_pmx *upmx = platform_get_drvdata(pdev);
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++)
-		pinctrl_remove_gpio_range(upmx->pctl, &u300_gpio_ranges[i]);
 	pinctrl_unregister(upmx->pctl);
 	iounmap(upmx->virtbase);
 	release_mem_region(upmx->phybase, upmx->physize);
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 3b894a6..170a588 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -131,8 +131,6 @@ extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
 extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
 extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
-extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
-				struct pinctrl_gpio_range *range);
 extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
 #else
-- 
1.7.0.4


