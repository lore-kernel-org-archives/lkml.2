Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0LQMq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:29 -0500
Received: from smtp.nokia.com ([147.243.128.26]:64448 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab0LQMqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:20 -0500
From: <ilkka.koskinen@nokia.com>
To: <samu.p.onkalo@nokia.com>, <rpurdie@rpsys.net>,
        <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <arun.murthy@stericsson.com>,
        <ankur.vaish@stericsson.com>
Subject: RE: [PATCH 3/3] leds: lp5521: Fix circular locking
Thread-Topic: [PATCH 3/3] leds: lp5521: Fix circular locking
Thread-Index: AQHLndPuFqZk+DyiBEmPI+o0lrkPsJOkkydg
Date: Fri, 17 Dec 2010 12:45:29 +0000
Message-ID: <B152A2ECB7F1E847B5E0A8CFDF6F369002E1F2@008-AM1MPN1-022.mgdnok.nokia.com>
References: <1292581161-1177-1-git-send-email-samu.p.onkalo@nokia.com>
 <1292581161-1177-4-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1292581161-1177-4-git-send-email-samu.p.onkalo@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 17 Dec 2010 12:45:32.0370 (UTC) FILETIME=[4AD5F320:01CB9DE8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>From: Samu Onkalo [mailto:samu.p.onkalo@nokia.com]
>Sent: 17 December, 2010 12:19
>Subject: [PATCH 3/3] leds: lp5521: Fix circular locking
>
>Driver contained possibility for circular locking.
>One lock is held by sysfs-core and another one by the driver itself.
>This happened when the driver created or removed sysfs entries
>dynamically.
>There is no real need to do those operations. Now all the sysfs entries
>are created at probe and removed at removal. Engine load sysfs entries
>are
>now visible all the time. However, access to the entries fails if
>the engine is disabled or running.
>
>Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>

Reviewed-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>


>---
> drivers/leds/leds-lp5521.c |   52 ++++++-------------------------------
>------
> 1 files changed, 8 insertions(+), 44 deletions(-)
>
>diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
>index 745ad99..eda99b9 100644
>--- a/drivers/leds/leds-lp5521.c
>+++ b/drivers/leds/leds-lp5521.c
>@@ -98,7 +98,6 @@
> #define LP5521_EXT_CLK_USED		0x08
>
> struct lp5521_engine {
>-	const struct attribute_group *attributes;
> 	int		id;
> 	u8		mode;
> 	u8		prog_page;
>@@ -225,25 +224,22 @@ static int lp5521_set_led_current(struct
>lp5521_chip *chip, int led, u8 curr)
> 		    curr);
> }
>
>-static void lp5521_init_engine(struct lp5521_chip *chip,
>-			const struct attribute_group *attr_group)
>+static void lp5521_init_engine(struct lp5521_chip *chip)
> {
> 	int i;
> 	for (i = 0; i < ARRAY_SIZE(chip->engines); i++) {
> 		chip->engines[i].id = i + 1;
> 		chip->engines[i].engine_mask = LP5521_ENG_MASK_BASE >> (i *
>2);
> 		chip->engines[i].prog_page = i;
>-		chip->engines[i].attributes = &attr_group[i];
> 	}
> }
>
>-static int lp5521_configure(struct i2c_client *client,
>-			const struct attribute_group *attr_group)
>+static int lp5521_configure(struct i2c_client *client)
> {
> 	struct lp5521_chip *chip = i2c_get_clientdata(client);
> 	int ret;
>
>-	lp5521_init_engine(chip, attr_group);
>+	lp5521_init_engine(chip);
>
> 	/* Set all PWMs to direct control mode */
> 	ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);
>@@ -329,9 +325,6 @@ static int lp5521_detect(struct i2c_client *client)
> /* Set engine mode and create appropriate sysfs attributes, if
>required. */
> static int lp5521_set_mode(struct lp5521_engine *engine, u8 mode)
> {
>-	struct lp5521_chip *chip = engine_to_lp5521(engine);
>-	struct i2c_client *client = chip->client;
>-	struct device *dev = &client->dev;
> 	int ret = 0;
>
> 	/* if in that mode already do nothing, except for run */
>@@ -343,18 +336,10 @@ static int lp5521_set_mode(struct lp5521_engine
>*engine, u8 mode)
> 	} else if (mode == LP5521_CMD_LOAD) {
> 		lp5521_set_engine_mode(engine, LP5521_CMD_DISABLED);
> 		lp5521_set_engine_mode(engine, LP5521_CMD_LOAD);
>-
>-		ret = sysfs_create_group(&dev->kobj, engine->attributes);
>-		if (ret)
>-			return ret;
> 	} else if (mode == LP5521_CMD_DISABLED) {
> 		lp5521_set_engine_mode(engine, LP5521_CMD_DISABLED);
> 	}
>
>-	/* remove load attribute from sysfs if not in load mode */
>-	if (engine->mode == LP5521_CMD_LOAD && mode != LP5521_CMD_LOAD)
>-		sysfs_remove_group(&dev->kobj, engine->attributes);
>-
> 	engine->mode = mode;
>
> 	return ret;
>@@ -387,7 +372,10 @@ static int lp5521_do_store_load(struct
>lp5521_engine *engine,
> 		goto fail;
>
> 	mutex_lock(&chip->lock);
>-	ret = lp5521_load_program(engine, pattern);
>+	if (engine->mode == LP5521_CMD_LOAD)
>+		ret = lp5521_load_program(engine, pattern);
>+	else
>+		ret = -EINVAL;
> 	mutex_unlock(&chip->lock);
>
> 	if (ret) {
>@@ -574,20 +562,8 @@ static struct attribute *lp5521_attributes[] = {
> 	&dev_attr_engine2_mode.attr,
> 	&dev_attr_engine3_mode.attr,
> 	&dev_attr_selftest.attr,
>-	NULL
>-};
>-
>-static struct attribute *lp5521_engine1_attributes[] = {
> 	&dev_attr_engine1_load.attr,
>-	NULL
>-};
>-
>-static struct attribute *lp5521_engine2_attributes[] = {
> 	&dev_attr_engine2_load.attr,
>-	NULL
>-};
>-
>-static struct attribute *lp5521_engine3_attributes[] = {
> 	&dev_attr_engine3_load.attr,
> 	NULL
> };
>@@ -596,12 +572,6 @@ static const struct attribute_group lp5521_group =
>{
> 	.attrs = lp5521_attributes,
> };
>
>-static const struct attribute_group lp5521_engine_group[] = {
>-	{.attrs = lp5521_engine1_attributes },
>-	{.attrs = lp5521_engine2_attributes },
>-	{.attrs = lp5521_engine3_attributes },
>-};
>-
> static int lp5521_register_sysfs(struct i2c_client *client)
> {
> 	struct device *dev = &client->dev;
>@@ -616,12 +586,6 @@ static void lp5521_unregister_sysfs(struct
>i2c_client *client)
>
> 	sysfs_remove_group(&dev->kobj, &lp5521_group);
>
>-	for (i = 0; i <  ARRAY_SIZE(chip->engines); i++) {
>-		if (chip->engines[i].mode == LP5521_CMD_LOAD)
>-			sysfs_remove_group(&dev->kobj,
>-					chip->engines[i].attributes);
>-	}
>-
> 	for (i = 0; i < chip->num_leds; i++)
> 		sysfs_remove_group(&chip->leds[i].cdev.dev->kobj,
> 				&lp5521_led_attribute_group);
>@@ -724,7 +688,7 @@ static int lp5521_probe(struct i2c_client *client,
>
> 	dev_info(&client->dev, "%s programmable led chip found\n", id-
>>name);
>
>-	ret = lp5521_configure(client, lp5521_engine_group);
>+	ret = lp5521_configure(client);
> 	if (ret < 0) {
> 		dev_err(&client->dev, "error configuring chip\n");
> 		goto fail2;
>--
>1.7.0.4

