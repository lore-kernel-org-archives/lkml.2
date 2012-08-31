Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2HaLYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:24:07 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:11957 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2HaLXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:23:32 -0400
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <lm-sensors@lm-sensors.org>, <linux-input@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <linux-leds@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>, Donggeun Kim <dg77.kim@samsung.com>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        "Wim Van Sebroeck" <wim@iguana.be>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Anthony Olech <anthony.olech@diasemi.com>
References: <201208241445@sw-eng-lt-dc-vm2>
 <201208241450@sw-eng-lt-dc-vm2>
 <20120825183113.GE6520@opensource.wolfsonmicro.com>
In-Reply-To: <20120825183113.GE6520@opensource.wolfsonmicro.com>
Message-ID: <201208311220@sw-eng-lt-dc-vm2>
Date: Fri, 31 Aug 2012 12:20:00 +0100
Subject: Re: [PATCH 1/8] mfd: Add Dialog DA906x core driver.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Aug 24, 2012 at 02:50:00PM +0100, Krystian Garbaciak wrote:
> 
> > This is MFD module providing access to registers and interrupts of DA906x
> > series PMIC. It is used by other functional modules, registered as MFD cells.
> > Driver uses regmap with paging to access extended register list. Register map
> > is divided into two pages, where the second page is used during initialisation.
> 
> Your selection of people to CC here appears both large and random...

I've added any maintainer for my modules from maintainer list.

> > +inline unsigned int da906x_to_range_reg(u16 reg)
> > +{
> > +	return reg + DA906X_MAPPING_BASE;
> > +}
> 
> I've no real idea what this stuff is all about, it at least needs some
> comments somewhere.  The fact that you're just adding a constant offset
> to all registers is at best odd.

I will comment it precisely for next version:

+/* Adding virtual register range starting from address DA9063_MAPPING_BASE.
+   It will be used for registers requiring page switching, which in our case
+   are virtually all PMIC registers.
+   Registers from 0 to 255 are used only as a page window and are volatile,
+   except DA9063_REG_PAGE_CON register (page selector), which is cachable. */
+static const struct regmap_range_cfg da9063_range_cfg[] = {
+	{
+		.range_min = DA9063_MAPPING_BASE,
+		.range_max = DA9063_MAPPING_BASE +
+			     ARRAY_SIZE(da9063_reg_flg) - 1,
+		.selector_reg = DA9063_REG_PAGE_CON,
+		.selector_mask = 1 << DA9063_I2C_PAGE_SEL_SHIFT,
+		.selector_shift = DA9063_I2C_PAGE_SEL_SHIFT,
+		.window_start = 0,
+		.window_len = 256,
+	}
+};

.. and here:

+/* Access to any PMIC register is passed through virtual register range,
+   starting at DA9063_MAPPING_BASE. For those registers, paging is required. */
+inline unsigned int da9063_to_range_reg(u16 reg)
+{
+	return reg + DA9063_MAPPING_BASE;
+}

