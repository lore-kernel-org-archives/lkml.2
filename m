Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab1AaToS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:44:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39269 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab1AaToR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:44:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nOuoGm+akINjif6bezwkOyyJz9Bb+TmszJOxVn9dlynzobjQ+kBCECqACW3PBSpL+k
         kH5frspHdIzYSL8FfQCcV+WCpBoYHWI1Z6xFNNiq+lXM/kmHZoMROMsOfK7CmaZumslE
         buX8fbtzPlDZEOG/Z0ZxrT9p5hy8nC8EBAwV4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru> <20110131154354.GC3819@enneenne.com>
 <20110131160321.GA23546@oksana.dev.rtsoft.ru> <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Mon, 31 Jan 2011 20:43:36 +0100
Message-ID: <AANLkTikUU9WamKweb=nL+v1eYg=GqguXSe5x++JZGBQ2@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is new patch. It is possible to merge it then with changes on git?

===

This patch add support for reporting properties
POWER_SUPPLY_PROP_CHARGE_NOW, POWER_SUPPLY_PROP_CHARGE_FULL,
POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
POWER_SUPPLY_PROP_CHARGE_COUNTER, POWER_SUPPLY_PROP_ENERGY_NOW in
module bq27x00_battery.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>

--- a/drivers/power/bq27x00_battery.c   2011-01-31 17:45:01.000000000 +0100
+++ b/drivers/power/bq27x00_battery.c   2011-01-31 18:43:16.000000000 +0100
@@ -4,6 +4,11 @@
  * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
  * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
  *
+ * Support for reporting properties: POWER_SUPPLY_PROP_CHARGE_NOW,
+ * POWER_SUPPLY_PROP_CHARGE_FULL, POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+ * POWER_SUPPLY_PROP_CHARGE_COUNTER, POWER_SUPPLY_PROP_ENERGY_NOW
+ *   Copyright (C) 2011 Pali Rohár <pali.rohar@gmail.com>
+ *
  * Based on a previous work by Copyright (C) 2008 Texas Instruments, Inc.
  *
  * This package is free software; you can redistribute it and/or modify
@@ -15,6 +20,13 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  *
  */
+
+/*
+ * Datasheets:
+ * http://focus.ti.com/docs/prod/folders/print/bq27000.html
+ * http://focus.ti.com/docs/prod/folders/print/bq27500.html
+ */
+
 #include <linux/module.h>
 #include <linux/param.h>
 #include <linux/jiffies.h>
@@ -27,7 +39,7 @@
 #include <linux/slab.h>
 #include <asm/unaligned.h>

-#define DRIVER_VERSION                 "1.1.0"
+#define DRIVER_VERSION                 "1.2.0"

 #define BQ27x00_REG_TEMP               0x06
 #define BQ27x00_REG_VOLT               0x08
@@ -36,12 +48,19 @@
 #define BQ27x00_REG_TTE                        0x16
 #define BQ27x00_REG_TTF                        0x18
 #define BQ27x00_REG_TTECP              0x26
+#define BQ27x00_REG_NAC                        0x0C /* Nominal
available capaciy */
+#define BQ27x00_REG_LMD                        0x12 /* Last measured
discharge */
+#define BQ27x00_REG_CYCT               0x2A /* Cycle count total */
+#define BQ27x00_REG_AE                 0x22 /* Available enery */

 #define BQ27000_RS                     20 /* Resistor sense */
 #define BQ27000_REG_RSOC               0x0B /* Relative State-of-Charge */
+#define BQ27000_REG_ILMD               0x76 /* Initial last measured
discharge */
 #define BQ27000_FLAG_CHGS              BIT(7)
+#define BQ27000_FLAG_FC                        BIT(5)

 #define BQ27500_REG_SOC                        0x2C
+#define BQ27500_REG_DCAP               0x3C /* Design capacity */
 #define BQ27500_FLAG_DSC               BIT(0)
 #define BQ27500_FLAG_FC                        BIT(9)

@@ -75,6 +94,11 @@ static enum power_supply_property bq27x0
        POWER_SUPPLY_PROP_VOLTAGE_NOW,
        POWER_SUPPLY_PROP_CURRENT_NOW,
        POWER_SUPPLY_PROP_CAPACITY,
+       POWER_SUPPLY_PROP_CHARGE_NOW,
+       POWER_SUPPLY_PROP_CHARGE_FULL,
+       POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+       POWER_SUPPLY_PROP_CHARGE_COUNTER,
+       POWER_SUPPLY_PROP_ENERGY_NOW,
        POWER_SUPPLY_PROP_TEMP,
        POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
        POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
