Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2LKOAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:00:21 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:49766 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab2LKOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:00:20 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Julien Delacou <julien.delacou@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinctrl/nomadik: adopt pinctrl sleep mode management
Date: Tue, 11 Dec 2012 15:00:04 +0100
Message-ID: <1355234404-17405-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Delacou <julien.delacou@stericsson.com>

This fix makes pinctrl-nomadik able to handle suspend/resume
events and change hogged pins states accordingly.

Signed-off-by: Julien Delacou <julien.delacou@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 8ef3e85..1068faa 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1847,6 +1847,28 @@ static const struct of_device_id nmk_pinctrl_match[] = {
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
@@ -1955,6 +1977,10 @@ static struct platform_driver nmk_pinctrl_driver = {
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

