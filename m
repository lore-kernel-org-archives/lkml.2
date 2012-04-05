Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2DEKAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:00:04 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:33971 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2DEKAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:00:00 -0400
Date: Thu, 5 Apr 2012 11:59:52 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>
Subject: Re: [rtc-linux] [PATCH 2/2 RFC] rtc-pcf8563: Add
	RTC_VL_READ/RTC_VL_CLR ioctl feature
Message-ID: <20120405095951.GT16861@axis.com>
References: <1329236025-31323-1-git-send-email-alexander.stein@systec-electronic.com> <1329236025-31323-2-git-send-email-alexander.stein@systec-electronic.com> <20120404152722.2f026ba6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404152722.2f026ba6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 12:27:22AM +0200, Andrew Morton wrote:
> On Tue, 14 Feb 2012 17:13:45 +0100
> Alexander Stein <alexander.stein@systec-electronic.com> wrote:
> 
> > Changes are based on arch/cris/arch-v10/drivers/pcf8563.c
> > 
> >  drivers/rtc/rtc-pcf8563.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
> 
> um, why does the kernel have two drivers for the same device?
> 
> arch/cris/arch-v10/drivers/pcf8563.c reimplements some of drivers/rtc/rtc-lib.c :(

That driver is an old legacy, we can remove it now that the voltage
low stuff is copied, together with the ds1302 driver which is also
duplicated in the crisv10 arch. Something like:

CRIS: Remove legacy RTC drivers

These old drivers are not used anymore, we use the ones in drivers/rtc.
This allows us to remove some cruft in the CRIS timekeeping code.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/drivers/ds1302.c   |  515 ---------------------------------
 arch/cris/arch-v10/drivers/pcf8563.c  |  380 ------------------------
 arch/cris/arch-v10/kernel/fasttimer.c |    2 -
 arch/cris/arch-v10/kernel/time.c      |    9 -
 arch/cris/arch-v32/kernel/time.c      |    7 -
 arch/cris/include/asm/Kbuild          |    1 -
 arch/cris/include/asm/rtc.h           |  107 -------
 arch/cris/kernel/time.c               |   76 +-----
 8 files changed, 7 insertions(+), 1090 deletions(-)
 delete mode 100644 arch/cris/arch-v10/drivers/ds1302.c
 delete mode 100644 arch/cris/arch-v10/drivers/pcf8563.c
 delete mode 100644 arch/cris/include/asm/rtc.h

diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
deleted file mode 100644
index 74f99c6..0000000
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ /dev/null
@@ -1,515 +0,0 @@
-/*!***************************************************************************
-*!
-*! FILE NAME  : ds1302.c
-*!
-*! DESCRIPTION: Implements an interface for the DS1302 RTC through Etrax I/O
-*!
-*! Functions exported: ds1302_readreg, ds1302_writereg, ds1302_init
-*!
-*! ---------------------------------------------------------------------------
-*!
-*! (C) Copyright 1999-2007 Axis Communications AB, LUND, SWEDEN
-*!
-*!***************************************************************************/
-
-
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/miscdevice.h>
-#include <linux/delay.h>
-#include <linux/mutex.h>
-#include <linux/bcd.h>
-#include <linux/capability.h>
-
-#include <asm/uaccess.h>
-#include <arch/svinto.h>
-#include <asm/io.h>
-#include <asm/rtc.h>
-#include <arch/io_interface_mux.h>
-
-#include "i2c.h"
-
-#define RTC_MAJOR_NR 121 /* local major, change later */
-
-static DEFINE_MUTEX(ds1302_mutex);
-static const char ds1302_name[] = "ds1302";
-
-/* The DS1302 might be connected to different bits on different products. 
- * It has three signals - SDA, SCL and RST. RST and SCL are always outputs,
- * but SDA can have a selected direction.
- * For now, only PORT_PB is hardcoded.
- */
-
-/* The RST bit may be on either the Generic Port or Port PB. */
-#ifdef CONFIG_ETRAX_DS1302_RST_ON_GENERIC_PORT
-#define TK_RST_OUT(x) REG_SHADOW_SET(R_PORT_G_DATA,  port_g_data_shadow,  CONFIG_ETRAX_DS1302_RSTBIT, x)
-#define TK_RST_DIR(x)
-#else
-#define TK_RST_OUT(x) REG_SHADOW_SET(R_PORT_PB_DATA, port_pb_data_shadow, CONFIG_ETRAX_DS1302_RSTBIT, x)
-#define TK_RST_DIR(x) REG_SHADOW_SET(R_PORT_PB_DIR,  port_pb_dir_shadow,  CONFIG_ETRAX_DS1302_RSTBIT, x)
-#endif
-
-
-#define TK_SDA_OUT(x) REG_SHADOW_SET(R_PORT_PB_DATA, port_pb_data_shadow, CONFIG_ETRAX_DS1302_SDABIT, x)
-#define TK_SCL_OUT(x) REG_SHADOW_SET(R_PORT_PB_DATA, port_pb_data_shadow, CONFIG_ETRAX_DS1302_SCLBIT, x)
-
-#define TK_SDA_IN()   ((*R_PORT_PB_READ >> CONFIG_ETRAX_DS1302_SDABIT) & 1)
-/* 1 is out, 0 is in */
-#define TK_SDA_DIR(x) REG_SHADOW_SET(R_PORT_PB_DIR,  port_pb_dir_shadow,  CONFIG_ETRAX_DS1302_SDABIT, x)
-#define TK_SCL_DIR(x) REG_SHADOW_SET(R_PORT_PB_DIR,  port_pb_dir_shadow,  CONFIG_ETRAX_DS1302_SCLBIT, x)
-
-
-/*
- * The reason for tempudelay and not udelay is that loops_per_usec
- * (used in udelay) is not set when functions here are called from time.c 
- */
-
-static void tempudelay(int usecs) 
-{
-	volatile int loops;
-
-	for(loops = usecs * 12; loops > 0; loops--)
-		/* nothing */;	
-}
-
-
-/* Send 8 bits. */
-static void
-out_byte(unsigned char x) 
-{
-	int i;
-	TK_SDA_DIR(1);
-	for (i = 8; i--;) {
-		/* The chip latches incoming bits on the rising edge of SCL. */
-		TK_SCL_OUT(0);
-		TK_SDA_OUT(x & 1);
-		tempudelay(1);
-		TK_SCL_OUT(1);
-		tempudelay(1);
-		x >>= 1;
-	}
-	TK_SDA_DIR(0);
-}
-
-static unsigned char
-in_byte(void) 
-{
-	unsigned char x = 0;
-	int i;
-
-	/* Read byte. Bits come LSB first, on the falling edge of SCL.
-	 * Assume SDA is in input direction already.
-	 */
-	TK_SDA_DIR(0);
-
-	for (i = 8; i--;) {
-		TK_SCL_OUT(0);
-		tempudelay(1);
-		x >>= 1;
-		x |= (TK_SDA_IN() << 7);
-		TK_SCL_OUT(1);
-		tempudelay(1);
-	}
-
-	return x;
-}
-
-/* Prepares for a transaction by de-activating RST (active-low). */
-
-static void
-start(void) 
-{
-	TK_SCL_OUT(0);
-	tempudelay(1);
-	TK_RST_OUT(0);
-	tempudelay(5);
-	TK_RST_OUT(1);	
-}
-
-/* Ends a transaction by taking RST active again. */
-
-static void
-stop(void) 
-{
-	tempudelay(2);
-	TK_RST_OUT(0);
-}
-
-/* Enable writing. */
-
-static void
-ds1302_wenable(void) 
-{
-	start(); 	
-	out_byte(0x8e); /* Write control register  */
-	out_byte(0x00); /* Disable write protect bit 7 = 0 */
-	stop();
-}
-
-/* Disable writing. */
-
-static void
-ds1302_wdisable(void) 
-{
-	start();
-	out_byte(0x8e); /* Write control register  */
-	out_byte(0x80); /* Disable write protect bit 7 = 0 */
-	stop();
-}
-
-
-
-/* Read a byte from the selected register in the DS1302. */
-
-unsigned char
-ds1302_readreg(int reg) 
-{
-	unsigned char x;
-
-	start();
-	out_byte(0x81 | (reg << 1)); /* read register */
-	x = in_byte();
-	stop();
-
-	return x;
-}
-
-/* Write a byte to the selected register. */
-
-void
-ds1302_writereg(int reg, unsigned char val) 
-{
-#ifndef CONFIG_ETRAX_RTC_READONLY
-	int do_writereg = 1;
-#else
-	int do_writereg = 0;
-
-	if (reg == RTC_TRICKLECHARGER)
-		do_writereg = 1;
-#endif
-
-	if (do_writereg) {
-		ds1302_wenable();
-		start();
-		out_byte(0x80 | (reg << 1)); /* write register */
-		out_byte(val);
-		stop();
-		ds1302_wdisable();
-	}
-}
-
-void
-get_rtc_time(struct rtc_time *rtc_tm) 
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	rtc_tm->tm_sec = CMOS_READ(RTC_SECONDS);
-	rtc_tm->tm_min = CMOS_READ(RTC_MINUTES);
-	rtc_tm->tm_hour = CMOS_READ(RTC_HOURS);
-	rtc_tm->tm_mday = CMOS_READ(RTC_DAY_OF_MONTH);
-	rtc_tm->tm_mon = CMOS_READ(RTC_MONTH);
-	rtc_tm->tm_year = CMOS_READ(RTC_YEAR);
-
-	local_irq_restore(flags);
-	
-	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
-	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
-	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
-	rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
-	rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
-	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
-
-	/*
-	 * Account for differences between how the RTC uses the values
-	 * and how they are defined in a struct rtc_time;
-	 */
-
-	if (rtc_tm->tm_year <= 69)
-		rtc_tm->tm_year += 100;
-
-	rtc_tm->tm_mon--;
-}
-
-static unsigned char days_in_mo[] = 
-    {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
-
-/* ioctl that supports RTC_RD_TIME and RTC_SET_TIME (read and set time/date). */
-
-static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	unsigned long flags;
-
-	switch(cmd) {
-		case RTC_RD_TIME:	/* read the time/date from RTC	*/
-		{
-			struct rtc_time rtc_tm;
-						
-			memset(&rtc_tm, 0, sizeof (struct rtc_time));
-			get_rtc_time(&rtc_tm);						
-			if (copy_to_user((struct rtc_time*)arg, &rtc_tm, sizeof(struct rtc_time)))
-				return -EFAULT;	
-			return 0;
-		}
-
-		case RTC_SET_TIME:	/* set the RTC */
-		{
-			struct rtc_time rtc_tm;
-			unsigned char mon, day, hrs, min, sec, leap_yr;
-			unsigned int yrs;
-
-			if (!capable(CAP_SYS_TIME))
-				return -EPERM;
-
-			if (copy_from_user(&rtc_tm, (struct rtc_time*)arg, sizeof(struct rtc_time)))
-				return -EFAULT;
-
-			yrs = rtc_tm.tm_year + 1900;
-			mon = rtc_tm.tm_mon + 1;   /* tm_mon starts at zero */
-			day = rtc_tm.tm_mday;
-			hrs = rtc_tm.tm_hour;
-			min = rtc_tm.tm_min;
-			sec = rtc_tm.tm_sec;
-			
-			
-			if ((yrs < 1970) || (yrs > 2069))
-				return -EINVAL;
-
-			leap_yr = ((!(yrs % 4) && (yrs % 100)) || !(yrs % 400));
-
-			if ((mon > 12) || (day == 0))
-				return -EINVAL;
-
-			if (day > (days_in_mo[mon] + ((mon == 2) && leap_yr)))
-				return -EINVAL;
-			
-			if ((hrs >= 24) || (min >= 60) || (sec >= 60))
-				return -EINVAL;
-
-			if (yrs >= 2000)
-				yrs -= 2000;	/* RTC (0, 1, ... 69) */
-			else
-				yrs -= 1900;	/* RTC (70, 71, ... 99) */
-
-			sec = bin2bcd(sec);
-			min = bin2bcd(min);
-			hrs = bin2bcd(hrs);
-			day = bin2bcd(day);
-			mon = bin2bcd(mon);
-			yrs = bin2bcd(yrs);
-
-			local_irq_save(flags);
-			CMOS_WRITE(yrs, RTC_YEAR);
-			CMOS_WRITE(mon, RTC_MONTH);
-			CMOS_WRITE(day, RTC_DAY_OF_MONTH);
-			CMOS_WRITE(hrs, RTC_HOURS);
-			CMOS_WRITE(min, RTC_MINUTES);
-			CMOS_WRITE(sec, RTC_SECONDS);
-			local_irq_restore(flags);
-
-			/* Notice that at this point, the RTC is updated but
-			 * the kernel is still running with the old time.
-			 * You need to set that separately with settimeofday
-			 * or adjtimex.
-			 */
-			return 0;
-		}
-
-		case RTC_SET_CHARGE: /* set the RTC TRICKLE CHARGE register */
-		{
-			int tcs_val;
-
-			if (!capable(CAP_SYS_TIME))
-				return -EPERM;
-			
-			if(copy_from_user(&tcs_val, (int*)arg, sizeof(int)))
-				return -EFAULT;
-
-			tcs_val = RTC_TCR_PATTERN | (tcs_val & 0x0F);
-			ds1302_writereg(RTC_TRICKLECHARGER, tcs_val);
-			return 0;
-		}
-		case RTC_VL_READ:
-		{
-			/* TODO:
-			 * Implement voltage low detection support
-			 */
-			printk(KERN_WARNING "DS1302: RTC Voltage Low detection"
-			       " is not supported\n");
-			return 0;
-		}
-		case RTC_VL_CLR:
-		{
-			/* TODO:
-			 * Nothing to do since Voltage Low detection is not supported
-			 */
-			return 0;
-		}
-		default:
-			return -ENOIOCTLCMD;
-	}
-}
-
-static long rtc_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	int ret;
-
-	mutex_lock(&ds1302_mutex);
-	ret = rtc_ioctl(file, cmd, arg);
-	mutex_unlock(&ds1302_mutex);
-
-	return ret;
-}
-
-static void
-print_rtc_status(void)
-{
-	struct rtc_time tm;
-
-	get_rtc_time(&tm);
-
-	/*
-	 * There is no way to tell if the luser has the RTC set for local
-	 * time or for Universal Standard Time (GMT). Probably local though.
-	 */
-
-	printk(KERN_INFO "rtc_time\t: %02d:%02d:%02d\n",
-	       tm.tm_hour, tm.tm_min, tm.tm_sec);
-	printk(KERN_INFO "rtc_date\t: %04d-%02d-%02d\n",
-	       tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday);
-}
-
-/* The various file operations we support. */
-
-static const struct file_operations rtc_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl = rtc_unlocked_ioctl,
-	.llseek		= noop_llseek,
-}; 
-
-/* Probe for the chip by writing something to its RAM and try reading it back. */
-
-#define MAGIC_PATTERN 0x42
-
-static int __init
-ds1302_probe(void) 
-{
-	int retval, res; 
-
-	TK_RST_DIR(1);
-	TK_SCL_DIR(1);
-	TK_SDA_DIR(0);
-	
-	/* Try to talk to timekeeper. */
-
-	ds1302_wenable();  
-	start();
-	out_byte(0xc0); /* write RAM byte 0 */	
-	out_byte(MAGIC_PATTERN); /* write something magic */
-	start();
-	out_byte(0xc1); /* read RAM byte 0 */
-
-	if((res = in_byte()) == MAGIC_PATTERN) {
-		stop();
-		ds1302_wdisable();
-		printk(KERN_INFO "%s: RTC found.\n", ds1302_name);
-		printk(KERN_INFO "%s: SDA, SCL, RST on PB%i, PB%i, %s%i\n",
-		       ds1302_name,
-		       CONFIG_ETRAX_DS1302_SDABIT,
-		       CONFIG_ETRAX_DS1302_SCLBIT,
-#ifdef CONFIG_ETRAX_DS1302_RST_ON_GENERIC_PORT
-		       "GENIO",
-#else
-		       "PB",
-#endif
-		       CONFIG_ETRAX_DS1302_RSTBIT);
-		       print_rtc_status();
-		retval = 1;
-	} else {
-		stop();
-		retval = 0;
-	}
-
-	return retval;
-}
-
-
-/* Just probe for the RTC and register the device to handle the ioctl needed. */
-
-int __init
-ds1302_init(void) 
-{
-#ifdef CONFIG_ETRAX_I2C
-	i2c_init();
-#endif
-
-	if (!ds1302_probe()) {
-#ifdef CONFIG_ETRAX_DS1302_RST_ON_GENERIC_PORT
-#if CONFIG_ETRAX_DS1302_RSTBIT == 27
-		/*
-		 * The only way to set g27 to output is to enable ATA.
-		 *
-		 * Make sure that R_GEN_CONFIG is setup correct.
-		 */
-		/* Allocating the ATA interface will grab almost all
-		 * pins in I/O groups a, b, c and d.  A consequence of
-		 * allocating the ATA interface is that the fixed
-		 * interfaces shared RAM, parallel port 0, parallel
-		 * port 1, parallel port W, SCSI-8 port 0, SCSI-8 port
-		 * 1, SCSI-W, serial port 2, serial port 3,
-		 * synchronous serial port 3 and USB port 2 and almost
-		 * all GPIO pins on port g cannot be used.
-		 */
-		if (cris_request_io_interface(if_ata, "ds1302/ATA")) {
-			printk(KERN_WARNING "ds1302: Failed to get IO interface\n");
-			return -1;
-		}
-
-#elif CONFIG_ETRAX_DS1302_RSTBIT == 0
-		if (cris_io_interface_allocate_pins(if_gpio_grp_a,
-						    'g',
-						    CONFIG_ETRAX_DS1302_RSTBIT,
-						    CONFIG_ETRAX_DS1302_RSTBIT)) {
-			printk(KERN_WARNING "ds1302: Failed to get IO interface\n");
-			return -1;
-		}
-
-		/* Set the direction of this bit to out. */
-		genconfig_shadow = ((genconfig_shadow &
- 				     ~IO_MASK(R_GEN_CONFIG, g0dir)) |
- 				   (IO_STATE(R_GEN_CONFIG, g0dir, out)));
-		*R_GEN_CONFIG = genconfig_shadow;
-#endif
-		if (!ds1302_probe()) {
-			printk(KERN_WARNING "%s: RTC not found.\n", ds1302_name);
-			return -1;
-		}
-#else
-		printk(KERN_WARNING "%s: RTC not found.\n", ds1302_name);
-		return -1;
-#endif
-  	}
-	/* Initialise trickle charger */
-	ds1302_writereg(RTC_TRICKLECHARGER,
-			RTC_TCR_PATTERN |(CONFIG_ETRAX_DS1302_TRICKLE_CHARGE & 0x0F));
-        /* Start clock by resetting CLOCK_HALT */
-	ds1302_writereg(RTC_SECONDS, (ds1302_readreg(RTC_SECONDS) & 0x7F));
-	return 0;
-}
-
-static int __init ds1302_register(void)
-{
-	ds1302_init();
-	if (register_chrdev(RTC_MAJOR_NR, ds1302_name, &rtc_fops)) {
-		printk(KERN_INFO "%s: unable to get major %d for rtc\n", 
-		       ds1302_name, RTC_MAJOR_NR);
-		return -1;
-	}
-        return 0;
-
-}
-
-module_init(ds1302_register);
diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
deleted file mode 100644
index 9da0568..0000000
--- a/arch/cris/arch-v10/drivers/pcf8563.c
+++ /dev/null
@@ -1,380 +0,0 @@
-/*
- * PCF8563 RTC
- *
- * From Phillips' datasheet:
- *
- * The PCF8563 is a CMOS real-time clock/calendar optimized for low power
- * consumption. A programmable clock output, interrupt output and voltage
- * low detector are also provided. All address and data are transferred
- * serially via two-line bidirectional I2C-bus. Maximum bus speed is
- * 400 kbits/s. The built-in word address register is incremented
- * automatically after each written or read byte.
- *
- * Copyright (c) 2002-2007, Axis Communications AB
- * All rights reserved.
- *
- * Author: Tobias Anderberg <tobiasa@axis.com>.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/fs.h>
-#include <linux/ioctl.h>
-#include <linux/delay.h>
-#include <linux/bcd.h>
-#include <linux/mutex.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
-#include <asm/rtc.h>
-
-#include "i2c.h"
-
-#define PCF8563_MAJOR 121	/* Local major number. */
-#define DEVICE_NAME "rtc"	/* Name which is registered in /proc/devices. */
-#define PCF8563_NAME "PCF8563"
-#define DRIVER_VERSION "$Revision: 1.24 $"
-
-/* I2C bus slave registers. */
-#define RTC_I2C_READ		0xa3
-#define RTC_I2C_WRITE		0xa2
-
-/* Two simple wrapper macros, saves a few keystrokes. */
-#define rtc_read(x) i2c_readreg(RTC_I2C_READ, x)
-#define rtc_write(x,y) i2c_writereg(RTC_I2C_WRITE, x, y)
-
-static DEFINE_MUTEX(pcf8563_mutex);
-static DEFINE_MUTEX(rtc_lock); /* Protect state etc */
-
-static const unsigned char days_in_month[] =
-	{ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
-
-static long pcf8563_unlocked_ioctl(struct file *, unsigned int, unsigned long);
-
-/* Cache VL bit value read at driver init since writing the RTC_SECOND
- * register clears the VL status.
- */
-static int voltage_low;
-
-static const struct file_operations pcf8563_fops = {
-	.owner = THIS_MODULE,
-	.unlocked_ioctl = pcf8563_unlocked_ioctl,
-	.llseek		= noop_llseek,
-};
-
-unsigned char
-pcf8563_readreg(int reg)
-{
-	unsigned char res = rtc_read(reg);
-
-	/* The PCF8563 does not return 0 for unimplemented bits. */
-	switch (reg) {
-	case RTC_SECONDS:
-	case RTC_MINUTES:
-		res &= 0x7F;
-		break;
-	case RTC_HOURS:
-	case RTC_DAY_OF_MONTH:
-		res &= 0x3F;
-		break;
-	case RTC_WEEKDAY:
-		res &= 0x07;
-		break;
-	case RTC_MONTH:
-		res &= 0x1F;
-		break;
-	case RTC_CONTROL1:
-		res &= 0xA8;
-		break;
-	case RTC_CONTROL2:
-		res &= 0x1F;
-		break;
-	case RTC_CLOCKOUT_FREQ:
-	case RTC_TIMER_CONTROL:
-		res &= 0x83;
-		break;
-	}
-	return res;
-}
-
-void
-pcf8563_writereg(int reg, unsigned char val)
-{
-	rtc_write(reg, val);
-}
-
-void
-get_rtc_time(struct rtc_time *tm)
-{
-	tm->tm_sec  = rtc_read(RTC_SECONDS);
-	tm->tm_min  = rtc_read(RTC_MINUTES);
-	tm->tm_hour = rtc_read(RTC_HOURS);
-	tm->tm_mday = rtc_read(RTC_DAY_OF_MONTH);
-	tm->tm_wday = rtc_read(RTC_WEEKDAY);
-	tm->tm_mon  = rtc_read(RTC_MONTH);
-	tm->tm_year = rtc_read(RTC_YEAR);
-
-	if (tm->tm_sec & 0x80) {
-		printk(KERN_ERR "%s: RTC Voltage Low - reliable date/time "
-		       "information is no longer guaranteed!\n", PCF8563_NAME);
-	}
-
-	tm->tm_year  = bcd2bin(tm->tm_year) +
-		       ((tm->tm_mon & 0x80) ? 100 : 0);
-	tm->tm_sec  &= 0x7F;
-	tm->tm_min  &= 0x7F;
-	tm->tm_hour &= 0x3F;
-	tm->tm_mday &= 0x3F;
-	tm->tm_wday &= 0x07; /* Not coded in BCD. */
-	tm->tm_mon  &= 0x1F;
-
-	tm->tm_sec = bcd2bin(tm->tm_sec);
-	tm->tm_min = bcd2bin(tm->tm_min);
-	tm->tm_hour = bcd2bin(tm->tm_hour);
-	tm->tm_mday = bcd2bin(tm->tm_mday);
-	tm->tm_mon = bcd2bin(tm->tm_mon);
-	tm->tm_mon--; /* Month is 1..12 in RTC but 0..11 in linux */
-}
-
-int __init
-pcf8563_init(void)
-{
-	static int res;
-	static int first = 1;
-
-	if (!first)
-		return res;
-	first = 0;
-
-	/* Initiate the i2c protocol. */
-	res = i2c_init();
-	if (res < 0) {
-		printk(KERN_CRIT "pcf8563_init: Failed to init i2c.\n");
-		return res;
-	}
-
-	/*
-	 * First of all we need to reset the chip. This is done by
-	 * clearing control1, control2 and clk freq and resetting
-	 * all alarms.
-	 */
-	if (rtc_write(RTC_CONTROL1, 0x00) < 0)
-		goto err;
-
-	if (rtc_write(RTC_CONTROL2, 0x00) < 0)
-		goto err;
-
-	if (rtc_write(RTC_CLOCKOUT_FREQ, 0x00) < 0)
-		goto err;
-
-	if (rtc_write(RTC_TIMER_CONTROL, 0x03) < 0)
-		goto err;
-
-	/* Reset the alarms. */
-	if (rtc_write(RTC_MINUTE_ALARM, 0x80) < 0)
-		goto err;
-
-	if (rtc_write(RTC_HOUR_ALARM, 0x80) < 0)
-		goto err;
-
-	if (rtc_write(RTC_DAY_ALARM, 0x80) < 0)
-		goto err;
-
-	if (rtc_write(RTC_WEEKDAY_ALARM, 0x80) < 0)
-		goto err;
-
-	/* Check for low voltage, and warn about it. */
-	if (rtc_read(RTC_SECONDS) & 0x80) {
-		voltage_low = 1;
-		printk(KERN_WARNING "%s: RTC Voltage Low - reliable "
-		       "date/time information is no longer guaranteed!\n",
-		       PCF8563_NAME);
-	}
-
-	return res;
-
-err:
-	printk(KERN_INFO "%s: Error initializing chip.\n", PCF8563_NAME);
-	res = -1;
-	return res;
-}
-
-void __exit
-pcf8563_exit(void)
-{
-	unregister_chrdev(PCF8563_MAJOR, DEVICE_NAME);
-}
-
-/*
- * ioctl calls for this driver. Why return -ENOTTY upon error? Because
- * POSIX says so!
- */
-static int pcf8563_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
-{
-	/* Some sanity checks. */
-	if (_IOC_TYPE(cmd) != RTC_MAGIC)
-		return -ENOTTY;
-
-	if (_IOC_NR(cmd) > RTC_MAX_IOCTL)
-		return -ENOTTY;
-
-	switch (cmd) {
-	case RTC_RD_TIME:
-	{
-		struct rtc_time tm;
-
-		mutex_lock(&rtc_lock);
-		memset(&tm, 0, sizeof tm);
-		get_rtc_time(&tm);
-
-		if (copy_to_user((struct rtc_time *) arg, &tm,
-				 sizeof tm)) {
-			mutex_unlock(&rtc_lock);
-			return -EFAULT;
-		}
-
-		mutex_unlock(&rtc_lock);
-
-		return 0;
-	}
-	case RTC_SET_TIME:
-	{
-		int leap;
-		int year;
-		int century;
-		struct rtc_time tm;
-
-		memset(&tm, 0, sizeof tm);
-		if (!capable(CAP_SYS_TIME))
-			return -EPERM;
-
-		if (copy_from_user(&tm, (struct rtc_time *) arg, sizeof tm))
-			return -EFAULT;
-
-		/* Convert from struct tm to struct rtc_time. */
-		tm.tm_year += 1900;
-		tm.tm_mon += 1;
-
-		/*
-		 * Check if tm.tm_year is a leap year. A year is a leap
-		 * year if it is divisible by 4 but not 100, except
-		 * that years divisible by 400 _are_ leap years.
-		 */
-		year = tm.tm_year;
-		leap = (tm.tm_mon == 2) &&
-			((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);
-
-		/* Perform some sanity checks. */
-		if ((tm.tm_year < 1970) ||
-		    (tm.tm_mon > 12) ||
-		    (tm.tm_mday == 0) ||
-		    (tm.tm_mday > days_in_month[tm.tm_mon] + leap) ||
-		    (tm.tm_wday >= 7) ||
-		    (tm.tm_hour >= 24) ||
-		    (tm.tm_min >= 60) ||
-		    (tm.tm_sec >= 60))
-			return -EINVAL;
-
-		century = (tm.tm_year >= 2000) ? 0x80 : 0;
-		tm.tm_year = tm.tm_year % 100;
-
-		tm.tm_year = bin2bcd(tm.tm_year);
-		tm.tm_mon = bin2bcd(tm.tm_mon);
-		tm.tm_mday = bin2bcd(tm.tm_mday);
-		tm.tm_hour = bin2bcd(tm.tm_hour);
-		tm.tm_min = bin2bcd(tm.tm_min);
-		tm.tm_sec = bin2bcd(tm.tm_sec);
-		tm.tm_mon |= century;
-
-		mutex_lock(&rtc_lock);
-
-		rtc_write(RTC_YEAR, tm.tm_year);
-		rtc_write(RTC_MONTH, tm.tm_mon);
-		rtc_write(RTC_WEEKDAY, tm.tm_wday); /* Not coded in BCD. */
-		rtc_write(RTC_DAY_OF_MONTH, tm.tm_mday);
-		rtc_write(RTC_HOURS, tm.tm_hour);
-		rtc_write(RTC_MINUTES, tm.tm_min);
-		rtc_write(RTC_SECONDS, tm.tm_sec);
-
-		mutex_unlock(&rtc_lock);
-
-		return 0;
-	}
-	case RTC_VL_READ:
-		if (voltage_low) {
-			printk(KERN_ERR "%s: RTC Voltage Low - "
-			       "reliable date/time information is no "
-			       "longer guaranteed!\n", PCF8563_NAME);
-		}
-
-		if (copy_to_user((int *) arg, &voltage_low, sizeof(int)))
-			return -EFAULT;
-		return 0;
-
-	case RTC_VL_CLR:
-	{
-		/* Clear the VL bit in the seconds register in case
-		 * the time has not been set already (which would
-		 * have cleared it). This does not really matter
-		 * because of the cached voltage_low value but do it
-		 * anyway for consistency. */
-
-		int ret = rtc_read(RTC_SECONDS);
-
-		rtc_write(RTC_SECONDS, (ret & 0x7F));
-
-		/* Clear the cached value. */
-		voltage_low = 0;
-
-		return 0;
-	}
-	default:
-		return -ENOTTY;
-	}
-
-	return 0;
-}
-
-static long pcf8563_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
-{
-	int ret;
-
-	mutex_lock(&pcf8563_mutex);
-	ret = pcf8563_ioctl(filp, cmd, arg);
-	mutex_unlock(&pcf8563_mutex);
-
-	return ret;
-}
-
-static int __init pcf8563_register(void)
-{
-	if (pcf8563_init() < 0) {
-		printk(KERN_INFO "%s: Unable to initialize Real-Time Clock "
-		       "Driver, %s\n", PCF8563_NAME, DRIVER_VERSION);
-		return -1;
-	}
-
-	if (register_chrdev(PCF8563_MAJOR, DEVICE_NAME, &pcf8563_fops) < 0) {
-		printk(KERN_INFO "%s: Unable to get major number %d for RTC device.\n",
-		       PCF8563_NAME, PCF8563_MAJOR);
-		return -1;
-	}
-
-	printk(KERN_INFO "%s Real-Time Clock Driver, %s\n", PCF8563_NAME,
-	       DRIVER_VERSION);
-
-	/* Check for low voltage, and warn about it. */
-	if (voltage_low) {
-		printk(KERN_WARNING "%s: RTC Voltage Low - reliable date/time "
-		       "information is no longer guaranteed!\n", PCF8563_NAME);
-	}
-
-	return 0;
-}
-
-module_init(pcf8563_register);
-module_exit(pcf8563_exit);
diff --git a/arch/cris/arch-v10/kernel/fasttimer.c b/arch/cris/arch-v10/kernel/fasttimer.c
index 8a8196e..082f189 100644
--- a/arch/cris/arch-v10/kernel/fasttimer.c
+++ b/arch/cris/arch-v10/kernel/fasttimer.c
@@ -21,8 +21,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/delay.h>
-#include <asm/rtc.h>
-
 
 #include <arch/svinto.h>
 #include <asm/fasttimer.h>
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 20c85b5..bcffcb6 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -19,16 +19,12 @@
 #include <asm/signal.h>
 #include <asm/io.h>
 #include <asm/delay.h>
-#include <asm/rtc.h>
 #include <asm/irq_regs.h>
 
 /* define this if you need to use print_timestamp */
 /* it will make jiffies at 96 hz instead of 100 hz though */
 #undef USE_CASCADE_TIMERS
 
-extern int set_rtc_mmss(unsigned long nowtime);
-extern int have_rtc;
-
 unsigned long get_ns_in_jiffie(void)
 {
 	unsigned char timer_count, t1;
@@ -203,11 +199,6 @@ time_init(void)
 	 */
 	loops_per_usec = 50;
 
-	if(RTC_INIT() < 0)
-		have_rtc = 0;
-	else
-		have_rtc = 1;
-
 	/* Setup the etrax timers
 	 * Base frequency is 25000 hz, divider 250 -> 100 HZ
 	 * In normal mode, we use timer0, so timer1 is free. In cascade
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index 6773fc8..8c4b45e 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -18,7 +18,6 @@
 #include <asm/signal.h>
 #include <asm/io.h>
 #include <asm/delay.h>
-#include <asm/rtc.h>
 #include <asm/irq.h>
 #include <asm/irq_regs.h>
 
@@ -67,7 +66,6 @@ unsigned long timer_regs[NR_CPUS] =
 };
 
 extern int set_rtc_mmss(unsigned long nowtime);
-extern int have_rtc;
 
 #ifdef CONFIG_CPU_FREQ
 static int
@@ -265,11 +263,6 @@ void __init time_init(void)
 	 */
 	loops_per_usec = 50;
 
-	if(RTC_INIT() < 0)
-		have_rtc = 0;
-	else
-		have_rtc = 1;
-
 	/* Start CPU local timer. */
 	cris_timer_init();
 
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 956eea2..04d02a5 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -6,5 +6,4 @@ header-y += arch-v32/
 header-y += ethernet.h
 header-y += etraxgpio.h
 header-y += rs485.h
-header-y += rtc.h
 header-y += sync_serial.h
diff --git a/arch/cris/include/asm/rtc.h b/arch/cris/include/asm/rtc.h
deleted file mode 100644
index 17d3019..0000000
--- a/arch/cris/include/asm/rtc.h
+++ /dev/null
@@ -1,107 +0,0 @@
-
-#ifndef __RTC_H__
-#define __RTC_H__
-
-#ifdef CONFIG_ETRAX_DS1302
-   /* Dallas DS1302 clock/calendar register numbers. */
-#  define RTC_SECONDS      0
-#  define RTC_MINUTES      1
-#  define RTC_HOURS        2
-#  define RTC_DAY_OF_MONTH 3
-#  define RTC_MONTH        4
-#  define RTC_WEEKDAY      5
-#  define RTC_YEAR         6
-#  define RTC_CONTROL      7
-
-   /* Bits in CONTROL register. */
-#  define RTC_CONTROL_WRITEPROTECT	0x80
-#  define RTC_TRICKLECHARGER		8
-
-  /* Bits in TRICKLECHARGER register TCS TCS TCS TCS DS DS RS RS. */
-#  define RTC_TCR_PATTERN	0xA0	/* 1010xxxx */
-#  define RTC_TCR_1DIOD		0x04	/* xxxx01xx */
-#  define RTC_TCR_2DIOD		0x08	/* xxxx10xx */
-#  define RTC_TCR_DISABLED	0x00	/* xxxxxx00 Disabled */
-#  define RTC_TCR_2KOHM		0x01	/* xxxxxx01 2KOhm */
-#  define RTC_TCR_4KOHM		0x02	/* xxxxxx10 4kOhm */
-#  define RTC_TCR_8KOHM		0x03	/* xxxxxx11 8kOhm */
-
-#elif defined(CONFIG_ETRAX_PCF8563)
-   /* I2C bus slave registers. */
-#  define RTC_I2C_READ		0xa3
-#  define RTC_I2C_WRITE		0xa2
-
-   /* Phillips PCF8563 registers. */
-#  define RTC_CONTROL1		0x00		/* Control/Status register 1. */
-#  define RTC_CONTROL2		0x01		/* Control/Status register 2. */
-#  define RTC_CLOCKOUT_FREQ	0x0d		/* CLKOUT frequency. */
-#  define RTC_TIMER_CONTROL	0x0e		/* Timer control. */
-#  define RTC_TIMER_CNTDOWN	0x0f		/* Timer countdown. */
-
-   /* BCD encoded clock registers. */
-#  define RTC_SECONDS		0x02
-#  define RTC_MINUTES		0x03
-#  define RTC_HOURS		0x04
-#  define RTC_DAY_OF_MONTH	0x05
-#  define RTC_WEEKDAY		0x06	/* Not coded in BCD! */
-#  define RTC_MONTH		0x07
-#  define RTC_YEAR		0x08
-#  define RTC_MINUTE_ALARM	0x09
-#  define RTC_HOUR_ALARM	0x0a
-#  define RTC_DAY_ALARM		0x0b
-#  define RTC_WEEKDAY_ALARM 0x0c
-
-#endif
-
-#ifdef CONFIG_ETRAX_DS1302
-extern unsigned char ds1302_readreg(int reg);
-extern void ds1302_writereg(int reg, unsigned char val);
-extern int ds1302_init(void);
-#  define CMOS_READ(x) ds1302_readreg(x)
-#  define CMOS_WRITE(val,reg) ds1302_writereg(reg,val)
-#  define RTC_INIT() ds1302_init()
-#elif defined(CONFIG_ETRAX_PCF8563)
-extern unsigned char pcf8563_readreg(int reg);
-extern void pcf8563_writereg(int reg, unsigned char val);
-extern int pcf8563_init(void);
-#  define CMOS_READ(x) pcf8563_readreg(x)
-#  define CMOS_WRITE(val,reg) pcf8563_writereg(reg,val)
-#  define RTC_INIT() pcf8563_init()
-#else
-  /* No RTC configured so we shouldn't try to access any. */
-#  define CMOS_READ(x) 42
-#  define CMOS_WRITE(x,y)
-#  define RTC_INIT() (-1)
-#endif
-
-/*
- * The struct used to pass data via the following ioctl. Similar to the
- * struct tm in <time.h>, but it needs to be here so that the kernel
- * source is self contained, allowing cross-compiles, etc. etc.
- */
-struct rtc_time {
-	int tm_sec;
-	int tm_min;
-	int tm_hour;
-	int tm_mday;
-	int tm_mon;
-	int tm_year;
-	int tm_wday;
-	int tm_yday;
-	int tm_isdst;
-};
-
-/* ioctl() calls that are permitted to the /dev/rtc interface. */
-#define RTC_MAGIC 'p'
-/* Read RTC time. */
-#define RTC_RD_TIME		_IOR(RTC_MAGIC, 0x09, struct rtc_time)
-/* Set RTC time. */
-#define RTC_SET_TIME		_IOW(RTC_MAGIC, 0x0a, struct rtc_time)
-#define RTC_SET_CHARGE		_IOW(RTC_MAGIC, 0x0b, int)
-/* Voltage low detector */
-#define RTC_VL_READ		_IOR(RTC_MAGIC, 0x13, int)
-/* Clear voltage low information */
-#define RTC_VL_CLR		_IO(RTC_MAGIC, 0x14)
-#define RTC_MAX_IOCTL 0x14
-
-#endif /* __RTC_H__ */
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index 4e73092..277ffc4 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -21,7 +21,6 @@
  *
  */
 
-#include <asm/rtc.h>
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/param.h>
@@ -32,7 +31,8 @@
 #include <linux/profile.h>
 #include <linux/sched.h>	/* just for sched_clock() - funny that */
 
-int have_rtc;  /* used to remember if we have an RTC or not */;
+
+#define D(x)
 
 #define TICK_SIZE tick
 
@@ -50,78 +50,16 @@ u32 arch_gettimeoffset(void)
 }
 #endif
 
-/*
- * BUG: This routine does not handle hour overflow properly; it just
- *      sets the minutes. Usually you'll only notice that after reboot!
- */
-
 int set_rtc_mmss(unsigned long nowtime)
 {
-	int retval = 0;
-	int real_seconds, real_minutes, cmos_minutes;
-
-	printk(KERN_DEBUG "set_rtc_mmss(%lu)\n", nowtime);
-
-	if(!have_rtc)
-		return 0;
-
-	cmos_minutes = CMOS_READ(RTC_MINUTES);
-	cmos_minutes = bcd2bin(cmos_minutes);
-
-	/*
-	 * since we're only adjusting minutes and seconds,
-	 * don't interfere with hour overflow. This avoids
-	 * messing with unknown time zones but requires your
-	 * RTC not to be off by more than 15 minutes
-	 */
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	if (((abs(real_minutes - cmos_minutes) + 15)/30) & 1)
-		real_minutes += 30;		/* correct for half hour time zone */
-	real_minutes %= 60;
-
-	if (abs(real_minutes - cmos_minutes) < 30) {
-		real_seconds = bin2bcd(real_seconds);
-		real_minutes = bin2bcd(real_minutes);
-		CMOS_WRITE(real_seconds,RTC_SECONDS);
-		CMOS_WRITE(real_minutes,RTC_MINUTES);
-	} else {
-		printk_once(KERN_NOTICE
-		       "set_rtc_mmss: can't update from %d to %d\n",
-		       cmos_minutes, real_minutes);
-		retval = -1;
-	}
-
-	return retval;
+	D(printk(KERN_DEBUG "set_rtc_mmss(%lu)\n", nowtime));
+	return 0;
 }
 
 /* grab the time from the RTC chip */
-
-unsigned long
-get_cmos_time(void)
+unsigned long get_cmos_time(void)
 {
-	unsigned int year, mon, day, hour, min, sec;
-	if(!have_rtc)
-		return 0;
-
-	sec = CMOS_READ(RTC_SECONDS);
-	min = CMOS_READ(RTC_MINUTES);
-	hour = CMOS_READ(RTC_HOURS);
-	day = CMOS_READ(RTC_DAY_OF_MONTH);
-	mon = CMOS_READ(RTC_MONTH);
-	year = CMOS_READ(RTC_YEAR);
-
-	sec = bcd2bin(sec);
-	min = bcd2bin(min);
-	hour = bcd2bin(hour);
-	day = bcd2bin(day);
-	mon = bcd2bin(mon);
-	year = bcd2bin(year);
-
-	if ((year += 1900) < 1970)
-		year += 100;
-
-	return mktime(year, mon, day, hour, min, sec);
+	return 0;
 }
 
 
@@ -132,7 +70,7 @@ int update_persistent_clock(struct timespec now)
 
 void read_persistent_clock(struct timespec *ts)
 {
-	ts->tv_sec = get_cmos_time();
+	ts->tv_sec = 0;
 	ts->tv_nsec = 0;
 }
 
-- 
1.7.8




/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
