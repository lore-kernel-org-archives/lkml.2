Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0ECSnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:43:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20142 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0ECSnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:43:50 -0400
Date: Mon, 3 May 2010 11:42:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH/RFC] watchdog: update/improve/consolidate watchdog driver
 parameters
Message-Id: <20100503114252.f915b476.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BDF1964.0059:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move the limited watchdog driver help from kernel-parameters.txt
to Documentation/watchdog/watchdog-parameters.txt and add info to it
for all watchdog drivers except the ones that have driver-specific
files already.

Correct minor comments and MODULE_PARM_DESC() text in 2 places.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt            |   15 
 Documentation/watchdog/00-INDEX                |    5 
 Documentation/watchdog/watchdog-parameters.txt |  390 +++++++++++++++
 Documentation/watchdog/wdt.txt                 |   15 
 drivers/watchdog/eurotechwdt.c                 |    1 
 drivers/watchdog/wdt.c                         |    2 
 6 files changed, 411 insertions(+), 17 deletions(-)

--- lnx-2634-rc6.orig/Documentation/watchdog/00-INDEX
+++ lnx-2634-rc6/Documentation/watchdog/00-INDEX
@@ -1,10 +1,15 @@
 00-INDEX
 	- this file.
+hpwdt.txt
+	- information on the HP iLO2 NMI watchdog
 pcwd-watchdog.txt
 	- documentation for Berkshire Products PC Watchdog ISA cards.
 src/
 	- directory holding watchdog related example programs.
 watchdog-api.txt
 	- description of the Linux Watchdog driver API.
+watchdog-parameters.txt
+	- information on driver parameters (for drivers other than
+	  the ones that have driver-specific files here)
 wdt.txt
 	- description of the Watchdog Timer Interfaces for Linux.
--- lnx-2634-rc6.orig/Documentation/kernel-parameters.txt
+++ lnx-2634-rc6/Documentation/kernel-parameters.txt
@@ -287,9 +287,6 @@ and is between 256 and 4096 characters. 
 	advansys=	[HW,SCSI]
 			See header of drivers/scsi/advansys.c.
 
-	advwdt=		[HW,WDT] Advantech WDT
-			Format: <iostart>,<iostop>
-
 	aedsp16=	[HW,OSS] Audio Excel DSP 16
 			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
 			See also header of sound/oss/aedsp16.c.
@@ -754,9 +751,6 @@ and is between 256 and 4096 characters. 
 			This option is obsoleted by the "netdev=" option, which
 			has equivalent usage. See its documentation for details.
 
-	eurwdt=		[HW,WDT] Eurotech CPU-1220/1410 onboard watchdog.
-			Format: <io>[,<irq>]
-
 	failslab=
 	fail_page_alloc=
 	fail_make_request=[KNL]
@@ -2236,9 +2230,6 @@ and is between 256 and 4096 characters. 
 
 	sched_debug	[KNL] Enables verbose scheduler debug messages.
 
-	sc1200wdt=	[HW,WDT] SC1200 WDT (watchdog) driver
-			Format: <io>[,<timeout>[,<isapnp>]]
-
 	scsi_debug_*=	[SCSI]
 			See drivers/scsi/scsi_debug.c.
 
@@ -2818,8 +2809,10 @@ and is between 256 and 4096 characters. 
 	wd7000=		[HW,SCSI]
 			See header of drivers/scsi/wd7000.c.
 
-	wdt=		[WDT] Watchdog
-			See Documentation/watchdog/wdt.txt.
+	watchdog timers	[HW,WDT] For information on watchdog timers,
+			see Documentation/watchdog/watchdog-parameters.txt
+			or other driver-specific files in the
+			Documentation/watchdog/ directory.
 
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
--- lnx-2634-rc6.orig/drivers/watchdog/eurotechwdt.c
+++ lnx-2634-rc6/drivers/watchdog/eurotechwdt.c
@@ -68,7 +68,6 @@ static spinlock_t eurwdt_lock;
 
 /*
  * You must set these - there is no sane way to probe for this board.
- * You can use eurwdt=x,y to set these now.
  */
 
 static int io = 0x3f0;
