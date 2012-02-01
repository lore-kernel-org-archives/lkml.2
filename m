Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2BAOkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:40:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61417 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2BAOkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:40:43 -0500
Date: Wed, 1 Feb 2012 17:40:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Richard Purdie <rpurdie@rpsys.net>, Kim@elgon.mountain,
        Milo <Milo.Kim@ti.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
Message-ID: <20120201144019.GB5359@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F294EE1.0015,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc 4.6.2 complains that:
drivers/leds/leds-lp5521.c: In function ‘lp5521_load_program’:
drivers/leds/leds-lp5521.c:214:21: warning: ‘mode’ may be used uninitialized in this function [-Wuninitialized]
drivers/leds/leds-lp5521.c: In function ‘lp5521_probe’:
drivers/leds/leds-lp5521.c:788:5: warning: ‘buf’ may be used uninitialized in this function [-Wuninitialized]
drivers/leds/leds-lp5521.c:740:6: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized]

These are real problems if lp5521_read() returns an error.  When that
happens we should handle it, instead of ignoring it or doing a bitwise
OR with all the other error codes and continuing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index de7b8fe..2381562 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -193,9 +193,14 @@ static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
 
 	/* move current engine to direct mode and remember the state */
 	ret = lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
+	if (ret)
+		return ret;
+
 	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
 	usleep_range(1000, 2000);
-	ret |= lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	ret = lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	if (ret)
+		return ret;
 
 	/* For loading, all the engines to load mode */
 	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
@@ -211,8 +216,7 @@ static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
 				LP5521_PROG_MEM_SIZE,
 				pattern);
 
-	ret |= lp5521_write(client, LP5521_REG_OP_MODE, mode);
-	return ret;
+	return lp5521_write(client, LP5521_REG_OP_MODE, mode);
 }
 
 static int lp5521_set_led_current(struct lp5521_chip *chip, int led, u8 curr)
@@ -784,8 +788,8 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	 * otherwise further access to the R G B channels in the
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
-	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
-	if (buf != LP5521_REG_R_CURR_DEFAULT) {
+	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	if (ret || buf != LP5521_REG_R_CURR_DEFAULT) {
 		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
 	}
