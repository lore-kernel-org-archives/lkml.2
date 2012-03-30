Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab2C3Sl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:41:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab2C3SlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:41:24 -0400
Date: Fri, 30 Mar 2012 11:41:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geon Si Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] leds: Add LED driver for lm3556 chip
Message-Id: <20120330114122.be769e8a.akpm@linux-foundation.org>
In-Reply-To: <1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
References: <1333089508-8501-1-git-send-email-gshark.jeong@gmail.com>
	<1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 15:38:28 +0900
Geon Si Jeong <gshark.jeong@gmail.com> wrote:

> It is a simple driver for LM3556 Chip(Texas Instruments)
> LM3556 :
> The LM3556 is a 4 MHz fixed-frequency synchronous boost
> converter plus 1.5A constant current driver for a high-current white LED.
> Datasheet: www.national.com/ds/LM/LM3556.pdf

It needs this to build on x86_64:

--- a/drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-fix-2
+++ a/drivers/leds/leds-lm3556.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/leds.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/types.h>


And here are some fixes for problems which were detected by checkpatch.
Please use checkpatch.  Please review and test this change:

--- a/drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
+++ a/drivers/leds/leds-lm3556.c
@@ -141,7 +141,7 @@ static struct indicator indicator_patter
 };
 
 /* i2c access*/
-int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * val)
+int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 *val)
 {
 	int ret;
 	struct lm3556_chip_data *chip = i2c_get_clientdata(client);
@@ -317,12 +317,15 @@ static ssize_t lm3556_indicator_pattern_
 					      const char *buf, size_t size)
 {
 	char *after;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
 	struct i2c_client *client = container_of(dev->parent,
 						 struct i2c_client, dev);
-	unsigned long state = simple_strtoul(buf, &after, 10);
+	unsigned long state;
 	size_t count = after - buf;
 
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto out;
 	if (isspace(*after))
 		count++;
 
@@ -336,6 +339,7 @@ static ssize_t lm3556_indicator_pattern_
 		lm3556_write_reg(client, REG_INDIC_PERIOD,
 				 indicator_pattern[state].period_cnt);
 	}
+out:
 	return ret;
 }
 


