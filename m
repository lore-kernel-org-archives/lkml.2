Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934539Ab2C3Rkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:40:53 -0400
Received: from csmtp3.one.com ([91.198.169.23]:28207 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab2C3Rkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:40:46 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Fri, 30 Mar 2012 19:41:52 +0200
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] HID: autoload hid-multitouch as needed
Message-ID: <20120330174152.GA2773@polaris.bitmath.org>
References: <1332945198-2518-1-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332945198-2518-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> When the generic hid parsing of the report descriptors in hid-core
> detects that the device contains the field ContactID, the device should
> be handled by hid-multitouch, and hid-core should release it.
> This patch implements a temporary fix for hid-core to automatically
> call the loading of hid-multitouch. A better solution would involve
> userspace.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---

This reply contains an alternative approach involving userspace, but
first, two comments on this patch:

* It seems request_module_nowait() can be used instead of
the workqueue.

* Cold plug fails when hid is loaded in absence of disks.

Rather than wait for the userland solution to appear, please find
enclosed five patches attempting to resolve the problem. Both
cold-plugged and hot-plugged devices seems to work. No extra udev
rules are needed. On this machine, everything seems to work as
intended. I run with the hid module builtin, and no initrd.

The approach is based on two things:

* Parse the hid descriptors before adding the device

* Modify the modalias to include a hid subclass matching the
kernel drivers, here exemplified with hid-multitouch.

The patches apply directly on top of 3.3, so it should be
fairly easy to try them out.

Cheers,
Henrik

---

>From 96b0022da2c0617a74168abb015f0b0b6564819e Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Fri, 30 Mar 2012 18:34:16 +0200
Subject: [PATCH 1/5] hid: Remove multitouch quirk

In preparation for a generic autoloading mechanism, remove
the temporary HID_QUIRK_MULTITOUCH quirk.
---
 drivers/hid/hid-core.c  |    5 -----
 drivers/hid/hid-input.c |   11 -----------
 include/linux/hid.h     |    1 -
 3 files changed, 17 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index af08ce7..35ba9d9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1230,11 +1230,6 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	if ((connect_mask & HID_CONNECT_HIDINPUT) && !hidinput_connect(hdev,
 				connect_mask & HID_CONNECT_HIDINPUT_FORCE))
 		hdev->claimed |= HID_CLAIMED_INPUT;
-	if (hdev->quirks & HID_QUIRK_MULTITOUCH) {
-		/* this device should be handled by hid-multitouch, skip it */
-		hdev->quirks &= ~HID_QUIRK_MULTITOUCH;
-		return -ENODEV;
-	}
 
 	if ((connect_mask & HID_CONNECT_HIDDEV) && hdev->hiddev_connect &&
 			!hdev->hiddev_connect(hdev,
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 627850a..e15575a 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -631,10 +631,6 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			map_key_clear(BTN_STYLUS2);
 			break;
 
-		case 0x51: /* ContactID */
-			device->quirks |= HID_QUIRK_MULTITOUCH;
-			goto unknown;
-
 		default:  goto unknown;
 		}
 		break;
@@ -1201,13 +1197,6 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 		}
 	}
 
