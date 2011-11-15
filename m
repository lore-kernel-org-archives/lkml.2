Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1KOGty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:49:54 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:14848 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711Ab1KOGtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:49:52 -0500
From: <oskar.andero@sonyericsson.com>
Date: Tue, 15 Nov 2011 07:50:43 +0100
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH v2] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111115065043.GC9307@caracas.corpusers.net>
References: <1321285158-7123-1-git-send-email-oskar.andero@sonyericsson.com>
 <CAM=Q2cvH4gb5+=+ijE_d_ejoMCPikqd4g4uSw9T-z2yqDZCN+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAM=Q2cvH4gb5+=+ijE_d_ejoMCPikqd4g4uSw9T-z2yqDZCN+Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shubhrajyoti,

Thanks for reviewing!

On 17:52 Mon 14 Nov     , Shubhrajyoti Datta wrote:
>    Hi Courtney,
>    Some minor comments
> 
>    On Mon, Nov 14, 2011 at 9:09 PM, <[1]oskar.andero@sonyericsson.com>
>    wrote:
> 
>      From: Courtney Cavin <[2]courtney.cavin@sonyericsson.com>
>      Signed-off-by: Courtney Cavin <[3]courtney.cavin@sonyericsson.com>
>      Signed-off-by: Oskar Andero <[4]oskar.andero@sonyericsson.com>
>      ---
>       drivers/input/misc/Kconfig         |   11 ++
>       drivers/input/misc/Makefile        |    1 +
>       drivers/input/misc/gp2ap002a00f.c  |  286
>      ++++++++++++++++++++++++++++++++++++
>       include/linux/input/gp2ap002a00f.h |   22 +++
>       4 files changed, 320 insertions(+), 0 deletions(-)
>       create mode 100644 drivers/input/misc/gp2ap002a00f.c
>       create mode 100644 include/linux/input/gp2ap002a00f.h
>      diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>      index 22d875f..dee96a0 100644
>      --- a/drivers/input/misc/Kconfig
>      +++ b/drivers/input/misc/Kconfig
>      @@ -544,4 +544,15 @@ config INPUT_XEN_KBDDEV_FRONTEND
>               To compile this driver as a module, choose M here: the
>               module will be called xen-kbdfront.
>      +config INPUT_GP2A
>      +       tristate "Sharp GP2AP002A00F I2C Proximity/Opto sensor
>      driver"
>      +       depends on I2C
>      +       default n
> 
>    you may want to drop it as default is anyways n.
> 
>      +       help
>      +         Say Y here if you have a Sharp GP2AP002A00F proximity/als
>      combo-chip
>      +         hooked to an I2C bus.
>      +
>      +         To compile this driver as a module, choose M here: the
>      +         module will be called gp2ap002a00f.
>      +
>       endif
>      diff --git a/drivers/input/misc/Makefile
>      b/drivers/input/misc/Makefile
>      index a244fc6..1681993 100644
>      --- a/drivers/input/misc/Makefile
>      +++ b/drivers/input/misc/Makefile
>      @@ -22,6 +22,7 @@ obj-$(CONFIG_INPUT_CMA3000)           +=
>      cma3000_d0x.o
>       obj-$(CONFIG_INPUT_CMA3000_I2C)                += cma3000_d0x_i2c.o
>       obj-$(CONFIG_INPUT_COBALT_BTNS)                += cobalt_btns.o
>       obj-$(CONFIG_INPUT_DM355EVM)           += dm355evm_keys.o
>      +obj-$(CONFIG_INPUT_GP2A)               += gp2ap002a00f.o
>       obj-$(CONFIG_HP_SDC_RTC)               += hp_sdc_rtc.o
>       obj-$(CONFIG_INPUT_IXP4XX_BEEPER)      += ixp4xx-beeper.o
>       obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)     += keyspan_remote.o
>      diff --git a/drivers/input/misc/gp2ap002a00f.c
>      b/drivers/input/misc/gp2ap002a00f.c
>      new file mode 100644
>      index 0000000..1c5ddf8
>      --- /dev/null
>      +++ b/drivers/input/misc/gp2ap002a00f.c
>      @@ -0,0 +1,286 @@
>      +/*
>      + * Copyright (C) 2009,2010 Sony Ericsson Mobile Communications Inc.
> 
>    May want to check the year.
> 
>      + *
>      + * Author: Courtney Cavin <[5]courtney.cavin@sonyericsson.com>
>      + * Prepared for up-stream by: Oskar Andero
>      <[6]oskar.andero@sonyericsson.com>
> 
>      + *
>      + * This program is free software; you can redistribute it and/or
>      modify
>      + * it under the terms of the GNU General Public License version 2,
>      as
>      + * published by the Free Software Foundation.
>      + */
>      +
>      +#include <linux/i2c.h>
>      +#include <linux/irq.h>
>      +#include <linux/slab.h>
>      +#include <linux/input.h>
>      +#include <linux/module.h>
>      +#include <linux/workqueue.h>
> 
>    Are all these header files needed?
> 
>      +#include <linux/interrupt.h>
>      +#include <linux/gpio.h>
>      +#include <linux/delay.h>
>      +#include <linux/input/gp2ap002a00f.h>
>      +
>      +struct gp2a_data {
>      +       struct input_dev *device;
>      +       const struct gp2a_platform_data *pdata;
>      +       struct i2c_client *i2c_client;
>      +};
>      +
>      +enum gp2a_addr {
>      +       GP2A_ADDR_PROX  = 0x0,
>      +       GP2A_ADDR_GAIN  = 0x1,
>      +       GP2A_ADDR_HYS   = 0x2,
>      +       GP2A_ADDR_CYCLE = 0x3,
>      +       GP2A_ADDR_OPMOD = 0x4,
>      +       GP2A_ADDR_CON   = 0x6
>      +};
>      +
>      +enum gp2a_controls {
>      +       GP2A_CTRL_SSD   = 0x01
> 
>    Not a comment really
>    Could you explain SSD?

SSD means Software shutdown according to the datasheet where 0 puts the
chip in shutdown and 1 in normal operation. I'll add a comment in the code.

-Oskar
