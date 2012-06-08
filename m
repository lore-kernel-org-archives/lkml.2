Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2FHAfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:35:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43291 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2FHAfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:35:43 -0400
Message-ID: <1339115737.4310.7.camel@phoenix>
Subject: [PATCH 2/2] mfd: max77693: fix irq leak and wrong kfree call
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Fri, 08 Jun 2012 08:35:37 +0800
In-Reply-To: <1339115669.4310.6.camel@phoenix>
References: <1339115669.4310.6.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to call max77693_irq_exit() in max77693_i2c_probe error patch and
max77693_i2c_remove.

Current code already uses devm_kzalloc() to allocate memory for max77693.
Thus we should not call kfree(max77693), otherwise we got double free.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/max77693.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 4055bc2..4251757 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -122,7 +122,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	max77693->regmap = devm_regmap_init_i2c(i2c, &max77693_regmap_config);
 	if (IS_ERR(max77693->regmap)) {
 		ret = PTR_ERR(max77693->regmap);
-		dev_err(max77693->dev,"failed to allocate register map: %d\n",
+		dev_err(max77693->dev, "failed to allocate register map: %d\n",
 				ret);
 		goto err_regmap;
 	}
@@ -154,7 +154,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 
 	ret = max77693_irq_init(max77693);
 	if (ret < 0)
-		goto err_mfd;
+		goto err_irq;
 
 	pm_runtime_set_active(max77693->dev);
 
@@ -168,11 +168,11 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	return ret;
 
 err_mfd:
+	max77693_irq_exit(max77693);
+err_irq:
 	i2c_unregister_device(max77693->muic);
 	i2c_unregister_device(max77693->haptic);
 err_regmap:
-	kfree(max77693);
-
 	return ret;
 }
 
@@ -181,6 +181,7 @@ static int max77693_i2c_remove(struct i2c_client *i2c)
 	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
 
 	mfd_remove_devices(max77693->dev);
+	max77693_irq_exit(max77693);
 	i2c_unregister_device(max77693->muic);
 	i2c_unregister_device(max77693->haptic);
 
-- 
1.7.9.5



