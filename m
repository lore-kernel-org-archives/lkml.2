Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1DGNWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:22:24 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:41656 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647Ab1DGNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:22:21 -0400
Message-ID: <4D9DB8F6.4080208@gentoo.org>
Date: Thu, 07 Apr 2011 09:15:34 -0400
From: Joshua Kinard <kumba@gentoo.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux MIPS List <linux-mips@linux-mips.org>
Subject: [PATCH 1/2]: rtc: rtc-ds1685: Add driver to support Dallas/Maxim
 DS1685/DS1687 & related chips
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


This patch adds the core driver in drivers/rtc, the header file in
include/linux/rtc, and modifies the appropriate Kconfig & Makefiles.

I want to give a shoutout to the people at StackOverflow that assisted in the
register bit lookup table function.  That helped reduce the overall code for the
SysFS debug bits significantly.  Thanks!

Signed-off-by: Joshua Kinard <kumba@gentoo.org>
- ---

 drivers/rtc/Kconfig        |   90 +
 drivers/rtc/Makefile       |    1
 drivers/rtc/rtc-ds1685.c   | 2178 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rtc/ds1685.h |  334 ++++++
 4 files changed, 2603 insertions(+)

diff -Naurp linux-2.6.orig/drivers/rtc/Kconfig linux-2.6.rtc/drivers/rtc/Kconfig
- --- linux-2.6.orig/drivers/rtc/Kconfig	2011-04-04 03:08:22.182076000 -0400
+++ linux-2.6.rtc/drivers/rtc/Kconfig	2011-04-07 07:22:55.583871001 -0400
@@ -511,6 +511,96 @@ config RTC_DRV_DS1553
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1553.

+config RTC_DRV_DS1685_FAMILY
+	tristate "Dallas/Maxim DS1685 Family"
+	help
+	  If you say yes here you get support for the Dallas/Maxim DS1685
+	  family of real time chips.  This family includes the DS1685/DS1687,
+	  DS1689/DS1693, DS17285/DS17287, DS17485/DS17487, and
+	  DS17885/DS17887 chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-ds1685.
+
+choice
+	prompt "Subtype"
+	depends on RTC_DRV_DS1685_FAMILY
+	default RTC_DRV_DS1685
+
+config RTC_DRV_DS1685
+	bool "DS1685/DS1687"
+	help
+	  This enables support for the Dallas/Maxim DS1685/DS1687 real time
+	  clock chip.
+
+	  This chip is commonly found in SGI O2 (IP32) and SGI Octane (IP30)
+	  systems, as well as EPPC-405-UC modules by electronic system design
+	  GmbH.
+
+config RTC_DRV_DS1689
+	bool "DS1689/DS1693"
+	help
+	  This enables support for the Dallas/Maxim DS1689/DS1693 real time
+	  clock chip.
+
+	  This is an older RTC chip, supplanted by the DS1685/DS1687 above,
+	  which supports a few minor features such as Vcc, Vbat, and Power
+	  Cycle counters, plus a customer-specific, 8-byte ROM/Serial number.
+
+	  It also works for the even older DS1688/DS1691 RTC chips, which are
+	  virtually the same and carry the same model number.  Both chips
+	  have 114 bytes of user NVRAM.
+
+config RTC_DRV_DS17285
+	bool "DS17285/DS17287"
+	help
+	  This enables support for the Dallas/Maxim DS17285/DS17287 real time
+	  clock chip.
+
+	  This chip features 2kb of extended NV-SRAM.  It may possibly be
+	  found in some SGI O2 systems (rare).
+
+config RTC_DRV_DS17485
+	bool "DS17485/DS17487"
+	help
+	  This enables support for the Dallas/Maxim DS17485/DS17487 real time
+	  clock chip.
+
+	  This chip features 4kb of extended NV-SRAM.
+
+config RTC_DRV_DS17885
+	bool "DS17885/DS17887"
+	help
+	  This enables support for the Dallas/Maxim DS17885/DS17887 real time
+	  clock chip.
+
+	  This chip features 8kb of extended NV-SRAM.
+
+endchoice
+
+config RTC_DS1685_PROC_REGS
+	bool "Display register values in /proc"
+	depends on RTC_DRV_DS1685_FAMILY && PROC_FS
+	help
+	  Enable this to display a readout of all of the RTC registers in
+	  /proc/drivers/rtc.  Keep in mind that this can potentially lead
+	  to lost interrupts, as reading Control Register C will clear
+	  all pending IRQ flags.
+
+	  Unless you are debugging this driver, choose N.
+
+config RTC_DS1685_SYSFS_REGS
+	bool "SysFS access to RTC register bits"
+	depends on RTC_DRV_DS1685_FAMILY && SYSFS
+	help
+	  Enable this to provide access to the RTC control register bits
+	  in /sys.  Some of the bits are read-write, others are read-only.
+
+	  Keep in mind that reading Control C's bits automatically clears
+	  all pending IRQ flags - this can cause lost interrupts.
+
+	  If you know that you need access to these bits, choose Y, Else N.
+
 config RTC_DRV_DS1742
 	tristate "Maxim/Dallas DS1742/1743"
 	help
diff -Naurp linux-2.6.orig/drivers/rtc/Makefile linux-2.6.rtc/drivers/rtc/Makefile
- --- linux-2.6.orig/drivers/rtc/Makefile	2011-04-04 03:08:22.182076000 -0400
+++ linux-2.6.rtc/drivers/rtc/Makefile	2011-04-07 07:22:55.583871001 -0400
@@ -39,6 +39,7 @@ obj-$(CONFIG_RTC_DRV_DS1390)	+= rtc-ds13
 obj-$(CONFIG_RTC_DRV_DS1511)	+= rtc-ds1511.o
 obj-$(CONFIG_RTC_DRV_DS1553)	+= rtc-ds1553.o
 obj-$(CONFIG_RTC_DRV_DS1672)	+= rtc-ds1672.o
+obj-$(CONFIG_RTC_DRV_DS1685_FAMILY)	+= rtc-ds1685.o
 obj-$(CONFIG_RTC_DRV_DS1742)	+= rtc-ds1742.o
 obj-$(CONFIG_RTC_DRV_DS3232)	+= rtc-ds3232.o
 obj-$(CONFIG_RTC_DRV_DS3234)	+= rtc-ds3234.o
