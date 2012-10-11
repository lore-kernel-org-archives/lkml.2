Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab2JKK7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:59:13 -0400
Received: from mail.netcomga.sk ([217.118.103.2]:56606 "EHLO netcomga.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754242Ab2JKK7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:59:08 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2012 06:59:07 EDT
Message-ID: <1349952660.1577.43.camel@pluto.netcomga.sk>
Subject: [PATCH] Platform: hp-wmi: add rfkill support for integrated GPS
From: =?ISO-8859-1?Q?Trep=E1k?= Vilmos <trepo@netcomga.sk>
To: mjg@redhat.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 12:51:00 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rfkill support for the GPS radio found in HP laptops (HP Elitebook 2170p and the like)
using the Ericsson F5321/H5321 Mobile Broadband Module.
Signed-off-by: Viliam Trepák <trepo@netcomga.sk>
---
After spending hours trying to get GPS working on my laptop, poring over AT command set
documentations and brute-forcing AT command parameters, I found this in dmesg:

> hp_wmi: unknown device type 0x3

Some copy&pasting later I could switch the GPS radio on and minicom started spewing out
NMEA sentences...  

Tested on the aforementioned laptop, with kernel 3.5.6. Applies cleanly to 3.6.1 as well.

--- linux-3.6.1/drivers/platform/x86/hp-wmi.c.orig	2012-10-07 17:41:28.000000000 +0200
+++ linux-3.6.1/drivers/platform/x86/hp-wmi.c	2012-10-11 10:51:17.469934685 +0200
@@ -60,6 +60,7 @@ enum hp_wmi_radio {
 	HPWMI_WIFI = 0,
 	HPWMI_BLUETOOTH = 1,
 	HPWMI_WWAN = 2,
+	HPWMI_GPS = 3,
 };
 
 enum hp_wmi_event_ids {
@@ -147,6 +148,7 @@ static struct platform_device *hp_wmi_pl
 static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
+static struct rfkill *gps_rfkill;
 
 struct rfkill2_device {
 	u8 id;
@@ -543,6 +545,10 @@ static void hp_wmi_notify(u32 value, voi
 			rfkill_set_states(wwan_rfkill,
 					  hp_wmi_get_sw_state(HPWMI_WWAN),
 					  hp_wmi_get_hw_state(HPWMI_WWAN));
+		if (gps_rfkill)
+			rfkill_set_states(gps_rfkill,
+					  hp_wmi_get_sw_state(HPWMI_GPS),
+					  hp_wmi_get_hw_state(HPWMI_GPS));
 		break;
 	case HPWMI_CPU_BATTERY_THROTTLE:
 		pr_info("Unimplemented CPU throttle because of 3 Cell battery event detected\n");
@@ -663,6 +669,24 @@ static int __devinit hp_wmi_rfkill_setup
 			goto register_bluetooth_error;
 	}
 
+	if (wireless & 0x3) {
+		gps_rfkill = rfkill_alloc("hp-gps", &device->dev,
+						RFKILL_TYPE_GPS,
+						&hp_wmi_rfkill_ops,
+						(void *) HPWMI_GPS);
+		if (!gps_rfkill) {
+			err = -ENOMEM;
+			goto register_bluetooth_error;
+		}
+		rfkill_init_sw_state(gps_rfkill,
+				     hp_wmi_get_sw_state(HPWMI_GPS));
+		rfkill_set_hw_state(bluetooth_rfkill,
+				    hp_wmi_get_hw_state(HPWMI_GPS));
+		err = rfkill_register(gps_rfkill);
+		if (err)
+			goto register_gps_error;
+	}
+
 	if (wireless & 0x4) {
 		wwan_rfkill = rfkill_alloc("hp-wwan", &device->dev,
 					   RFKILL_TYPE_WWAN,
@@ -670,7 +694,7 @@ static int __devinit hp_wmi_rfkill_setup
 					   (void *) HPWMI_WWAN);
 		if (!wwan_rfkill) {
 			err = -ENOMEM;
-			goto register_bluetooth_error;
+			goto register_gps_error;
 		}
 		rfkill_init_sw_state(wwan_rfkill,
 				     hp_wmi_get_sw_state(HPWMI_WWAN));
@@ -685,6 +709,11 @@ static int __devinit hp_wmi_rfkill_setup
 register_wwan_err:
 	rfkill_destroy(wwan_rfkill);
 	wwan_rfkill = NULL;
+	if (gps_rfkill)
+		rfkill_unregister(gps_rfkill);
+register_gps_error:
+	rfkill_destroy(gps_rfkill);
+	gps_rfkill = NULL;
 	if (bluetooth_rfkill)
 		rfkill_unregister(bluetooth_rfkill);
 register_bluetooth_error:
@@ -729,6 +758,10 @@ static int __devinit hp_wmi_rfkill2_setu
 			type = RFKILL_TYPE_WWAN;
 			name = "hp-wwan";
 			break;
+		case HPWMI_GPS:
+			type = RFKILL_TYPE_GPS;
+			name = "hp-gps";
+			break;
 		default:
 			pr_warn("unknown device type 0x%x\n",
 				state.device[i].radio_type);
@@ -786,6 +819,7 @@ static int __devinit hp_wmi_bios_setup(s
 	wifi_rfkill = NULL;
 	bluetooth_rfkill = NULL;
 	wwan_rfkill = NULL;
+	gps_rfkill = NULL;
 	rfkill2_count = 0;
 
 	if (hp_wmi_rfkill_setup(device))
@@ -835,6 +869,10 @@ static int __exit hp_wmi_bios_remove(str
 		rfkill_unregister(wwan_rfkill);
 		rfkill_destroy(wwan_rfkill);
 	}
+	if (gps_rfkill) {
+		rfkill_unregister(gps_rfkill);
+		rfkill_destroy(gps_rfkill);
+	}
 
 	return 0;
 }
@@ -870,6 +908,10 @@ static int hp_wmi_resume_handler(struct
 		rfkill_set_states(wwan_rfkill,
 				  hp_wmi_get_sw_state(HPWMI_WWAN),
 				  hp_wmi_get_hw_state(HPWMI_WWAN));
+	if (gps_rfkill)
+		rfkill_set_states(gps_rfkill,
+				  hp_wmi_get_sw_state(HPWMI_GPS),
+				  hp_wmi_get_hw_state(HPWMI_GPS));
 
 	return 0;
 }


