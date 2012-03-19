Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2CSCze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:55:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40407 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2CSCzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:55:33 -0400
Message-ID: <1332125724.17246.1.camel@phoenix>
Subject: [PATCH v3 1/2] regulator: pcf50633: Don't write to reserved bits of
 AUTO output voltage select register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 19 Mar 2012 10:55:24 +0800
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

This patch also fixes a bug in pcf50633_regulator_list_voltage:
In regulator core _regulator_do_set_voltage function:

        if (rdev->desc->ops->set_voltage) {
                ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
                                                   &selector);

                if (rdev->desc->ops->list_voltage)
                        selector = rdev->desc->ops->list_voltage(rdev,
                                                                 selector);
                else
                        selector = -1;

The list_voltage call here takes the selector got from set_voltage callback.
Thus adding 0x2f to the index in pcf50633_regulator_list_voltage looks wrong to me.

e.g.
If min_uV < 1.8V, pcf50633_regulator_set_voltage sets 0 to selector.
For this case, adding 0x2f to the index in pcf50633_regulator_list_voltage is correct.
However, if min_uV == 1.8V, pcf50633_regulator_set_voltage sets 0x2f to selector.
Adding 0x2f to the index in pcf50633_regulator_list_voltage in this case is wrong.

What this patch does is:
The minimal voltage setting for AUTOOUT is 0x2f.
Thus for the case min_uV < 1.8, set the voltage setting to 1.8V by writting
0x2f to AUTOOUT register and set selector = 0x2f.
So we don't write the rserved range to AUTOOUT register.
Which means the possible range of AUTOOUT register value is 0x2f ~ 0xff.

We have no problem in regulator_get_voltage.
Since we won't write 0~0x2e to AUTOOUT register, we have no problem converting
the bits we read to voltage. The equation in auto_voltage_value works fine.

For list_voltage, we need to take into account the case selector is 0 ~ 0x2e
because the regulator core assumes the selector is starting from 0.
This patch returns 0 for the cases selector is 0 ~ 0x2e, which means
"this selector code can't be used on this system".

The regulator core iterates from 0 to n_voltages to find the small voltage
in the specific range. The n_voltages settings for AUTOOUT should be 128 now,
including the reserved range of AUTOOUT.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcf50633-regulator.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 6db46c6..c05b5d1 100644
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
 
@@ -87,6 +87,9 @@ static u8 ldo_voltage_bits(unsigned int millivolts)
 /* Obtain voltage value from bits */
 static unsigned int auto_voltage_value(u8 bits)
 {
+	/* AUTOOUT: 00000000 to 00101110 are reserved.
+	 * Return 0 for bits in reserved range, which means this selector code
+	 * can't be used on this system */
 	if (bits < 0x2f)
 		return 0;
 
@@ -208,20 +211,7 @@ static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
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
@@ -287,7 +277,7 @@ static struct regulator_ops pcf50633_regulator_ops = {
 
 static struct regulator_desc regulators[] = {
 	[PCF50633_REGULATOR_AUTO] =
-		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO, 81),
+		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO, 128),
 	[PCF50633_REGULATOR_DOWN1] =
 		PCF50633_REGULATOR("down1", PCF50633_REGULATOR_DOWN1, 96),
 	[PCF50633_REGULATOR_DOWN2] =
-- 
1.7.5.4



