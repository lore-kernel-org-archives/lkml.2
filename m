Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0IAB5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:57:15 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19753 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843Ab0IAB5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:57:12 -0400
Message-ID: <008001cb4978$fcf35620$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "ML linux-kernel" <linux-kernel@vger.kernel.org>,
        <margie.foster@intel.com>, <alan@linux.intel.com>,
        <arjan@linux.intel.com>, "Andrew" <andrew.chih.howe.khor@intel.com>,
        "Wang Qi" <qi.wang@intel.com>, "Wang Yong Y" <yong.y.wang@intel.com>,
        <meego-dev@meego.com>
References: <4C5B9094.5090205@dsn.okisemi.com> <20100806142418.GA4921@suse.de>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
Date: Wed, 1 Sep 2010 10:57:08 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg

Sorry for late response.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Greg KH" <gregkh@suse.de>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: <meego-dev@meego.com>; "Wang Yong Y" <yong.y.wang@intel.com>; "Wang Qi" <qi.wang@intel.com>; "Andrew"
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <alan@linux.intel.com>; <margie.foster@intel.com>
Sent: Friday, August 06, 2010 11:24 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35


> On Fri, Aug 06, 2010 at 01:33:24PM +0900, Masayuki Ohtak wrote:
> > I2C driver of Topcliff PCH
> >
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus.
> > Topcliff PCH has I2C I/F. Using this I/F, it is able to access system
> > devices connected to I2C.
> >
> > Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>
>
> Why not run this by the i2c maintainer and developers as well?

I will add i2c maintainer and developers next submission.

>
> You do know about the scripts/get_maintainer.pl program to tell you who
> to copy when sending a patch, right?  Please use that.
>
> >
> > ---
> >  drivers/i2c/busses/Kconfig   |    8 +
> >  drivers/i2c/busses/Makefile  |    3 +
> >  drivers/i2c/busses/i2c-pch.c |  910 ++++++++++++++++++++++++++++++++++++++++++
> >  drivers/i2c/busses/i2c-pch.h |  147 +++++++
> >  drivers/i2c/i2c-dev.c        |   21 +
> >  5 files changed, 1089 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/i2c/busses/i2c-pch.c
> >  create mode 100644 drivers/i2c/busses/i2c-pch.h
> >
> > diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> > index 5f318ce..98e7201 100644
> > --- a/drivers/i2c/busses/Kconfig
> > +++ b/drivers/i2c/busses/Kconfig
> > @@ -7,6 +7,14 @@ menu "I2C Hardware Bus support"
> >  comment "PC SMBus host controller drivers"
> >  depends on PCI
> >
> > +config PCH_I2C
> > + tristate "PCH I2C"
> > + depends on PCI
> > + help
> > +   This driver is for PCH I2C of Topcliff which is an IOH for x86
> > +   embedded processor.
> > +   This driver can access PCH I2C bus device.
> > +
> >  config I2C_ALI1535
> >  tristate "ALI 1535"
> >  depends on PCI
> > diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> > index 302c551..3e6b8d6 100644
> > --- a/drivers/i2c/busses/Makefile
> > +++ b/drivers/i2c/busses/Makefile
> > @@ -75,3 +75,6 @@ obj-$(CONFIG_SCx200_I2C) += scx200_i2c.o
> >  ifeq ($(CONFIG_I2C_DEBUG_BUS),y)
> >  EXTRA_CFLAGS += -DDEBUG
> >  endif
> > +
> > +obj-$(CONFIG_PCH_I2C) += pch_i2c.o
> > +pch_i2c-objs := i2c-pch.o
>
> Why not just name your file i2c-pci.c and then you don't need this
> two-step Makefile mess?
>
> > diff --git a/drivers/i2c/busses/i2c-pch.c b/drivers/i2c/busses/i2c-pch.c
> > new file mode 100644
> > index 0000000..7939781
> > --- /dev/null
> > +++ b/drivers/i2c/busses/i2c-pch.c
> > @@ -0,0 +1,910 @@
> > +/*
> > + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/delay.h>
> > +#include <linux/init.h>
> > +#include <linux/errno.h>
> > +#include <linux/i2c.h>
> > +#include <linux/fs.h>
> > +#include <linux/io.h>
> > +#include <linux/types.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/jiffies.h>
> > +#include <linux/pci.h>
> > +#include <linux/mutex.h>
> > +#include <linux/ktime.h>
> > +
> > +#include "i2c-pch.h"
>
> Why do you need a .h file for this driver?

I will delete.

>
> <snip>
>
> > diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
> > index f4110aa..53e13de 100644
> > --- a/drivers/i2c/i2c-dev.c
> > +++ b/drivers/i2c/i2c-dev.c
> > @@ -36,6 +36,7 @@
> >  #include <linux/i2c-dev.h>
> >  #include <linux/jiffies.h>
> >  #include <linux/uaccess.h>
> > +#include "busses/i2c-pch.h"
>
> Note how no other i2c driver needs to be included here...

I will delete.

>
> >  static struct i2c_driver i2cdev_driver;
> >
> > @@ -372,6 +373,12 @@ static long i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >  struct i2c_client *client = file->private_data;
> >  unsigned long funcs;
> >
> > + unsigned long pch_mode;
> > + int ret;
> > +
> > + struct i2c_msg msg;
> > + unsigned char msgbuf[1];
> > +
> >  dev_dbg(&client->adapter->dev, "ioctl, cmd=0x%02x, arg=0x%02lx\n",
> >  cmd, arg);
> >
> > @@ -427,6 +434,20 @@ static long i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >  */
> >  client->adapter->timeout = msecs_to_jiffies(arg * 10);
> >  break;
> > + case I2C_MODE_SEL:
> > + pch_mode = arg;
> > +
> > + if (pch_mode <= 4) {
> > + msgbuf[0] = pch_mode;
> > + msg.buf = msgbuf;
> > + msg.len = 1;
> > + msg.flags = 0;
> > + ret = i2c_transfer(client->adapter, &msg, 1);
> > + } else {
> > + printk(KERN_ERR "I2C mode sel:Invalid mode\n");
> > + ret = -EINVAL;
> > + }
> > + return ret;
>
> I really doubt you are allowed to add a new ioctl to the core i2c layer.
> You will have to run this by the i2c maintainer to get it accepted.
>

I will revert i2c core module.

I will submit modified patch soon.

Thanks, Ohtake(OKISemi)


