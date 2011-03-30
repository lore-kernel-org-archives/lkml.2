Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab1C3WSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:18:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38938 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932342Ab1C3WSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:18:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpio: pca953x: fix error handling path in probe() call
Date: Thu, 31 Mar 2011 07:18:46 +0900
Message-Id: <1301523526-27799-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben-linux@fluff.org>

If the device fails to respond, then the error path tries to remove an
interrupt that never got registered, which causes an backtrace from the
interrupt handling code.

Fix this by ensuring that the cleanup path has two labels and use the
correct path as needed.

fixes the following error:

WARNING: at kernel/irq/manage.c:908 __free_irq+0x80/0x160()
Trying to free already-free IRQ 0

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/pca953x.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 583e925..7630ab7 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -558,7 +558,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 
 	ret = gpiochip_add(&chip->gpio_chip);
 	if (ret)
-		goto out_failed;
+		goto out_failed_irq;
 
 	if (pdata->setup) {
 		ret = pdata->setup(client, chip->gpio_chip.base,
@@ -570,8 +570,9 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, chip);
 	return 0;
 
-out_failed:
+out_failed_irq:
 	pca953x_irq_teardown(chip);
+out_failed:
 	kfree(chip->dyn_pdata);
 	kfree(chip);
 	return ret;
-- 
1.7.4.1

