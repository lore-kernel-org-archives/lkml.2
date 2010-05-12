Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0ELAS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:18:59 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:58047 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752886Ab0ELASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:18:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 21078
From: Lars-Peter Clausen <lars@metafoo.de>
To: sameo@linux.intel.com
Cc: fercerpav@gmail.com, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/4] MFD: pcf50633: Use threaded irq
Date: Wed, 12 May 2010 02:10:55 +0200
Message-Id: <1273623056-1243-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273623056-1243-3-git-send-email-lars@metafoo.de>
References: <1273623056-1243-1-git-send-email-lars@metafoo.de>
 <1273623056-1243-2-git-send-email-lars@metafoo.de>
 <1273623056-1243-3-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use threaded oneshot irq handler instead of normal irq handler and a workqueue.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mfd/Makefile        |    2 +-
 drivers/mfd/pcf50633-core.c |   57 +++++++------------------------------------
 2 files changed, 10 insertions(+), 49 deletions(-)

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 4c684c1..8593496 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -57,7 +57,7 @@ obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 
-obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
+obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o pcf50633-irq.o
 obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
 obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
 obj-$(CONFIG_ABX500_CORE)	+= abx500-core.o
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 6f7fb60..fc5cd7f 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -325,14 +325,12 @@ static void pcf50633_irq_call_handler(struct pcf50633 *pcf, int irq)
 /* Maximum amount of time ONKEY is held before emergency action is taken */
 #define PCF50633_ONKEY1S_TIMEOUT 8
 
-static void pcf50633_irq_worker(struct work_struct *work)
+static irqreturn_t pcf50633_irq(int irq, void *data)
 {
-	struct pcf50633 *pcf;
+	struct pcf50633 *pcf = data;
 	int ret, i, j;
 	u8 pcf_int[5], chgstat;
 
-	pcf = container_of(work, struct pcf50633, irq_work);
-
 	/* Read the 5 INT regs in one transaction */
 	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1,
 						ARRAY_SIZE(pcf_int), pcf_int);
@@ -436,21 +434,7 @@ static void pcf50633_irq_worker(struct work_struct *work)
 	}
 
 out:
-	put_device(pcf->dev);
-	enable_irq(pcf->irq);
-}
-
-static irqreturn_t pcf50633_irq(int irq, void *data)
-{
-	struct pcf50633 *pcf = data;
-
-	dev_dbg(pcf->dev, "pcf50633_irq\n");
-
-	get_device(pcf->dev);
-	disable_irq_nosync(pcf->irq);
-	queue_work(pcf->work_queue, &pcf->irq_work);
-
-	return IRQ_HANDLED;
+	return IRQ_HANDLED
 }
 
 static void
@@ -488,9 +472,6 @@ static int pcf50633_suspend(struct i2c_client *client, pm_message_t state)
 	 * henceforth */
 	disable_irq(pcf->irq);
 
-	/* Make sure that any running IRQ worker has quit */
-	cancel_work_sync(&pcf->irq_work);
-
 	/* Save the masks */
 	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1M,
 				ARRAY_SIZE(pcf->suspend_irq_masks),
@@ -531,16 +512,7 @@ static int pcf50633_resume(struct i2c_client *client)
 	if (ret < 0)
 		dev_err(pcf->dev, "Error restoring saved suspend masks\n");
 
-	/* Restore regulators' state */
-
-
-	get_device(pcf->dev);
-
-	/*
-	 * Clear any pending interrupts and set resume reason if any.
-	 * This will leave with enable_irq()
-	 */
-	pcf50633_irq_worker(&pcf->irq_work);
+	enable_irq(pcf->irq);
 
 	return 0;
 }
@@ -574,22 +546,13 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf->dev = &client->dev;
 	pcf->i2c_client = client;
 	pcf->irq = client->irq;
-	pcf->work_queue = create_singlethread_workqueue("pcf50633");
-
-	if (!pcf->work_queue) {
-		dev_err(&client->dev, "Failed to alloc workqueue\n");
-		ret = -ENOMEM;
-		goto err_free;
-	}
-
-	INIT_WORK(&pcf->irq_work, pcf50633_irq_worker);
 
 	version = pcf50633_reg_read(pcf, 0);
 	variant = pcf50633_reg_read(pcf, 1);
 	if (version < 0 || variant < 0) {
 		dev_err(pcf->dev, "Unable to probe pcf50633\n");
 		ret = -ENODEV;
-		goto err_destroy_workqueue;
+		goto err_free;
 	}
 
 	dev_info(pcf->dev, "Probed device version %d variant %d\n",
@@ -603,12 +566,13 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf50633_reg_write(pcf, PCF50633_REG_INT4M, 0x00);
 	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
 
-	ret = request_irq(client->irq, pcf50633_irq,
-					IRQF_TRIGGER_LOW, "pcf50633", pcf);
+	ret = request_threaded_irq(client->irq, NULL, pcf50633_irq,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					"pcf50633", pcf);
 
 	if (ret) {
 		dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
-		goto err_destroy_workqueue;
+		goto err_free;
 	}
 
 	/* Create sub devices */
@@ -651,8 +615,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 	return 0;
 
-err_destroy_workqueue:
-	destroy_workqueue(pcf->work_queue);
 err_free:
 	i2c_set_clientdata(client, NULL);
 	kfree(pcf);
@@ -666,7 +628,6 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 	int i;
 
 	free_irq(pcf->irq, pcf);
-	destroy_workqueue(pcf->work_queue);
 
 	platform_device_unregister(pcf->input_pdev);
 	platform_device_unregister(pcf->rtc_pdev);
-- 
1.5.6.5