--- lnx-2634-rc6.orig/Documentation/watchdog/wdt.txt
+++ lnx-2634-rc6/Documentation/watchdog/wdt.txt
@@ -14,14 +14,22 @@ reboot will depend on the state of the m
 boards physically pull the machine down off their own onboard timers and
 will reboot from almost anything.
 
-A second temperature monitoring interface is available on the WDT501P cards
+A second temperature monitoring interface is available on the WDT501P cards.
 This provides /dev/temperature. This is the machine internal temperature in
 degrees Fahrenheit. Each read returns a single byte giving the temperature.
 
 The third interface logs kernel messages on additional alert events.
 
-The wdt card cannot be safely probed for. Instead you need to pass
-wdt=ioaddr,irq as a boot parameter - eg "wdt=0x240,11".
+The ICS ISA-bus wdt card cannot be safely probed for. Instead you need to
+pass IO address and IRQ boot parameters.  E.g.:
+	wdt.io=0x240 wdt.irq=11
+
+Other "wdt" driver parameters are:
+	heartbeat	Watchdog heartbeat in seconds (default 60)
+	nowayout	Watchdog cannot be stopped once started (kernel
+				build parameter)
+	tachometer	WDT501-P Fan Tachometer support (0=disable, default=0)
+	type		WDT501-P Card type (500 or 501, default=500)
 
 Features
 --------
@@ -40,4 +48,3 @@ Minor numbers are however allocated for 
 
 
 Example Watchdog Driver:  see Documentation/watchdog/src/watchdog-simple.c
