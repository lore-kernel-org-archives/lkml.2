Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab1GKVc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:32:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53257 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab1GKVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:32:25 -0400
Date: Mon, 11 Jul 2011 23:32:24 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/11] watchdog: WatchDog Timer Driver Core - Add basic
 framework
Message-ID: <20110711213224.GC5811@pengutronix.de>
References: <20110711135056.GT29245@infomag.iguana.be>
 <1310392522-9949-1-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


I put some "Overdocumented" in here. Maybe our mileage just varies :)

On Mon, Jul 11, 2011 at 04:19:48PM +0200, Wim Van Sebroeck wrote:
> The WatchDog Timer Driver Core is a framework
> that contains the common code for all watchdog-driver's.
> It also introduces a watchdog device structure and the
> operations that go with it.
>=20
> This is the introduction of this framework. This part
> supports the minimal watchdog userspace API (or with
> other words: the functionality to use /dev/watchdog's
> open, release and write functionality as defined in
> the simplest watchdog API). Extra functionality will
> follow in the next set of patches.
>=20
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> ---
>  Documentation/watchdog/watchdog-kernel-api.txt |  103 ++++++++++
>  drivers/watchdog/Kconfig                       |   11 +
>  drivers/watchdog/Makefile                      |    4 +
>  drivers/watchdog/watchdog_core.c               |  108 ++++++++++
>  drivers/watchdog/watchdog_dev.c                |  261 ++++++++++++++++++=
++++++
>  drivers/watchdog/watchdog_dev.h                |   33 +++
>  include/linux/watchdog.h                       |   27 +++
>  7 files changed, 547 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/watchdog/watchdog-kernel-api.txt
>  create mode 100644 drivers/watchdog/watchdog_core.c
>  create mode 100644 drivers/watchdog/watchdog_dev.c
>  create mode 100644 drivers/watchdog/watchdog_dev.h
>=20
> diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentati=
on/watchdog/watchdog-kernel-api.txt
> new file mode 100644
> index 0000000..03c1066
> --- /dev/null
> +++ b/Documentation/watchdog/watchdog-kernel-api.txt
> @@ -0,0 +1,103 @@
> +The Linux WatchDog Timer Driver Core kernel API.
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Last reviewed: 09-Jul-2011
> +
> +Wim Van Sebroeck <wim@iguana.be>
> +
> +Introduction
> +------------
> +This document does not describe what a WatchDog Timer (WDT) Driver or De=
vice is.
> +It also does not describe the API which can be used by user space to com=
municate
> +with a WatchDog Timer. If you want to know this then please read the fol=
lowing
> +file: Documentation/watchdog/watchdog-api.txt .
> +
> +So what does this document describe? It describes the API that can be us=
ed by
> +WatchDog Timer Drivers that want to use the WatchDog Timer Driver Core
> +Framework. This framework provides all interfacing towards user space so=
 that
> +the same code does not have to be reproduced each time. This also means =
that
> +a watchdog timer driver then only needs to provide the different routines
> +(operations) that control the watchdog timer (WDT).
> +
> +The API
> +-------
> +Each watchdog timer driver that wants to use the WatchDog Timer Driver C=
ore
> +must #include <linux/watchdog.h> (you would have to do this anyway when
> +writing a watchdog device driver). This include file contains following
> +register/unregister routines:
> +
> +extern int watchdog_register_device(struct watchdog_device *);
> +extern void watchdog_unregister_device(struct watchdog_device *);
> +
> +The watchdog_register_device routine registers a watchdog timer device.
> +The parameter of this routine is a pointer to a watchdog_device structur=
e.
> +This routine returns zero on success and a negative errno code for failu=
re.
> +
> +The watchdog_unregister_device routine deregisters a registered watchdog=
 timer