diff -Naurp linux-2.6.orig/drivers/rtc/rtc-ds1685.c
linux-2.6.rtc/drivers/rtc/rtc-ds1685.c
- --- linux-2.6.orig/drivers/rtc/rtc-ds1685.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.rtc/drivers/rtc/rtc-ds1685.c	2011-04-07 07:22:55.593871001 -0400
@@ -0,0 +1,2178 @@
+/*
+ * An rtc driver for the Dallas/Maxim DS1685/DS1687 and related real-time
+ * chips.
+ *
+ * Copyright (C) 2011 Joshua Kinard <kumba@gentoo.org>.
+ * Copyright (C) 2009 Matthias Fuchs <matthias.fuchs@esd-electronics.com>.
+ *
+ * References:
+ *    DS1685/DS1687 3V/5V Real-Time Clocks, 19-5215, Rev 4/10.
+ *    DS17x85/DS17x87 3V/5V Real-Time Clocks, 19-5222, Rev 4/10.
+ *    DS1689/DS1693 3V/5V Serialized Real-Time Clocks, Rev 112105.
+ *    Application Note 90, Using the Multiplex Bus RTC Extended Features.
+ *
+ * Todo:
+ *    - Implement pio access.  mmio only for now.
+ *    - Platform data function for custom time checks (some archs are weird).
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bcd.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/workqueue.h>
+
+#include <linux/rtc/ds1685.h>
+
+#ifdef CONFIG_PROC_FS
+#include <linux/proc_fs.h>
+#endif
+
+#define DRV_VERSION	"0.42"
+
+
+/* ----------------------------------------------------------------------- */
+/* Inlined functions */
+
+/**
+ * ds1685_read - read a value from an rtc register.
+ * @rtc: pointer to the ds1685 rtc structure.
+ * @reg: the register address to read.
+ */
+static inline u8
+ds1685_read(struct ds1685_priv *rtc, int reg)
+{
+	return readb((volatile u8 __iomem *)rtc->regs +
+	             (reg * rtc->regstep));
+}
+
+
+/**
+ * ds1685_write - write a value to an rtc register.
+ * @rtc: pointer to the ds1685 rtc structure.
+ * @reg: the register address to write.
+ * @value: value to write to the register.
+ */
+static inline void
+ds1685_write(struct ds1685_priv *rtc, int reg, u8 value)
+{
+	writeb(value, (volatile u8 __iomem *)rtc->regs +
+	              (reg * rtc->regstep));
+}
+
+
+/**
+ * ds1685_rtc_switch_to_bank0 - switch the rtc to bank 0.
+ * @rtc: pointer to the ds1685 rtc structure.
+ */
+static inline void
+ds1685_rtc_switch_to_bank0(struct ds1685_priv *rtc)
+{
+	ds1685_write(rtc, RTC_CTRL_A,
+	             (ds1685_read(rtc, RTC_CTRL_A) & ~(RTC_CTRL_A_DV0)));
+}
+
+
+/**
+ * ds1685_rtc_switch_to_bank1 - switch the rtc to bank 1.
+ * @rtc: pointer to the ds1685 rtc structure.
+ */
+static inline void
+ds1685_rtc_switch_to_bank1(struct ds1685_priv *rtc)
+{
+	ds1685_write(rtc, RTC_CTRL_A,
+	             (ds1685_read(rtc, RTC_CTRL_A) | RTC_CTRL_A_DV0));
+}
+
+
+/**
+ * ds1685_rtc_begin_data_access - prepare the rtc for data access.
+ * @rtc: pointer to the ds1685 rtc structure.
+ *
+ * This takes several steps to prepare the rtc for access to get/set time
+ * and alarm values from the rtc registers:
+ *  - Sets the SET bit in Control Register B.
+ *  - Reads Control Register A and checks the UIP bit.
+ *  - If UIP is active, a short delay is added before Control Register A
+ *    is read again in a loop until UIP is inactive.
+ *  - Switches the rtc to bank 1.  This allows access to all relevant
+ *    data for normal rtc operation, as bank 0 contains only the nvram.
+ */
+static inline void
+ds1685_rtc_begin_data_access(struct ds1685_priv *rtc)
+{
+	unsigned long uip_watchdog = jiffies;
+
+	/* Set the SET bit in Ctrl B */
+	ds1685_write(rtc, RTC_CTRL_B,
+	             (ds1685_read(rtc, RTC_CTRL_B) | RTC_CTRL_B_SET));
+
+	/* Read Ctrl A and check the UIP bit to avoid a lockout. */
+	while ((ds1685_read(rtc, RTC_CTRL_A) & RTC_CTRL_A_UIP) &&
+	       (time_before(jiffies, uip_watchdog + (2 * HZ / 100))))
+		cpu_relax();
+
+	/* Switch to Bank 1 */
+	ds1685_rtc_switch_to_bank1(rtc);
+}
+
+
+/**
+ * ds1685_rtc_end_data_access - end data access on the rtc.
+ * @rtc: pointer to the ds1685 rtc structure.
+ *
+ * This ends what was started by ds1685_rtc_begin_data_access:
+ *  - Switches the rtc back to bank 0.
+ *  - Clears the SET bit in Control Register B.
+ */
+static inline void
+ds1685_rtc_end_data_access(struct ds1685_priv *rtc)
+{
+	/* Switch back to Bank 0 */
+	ds1685_rtc_switch_to_bank1(rtc);
+
+	/* Clear the SET bit in Ctrl B */
+	ds1685_write(rtc, RTC_CTRL_B,
+	             (ds1685_read(rtc, RTC_CTRL_B) & ~(RTC_CTRL_B_SET)));
+}
+
+
+/**
+ * ds1685_rtc_begin_ctrl_access - prepare the rtc for ctrl access.
+ * @rtc: pointer to the ds1685 rtc structure.
+ * @flags: irq flags variable for spin_lock_irqsave.
+ *
+ * This takes several steps to prepare the rtc for access to read just the
+ * control registers:
+ *  - Sets a spinlock on the rtc IRQ.
+ *  - Switches the rtc to bank 1.  This allows access to the two extended
+ *    control registers.
+ *
+ * Only use this where you are certain another lock will not be held.
+ */
+static inline void
+ds1685_rtc_begin_ctrl_access(struct ds1685_priv *rtc, unsigned long flags)
+{
+	spin_lock_irqsave(&rtc->lock, flags);
+	ds1685_rtc_switch_to_bank1(rtc);
+}
+
+
+/**
+ * ds1685_rtc_end_ctrl_access - end ctrl access on the rtc.
+ * @rtc: pointer to the ds1685 rtc structure.
+ * @flags: irq flags variable for spin_unlock_irqrestore.
+ *
+ * This ends what was started by ds1685_rtc_begin_ctrl_access:
+ *  - Switches the rtc back to bank 0.
+ *  - Unsets the spinlock on the rtc IRQ.
+ */
+static inline void
+ds1685_rtc_end_ctrl_access(struct ds1685_priv *rtc, unsigned long flags)
+{
+	ds1685_rtc_switch_to_bank0(rtc);
+	spin_unlock_irqrestore(&rtc->lock, flags);
+}
+
+
+/**
+ * ds1685_rtc_get_ssn - retrieve the silicon serial number.
+ * @rtc: pointer to the ds1685 rtc structure.
+ * @ssn: u8 array to hold the bits of the silicon serial number.
+ *
+ * This number starts at 0x40, and is 8-bytes long, ending at 0x47. The
+ * first byte is the model number, the next six bytes are the serial number
+ * digits, and the final byte is a CRC check byte.  Together, they form the
+ * silicon serial number.
+ *
+ * These values are stored in bank1, so call ds1685_rtc_switch_to_bank1
+ * before calling this function, else you will read data out of the bank0
+ * NVRAM!  Remember to call ds1685_rtc_switch_to_bank0 when you're done to
+ * switch back to bank0.
+ */
+static inline void
+ds1685_rtc_get_ssn(struct ds1685_priv *rtc, u8 *ssn)
+{
+	ssn[0] = ds1685_read(rtc, RTC_BANK1_SSN_MODEL);
+	ssn[1] = ds1685_read(rtc, RTC_BANK1_SSN_BYTE_1);
+	ssn[2] = ds1685_read(rtc, RTC_BANK1_SSN_BYTE_2);
+	ssn[3] = ds1685_read(rtc, RTC_BANK1_SSN_BYTE_3);
+	ssn[4] = ds1685_read(rtc, RTC_BANK1_SSN_BYTE_4);
+	ssn[5] = ds1685_read(rtc, RTC_BANK1_SSN_BYTE_5);
+	ssn[6] = ds1685_read(rtc, RTC_BANK1_SSN_BYTE_6);
+	ssn[7] = ds1685_read(rtc, RTC_BANK1_SSN_CRC);
+}
+/* ----------------------------------------------------------------------- */
+
+
+/* ----------------------------------------------------------------------- */
+/* Read/Set Time & Alarm functions */
+
+/**
+ * ds1685_rtc_read_time - reads the time registers.
+ * @dev: pointer to device structure.
+ * @tm: pointer to rtc_time structure.
+ */
+static int
+ds1685_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 ctrlb, century;
+	u8 seconds, minutes, hours, wday, mday, month, years;
+
+	/* Fetch the time info from the RTC registers. */
+	ds1685_rtc_begin_data_access(rtc);
+	seconds	= ds1685_read(rtc, RTC_SECONDS) & RTC_SECONDS_MASK;
+	minutes	= ds1685_read(rtc, RTC_MINUTES) & RTC_MINUTES_MASK;
+	hours	= ds1685_read(rtc, RTC_HOURS) & RTC_HOURS_24_MASK;
+	wday	= ds1685_read(rtc, RTC_WDAY) & RTC_WDAY_MASK;
+	mday	= ds1685_read(rtc, RTC_MDAY) & RTC_MDAY_MASK;
+	month	= ds1685_read(rtc, RTC_MONTH) & RTC_MONTH_MASK;
+	years	= ds1685_read(rtc, RTC_YEAR) & RTC_YEAR_MASK;
+	century	= ds1685_read(rtc, RTC_CENTURY) & RTC_CENTURY_MASK;
+	ctrlb	= ds1685_read(rtc, RTC_CTRL_B);
+	ds1685_rtc_end_data_access(rtc);
+
+	/* Convert to Binary, perform fixups, and store to rtc_time. */
+	tm->tm_sec	= bcd2bin(seconds);
+	tm->tm_min	= bcd2bin(minutes);
+	tm->tm_hour	= bcd2bin(hours);
+	tm->tm_wday	= (bcd2bin(wday) - 1);
+	tm->tm_mday	= bcd2bin(mday);
+	tm->tm_mon	= (bcd2bin(month) - 1);
+	tm->tm_year	= ((bcd2bin(years) + (bcd2bin(century) * 100)) - 1900);
+	tm->tm_yday	= rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
+	tm->tm_isdst	= 0; /* RTC has hardcoded timezone, so don't use. */
+
+	return rtc_valid_tm(tm);
+}
+
+
+/**
+ * ds1685_rtc_set_time - sets the time registers.
+ * @dev: pointer to device structure.
+ * @tm: pointer to rtc_time structure.
+ */
+static int
+ds1685_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 seconds, minutes, hours, wday, mday, month, years, century;
+
+	/* Fetch the time info from rtc_time. */
+	seconds	= bin2bcd(tm->tm_sec);
+	minutes	= bin2bcd(tm->tm_min);
+	hours	= bin2bcd(tm->tm_hour);
+	wday	= bin2bcd(tm->tm_wday + 1);
+	mday	= bin2bcd(tm->tm_mday);
+	month	= bin2bcd(tm->tm_mon + 1);
+	years	= bin2bcd(tm->tm_year % 100);
+	century	= bin2bcd((tm->tm_year + 1900) / 100);
+
+	/*
+	 * Perform Sanity Checks:
+	 *   - Months: !> 12, Month Day != 0.
+	 *   - Month Day !> Max days in current month.
+	 *   - Hours !>= 24, Mins !>= 60, Secs !>= 60, & Weekday !> 7.
+	 */
+	if ((month > 12) || (mday == 0))
+		return -EDOM;
+
+	if (tm->tm_mday > rtc_month_days(tm->tm_mon, tm->tm_year))
+		return -EDOM;
+
+	if ((tm->tm_hour >= 24) || (tm->tm_min >= 60) ||
+	    (tm->tm_sec >= 60)  || (wday > 7))
+		return -EDOM;
+
+	/*
+	 * Force datamode to BCD (DM=0) and and store the time values in
+	 * the RTC registers.
+	 */
+	ds1685_rtc_begin_data_access(rtc);
+	ds1685_write(rtc, RTC_CTRL_B,
+	             (ds1685_read(rtc, RTC_CTRL_B) & ~(RTC_CTRL_B_DM)));
+	ds1685_write(rtc, RTC_SECONDS, seconds & RTC_SECONDS_MASK);
+	ds1685_write(rtc, RTC_MINUTES, minutes & RTC_MINUTES_MASK);
+	ds1685_write(rtc, RTC_HOURS, hours & RTC_HOURS_24_MASK);
+	ds1685_write(rtc, RTC_WDAY, wday & RTC_WDAY_MASK);
+	ds1685_write(rtc, RTC_MDAY, mday & RTC_MDAY_MASK);
+	ds1685_write(rtc, RTC_MONTH, month & RTC_MONTH_MASK);
+	ds1685_write(rtc, RTC_YEAR, years & RTC_YEAR_MASK);
+	ds1685_write(rtc, RTC_CENTURY, century & RTC_CENTURY_MASK);
+	ds1685_rtc_end_data_access(rtc);
+
+	return 0;
+}
+
+
+/**
+ * ds1685_rtc_read_alarm - reads the alarm registers.
+ * @dev: pointer to device structure.
+ * @alrm: pointer to rtc_wkalrm structure.
+ *
+ * There are three primary alarm registers: seconds, minutes, and hours.
+ * A fourth alarm register for the month date is also available in bank1 for
+ * kickstart/wakeup features.  The DS1685/DS1687 manual states that a
+ * "don't care" value ranging from 0xc0 to 0xff may be written into one or
+ * more of the three alarm bytes to act as a wildcard value.  The fourth
+ * byte doesn't support a "don't care" value.
+ */
+static int
+ds1685_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 seconds, minutes, hours, mday, ctrlb, ctrlc;
+
+	/* Fetch the alarm info from the RTC alarm registers. */
+	ds1685_rtc_begin_data_access(rtc);
+	seconds	= ds1685_read(rtc, RTC_SECONDS_ALARM) & RTC_SECONDS_MASK;
+	minutes	= ds1685_read(rtc, RTC_MINUTES_ALARM) & RTC_MINUTES_MASK;
+	hours	= ds1685_read(rtc, RTC_HOURS_ALARM) & RTC_HOURS_24_MASK;
+	mday	= ds1685_read(rtc, RTC_MDAY_ALARM) & RTC_MDAY_MASK;
+	ctrlb	= ds1685_read(rtc, RTC_CTRL_B);
+	ctrlc	= ds1685_read(rtc, RTC_CTRL_C);
+	ds1685_rtc_end_data_access(rtc);
+
+	/* Check month date. */
+	if (!(mday >= 1) && (mday <= 31))
+		return -EDOM;
+
+	/*
+	 * Check the three alarm bytes.
+	 *
+	 * The Linux RTC system doesn't support the "don't care" capability
+	 * of this RTC chip.  We check for it anyways in case support is
+	 * added in the future.
+	 */
+	if (unlikely((seconds >= 0xc0) && (seconds <= 0xff)))
+		alrm->time.tm_sec = -1;
+	else
+		alrm->time.tm_sec = bcd2bin(seconds);
+
+	if (unlikely((minutes >= 0xc0) && (minutes <= 0xff)))
+		alrm->time.tm_min = -1;
+	else
+		alrm->time.tm_min = bcd2bin(minutes);
+
+	if (unlikely((hours >= 0xc0) && (hours <= 0xff)))
+		alrm->time.tm_hour = -1;
+	else
+		alrm->time.tm_hour = bcd2bin(hours);
+
+	/* Write the data to rtc_wkalrm. */
+	alrm->time.tm_mday	= bcd2bin(mday);
+	alrm->time.tm_mon	= -1;
+	alrm->time.tm_year	= -1;
+	alrm->time.tm_wday	= -1;
+	alrm->time.tm_yday	= -1;
+	alrm->time.tm_isdst	= -1;
+	alrm->enabled		= !!(ctrlb & RTC_CTRL_B_AIE);
+	alrm->pending		= !!(ctrlc & RTC_CTRL_C_AF);
+
+	return 0;
+}
+
+
+/**
+ * ds1685_rtc_set_alarm - sets the alarm in registers.
+ * @dev: pointer to device structure.
+ * @alrm: pointer to rtc_wkalrm structure.
+ */
+static int
+ds1685_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 seconds, minutes, hours, mday, ctrlb;
+
+	/* Fetch the alarm info and convert to BCD. */
+	seconds	= bin2bcd(alrm->time.tm_sec);
+	minutes	= bin2bcd(alrm->time.tm_min);
+	hours	= bin2bcd(alrm->time.tm_hour);
+	mday	= bin2bcd(alrm->time.tm_mday);
+
+	/* Check the month date for validity. */
+	if (!(mday >= 1) && (mday <= 31))
+		return -EDOM;
+
+	/*
+	 * Check the three alarm bytes.
+	 *
+	 * The Linux RTC system doesn't support the "don't care" capability
+	 * of this RTC chip because rtc_valid_tm tries to validate every
+	 * field, and we only support four fields.  We put the support
+	 * here anyways for the future.
+	 */
+	if (unlikely((seconds >= 0xc0) && (seconds <= 0xff)))
+		seconds = 0xff;
+
+	if (unlikely((minutes >= 0xc0) && (minutes <= 0xff)))
+		minutes = 0xff;
+
+	if (unlikely((hours >= 0xc0) && (hours <= 0xff)))
+		hours = 0xff;
+
+	alrm->time.tm_mon	= -1;
+	alrm->time.tm_year	= -1;
+	alrm->time.tm_wday	= -1;
+	alrm->time.tm_yday	= -1;
+	alrm->time.tm_isdst	= -1;
+
+	/* Disable the alarm interrupt first. */
+	ds1685_rtc_begin_data_access(rtc);
+	ctrlb = ds1685_read(rtc, RTC_CTRL_B);
+	ds1685_write(rtc, RTC_CTRL_B, (ctrlb & ~(RTC_CTRL_B_AIE)));
+
+	/* Read ctrlc to clear RTC_CTRL_C_AF. */
+	ds1685_read(rtc, RTC_CTRL_C);
+
+	/*
+	 * Force datamode to BCD (DM=0) and store the alarm values in the
+	 * RTC registers.
+	 */
+	ds1685_rtc_begin_data_access(rtc);
+	ds1685_write(rtc, RTC_CTRL_B,
+	             (ds1685_read(rtc, RTC_CTRL_B) & ~(RTC_CTRL_B_DM)));
+	ds1685_write(rtc, RTC_SECONDS_ALARM, seconds & RTC_SECONDS_MASK);
+	ds1685_write(rtc, RTC_MINUTES_ALARM, minutes & RTC_MINUTES_MASK);
+	ds1685_write(rtc, RTC_HOURS_ALARM, hours & RTC_HOURS_24_MASK);
+	ds1685_write(rtc, RTC_MDAY_ALARM, mday & RTC_MDAY_MASK);
+
+	/* Re-enable the alarm if needed. */
+	if (alrm->enabled) {
+		ctrlb |= RTC_CTRL_B_AIE;
+		ds1685_write(rtc, RTC_CTRL_B, ctrlb);
+	}
+
+	/* Done! */
+	ds1685_rtc_end_data_access(rtc);
+
+	return 0;
+}
+/* ----------------------------------------------------------------------- */
+
+
+/* ----------------------------------------------------------------------- */
+
+/* Periodic Interrupt Rate & Square-Wave Output functionality. */
+
+#if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_SYSFS)
+/**
+ * ds1685_rtc_set_freq - sets the periodic irq rate/square-wave freq.
+ * @dev: pointer to device structure.
+ * @freq: integer value of the frequency to set.
+ */
+static int
+ds1685_rtc_set_freq(struct device *dev, int freq)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 rate, ctrla, ctrlb, ctrl4b;
+	unsigned char e32k = 0;
+	unsigned long flags = 0;
+
+	/* 8192Hz is the highest user-selectable frequency, unless 32768Hz. */
+	if (((freq > RTC_MAX_USER_FREQ) && (freq != RTC_SQW_32768HZ)) ||
+	    (freq < 0))
+		return -ERANGE;
+
+	/* Set the rate/frequency. */
+	switch (freq) {
+	case 0:    rate = RTC_SQW_0HZ;		break;
+	case 2:    rate = RTC_SQW_2HZ;		break;
+	case 4:    rate = RTC_SQW_4HZ;		break;
+	case 8:    rate = RTC_SQW_8HZ;		break;
+	case 16:   rate = RTC_SQW_16HZ;		break;
+	case 32:   rate = RTC_SQW_32HZ;		break;
+	case 64:   rate = RTC_SQW_64HZ;		break;
+	case 128:  rate = RTC_SQW_128HZ;	break;
+	case 256:  rate = RTC_SQW_256HZ;	break;
+	case 512:  rate = RTC_SQW_512HZ;	break;
+	case 1024: rate = RTC_SQW_1024HZ;	break;
+	case 2048: rate = RTC_SQW_2048HZ;	break;
+	case 4096: rate = RTC_SQW_4096HZ;	break;
+	case 8192: rate = RTC_SQW_8192HZ;	break;
+	case 32768:
+		rate = 0;
+		e32k = 1;
+		break;
+	default:
+		return -EDOM;
+		break;
+	}
+
+	/* Read the current rate/frequency from the RTC. */
+	ds1685_rtc_begin_ctrl_access(rtc, flags);
+	ctrla = ds1685_read(rtc, RTC_CTRL_A);
+	ctrl4b = ds1685_read(rtc, RTC_EXT_CTRL_4B);
+	ds1685_rtc_end_ctrl_access(rtc, flags);
+
+	/* If 32768Hz, clear RS3-RS0 in Ctrl A and set E32K in Ctrl 4B. */
+	if (e32k) {
+		ctrla &= ~(RTC_CTRL_A_RS_MASK);
+		ctrl4b |= RTC_CTRL_4B_E32K;
+	} else {
+		/* Else, clear E32K in Ctrl 4B and set RS3-RS0 in Ctrl A. */
+		ctrl4b &= ~(RTC_CTRL_4B_E32K);
+		ctrla &= ~(RTC_CTRL_A_RS_MASK);
+		ctrla |= rate;
+	}
+
+	/* Write the rate/frequency to the RTC. */
+	ds1685_rtc_begin_ctrl_access(rtc, flags);
+	ctrlb = ds1685_read(rtc, RTC_CTRL_B);
+	ds1685_write(rtc, RTC_CTRL_B, (ctrlb & ~(RTC_CTRL_B_SQWE)));
+	ds1685_write(rtc, RTC_CTRL_A, ctrla);
+	ds1685_write(rtc, RTC_EXT_CTRL_4B, ctrl4b);
+	ds1685_write(rtc, RTC_CTRL_B, (ctrlb | RTC_CTRL_B_SQWE));
+	ds1685_rtc_end_ctrl_access(rtc, flags);
+
+	return 0;
+}
+#else
+#define ds1685_rtc_set_freq		NULL
+#endif /* CONFIG_RTC_INTF_DEV || CONFIG_SYSFS */
+/* ----------------------------------------------------------------------- */
+
+
+/* ----------------------------------------------------------------------- */
+/* /dev/rtcX Interface functions */
+
+#ifdef CONFIG_RTC_INTF_DEV
+/**
+ * ds1685_rtc_irq_ctrl - enables/disables an interrupt.
+ * @rtc: pointer to the ds1685 rtc structure.
+ * @reg: the register address to use.
+ * @irq_bit: the register bit for the irq to modify.
+ * @enabled: boolean value indicating the state to set the irq bit to.
+ * @flags: irq flags variable for spin_lock_irqsave/spin_unlock_irqrestore.
+ *
+ * PIE/AIE/UIE are read/written in Ctrl B, and RIE/WIE/KSE in Ctrl 4B.
+ * RTC Core doesn't know about RIE/WIE/KSE, so they are not processed here.
+ */
+static inline void
+ds1685_rtc_irq_ctrl(struct ds1685_priv *rtc, const int reg, const u8 irq_bit,
+                    const u8 enabled, unsigned long flags)
+{
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	/* Flip the requisite interrupt-enable bit. */
+	if (enabled)
+		ds1685_write(rtc, reg, (ds1685_read(rtc, reg) | irq_bit));
+	else
+		ds1685_write(rtc, reg, (ds1685_read(rtc, reg) & ~(irq_bit)));
+
+	/* Read Control C to clear all the flag bits. */
+	ds1685_read(rtc, RTC_CTRL_C);
+	spin_unlock_irqrestore(&rtc->lock, flags);
+}
+
+
+/**
+ * ds1685_rtc_periodic_irq_enable - replaces ioctl() RTC_PIE on/off.
+ * @dev: pointer to device structure.
+ * @enabled: flag indicating whether to enable or disable.
+ *
+ * XXX: 2nd arg should be 'unsigned int', but needs fix in RTC core.
+ */
+static int
+ds1685_rtc_periodic_irq_enable(struct device *dev, int enabled)
+{
+	struct ds1685_priv *rtc = dev_get_drvdata(dev);
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+	ds1685_rtc_switch_to_bank1(rtc);
+
+	/* Periodic IRQs are not possible if E32K = 1 in Control 4B. */
+	if (ds1685_read(rtc, RTC_EXT_CTRL_4B) & RTC_CTRL_4B_E32K)
+		goto no_irq;
+
+	/* Periodic IRQs are not possible if RS3-RS0 = 0 in Control A. */
+	if (!(ds1685_read(rtc, RTC_CTRL_A) & RTC_CTRL_A_RS_MASK))
+		goto no_irq;
+
+	/* Done with our sanity checks. */
+	ds1685_rtc_switch_to_bank0(rtc);
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	/* Enable/disable the Periodic IRQ-Enable flag. */
+	ds1685_rtc_irq_ctrl(rtc, RTC_CTRL_B, RTC_CTRL_B_PIE, enabled, flags);
+
+	return 0;
+
+ no_irq:
+	ds1685_rtc_switch_to_bank0(rtc);
+	spin_unlock_irqrestore(&rtc->lock, flags);
+	return -EINVAL;
+}
+
+
+/**
+ * ds1685_rtc_alarm_irq_enable - replaces ioctl() RTC_AIE on/off.
+ * @dev: pointer to device structure.
+ * @enabled: flag indicating whether to enable or disable.
+ */
+static int
+ds1685_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct ds1685_priv *rtc = dev_get_drvdata(dev);
+	unsigned long flags = 0;
+
+	/* Enable/disable the Alarm IRQ-Enable flag. */
+	ds1685_rtc_irq_ctrl(rtc, RTC_CTRL_B, RTC_CTRL_B_AIE, enabled, flags);
+
+	return 0;
+}
+
+
+/**
+ * ds1685_rtc_update_irq_enable - replaces ioctl() RTC_UIE on/off.
+ * @dev: pointer to device structure.
+ * @enabled: flag indicating whether to enable or disable.
+ */
+static int
+ds1685_rtc_update_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct ds1685_priv *rtc = dev_get_drvdata(dev);
+	unsigned long flags = 0;
+
+	/* Enable/disable the Update IRQ-Enable flag. */
+	ds1685_rtc_irq_ctrl(rtc, RTC_CTRL_B, RTC_CTRL_B_UIE, enabled, flags);
+
+	return 0;
+}
+
+
+#else
+#define ds1685_rtc_periodic_irq_enable	NULL
+#define ds1685_rtc_alarm_irq_enable	NULL
+#define ds1685_rtc_update_irq_enable	NULL
+#endif /* CONFIG_RTC_INTF_DEV */
+/* ----------------------------------------------------------------------- */
+
+
+/* ----------------------------------------------------------------------- */
+/* IRQ handler & workqueue. */
+
+
+/**
+ * ds1685_rtc_irq_handler - IRQ handler.
+ * @irq: IRQ number.
+ * @dev_id: platform device pointer.
+ */
+static irqreturn_t
+ds1685_rtc_irq_handler(int irq, void *dev_id)
+{
+	struct platform_device *pdev = dev_id;
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 ctrlb, ctrlc;
+	unsigned long events = 0;
+	u8 num_irqs = 0;
+
+	/* Abort early if the device isn't ready yet (i.e., DEBUG_SHIRQ). */
+	if (unlikely(!rtc))
+		return IRQ_HANDLED;
+
+	/* Ctrlb holds the interrupt-enable bits and ctrlc the flag bits. */
+	spin_lock(&rtc->lock);
+	ctrlb = ds1685_read(rtc, RTC_CTRL_B);
+	ctrlc = ds1685_read(rtc, RTC_CTRL_C);
+
+	/* Is the IRQF bit set? */
+	if (likely(ctrlc & RTC_CTRL_C_IRQF)) {
+		/*
+		 * We need to determine if it was one of the standard
+		 * events: PF, AF, or UF.  If so, we handle them and
+		 * update the RTC core.
+		 */
+		if (likely(ctrlc & RTC_CTRL_B_PAU_MASK)) {
+			events = RTC_IRQF;
+
+			/* Check for a periodic interrupt. */
+			if ((ctrlb & RTC_CTRL_B_PIE) &&
+			    (ctrlc & RTC_CTRL_C_PF)) {
+					events |= RTC_PF;
+					num_irqs++;
+			}
+
+			/* Check for an alarm interrupt. */
+			if ((ctrlb & RTC_CTRL_B_AIE) &&
+			    (ctrlc & RTC_CTRL_C_AF)) {
+					events |= RTC_AF;
+					num_irqs++;
+			}
+
+			/* Check for an update interrupt. */
+			if ((ctrlb & RTC_CTRL_B_UIE) &&
+			    (ctrlc & RTC_CTRL_C_UF)) {
+					events |= RTC_UF;
+					num_irqs++;
+			}
+
+			rtc_update_irq(rtc->dev, num_irqs, events);
+		} else {
+			/*
+			 * We received one of the "extended" interrupts
+			 * which are not recognized by the RTC core.  These
+			 * need to be handled in task context as they can
+			 * call other functions and we don't want to be in
+			 * irq context for too long, so we schedule them
+			 * into a workqueue and inform the RTC core that
+			 * nothing happened.
+			 */
+			spin_unlock(&rtc->lock);
+			schedule_work(&rtc->work);
+			rtc_update_irq(rtc->dev, 0, 0);
+			return IRQ_HANDLED;
+		}
+	}
+	spin_unlock(&rtc->lock);
+
+	return events ? IRQ_HANDLED : IRQ_NONE;
+}
+
+
+/**
+ * ds1685_rtc_work_queue - work queue handler.
+ * @work: work_struct containing data to work on in task context.
+ */
+static void
+ds1685_rtc_work_queue(struct work_struct *work)
+{
+	struct ds1685_priv *rtc = container_of(work,
+	                                       struct ds1685_priv, work);
+	struct platform_device *pdev = to_platform_device(&rtc->dev->dev);
+	struct mutex *rtc_mutex = &rtc->dev->ops_lock;
+	u8 ctrl4a, ctrl4b;
+
+	mutex_lock(rtc_mutex);
+
+	ds1685_rtc_switch_to_bank1(rtc);
+	ctrl4a = ds1685_read(rtc, RTC_EXT_CTRL_4A);
+	ctrl4b = ds1685_read(rtc, RTC_EXT_CTRL_4B);
+
+	/*
+	 * Check for a kickstart interrupt. With Vcc applied, this
+	 * typically means that the power button was pressed, so we
+	 * begin the shutdown sequence.
+	 */
+	if ((ctrl4b & RTC_CTRL_4B_KSE) &&
+	    (ctrl4a & RTC_CTRL_4A_KF)) {
+		/* Briefly disable kickstarts to debounce button presses. */
+		ds1685_write(rtc, RTC_EXT_CTRL_4B,
+		             (ds1685_read(rtc, RTC_EXT_CTRL_4B) &
+		              ~(RTC_CTRL_4B_KSE)));
+
+		/* Clear the kickstart flag. */
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+		             (ctrl4a & ~(RTC_CTRL_4A_KF)));
+
+
+		/*
+		 * Sleep 500ms before re-enabling kickstarts.  This allows
+		 * adequate time to avoid reading signal jitter as additional
+		 * button presses.
+		 */
+		msleep(500);
+		ds1685_write(rtc, RTC_EXT_CTRL_4B,
+	        	     (ds1685_read(rtc, RTC_EXT_CTRL_4B) |
+		              RTC_CTRL_4B_KSE));
+
+		/* Call the platform pre-poweroff function. Else, shutdown. */
+		if (rtc->prepare_poweroff != NULL)
+			rtc->prepare_poweroff();
+		else
+			ds1685_rtc_poweroff(pdev);
+	}
+
+	/*
+	 * Check for a wake-up interrupt.  With Vcc applied, this is
+	 * essentially a second alarm interrupt, except it takes into
+	 * account the 'date' register in bank1 in addition to the
+	 * standard three alarm registers.
+	 */
+	if ((ctrl4b & RTC_CTRL_4B_WIE) &&
+	    (ctrl4a & RTC_CTRL_4A_WF)) {
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+                             (ctrl4a & ~(RTC_CTRL_4A_WF)));
+
+		/* Call the platform wake_alarm function if defined. */
+		if (rtc->wake_alarm != NULL)
+			rtc->wake_alarm();
+		else
+			dev_warn(&pdev->dev,
+			         "Wake Alarm IRQ just occurred!\n");
+	}
+
+	/*
+	 * Check for a ram-clear interrupt.  This happens if RIE=1 and RF=0
+	 * when RCE in 4B is set to a logic 1.  This clears all NVRAM bytes
+	 * in bank0 by setting each byte to a logic 1.  This has no effect
+	 * on any extended NV-SRAM that might be present, nor on the
+	 * time/calendar/alarm registers.  After a ram-clear is completed,
+	 * there is a minimum recovery time of ~150ms in which all
+	 * reads/writes are locked out.  NOTE: A ram-clear can still occur
+	 * if RCE=1 and RIE=0.  We cannot catch this scenario.
+	 */
+	if ((ctrl4b & RTC_CTRL_4B_RIE) &&
+	    (ctrl4a & RTC_CTRL_4A_RF)) {
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+                             (ctrl4a & ~(RTC_CTRL_4A_RF)));
+		msleep(150);
+
+		/* Call the platform post_ram_clear function if defined. */
+		if (rtc->post_ram_clear != NULL)
+			rtc->post_ram_clear();
+		else
+			dev_warn(&pdev->dev,
+			         "RAM-Clear IRQ just occurred!\n");
+	}
+	ds1685_rtc_switch_to_bank0(rtc);
+
+	mutex_unlock(rtc_mutex);
+}
+/* ----------------------------------------------------------------------- */
+
+
+/* ----------------------------------------------------------------------- */
+/* ProcFS interface */
+
+#ifdef CONFIG_PROC_FS
+#define NUM_REGS	6	/* Num of control registers. */
+#define NUM_BITS	8	/* Num bits per register. */
+#define NUM_SPACES	4	/* Num spaces between each bit. */
+
+/*
+ * Periodic Interrupt Rates.
+ */
+static const char *ds1685_rtc_pirq_rate[16] = {
+	"none", "3.90625ms", "7.8125ms", "0.122070ms", "0.244141ms",
+	"0.488281ms", "0.9765625ms", "1.953125ms", "3.90625ms", "7.8125ms",
+	"15.625ms", "31.25ms", "62.5ms", "125ms", "250ms", "500ms"
+};
+
+
+/*
+ * Square-Wave Output Frequencies.
+ */
+static const char *ds1685_rtc_sqw_freq[16] = {
+	"none", "256Hz", "128Hz", "8192Hz", "4096Hz", "2048Hz",
+	"1024Hz", "512Hz", "256Hz", "128Hz", "64Hz", "32Hz", "16Hz",
+	"8Hz", "4Hz", "2Hz"
+};
+
+
+#ifdef CONFIG_RTC_DS1685_PROC_REGS
+/**
+ * ds1685_rtc_print_regs - helper function to print register values.
+ * @hex: hex byte to convert into binary bits.
+ * @dest: destination char array.
+ *
+ * This is basically a hex->binary function, just with extra spacing between
+ * the digits.  It only works on 1-byte values (8 bits).
+ */
+static char*
+ds1685_rtc_print_regs(u8 hex, char *dest)
+{
+	u32 i, j;
+	char *tmp = dest;
+
+	for (i = 0; i < NUM_BITS; i++) {
+		*tmp++ = ((hex & 0x80) != 0 ? '1' : '0');
+		for (j = 0; j < NUM_SPACES; j++)
+			*tmp++ = ' ';
+		hex <<= 1;
+	}
+	*tmp++ = '\0';
+
+	return dest;
+}
+#endif
+
+
+/**
+ * ds1685_rtc_proc - procfs access function.
+ * @dev: pointer to device structure.
+ * @seq: pointer to seq_file structure.
+ */
+static int
+ds1685_rtc_proc(struct device *dev, struct seq_file *seq)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 ctrla, ctrlb, ctrlc, ctrld, ctrl4a, ctrl4b, ssn[8];
+	char *model = '\0';
+#ifdef CONFIG_RTC_DS1685_PROC_REGS
+	char bits[NUM_REGS][(NUM_BITS * NUM_SPACES) + NUM_BITS + 1];
+#endif
+
+	/* Read all the relevant data from the control registers. */
+	ds1685_rtc_switch_to_bank1(rtc);
+	ds1685_rtc_get_ssn(rtc, ssn);
+	ctrla = ds1685_read(rtc, RTC_CTRL_A);
+	ctrlb = ds1685_read(rtc, RTC_CTRL_B);
+	ctrlc = ds1685_read(rtc, RTC_CTRL_C);
+	ctrld = ds1685_read(rtc, RTC_CTRL_D);
+	ctrl4a = ds1685_read(rtc, RTC_EXT_CTRL_4A);
+	ctrl4b = ds1685_read(rtc, RTC_EXT_CTRL_4B);
+	ds1685_rtc_switch_to_bank0(rtc);
+
+	/* Determine the RTC model. */
+	switch (ssn[0]) {
+	case RTC_MODEL_DS1685:  model = "DS1685/DS1687\0";	break;
+	case RTC_MODEL_DS1689:  model = "DS1689/DS1693\0";	break;
+	case RTC_MODEL_DS17285: model = "DS17285/DS17287\0";	break;
+	case RTC_MODEL_DS17485: model = "DS17485/DS17487\0";	break;
+	case RTC_MODEL_DS17885: model = "DS17885/DS17887\0";	break;
+	default:                model = "Unknown\0";		break;
+	}
+
+	/* Print out the information. */
+	seq_printf(seq,
+	   "Model\t\t: %s\n"
+	   "Oscillator\t: %s\n"
+	   "12/24hr\t\t: %s\n"
+	   "DST\t\t: %s\n"
+	   "Data mode\t: %s\n"
+	   "Battery\t\t: %s\n"
+	   "Aux batt\t: %s\n"
+	   "Update IRQ\t: %s\n"
+	   "Periodic IRQ\t: %s\n"
+	   "Periodic Rate\t: %s\n"
+	   "SQW Freq\t: %s\n"
+#ifdef CONFIG_RTC_DS1685_PROC_REGS
+	   "Serial #\t: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n"
+	   "Register Status\t:\n"
+	   "   Ctrl A\t: "
+	   "UIP  DV2  DV1  DV0  RS3  RS2  RS1  RS0\n\t\t:  %s\n"
+	   "   Ctrl B\t: "
+	   "SET  PIE  AIE  UIE  SQWE  DM  2412 DSE\n\t\t:  %s\n"
+	   "   Ctrl C\t: "
+	   "IRQF  PF   AF   UF  ---  ---  ---  ---\n\t\t:  %s\n"
+	   "   Ctrl D\t: "
+	   "VRT  ---  ---  ---  ---  ---  ---  ---\n\t\t:  %s\n"
+	   "   Ctrl 4A\t: "
+	   "VRT2 INCR ---  ---  PAB   RF   WF   KF\n\t\t:  %s\n"
+	   "   Ctrl 4B\t: "
+	   "ABE  E32k  CS  RCE  PRS  RIE  WIE  KSE\n\t\t:  %s\n",
+#else
+	   "Serial #\t: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+#endif
+	   model,
+	   ((ctrla & RTC_CTRL_A_DV1) ? "enabled" : "disabled"),
+	   ((ctrlb & RTC_CTRL_B_2412) ? "24-hour" : "12-hour"),
+	   ((ctrlb & RTC_CTRL_B_DSE) ? "enabled" : "disabled"),
+	   ((ctrlb & RTC_CTRL_B_DM) ? "binary" : "BCD"),
+	   ((ctrld & RTC_CTRL_D_VRT) ? "ok" : "exhausted or n/a"),
+	   ((ctrl4a & RTC_CTRL_4A_VRT2) ? "ok" : "exhausted or n/a"),
+	   ((ctrlb & RTC_CTRL_B_UIE) ? "yes" : "no"),
+	   ((ctrlb & RTC_CTRL_B_PIE) ? "yes" : "no"),
+	   (!(ctrl4b & RTC_CTRL_4B_E32K) ?
+	    ds1685_rtc_pirq_rate[(ctrla & RTC_CTRL_A_RS_MASK)] : "none"),
+	   (!((ctrl4b & RTC_CTRL_4B_E32K)) ?
+	    ds1685_rtc_sqw_freq[(ctrla & RTC_CTRL_A_RS_MASK)] : "32768Hz"),
+#ifdef CONFIG_RTC_DS1685_PROC_REGS
+	   ssn[0], ssn[1], ssn[2], ssn[3], ssn[4], ssn[5], ssn[6], ssn[7],
+	   ds1685_rtc_print_regs(ctrla, bits[0]),
+	   ds1685_rtc_print_regs(ctrlb, bits[1]),
+	   ds1685_rtc_print_regs(ctrlc, bits[2]),
+	   ds1685_rtc_print_regs(ctrld, bits[3]),
+	   ds1685_rtc_print_regs(ctrl4a, bits[4]),
+	   ds1685_rtc_print_regs(ctrl4b, bits[5]));
+#else
+	   ssn[0], ssn[1], ssn[2], ssn[3], ssn[4], ssn[5], ssn[6], ssn[7]);
+#endif
+	return 0;
+}
+#else
+#define ds1685_rtc_proc NULL
+#endif /* CONFIG_PROC_FS */
+/* ----------------------------------------------------------------------- */
+
+
+/* ----------------------------------------------------------------------- */
+/* RTC Class operations */
+
+static const struct rtc_class_ops ds1685_rtc_ops = {
+	.proc			= ds1685_rtc_proc,
+	.read_time		= ds1685_rtc_read_time,
+	.set_time		= ds1685_rtc_set_time,
+	.read_alarm		= ds1685_rtc_read_alarm,
+	.set_alarm		= ds1685_rtc_set_alarm,
+	.irq_set_freq		= ds1685_rtc_set_freq,
+	.irq_set_state		= ds1685_rtc_periodic_irq_enable,
+	.alarm_irq_enable	= ds1685_rtc_alarm_irq_enable,
+	.update_irq_enable	= ds1685_rtc_update_irq_enable,
+};
+/* ----------------------------------------------------------------------- */
+
+
+/* ----------------------------------------------------------------------- */
+/* SysFS interface */
+
+#ifdef CONFIG_SYSFS
+/**
+ * ds1685_rtc_sysfs_nvram_read - reads rtc nvram via sysfs.
+ * @file: pointer to file structure.
+ * @kobj: pointer to kobject structure.
+ * @bin_attr: pointer to bin_attribute structure.
+ * @buf: pointer to char array to hold the output.
+ * @pos: current file position pointer.
+ * @size: size of the data to read.
+ */
+static ssize_t
+ds1685_rtc_sysfs_nvram_read(struct file *filp, struct kobject *kobj,
+                            struct bin_attribute *bin_attr, char *buf,
+                            loff_t pos, size_t size)
+{
+	struct platform_device *pdev =
+		to_platform_device(container_of(kobj, struct device, kobj));
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	ssize_t count;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+	ds1685_rtc_switch_to_bank0(rtc);
+
+	/* Read NVRAM in time and bank0 registers. */
+	for (count = 0; size > 0 && pos < NVRAM_TOTAL_SZ_BANK0;
+	     count++, size--) {
+		if (count < NVRAM_SZ_TIME)
+			*buf++ = ds1685_read(rtc, (NVRAM_TIME_BASE +
+			                     pos++));
+		else
+			*buf++ = ds1685_read(rtc, (NVRAM_BANK0_BASE +
+			                     pos++));
+	}
+
+#ifndef CONFIG_RTC_DRV_DS1689
+	if (size > 0) {
+		ds1685_rtc_switch_to_bank1(rtc);
+
+#ifndef CONFIG_RTC_DRV_DS1685
+		/* Enable burst-mode on DS17x85/DS17x87 */
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+		             (ds1685_read(rtc, RTC_EXT_CTRL_4A) |
+		              RTC_CTRL_4A_BME));
+
+		/* We need one write to RTC_BANK1_RAM_ADDR_LSB to start
+		 * reading with burst-mode */
+		ds1685_write(rtc, RTC_BANK1_RAM_ADDR_LSB,
+			     (pos - NVRAM_TOTAL_SZ_BANK0));
+#endif
+
+		/* Read NVRAM in bank1 registers. */
+		for (count = 0; size > 0 && pos < NVRAM_TOTAL_SZ;
+		     count++, size--) {
+#ifdef CONFIG_RTC_DRV_DS1685
+			/* DS1685/DS1687 has to write to RTC_BANK1_RAM_ADDR
+			 * before each read. */
+			ds1685_write(rtc, RTC_BANK1_RAM_ADDR,
+				     (pos - NVRAM_TOTAL_SZ_BANK0));
+#endif
+			*buf++ = ds1685_read(rtc, RTC_BANK1_RAM_DATA_PORT);
+			pos++;
+		}
+
+#ifndef CONFIG_RTC_DRV_DS1685
+		/* Disable burst-mode on DS17x85/DS17x87 */
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+		             (ds1685_read(rtc, RTC_EXT_CTRL_4A) &
+		              ~(RTC_CTRL_4A_BME)));
+#endif
+		ds1685_rtc_switch_to_bank0(rtc);
+	}
+#endif /* !CONFIG_RTC_DRV_DS1689 */
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	/*
+	 * XXX: Bug? this causes the function to get executed several times
+	 * in succession.  But it's the only way to actually get data written
+	 * out to a file correctly.
+	 */
+	return count;
+}
+
+
+/**
+ * ds1685_rtc_sysfs_nvram_write - writes rtc nvram via sysfs.
+ * @file: pointer to file structure.
+ * @kobj: pointer to kobject structure.
+ * @bin_attr: pointer to bin_attribute structure.
+ * @buf: pointer to char array to hold the input.
+ * @pos: current file position pointer.
+ * @size: size of the data to write.
+ */
+static ssize_t
+ds1685_rtc_sysfs_nvram_write(struct file *filp, struct kobject *kobj,
+                             struct bin_attribute *bin_attr, char *buf,
+                             loff_t pos, size_t size)
+{
+	struct platform_device *pdev =
+		to_platform_device(container_of(kobj, struct device, kobj));
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	ssize_t count;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+	ds1685_rtc_switch_to_bank0(rtc);
+
+	/* Write NVRAM in time and bank0 registers. */
+	for (count = 0; size > 0 && pos < NVRAM_TOTAL_SZ_BANK0;
+	     count++, size--)
+		if (count < NVRAM_SZ_TIME)
+			ds1685_write(rtc, (NVRAM_TIME_BASE + pos++),
+			             *buf++);
+		else
+			ds1685_write(rtc, (NVRAM_BANK0_BASE), *buf++);
+
+#ifndef CONFIG_RTC_DRV_DS1689
+	if (size > 0) {
+		ds1685_rtc_switch_to_bank1(rtc);
+
+#ifndef CONFIG_RTC_DRV_DS1685
+		/* Enable burst-mode on DS17x85/DS17x87 */
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+		             (ds1685_read(rtc, RTC_EXT_CTRL_4A) |
+		              RTC_CTRL_4A_BME));
+
+		/* We need one write to RTC_BANK1_RAM_ADDR_LSB to start
+		 * writing with burst-mode */
+		ds1685_write(rtc, RTC_BANK1_RAM_ADDR_LSB,
+			     (pos - NVRAM_TOTAL_SZ_BANK0));
+#endif
+
+		/* Write NVRAM in bank1 registers. */
+		for (count = 0; size > 0 && pos < NVRAM_TOTAL_SZ;
+		     count++, size--) {
+#ifdef CONFIG_RTC_DRV_DS1685
+			/* DS1685/DS1687 has to write to RTC_BANK1_RAM_ADDR
+			 * before each read. */
+			ds1685_write(rtc, RTC_BANK1_RAM_ADDR,
+				     (pos - NVRAM_TOTAL_SZ_BANK0));
+#endif
+			ds1685_write(rtc, RTC_BANK1_RAM_DATA_PORT, *buf++);
+			pos++;
+		}
+
+#ifndef CONFIG_RTC_DRV_DS1685
+		/* Disable burst-mode on DS17x85/DS17x87 */
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+		             (ds1685_read(rtc, RTC_EXT_CTRL_4A) &
+		              ~(RTC_CTRL_4A_BME)));
+#endif
+		ds1685_rtc_switch_to_bank0(rtc);
+	}
+#endif /* !CONFIG_RTC_DRV_DS1689 */
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	return count;
+}
+
+
+/**
+ * struct ds1685_rtc_sysfs_nvram_attr - sysfs attributes for rtc nvram.
+ * @attr: nvram attributes.
+ * @read: nvram read function.
+ * @write: nvram write function.
+ * @size: nvram total size (bank0 + extended).
+ */
+static struct bin_attribute ds1685_rtc_sysfs_nvram_attr = {
+	.attr = {
+		.name = "nvram",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.read = ds1685_rtc_sysfs_nvram_read,
+	.write = ds1685_rtc_sysfs_nvram_write,
+	.size = NVRAM_TOTAL_SZ
+};
+
+
+/**
+ * ds1685_rtc_sysfs_sqwfreq_show - reads the square-wave freq via sysfs.
+ * @dev: pointer to device structure.
+ * @attr: pointer to device_attribute structure.
+ * @buf: pointer to char array to hold the output.
+ */
+static ssize_t
+ds1685_rtc_sysfs_sqwfreq_show(struct device *dev,
+                              struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 ctrla, ctrl4b;
+	u32 freq = 0;
+
+	/* Read the square-wave data from the RTC registers. */
+	ds1685_rtc_switch_to_bank1(rtc);
+	ctrla = ds1685_read(rtc, RTC_CTRL_A);
+	ctrl4b = ds1685_read(rtc, RTC_EXT_CTRL_4B);
+	ds1685_rtc_switch_to_bank0(rtc);
+
+	/* If E32K is set, return 32768Hz. */
+	if (ctrl4b & RTC_CTRL_4B_E32K)
+		return sprintf(buf, "%d\n", RTC_SQW_32768HZ);
+
+	/* Else, return the user-selected frequency. */
+	switch (ctrla & RTC_CTRL_A_RS_MASK) {
+	case RTC_SQW_0HZ:    freq = 0;		break;
+	case RTC_SQW_2HZ:    freq = 2;		break;
+	case RTC_SQW_4HZ:    freq = 4;		break;
+	case RTC_SQW_8HZ:    freq = 8;		break;
+	case RTC_SQW_16HZ:   freq = 16;		break;
+	case RTC_SQW_32HZ:   freq = 32;		break;
+	case RTC_SQW_64HZ:   freq = 64;		break;
+	case 0x02:
+	case RTC_SQW_128HZ:  freq = 128;	break;
+	case 0x01:
+	case RTC_SQW_256HZ:  freq = 256;	break;
+	case RTC_SQW_512HZ:  freq = 512;	break;
+	case RTC_SQW_1024HZ: freq = 1024;	break;
+	case RTC_SQW_2048HZ: freq = 2048;	break;
+	case RTC_SQW_4096HZ: freq = 4096;	break;
+	case RTC_SQW_8192HZ: freq = 8192;	break;
+	}
+
+	return sprintf(buf, "%d\n", freq);
+}
+
+
+/**
+ * ds1685_rtc_sysfs_sqwfreq_store - sets the square-wave freq via sysfs.
+ * @dev: pointer to device structure.
+ * @attr: pointer to device_attribute structure.
+ * @buf: pointer to char array to hold the output.
+ * @count: number of bytes written.
+ */
+static ssize_t
+ds1685_rtc_sysfs_sqwfreq_store(struct device *dev,
+                               struct device_attribute *attr, const char *buf,
+                               size_t count)
+{
+	long int freq = 0;
+	int ret;
+
+	/* We only accept numbers. */
+	if (strict_strtol(buf, 10, &freq) < 0)
+		return -EINVAL;
+
+	/* Return the failure code if the frequency couldn't be set. */
+	ret = ds1685_rtc_set_freq(dev, freq);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR(sqwfreq, S_IRUGO | S_IWUSR, ds1685_rtc_sysfs_sqwfreq_show,
+                   ds1685_rtc_sysfs_sqwfreq_store);
+
+
+/**
+ * ds1685_rtc_sysfs_battery_show - sysfs file for main battery status.
+ * @dev: pointer to device structure.
+ * @attr: pointer to device_attribute structure.
+ * @buf: pointer to char array to hold the output.
+ */
+static ssize_t
+ds1685_rtc_sysfs_battery_show(struct device *dev,
+                              struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 ctrld;
+
+	ctrld = ds1685_read(rtc, RTC_CTRL_D);
+
+	return sprintf(buf, "%s\n",
+	               (ctrld & RTC_CTRL_D_VRT) ? "ok" : "not ok or N/A");
+}
+static DEVICE_ATTR(battery, S_IRUGO, ds1685_rtc_sysfs_battery_show, NULL);
+
+
+/**
+ * ds1685_rtc_sysfs_auxbatt_show - sysfs file for aux battery status.
+ * @dev: pointer to device structure.
+ * @attr: pointer to device_attribute structure.
+ * @buf: pointer to char array to hold the output.
+ */
+static ssize_t
+ds1685_rtc_sysfs_auxbatt_show(struct device *dev,
+                              struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 ctrl4a;
+
+	ds1685_rtc_switch_to_bank1(rtc);
+	ctrl4a = ds1685_read(rtc, RTC_EXT_CTRL_4A);
+	ds1685_rtc_switch_to_bank0(rtc);
+
+	return sprintf(buf, "%s\n",
+	               (ctrl4a & RTC_CTRL_4A_VRT2) ? "ok" : "not ok or N/A");
+}
+static DEVICE_ATTR(auxbatt, S_IRUGO, ds1685_rtc_sysfs_auxbatt_show, NULL);
+
+
+/**
+ * ds1685_rtc_sysfs_serial_show - sysfs file for silicon serial number.
+ * @dev: pointer to device structure.
+ * @attr: pointer to device_attribute structure.
+ * @buf: pointer to char array to hold the output.
+ */
+static ssize_t
+ds1685_rtc_sysfs_serial_show(struct device *dev,
+                             struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+	u8 ssn[8];
+
+	ds1685_rtc_switch_to_bank1(rtc);
+	ds1685_rtc_get_ssn(rtc, ssn);
+	ds1685_rtc_switch_to_bank0(rtc);
+
+	return sprintf(buf, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+	               ssn[0], ssn[1], ssn[2], ssn[3], ssn[4], ssn[5], ssn[6],
+	               ssn[7]);
+
+	return 0;
+}
+static DEVICE_ATTR(serial, S_IRUGO, ds1685_rtc_sysfs_serial_show, NULL);
+
+/**
+ * struct ds1685_rtc_sysfs_misc_attrs - list for misc RTC features.
+ */
+static struct attribute*
+ds1685_rtc_sysfs_misc_attrs[] = {
+	&dev_attr_sqwfreq.attr,
+	&dev_attr_battery.attr,
+	&dev_attr_auxbatt.attr,
+	&dev_attr_serial.attr,
+	NULL,
+};
+
+
+/**
+ * struct ds1685_rtc_sysfs_misc_grp - attr group for misc RTC features.
+ */
+static const struct attribute_group
+ds1685_rtc_sysfs_misc_grp = {
+	.name = "misc",
+	.attrs = ds1685_rtc_sysfs_misc_attrs,
+};
+
+
+#ifdef CONFIG_RTC_DS1685_SYSFS_REGS
+/**
+ * struct ds1685_rtc_regs.
+ * @name: char pointer for the bit name.
+ * @reg: control register the bit is in.
+ * @bit: the bit's offset in the register.
+ */
+struct ds1685_rtc_regs {
+	const char *name;
+	const u8 reg;
+	const u8 bit;
+};
+
+
+/*
+ * Register bit lookup table.
+ */
+static const struct ds1685_rtc_regs
+ds1685_regs_table[] = {
+	{ "uip",  RTC_CTRL_A,      RTC_CTRL_A_UIP   },
+	{ "dv2",  RTC_CTRL_A,      RTC_CTRL_A_DV2   },
+	{ "dv1",  RTC_CTRL_A,      RTC_CTRL_A_DV1   },
+	{ "dv0",  RTC_CTRL_A,      RTC_CTRL_A_DV0   },
+	{ "rs3",  RTC_CTRL_A,      RTC_CTRL_A_RS3   },
+	{ "rs2",  RTC_CTRL_A,      RTC_CTRL_A_RS2   },
+	{ "rs1",  RTC_CTRL_A,      RTC_CTRL_A_RS1   },
+	{ "rs0",  RTC_CTRL_A,      RTC_CTRL_A_RS0   },
+	{ "set",  RTC_CTRL_B,      RTC_CTRL_B_SET   },
+	{ "pie",  RTC_CTRL_B,      RTC_CTRL_B_PIE   },
+	{ "aie",  RTC_CTRL_B,      RTC_CTRL_B_AIE   },
+	{ "uie",  RTC_CTRL_B,      RTC_CTRL_B_UIE   },
+	{ "sqwe", RTC_CTRL_B,      RTC_CTRL_B_SQWE  },
+	{ "dm",   RTC_CTRL_B,      RTC_CTRL_B_DM    },
+	{ "2412", RTC_CTRL_B,      RTC_CTRL_B_2412  },
+	{ "dse",  RTC_CTRL_B,      RTC_CTRL_B_DSE   },
+	{ "irqf", RTC_CTRL_C,      RTC_CTRL_C_IRQF  },
+	{ "pf",   RTC_CTRL_C,      RTC_CTRL_C_PF    },
+	{ "af",   RTC_CTRL_C,      RTC_CTRL_C_AF    },
+	{ "uf",   RTC_CTRL_C,      RTC_CTRL_C_UF    },
+	{ "vrt",  RTC_CTRL_D,      RTC_CTRL_D_VRT   },
+	{ "vrt2", RTC_EXT_CTRL_4A, RTC_CTRL_4A_VRT2 },
+	{ "incr", RTC_EXT_CTRL_4A, RTC_CTRL_4A_INCR },
+	{ "pab",  RTC_EXT_CTRL_4A, RTC_CTRL_4A_PAB  },
+	{ "rf",   RTC_EXT_CTRL_4A, RTC_CTRL_4A_RF   },
+	{ "wf",   RTC_EXT_CTRL_4A, RTC_CTRL_4A_WF   },
+	{ "kf",   RTC_EXT_CTRL_4A, RTC_CTRL_4A_KF   },
+#if !defined(CONFIG_RTC_DRV_DS1685) && !defined(CONFIG_RTC_DRV_DS1689)
+	{ "bme",  RTC_EXT_CTRL_4A, RTC_CTRL_4A_BME  },
+#endif
+	{ "abe",  RTC_EXT_CTRL_4B, RTC_CTRL_4B_ABE  },
+	{ "e32k", RTC_EXT_CTRL_4B, RTC_CTRL_4B_E32K },
+	{ "cs",   RTC_EXT_CTRL_4B, RTC_CTRL_4B_CS   },
+	{ "rce",  RTC_EXT_CTRL_4B, RTC_CTRL_4B_RCE  },
+	{ "prs",  RTC_EXT_CTRL_4B, RTC_CTRL_4B_PRS  },
+	{ "rie",  RTC_EXT_CTRL_4B, RTC_CTRL_4B_RIE  },
+	{ "wie",  RTC_EXT_CTRL_4B, RTC_CTRL_4B_WIE  },
+	{ "kse",  RTC_EXT_CTRL_4B, RTC_CTRL_4B_KSE  },
+	{ NULL,   0,               0                },
+};
+
+
+/**
+ * ds1685_rtc_sysfs_regs_lookup - register bit lookup function.
+ * @name: register bit to look up in ds1685_regs_table.
+ */
+static const struct ds1685_rtc_regs*
+ds1685_rtc_sysfs_regs_lookup(const char *name)
+{
+	const struct ds1685_rtc_regs *p = ds1685_regs_table;
+
+	for (; p->name != NULL; ++p)
+		if (strcmp(p->name, name) == 0)
+			return p;
+
+	return NULL;
+}
+
+
+/**
+ * ds1685_rtc_sysfs_ctrl_regs_show - reads a register bit via sysfs.
+ * @dev: pointer to device structure.
+ * @attr: pointer to device_attribute structure.
+ * @buf: pointer to char array to hold the output.
+ */
+static ssize_t
+ds1685_rtc_sysfs_ctrl_regs_show(struct device *dev,
+                                struct device_attribute *attr, char *buf)
+{
+	struct ds1685_priv *rtc = dev_get_drvdata(dev);
+	u8 reg = 0, bit = 0, tmp;
+	const struct ds1685_rtc_regs *reg_info =
+		ds1685_rtc_sysfs_regs_lookup(attr->attr.name);
+	
+	/* Make sure we actually matched something. */
+	if (!reg_info)
+		return -EINVAL;
+
+	reg = reg_info->reg;
+	bit = reg_info->bit;
+
+	/* No spinlock during a read -- mutex is already held. */
+	ds1685_rtc_switch_to_bank1(rtc);
+	tmp = ds1685_read(rtc, reg) & bit;
+	ds1685_rtc_switch_to_bank0(rtc);
+
+	return sprintf(buf, "%d\n", (tmp ? 1 : 0));
+}
+
+
+/**
+ * ds1685_rtc_sysfs_ctrl_regs_store - writes a register bit via sysfs.
+ * @dev: pointer to device structure.
+ * @attr: pointer to device_attribute structure.
+ * @buf: pointer to char array to hold the output.
+ * @count: number of bytes written.
+ */
+static ssize_t
+ds1685_rtc_sysfs_ctrl_regs_store(struct device *dev,
+                                 struct device_attribute *attr,
+                                 const char *buf, size_t count)
+{
+	struct ds1685_priv *rtc = dev_get_drvdata(dev);
+	u8 reg = 0, bit = 0, tmp;
+	unsigned long flags = 0;
+	long int val = 0;
+	const struct ds1685_rtc_regs *reg_info =
+		ds1685_rtc_sysfs_regs_lookup(attr->attr.name);
+
+	/* We only accept numbers. */
+	if (strict_strtol(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	/* bits are binary, 0 or 1 only. */
+	if ((val != 0) && (val != 1))
+		return -ERANGE;
+
+	/* Make sure we actually matched something. */
+	if (!reg_info)
+		return -EINVAL;
+
+	reg = reg_info->reg;
+	bit = reg_info->bit;
+
+	/* Safe to spinlock during a write. */
+	ds1685_rtc_begin_ctrl_access(rtc, flags);
+	tmp = ds1685_read(rtc, reg);
+	ds1685_write(rtc, reg, (val ? (tmp | bit) : (tmp & ~(bit))));
+	ds1685_rtc_end_ctrl_access(rtc, flags);
+
+	return count;
+}
+
+
+/**
+ * DS1685_RTC_SYSFS_REG_RO - device_attribute for a read-only register bit.
+ * @bit: bit to read.
+ */
+#define DS1685_RTC_SYSFS_REG_RO(bit)					\
+	static DEVICE_ATTR(bit, S_IRUGO,				\
+	ds1685_rtc_sysfs_ctrl_regs_show, NULL)
+
+/**
+ * DS1685_RTC_SYSFS_REG_RW - device_attribute for a read-write register bit.
+ * @bit: bit to read or write.
+ */
+#define DS1685_RTC_SYSFS_REG_RW(bit)					\
+	static DEVICE_ATTR(bit, S_IRUGO | S_IWUSR,			\
+	ds1685_rtc_sysfs_ctrl_regs_show,				\
+	ds1685_rtc_sysfs_ctrl_regs_store)
+
+
+/*
+ * Control Register A bits.
+ */
+DS1685_RTC_SYSFS_REG_RO(uip);
+DS1685_RTC_SYSFS_REG_RW(dv2);
+DS1685_RTC_SYSFS_REG_RW(dv1);
+DS1685_RTC_SYSFS_REG_RO(dv0);
+DS1685_RTC_SYSFS_REG_RW(rs3);
+DS1685_RTC_SYSFS_REG_RW(rs2);
+DS1685_RTC_SYSFS_REG_RW(rs1);
+DS1685_RTC_SYSFS_REG_RW(rs0);
+
+static struct attribute*
+ds1685_rtc_sysfs_ctrla_attrs[] = {
+	&dev_attr_uip.attr,
+	&dev_attr_dv2.attr,
+	&dev_attr_dv1.attr,
+	&dev_attr_dv0.attr,
+	&dev_attr_rs3.attr,
+	&dev_attr_rs2.attr,
+	&dev_attr_rs1.attr,
+	&dev_attr_rs0.attr,
+	NULL,
+};
+
+static const struct attribute_group
+ds1685_rtc_sysfs_ctrla_grp = {
+	.name = "ctrla",
+	.attrs = ds1685_rtc_sysfs_ctrla_attrs,
+};
+
+
+/*
+ * Control Register B bits.
+ */
+DS1685_RTC_SYSFS_REG_RO(set);
+DS1685_RTC_SYSFS_REG_RW(pie);
+DS1685_RTC_SYSFS_REG_RW(aie);
+DS1685_RTC_SYSFS_REG_RW(uie);
+DS1685_RTC_SYSFS_REG_RW(sqwe);
+DS1685_RTC_SYSFS_REG_RO(dm);
+DS1685_RTC_SYSFS_REG_RO(2412);
+DS1685_RTC_SYSFS_REG_RO(dse);
+
+static struct attribute*
+ds1685_rtc_sysfs_ctrlb_attrs[] = {
+	&dev_attr_set.attr,
+	&dev_attr_pie.attr,
+	&dev_attr_aie.attr,
+	&dev_attr_uie.attr,
+	&dev_attr_sqwe.attr,
+	&dev_attr_dm.attr,
+	&dev_attr_2412.attr,
+	&dev_attr_dse.attr,
+	NULL,
+};
+
+static const struct attribute_group
+ds1685_rtc_sysfs_ctrlb_grp = {
+	.name = "ctrlb",
+	.attrs = ds1685_rtc_sysfs_ctrlb_attrs,
+};
+
+
+/*
+ * Control Register C bits.
+ *
+ * Reading Control C clears these bits!  Reading them individually can
+ * possibly cause an interrupt to be missed.  Use the /proc interface
+ * to see all the bits in this register simultaneously.
+ */
+DS1685_RTC_SYSFS_REG_RO(irqf);
+DS1685_RTC_SYSFS_REG_RO(pf);
+DS1685_RTC_SYSFS_REG_RO(af);
+DS1685_RTC_SYSFS_REG_RO(uf);
+
+static struct attribute*
+ds1685_rtc_sysfs_ctrlc_attrs[] = {
+	&dev_attr_irqf.attr,
+	&dev_attr_pf.attr,
+	&dev_attr_af.attr,
+	&dev_attr_uf.attr,
+	NULL,
+};
+
+static const struct attribute_group
+ds1685_rtc_sysfs_ctrlc_grp = {
+	.name = "ctrlc",
+	.attrs = ds1685_rtc_sysfs_ctrlc_attrs,
+};
+
+
+/*
+ * Control Register D bits.
+ */
+DS1685_RTC_SYSFS_REG_RO(vrt);
+
+static struct attribute*
+ds1685_rtc_sysfs_ctrld_attrs[] = {
+	&dev_attr_vrt.attr,
+	NULL,
+};
+
+static const struct attribute_group
+ds1685_rtc_sysfs_ctrld_grp = {
+	.name = "ctrld",
+	.attrs = ds1685_rtc_sysfs_ctrld_attrs,
+};
+
+
+/*
+ * Control Register 4A bits.
+ */
+DS1685_RTC_SYSFS_REG_RO(vrt2);
+DS1685_RTC_SYSFS_REG_RO(incr);
+DS1685_RTC_SYSFS_REG_RW(pab);
+DS1685_RTC_SYSFS_REG_RW(rf);
+DS1685_RTC_SYSFS_REG_RW(wf);
+DS1685_RTC_SYSFS_REG_RW(kf);
+#if !defined(CONFIG_RTC_DRV_DS1685) && !defined(CONFIG_RTC_DRV_DS1689)
+DS1685_RTC_SYSFS_REG_RO(bme);
+#endif
+
+static struct attribute*
+ds1685_rtc_sysfs_ctrl4a_attrs[] = {
+	&dev_attr_vrt2.attr,
+	&dev_attr_incr.attr,
+	&dev_attr_pab.attr,
+	&dev_attr_rf.attr,
+	&dev_attr_wf.attr,
+	&dev_attr_kf.attr,
+#if !defined(CONFIG_RTC_DRV_DS1685) && !defined(CONFIG_RTC_DRV_DS1689)
+	&dev_attr_bme.attr,
+#endif
+	NULL,
+};
+
+static const struct attribute_group
+ds1685_rtc_sysfs_ctrl4a_grp = {
+	.name = "ctrl4a",
+	.attrs = ds1685_rtc_sysfs_ctrl4a_attrs,
+};
+
+
+/*
+ * Control Register 4B bits.
+ */
+DS1685_RTC_SYSFS_REG_RW(abe);
+DS1685_RTC_SYSFS_REG_RW(e32k);
+DS1685_RTC_SYSFS_REG_RO(cs);
+DS1685_RTC_SYSFS_REG_RW(rce);
+DS1685_RTC_SYSFS_REG_RW(prs);
+DS1685_RTC_SYSFS_REG_RW(rie);
+DS1685_RTC_SYSFS_REG_RW(wie);
+DS1685_RTC_SYSFS_REG_RW(kse);
+
+static struct attribute*
+ds1685_rtc_sysfs_ctrl4b_attrs[] = {
+	&dev_attr_abe.attr,
+	&dev_attr_e32k.attr,
+	&dev_attr_cs.attr,
+	&dev_attr_rce.attr,
+	&dev_attr_prs.attr,
+	&dev_attr_rie.attr,
+	&dev_attr_wie.attr,
+	&dev_attr_kse.attr,
+	NULL,
+};
+
+static const struct attribute_group
+ds1685_rtc_sysfs_ctrl4b_grp = {
+	.name = "ctrl4b",
+	.attrs = ds1685_rtc_sysfs_ctrl4b_attrs,
+};
+#endif /* CONFIG_RTC_DS1685_SYSFS_REGS */
+
+
+/**
+ * ds1685_rtc_sysfs_register - register sysfs files.
+ * @dev: pointer to device structure.
+ */
+static int __devinit
+ds1685_rtc_sysfs_register(struct device *dev)
+{
+	int ret = 0;
+
+	sysfs_bin_attr_init(&ds1685_rtc_sysfs_nvram_attr);
+	ret = sysfs_create_bin_file(&dev->kobj,
+	                            &ds1685_rtc_sysfs_nvram_attr);
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&dev->kobj, &ds1685_rtc_sysfs_misc_grp);
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_RTC_DS1685_SYSFS_REGS
+	ret = sysfs_create_group(&dev->kobj, &ds1685_rtc_sysfs_ctrla_grp);
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&dev->kobj, &ds1685_rtc_sysfs_ctrlb_grp);
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&dev->kobj, &ds1685_rtc_sysfs_ctrlc_grp);
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&dev->kobj, &ds1685_rtc_sysfs_ctrld_grp);
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&dev->kobj, &ds1685_rtc_sysfs_ctrl4a_grp);
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&dev->kobj, &ds1685_rtc_sysfs_ctrl4b_grp);
+	if (ret)
+		return ret;
+#endif
+	return 0;
+}
+
+
+/**
+ * ds1685_rtc_sysfs_unregister - unregister sysfs files.
+ * @dev: pointer to device structure.
+ */
+static int __devexit
+ds1685_rtc_sysfs_unregister(struct device *dev)
+{
+	sysfs_remove_bin_file(&dev->kobj, &ds1685_rtc_sysfs_nvram_attr);
+	sysfs_remove_group(&dev->kobj, &ds1685_rtc_sysfs_misc_grp);
+
+#ifdef CONFIG_RTC_DS1685_SYSFS_REGS
+	sysfs_remove_group(&dev->kobj, &ds1685_rtc_sysfs_ctrla_grp);
+	sysfs_remove_group(&dev->kobj, &ds1685_rtc_sysfs_ctrlb_grp);
+	sysfs_remove_group(&dev->kobj, &ds1685_rtc_sysfs_ctrlc_grp);
+	sysfs_remove_group(&dev->kobj, &ds1685_rtc_sysfs_ctrld_grp);
+	sysfs_remove_group(&dev->kobj, &ds1685_rtc_sysfs_ctrl4a_grp);
+	sysfs_remove_group(&dev->kobj, &ds1685_rtc_sysfs_ctrl4b_grp);
+#endif
+
+	return 0;
+}
+#endif /* CONFIG_SYSFS */
+
+
+
+/* ----------------------------------------------------------------------- */
+/* Driver Probe/Removal */
+
+/**
+ * ds1685_rtc_probe - initializes rtc driver.
+ * @pdev: pointer to platform_device structure.
+ */
+static int __devinit
+ds1685_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtc_dev;
+	struct resource *res;
+	struct ds1685_priv *rtc;
+	struct ds1685_rtc_platform_data *pdata;
+	u8 ctrla, ctrlb, hours;
+	unsigned char am_pm;
+	int ret = 0;
+
+	/* Get the platform resources. */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
+	/* Get the platform data. */
+	pdata = (struct ds1685_rtc_platform_data *) pdev->dev.platform_data;
+	if (!pdata)
+		return -ENODEV;
+
+	/* Allocate memory for the rtc device. */
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+	rtc->size = resource_size(res);
+
+	/* Request a memory region. */
+	/* TODO: Only mmio for now.  Need to add standard io. */
+	if (!devm_request_mem_region(&pdev->dev, res->start, rtc->size,
+	                             pdev->name))
+		return -EBUSY;
+
+	/* Set the base address for the rtc, and ioremap its registers. */
+	rtc->baseaddr = res->start;
+	rtc->regs = devm_ioremap(&pdev->dev, res->start, rtc->size);
+	if (!rtc->regs)
+		return -ENOMEM;
+
+	/* Get the register step size. */
+	if (pdata->regstep > 0)
+		rtc->regstep = pdata->regstep;
+	else
+		rtc->regstep = 1;
+
+	/* Assign the pre-shutdown function, if defined. */
+	if (pdata->plat_prepare_poweroff != NULL)
+		rtc->prepare_poweroff = pdata->plat_prepare_poweroff;
+
+	/* Assign the wake_alarm function, if defined. */
+	if (pdata->plat_wake_alarm != NULL)
+		rtc->wake_alarm = pdata->plat_wake_alarm;
+
+	/* Assign the post_ram_clear function, if defined. */
+	if (pdata->plat_post_ram_clear != NULL)
+		rtc->post_ram_clear = pdata->plat_post_ram_clear;
+
+	/* Init the spinlock, workqueue, denouncer, & set the driver data. */
+	spin_lock_init(&rtc->lock);
+	INIT_WORK(&rtc->work, ds1685_rtc_work_queue);
+	platform_set_drvdata(pdev, rtc);
+
+	/* Turn the oscillator on if is not already on (DV1 = 1). */
+	ctrla = ds1685_read(rtc, RTC_CTRL_A);
+	if (!(ctrla & RTC_CTRL_A_DV1))
+		ctrla |= RTC_CTRL_A_DV1;
+
+	/* Enable the countdown chain (DV2 = 0) */
+	ctrla &= ~(RTC_CTRL_A_DV2);
+
+	/* Clear RS3-RS0 in Control A. */
+	ctrla &= ~(RTC_CTRL_A_RS_MASK);
+
+	/*
+	 * All done with Control A.  Switch to Bank 1 for the remainder of
+	 * the RTC setup so we have access to the extended functions.
+	 */
+	ctrla |= RTC_CTRL_A_DV0;
+	ds1685_write(rtc, RTC_CTRL_A, ctrla);
+
+	/* Default to 32768kHz output. */
+	ds1685_write(rtc, RTC_EXT_CTRL_4B,
+	             (ds1685_read(rtc, RTC_EXT_CTRL_4B) | RTC_CTRL_4B_E32K));
+
+	/*
+	 * Set the SET bit in Control B so we can do some housekeeping.
+	 * We do not check UIP in Control A because this is a one-time
+	 * thing during driver setup and we'll just hope that we don't
+	 * hit in the middle of an update.
+	 */
+	ds1685_write(rtc, RTC_CTRL_B,
+	             (ds1685_read(rtc, RTC_CTRL_B) | RTC_CTRL_B_SET));
+
+	/* Force BCD mode (DM = 0). */
+	ctrlb = ds1685_read(rtc, RTC_CTRL_B);
+	if (ctrlb & RTC_CTRL_B_DM)
+		ctrlb &= ~(RTC_CTRL_B_DM);
+
+	/*
+	 * Disable Daylight Savings Time (DSE = 0).
+	 * The RTC has hardcoded timezone information that is rendered
+	 * obselete.  We'll let the OS deal with DST settings instead.
+	 */
+	if (ctrlb & RTC_CTRL_B_DSE)
+		ctrlb &= ~(RTC_CTRL_B_DSE);
+
+	/* Force 24-hour mode (2412 = 1). */
+	if (!(ctrlb & RTC_CTRL_B_2412)) {
+		/* Reinitialize the time hours. */
+		hours = ds1685_read(rtc, RTC_HOURS);
+		am_pm = hours & RTC_HOURS_AMPM_MASK;
+		hours = bcd2bin(hours & RTC_HOURS_12_MASK);
+		hours = ((hours == 12) ? 0 : ((am_pm) ? hours + 12 : hours));
+
+		/* Enable 24-hour mode. */
+		ctrlb |= RTC_CTRL_B_2412;
+
+		/* Write back to Control B, including DM & DSE bits. */
+		ds1685_write(rtc, RTC_CTRL_B, ctrlb);
+
+		/* Write the time hours back. */
+		ds1685_write(rtc, RTC_HOURS,
+		             bin2bcd(hours) & RTC_HOURS_24_MASK);
+
+		/* Reinitialize the alarm hours. */
+		hours = ds1685_read(rtc, RTC_HOURS_ALARM);
+		am_pm = hours & RTC_HOURS_AMPM_MASK;
+		hours = bcd2bin(hours & RTC_HOURS_12_MASK);
+		hours = ((hours == 12) ? 0 : ((am_pm) ? hours + 12 : hours));
+
+		/* Write the alarm hours back. */
+		ds1685_write(rtc, RTC_HOURS_ALARM,
+		             bin2bcd(hours) & RTC_HOURS_24_MASK);
+	} else {
+		/* 24-hour mode is already set, so write Control B back. */
+		ds1685_write(rtc, RTC_CTRL_B, ctrlb);
+	}
+
+	/* Unset the SET bit in Control B so the RTC can update. */
+	ds1685_write(rtc, RTC_CTRL_B,
+	             (ds1685_read(rtc, RTC_CTRL_B) & ~(RTC_CTRL_B_SET)));
+
+	/* Check the main battery. */
+	if (!(ds1685_read(rtc, RTC_CTRL_D) & RTC_CTRL_D_VRT))
+		dev_warn(&pdev->dev,
+		         "Main battery is exhausted! RTC may be invalid!\n");
+
+	/* Check the auxillary battery.  It is optional. */
+	if (!(ds1685_read(rtc, RTC_EXT_CTRL_4A) & RTC_CTRL_4A_VRT2))
+		dev_warn(&pdev->dev,
+			 "Aux battery is exhausted or not available.\n");
+
+	/* Fetch the IRQ and setup the interrupt handler. */
+	rtc->irq = platform_get_irq(pdev, 0);
+	if (rtc->irq > 0) {
+		/* Read Ctrl B and clear PIE/AIE/UIE. */
+		ds1685_write(rtc, RTC_CTRL_B,
+		             (ds1685_read(rtc, RTC_CTRL_B) &
+		              ~(RTC_CTRL_B_PAU_MASK)));
+
+		/* Reading Ctrl C auto-clears PF/AF/UF. */
+		ds1685_read(rtc, RTC_CTRL_C);
+
+		/* Read Ctrl 4B and clear RIE/WIE/KSE. */
+		ds1685_write(rtc, RTC_EXT_CTRL_4B,
+		             (ds1685_read(rtc, RTC_EXT_CTRL_4B) &
+		              ~(RTC_CTRL_4B_RWK_MASK)));
+
+		/* Manually clear RF/WF/KF in Ctrl 4A. */
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+		             (ds1685_read(rtc, RTC_EXT_CTRL_4A) &
+		              ~(RTC_CTRL_4A_RWK_MASK)));
+
+		/* Request an IRQ. */
+		ret = devm_request_irq(&pdev->dev, rtc->irq,
+		                       ds1685_rtc_irq_handler,
+		                       IRQF_SHARED, pdev->name, pdev);
+
+		/* Check to see if something came back. */
+		if (unlikely(ret)) {
+			dev_warn(&pdev->dev,
+			         "RTC interrupt not available\n");
+			rtc->irq = 0;
+		} else {
+			/*
+			 * Re-enable KSE to handle power button events.  We
+			 * do not enable WIE or RIE by default.
+			 */
+			ds1685_write(rtc, RTC_EXT_CTRL_4B,
+			             (ds1685_read(rtc, RTC_EXT_CTRL_4B) |
+		        	      RTC_CTRL_4B_KSE));
+		}
+	}
+
+	/* Setup complete. */
+	ds1685_rtc_switch_to_bank0(rtc);
+
+	/* Register the device as an RTC. */
+	rtc_dev = rtc_device_register(pdev->name, &pdev->dev,
+	                              &ds1685_rtc_ops, THIS_MODULE);
+
+	/* Success? */
+	if (IS_ERR(rtc_dev))
+		return PTR_ERR(rtc_dev);
+
+	/* Maximum periodic rate is 8192Hz (0.122070ms). */
+	rtc_dev->max_user_freq = RTC_MAX_USER_FREQ;
+
+	rtc->dev = rtc_dev;
+
+#ifdef CONFIG_SYSFS
+	ret = ds1685_rtc_sysfs_register(&pdev->dev);
+	if (ret)
+		rtc_device_unregister(rtc->dev);
+#endif
+
+	/* Done! */
+	return ret;
+}
+
+
+/**
+ * ds1685_rtc_remove - removes rtc driver.
+ * @pdev: pointer to platform_device structure.
+ */
+static int __devexit
+ds1685_rtc_remove(struct platform_device *pdev)
+{
+	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
+
+#ifdef CONFIG_SYSFS
+	ds1685_rtc_sysfs_unregister(&pdev->dev);
+#endif
+
+	rtc_device_unregister(rtc->dev);
+	if (rtc->irq > 0) {
+		/* Read Ctrl B and clear PIE/AIE/UIE. */
+		ds1685_write(rtc, RTC_CTRL_B,
+		             (ds1685_read(rtc, RTC_CTRL_B) &
+		              ~(RTC_CTRL_B_PAU_MASK)));
+
+		/* Reading Ctrl C auto-clears PF/AF/UF. */
+		ds1685_read(rtc, RTC_CTRL_C);
+
+		/* Read Ctrl 4B and clear RIE/WIE/KSE. */
+		ds1685_write(rtc, RTC_EXT_CTRL_4B,
+		             (ds1685_read(rtc, RTC_EXT_CTRL_4B) &
+		              ~(RTC_CTRL_4B_RWK_MASK)));
+
+		/* Manually clear RF/WF/KF in Ctrl 4A. */
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+		             (ds1685_read(rtc, RTC_EXT_CTRL_4A) &
+		              ~(RTC_CTRL_4A_RWK_MASK)));
+	}
+	flush_scheduled_work();
+
+	return 0;
+}
+
+
+/**
+ * ds1685_rtc_driver - rtc driver properties.
+ */
+static struct platform_driver ds1685_rtc_driver = {
+	.driver		= {
+		.name	= "rtc-ds1685",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ds1685_rtc_probe,
+	.remove		= __devexit_p(ds1685_rtc_remove),
+};
+
+
+/**
+ * ds1685_rtc_init - rtc module init.
+ */
+static int __init
+ds1685_rtc_init(void)
+{
+	return platform_driver_register(&ds1685_rtc_driver);
+}
+
+
+/**
+ * ds1685_rtc_exit - rtc module exit.
+ */
+static void __exit
+ds1685_rtc_exit(void)
+{
+	platform_driver_unregister(&ds1685_rtc_driver);
+}
+
+module_init(ds1685_rtc_init);
+module_exit(ds1685_rtc_exit);
+/* ----------------------------------------------------------------------- */
+
+
+/* ----------------------------------------------------------------------- */
+/* Poweroff function */
+
+/**
+ * ds1685_rtc_poweroff - uses the RTC chip to power the system off.
+ * @pdev: pointer to platform_device structure.
+ */
+extern void ATTRIB_NORET
+ds1685_rtc_poweroff(struct platform_device *pdev)
+{
+	u8 ctrla, ctrl4a, ctrl4b;
+	struct ds1685_priv *rtc;
+
+	/* Check for valid RTC data, else, spin forever. */
+	if (unlikely(!pdev))
+		while (1);
+	else {
+		/* Get the rtc data. */
+		rtc = platform_get_drvdata(pdev);
+
+		/*
+		 * Disable our IRQ.  We're powering down, so we're not
+		 * going to worry about cleaning up.  Most of that should
+		 * be taken care of by the shutdown scripts and we're the
+		 * final call.
+		 */
+		disable_irq_nosync(rtc->irq);
+
+		/* Ocsillator must be on and the countdown chain enabled. */
+		ctrla = ds1685_read(rtc, RTC_CTRL_A);
+		ctrla |= RTC_CTRL_A_DV1;
+		ctrla &= ~(RTC_CTRL_A_DV2);
+		ds1685_write(rtc, RTC_CTRL_A, ctrla);
+
+		/*
+		 * Read Control 4A and check the status of the auxillary
+		 * battery.  This must be present and working (VRT2 = 1)
+		 * for wakeup and kickstart functionality to be useful.
+		 */
+		ds1685_rtc_switch_to_bank1(rtc);
+		ctrl4a = ds1685_read(rtc, RTC_EXT_CTRL_4A);
+		if (ctrl4a & RTC_CTRL_4A_VRT2) {
+			/* Clear all the interrupt flags on Control 4A. */
+			ctrl4a &= ~(RTC_CTRL_4A_RWK_MASK);
+			ds1685_write(rtc, RTC_EXT_CTRL_4A, ctrl4a);
+
+			/*
+			 * The auxillary battery is present and working.
+			 * Enable extended functions (ABE=1), enable
+			 * wake-up (WUE=1), and enable kickstart (KSE=1)
+			 * in Control 4B.
+			 */
+			ctrl4b = ds1685_read(rtc, RTC_EXT_CTRL_4B);
+			ctrl4b |= RTC_CTRL_4B_ABE | RTC_CTRL_4B_WIE |
+			          RTC_CTRL_4B_KSE;
+			ds1685_write(rtc, RTC_EXT_CTRL_4B, ctrl4b);
+		}
+
+		/* Set PAB to 1 in Control 4A to power the system down. */
+		printk(KERN_EMERG "Powerdown.\n");
+		msleep(10);
+		ds1685_write(rtc, RTC_EXT_CTRL_4A,
+		             (ctrl4a | RTC_CTRL_4A_PAB));
+
+		/* Spin ... we do not switch back to bank0. */
+		while (1);
+	}
+}
+EXPORT_SYMBOL(ds1685_rtc_poweroff);
+/* ----------------------------------------------------------------------- */
+
+
+MODULE_AUTHOR("Joshua Kinard <kumba@gentoo.org>");
+MODULE_AUTHOR("Matthias Fuchs <matthias.fuchs@esd-electronics.com>");
+MODULE_DESCRIPTION("Dallas/Maxim DS1685/DS1687-series RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:rtc-ds1685");
diff -Naurp linux-2.6.orig/include/linux/rtc/ds1685.h
linux-2.6.rtc/include/linux/rtc/ds1685.h
- --- linux-2.6.orig/include/linux/rtc/ds1685.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.rtc/include/linux/rtc/ds1685.h	2011-04-07 07:22:55.593871001 -0400
@@ -0,0 +1,334 @@
+/*
+ * Definitions for the registers, addresses, and platform data of the
+ * DS1685/DS1687-series RTC chips.
+ *
+ * This Driver also works for the DS17X85/DS17X87 RTC chips.  Functionally
+ * similar to the DS1685/DS1687, they support a few extra features which
+ * include larger, battery-backed NV-SRAM, burst-mode access, and an RTC
+ * write counter.
+ *
+ * Copyright (C) 2009 Matthias Fuchs <matthias.fuchs@esd-electronics.com>
+ * Copyright (C) 2011 Joshua Kinard <kumba@gentoo.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_RTC_DS1685_H_
+#define _LINUX_RTC_DS1685_H_
+
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+
+/**
+ * struct ds1685_priv - DS1685 private data structure.
+ * @dev: pointer to the rtc_device structure.
+ * @regs: iomapped base address pointer of the RTC registers.
+ * @regstep: padding/step size between registers (optional).
+ * @baseaddr: base address of the RTC device.
+ * @size: resource size.
+ * @lock: private lock variable for spin locking/unlocking.
+ * @work: private workqueue.
+ * @irq: IRQ number assigned to the RTC device.
+ * @prepare_poweroff: pointer to platform pre-poweroff function.
+ * @wake_alarm: pointer to platform wake alarm function.
+ * @post_ram_clear: pointer to platform post ram-clear function.
+ */
+struct ds1685_priv {
+	struct rtc_device *dev;
+	void __iomem *regs;
+	u32 regstep;
+	resource_size_t baseaddr;
+	size_t size;
+	spinlock_t lock;
+	struct work_struct work;
+	int irq;
+	void (*prepare_poweroff)(void);
+	void (*wake_alarm)(void);
+	void (*post_ram_clear)(void);
+};
+
+
+/**
+ * struct ds1685_rtc_platform_data - platform data structure.
+ * @plat_prepare_poweroff: platform-specific pre-poweroff function.
+ * @plat_wake_alarm: platform-specific wake alarm function.
+ * @plat_post_ram_clear: platform-specific post ram-clear function.
+ *
+ * If your platform needs to use a custom padding/step size between
+ * registers, or uses one or more of the extended interrupts and needs special
+ * handling, then include this header file in your platform definition and
+ * set regstep and the plat_* pointers as appropriate.
+ */
+struct ds1685_rtc_platform_data {
+	void (*plat_prepare_poweroff)(void);
+	void (*plat_wake_alarm)(void);
+	void (*plat_post_ram_clear)(void);
+	const u32 regstep;
+};
+
+
+/*
+ * Time Registers.
+ */
+#define RTC_SECONDS		0x00	/* Seconds 00-59 */
+#define RTC_SECONDS_ALARM	0x01	/* Alarm Seconds 00-59 */
+#define RTC_MINUTES		0x02	/* Minutes 00-59 */
+#define RTC_MINUTES_ALARM	0x03	/* Alarm Minutes 00-59 */
+#define RTC_HOURS		0x04	/* Hours 01-12 AM/PM || 00-23 */
+#define RTC_HOURS_ALARM		0x05	/* Alarm Hours 01-12 AM/PM || 00-23 */
+#define RTC_WDAY		0x06	/* Day of Week 01-07 */
+#define RTC_MDAY		0x07	/* Day of Month 01-31 */
+#define RTC_MONTH		0x08	/* Month 01-12 */
+#define RTC_YEAR		0x09	/* Year 00-99 */
+#define RTC_CENTURY		0x48	/* Century 00-99 */
+#define RTC_MDAY_ALARM		0x49	/* Alarm Day of Month 01-31 */
+
+
+/*
+ * Bit masks for the Time registers in BCD Mode (DM = 0).
+ */
+#define RTC_SECONDS_MASK	0x7f	/* - x x x x x x x */
+#define RTC_MINUTES_MASK	0x7f	/* - x x x x x x x */
+#define RTC_HOURS_12_MASK	0x1f	/* - - - x x x x x */
+#define RTC_HOURS_24_MASK	0x3f	/* - - x x x x x x */
+#define RTC_WDAY_MASK		0x07	/* - - - - - x x x */
+#define RTC_MDAY_MASK		0x3f	/* - - x x x x x x */
+#define RTC_MONTH_MASK		0x1f	/* - - - x x x x x */
+#define RTC_YEAR_MASK		0xff	/* x x x x x x x x */
+#define RTC_CENTURY_MASK	0xff	/* x x x x x x x x */
+#define RTC_HOURS_AMPM_MASK	BIT(7)	/* Mask for the AM/PM bit */
+
+
+/*
+ * Control Registers.
+ */
+#define RTC_CTRL_A		0x0a	/* Control Register A */
+#define RTC_CTRL_B		0x0b	/* Control Register B */
+#define RTC_CTRL_C		0x0c	/* Control Register C */
+#define RTC_CTRL_D		0x0d	/* Control Register D */
+#define RTC_EXT_CTRL_4A		0x4a	/* Extended Control Register 4A */
+#define RTC_EXT_CTRL_4B		0x4b	/* Extended Control Register 4B */
+
+
+/*
+ * Bit names in Control Register A.
+ */
+#define RTC_CTRL_A_UIP		BIT(7)	/* Update In Progress */
+#define RTC_CTRL_A_DV2		BIT(6)	/* Countdown Chain */
+#define RTC_CTRL_A_DV1		BIT(5)	/* Oscillator Enable */
+#define RTC_CTRL_A_DV0		BIT(4)	/* Bank Select */
+#define RTC_CTRL_A_RS2		BIT(2)	/* Rate-Selection Bit 2 */
+#define RTC_CTRL_A_RS3		BIT(3)	/* Rate-Selection Bit 3 */
+#define RTC_CTRL_A_RS1		BIT(1)	/* Rate-Selection Bit 1 */
+#define RTC_CTRL_A_RS0		BIT(0)	/* Rate-Selection Bit 0 */
+#define RTC_CTRL_A_RS_MASK	0x0f	/* RS3 + RS2 + RS1 + RS0 */
+
+/*
+ * Bit names in Control Register B.
+ */
+#define RTC_CTRL_B_SET		BIT(7)	/* SET Bit */
+#define RTC_CTRL_B_PIE		BIT(6)	/* Periodic-Interrupt Enable */
+#define RTC_CTRL_B_AIE		BIT(5)	/* Alarm-Interrupt Enable */
+#define RTC_CTRL_B_UIE		BIT(4)	/* Update-Ended Interrupt-Enable */
+#define RTC_CTRL_B_SQWE		BIT(3)	/* Square-Wave Enable */
+#define RTC_CTRL_B_DM		BIT(2)	/* Data Mode */
+#define RTC_CTRL_B_2412		BIT(1)	/* 12-Hr/24-Hr Mode */
+#define RTC_CTRL_B_DSE		BIT(0)	/* Daylight Savings Enable */
+#define RTC_CTRL_B_PAU_MASK	0x70	/* PIE + AIE + UIE */
+
+
+/*
+ * Bit names in Control Register C.
+ *
+ * BIT(0), BIT(1), BIT(2), & BIT(3) are unused, always return 0, and cannot
+ * be written to.
+ */
+#define RTC_CTRL_C_IRQF		BIT(7)	/* Interrupt-Request Flag */
+#define RTC_CTRL_C_PF		BIT(6)	/* Periodic-Interrupt Flag */
+#define RTC_CTRL_C_AF		BIT(5)	/* Alarm-Interrupt Flag */
+#define RTC_CTRL_C_UF		BIT(4)	/* Update-Ended Interrupt Flag */
+#define RTC_CTRL_C_PAU_MASK	0x70	/* PF + AF + UF */
+
+
+/*
+ * Bit names in Control Register D.
+ *
+ * BIT(0) through BIT(6) are unused, always return 0, and cannot
+ * be written to.
+ */
+#define RTC_CTRL_D_VRT		BIT(7)	/* Valid RAM and Time */
+
+
+/*
+ * Bit names in Extended Control Register 4A.
+ *
+ * On the DS1685/DS1687/DS1689/DS1693, BIT(4) and BIT(5) are reserved for
+ * future use.  They can be read from and written to, but have no effect
+ * on the RTC's operation.
+ *
+ * On the DS17x85/DS17x87, BIT(5) is Burst-Mode Enable (BME), and allows
+ * access to the extended NV-SRAM by automatically incrementing the address
+ * register when they are read from or written to.
+ */
+#define RTC_CTRL_4A_VRT2	BIT(7)	/* Auxillary Battery Status */
+#define RTC_CTRL_4A_INCR	BIT(6)	/* Increment-in-Progress Status */
+#define RTC_CTRL_4A_PAB		BIT(3)	/* Power-Active Bar Control */
+#define RTC_CTRL_4A_RF		BIT(2)	/* RAM-Clear Flag */
+#define RTC_CTRL_4A_WF		BIT(1)	/* Wake-Up Alarm Flag */
+#define RTC_CTRL_4A_KF		BIT(0)	/* Kickstart Flag */
+#if !defined(CONFIG_RTC_DRV_DS1685) && !defined(CONFIG_RTC_DRV_DS1689)
+#define RTC_CTRL_4A_BME		BIT(5)	/* Burst-Mode Enable */
+#endif
+#define RTC_CTRL_4A_RWK_MASK	0x07	/* RF + WF + KF */
+
+
+/*
+ * Bit names in Extended Control Register 4B.
+ */
+#define RTC_CTRL_4B_ABE		BIT(7)	/* Auxillary Battery Enable */
+#define RTC_CTRL_4B_E32K	BIT(6)	/* Enable 32.768Hz on SQW Pin */
+#define RTC_CTRL_4B_CS		BIT(5)	/* Crystal Select */
+#define RTC_CTRL_4B_RCE		BIT(4)	/* RAM Clear-Enable */
+#define RTC_CTRL_4B_PRS		BIT(3)	/* PAB Reset-Select */
+#define RTC_CTRL_4B_RIE		BIT(2)	/* RAM Clear-Interrupt Enable */
+#define RTC_CTRL_4B_WIE		BIT(1)	/* Wake-Up Alarm-Interrupt Enable */
+#define RTC_CTRL_4B_KSE		BIT(0)	/* Kickstart Interrupt-Enable */
+#define RTC_CTRL_4B_RWK_MASK	0x07	/* RIE + WIE + KSE */
+
+
+/*
+ * Misc register names in Bank 1.
+ *
+ * The DV0 bit in Control Register A must be set to 1 for these registers
+ * to become available, including Extended Control Registers 4A & 4B.
+ */
+#define RTC_BANK1_SSN_MODEL	0x40	/* Model Number */
+#define RTC_BANK1_SSN_BYTE_1	0x41	/* 1st Byte of Serial Number */
+#define RTC_BANK1_SSN_BYTE_2	0x42	/* 2nd Byte of Serial Number */
+#define RTC_BANK1_SSN_BYTE_3	0x43	/* 3rd Byte of Serial Number */
+#define RTC_BANK1_SSN_BYTE_4	0x44	/* 4th Byte of Serial Number */
+#define RTC_BANK1_SSN_BYTE_5	0x45	/* 5th Byte of Serial Number */
+#define RTC_BANK1_SSN_BYTE_6	0x46	/* 6th Byte of Serial Number */
+#define RTC_BANK1_SSN_CRC	0x47	/* Serial CRC Byte */
+#define RTC_BANK1_RAM_DATA_PORT	0x53	/* Extended RAM Data Port */
+
+
+/*
+ * Model-specific registers in Bank 1.
+ *
+ * The addresses below differ depending on the model of the RTC chip
+ * selected in the kernel configuration.  Not all of these features are
+ * supported in the main driver at present.
+ *
+ * DS1685/DS1687   - Extended NV-SRAM address (LSB only).
+ * DS1689/DS1693   - Vcc, Vbat, Pwr Cycle Counters & Customer-specific S/N.
+ * DS17x85/DS17x87 - Extended NV-SRAM addresses (MSB & LSB) & Write counter.
+ */
+#if defined(CONFIG_RTC_DRV_DS1685)
+#define RTC_BANK1_RAM_ADDR	0x50	/* NV-SRAM Addr */
+#elif defined(CONFIG_RTC_DRV_DS1689)
+#define RTC_BANK1_VCC_CTR_LSB	0x54	/* Vcc Counter Addr (LSB) */
+#define RTC_BANK1_VCC_CTR_MSB	0x57	/* Vcc Counter Addr (MSB) */
+#define RTC_BANK1_VBAT_CTR_LSB	0x58	/* Vbat Counter Addr (LSB) */
+#define RTC_BANK1_VBAT_CTR_MSB	0x5b	/* Vbat Counter Addr (MSB) */
+#define RTC_BANK1_PWR_CTR_LSB	0x5c	/* Pwr Cycle Counter Addr (LSB) */
+#define RTC_BANK1_PWR_CTR_MSB	0x5d	/* Pwr Cycle Counter Addr (MSB) */
+#define RTC_BANK1_UNIQ_SN	0x60	/* Customer-specific S/N */
+#else /* DS17x85/DS17x87 */
+#define RTC_BANK1_RAM_ADDR_LSB	0x50	/* NV-SRAM Addr (LSB) */
+#define RTC_BANK1_RAM_ADDR_MSB	0x51	/* NV-SRAM Addr (MSB) */
+#define RTC_BANK1_WRITE_CTR	0x5e	/* RTC Write Counter */
+#endif
+
+
+/*
+ * Model numbers.
+ *
+ * The DS1688/DS1691 and DS1689/DS1693 chips share the same model number
+ * and the manual doesn't indicate any major differences.  As such, they
+ * are regarded as the same chip in this driver.
+ */
+#define RTC_MODEL_DS1685	0x71	/* DS1685/DS1687 */
+#define RTC_MODEL_DS17285	0x72	/* DS17285/DS17287 */
+#define RTC_MODEL_DS1689	0x73	/* DS1688/DS1691/DS1689/DS1693 */
+#define RTC_MODEL_DS17485	0x74	/* DS17485/DS17487 */
+#define RTC_MODEL_DS17885	0x78	/* DS17885/DS17887 */
+
+
+/*
+ * Periodic Interrupt Rates / Square-Wave Output Frequency
+ *
+ * Periodic rates are selected by setting the RS3-RS0 bits in Control
+ * Register A and enabled via either the E32K bit in Extended Control
+ * Register 4B or the SQWE bit in Control Register B.
+ *
+ * E32K overrides the settings of RS3-RS0 and outputs a frequency of 32768Hz
+ * on the SQW pin of the RTC chip.  While there are 16 possible selections,
+ * the 1-of-16 decoder is only able to divide the base 32768Hz signal into
+ * 13 smaller frequencies.  The values 0x01 and 0x02 are not used and are
+ * synonymous with 0x08 and 0x09, respectively.
+ *
+ * When E32K is set to a logic 1, periodic interrupts are disabled and
+ * reading /dev/rtc will return -EINVAL.  This also applies if the periodic
+ * interrupt frequency is set to 0Hz.
+ */
+                      		    	/* E32K RS3 RS2 RS1 RS0 */
+#define RTC_SQW_8192HZ		0x03	/*  0    0   0   1   1  */
+#define RTC_SQW_4096HZ		0x04	/*  0    0   1   0   0  */
+#define RTC_SQW_2048HZ		0x05	/*  0    0   1   0   1  */
+#define RTC_SQW_1024HZ		0x06	/*  0    0   1   1   0  */
+#define RTC_SQW_512HZ		0x07	/*  0    0   1   1   1  */
+#define RTC_SQW_256HZ		0x08	/*  0    1   0   0   0  */
+#define RTC_SQW_128HZ		0x09	/*  0    1   0   0   1  */
+#define RTC_SQW_64HZ		0x0a	/*  0    1   0   1   0  */
+#define RTC_SQW_32HZ		0x0b	/*  0    1   0   1   1  */
+#define RTC_SQW_16HZ		0x0c	/*  0    1   1   0   0  */
+#define RTC_SQW_8HZ		0x0d	/*  0    1   1   0   1  */
+#define RTC_SQW_4HZ		0x0e	/*  0    1   1   1   0  */
+#define RTC_SQW_2HZ		0x0f	/*  0    1   1   1   1  */
+#define RTC_SQW_0HZ		0x00	/*  0    0   0   0   0  */
+#define RTC_SQW_32768HZ		32768	/*  1    -   -   -   -  */
+#define RTC_MAX_USER_FREQ	8192
+
+
+/*
+ * NVRAM data & addresses:
+ *   - 50 bytes of NVRAM are available just past the clock registers.
+ *   - 64 additional bytes are available in Bank0.
+ *
+ * Extended, battery-backed NV-SRAM:
+ *   - DS1685/DS1687    - 128 bytes.
+ *   - DS1689/DS1693    - 0 bytes.
+ *   - DS17285/DS17287  - 2048 bytes.
+ *   - DS17485/DS17487  - 4096 bytes.
+ *   - DS17885/DS17887  - 8192 bytes.
+ */
+#define NVRAM_TIME_BASE		0x0e	/* NVRAM Addr in Time regs */
+#define NVRAM_BANK0_BASE	0x40	/* NVRAM Addr in Bank0 regs */
+#define NVRAM_SZ_TIME		50
+#define NVRAM_SZ_BANK0		64
+#if defined(CONFIG_RTC_DRV_DS1685)
+#  define NVRAM_SZ_EXTND	128
+#elif defined(CONFIG_RTC_DRV_DS1689)
+#  define NVRAM_SZ_EXTND	0
+#elif defined(CONFIG_RTC_DRV_DS17285)
+#  define NVRAM_SZ_EXTND	2048
+#elif defined(CONFIG_RTC_DRV_DS17485)
+#  define NVRAM_SZ_EXTND	4096
+#elif defined(CONFIG_RTC_DRV_DS17885)
+#  define NVRAM_SZ_EXTND	8192
+#endif
+#define NVRAM_TOTAL_SZ_BANK0	(NVRAM_SZ_TIME + NVRAM_SZ_BANK0)
+#define NVRAM_TOTAL_SZ		(NVRAM_TOTAL_SZ_BANK0 + NVRAM_SZ_EXTND)
+
+
+/*
+ * Function Prototypes.
+ */
+extern void ATTRIB_NORET
+  ds1685_rtc_poweroff(struct platform_device *pdev);
+
+#endif /* _LINUX_RTC_DS1685_H_ */
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQIcBAEBAgAGBQJNnbjyAAoJENsjoH7SXZXj7jgP/3PIt0+GnVRcEv4jUyYhCRLR
/huNyWEWUy3F82tnZ7H6Ti5gx6soUYaIAgWzN/TB4WEDiiH0Zx7TtL9GvRkb5kPJ
Eo/WFBh4Y64JCQOv/LDO2AcxJeD4u+BuZmFn0k6fZLQK0KCIxe7BvouQgNO028AR
QnSE5V9f0trJtRr8h+Zg7/IRvH+X9wVezYTXzZZKeMBQMmwb4nB5NcpJi0gmJwlh
hemRQ/Pkc0snExBtPN03FSFbte3fSUzXVt035/4GCEryLllPp9Cv52hAoqJcd8Rx
085OSN2R2B4hX9RvGxjQEeskjieKNzNsnCvSXejeGLLkcAo3lbkYpHGvvRJb0UdA
y3ZYJCWrWjrfQrlF+sxhIIUwpy01tyj9748uofh4wffdRImgad7q6K5x3IXKmRCK
5SUgrJFcFW28Cf5JYlRyEtwR+YiIR4DQYNmPlQisShVrMmmeRedj+pCrprR/YAwu
H/fUHE9jaydTnjR3WLVQlwoLuP0MpwfYQtMsZWB2O15aZSJbaK3+/2kH7lVojFaA
s4ZepDkdwDz0lBsBZcn4s+PYkkQEvvUmINaa3uqLScn37SQVutWrvYa3jK6wrDyO
+PpAFQ0ZcovQaZs1LC9QeqOjuUtj/mrqxvROe/T1UVu+wqATGEVcZACHJVD2A4EK
dOsqIgAuLAU7trIuLlKF
=tge7
-----END PGP SIGNATURE-----