@@ -188,6 +212,119 @@ static int bq27x00_battery_rsoc(struct b
        return rsoc;
 }

+/*
+ * Return the battery Nominal available capaciy in µAh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_nac(struct bq27x00_device_info *di)
+{
+       int ret;
+       int nac = 0;
+
+       ret = bq27x00_read(BQ27x00_REG_NAC, &nac, 0, di);
+       if (ret) {
+               dev_err(di->dev, "error reading nominal available capacity\n");
+               return ret;
+       }
+
+       if (di->chip == BQ27500)
+               nac *= 1000;
+       else
+               nac = nac * 3570 / BQ27000_RS;
+
+       return nac;
+}
+
+/*
+ * Return the battery Last measured discharge in µAh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_lmd(struct bq27x00_device_info *di)
+{
+       int ret;
+       int lmd = 0;
+
+       ret = bq27x00_read(BQ27x00_REG_LMD, &lmd, 0, di);
+       if (ret) {
+               dev_err(di->dev, "error reading last measured discharge\n");
+               return ret;
+       }
+
+       if (di->chip == BQ27500)
+               lmd *= 1000;
+       else
+               lmd = lmd * 3570 / BQ27000_RS;
+
+       return lmd;
+}
+
+/*
+ * Return the battery Initial last measured discharge in µAh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_ilmd(struct bq27x00_device_info *di)
+{
+       int ret;
+       int ilmd = 0;
+
+       if (di->chip == BQ27500)
+               ret = bq27x00_read(BQ27500_REG_DCAP, &ilmd, 0, di);
+       else
+               ret = bq27x00_read(BQ27000_REG_ILMD, &ilmd, 0, di);
+       if (ret) {
+               dev_err(di->dev, "error reading initial last measured
discharge\n");
+               return ret;
+       }
+
+       if (di->chip == BQ27500)
+               ilmd *= 1000;
+       else
+               ilmd = ilmd * 256 * 3570 / BQ27000_RS;
+
+       return ilmd;
+}
+
+/*
+ * Return the battery Cycle count total
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_cyct(struct bq27x00_device_info *di)
+{
+       int ret;
+       int cyct = 0;
+
+       ret = bq27x00_read(BQ27x00_REG_CYCT, &cyct, 0, di);
+       if (ret) {
+               dev_err(di->dev, "error reading cycle count total\n");
+               return ret;
+       }
+
+       return cyct;
+}
+
+/*
+ * Return the battery Available energy in µWh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_energy(struct bq27x00_device_info *di)
+{
+       int ret;
+       int ae = 0;
+
+       ret = bq27x00_read(BQ27x00_REG_LMD, &ae, 0, di);
+       if (ret) {
+               dev_err(di->dev, "error reading available energy\n");
+               return ret;
+       }
+
+       if (di->chip == BQ27500)
+               ae *= 1000;
+       else
+               ae = ae * 29200 / BQ27000_RS;
+
+       return ae;
+}
+
 static int bq27x00_battery_status(struct bq27x00_device_info *di,
                                  union power_supply_propval *val)
 {
@@ -209,7 +346,9 @@ static int bq27x00_battery_status(struct
                else
                        status = POWER_SUPPLY_STATUS_CHARGING;
        } else {
-               if (flags & BQ27000_FLAG_CHGS)
+               if (flags & BQ27000_FLAG_FC)
+                       status = POWER_SUPPLY_STATUS_FULL;
+               else if (flags & BQ27000_FLAG_CHGS)
                        status = POWER_SUPPLY_STATUS_CHARGING;
                else
                        status = POWER_SUPPLY_STATUS_DISCHARGING;
@@ -268,6 +407,21 @@ static int bq27x00_battery_get_property(
        case POWER_SUPPLY_PROP_CAPACITY:
                val->intval = bq27x00_battery_rsoc(di);
                break;
+       case POWER_SUPPLY_PROP_CHARGE_NOW:
+               val->intval = bq27x00_battery_nac(di);
+               break;
+       case POWER_SUPPLY_PROP_CHARGE_FULL:
+               val->intval = bq27x00_battery_lmd(di);
+               break;
+       case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+               val->intval = bq27x00_battery_ilmd(di);
+               break;
+       case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+               val->intval = bq27x00_battery_cyct(di);
+               break;
+       case POWER_SUPPLY_PROP_ENERGY_NOW:
+               val->intval = bq27x00_battery_energy(di);
+               break;
        case POWER_SUPPLY_PROP_TEMP:
                val->intval = bq27x00_battery_temperature(di);
                break;
