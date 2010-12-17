Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0LQKUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:20:30 -0500
Received: from smtp.nokia.com ([147.243.1.47]:31880 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0LQKU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:20:28 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: rpurdie@rpsys.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ilkka.koskinen@nokia.com,
        arun.murthy@stericsson.com, ankur.vaish@stericsson.com
Subject: [PATCH 2/3] leds: lp5523: Fix circular locking
Date: Fri, 17 Dec 2010 12:19:20 +0200
Message-Id: <1292581161-1177-3-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1292581161-1177-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1292581161-1177-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver contained possibility for circular locking.
One lock is held by sysfs-core and another one by the driver itself.
This happened when the driver created or removed sysfs entries dynamically.
There is no real need to do those operations. Now all the sysfs entries
are created at probe and removed at removal. Engine load and mux configuration
sysfs entries are now visible all the time. However, access to the entries
fails if the engine is disabled or running.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/leds/leds-lp5523.c |   56 ++++++++++++-------------------------------
 1 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 6cb4160..d0c4068 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -105,7 +105,6 @@
 #define SHIFT_MASK(id)			(((id) - 1) * 2)
 
 struct lp5523_engine {
-	const struct attribute_group *attributes;
 	int		id;
 	u8		mode;
 	u8		prog_page;
@@ -403,14 +402,23 @@ static ssize_t store_engine_leds(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct lp5523_chip *chip = i2c_get_clientdata(client);
 	u16 mux = 0;
+	ssize_t ret;
 
 	if (lp5523_mux_parse(buf, &mux, len))
 		return -EINVAL;
 
+	mutex_lock(&chip->lock);
+	ret = -EINVAL;
+	if (chip->engines[nr - 1].mode != LP5523_CMD_LOAD)
+		goto leave;
+
 	if (lp5523_load_mux(&chip->engines[nr - 1], mux))
-		return -EINVAL;
+		goto leave;
 
-	return len;
+	ret = len;
+leave:
+	mutex_unlock(&chip->lock);
+	return ret;
 }
 
 #define store_leds(nr)						\
@@ -556,7 +564,11 @@ static int lp5523_do_store_load(struct lp5523_engine *engine,
 
 	mutex_lock(&chip->lock);
 
-	ret = lp5523_load_program(engine, pattern);
+	if (engine->mode == LP5523_CMD_LOAD)
+		ret = lp5523_load_program(engine, pattern);
+	else
+		ret = -EINVAL;
+
 	mutex_unlock(&chip->lock);
 
 	if (ret) {
@@ -737,37 +749,18 @@ static struct attribute *lp5523_attributes[] = {
 	&dev_attr_engine2_mode.attr,
 	&dev_attr_engine3_mode.attr,
 	&dev_attr_selftest.attr,
-	NULL
-};
-
-static struct attribute *lp5523_engine1_attributes[] = {
 	&dev_attr_engine1_load.attr,
 	&dev_attr_engine1_leds.attr,
-	NULL
-};
-
-static struct attribute *lp5523_engine2_attributes[] = {
 	&dev_attr_engine2_load.attr,
 	&dev_attr_engine2_leds.attr,
-	NULL
-};
-
-static struct attribute *lp5523_engine3_attributes[] = {
 	&dev_attr_engine3_load.attr,
 	&dev_attr_engine3_leds.attr,
-	NULL
 };
 
 static const struct attribute_group lp5523_group = {
 	.attrs = lp5523_attributes,
 };
 
-static const struct attribute_group lp5523_engine_group[] = {
-	{.attrs = lp5523_engine1_attributes },
-	{.attrs = lp5523_engine2_attributes },
-	{.attrs = lp5523_engine3_attributes },
-};
-
 static int lp5523_register_sysfs(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -788,10 +781,6 @@ static void lp5523_unregister_sysfs(struct i2c_client *client)
 
 	sysfs_remove_group(&dev->kobj, &lp5523_group);
 
-	for (i = 0; i < ARRAY_SIZE(chip->engines); i++)
-		if (chip->engines[i].mode == LP5523_CMD_LOAD)
-			sysfs_remove_group(&dev->kobj, &lp5523_engine_group[i]);
-
 	for (i = 0; i < chip->num_leds; i++)
 		sysfs_remove_group(&chip->leds[i].cdev.dev->kobj,
 				&lp5523_led_attribute_group);
@@ -802,10 +791,6 @@ static void lp5523_unregister_sysfs(struct i2c_client *client)
 /*--------------------------------------------------------------*/
 static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
 {
-	/*  engine to chip */
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-	struct device *dev = &client->dev;
 	int ret = 0;
 
 	/* if in that mode already do nothing, except for run */
@@ -817,18 +802,10 @@ static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
 	} else if (mode == LP5523_CMD_LOAD) {
 		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
 		lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
-
-		ret = sysfs_create_group(&dev->kobj, engine->attributes);
-		if (ret)
-			return ret;
 	} else if (mode == LP5523_CMD_DISABLED) {
 		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
 	}
 
-	/* remove load attribute from sysfs if not in load mode */
-	if (engine->mode == LP5523_CMD_LOAD && mode != LP5523_CMD_LOAD)
-		sysfs_remove_group(&dev->kobj, engine->attributes);
-
 	engine->mode = mode;
 
 	return ret;
@@ -845,7 +822,6 @@ static int __init lp5523_init_engine(struct lp5523_engine *engine, int id)
 	engine->engine_mask = LP5523_ENG_MASK_BASE >> SHIFT_MASK(id);
 	engine->prog_page = id - 1;
 	engine->mux_page = id + 2;
-	engine->attributes = &lp5523_engine_group[id - 1];
 
 	return 0;
 }
-- 
1.7.0.4

