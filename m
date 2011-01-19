Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1ASOwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:52:23 -0500
Received: from smtp-out.google.com ([216.239.44.51]:33261 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab1ASOwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:52:22 -0500
From: Vincent Palatin <vpalatin@chromium.org>
To: Samuel Ortiz <sameo@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] mfd: tps6586x: Invert GPIO and subdevices initialization
Date: Wed, 19 Jan 2011 09:52:09 -0500
Message-Id: <1295448729-22821-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a fixed voltage regulator triggered by a TPS6586x GPIO,
this allows to declare and initialize it conveniently from the "subdev" list.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 drivers/mfd/tps6586x.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 627cf57..fdb16ed 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -517,19 +517,25 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 		}
 	}
 
+	tps6586x_gpio_init(tps6586x, pdata->gpio_base);
+
 	ret = tps6586x_add_subdevs(tps6586x, pdata);
 	if (ret) {
 		dev_err(&client->dev, "add devices failed: %d\n", ret);
 		goto err_add_devs;
 	}
 
-	tps6586x_gpio_init(tps6586x, pdata->gpio_base);
-
 	return 0;
 
 err_add_devs:
 	if (client->irq)
 		free_irq(client->irq, tps6586x);
+	if (pdata->gpio_base) {
+		ret = gpiochip_remove(&tps6586x->gpio);
+		if (ret)
+			dev_err(&client->dev, "Can't remove gpio chip: %d\n",
+				ret);
+	}
 err_irq_init:
 	kfree(tps6586x);
 	return ret;
-- 
1.7.3.1

