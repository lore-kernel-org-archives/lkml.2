Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab0EAQrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 12:47:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34574 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0EAQrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 12:47:17 -0400
Date: Sat, 1 May 2010 09:46:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH] watchdogs: fix several MODULE_PARM_DESC strings
Message-Id: <20100501094615.06fc4972.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4BDC5B0B.00D0:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix MODULE_PARM_DESC() strings in several watchdog drivers.
Some are simple as add a parenthesis.
Others are problems from __stringify() being used on a
variable name instead of a macro name, so the variable name
is produced in the string instead of its build-time value.
In these cases, create a macro for the value so that the
module param description string is useful.

Only pc87413_wdt has been built (due to toolchains).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
BTW, in ep93xx_wdt.c, I can't find where WATCHDOG_TIMEOUT is
defined.  Can someone point me to it, please?
(or does it not even build?)

 drivers/watchdog/mpc8xxx_wdt.c |    2 +-
 drivers/watchdog/pc87413_wdt.c |    8 +++++---
 drivers/watchdog/pnx833x_wdt.c |   11 +++++++----
 drivers/watchdog/s3c2410_wdt.c |    6 +++---
 drivers/watchdog/shwdt.c       |    2 +-
 drivers/watchdog/wdt977.c      |    2 +-
 6 files changed, 18 insertions(+), 13 deletions(-)

--- lnx-2634-rc6.orig/drivers/watchdog/mpc8xxx_wdt.c
+++ lnx-2634-rc6/drivers/watchdog/mpc8xxx_wdt.c
@@ -53,7 +53,7 @@ static int mpc8xxx_wdt_init_late(void);
 static u16 timeout = 0xffff;
 module_param(timeout, ushort, 0);
 MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in ticks. (0<timeout<65536, default=65535");
+	"Watchdog timeout in ticks. (0<timeout<65536, default=65535)");
 
 static int reset = 1;
 module_param(reset, bool, 0);
--- lnx-2634-rc6.orig/drivers/watchdog/pc87413_wdt.c
+++ lnx-2634-rc6/drivers/watchdog/pc87413_wdt.c
@@ -53,7 +53,9 @@
 #define WDTO                0x11	/* Watchdog timeout register */
 #define WDCFG               0x12	/* Watchdog config register */
 
-static int io = 0x2E;			/* Address used on Portwell Boards */
+#define IO_DEFAULT	0x2E		/* Address used on Portwell Boards */
+
+static int io = IO_DEFAULT;
 
 static int timeout = DEFAULT_TIMEOUT;	/* timeout value */
 static unsigned long timer_enabled;	/* is the timer enabled? */
@@ -583,12 +585,12 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(io, int, 0);
-MODULE_PARM_DESC(io, MODNAME " I/O port (default: " __MODULE_STRING(io) ").");
+MODULE_PARM_DESC(io, MODNAME " I/O port (default: " __MODULE_STRING(IO_DEFAULT) ").");
 
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout,
 		"Watchdog timeout in minutes (default="
-				__MODULE_STRING(timeout) ").");
+				__MODULE_STRING(DEFAULT_TIMEOUT) ").");
 
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout,
--- lnx-2634-rc6.orig/drivers/watchdog/pnx833x_wdt.c
+++ lnx-2634-rc6/drivers/watchdog/pnx833x_wdt.c
@@ -33,6 +33,8 @@
 #define PFX "pnx833x: "
 #define WATCHDOG_TIMEOUT 30		/* 30 sec Maximum timeout */
 #define WATCHDOG_COUNT_FREQUENCY 68000000U /* Watchdog counts at 68MHZ. */
+#define	PNX_WATCHDOG_TIMEOUT	(WATCHDOG_TIMEOUT * WATCHDOG_COUNT_FREQUENCY)
+#define PNX_TIMEOUT_VALUE	2040000000U
 
 /** CONFIG block */
 #define PNX833X_CONFIG                      (0x07000U)
@@ -47,20 +49,21 @@
 static int pnx833x_wdt_alive;
 
 /* Set default timeout in MHZ.*/
-static int pnx833x_wdt_timeout = (WATCHDOG_TIMEOUT * WATCHDOG_COUNT_FREQUENCY);
+static int pnx833x_wdt_timeout = PNX_WATCHDOG_TIMEOUT;
 module_param(pnx833x_wdt_timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Watchdog timeout in Mhz. (68Mhz clock), default="
-			__MODULE_STRING(pnx833x_wdt_timeout) "(30 seconds).");
+			__MODULE_STRING(PNX_TIMEOUT_VALUE) "(30 seconds).");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 					__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static int start_enabled = 1;
+#define START_DEFAULT	1
+static int start_enabled = START_DEFAULT;
 module_param(start_enabled, int, 0);
 MODULE_PARM_DESC(start_enabled, "Watchdog is started on module insertion "
-				"(default=" __MODULE_STRING(start_enabled) ")");
+				"(default=" __MODULE_STRING(START_DEFAULT) ")");
 
 static void pnx833x_wdt_start(void)
 {
--- lnx-2634-rc6.orig/drivers/watchdog/s3c2410_wdt.c
+++ lnx-2634-rc6/drivers/watchdog/s3c2410_wdt.c
@@ -63,7 +63,7 @@ module_param(nowayout,    int, 0);
 module_param(soft_noboot, int, 0);
 module_param(debug,	  int, 0);
 
-MODULE_PARM_DESC(tmr_margin, "Watchdog tmr_margin in seconds. default="
+MODULE_PARM_DESC(tmr_margin, "Watchdog tmr_margin in seconds. (default="
 		__MODULE_STRING(CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME) ")");
 MODULE_PARM_DESC(tmr_atboot,
 		"Watchdog is started at boot time if set to 1, default="
@@ -71,8 +71,8 @@ MODULE_PARM_DESC(tmr_atboot,
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 			__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, "
-			"0 to reboot (default depends on ONLY_TESTING)");
-MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug, (default 0)");
+			"0 to reboot (default 0)");
+MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
 
 static unsigned long open_lock;
 static struct device    *wdt_dev;	/* platform device attached to */
--- lnx-2634-rc6.orig/drivers/watchdog/wdt977.c
+++ lnx-2634-rc6/drivers/watchdog/wdt977.c
@@ -63,7 +63,7 @@ static	char expect_close;
 static	DEFINE_SPINLOCK(spinlock);
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (60..15300), default="
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (60..15300, default="
 				__MODULE_STRING(DEFAULT_TIMEOUT) ")");
 module_param(testmode, int, 0);
 MODULE_PARM_DESC(testmode, "Watchdog testmode (1 = no reboot), default=0");
--- lnx-2634-rc6.orig/drivers/watchdog/shwdt.c
+++ lnx-2634-rc6/drivers/watchdog/shwdt.c
@@ -496,7 +496,7 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 module_param(clock_division_ratio, int, 0);
 MODULE_PARM_DESC(clock_division_ratio,
 	"Clock division ratio. Valid ranges are from 0x5 (1.31ms) "
-	"to 0x7 (5.25ms). (default=" __MODULE_STRING(clock_division_ratio) ")");
+	"to 0x7 (5.25ms). (default=" __MODULE_STRING(WTCSR_CKS_4096) ")");
 
 module_param(heartbeat, int, 0);
 MODULE_PARM_DESC(heartbeat,
