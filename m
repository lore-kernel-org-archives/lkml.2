Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab1ESTET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:04:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932611Ab1ESTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:04:17 -0400
Date: Thu, 19 May 2011 12:03:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: <ryan@bluewatersys.com>, <haojian.zhuang@marvell.com>,
        <johnpol@2ka.mipt.ru>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] w1: Add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge
 IC support.
Message-Id: <20110519120334.69ccb4b6.akpm@linux-foundation.org>
In-Reply-To: <4DD50B35.2000005@indesign-llc.com>
References: <4DD50B35.2000005@indesign-llc.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 08:21:09 -0400
Clifton Barnes <cabarnes@indesign-llc.com> wrote:

> Add support for the Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC.
> 
> I've updated the driver based on feedback from the last version.
> I believe the locking is correct because the w1_ds2780_io function
> has locking in it.  If there's still a problem that I'm missing let 
> me know and I can correct it.
> 
> Changes for v3:
>  - Formatting changes suggested from last version
>  - Moved read/write functions to battery driver
>  - Corrected temperature calculation
>  - Changed EEPROM access to bin_attribute
> 

We have a min_t() helper to avoid (or hide) the typecasts:

--- a/drivers/power/ds2780_battery.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
+++ a/drivers/power/ds2780_battery.c
@@ -628,7 +628,7 @@ static ssize_t ds2780_read_param_eeprom_
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
@@ -646,7 +646,7 @@ static ssize_t ds2780_write_param_eeprom
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 	int ret;
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
@@ -681,7 +681,7 @@ static ssize_t ds2780_read_user_eeprom_b
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
@@ -700,7 +700,7 @@ static ssize_t ds2780_write_user_eeprom_
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 	int ret;
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
--- a/drivers/w1/slaves/w1_ds2780.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -40,7 +40,7 @@ int w1_ds2780_io(struct device *dev, cha
 		count = 0;
 		goto out;
 	}
-	count = min((int)count, DS2780_DATA_SIZE - addr);
+	count = min_t(int, count, DS2780_DATA_SIZE - addr);
 
 	if (w1_reset_select_slave(sl) == 0) {
 		if (io) {
_


However its use is often a sign that some types were unwisely chosen.
