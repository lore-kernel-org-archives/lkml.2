Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2DDLW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:22:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20815 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2DDLW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:22:58 -0400
Date: Wed, 4 Apr 2012 14:22:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] leds: lm3556: fix fallout from checkpatch fixes
Message-ID: <20120404112240.GC23719@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F7C2F08.0035,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 476b78f277 "leds-add-led-driver-for-lm3556-chip-checkpatch-fixes"
introduces a bug where we use "after" without initializing it.

In the original code, "count" and "after" were used to tell if
simple_strtoul() found a valid number.  Now that we've changed it to
kstrtoul(), we can just get rid of both variables.  It makes the whole
function simpler.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/leds/leds-lm3556.c b/drivers/leds/leds-lm3556.c
index 64e751c..886a5d3 100644
--- a/drivers/leds/leds-lm3556.c
+++ b/drivers/leds/leds-lm3556.c
@@ -316,31 +316,23 @@ static ssize_t lm3556_indicator_pattern_store(struct device *dev,
 					      struct device_attribute *devAttr,
 					      const char *buf, size_t size)
 {
-	char *after;
-	ssize_t ret;
 	struct i2c_client *client = container_of(dev->parent,
 						 struct i2c_client, dev);
 	unsigned long state;
-	size_t count = after - buf;
+	int ret;
 
 	ret = kstrtoul(buf, 10, &state);
 	if (ret)
 		goto out;
-	if (isspace(*after))
-		count++;
-
-	if (count == size) {
-		ret = count;
-
-		if (state > INDIC_PATTERN_SIZE - 1)
-			state = INDIC_PATTERN_SIZE - 1;
-		lm3556_write_reg(client, REG_INDIC_BLINK,
-				 indicator_pattern[state].blinking);
-		lm3556_write_reg(client, REG_INDIC_PERIOD,
-				 indicator_pattern[state].period_cnt);
-	}
+
+	if (state > INDIC_PATTERN_SIZE - 1)
+		state = INDIC_PATTERN_SIZE - 1;
+	lm3556_write_reg(client, REG_INDIC_BLINK,
+			 indicator_pattern[state].blinking);
+	lm3556_write_reg(client, REG_INDIC_PERIOD,
+			 indicator_pattern[state].period_cnt);
 out:
-	return ret;
+	return size;
 }
 
 static DEVICE_ATTR(pattern, 0644, NULL, lm3556_indicator_pattern_store);
