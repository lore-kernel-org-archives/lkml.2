Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab1CINA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:00:28 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52731 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1CINA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:00:26 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH, RESEND] Putting the device into runtime suspend after
 resume()/probe() is handled
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Mar 2011 12:39:34 +0000
Message-ID: <20110309123916.19908.78417.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Liu <hong.liu@intel.com>

by the PM core and the device core code. No need to manually add them in
each single driver. And correct the runtime state in remove().

Signed-off-by: Hong Liu <hong.liu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/misc/apds9802als.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)


diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index 644d4cd..81db781 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -245,9 +245,8 @@ static int apds9802als_probe(struct i2c_client *client,
 	als_set_default_config(client);
 	mutex_init(&data->mutex);
 
+	pm_runtime_set_active(&client->dev);
 	pm_runtime_enable(&client->dev);
-	pm_runtime_get(&client->dev);
-	pm_runtime_put(&client->dev);
 
 	return res;
 als_error1:
@@ -255,12 +254,19 @@ als_error1:
 	return res;
 }
 
-static int apds9802als_remove(struct i2c_client *client)
+static int __devexit apds9802als_remove(struct i2c_client *client)
 {
 	struct als_data *data = i2c_get_clientdata(client);
 
+	pm_runtime_get_sync(&client->dev);
+
 	als_set_power_state(client, false);
 	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
+
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_put_noidle(&client->dev);
+
 	kfree(data);
 	return 0;
 }
@@ -275,9 +281,6 @@ static int apds9802als_suspend(struct i2c_client *client, pm_message_t mesg)
 static int apds9802als_resume(struct i2c_client *client)
 {
 	als_set_default_config(client);
-
-	pm_runtime_get(&client->dev);
-	pm_runtime_put(&client->dev);
 	return 0;
 }
 
@@ -323,7 +326,7 @@ static struct i2c_driver apds9802als_driver = {
 		.pm = APDS9802ALS_PM_OPS,
 	},
 	.probe = apds9802als_probe,
-	.remove = apds9802als_remove,
+	.remove = __devexit_p(apds9802als_remove),
 	.suspend = apds9802als_suspend,
 	.resume = apds9802als_resume,
 	.id_table = apds9802als_id,

