Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1ATXMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:12:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378Ab1ATXMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:12:47 -0500
Date: Thu, 20 Jan 2011 15:12:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Convert bd2802 driver to dev_pm_ops
Message-Id: <20110120151201.8dca7a7e.akpm@linux-foundation.org>
In-Reply-To: <1295559395-28942-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1295559395-28942-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 21:36:35 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> There is a move to deprecate bus-specific PM operations and move to
> using dev_pm_ops instead in order to reduce the amount of boilerplate
> code in buses and facilitiate updates to the PM core. Do this move for
> the bs2802 driver.
> 

CONFIG_PM=n:

drivers/leds/leds-bd2802.c:765: warning: 'bd2802_suspend' defined but not used
drivers/leds/leds-bd2802.c:775: warning: 'bd2802_resume' defined but not used

It would be nice to fix all this via automagic within the
SIMPLE_DEV_PM_OPS() implementation but I can't see a way of doing that :(



--- a/drivers/leds/leds-bd2802.c~leds-convert-bd2802-driver-to-dev_pm_ops-fix
+++ a/drivers/leds/leds-bd2802.c
@@ -319,20 +319,6 @@ static void bd2802_turn_off(struct bd280
 	bd2802_update_state(led, id, color, BD2802_OFF);
 }
 
-static void bd2802_restore_state(struct bd2802_led *led)
-{
-	int i;
-
-	for (i = 0; i < LED_NUM; i++) {
-		if (led->led[i].r)
-			bd2802_turn_on(led, i, RED, led->led[i].r);
-		if (led->led[i].g)
-			bd2802_turn_on(led, i, GREEN, led->led[i].g);
-		if (led->led[i].b)
-			bd2802_turn_on(led, i, BLUE, led->led[i].b);
-	}
-}
-
 #define BD2802_SET_REGISTER(reg_addr, reg_name)				\
 static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
 	struct device_attribute *attr, const char *buf, size_t count)	\
@@ -761,6 +747,22 @@ static int __exit bd2802_remove(struct i
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+static void bd2802_restore_state(struct bd2802_led *led)
+{
+	int i;
+
+	for (i = 0; i < LED_NUM; i++) {
+		if (led->led[i].r)
+			bd2802_turn_on(led, i, RED, led->led[i].r);
+		if (led->led[i].g)
+			bd2802_turn_on(led, i, GREEN, led->led[i].g);
+		if (led->led[i].b)
+			bd2802_turn_on(led, i, BLUE, led->led[i].b);
+	}
+}
+
 static int bd2802_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -785,6 +787,10 @@ static int bd2802_resume(struct device *
 }
 
 static SIMPLE_DEV_PM_OPS(bd2802_pm, bd2802_suspend, bd2802_resume);
+#define BD2802_PM (&bd2802_pm)
+#else		/* CONFIG_PM */
+#define BD2802_PM NULL
+#endif
 
 static const struct i2c_device_id bd2802_id[] = {
 	{ "BD2802", 0 },
@@ -795,7 +801,7 @@ MODULE_DEVICE_TABLE(i2c, bd2802_id);
 static struct i2c_driver bd2802_i2c_driver = {
 	.driver	= {
 		.name	= "BD2802",
-		.pm	= &bd2802_pm,
+		.pm	= BD2802_PM,
 	},
 	.probe		= bd2802_probe,
 	.remove		= __exit_p(bd2802_remove),
_

