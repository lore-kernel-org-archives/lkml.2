Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1DPIoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:44:23 -0400
Received: from wnohang.net ([178.79.154.173]:50300 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab1DPIoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:44:22 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 795C334870
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net C25E23486D
Date: Sat, 16 Apr 2011 14:14:17 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] FIX: Check the return value before proceeding
Message-ID: <20110416084417.GA27829@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20110416083730.GA5114@Xye>
X-Operating-System: Arch linux x86_64 2.6.38.2-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of failure from lp5521_read, an uninitialized mode is passed to lp5521_write.
This adds checks to prevent that.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
  drivers/leds/leds-lp5521.c |   40 ++++++++++++++++++++++------------------
  1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 6c5eac0..f03a524 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -176,7 +176,7 @@ static int lp5521_set_engine_mode(struct lp5521_engine *engine, u8 mode)
  
  	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
  
-	if (ret == 0){
+	if (!ret){
  	/* set mode only for this engine */
  		engine_state &= ~(engine->engine_mask);
  		mode &= engine->engine_mask;
@@ -192,6 +192,7 @@ static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
  	struct lp5521_chip *chip = engine_to_lp5521(eng);
  	struct i2c_client *client = chip->client;
  	int ret;
+	int ret_read;
  	int addr;
  	u8 mode;
  
@@ -199,23 +200,26 @@ static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
  	ret = lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
  	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
  	usleep_range(1000, 2000);
-	ret |= lp5521_read(client, LP5521_REG_OP_MODE, &mode);
-
-	/* For loading, all the engines to load mode */
-	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
-	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
-	usleep_range(1000, 2000);
-	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_LOAD);
-	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
-	usleep_range(1000, 2000);
-
-	addr = LP5521_PROG_MEM_BASE + eng->prog_page * LP5521_PROG_MEM_SIZE;
-	i2c_smbus_write_i2c_block_data(client,
-				addr,
-				LP5521_PROG_MEM_SIZE,
-				pattern);
-
-	ret |= lp5521_write(client, LP5521_REG_OP_MODE, mode);
+	ret_read = lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	ret |= ret_read;
+
+	if (!ret_read){
+		/* For loading, all the engines to load mode */
+		lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
+		/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
+		usleep_range(1000, 2000);
+		lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_LOAD);
+		/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
+		usleep_range(1000, 2000);
+
+		addr = LP5521_PROG_MEM_BASE + eng->prog_page * LP5521_PROG_MEM_SIZE;
+		i2c_smbus_write_i2c_block_data(client,
+					addr,
+					LP5521_PROG_MEM_SIZE,
+					pattern);
+
+		ret |= lp5521_write(client, LP5521_REG_OP_MODE, mode);
+	}
  	return ret;
  }
  
-- 
1.7.4.4

--------------------------
Raghavendra Prabhu
GPG Id : D72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977