-	if (hid->quirks & HID_QUIRK_MULTITOUCH) {
-		/* generic hid does not know how to handle multitouch devices */
-		if (hidinput)
-			goto out_cleanup;
-		goto out_unwind;
-	}
-
 	if (hidinput && input_register_device(hidinput->input))
 		goto out_cleanup;
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 3a95da6..5b3be43 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -317,7 +317,6 @@ struct hid_item {
 #define HID_QUIRK_BADPAD			0x00000020
 #define HID_QUIRK_MULTI_INPUT			0x00000040
 #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
-#define HID_QUIRK_MULTITOUCH			0x00000100
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
-- 
1.7.9.4

>From f2ac2e444e2121a76305156a6c12507aca0222f3 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Fri, 30 Mar 2012 18:40:11 +0200
Subject: [PATCH 2/5] hid-multitouch: Prepare driver for new device ids

Use a driver-specific device id macro for the id list.
This patch does not contain any functional changes.
---
 drivers/hid/hid-multitouch.c |  119 ++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 58 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 24fc442..421b16c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -103,6 +103,9 @@ struct mt_device {
 
 #define MT_DEFAULT_MAXCONTACT	10
 
+#define HID_USB_MT_DEVICE(v, p)						\
+	HID_USB_DEVICE(v, p)
+
 /*
  * these device-dependent functions determine what slot corresponds
  * to a valid contact that was just read.
@@ -656,231 +659,231 @@ static const struct hid_device_id mt_devices[] = {
 
 	/* 3M panels */
 	{ .driver_data = MT_CLS_3M,
-		HID_USB_DEVICE(USB_VENDOR_ID_3M,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_3M,
 			USB_DEVICE_ID_3M1968) },
 	{ .driver_data = MT_CLS_3M,
-		HID_USB_DEVICE(USB_VENDOR_ID_3M,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_3M,
 			USB_DEVICE_ID_3M2256) },
 	{ .driver_data = MT_CLS_3M,
-		HID_USB_DEVICE(USB_VENDOR_ID_3M,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_3M,
 			USB_DEVICE_ID_3M3266) },
 
 	/* ActionStar panels */
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
 			USB_DEVICE_ID_ACTIONSTAR_1011) },
 
 	/* Atmel panels */
 	{ .driver_data = MT_CLS_SERIAL,
-		HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_ATMEL,
 			USB_DEVICE_ID_ATMEL_MULTITOUCH) },
 
 	/* Cando panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
-		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
-		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
-		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
-		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
 
 	/* Chunghwa Telecom touch panels */
 	{  .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
 			USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
 
 	/* CVTouch panels */
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_CVTOUCH,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_CVTOUCH,
 			USB_DEVICE_ID_CVTOUCH_SCREEN) },
 
 	/* Cypress panel */
 	{ .driver_data = MT_CLS_CYPRESS,
-		HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_CYPRESS,
 			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 
 	/* eGalax devices (resistive) */
 	{ .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480D) },
 	{ .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480E) },
 
 	/* eGalax devices (capacitive) */
 	{ .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C) },
 	{ .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) },
 	{ .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
 	{ .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA) },
 	{ .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
 	{ .driver_data = MT_CLS_EGALAX_SERIAL,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 
 	/* Elo TouchSystems IntelliTouch Plus panel */
 	{ .driver_data = MT_CLS_DUAL_NSMU_CONTACTID,
-		HID_USB_DEVICE(USB_VENDOR_ID_ELO,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_ELO,
 			USB_DEVICE_ID_ELO_TS2515) },
 
 	/* GeneralTouch panel */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
-		HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
 			USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
 
 	/* GoodTouch panels */
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_GOODTOUCH,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_GOODTOUCH,
 			USB_DEVICE_ID_GOODTOUCH_000f) },
 
 	/* Hanvon panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
-		HID_USB_DEVICE(USB_VENDOR_ID_HANVON_ALT,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_HANVON_ALT,
 			USB_DEVICE_ID_HANVON_ALT_MULTITOUCH) },
 
 	/* Ideacom panel */
 	{ .driver_data = MT_CLS_SERIAL,
-		HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_IDEACOM,
 			USB_DEVICE_ID_IDEACOM_IDC6650) },
 
 	/* Ilitek dual touch panel */
 	{  .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_ILITEK,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_ILITEK,
 			USB_DEVICE_ID_ILITEK_MULTITOUCH) },
 
 	/* IRTOUCH panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
-		HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 
 	/* LG Display panels */
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_LG,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_LG,
 			USB_DEVICE_ID_LG_MULTITOUCH) },
 
 	/* Lumio panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-		HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_LUMIO,
 			USB_DEVICE_ID_CRYSTALTOUCH) },
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-		HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_LUMIO,
 			USB_DEVICE_ID_CRYSTALTOUCH_DUAL) },
 
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-		HID_USB_DEVICE(USB_VENDOR_ID_ASUS,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_ASUS,
 			USB_DEVICE_ID_ASUS_T91MT)},
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-		HID_USB_DEVICE(USB_VENDOR_ID_ASUS,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_ASUS,
 			USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO) },
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-		HID_USB_DEVICE(USB_VENDOR_ID_TURBOX,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_TURBOX,
 			USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 
 	/* PenMount panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
-		HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_PENMOUNT,
 			USB_DEVICE_ID_PENMOUNT_PCI) },
 
 	/* PixArt optical touch screen */
 	{ .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
-		HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_PIXART,
 			USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN) },
 	{ .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
-		HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_PIXART,
 			USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1) },
 	{ .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
-		HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_PIXART,
 			USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2) },
 
 	/* PixCir-based panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
-		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_HANVON,
 			USB_DEVICE_ID_HANVON_MULTITOUCH) },
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
-		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
 
 	/* Quanta-based panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
-		HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_QUANTA,
 			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
-		HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_QUANTA,
 			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001) },
 	{ .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
-		HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_QUANTA,
 			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008) },
 
 	/* Stantum panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
-		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_STANTUM,
 			USB_DEVICE_ID_MTP)},
 	{ .driver_data = MT_CLS_CONFIDENCE,
-		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_STANTUM_STM,
 			USB_DEVICE_ID_MTP_STM)},
 	{ .driver_data = MT_CLS_CONFIDENCE,
-		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
 			USB_DEVICE_ID_MTP_SITRONIX)},
 
 	/* Touch International panels */
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
 			USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH) },
 
 	/* Unitec panels */
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_UNITEC,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0709) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_UNITEC,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
 	/* XAT */
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XAT,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XAT,
 			USB_DEVICE_ID_XAT_CSR) },
 
 	/* Xiroku */
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_SPX) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_MPX) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_SPX1) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_MPX1) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR1) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_SPX2) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_MPX2) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR2) },
 
 	{ }
