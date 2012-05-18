Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2ERPBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:01:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2ERPBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:01:40 -0400
From: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
Organization: 3ality Technica
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] GPIO/TCA6424: merge I2C transactions, remove cast
Date: Fri, 18 May 2012 17:01:36 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-KSE-AntiSpam-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean
Message-Id: <0M9AKX-1SNwZq1JrJ-00CWsH@mrelayeu.kundenserver.de>
X-Provags-ID: V02:K0:rL+oZ4knJHnaQcnObTzjVLPso3bNe7fDARWhq98MxFV
 m/UhaoELolTX5CIB2TU2vJ4GtnnPebkIayQB+5RwH6ynCx7qGC
 LSwYnGz5ZAEWlj2auvi2m1p2xVeEztQoVuGI3/+fA3xEWZAuGf
 YABwNBxSZFru7DZxurD1gwDwcXjepC093TT6847uVbAyrpkCs1
 rDwqgM16tkBw76czWzJWQyzWLYbBBAF0T8cCizKnNbd692jwF4
 UL0mHCvz1E6j43rNJQ3RrvfbzjQymrfHZhlJyBcdL/UpVw2ZoY
 YiOpnoCzxbX1+luQkEvyIitnUP+QGW3InJodGyFm4HCAH+bMWz
 WHryQiOeyGoecocWANk9TICbnmuCY2LQss/9dHgKoxNcBL9eJ6
 VBi7pZug0Vebg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1a80280e20dfef57c6bc6429e5bdf7e10d10fda9 Mon Sep 17 00:00:00 2001
From: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
Date: Fri, 18 May 2012 16:20:31 +0200
Subject: [PATCH] GPIO/TCA6424: merge I2C transactions, remove cast

This is a follow-up to "[PATCH v2] Add support for TCA6424":
- Use 3 byte transfers instead of two separate transfers (2+1 byte)
- An unnecessary cast removed

Please check especially if endianness conversion is done the way it should be.

Signed-off-by: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>

---
 drivers/gpio/gpio-pca953x.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 1c313c7..5eee524 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -98,12 +98,11 @@ static int pca953x_write_reg(struct pca953x_chip *chip, 
int reg, u32 val)
        if (chip->gpio_chip.ngpio <= 8)
                ret = i2c_smbus_write_byte_data(chip->client, reg, val);
        else if (chip->gpio_chip.ngpio == 24) {
-               ret = i2c_smbus_write_word_data(chip->client,
+               cpu_to_le32s(&val);
+               ret = i2c_smbus_write_i2c_block_data(chip->client,
                                                (reg << 2) | REG_ADDR_AI,
-                                               val & 0xffff);
-               ret = i2c_smbus_write_byte_data(chip->client,
-                                               (reg << 2) + 2,
-                                               (val & 0xff0000) >> 16);
+                                               3,
+                                               (u8 *) &val);
        }
        else {
                switch (chip->chip_type) {
@@ -135,22 +134,28 @@ static int pca953x_read_reg(struct pca953x_chip *chip, 
int reg, u32 *val)
 {
        int ret;
 
-       if (chip->gpio_chip.ngpio <= 8)
+       if (chip->gpio_chip.ngpio <= 8) {
                ret = i2c_smbus_read_byte_data(chip->client, reg);
+               *val = ret;
+       }
        else if (chip->gpio_chip.ngpio == 24) {
-               ret =  i2c_smbus_read_word_data(chip->client, reg << 2);
-               ret |= (i2c_smbus_read_byte_data(chip->client,
-                                                (reg << 2) + 2)<<16);
+               *val = 0;
+               ret = i2c_smbus_read_i2c_block_data(chip->client,
+                                               (reg << 2) | REG_ADDR_AI,
+                                               3,
+                                               (u8 *) val);
+               le32_to_cpus(val);
        }
-       else
+       else {
                ret = i2c_smbus_read_word_data(chip->client, reg << 1);
+               *val = ret;
+       }
 
        if (ret < 0) {
                dev_err(&chip->client->dev, "failed reading register\n");
                return ret;
        }
 
-       *val = (u32)ret;
        return 0;
 }
 
-- 
1.7.3.4
