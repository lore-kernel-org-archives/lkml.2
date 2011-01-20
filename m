Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1ATWn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:43:58 -0500
Received: from imx9.toshiba.co.jp ([202.33.96.51]:42229 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab1ATWn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:43:56 -0500
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2011 17:43:56 EST
Subject: [PATCH] it87_wdt: Add support for IT8721F watchdog
Date: Fri, 21 Jan 2011 07:37:51 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-ID: <C726904B48DD7B4386BEA4D639541F2502B254A8@JPDC-ML-212.jpn.toshiba-dpg.local>
Content-class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft Exchange V6.5
Thread-Topic: [PATCH] it87_wdt: Add support for IT8721F watchdog
Thread-Index: Acu48qvJUs7MYI4rQ+eQHWdffDyNtg==
From: "tomita, haruo" <haruo.tomita@toshiba.co.jp>
To: <wim@iguana.be>
Cc: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Jan 2011 22:37:52.0345 (UTC) FILETIME=[AC5B4490:01CBB8F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

This simple patch adds support for a watchdog in IT8721F Super IO
chip to it87_wdt driver.
This new chips differ from the older IT87xxxF chips 
in the following ways:

* WDT_GAMEPORT is not in IT8721F.
* WDT_PWROK is not in IT8721F.

Please apply this patch to your git.

Regards,
Haruo

diff -urpN a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig  2011-01-19 08:04:54.176307715 +0900
+++ b/drivers/watchdog/Kconfig  2011-01-19 08:11:37.363616718 +0900
@@ -580,7 +580,7 @@ config IT87_WDT
        depends on X86 && EXPERIMENTAL
        ---help---
          This is the driver for the hardware watchdog on the ITE IT8702,
-         IT8712, IT8716, IT8718, IT8720, IT8726, IT8712 Super I/O chips.
+         IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 Super I/O chips.
          This watchdog simply watches your kernel to make sure it doesn't
          freeze, and if it does, it reboots your computer after a certain
          amount of time.
diff -urpN a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
--- a/drivers/watchdog/it87_wdt.c       2011-01-05 09:50:19.000000000 +0900
+++ b/drivers/watchdog/it87_wdt.c       2011-01-19 08:11:37.364617177 +0900
@@ -12,7 +12,7 @@
  *                 http://www.ite.com.tw/
  *
  *     Support of the watchdog timers, which are available on
- *     IT8702, IT8712, IT8716, IT8718, IT8720 and IT8726.
+ *     IT8702, IT8712, IT8716, IT8718, IT8720, IT8721 and IT8726.
  *
  *     This program is free software; you can redistribute it and/or
  *     modify it under the terms of the GNU General Public License
@@ -45,7 +45,7 @@

 #include <asm/system.h>

-#define WATCHDOG_VERSION       "1.13"
+#define WATCHDOG_VERSION       "1.13.1"
 #define WATCHDOG_NAME          "IT87 WDT"
 #define PFX                    WATCHDOG_NAME ": "
 #define DRIVER_VERSION         WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
@@ -82,6 +82,7 @@
 #define IT8716_ID      0x8716
 #define IT8718_ID      0x8718
 #define IT8720_ID      0x8720
+#define        IT8721_ID       0x8721
 #define IT8726_ID      0x8726  /* the data sheet suggest wrongly 0x8716 */

 /* GPIO Configuration Registers LDN=0x07 */
@@ -94,7 +95,7 @@
 #define WDT_CIRINT     0x80
 #define WDT_MOUSEINT   0x40
 #define WDT_KYBINT     0x20
-#define WDT_GAMEPORT   0x10 /* not in it8718, it8720 */
+#define WDT_GAMEPORT   0x10 /* not in it8718, it8720, it8721 */
 #define WDT_FORCE      0x02
 #define WDT_ZERO       0x01

@@ -102,7 +103,7 @@
 #define WDT_TOV1       0x80
 #define WDT_KRST       0x40
 #define WDT_TOVE       0x20
-#define WDT_PWROK      0x10
+#define WDT_PWROK      0x10 /* not in it8721 */
 #define WDT_INT_MASK   0x0f

 /* CIR Configuration Register LDN=0x0a */
@@ -215,7 +216,9 @@ static inline void superio_outw(int val,
 /* Internal function, should be called after superio_select(GPIO) */
 static void wdt_update_timeout(void)
 {
-       unsigned char cfg = WDT_KRST | WDT_PWROK;
+       u16 chip_type =  superio_inw(CHIPID);
+       unsigned char cfg =
+               (chip_type == IT8721_ID) ? WDT_KRST: WDT_KRST | WDT_PWROK;
        int tm = timeout;

        if (testmode)
@@ -581,6 +584,7 @@ static int __init it87_wdt_init(void)
                break;
        case IT8718_ID:
        case IT8720_ID:
+       case IT8721_ID:
                max_units = 65535;
                try_gameport = 0;
                break;