> +device. The parameter of this routine is the pointer to the registered
> +watchdog_device structure.
> +
> +The watchdog device structure looks like this:
> +
> +struct watchdog_device {
> +	const struct watchdog_info *info;
> +	const struct watchdog_ops *ops;
> +	void *priv;
> +	unsigned long status;
> +};
> +
> +It contains following fields:
> +* info: a pointer to a watchdog_info structure. This structure gives some
> +  additional information about the watchdog timer itself. (Like it's uni=
que name)
> +* ops: a pointer to the list of watchdog operations that the watchdog su=
pports.
> +* priv: a pointer to the private data of a watchdog device
> +* status: this field contains a number of status bits that give extra
> +  information about the status of the device (Like: is the device opened=
 via
> +  the /dev/watchdog interface or not, ...)
> +
> +The list of watchdog operations is defined as:
> +
> +struct watchdog_ops {
> +	struct module *owner;
> +	/* mandatory operations */
> +	int (*start)(struct watchdog_device *);
> +	int (*stop)(struct watchdog_device *);
> +	/* optional operations */
> +	int (*ping)(struct watchdog_device *);
> +};
> +
> +It is important that you first define the module owner of the watchdog t=
imer
> +driver's operations. This module owner will be used to lock the module w=
hen
> +the watchdog is active. (This to avoid a system crash when you unload the
> +module and /dev/watchdog is still open).
> +Some operations are mandatory and some are optional. The mandatory opera=
tions
> +are:
> +* start: this is a pointer to the routine that starts the watchdog timer
> +  device.
> +  The routine needs a pointer to the watchdog timer device structure as a
> +  parameter. It returns zero on success or a negative errno code for fai=
lure.
> +* stop: with this routine the watchdog timer device is being stopped.
> +  The routine needs a pointer to the watchdog timer device structure as a
> +  parameter. It returns zero on success or a negative errno code for fai=
lure.
> +  Some watchdog timer hardware can only be started and not be stopped. T=
he
> +  driver supporting this hardware needs to make sure that a start and st=
op
> +  routine is being provided. This can be done by using a timer in the dr=
iver
> +  that regularly sends a keepalive ping to the watchdog timer hardware.
> +
> +Not all watchdog timer hardware supports the same functionality. That's =
why
> +all other routines/operations are optional. They only need to be provide=
d if
> +they are supported. These optional routines/operations are:
> +* ping: this is the routine that sends a keepalive ping to the watchdog =
timer
> +  hardware.
> +  The routine needs a pointer to the watchdog timer device structure as a
> +  parameter. It returns zero on success or a negative errno code for fai=
lure.
> +  Most hardware that does not support this as a separate function uses t=
he
> +  start function to restart the watchdog timer hardware. And that's also=
 what
> +  the watchdog timer driver core does: to send a keepalive ping to the w=
atchdog
> +  timer hardware it will either use the ping operation (when available) =
or the
> +  start operation (when the ping operation is not available).
> +
> +The status bits should (preferably) be set with the set_bit and clear_bi=
t alike
> +bit-operations. The status bits that are defined are:
> +* WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
> +  was opened via /dev/watchdog.
> +  (This bit should only be used by the WatchDog Timer Driver Core).
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 372bc64..edb0f1b 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -28,6 +28,17 @@ menuconfig WATCHDOG
> =20
>  if WATCHDOG
> =20
> +config WATCHDOG_CORE
> +	tristate "WatchDog Timer Driver Core"

What about the idea of making this bool and let it always be compiled as so=
on
as WATCHDOG is selected?

