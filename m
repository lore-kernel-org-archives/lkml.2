Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2KVToU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:44:20 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49570 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2KVToS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:44:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ0PZbT-RD_jMpAesm9aegjpfzsimN-hAUX3ck7vJBOHH7EV5A@mail.gmail.com>
References: <1353507795-3516-1-git-send-email-thomas.abraham@linaro.org>
	<CAJ0PZbT-RD_jMpAesm9aegjpfzsimN-hAUX3ck7vJBOHH7EV5A@mail.gmail.com>
Date: Thu, 22 Nov 2012 13:56:58 +0530
Message-ID: <CAJuYYwRbPbiBJGzFFzPqRHwsEwKnR3UCAVxwBPKytAgmemAwVg@mail.gmail.com>
Subject: Re: [PATCH] regulator: max8997: skip gpio dvs setup if not used
From: Thomas Abraham <thomas.abraham@linaro.org>
To: myungjoo.ham@gmail.com
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Ham,

Thanks for your comments.

On 21 November 2012 20:01, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> On Wed, Nov 21, 2012 at 11:23 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>> If gpio based voltage selection for buck 1/2/5 are not used, then the execution
>> of gpio dvs setup code during probe can be skipped completly.
>
> Even if GPIO-DVS feature is turned off, you need to setup BUCKxDVS1 anyway.
> Otherwise, you may get "unspecified" behavior from the BUCK1/2/5,
> which may incur unstable system.

I was looking into the documents but I did not find that this
condition being documented. Anyways, based on your comments, I have
tested two changes in the max8997 driver.

The first change moves the programming of the DVS related BUCK
registers above the programming of the BUCKxCTRL register. This is
required because by the time the BUCKxCTRL register is configured, the
corresponding voltage levels should already be programmed in BUCKxDVSx
registers.

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index cea9ec9..8901371 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1019,6 +1019,19 @@ static int max8997_pmic_probe(struct
platform_device *pdev)
                                max_buck5, 0x3f);
        }

+       /* Initialize all the DVS related BUCK registers */
+       for (i = 0; i < 8; i++) {
+               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
+                               max8997->buck1_vol[i],
+                               0x3f);
+               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
+                               max8997->buck2_vol[i],
+                               0x3f);
+               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
+                               max8997->buck5_vol[i],
+                               0x3f);
+       }
+
        /*
         * If buck 1, 2, and 5 do not care DVS GPIO settings, ignore them.
         * If at least one of them cares, set gpios.
@@ -1068,19 +1081,6 @@ static int max8997_pmic_probe(struct
platform_device *pdev)
        max8997_update_reg(i2c, MAX8997_REG_BUCK5CTRL, (pdata->buck5_gpiodvs) ?
                        (1 << 1) : (0 << 1), 1 << 1);

-       /* Initialize all the DVS related BUCK registers */
-       for (i = 0; i < 8; i++) {
-               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
-                               max8997->buck1_vol[i],
-                               0x3f);
-               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
-                               max8997->buck2_vol[i],
-                               0x3f);
-               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
-                               max8997->buck5_vol[i],
-                               0x3f);
-       }
-
        /* Misc Settings */
        max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
        max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);


In the second change, if the DVS feature is used, all the 8 BUCKxDVSx
registers are programmed. If DVS feature is not used, only BUCKxDVS1
register is programmed.

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 8901371..231fcdb 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -941,7 +941,7 @@ static int max8997_pmic_probe(struct platform_device *pdev)
        struct regulator_dev **rdev;
        struct max8997_data *max8997;
        struct i2c_client *i2c;
-       int i, ret, size;
+       int i, ret, size, nr_dvs;
        u8 max_buck1 = 0, max_buck2 = 0, max_buck5 = 0;

        if (!pdata) {
@@ -973,7 +973,10 @@ static int max8997_pmic_probe(struct platform_device *pdev)
        memcpy(max8997->buck125_gpios, pdata->buck125_gpios, sizeof(int) * 3);
        max8997->ignore_gpiodvs_side_effect = pdata->ignore_gpiodvs_side_effect;

-       for (i = 0; i < 8; i++) {
+       nr_dvs = (pdata->buck1_gpiodvs || pdata->buck2_gpiodvs ||
+                       pdata->buck5_gpiodvs) ? 8 : 1;
+
+       for (i = 0; i < nr_dvs; i++) {
                max8997->buck1_vol[i] = ret =
                        max8997_get_voltage_proper_val(
                                        &buck1245_voltage_map_desc,
@@ -1020,7 +1023,7 @@ static int max8997_pmic_probe(struct
platform_device *pdev)
        }

        /* Initialize all the DVS related BUCK registers */
-       for (i = 0; i < 8; i++) {
+       for (i = 0; i < nr_dvs; i++) {
                max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
                                max8997->buck1_vol[i],
                                0x3f);

If these changes are correct, could you please let me know. I will
submit patches for these changes.

Thanks for your time.

Regards,
Thomas.

> Cheers,
> MyungJoo
>
>
> --
> MyungJoo Ham, Ph.D.
> Mobile Software Platform Lab, DMC Business, Samsung Electronics
