Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0LERzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:55:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab0LERvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RoluLqlhORZGqZQPRj1IUf8+y7ZB886Ye1lBtDCJE52QJPvrnY4qy5B9UKJpedpf1b
         12d/LLzN5aYxvu321Vua6UFy7Cmpf79zxy69zQgAYj07EeBHpUiY7G9W03ZtralJsu9n
         iJCvhDqvgLclAsQrK0/MeKa5q4OMOpNsz2qC4=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 27/45] kstrtox: convert drivers/leds/
Date: Sun,  5 Dec 2010 19:49:24 +0200
Message-Id: <1291571382-2719-27-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/leds/leds-bd2802.c  |   10 +++++-----
 drivers/leds/leds-lp5521.c  |    9 +++++----
 drivers/leds/leds-lp5523.c  |   11 ++++++-----
 drivers/leds/leds-netxbig.c |    2 +-
 drivers/leds/leds-ns2.c     |    2 +-
 drivers/leds/leds-ss4200.c  |    4 ++--
 6 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 19dc4b6..4248173 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -338,15 +338,15 @@ static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
 	struct device_attribute *attr, const char *buf, size_t count)	\
 {									\
 	struct bd2802_led *led = i2c_get_clientdata(to_i2c_client(dev));\
-	unsigned long val;						\
+	u8 val;						\
 	int ret;							\
 	if (!count)							\
 		return -EINVAL;						\
-	ret = strict_strtoul(buf, 16, &val);				\
+	ret = kstrtou8(buf, 16, &val);					\
 	if (ret)							\
 		return ret;						\
 	down_write(&led->rwsem);					\
-	bd2802_write_byte(led->client, reg_addr, (u8) val);		\
+	bd2802_write_byte(led->client, reg_addr, val);			\
 	up_write(&led->rwsem);						\
 	return count;							\
 }									\
@@ -502,11 +502,11 @@ static ssize_t bd2802_store_##attr_name(struct device *dev,		\
 	struct device_attribute *attr, const char *buf, size_t count)	\
 {									\
 	struct bd2802_led *led = i2c_get_clientdata(to_i2c_client(dev));\
-	unsigned long val;						\
+	unsigned int val;						\
 	int ret;							\
 	if (!count)							\
 		return -EINVAL;						\
-	ret = strict_strtoul(buf, 16, &val);				\
+	ret = kstrtouint(buf, 16, &val);				\
 	if (ret)							\
 		return ret;						\
 	down_write(&led->rwsem);					\
diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 33facd0..1a3c43d 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -508,11 +508,12 @@ static ssize_t store_current(struct device *dev,
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lp5521_led *led = cdev_to_led(led_cdev);
 	struct lp5521_chip *chip = led_to_lp5521(led);
-	ssize_t ret;
-	unsigned long curr;
+	u8 curr;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &curr))
-		return -EINVAL;
+	ret = kstrtou8(buf, 0, &curr);
+	if (ret < 0)
+		return ret;
 
 	if (curr > led->max_current)
 		return -EINVAL;
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 0cc4ead..c21ee86 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -677,11 +677,12 @@ static ssize_t store_current(struct device *dev,
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lp5523_led *led = cdev_to_led(led_cdev);
 	struct lp5523_chip *chip = led_to_lp5523(led);
-	ssize_t ret;
-	unsigned long curr;
+	u8 curr;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &curr))
-		return -EINVAL;
+	ret = kstrtou8(buf, 0, &curr);
+	if (ret < 0)
+		return ret;
 
 	if (curr > led->max_current)
 		return -EINVAL;
@@ -689,7 +690,7 @@ static ssize_t store_current(struct device *dev,
 	mutex_lock(&chip->lock);
 	ret = lp5523_write(chip->client,
 			LP5523_REG_LED_CURRENT_BASE + led->chan_nr,
-			(u8)curr);
+			curr);
 	mutex_unlock(&chip->lock);
 
 	if (ret < 0)
diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index f2e51c1..b149f30 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -255,7 +255,7 @@ static ssize_t netxbig_led_sata_store(struct device *dev,
 	int mode_val;
 	int ret;
 
-	ret = strict_strtoul(buff, 10, &enable);
+	ret = kstrtoul(buff, 10, &enable);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/leds/leds-ns2.c b/drivers/leds/leds-ns2.c
index f77d48d..4027583 100644
--- a/drivers/leds/leds-ns2.c
+++ b/drivers/leds/leds-ns2.c
@@ -148,7 +148,7 @@ static ssize_t ns2_led_sata_store(struct device *dev,
 	unsigned long enable;
 	enum ns2_led_modes mode;
 
-	ret = strict_strtoul(buff, 10, &enable);
+	ret = kstrtoul(buff, 10, &enable);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
index 614ebeb..56b3ab8 100644
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -457,9 +457,9 @@ static ssize_t nas_led_blink_store(struct device *dev,
 {
 	int ret;
 	struct led_classdev *led = dev_get_drvdata(dev);
-	unsigned long blink_state;
+	u32 blink_state;
 
-	ret = strict_strtoul(buf, 10, &blink_state);
+	ret = kstrtou32(buf, 10, &blink_state);
 	if (ret)
 		return ret;
 
-- 
1.7.2.2

