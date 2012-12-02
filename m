Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2LBR3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 12:29:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab2LBR3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 12:29:44 -0500
Date: Sun, 2 Dec 2012 20:29:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] leds: leds-lp5521: return an error code on error in probe()
Message-ID: <20121202172930.GA21835@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354418247.7995.49.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "buf" wasn't equal to LP5521_REG_R_CURR_DEFAULT the probe fails but
we still return zero.  I've changed it to print an error message and
return -EINVAL.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 2bee6b9..cb8a522 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -788,10 +788,17 @@ static int lp5521_probe(struct i2c_client *client,
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
 	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
-	if (ret || buf != LP5521_REG_R_CURR_DEFAULT) {
+	if (ret) {
 		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
 	}
+	if (buf != LP5521_REG_R_CURR_DEFAULT) {
+		dev_err(&client->dev,
+			"unexpected data in register (expected 0x%x got 0x%x)\n",
+			LP5521_REG_R_CURR_DEFAULT, buf);
+		ret = -EINVAL;
+		goto fail2;
+	}
 	usleep_range(10000, 20000);
 
 	ret = lp5521_detect(client);