> +	---help---
> +	  Say Y here if you want to use the new watchdog timer driver core.
> +	  This driver provides a framework for all watchdog timer drivers
> +	  and gives them the /dev/watchdog interface (and later also the
> +	  sysfs interface).
> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called watchdog.
> +
>  config WATCHDOG_NOWAYOUT
>  	bool "Disable watchdog shutdown on close"
>  	help
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index b2ddff7..7b26484 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -2,6 +2,10 @@
>  # Makefile for the WatchDog device drivers.
>  #
> =20
> +# The WatchDog Timer Driver Core.
> +watchdog-objs	+=3D watchdog_core.o watchdog_dev.o
> +obj-$(CONFIG_WATCHDOG_CORE)	+=3D watchdog.o
> +
>  # Only one watchdog can succeed. We probe the ISA/PCI/USB based
>  # watchdog-cards first, then the architecture specific watchdog
>  # drivers and then the architecture independent "softdog" driver.
> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog=
_core.c
> new file mode 100644
> index 0000000..79684ad
> --- /dev/null
> +++ b/drivers/watchdog/watchdog_core.c
> @@ -0,0 +1,108 @@
> +/*
> + *	watchdog_core.c
> + *
> + *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
> + *						All Rights Reserved.
> + *
> + *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
> + *
> + *	This source code is part of the generic code that can be used
> + *	by all the watchdog timer drivers.
> + *
> + *	Based on source code of the following authors:
> + *	  Matt Domsch <Matt_Domsch@dell.com>,
> + *	  Rob Radez <rob@osinvestor.com>,
> + *	  Rusty Lynch <rusty@linux.co.intel.com>
> + *	  Satyam Sharma <satyam@infradead.org>
> + *	  Randy Dunlap <randy.dunlap@oracle.com>
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; either version
> + *	2 of the License, or (at your option) any later version.
> + *
> + *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
> + *	admit liability nor provide warranty for any of this software.
> + *	This material is provided "AS-IS" and at no charge.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +/*
> + *	Include files
> + */
> +#include <linux/module.h>	/* For EXPORT_SYMBOL/module stuff/... */
> +#include <linux/types.h>	/* For standard types */
> +#include <linux/errno.h>	/* For the -ENODEV/... values */
> +#include <linux/kernel.h>	/* For printk/panic/... */
> +#include <linux/watchdog.h>	/* For watchdog specific items */
> +#include <linux/init.h>		/* For __init/__exit/... */
> +
> +#include "watchdog_dev.h"	/* For watchdog_dev_register/... */
> +
> +/**
> + *	watchdog_register_device	-	register a watchdog device
> + *	@wdd: watchdog device
> + *
> + *	Register a watchdog device with the kernel so that the
> + *	watchdog timer can be accessed from userspace.
> + *
> + *	A zero is returned on success and a negative errno code for
> + *	failure.
> + */
> +int watchdog_register_device(struct watchdog_device *wdd)
> +{
> +	int ret;
> +
> +	/* Make sure we have a valid watchdog_device structure */
> +	if (wdd =3D=3D NULL || wdd->info =3D=3D NULL || wdd->ops =3D=3D NULL)
> +		return -EINVAL;
> +
> +	/* Make sure that the mandatory operations are supported */
> +	if (wdd->ops->start =3D=3D NULL || wdd->ops->stop =3D=3D NULL)
> +		return -EINVAL;

Check also for wdd->ops->owner? Should we mark it as mandatory?

> +
> +	/*
> +	 * Note: now that all watchdog_device data has been verified, we
> +	 * will not check this anymore in other functions. If data gets
> +	 * corrupted in a later stage then we expect a kernel panic!
> +	 */
> +
> +	/* We only support 1 watchdog device via the /dev/watchdog interface */
> +	ret =3D watchdog_dev_register(wdd);
> +	if (ret) {
> +		pr_err("error registering /dev/watchdog (err=3D%d).\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(watchdog_register_device);
> +
> +/**
> + *	watchdog_unregister_device	-	unregister a watchdog device
> + *	@wdd: watchdog device to unregister
> + *
> + *	Unregister a watchdog device that was previously successfully
> + *	registered with watchdog_register_device().
> + */
> +void watchdog_unregister_device(struct watchdog_device *wdd)
> +{
> +	int ret;
> +
> +	/* Make sure we have a valid watchdog_device structure */

Overdocumented?

> +	if (wdd =3D=3D NULL)
> +		return;
> +
> +	/* remove the /dev/watchdog interface */

Overdocumented?

> +	ret =3D watchdog_dev_unregister(wdd);
> +	if (ret)
> +		pr_err("error unregistering /dev/watchdog (err=3D%d).\n", ret);
> +}
> +EXPORT_SYMBOL_GPL(watchdog_unregister_device);
> +
> +MODULE_AUTHOR("Alan Cox <alan@lxorguk.ukuu.org.uk>");
> +MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
> +MODULE_DESCRIPTION("WatchDog Timer Driver Core");
> +MODULE_LICENSE("GPL");
> +MODULE_SUPPORTED_DEVICE("watchdog");

That one should go? There isn't even a init_function here, so nothing will
happen when the module gets loaded. (and if we pickup the idea of this being
always compiled when WATCHDOG is selected, it won't even be a module).

> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_=
dev.c
> new file mode 100644
> index 0000000..c47154c
> --- /dev/null
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -0,0 +1,261 @@
> +/*
> + *	watchdog_dev.c
> + *
> + *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
> + *						All Rights Reserved.
> + *
> + *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
> + *
> + *
> + *	This source code is part of the generic code that can be used
> + *	by all the watchdog timer drivers.
> + *
> + *	This part of the generic code takes care of the following
> + *	misc device: /dev/watchdog.
> + *
> + *	Based on source code of the following authors:
> + *	  Matt Domsch <Matt_Domsch@dell.com>,
> + *	  Rob Radez <rob@osinvestor.com>,
> + *	  Rusty Lynch <rusty@linux.co.intel.com>
> + *	  Satyam Sharma <satyam@infradead.org>
> + *	  Randy Dunlap <randy.dunlap@oracle.com>
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; either version
> + *	2 of the License, or (at your option) any later version.
> + *
> + *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
> + *	admit liability nor provide warranty for any of this software.
> + *	This material is provided "AS-IS" and at no charge.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +/*
> + *	Include files
> + */

Overdocumented?

> +#include <linux/module.h>	/* For module stuff/... */
> +#include <linux/types.h>	/* For standard types (like size_t) */
> +#include <linux/errno.h>	/* For the -ENODEV/... values */
> +#include <linux/kernel.h>	/* For printk/panic/... */
> +#include <linux/fs.h>		/* For file operations */
> +#include <linux/watchdog.h>	/* For watchdog specific items */
> +#include <linux/miscdevice.h>	/* For handling misc devices */
> +#include <linux/init.h>		/* For __init/__exit/... */
> +#include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
> +
> +/*
> + *	Locally used variables
> + */

Overdocumented?

> +
> +/* make sure we only register one /dev/watchdog device */
> +static unsigned long watchdog_dev_busy;
> +/* the watchdog device behind /dev/watchdog */
> +static struct watchdog_device *wdd;
> +
> +/*
> + *	/dev/watchdog operations
> + */
> +
> +/*
> + *	watchdog_ping: ping the watchdog.
> + *	@wddev: the watchdog device to ping
> + *
> + *	If the watchdog has no own ping operation then it needs to be
> + *	restarted via the start operation. This wrapper function does
> + *	exactly that.
> + */
> +
> +static int watchdog_ping(struct watchdog_device *wddev)
> +{
> +	if (wddev->ops->ping)
> +		return wddev->ops->ping(wddev);  /* ping the watchdog */
> +	else
> +		return wddev->ops->start(wddev); /* restart the watchdog */
> +}
> +
> +/*
> + *	watchdog_write: writes to the watchdog.
> + *	@file: file from VFS
> + *	@data: user address of data
> + *	@len: length of data
> + *	@ppos: pointer to the file offset
> + *
> + *	A write to a watchdog device is defined as a keepalive ping.
> + */
> +
> +static ssize_t watchdog_write(struct file *file, const char __user *data,
> +						size_t len, loff_t *ppos)
> +{
> +	size_t i;
> +	char c;
> +
> +	if (len =3D=3D 0)
> +		return 0;
> +
> +	for (i =3D 0; i !=3D len; i++) {
> +		if (get_user(c, data + i))
> +			return -EFAULT;
> +	}
> +
> +	/* someone wrote to us, so we send the watchdog a keepalive ping */
> +	watchdog_ping(wdd);
> +
> +	return len;
> +}
> +
> +/*
> + *	watchdog_open: open the /dev/watchdog device.
> + *	@inode: inode of device
> + *	@file: file handle to device
> + *
> + *	When the /dev/watchdog device gets opened, we start the watchdog.
> + *	Watch out: the /dev/watchdog device is single open, so we make sure
> + *	it can only be opened once.
> + */
> +
> +static int watchdog_open(struct inode *inode, struct file *file)
> +{
> +	int err =3D -EBUSY;
> +
> +	/* the watchdog is single open! */
> +	if (test_and_set_bit(WDOG_DEV_OPEN, &wdd->status))
> +		return -EBUSY;
> +
> +	/*
> +	 * If the /dev/watchdog device is open, we don't want the module
> +	 * to be unloaded.
> +	 */
> +	if (!try_module_get(wdd->ops->owner))
> +		goto out;
> +
> +	/* start the watchdog */

Overdocumented?

> +	err =3D wdd->ops->start(wdd);
> +	if (err < 0)
> +		goto out_mod;
> +
> +	/* dev/watchdog is a virtual (and thus non-seekable) filesystem */
> +	return nonseekable_open(inode, file);
> +
> +out_mod:
> +	module_put(wdd->ops->owner);
> +out:
> +	clear_bit(WDOG_DEV_OPEN, &wdd->status);
> +	return err;
> +}
> +
> +/*
> + *      watchdog_release: release the /dev/watchdog device.
> + *      @inode: inode of device
> + *      @file: file handle to device
> + *
> + *	This is the code for when /dev/watchdog gets closed.
> + */
> +
> +static int watchdog_release(struct inode *inode, struct file *file)
> +{
> +	int err;
> +
> +	/* stop the watchdog */

Overdocumented?

> +	err =3D wdd->ops->stop(wdd);
> +	if (err !=3D 0) {
> +		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
> +		watchdog_ping(wdd);
> +	}
> +
> +	/* Allow the owner module to be unloaded again */
> +	module_put(wdd->ops->owner);
> +
> +	/* make sure that /dev/watchdog can be re-opened */
> +	clear_bit(WDOG_DEV_OPEN, &wdd->status);
> +
> +	return 0;
> +}
> +
> +/*
> + *	/dev/watchdog kernel interfaces
> + */

Overdocumented?

> +
> +static const struct file_operations watchdog_fops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.llseek		=3D no_llseek,
> +	.write		=3D watchdog_write,
> +	.open		=3D watchdog_open,
> +	.release	=3D watchdog_release,
> +};
> +
> +static struct miscdevice watchdog_miscdev =3D {
> +	.minor		=3D WATCHDOG_MINOR,
> +	.name		=3D "watchdog",
> +	.fops		=3D &watchdog_fops,
> +};
> +
> +/*
> + *	/dev/watchdog register and unregister functions
> + */

Overdocumented?

> +
> +/*
> + *	watchdog_dev_register:
> + *	@watchdog: watchdog device
> + *
> + *	Register a watchdog device as /dev/watchdog. /dev/watchdog
> + *	is actually a miscdevice and thus we set it up like that.
> + */
> +
> +int watchdog_dev_register(struct watchdog_device *watchdog)
> +{
> +	int err;
> +
> +	/* Only one device can register for /dev/watchdog */
> +	if (test_and_set_bit(0, &watchdog_dev_busy)) {
> +		pr_err("only one watchdog can use /dev/watchdog.\n");
> +		return -EBUSY;
> +	}
> +
> +	wdd =3D watchdog;
> +
> +	/* Register the miscdevice */

Overdocumented?

> +	err =3D misc_register(&watchdog_miscdev);
> +	if (err !=3D 0) {
> +		pr_err("%s: cannot register miscdev on minor=3D%d (err=3D%d).\n",
> +			watchdog->info->identity, WATCHDOG_MINOR, err);
> +		goto out;
> +	}
> +
> +	return 0;
> +
> +out:
> +	wdd =3D NULL;
> +	clear_bit(0, &watchdog_dev_busy);
> +	return err;
> +}
> +
> +/*
> + *	watchdog_dev_unregister:
> + *	@watchdog: watchdog device
> + *
> + *	Deregister the /dev/watchdog device.
> + */
> +
> +int watchdog_dev_unregister(struct watchdog_device *watchdog)
> +{
> +	/* Check that a watchdog device was registered in the past */
> +	if (!test_bit(0, &watchdog_dev_busy) || !wdd)
> +		return -ENODEV;
> +
> +	/* We can only unregister the watchdog device that was registered */
> +	if (watchdog !=3D wdd) {
> +		pr_err("%s: watchdog was not registered as /dev/watchdog.\n",
> +			watchdog->info->identity);
> +		return -ENODEV;
> +	}
> +
> +	/* Unregister the miscdevice */

Overdocumented?

> +	misc_deregister(&watchdog_miscdev);
> +	wdd =3D NULL;
> +	clear_bit(0, &watchdog_dev_busy);
> +	return 0;
> +}
> +
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

Same as for MODULE_SUPPORTED_DEVICE?

> diff --git a/drivers/watchdog/watchdog_dev.h b/drivers/watchdog/watchdog_=
dev.h
> new file mode 100644
> index 0000000..bc7612b
> --- /dev/null
> +++ b/drivers/watchdog/watchdog_dev.h
> @@ -0,0 +1,33 @@
> +/*
> + *	watchdog_core.h
> + *
> + *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
> + *						All Rights Reserved.
> + *
> + *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
> + *
> + *	This source code is part of the generic code that can be used
> + *	by all the watchdog timer drivers.
> + *
> + *	Based on source code of the following authors:
> + *	  Matt Domsch <Matt_Domsch@dell.com>,
> + *	  Rob Radez <rob@osinvestor.com>,
> + *	  Rusty Lynch <rusty@linux.co.intel.com>
> + *	  Satyam Sharma <satyam@infradead.org>
> + *	  Randy Dunlap <randy.dunlap@oracle.com>
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; either version
> + *	2 of the License, or (at your option) any later version.
> + *
> + *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
> + *	admit liability nor provide warranty for any of this software.
> + *	This material is provided "AS-IS" and at no charge.
> + */
> +
> +/*
> + *	Functions/procedures to be called by the core
> + */
> +int watchdog_dev_register(struct watchdog_device *);
> +int watchdog_dev_unregister(struct watchdog_device *);
> diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
> index 011bcfe..40333ff 100644
> --- a/include/linux/watchdog.h
> +++ b/include/linux/watchdog.h
> @@ -59,6 +59,33 @@ struct watchdog_info {
>  #define WATCHDOG_NOWAYOUT	0
>  #endif
> =20
> +struct watchdog_ops;
> +struct watchdog_device;
> +
> +/* The watchdog-devices operations */
> +struct watchdog_ops {
> +	struct module *owner;
> +	/* mandatory operations */
> +	int (*start)(struct watchdog_device *);
> +	int (*stop)(struct watchdog_device *);
> +	/* optional operations */
> +	int (*ping)(struct watchdog_device *);
> +};
> +
> +/* The structure that defines a watchdog device */
> +struct watchdog_device {
> +	const struct watchdog_info *info;
> +	const struct watchdog_ops *ops;
> +	void *priv;
> +	unsigned long status;
> +/* Bit numbers for status flags */
> +#define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
> +};
> +
> +/* drivers/watchdog/core/watchdog_core.c */
> +extern int watchdog_register_device(struct watchdog_device *);
> +extern void watchdog_unregister_device(struct watchdog_device *);
> +
>  #endif	/* __KERNEL__ */
> =20
>  #endif  /* ifndef _LINUX_WATCHDOG_H */
> --=20
> 1.7.6
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4ba+gACgkQD27XaX1/VRvMywCeKgtz6Bfp73oUskXB9wGbf1gX
IBEAn214nHB4pyU7XFmThxs7TdpIfwXw
=OgBh
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
