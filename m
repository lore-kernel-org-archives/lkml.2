Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2JAVwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:52:47 -0400
Received: from lunge.queued.net ([173.255.254.236]:58893 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2JAVwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:52:43 -0400
Date: Mon, 1 Oct 2012 14:46:21 -0700
From: Andres Salomon <dilinger@queued.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Nettleton <jon.nettleton@gmail.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 5/5] staging/olpc_dcon: use s/r hooks from device_driver->pm
Message-ID: <20121001144621.360ed7e8@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


..instead of the i2c_driver hooks.  This should silence the following
runtime warnings:

[   17.820321] i2c-core: driver [olpc_dcon] using legacy suspend method
[   17.846082] i2c-core: driver [olpc_dcon] using legacy resume method

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 2b0bbac..3fe209c 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -685,8 +685,9 @@ static int dcon_remove(struct i2c_client *client)
 }
 
 #ifdef CONFIG_PM
-static int dcon_suspend(struct i2c_client *client, pm_message_t state)
+static int dcon_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct dcon_priv *dcon = i2c_get_clientdata(client);
 
 	if (!dcon->asleep) {
@@ -697,8 +698,9 @@ static int dcon_suspend(struct i2c_client *client, pm_message_t state)
 	return 0;
 }
 
-static int dcon_resume(struct i2c_client *client)
+static int dcon_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct dcon_priv *dcon = i2c_get_clientdata(client);
 
 	if (!dcon->asleep) {
@@ -709,7 +711,12 @@ static int dcon_resume(struct i2c_client *client)
 	return 0;
 }
 
-#endif
+#else
+
+#define dcon_suspend NULL
+#define dcon_resume NULL
+
+#endif /* CONFIG_PM */
 
 
 irqreturn_t dcon_interrupt(int irq, void *id)
@@ -753,16 +760,21 @@ irqreturn_t dcon_interrupt(int irq, void *id)
 	return IRQ_HANDLED;
 }
 
+static const struct dev_pm_ops dcon_pm_ops = {
+	.suspend = dcon_suspend,
+	.resume = dcon_resume,
+};
+
 static const struct i2c_device_id dcon_idtable[] = {
 	{ "olpc_dcon",  0 },
 	{ }
 };
-
 MODULE_DEVICE_TABLE(i2c, dcon_idtable);
 
 struct i2c_driver dcon_driver = {
 	.driver = {
 		.name	= "olpc_dcon",
+		.pm = &dcon_pm_ops,
 	},
 	.class = I2C_CLASS_DDC | I2C_CLASS_HWMON,
 	.id_table = dcon_idtable,
@@ -770,10 +782,6 @@ struct i2c_driver dcon_driver = {
 	.remove = __devexit_p(dcon_remove),
 	.detect = dcon_detect,
 	.address_list = normal_i2c,
-#ifdef CONFIG_PM
-	.suspend = dcon_suspend,
-	.resume = dcon_resume,
-#endif
 };
 
 static int __init olpc_dcon_init(void)
-- 
1.7.10.4

