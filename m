Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1LNKpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:45:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48909 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab1LNKpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:45:14 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v3] mfd: TPS65910: Make usable even if interrupt unused
Date: Wed, 14 Dec 2011 16:05:35 +0530
Message-ID: <1323858935-25724-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65910 can be used even if interrupt is unused.
Hence let probe succeed in case interrupt can't be
configured and let Kernel only to complain about it

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

v2: free irq only if registered

 drivers/mfd/tps65910-irq.c |    3 ++-
 drivers/mfd/tps65910.c     |    7 ++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index a56be93..95c0d79 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -215,6 +215,7 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 
 int tps65910_irq_exit(struct tps65910 *tps65910)
 {
-	free_irq(tps65910->chip_irq, tps65910);
+	if (tps65910->chip_irq)
+		free_irq(tps65910->chip_irq, tps65910);
 	return 0;
 }
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 6f5b8cf..04814a7 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -172,15 +172,12 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
 
-	ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
-	if (ret < 0)
-		goto err;
+	tps65910_irq_init(tps65910, init_data->irq, init_data);
 
 	kfree(init_data);
 	return ret;
 
 err:
-	mfd_remove_devices(tps65910->dev);
 	kfree(tps65910);
 	kfree(init_data);
 	return ret;
@@ -190,8 +187,8 @@ static int tps65910_i2c_remove(struct i2c_client *i2c)
 {
 	struct tps65910 *tps65910 = i2c_get_clientdata(i2c);
 
-	mfd_remove_devices(tps65910->dev);
 	tps65910_irq_exit(tps65910);
+	mfd_remove_devices(tps65910->dev);
 	kfree(tps65910);
 
 	return 0;
-- 
1.7.1

