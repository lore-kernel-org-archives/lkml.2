Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2HUJEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:04:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37965 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab2HUJES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:04:18 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: [PATCH 4/4] leds-lp5523: minor code style fixes
Thread-Topic: [PATCH 4/4] leds-lp5523: minor code style fixes
Thread-Index: Ac1/e+hY+x58zKHsRg607HRYQRJlJQ==
Date: Tue, 21 Aug 2012 09:04:02 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF0AFE@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(a) use LP5523_ENABLE rather than magic number 0x40
(b) use min_t() in lp5523_mux_parse()
(c) skip while loop and just return if invalid command

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index f8231f1..64ba8b2 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -177,7 +177,7 @@ static int lp5523_detect(struct i2c_client *client)
 	int ret;
 	u8 buf;
 
-	ret = lp5523_write(client, LP5523_REG_ENABLE, 0x40);
+	ret = lp5523_write(client, LP5523_REG_ENABLE, LP5523_ENABLE);
 	if (ret)
 		return ret;
 	ret = lp5523_read(client, LP5523_REG_ENABLE, &buf);
@@ -338,7 +338,8 @@ static int lp5523_mux_parse(const char *buf, u16 *mux, size_t len)
 {
 	int i;
 	u16 tmp_mux = 0;
-	len = len < LP5523_LEDS ? len : LP5523_LEDS;
+
+	len = min_t(int, len, LP5523_LEDS);
 	for (i = 0; i < len; i++) {
 		switch (buf[i]) {
 		case '1':
@@ -546,6 +547,9 @@ static int lp5523_do_store_load(struct lp5523_engine *engine,
 	unsigned cmd;
 	u8 pattern[LP5523_PROGRAM_LENGTH] = {0};
 
+	if (engine->mode != LP5523_CMD_LOAD)
+		return -EINVAL;
+
 	while ((offset < len - 1) && (i < LP5523_PROGRAM_LENGTH)) {
 		/* separate sscanfs because length is working only for %s */
 		ret = sscanf(buf + offset, "%2s%n ", c, &nrchars);
@@ -563,12 +567,7 @@ static int lp5523_do_store_load(struct lp5523_engine *engine,
 		goto fail;
 
 	mutex_lock(&chip->lock);
-
-	if (engine->mode == LP5523_CMD_LOAD)
-		ret = lp5523_load_program(engine, pattern);
-	else
-		ret = -EINVAL;
-
+	ret = lp5523_load_program(engine, pattern);
 	mutex_unlock(&chip->lock);
 
 	if (ret) {
-- 
1.7.2.5


Best Regards,
Milo


