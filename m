Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2GEKO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:14:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42557 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab2GEKOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:14:16 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Chris Ball <cjb@laptop.org>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Viresh Kumar <viresh.kumar@st.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] mmc: sdhci-dove: Prepare for common clock framework
Date: Thu,  5 Jul 2012 12:14:01 +0200
Message-Id: <1341483241-18300-2-git-send-email-sebastian.hesselbarth@googlemail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341483241-18300-1-git-send-email-sebastian.hesselbarth@googlemail.com>
References: <1341483241-18300-1-git-send-email-sebastian.hesselbarth@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mach-dove is moving towards common clock framework prepare
the sdhci driver to grab it's clock.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/sdhci-dove.c |   48 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index 9c85368..a6e53a1 100644
--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -20,11 +20,17 @@
  */
 
 #include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/mmc/host.h>
 
 #include "sdhci-pltfm.h"
 
+struct sdhci_dove_priv {
+	struct clk *clk;
+};
+
 static u16 sdhci_dove_readw(struct sdhci_host *host, int reg)
 {
 	u16 ret;
@@ -72,11 +78,51 @@ static struct sdhci_pltfm_data sdhci_dove_pdata = {
 
 static int __devinit sdhci_dove_probe(struct platform_device *pdev)
 {
-	return sdhci_pltfm_register(pdev, &sdhci_dove_pdata);
+	struct sdhci_host *host;
+	struct sdhci_pltfm_host *pltfm_host;
+	struct sdhci_dove_priv *priv;
+	int ret;
+
+	ret = sdhci_pltfm_register(pdev, &sdhci_dove_pdata);
+	if (ret)
+		goto sdhci_dove_register_fail;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct sdhci_dove_priv),
+			    GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "unable to allocate private data");
+		ret = -ENOMEM;
+		goto sdhci_dove_allocate_fail;
+	}
+
+	host = platform_get_drvdata(pdev);
+	pltfm_host = sdhci_priv(host);
+	pltfm_host->priv = priv;
+
+	priv->clk = clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(priv->clk))
+		clk_prepare_enable(priv->clk);
+	return 0;
+
+sdhci_dove_allocate_fail:
+	sdhci_pltfm_unregister(pdev);
+sdhci_dove_register_fail:
+	return ret;
 }
 
 static int __devexit sdhci_dove_remove(struct platform_device *pdev)
 {
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_dove_priv *priv = pltfm_host->priv;
+
+	if (priv->clk) {
+		if (!IS_ERR(priv->clk)) {
+			clk_disable_unprepare(priv->clk);
+			clk_put(priv->clk);
+		}
+		devm_kfree(&pdev->dev, priv->clk);
+	}
 	return sdhci_pltfm_unregister(pdev);
 }
 
-- 
1.7.10

