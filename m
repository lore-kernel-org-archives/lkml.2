Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0HTB6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:58:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46674 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0HTB6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Jexr12I5wCpr5IJoCQv2hAiNq9wJHmdzmxHDZigbKS2C6VK4dcNyxMEyCn3Ow+/Sfb
         MXdanomE0AUQ/bjhuwgQUg9FqsAMuvhoC20t/IIy1EHlFwdTWUEzQSApTSIeM3wdVtEs
         duHhSgOpDiEOfIneT8WFbsd+V3coxel3SrKXM=
Subject: [PATCH 3/4] regulator/wm831x-ldo: fix potential NULL dereference
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <1282269518.31048.2.camel@mola>
References: <1282269518.31048.2.camel@mola>
Content-Type: text/plain
Date: Fri, 20 Aug 2010 10:01:24 +0800
Message-Id: <1282269684.31048.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdata is dereferenced earlier than tested for being NULL.
Thus move the dereference of "pdata" below the check for NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-ldo.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index e686cdb..040515d 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -303,14 +303,17 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
 	struct wm831x_ldo *ldo;
 	struct resource *res;
-	int ret, irq;
+	int id, ret, irq;
 
+	if (pdata == NULL)
+		return -ENODEV;
+
+	id = pdev->id % ARRAY_SIZE(pdata->ldo);
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
-	if (pdata == NULL || pdata->ldo[id] == NULL)
+	if (pdata->ldo[id] == NULL)
 		return -ENODEV;
 
 	ldo = kzalloc(sizeof(struct wm831x_ldo), GFP_KERNEL);
@@ -563,14 +566,17 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
 	struct wm831x_ldo *ldo;
 	struct resource *res;
-	int ret, irq;
+	int id, ret, irq;
+
+	if (pdata == NULL)
+		return -ENODEV;
 
+	id = pdev->id % ARRAY_SIZE(pdata->ldo);
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
-	if (pdata == NULL || pdata->ldo[id] == NULL)
+	if (pdata->ldo[id] == NULL)
 		return -ENODEV;
 
 	ldo = kzalloc(sizeof(struct wm831x_ldo), GFP_KERNEL);
@@ -749,14 +755,17 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
 	struct wm831x_ldo *ldo;
 	struct resource *res;
-	int ret;
+	int id, ret;
+
+	if (pdata == NULL)
+		return -ENODEV;
 
+	id = pdev->id % ARRAY_SIZE(pdata->ldo);
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
-	if (pdata == NULL || pdata->ldo[id] == NULL)
+	if (pdata->ldo[id] == NULL)
 		return -ENODEV;
 
 	ldo = kzalloc(sizeof(struct wm831x_ldo), GFP_KERNEL);
-- 
1.7.2



