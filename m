Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1G2UCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:02:30 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:39705 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1G2UC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:02:29 -0400
Message-ID: <4E3311D1.3000601@gmail.com>
Date: Fri, 29 Jul 2011 22:02:25 +0200
From: Marcus Folkesson <marcus.folkesson@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] regulator: tps65023: Added support for the similiar
 TPS65020 chip
References: <marcus.folkesson@gmail.com> <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com> <1311762767-20263-4-git-send-email-marcus.folkesson@gmail.com> <20110729123420.GB22042@sirena.org.uk> <CAM8FrKL4-hn2rrazsCLrRoVY5zVkgR8A245ScfS48=O41jtffg@mail.gmail.com> <20110729140342.GB19118@opensource.wolfsonmicro.com>
In-Reply-To: <20110729140342.GB19118@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 04:03 PM, Mark Brown wrote:
> On Fri, Jul 29, 2011 at 03:08:54PM +0200, Marcus Folkesson wrote:
>> 2011/7/29 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>>> On Wed, Jul 27, 2011 at 12:32:47PM +0200, Marcus Folkesson wrote:
> 
>>>> +static struct tps_driver_data tps65020_drv_data = {
>>>> +             .info = (struct tps_info *) tps65020_regs,
> 
>>> Why do you need the cast here?  I see it's in the original driver too
>>> but it looks like something that should be fixed.
> 
>> I also thought about the line, It's only for avoiding warnings from gcc.
>> But I don't really understand why gcc is warning.
> 
>> gcc output:  "warning: initialization discards qualifiers from pointer
>> target type".
> 
> It's complaining because the declaration of tps65020_regs doesn't match
> up with that of .info.  Probably the struct member needs to be a const
> pointer.


Changes from original patch:

@@ -681,19 +681,19 @@ static const struct tps_info tps65023_regs[] = {
 };
 
 static struct tps_driver_data tps65020_drv_data = {
-		.info = (struct tps_info *) tps65020_regs,
+		.info = tps65020_regs,
 		.core_regulator = TPS65023_DCDC_3,
 		.num_voltages = tps65020_num_voltages,
 };
 





>From 9ad596ad019feade1e346bb4128819202b26c118 Mon Sep 17 00:00:00 2001
From: Marcus Folkesson <marcus.folkesson@gmail.com>
Date: Wed, 27 Jul 2011 11:34:43 +0200
Subject: [PATCH 3/3] regulator: tps65023: Added support for the similiar TPS65020 chip

Defines a new voltage-table and allows registering of the tps65020 device.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   63 ++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 5cc7344..a4c0583 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -103,8 +103,26 @@ static const u16 VCORE_VSEL_table[] = {
 	1500, 1525, 1550, 1600,
 };
 
+/* Supported voltage values for LDO regulators for tps65020 */
+static const u16 TPS65020_LDO1_VSEL_table[] = {
+	1000, 1050, 1100, 1300,
+	1800, 2500, 3000, 3300,
+};
+
+static const u16 TPS65020_LDO2_VSEL_table[] = {
+	1000, 1050, 1100, 1300,
+	1800, 2500, 3000, 3300,
+};
 
 
+static unsigned int tps65020_num_voltages[] = {
+				0,
+				0,
+				ARRAY_SIZE(VCORE_VSEL_table),
+				ARRAY_SIZE(TPS65020_LDO1_VSEL_table),
+				ARRAY_SIZE(TPS65020_LDO2_VSEL_table)
+};
+
 /* Supported voltage values for LDO regulators
  * for tps65021 and tps65023 */
 static const u16 TPS65023_LDO1_VSEL_table[] = {
@@ -553,6 +571,43 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct tps_info tps65020_regs[] = {
+	{
+		.name = "VDCDC1",
+		.min_uV = 3300000,
+		.max_uV = 3300000,
+		.fixed	= 1,
+	},
+	{
+		.name = "VDCDC2",
+		.min_uV =  1800000,
+		.max_uV = 1800000,
+		.fixed = 1,
+	},
+	{
+		.name = "VDCDC3",
+		.min_uV =  800000,
+		.max_uV = 1600000,
+		.table_len = ARRAY_SIZE(VCORE_VSEL_table),
+		.table = VCORE_VSEL_table,
+	},
+
+	{
+		.name = "LDO1",
+		.min_uV = 1000000,
+		.max_uV = 3150000,
+		.table_len = ARRAY_SIZE(TPS65020_LDO1_VSEL_table),
+		.table = TPS65020_LDO1_VSEL_table,
+	},
+	{
+		.name = "LDO2",
+		.min_uV = 1050000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(TPS65020_LDO2_VSEL_table),
+		.table = TPS65020_LDO2_VSEL_table,
+	},
+};
+
 static const struct tps_info tps65021_regs[] = {
 	{
 		.name = "VDCDC1",
@@ -625,6 +680,12 @@ static const struct tps_info tps65023_regs[] = {
 	},
 };

+static struct tps_driver_data tps65020_drv_data = {
+		.info = tps65020_regs,
+		.core_regulator = TPS65023_DCDC_3,
+		.num_voltages = tps65020_num_voltages,
+};
+
 static struct tps_driver_data tps65021_drv_data = {
 		.info = tps65021_regs,
 		.core_regulator = TPS65023_DCDC_3,
@@ -642,6 +703,8 @@ static const struct i2c_device_id tps_65023_id[] = {
 	.driver_data = (unsigned long) &tps65023_drv_data},
 	{.name = "tps65021",
 	.driver_data = (unsigned long) &tps65021_drv_data,},
+	{.name = "tps65020",
+	.driver_data = (unsigned long) &tps65020_drv_data},
 	{ },
 };
 
-- 
1.7.4.1








