Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2LOG3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:29:14 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39496 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2LOG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:29:12 -0500
Message-ID: <50CC18B3.5070800@gmail.com>
Date: Sat, 15 Dec 2012 10:29:07 +0400
From: Nikolay Epifanov <nik.epifanov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joonyoung Shim <dofmind@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: add MELFAS mms144 touchscreen driver
References: <50C9C368.4060202@gmail.com> <CAPLVkLtbz+mosPtgPJQtOpO+xmAxzrqYmJkLzDWdoc4dQYve5w@mail.gmail.com>
In-Reply-To: <CAPLVkLtbz+mosPtgPJQtOpO+xmAxzrqYmJkLzDWdoc4dQYve5w@mail.gmail.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.12.2012 05:46, Joonyoung Shim wrote:
> Hi,
> 
> 2012년 12월 13일 목요일에 Nikolay Epifanov님이 작성:
> 
>     This is an initial driver for MELFAS touchscreen chip mms144.
> 
>     Signed-off-by: Nikolay Epifanov <nik.epifanov@gmail.com>
>     ---
>     I don't know whether single driver could be used for both mms114 and
>     mms144.
>     Couldn't find datasheets for any of them.
> 
> 
> The touch data process logic of this driver is almost same with it of
> mms114 driver and offset of many registers is also same. I think you can
> merge this to mms114 driver.
> 
> Thanks.
> 
> 
>     There are two firmwares available under redistribution license from
>     AOSP tree:
>     for FPCB revisions 3.2 and 3.1. Not sure if those are Melfas original
>     or modified by Samsung. (Just for reference: they are
>     mms144_ts_rev3*.fw at
>     https://android.googlesource.com/device/samsung/tuna/+/214d003a47e7fe2962df667c5d65bce92a21a40e/
> 
>     mux_fw_flash(bool) from platform data switches pins between
>     I2C<->GPIO modes.
> 
>     Driver has been tested on Samsung Galaxy Nexus except suspend/resume.
> 
>     Applied on
>     git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
>     <http://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git>
>     branch next.
> 
>       drivers/input/touchscreen/Kconfig  |   14 +
>       drivers/input/touchscreen/Makefile |    1 +
>       drivers/input/touchscreen/mms144.c |  821
>     ++++++++++++++++++++++++++++++++++++
>       include/linux/i2c/mms144.h         |   34 ++
>       4 files changed, 870 insertions(+)
> 
>     diff --git a/drivers/input/touchscreen/Kconfig
>     b/drivers/input/touchscreen/Kconfig
>     index b93b598..78d9cd3 100644
>     --- a/drivers/input/touchscreen/Kconfig
>     +++ b/drivers/input/touchscreen/Kconfig
>     @@ -369,6 +369,20 @@ config TOUCHSCREEN_MMS114
>                To compile this driver as a module, choose M here: the
>                module will be called mms114.
> 
>     +config TOUCHSCREEN_MMS144
>     +       tristate "MELFAS MMS144 touchscreen"
>     +       depends on I2C
>     +       help
>     +         Say Y here if you have the MELFAS MMS144 touchscreen
>     controller
>     +         chip in your system.
>     +         Such kind of chip can be found in Samsung Galaxy Nexus
>     +         touchscreens.
>     +
>     +         If unsure, say N.
>     +
>     +         To compile this driver as a module, choose M here: the
>     +         module will be called mms144.
>     +
>       config TOUCHSCREEN_MTOUCH
>              tristate "MicroTouch serial touchscreens"
>              select SERIO
>     diff --git a/drivers/input/touchscreen/Makefile
>     b/drivers/input/touchscreen/Makefile
>     index 5f949c0..cfbe87c 100644
>     --- a/drivers/input/touchscreen/Makefile
>     +++ b/drivers/input/touchscreen/Makefile
>     @@ -39,6 +39,7 @@ obj-$(CONFIG_TOUCHSCREEN_MC13783)     += mc13783_ts.o
>       obj-$(CONFIG_TOUCHSCREEN_MCS5000)      += mcs5000_ts.o
>       obj-$(CONFIG_TOUCHSCREEN_MIGOR)                += migor_ts.o
>       obj-$(CONFIG_TOUCHSCREEN_MMS114)       += mms114.o
>     +obj-$(CONFIG_TOUCHSCREEN_MMS144)       += mms144.o
>       obj-$(CONFIG_TOUCHSCREEN_MTOUCH)       += mtouch.o
>       obj-$(CONFIG_TOUCHSCREEN_MK712)                += mk712.o
>       obj-$(CONFIG_TOUCHSCREEN_HP600)                += hp680_ts_input.o
>     diff --git a/drivers/input/touchscreen/mms144.c
>     b/drivers/input/touchscreen/mms144.c
>     new file mode 100644
>     index 0000000..3bb84d0
>     --- /dev/null
>     +++ b/drivers/input/touchscreen/mms144.c
>     @@ -0,0 +1,821 @@
>     +/*
>     + * mms144.c - Touchscreen driver for Melfas MMS144 touch controllers
>     + *
>     + * Copyright (C) 2011 Google Inc.
>     + * Author: Dima Zavin <dima@android.com>
>     + *         Simon Wilson <simonwilson@google.com>
>     + * Copyright (C) 2012 Nikolay Epifanov <nik.epifanov@gmail.com>
>     + *
>     + * ISP reflashing code based on original code from Melfas.
>     + *
>     + * This program is free software; you can redistribute  it and/or
>     modify it
>     + * under  the terms of  the GNU General  Public License as
>     published by the
>     + * Free Software Foundation;  either version 2 of the  License, or
>     (at your
>     + * option) any later version.
>     + *
>     + */
>     +
>     +#include <linux/completion.h>
>     +#include <linux/delay.h>
>     +#include <linux/firmware.h>
>     +#include <linux/gpio.h>
>     +#include <linux/i2c.h>
>     +#include <linux/i2c/mms144.h>
>     +#include <linux/init.h>
>     +#include <linux/input.h>
>     +#include <linux/input/mt.h>
>     +#include <linux/interrupt.h>
>     +#include <linux/irq.h>
>     +#include <linux/module.h>
>     +#include <linux/mutex.h>
>     +#include <linux/slab.h>
>     +#include <linux/unaligned/le_struct.h>
>     +
>     +#define MAX_FINGERS            10
>     +#define MAX_WIDTH              30
>     +#define MAX_PRESSURE           255
>     +#define FINGER_EVENT_SZ                6
>     +
>     +/* Registers */
>     +#define MMS_MODE_CONTROL       0x01
>     +#define MMS_XYRES_HI           0x02
>     +#define MMS_XRES_LO            0x03
>     +#define MMS_YRES_LO            0x04
>     +
>     +#define MMS_INPUT_EVENT_PKT_SZ 0x0F
>     +#define MMS_INPUT_EVENT0       0x10
>     +
>     +#define MMS_TSP_REVISION       0xF0
>     +#define MMS_HW_REVISION                0xF1
>     +#define MMS_COMPAT_GROUP       0xF2
>     +#define MMS_FW_VERSION         0xF3
> 
> 
> Above registers are same with them of mms114 driver.

Hi,

thanks, I'll give it a shot.