-
--- lnx-2634-rc6.orig/drivers/watchdog/wdt.c
+++ lnx-2634-rc6/drivers/watchdog/wdt.c
@@ -91,7 +91,7 @@ MODULE_PARM_DESC(tachometer,
 static int type = 500;
 module_param(type, int, 0);
 MODULE_PARM_DESC(type,
-		"WDT501-P Card type (500 or 501 , default=500)");
+		"WDT501-P Card type (500 or 501, default=500)");
 
 /*
  *	Programming support
--- /dev/null
+++ lnx-2634-rc6/Documentation/watchdog/watchdog-parameters.txt
@@ -0,0 +1,390 @@
+This file provides information on the module parameters of many of
+the Linux watchdog drivers.  Watchdog driver parameter specs should
+be listed here unless the driver has its own driver-specific information
+file.
+
+
+See Documentation/kernel-parameters.txt for information on
+providing kernel parameters for builtin drivers versus loadable
+modules.
+
+
+-------------------------------------------------
+acquirewdt:
+wdt_stop: Acquire WDT 'stop' io port (default 0x43)
+wdt_start: Acquire WDT 'start' io port (default 0x443)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+advantechwdt:
+wdt_stop: Advantech WDT 'stop' io port (default 0x443)
+wdt_start: Advantech WDT 'start' io port (default 0x443)
+timeout: Watchdog timeout in seconds. 1<= timeout <=63, default=60.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+alim1535_wdt:
+timeout: Watchdog timeout in seconds. (0 < timeout < 18000, default=60
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+alim7101_wdt:
+timeout: Watchdog timeout in seconds. (1<=timeout<=3600, default=30
+use_gpio: Use the gpio watchdog (required by old cobalt boards).
+	default=0/off/no
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ar7_wdt:
+margin: Watchdog margin in seconds (default=60)
+nowayout: Disable watchdog shutdown on close
+	(default=kernel config parameter)
+-------------------------------------------------
+at32ap700x_wdt:
+timeout: Timeout value. Limited to be 1 or 2 seconds. (default=2)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+at91rm9200_wdt:
+wdt_time: Watchdog time in seconds. (default=5)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+at91sam9_wdt:
+heartbeat: Watchdog heartbeats in seconds. (default = 15)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+bcm47xx_wdt:
+wdt_time: Watchdog time in seconds. (default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+bfin_wdt:
+timeout: Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default=20)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+coh901327_wdt:
+margin: Watchdog margin in seconds (default 60s)
+-------------------------------------------------
+cpu5wdt:
+port: base address of watchdog card, default is 0x91
+verbose: be verbose, default is 0 (no)
+ticks: count down ticks, default is 10000
+-------------------------------------------------
+cpwd:
+wd0_timeout: Default watchdog0 timeout in 1/10secs
+wd1_timeout: Default watchdog1 timeout in 1/10secs
+wd2_timeout: Default watchdog2 timeout in 1/10secs
+-------------------------------------------------
+davinci_wdt:
+heartbeat: Watchdog heartbeat period in seconds from 1 to 600, default 60
+-------------------------------------------------
+ep93xx_wdt:
+nowayout: Watchdog cannot be stopped once started
+timeout: Watchdog timeout in seconds. (1<=timeout<=3600, default=TBD)
+-------------------------------------------------
+eurotechwdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+io: Eurotech WDT io port (default=0x3f0)
+irq: Eurotech WDT irq (default=10)
+ev: Eurotech WDT event type (default is `int')
+-------------------------------------------------
+gef_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+geodewdt:
+timeout: Watchdog timeout in seconds. 1<= timeout <=131, default=60.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+i6300esb:
+heartbeat: Watchdog heartbeat in seconds. (1<heartbeat<2046, default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+iTCO_wdt:
+heartbeat: Watchdog heartbeat in seconds.
+	(2<heartbeat<39 (TCO v1) or 613 (TCO v2), default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+iTCO_vendor_support:
+vendorsupport: iTCO vendor specific support mode, default=0 (none),
+	1=SuperMicro Pent3, 2=SuperMicro Pent4+, 911=Broken SMI BIOS
+-------------------------------------------------
+ib700wdt:
+timeout: Watchdog timeout in seconds. 0<= timeout <=30, default=30.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ibmasr:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+indydog:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+iop_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+it8712f_wdt:
+margin: Watchdog margin in seconds (default 60)
+nowayout: Disable watchdog shutdown on close
+	(default=kernel config parameter)
+-------------------------------------------------
+it87_wdt:
+nogameport: Forbid the activation of game port, default=0
+exclusive: Watchdog exclusive device open, default=1
+timeout: Watchdog timeout in seconds, default=60
+testmode: Watchdog test mode (1 = no reboot), default=0
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ixp2000_wdt:
+heartbeat: Watchdog heartbeat in seconds (default 60s)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ixp4xx_wdt:
+heartbeat: Watchdog heartbeat in seconds (default 60s)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ks8695_wdt:
+wdt_time: Watchdog time in seconds. (default=5)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+machzwd:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+action: after watchdog resets, generate:
+	0 = RESET(*)  1 = SMI  2 = NMI  3 = SCI
+-------------------------------------------------
+max63xx_wdt:
+heartbeat: Watchdog heartbeat period in seconds from 1 to 60, default 60
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+nodelay: Force selection of a timeout setting without initial delay
+	(max6373/74 only, default=0)
+-------------------------------------------------
+mixcomwd:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+mpc8xxx_wdt:
+timeout: Watchdog timeout in ticks. (0<timeout<65536, default=65535)
+reset: Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+mpcore_wdt:
+mpcore_margin: MPcore timer margin in seconds.
+	(0 < mpcore_margin < 65536, default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+mpcore_noboot: MPcore watchdog action, set to 1 to ignore reboots,
+	0 to reboot (default=0
+-------------------------------------------------
+mv64x60_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+nuc900_wdt:
+heartbeat: Watchdog heartbeats in seconds.
+	(default = 15)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+omap_wdt:
+timer_margin: initial watchdog timeout (in seconds)
+-------------------------------------------------
+orion_wdt:
+heartbeat: Initial watchdog heartbeat in seconds
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+pc87413_wdt:
+io: pc87413 WDT I/O port (default: io).
+timeout: Watchdog timeout in minutes (default=timeout).
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+pika_wdt:
+heartbeat: Watchdog heartbeats in seconds. (default = 15)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+pnx4008_wdt:
+heartbeat: Watchdog heartbeat period in seconds from 1 to 60, default 19
+nowayout: Set to 1 to keep watchdog running after device release
+-------------------------------------------------
+pnx833x_wdt:
+timeout: Watchdog timeout in Mhz. (68Mhz clock), default=2040000000 (30 seconds)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+start_enabled: Watchdog is started on module insertion (default=1)
+-------------------------------------------------
+rc32434_wdt:
+timeout: Watchdog timeout value, in seconds (default=20)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+riowd:
+riowd_timeout: Watchdog timeout in minutes (default=1)
+-------------------------------------------------
+s3c2410_wdt:
+tmr_margin: Watchdog tmr_margin in seconds. (default=15)
+tmr_atboot: Watchdog is started at boot time if set to 1, default=0
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+soft_noboot: Watchdog action, set to 1 to ignore reboots, 0 to reboot
+debug: Watchdog debug, set to >1 for debug, (default 0)
+-------------------------------------------------
+sa1100_wdt:
+margin: Watchdog margin in seconds (default 60s)
+-------------------------------------------------
+sb_wdog:
+timeout: Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)
+-------------------------------------------------
+sbc60xxwdt:
+wdt_stop: SBC60xx WDT 'stop' io port (default 0x45)
+wdt_start: SBC60xx WDT 'start' io port (default 0x443)
+timeout: Watchdog timeout in seconds. (1<=timeout<=3600, default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sbc7240_wdt:
+timeout: Watchdog timeout in seconds. (1<=timeout<=255, default=30)
+nowayout: Disable watchdog when closing device file
+-------------------------------------------------
+sbc8360:
+timeout: Index into timeout table (0-63) (default=27 (60s))
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sbc_epx_c3:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sbc_fitpc2_wdt:
+margin: Watchdog margin in seconds (default 60s)
+nowayout: Watchdog cannot be stopped once started
+-------------------------------------------------
+sc1200wdt:
+isapnp: When set to 0 driver ISA PnP support will be disabled (default=1)
+io: io port
+timeout: range is 0-255 minutes, default is 1
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sc520_wdt:
+timeout: Watchdog timeout in seconds. (1 <= timeout <= 3600, default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sch311x_wdt:
+force_id: Override the detected device ID
+therm_trip: Should a ThermTrip trigger the reset generator
+timeout: Watchdog timeout in seconds. 1<= timeout <=15300, default=60
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+scx200_wdt:
+margin: Watchdog margin in seconds
+nowayout: Disable watchdog shutdown on close
+-------------------------------------------------
+shwdt:
+clock_division_ratio: Clock division ratio. Valid ranges are from 0x5 (1.31ms)
+	to 0x7 (5.25ms). (default=7)
+heartbeat: Watchdog heartbeat in seconds. (1 <= heartbeat <= 3600, default=30
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+smsc37b787_wdt:
+timeout: range is 1-255 units, default is 60
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+softdog:
+soft_margin: Watchdog soft_margin in seconds.
+	(0 < soft_margin < 65536, default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+soft_noboot: Softdog action, set to 1 to ignore reboots, 0 to reboot
+	(default=0)
+-------------------------------------------------
+stmp3xxx_wdt:
+heartbeat: Watchdog heartbeat period in seconds from 1 to 4194304, default 19
+-------------------------------------------------
+ts72xx_wdt:
+timeout: Watchdog timeout in seconds. (1 <= timeout <= 8, default=8)
+nowayout: Disable watchdog shutdown on close
+-------------------------------------------------
+twl4030_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+txx9wdt:
+timeout: Watchdog timeout in seconds. (0<timeout<N, default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+w83627hf_wdt:
+wdt_io: w83627hf/thf WDT io port (default 0x2E)
+timeout: Watchdog timeout in seconds. 1 <= timeout <= 255, default=60.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+w83697hf_wdt:
+wdt_io: w83697hf/hg WDT io port (default 0x2e, 0 = autodetect)
+timeout: Watchdog timeout in seconds. 1<= timeout <=255 (default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+early_disable: Watchdog gets disabled at boot time (default=1)
+-------------------------------------------------
+w83697ug_wdt:
+wdt_io: w83697ug/uf WDT io port (default 0x2e)
+timeout: Watchdog timeout in seconds. 1<= timeout <=255 (default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+w83877f_wdt:
+timeout: Watchdog timeout in seconds. (1<=timeout<=3600, default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+w83977f_wdt:
+timeout: Watchdog timeout in seconds (15..7635), default=45)
+testmode: Watchdog testmode (1 = no reboot), default=0
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+wafer5823wdt:
+timeout: Watchdog timeout in seconds. 1 <= timeout <= 255, default=60.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+wdt285:
+soft_margin: Watchdog timeout in seconds (default=60)
+-------------------------------------------------
+wdt977:
+timeout: Watchdog timeout in seconds (60..15300, default=60)
+testmode: Watchdog testmode (1 = no reboot), default=0
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+wm831x_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+wm8350_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
