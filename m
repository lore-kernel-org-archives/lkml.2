Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2EUHwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:52:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2EUHwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:52:53 -0400
From: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
To: <linus.walleij@stericsson.com>, <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
Subject: [PATCH-RESEND] GPIO/TCA6424: merge I2C transactions, remove cast
Date: Mon, 21 May 2012 09:52:43 +0200
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-KSE-AntiSpam-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean
Message-Id: <0LrHzA-1S4duI0urs-013Ke8@mrelayeu.kundenserver.de>
X-Provags-ID: V02:K0:JV6C32xwtonkZi0Sm6yKAG9+GBYQ6Zsm99OmXoqsPUc
 INprDxWqioI0HA6yAtBUKU3jmEydy0zIjOuhejlJL7toemHbCe
 Zl7P42/DSm3IkWKul5hOwxR+30fG1cPTE7iUVVa2XdyTEl6pwf
 +7DSSoOT8Gwi88HXeki+nryZMJM0YVJ6MIx1gXyJL58mbo+Vky
 wL+6ytCInDJpIbBFpKy+Ql5/Mdg+aYtxx4UBqd8PPMsOndZTTr
 qAcjV4+sa4zVn228A2sILANtDcIq8DMxY24vz4WFl1h3c/ZRaJ
 flGJW9823njJRa+gw/4fmjIDeRlJDBG57yV3CwtgP9y204+YVc
 UCS7uZGi8UBWS6j2j4w9Y2hO0yWjLNZ8fD+BNoMkFNt84oxT7/
 NRBm9Vwm72lzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow-up to "[PATCH v2] Add support for TCA6424":
- Use 3 byte transfers instead of two separate transfers (2+1 byte)
- An unnecessary cast removed

Signed-off-by: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>

---
 drivers/gpio/gpio-pca953x.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 1c313c7..5eee524 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -98,12 +98,11 @@ static int pca953x_write_reg(struct pca953x_chip *chip, int reg, u32 val)
 	if (chip->gpio_chip.ngpio <= 8)
 		ret = i2c_smbus_write_byte_data(chip->client, reg, val);
 	else if (chip->gpio_chip.ngpio == 24) {
-		ret = i2c_smbus_write_word_data(chip->client,
+		cpu_to_le32s(&val);
+		ret = i2c_smbus_write_i2c_block_data(chip->client,
 						(reg << 2) | REG_ADDR_AI,
-						val & 0xffff);
-		ret = i2c_smbus_write_byte_data(chip->client,
-						(reg << 2) + 2,
-						(val & 0xff0000) >> 16);
+						3,
+						(u8 *) &val);
 	}
 	else {
 		switch (chip->chip_type) {
@@ -135,22 +134,27 @@ static int pca953x_read_reg(struct pca953x_chip *chip, int reg, u32 *val)
 {
 	int ret;
 
-	if (chip->gpio_chip.ngpio <= 8)
+	if (chip->gpio_chip.ngpio <= 8) {
 		ret = i2c_smbus_read_byte_data(chip->client, reg);
+		*val = ret;
+	}
 	else if (chip->gpio_chip.ngpio == 24) {
-		ret =  i2c_smbus_read_word_data(chip->client, reg << 2);
-		ret |= (i2c_smbus_read_byte_data(chip->client,
-						 (reg << 2) + 2)<<16);
+		*val = 0;
+		ret = i2c_smbus_read_i2c_block_data(chip->client,
+						(reg << 2) | REG_ADDR_AI,
+						3,
+						(u8 *) val);
+		le32_to_cpus(val);
-	}
-	else
+	} else {
 		ret = i2c_smbus_read_word_data(chip->client, reg << 1);
+		*val = ret;
+	}
 
 	if (ret < 0) {
 		dev_err(&chip->client->dev, "failed reading register\n");
 		return ret;
 	}
 
-	*val = (u32)ret;
 	return 0;
 }
 
-- 
1.7.3.4

