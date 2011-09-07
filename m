Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1IGRAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:00:03 -0400
Received: from mail2.nsc.com ([12.238.8.132]:51121 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754516Ab1IGQ76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:59:58 -0400
X-WSS-ID: 0LR5A1U-0A-CKU-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@nsc.com>
To: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "cbou@mail.ru" <cbou@mail.ru>
Date: Wed, 7 Sep 2011 01:53:48 -0700
Subject: [PATCH 0/3] power: Add LP8727 charger driver
Thread-Topic: [PATCH 0/3] power: Add LP8727 charger driver
Thread-Index: AcxtOZHwsfRfFQT8RpKYDbb2wllC3QAAdKRQ
Message-ID: <B567DBAB974C0544994013492B949F8E380F619DDD@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6279EE941LS6373895-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch supports the LP8727 charger driver.

* General features
National Semiconductor LP8727 is the battery charger with Micro/Mini USB interface.
This IC includes below functions
- I2C interface for accessing user registers
- Single input Li-Ion battery charger
- Charger input ID detection from Micro/Mini USB
- Multiplexing switches on USB, UART

* Driver Description
1) Interrupt
	When the charger events occur(attached/detached), the LP8727 generates the interrupt.
	Then the host will read 2 interrupt registers and do ID detection, multiplexing switches and updating power supplies.
	It takes few debounce time (about 270ms) to get updated status.

2) ID detection
	LP8727 detects the charger and the device ID is updated in register area.
	Available device ID : TA(Travel Adaptor), Dedicated charger, USB charger and USB downstream

3) Power supplies
	Three power supplies are registered when LP8727 driver is detected.
	- AC : adapter
	- USB : USB charger
	- Battery : Li-On battery

	AC and USB are supplied to the battery.
	Charging parameters can be set as changed charger type.
	For this function, 'external_power_changed()' and 'supplied_to' are used.

4) Platform data for lp8727
	There are two reason for providing lp8727 platform data.
 
	a) Supporting limited power supply properties
	LP8727 doesn't support the fuel gauging and no way to check whether battery exists or not.
	So below properties can't be read from the LP8727 registers
	- POWER_SUPPLY_PROP_PRESENT
	- POWER_SUPPLY_PROP_VOLTAGE_NOW
	- POWER_SUPPLY_PROP_CAPACITY
	- POWER_SUPPLY_PROP_TEMP

	If the system has fuel gauging and battery detection,
	then I would recommend mapping functions in the platform data when adding i2c device.
   
	Ex) static struct lp8727_platform_data lp8727_chg_pdata = {
		.get_batt_present = dummy_get_batt_present,
		.get_batt_level = dummy_get_batt_level;
		.get_batt_capacity = dummy_get_batt_capacity,
		.get_batt_temp = dummy_get_batt_temp,
		...
	};

	When user-space gets battery properties, the mapping function is called.

	Ex) static int lp8727_battery_get_property(struct power_supply *psy,
								enum power_supply_property psp,
								union power_supply_propval *val)
	{
		struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);

		...

		// dummy_get_batt_level() will be called
		case POWER_SUPPLY_PROP_VOLTAGE_NOW:
			if(pchg->pdata->get_batt_level)
				val->intval = pchg->pdata->get_batt_level();
		break;

		...
	}

	b) Supporting platform specific charging parameters
	The values of EOC(End of Charge) and charging current depend on the charger type.(ac or usb)
	For example, during charging battery with ac adaptor, eoc level is 10% of Vterm and charging current is 400mA.
	(Vterm : charging termination voltage)
	But with USB charger, charging current is set to 500mA.
	This value is platform specific data.
 
	Ex) static struct lp8727_platform_data lp8727_chg_pdata = {
		...

		.ac = {
			.eoc_level = EOC_10P,
			.ichg = ICHG_400mA,
		},
		.usb = {
			.eoc_level = EOC_10P,
			.ichg = ICHG_500mA,
		},
	};

	Then this value will be updated after power_supply_changed() is called.
 
	Ex) static void lp8727_charger_changed(struct power_supply *psy)
	{
		...
		eoc_level = pchg->chg_parm->eoc_level;
		ichg = pchg->chg_parm->ichg;
		val = (ichg << 4) | eoc_level;
		 (void)lp8727_i2c_write(pchg, CHGCTRL2, &val, 1);
		...
	}

* Tested on OMAP3530 board


Best Regards
------------------------------------------------------------------------------------------------------------
Milo (Woo Gyom) KIM
National Semiconductor
milo.kim@nsc.com
------------------------------------------------------------------------------------------------------------



