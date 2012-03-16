Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023Ab2CPNf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:35:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65031 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826Ab2CPNfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:35:54 -0400
Message-ID: <1331904943.2891.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: pcf50633: Don't write to reserved bits
 of AUTO output voltage select register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 16 Mar 2012 21:35:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The datasheet says 00000000 to 00101110 are reserved, and the min value of the
voltage setting is 1.8 V.
Thus don't write 0 to AUTO output voltage select register (address 1Ah).

Table 50. AUTOOUT - AUTO output voltage select register (address 1Ah) bit description[1]
Bit Symbol Access Description
7:0 auto_out R/W VO(prog) = 0.625 + auto_out × 0.025 V
eg. 00000000 to 00101110: reserved
00101111: 1.8 V (min)
01010011: 2.7 V
01101010: 3.275 V
01101011: 3.300 V
01101100: 3.325 V
01111111 : 3.800 V (max)
..... .....
11111110 : 3.800 V
11111111 : 3.800 V

This patch also fixes a bug in pcf50633_regulator_list_voltage.
It is wrong to do "index += 0x2f" for PCF50633_REGULATOR_AUTO in
pcf50633_regulator_list_voltage. The purpose of adding 0x2f to index is because
current code return 0 in auto_voltage_bits when millivolts < 1800.
For millivolts > 1800, adding 0x2f to index is wrong.

We should handle this by
return -EINVAL if the selector is in the reserved range of AUTOOUT.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcf50633-regulator.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 6db46c6..3cefc63 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -52,7 +52,7 @@ static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
 static u8 auto_voltage_bits(unsigned int millivolts)
 {
 	if (millivolts < 1800)
-		return 0;
+		return 0x2f;
 	if (millivolts > 3800)
 		return 0xff;
 
@@ -87,9 +87,6 @@ static u8 ldo_voltage_bits(unsigned int millivolts)
 /* Obtain voltage value from bits */
 static unsigned int auto_voltage_value(u8 bits)
 {
-	if (bits < 0x2f)
-		return 0;
-
 	return 625 + (bits * 25);
 }
 
@@ -161,6 +158,9 @@ static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
 
 	switch (id) {
 	case PCF50633_REGULATOR_AUTO:
+		/* AUTOOUT: 00000000 to 00101110 are reserved */
+		if (bits < 0x2f)
+			return -EINVAL;
 		millivolts = auto_voltage_value(bits);
 		break;
 	case PCF50633_REGULATOR_DOWN1:
@@ -208,20 +208,7 @@ static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
 static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
 						unsigned int index)
 {
-	struct pcf50633 *pcf;
-	int regulator_id;
-
-	pcf = rdev_get_drvdata(rdev);
-
-	regulator_id = rdev_get_id(rdev);
-
-	switch (regulator_id) {
-	case PCF50633_REGULATOR_AUTO:
-		index += 0x2f;
-		break;
-	default:
-		break;
-	}
+	int regulator_id = rdev_get_id(rdev);
 
 	return pcf50633_regulator_voltage_value(regulator_id, index);
 }
-- 
1.7.5.4



