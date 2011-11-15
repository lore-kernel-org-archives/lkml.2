Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab1KOXn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:43:29 -0500
Received: from moh1-ve1.go2.pl ([193.17.41.131]:35062 "EHLO moh1-ve1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab1KOXn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:43:28 -0500
Message-ID: <4EC2F914.4010302@o2.pl>
Date: Wed, 16 Nov 2011 00:43:16 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111101 Thunderbird/7.0.1
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Glindkamp <christian.glindkamp@taskit.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH][W1]w1_therm: release the bus during conversion on externally
 powered devices
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 63
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

w1_therm devices can either be bus powered or externally powered.

When device is bus powered during temperature conversion the bus
have to be left high to provide necessary power. Some masters also allow
strong power-up to be enabled in this case.
Naturally, no communication over bus can occur during that time.

However, if device has external power then there is no such restriction,
and host can talk to other devices during temperature conversion.

There is command which allows us to check how device is powered,
this patch uses it to release the bus on externally w1_therm powered devices
during temperature conversion.

Also, this changes uninterruptible sleeps there into interruptible ones to
avoid long uninterruptible sleep if w1 subsystem happens to grab bus for
scan during w1_therm_read().

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index a1ef9b5..ff29ae7 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -175,11 +175,13 @@ static ssize_t w1_therm_read(struct device *device,
 {
 	struct w1_slave *sl = dev_to_w1_slave(device);
 	struct w1_master *dev = sl->master;
-	u8 rom[9], crc, verdict;
+	u8 rom[9], crc, verdict, external_power;
 	int i, max_trying = 10;
 	ssize_t c = PAGE_SIZE;
 
-	mutex_lock(&dev->mutex);
+	i = mutex_lock_interruptible(&dev->mutex);
+	if (i != 0)
+		return i;
 
 	memset(rom, 0, sizeof(rom));
 
@@ -190,13 +192,37 @@ static ssize_t w1_therm_read(struct device *device,
 		if (!w1_reset_select_slave(sl)) {
 			int count = 0;
 			unsigned int tm = 750;
+			unsigned long sleep_rem;
+
+			w1_write_8(dev, W1_READ_PSUPPLY);
+			external_power = w1_read_8(dev);
+
+			if (w1_reset_select_slave(sl))
+				continue;
 
 			/* 750ms strong pullup (or delay) after the convert */
-			if (w1_strong_pullup)
+			if (!external_power && w1_strong_pullup)
 				w1_next_pullup(dev, tm);
+
 			w1_write_8(dev, W1_CONVERT_TEMP);
-			if (!w1_strong_pullup)
-				msleep(tm);
+
+			if (external_power) {
+				mutex_unlock(&dev->mutex);
+
+				sleep_rem = msleep_interruptible(tm);
+				if (sleep_rem != 0)
+					return -EINTR;
+
+				i = mutex_lock_interruptible(&dev->mutex);
+				if (i != 0)
+					return i;
+			} else if (!w1_strong_pullup) {
+				sleep_rem = msleep_interruptible(tm);
+				if (sleep_rem != 0) {
+					mutex_unlock(&dev->mutex);
+					return -EINTR;
+				}
+			}
 
 			if (!w1_reset_select_slave(sl)) {
 


