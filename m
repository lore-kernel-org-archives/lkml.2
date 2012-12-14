Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2LNUV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:21:29 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:35852 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932157Ab2LNUV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:21:28 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Julien Delacou <julien.delacou@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2 v2] pinctrl/nomadik: adopt pinctrl sleep mode management
Date: Fri, 14 Dec 2012 21:21:12 +0100
Message-ID: <1355516472-24759-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Delacou <julien.delacou@stericsson.com>

This fix makes pinctrl-nomadik able to handle
suspend/resume events and change hogged pins states
accordingly.

Signed-off-by: Julien Delacou <julien.delacou@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Use the new interface from the local "core.h" file
---
 drivers/pinctrl/pinctrl-nomadik.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 0ceef59..1ecb3ea 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -35,6 +35,7 @@
 #include <asm/mach/irq.h>
 #include <mach/irqs.h>
 #include "pinctrl-nomadik.h"
+#include "core.h"
 
 /*
  * The GPIO module in the Nomadik family of Systems-on-Chip is an
@@ -2096,6 +2097,28 @@ static const struct of_device_id nmk_pinctrl_match[] = {
 	{},
 };
 
+static int nmk_pinctrl_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct nmk_pinctrl *npct;
+
+	npct = platform_get_drvdata(pdev);
+	if (!npct)
+		return -EINVAL;
+
+	return pinctrl_force_sleep(npct->pctl);
+}
+
+static int nmk_pinctrl_resume(struct platform_device *pdev)
+{
+	struct nmk_pinctrl *npct;
+
+	npct = platform_get_drvdata(pdev);
+	if (!npct)
+		return -EINVAL;
+
+	return pinctrl_force_default(npct->pctl);
+}
+
 static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 {
 	const struct platform_device_id *platid = platform_get_device_id(pdev);
@@ -2204,6 +2227,10 @@ static struct platform_driver nmk_pinctrl_driver = {
 	},
 	.probe = nmk_pinctrl_probe,
 	.id_table = nmk_pinctrl_id,
+#ifdef CONFIG_PM
+	.suspend = nmk_pinctrl_suspend,
+	.resume = nmk_pinctrl_resume,
+#endif
 };
 
 static int __init nmk_gpio_init(void)
-- 
1.7.11.3