-- 
1.7.9.4

>From 855657442a4d83e08610ac6065fa971da001ed00 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Fri, 30 Mar 2012 18:44:14 +0200
Subject: [PATCH 3/5] hid: Parse the device before adding it

The hid bus is populated by devices created by the usb and bluetooth
subsystems. The hid device is then broadcast to userland via uevents.
Currently, the parsing of the hid reports is done during probe of
the hid device, after the device has been broadcast. In order to
allow for the report descriptors to influence the device properties,
it is desirable to parse the device _before_ it is broadcast to
userland. In actuality, the parsing depends only accidentally on
the driver being present, so it can be trivially achieved.
---
 drivers/hid/hid-core.c        |    2 +-
 drivers/hid/usbhid/hid-core.c |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 35ba9d9..8a7b59e 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -658,7 +658,7 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 		hid_parser_reserved
 	};
 
-	if (device->driver->report_fixup)
+	if (device->driver && device->driver->report_fixup)
 		start = device->driver->report_fixup(device, start, &size);
 
 	device->rdesc = kmemdup(start, size, GFP_KERNEL);
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5bf91db..e63613b 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1266,6 +1266,11 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 	if (usb_string(dev, dev->descriptor.iSerialNumber, hid->uniq, 64) <= 0)
 		hid->uniq[0] = 0;
 
+	ret = hid_parse(hid);
+	if (ret)
+		goto err;
+
+
 	usbhid = kzalloc(sizeof(*usbhid), GFP_KERNEL);
 	if (usbhid == NULL) {
 		ret = -ENOMEM;
-- 
1.7.9.4

>From 2f1c6f63d4bd3bb21968c0d435570225145cdd22 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Fri, 30 Mar 2012 18:56:51 +0200
Subject: [PATCH 4/5] hid: Add idtags to modalias

HID devices are only partially presented to userland.  Hotplugged
devices emit events containing a modalias based on the basic bus,
vendor and product entities. However, in practise a hid device can
depend on details such as a single usb interface or a particular item
in a report descriptor.

This patch adds a special interface tag to the hid device id, and
broadcasts it using both uevent and modalias. Matching ids are
introduced for the hid-multitouch driver. As a consequence, generic
hid will no longer match multitouch devices, and udev will
automatically load hid-multitouch instead.
---
 drivers/hid/hid-core.c          |   28 +++++++++++++++++++++++++---
 drivers/hid/hid-multitouch.c    |    7 ++++++-
 include/linux/hid.h             |    7 +++++++
 include/linux/mod_devicetable.h |    2 +-
 scripts/mod/file2alias.c        |    2 ++
 5 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8a7b59e..1cf6cb5 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -205,6 +205,10 @@ static int hid_add_usage(struct hid_parser *parser, unsigned usage)
 		parser->collection_stack_ptr ?
 		parser->collection_stack[parser->collection_stack_ptr - 1] : 0;
 	parser->local.usage_index++;
+
+	if (usage == HID_DG_CONTACTID)
+		parser->device->idtags |= HID_IDTAG_MULTITOUCH;
+
 	return 0;
 }
 
