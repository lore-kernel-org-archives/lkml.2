Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1JRTAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:00:20 -0400
Received: from mail.fuel7.com ([74.222.0.51]:44532 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1JRTAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:00:11 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>
Cc: Kyle Manna <kyle.manna@fuel7.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 1/6] mfd: TPS65910: Handle non-existent devices
Date: Tue, 18 Oct 2011 13:26:23 -0500
Message-Id: <1318962388-26151-2-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
References: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempt to read the first register of the device, if there is no
device return -ENODEV

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 drivers/mfd/tps65910.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 6f5b8cf..03fb4a7 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -138,6 +138,7 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	struct tps65910_board *pmic_plat_data;
 	struct tps65910_platform_data *init_data;
 	int ret = 0;
+	char buff;
 
 	pmic_plat_data = dev_get_platdata(&i2c->dev);
 	if (!pmic_plat_data)
@@ -161,11 +162,17 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910->write = tps65910_i2c_write;
 	mutex_init(&tps65910->io_mutex);
 
-	ret = mfd_add_devices(tps65910->dev, -1,
-			      tps65910s, ARRAY_SIZE(tps65910s),
-			      NULL, 0);
-	if (ret < 0)
+	/* Check that the device is actually there */
+	ret = tps65910_i2c_read(tps65910, 0x0, 1, &buff);
+	if (ret < 0) {
+		ret = -ENODEV;
 		goto err;
+	}
+
+	ret = mfd_add_devices(tps65910->dev, -1, tps65910s,
+			ARRAY_SIZE(tps65910s), NULL, 0);
+	if (ret < 0)
+		goto err2;
 
 	init_data->irq = pmic_plat_data->irq;
 	init_data->irq_base = pmic_plat_data->irq;
@@ -174,13 +181,14 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
 	if (ret < 0)
-		goto err;
+		goto err2;
 
 	kfree(init_data);
 	return ret;
 
-err:
+err2:
 	mfd_remove_devices(tps65910->dev);
+err:
 	kfree(tps65910);
 	kfree(init_data);
 	return ret;
-- 
1.7.5.4

