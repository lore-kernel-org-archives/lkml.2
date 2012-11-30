Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769069Ab2K3TTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:19:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:58623 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992800Ab2K3S4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>, Milo <Milo.Kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 05/56] drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
Date: Fri, 30 Nov 2012 10:54:57 -0800
Message-Id: <20121130185118.896569929@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 5bc9ad774c063f6b41965e7314f2c26aa5e465a0 upstream.

Gcc 4.6.2 complains that:

  drivers/leds/leds-lp5521.c: In function `lp5521_load_program':
  drivers/leds/leds-lp5521.c:214:21: warning: `mode' may be used uninitialized in this function [-Wuninitialized]
  drivers/leds/leds-lp5521.c: In function `lp5521_probe':
  drivers/leds/leds-lp5521.c:788:5: warning: `buf' may be used uninitialized in this function [-Wuninitialized]
  drivers/leds/leds-lp5521.c:740:6: warning: `ret' may be used uninitialized in this function [-Wuninitialized]

These are real problems if lp5521_read() returns an error.  When that
happens we should handle it, instead of ignoring it or doing a bitwise
OR with all the other error codes and continuing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Milo <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-lp5521.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -193,9 +193,14 @@ static int lp5521_load_program(struct lp
 
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
@@ -211,8 +216,7 @@ static int lp5521_load_program(struct lp
 				LP5521_PROG_MEM_SIZE,
 				pattern);
 
-	ret |= lp5521_write(client, LP5521_REG_OP_MODE, mode);
-	return ret;
+	return lp5521_write(client, LP5521_REG_OP_MODE, mode);
 }
 
 static int lp5521_set_led_current(struct lp5521_chip *chip, int led, u8 curr)
@@ -785,7 +789,7 @@ static int __devinit lp5521_probe(struct
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
 	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
-	if (buf != LP5521_REG_R_CURR_DEFAULT) {
+	if (ret || buf != LP5521_REG_R_CURR_DEFAULT) {
 		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
 	}