@@ -1154,7 +1158,7 @@ EXPORT_SYMBOL_GPL(hid_input_report);
 static bool hid_match_one_id(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
-	return id->bus == hdev->bus &&
+	return id->bus == hdev->bus && id->idtags == hdev->idtags &&
 		(id->vendor == HID_ANY_ID || id->vendor == hdev->vendor) &&
 		(id->product == HID_ANY_ID || id->product == hdev->product);
 }
@@ -1723,6 +1727,23 @@ static int hid_device_remove(struct device *dev)
 	return 0;
 }
 
+static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
+			     char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "hid:b%04Xi%04Xv%08Xp%08X\n",
+		       hdev->bus, hdev->idtags, hdev->vendor, hdev->product);
+
+	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
+}
+
+static struct device_attribute hid_dev_attrs[] = {
+	__ATTR_RO(modalias),
+	__ATTR_NULL,
+};
+
 static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
@@ -1740,8 +1761,8 @@ static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (add_uevent_var(env, "HID_UNIQ=%s", hdev->uniq))
 		return -ENOMEM;
 
-	if (add_uevent_var(env, "MODALIAS=hid:b%04Xv%08Xp%08X",
-			hdev->bus, hdev->vendor, hdev->product))
+	if (add_uevent_var(env, "MODALIAS=hid:b%04Xi%04Xv%08Xp%08X",
+			   hdev->bus, hdev->idtags, hdev->vendor, hdev->product))
 		return -ENOMEM;
 
 	return 0;
@@ -1749,6 +1770,7 @@ static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static struct bus_type hid_bus_type = {
 	.name		= "hid",
+	.dev_attrs	= hid_dev_attrs,
 	.match		= hid_bus_match,
 	.probe		= hid_device_probe,
 	.remove		= hid_device_remove,
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 421b16c..80ceab5 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -104,7 +104,7 @@ struct mt_device {
 #define MT_DEFAULT_MAXCONTACT	10
 
 #define HID_USB_MT_DEVICE(v, p)						\
-	HID_USB_DEVICE(v, p)
+	.idtags = HID_IDTAG_MULTITOUCH, HID_USB_DEVICE(v, p)
 
 /*
  * these device-dependent functions determine what slot corresponds
@@ -886,6 +886,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR2) },
 
+	/* Generic MT device */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_MT_DEVICE(HID_ANY_ID,
+			HID_ANY_ID) },
+
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mt_devices);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 5b3be43..1e68543 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -62,6 +62,12 @@
 
 #define HID_MAX_DESCRIPTOR_SIZE		4096
 
+/*
+ * HID identifying tags extracted from reports
+ */
+#define HID_IDTAG_MULTITOUCH		0x0001
+
+
 #ifdef __KERNEL__
 
 #include <linux/types.h>
