Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2LSAsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:48:05 -0500
Received: from [12.239.217.82] ([12.239.217.82]:43129 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754977Ab2LSArz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:47:55 -0500
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 03/05] input: I2C physical layer
Date: Tue, 18 Dec 2012 16:46:34 -0800
Message-Id: <1355877996-1433-4-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
References: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes here are limited to those described in the 0/0 of this patchset, plus
some tweaks to debugging output.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>

---

 drivers/input/rmi4/rmi_i2c.c |  141 ++++++------------------------------------
 1 files changed, 20 insertions(+), 121 deletions(-)

diff --git a/drivers/input/rmi4/rmi_i2c.c b/drivers/input/rmi4/rmi_i2c.c
index ca32101..513791c 100644
--- a/drivers/input/rmi4/rmi_i2c.c
+++ b/drivers/input/rmi4/rmi_i2c.c
@@ -2,19 +2,9 @@
  * Copyright (c) 2011, 2012 Synaptics Incorporated
  * Copyright (c) 2011 Unixphere
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
  */

 #include <linux/kernel.h>
@@ -58,7 +48,7 @@ struct rmi_i2c_data {
 	u8 *debug_buf;
 	int debug_buf_size;

-	bool comms_debug;
+	u32 comms_debug;
 #ifdef CONFIG_RMI4_DEBUG
 	struct dentry *debugfs_comms;
 #endif
@@ -66,107 +56,13 @@ struct rmi_i2c_data {

 #ifdef CONFIG_RMI4_DEBUG

-
-/**
- * struct i2c_debugfs_data - stores information for debugfs
- *
- * @done: Indicates that we are done reading debug data. Subsequent reads
- * will return EOF.
- * @i2c_data: Pointer to the i2c data
- *
- */
-struct i2c_debugfs_data {
-	bool done;
-	struct rmi_i2c_data *i2c_data;
-};
-
-static int debug_open(struct inode *inodep, struct file *filp)
-{
-	struct i2c_debugfs_data *data;
-
-	data = kzalloc(sizeof(struct i2c_debugfs_data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	data->i2c_data = inodep->i_private;
-	filp->private_data = data;
-	return 0;
-}
-
-static int debug_release(struct inode *inodep, struct file *filp)
-{
-	kfree(filp->private_data);
-	return 0;
-}
-
-static ssize_t comms_debug_read(struct file *filp, char __user *buffer,
-		size_t size, loff_t *offset) {
-	int retval;
-	char *local_buf;
-	struct i2c_debugfs_data *dfs = filp->private_data;
-	struct rmi_i2c_data *data = dfs->i2c_data;
-
-	if (dfs->done)
-		return 0;
-
-	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
-	if (!local_buf)
-		return -ENOMEM;
-
-	dfs->done = 1;
-
-	retval = snprintf(local_buf, PAGE_SIZE, "%u\n", data->comms_debug);
-
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
-
-	return retval;
-}
-
-static ssize_t comms_debug_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset) {
-	int retval;
-	char *local_buf;
-	unsigned int new_value;
-	struct i2c_debugfs_data *dfs = filp->private_data;
-	struct rmi_i2c_data *data = dfs->i2c_data;
-
-	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
-	if (!local_buf)
-		return -ENOMEM;
-	retval = copy_from_user(local_buf, buffer, size);
-	if (retval) {
-		kfree(local_buf);
-		return -EFAULT;
-	}
-
-	retval = sscanf(local_buf, "%u", &new_value);
-	kfree(local_buf);
-	if (retval != 1 || new_value > 1)
-		return -EINVAL;
-
-	data->comms_debug = new_value;
-
-	return size;
-}
-
-
-static const struct file_operations comms_debug_fops = {
-	.owner = THIS_MODULE,
-	.open = debug_open,
-	.release = debug_release,
-	.read = comms_debug_read,
-	.write = comms_debug_write,
-};
-
 static int setup_debugfs(struct rmi_device *rmi_dev, struct rmi_i2c_data *data)
 {
 	if (!rmi_dev->debugfs_root)
 		return -ENODEV;

-	data->debugfs_comms = debugfs_create_file("comms_debug", RMI_RW_ATTR,
-			rmi_dev->debugfs_root, data, &comms_debug_fops);
+	data->debugfs_comms = debugfs_create_bool("comms_debug", RMI_RW_ATTR,
+			rmi_dev->debugfs_root, &data->comms_debug);
 	if (!data->debugfs_comms || IS_ERR(data->debugfs_comms)) {
 		dev_warn(&rmi_dev->dev, "Failed to create debugfs comms_debug.\n");
 		data->debugfs_comms = NULL;
@@ -180,6 +76,9 @@ static void teardown_debugfs(struct rmi_i2c_data *data)
 	if (data->debugfs_comms)
 		debugfs_remove(data->debugfs_comms);
 }
+#else
+#define setup_debugfs(rmi_dev, data) 0
+#define teardown_debugfs(data)
 #endif

 #define COMMS_DEBUG(data) (IS_ENABLED(CONFIG_RMI4_DEBUG) && data->comms_debug)
@@ -286,8 +185,8 @@ static int rmi_i2c_write_block(struct rmi_phys_device *phys, u16 addr,
 	}

 	if (COMMS_DEBUG(data)) {
-		retval = copy_to_debug_buf(&client->dev, data, (u8 *) buf, len);
-		if (!retval)
+		int rc = copy_to_debug_buf(&client->dev, data, (u8 *) buf, len);
+		if (!rc)
 			dev_dbg(&client->dev, "writes %d bytes at %#06x:%s\n",
 				len, addr, data->debug_buf);
 	}
@@ -341,8 +240,8 @@ static int rmi_i2c_read_block(struct rmi_phys_device *phys, u16 addr,
 	if (retval < 0)
 		phys->info.rx_errs++;
 	else if (COMMS_DEBUG(data)) {
-		retval = copy_to_debug_buf(&client->dev, data, (u8 *) buf, len);
-		if (!retval)
+		int rc = copy_to_debug_buf(&client->dev, data, (u8 *) buf, len);
+		if (!rc)
 			dev_dbg(&client->dev, "read %d bytes at %#06x:%s\n",
 				len, addr, data->debug_buf);
 	}
@@ -369,7 +268,7 @@ static int __devinit rmi_i2c_probe(struct i2c_client *client,
 		client->addr, pdata->attn_gpio);

 	if (pdata->gpio_config) {
-		dev_info(&client->dev, "Configuring GPIOs.\n");
+		dev_dbg(&client->dev, "Configuring GPIOs.\n");
 		retval = pdata->gpio_config(pdata->gpio_data, true);
 		if (retval < 0) {
 			dev_err(&client->dev, "Failed to configure GPIOs, code: %d.\n",
@@ -419,15 +318,16 @@ static int __devinit rmi_i2c_probe(struct i2c_client *client,

 	retval = rmi_register_phys_device(rmi_phys);
 	if (retval) {
-		dev_err(&client->dev,
-			"failed to register physical driver at 0x%.2X.\n",
+		dev_err(&client->dev, "Failed to register physical driver at 0x%.2X.\n",
 			client->addr);
 		goto err_gpio;
 	}
 	i2c_set_clientdata(client, rmi_phys);

-	if (IS_ENABLED(CONFIG_RMI4_DEBUG))
-		retval = setup_debugfs(rmi_phys->rmi_dev, data);
+	retval = setup_debugfs(rmi_phys->rmi_dev, data);
+	if (retval < 0)
+		dev_warn(&client->dev, "Failed to setup debugfs. Code: %d.\n",
+			 retval);

 	dev_info(&client->dev, "registered rmi i2c driver at %#04x.\n",
 			client->addr);
@@ -444,8 +344,7 @@ static int __devexit rmi_i2c_remove(struct i2c_client *client)
 	struct rmi_phys_device *phys = i2c_get_clientdata(client);
 	struct rmi_device_platform_data *pd = client->dev.platform_data;

-	if (IS_ENABLED(CONFIG_RMI4_DEBUG))
-		teardown_debugfs(phys->data);
+	teardown_debugfs(phys->data);

 	rmi_unregister_phys_device(phys);

