Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1KZAPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 19:15:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36277 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1KZAPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 19:15:51 -0500
Date: Sat, 26 Nov 2011 04:15:45 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        =?utf-8?B?77+92rDvv73vv73vv70=?= <kyungmin.park@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042
 fuel gauge
Message-ID: <20111126001545.GA24278@oksana.dev.rtsoft.ru>
References: <18021216.478661315185875229.JavaMail.weblogic@epml15>
 <12D0C12AF19E15409D57F22566E88EF50975BF4F98@bgsmsx501.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12D0C12AF19E15409D57F22566E88EF50975BF4F98@bgsmsx501.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 02:00:29PM +0530, Pallala, Ramakrishna wrote:
> > > In max17042_get_property(...), the values returned by
> > > max17042_read_reg are directly assigned to the variables,
> > > even if the read results in an error.
> > >
> > > This patch checks for the return code from max17042_read_reg and
> > > exits the function if there is any error.
> > >
> > > Signed-off-by: Ramakrishna Pallala
> > > ---
> > > drivers/power/max17042_battery.c |   85 ++++++++++++++++++++++++++------------
> > > 1 files changed, 58 insertions(+), 27 deletions(-)
> > >
> > 
> > Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> Thanks for the Ack.
> When can I expect the patch to be merged ?

Merged, much thanks!

Note that I had to manually fix conflicts with

	commit cf7a8c03db792894f436db5f3ffc44d947b9b068
	Author: MyungJoo Ham <myungjoo.ham@samsung.com>
	Date:   Wed Aug 17 10:18:34 2011 +0900

	    max17042_battery: Bugfix of incorrect voltage register value interpretation


So, the resulting patch in battery-2.6.git tree as follows, please
check if everything is OK:

- - - -
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Date: Sat, 26 Nov 2011 04:11:15 +0400
Subject: [PATCH] max17042_battery: Fix error handling

In max17042_get_property(...), the values returned by
max17042_read_reg are directly assigned to the variables,
even if the read results in an error.

This patch checks for the return code from max17042_read_reg and
exits the function if there is any error.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/power/max17042_battery.c |   85 ++++++++++++++++++++++++++------------
 1 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index a6dc9c7..10ffa8c 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -84,55 +84,79 @@ static int max17042_get_property(struct power_supply *psy,
 {
 	struct max17042_chip *chip = container_of(psy,
 				struct max17042_chip, battery);
+	int ret;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_STATUS);
-		if (val->intval & MAX17042_STATUS_BattAbsent)
+		ret = max17042_read_reg(chip->client, MAX17042_STATUS);
+		if (ret < 0)
+			return ret;
+
+		if (ret & MAX17042_STATUS_BattAbsent)
 			val->intval = 0;
 		else
 			val->intval = 1;
 		break;
 	case POWER_SUPPLY_PROP_CYCLE_COUNT:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_Cycles);
+		ret = max17042_read_reg(chip->client, MAX17042_Cycles);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_MinMaxVolt);
-		val->intval >>= 8;
+		ret = max17042_read_reg(chip->client, MAX17042_MinMaxVolt);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret >> 8;
 		val->intval *= 20000; /* Units of LSB = 20mV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_V_empty);
-		val->intval >>= 7;
+		ret = max17042_read_reg(chip->client, MAX17042_V_empty);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret >> 7;
 		val->intval *= 10000; /* Units of LSB = 10mV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = max17042_read_reg(chip->client, MAX17042_VCELL)
-			    * 625 / 8;
+		ret = max17042_read_reg(chip->client, MAX17042_VCELL);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret * 625 / 8;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
-		val->intval = max17042_read_reg(chip->client, MAX17042_AvgVCELL)
-			    * 625 / 8;
+		ret = max17042_read_reg(chip->client, MAX17042_AvgVCELL);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret * 625 / 8;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_SOC) / 256;
+		ret = max17042_read_reg(chip->client, MAX17042_SOC);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret >> 8;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_RepSOC);
-		if ((val->intval / 256) >= MAX17042_BATTERY_FULL)
+		ret = max17042_read_reg(chip->client, MAX17042_RepSOC);
+		if (ret < 0)
+			return ret;
+
+		if ((ret >> 8) >= MAX17042_BATTERY_FULL)
 			val->intval = 1;
-		else if (val->intval >= 0)
+		else if (ret >= 0)
 			val->intval = 0;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_TEMP);
+		ret = max17042_read_reg(chip->client, MAX17042_TEMP);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret;
 		/* The value is signed. */
 		if (val->intval & 0x8000) {
 			val->intval = (0x7fff & ~val->intval) + 1;
@@ -144,8 +168,11 @@ static int max17042_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		if (chip->pdata->enable_current_sense) {
-			val->intval = max17042_read_reg(chip->client,
-					MAX17042_Current);
+			ret = max17042_read_reg(chip->client, MAX17042_Current);
+			if (ret < 0)
+				return ret;
+
+			val->intval = ret;
 			if (val->intval & 0x8000) {
 				/* Negative */
 				val->intval = ~val->intval & 0x7fff;
@@ -159,8 +186,12 @@ static int max17042_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		if (chip->pdata->enable_current_sense) {
-			val->intval = max17042_read_reg(chip->client,
-					MAX17042_AvgCurrent);
+			ret = max17042_read_reg(chip->client,
+						MAX17042_AvgCurrent);
+			if (ret < 0)
+				return ret;
+
+			val->intval = ret;
 			if (val->intval & 0x8000) {
 				/* Negative */
 				val->intval = ~val->intval & 0x7fff;
-- 
1.7.5.3