@@ -473,6 +479,7 @@ struct hid_device {							/* device report descriptor */
 	unsigned maxcollection;						/* Number of parsed collections */
 	unsigned maxapplication;					/* Number of applications */
 	__u16 bus;							/* BUS ID */
+	__u16 idtags;							/* Identifying tags extracted from reports */
 	__u32 vendor;							/* Vendor ID */
 	__u32 product;							/* Product ID */
 	__u32 version;							/* HID version */
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 83ac071..25446f0 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -135,7 +135,7 @@ struct usb_device_id {
 
 struct hid_device_id {
 	__u16 bus;
-	__u16 pad1;
+	__u16 idtags;
 	__u32 vendor;
 	__u32 product;
 	kernel_ulong_t driver_data
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index b89efe6..d0c3a2b 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -336,10 +336,12 @@ static int do_hid_entry(const char *filename,
 			     struct hid_device_id *id, char *alias)
 {
 	id->bus = TO_NATIVE(id->bus);
+	id->idtags = TO_NATIVE(id->idtags);
 	id->vendor = TO_NATIVE(id->vendor);
 	id->product = TO_NATIVE(id->product);
 
 	sprintf(alias, "hid:b%04X", id->bus);
+	ADD(alias, "i", true, id->idtags);
 	ADD(alias, "v", id->vendor != HID_ANY_ID, id->vendor);
 	ADD(alias, "p", id->product != HID_ANY_ID, id->product);
 
-- 
1.7.9.4

>From b51b8d94243f032467e473c93b7e89fb616221e6 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Fri, 30 Mar 2012 19:14:52 +0200
Subject: [PATCH 5/5] hid: Remove multitouch devices from blacklist

With idtags in place, generic hid will no longer process multitouch
devices, and the ignore list can be trimmed occordingly.
---
 drivers/hid/hid-core.c |   53 ------------------------------------------------
 1 file changed, 53 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1cf6cb5..bf600af 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1310,13 +1310,10 @@ EXPORT_SYMBOL_GPL(hid_disconnect);
 
 /* a list of devices for which there is a specialized driver on HID bus */
 static const struct hid_device_id hid_have_special_driver[] = {
-	{ HID_USB_DEVICE(USB_VENDOR_ID_3M, USB_DEVICE_ID_3M1968) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_3M, USB_DEVICE_ID_3M2256) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR, USB_DEVICE_ID_ACTIONSTAR_1011) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ATV_IRCONTROL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },
@@ -1381,62 +1378,36 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_T91MT) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE_2) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT, USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CVTOUCH, USB_DEVICE_ID_CVTOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_MOUSE) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, 0x0006) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, 0x0011) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480D) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480E) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2515) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EMS, USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EZKEY, USB_DEVICE_ID_BTC_8193) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_GOODTOUCH, USB_DEVICE_ID_GOODTOUCH_000f) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0003) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0012) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_3) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_HANVON, USB_DEVICE_ID_HANVON_MULTITOUCH) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_HANVON_ALT, USB_DEVICE_ID_HANVON_ALT_MULTITOUCH) },
- 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6650) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK, USB_DEVICE_ID_HOLTEK_ON_LINE_GRIP) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ILITEK, USB_DEVICE_ID_ILITEK_MULTITOUCH) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS, USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KEYTOUCH, USB_DEVICE_ID_KEYTOUCH_IEC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 ) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_LG, USB_DEVICE_ID_LG_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
@@ -1467,8 +1438,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACETRAVELLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACENAVIGATOR) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_LUMIO, USB_DEVICE_ID_CRYSTALTOUCH) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_LUMIO, USB_DEVICE_ID_CRYSTALTOUCH_DUAL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD_BOOTLOADER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500) },
@@ -1500,13 +1469,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_PCI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_KEYBOARD) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ARVO) },
@@ -1522,9 +1486,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM, USB_DEVICE_ID_MTP) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM, USB_DEVICE_ID_MTP_STM) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX, USB_DEVICE_ID_MTP_SITRONIX) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
@@ -1536,16 +1497,12 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb65a) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED, USB_DEVICE_ID_TOPSEED_CYBERLINK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED2, USB_DEVICE_ID_TOPSEED2_RF_COMBO) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL, USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TWINHAN, USB_DEVICE_ID_TWINHAN_IR_REMOTE) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_PF1209) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP4030U) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP5540U) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP8060U) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP1062) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_UNITEC, USB_DEVICE_ID_UNITEC_USB_TOUCH_0709) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_UNITEC, USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_SMARTJOY_PLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_DUAL_USB_JOYPAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SUPER_JOY_BOX_3_PRO) },
@@ -1557,16 +1514,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SLIM_TABLET_12_1_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XAT, USB_DEVICE_ID_XAT_CSR) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_SPX) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_MPX) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_CSR) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_SPX1) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_MPX1) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_CSR1) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_SPX2) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_MPX2) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_CSR2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_X_TENSIONS, USB_DEVICE_ID_SPEEDLINK_VAD_CEZANNE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
-- 
1.7.9.4

