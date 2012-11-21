Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2KUCgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:36:23 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2KUC0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:55 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 10/42] sh-pfc: Support passing resources through platform device
Date: Wed, 21 Nov 2012 03:27:11 +0100
Message-Id: <1353464863-10281-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resources should be passed through the platform device, not through
platform data. Default to platform device resources and fall back to
platform data resources if not available.

Support for platform data resources will be removed when arch code will
be converted.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/sh/pfc/core.c |   29 +++++++++++++++++++++--------
 drivers/sh/pfc/core.h |    2 ++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/sh/pfc/core.c b/drivers/sh/pfc/core.c
index 9736e3d..4e4adc7 100644
--- a/drivers/sh/pfc/core.c
+++ b/drivers/sh/pfc/core.c
@@ -30,29 +30,42 @@ static void pfc_iounmap(struct sh_pfc *pfc)
 {
 	int k;
 
-	for (k = 0; k < pfc->pdata->num_resources; k++)
+	for (k = 0; k < pfc->num_windows; k++)
 		if (pfc->window[k].virt)
 			iounmap(pfc->window[k].virt);
 
 	kfree(pfc->window);
+	pfc->num_windows = 0;
 	pfc->window = NULL;
 }
 
-static int pfc_ioremap(struct sh_pfc *pfc)
+static int pfc_ioremap(struct sh_pfc *pfc, struct platform_device *pdev)
 {
+	unsigned int num_resources;
 	struct resource *res;
 	int k;
 
-	if (!pfc->pdata->num_resources)
+	if (pdev->num_resources) {
+		num_resources = pdev->num_resources;
+		res = pdev->resource;
+	} else {
+		num_resources = pfc->pdata->num_resources;
+		res = pfc->pdata->resource;
+	}
+
+	if (num_resources == 0) {
+		pfc->num_windows = 0;
 		return 0;
+	}
 
-	pfc->window = kzalloc(pfc->pdata->num_resources * sizeof(*pfc->window),
+	pfc->window = kzalloc(num_resources * sizeof(*pfc->window),
 			      GFP_NOWAIT);
 	if (!pfc->window)
 		goto err1;
 
-	for (k = 0; k < pfc->pdata->num_resources; k++) {
-		res = pfc->pdata->resource + k;
+	pfc->num_windows = num_resources;
+
+	for (k = 0; k < num_resources; k++, res++) {
 		WARN_ON(resource_type(res) != IORESOURCE_MEM);
 		pfc->window[k].phys = res->start;
 		pfc->window[k].size = resource_size(res);
@@ -77,7 +90,7 @@ static void __iomem *pfc_phys_to_virt(struct sh_pfc *pfc,
 	int k;
 
 	/* scan through physical windows and convert address */
-	for (k = 0; k < pfc->pdata->num_resources; k++) {
+	for (k = 0; k < pfc->num_windows; k++) {
 		window = pfc->window + k;
 
 		if (address < window->phys)
@@ -516,7 +529,7 @@ static int sh_pfc_probe(struct platform_device *pdev)
 	pfc->pdata = pdata;
 	pfc->dev = &pdev->dev;
 
-	ret = pfc_ioremap(pfc);
+	ret = pfc_ioremap(pfc, pdev);
 	if (unlikely(ret < 0))
 		return ret;
 
diff --git a/drivers/sh/pfc/core.h b/drivers/sh/pfc/core.h
index 1287b3e..b71f559 100644
--- a/drivers/sh/pfc/core.h
+++ b/drivers/sh/pfc/core.h
@@ -28,7 +28,9 @@ struct sh_pfc {
 	struct sh_pfc_platform_data *pdata;
 	spinlock_t lock;
 
+	unsigned int num_windows;
 	struct pfc_window *window;
+
 	struct sh_pfc_chip *gpio;
 	struct sh_pfc_pinctrl *pinctrl;
 };
-- 
1.7.8.6

