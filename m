Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab1ECK5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:57:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51042 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1ECK5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:57:43 -0400
Date: Tue, 3 May 2011 12:57:35 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jimmy Chen =?utf-8?B?KOmZs+awuOmBlCk=?= <jimmy.chen@moxa.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH 2/2] watchdog: add support for MOXA V2100 watchdog
 driver
Message-ID: <20110503105735.GB2497@pengutronix.de>
References: <20110503103704.69aba5b2@lxorguk.ukuu.org.uk>
 <ECB3782BB8F03341905DD923270296115F720B@mhqms01.moxa.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <ECB3782BB8F03341905DD923270296115F720B@mhqms01.moxa.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 03, 2011 at 06:25:50PM +0800, Jimmy Chen (=E9=99=B3=E6=B0=B8=E9=
=81=94) wrote:
> From: Jimmy Chen <jimmy.chen@moxa.com>
>=20
> -Add real function for watchdog driver
> -Follow advices from Alan Cox
>=20
> Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>
> ---
> diff --git a/drivers/watchdog/moxa_wdt.c b/drivers/watchdog/moxa_wdt.c
> new file mode 100644
> index 0000000..bcd8164
> --- /dev/null
> +++ b/drivers/watchdog/moxa_wdt.c
> @@ -0,0 +1,385 @@
> +/*
> + * serial driver for the MOXA V2100 platform.
> + *
> + * Copyright (c) MOXA Inc.  All rights reserved.
> + *	Jimmy Chen <jimmy.chen@moxa.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * History:
> + * Date		Author			Comment
> + * 04-29-2011	Jimmy Chen.		copy wdt.c code

Not needed, we have the git-repo-history.

> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME":"fmt
> +
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/types.h>
> +#include <linux/miscdevice.h>
> +#include <linux/watchdog.h>
> +#include <linux/fs.h>
> +#include <linux/ioport.h>
> +#include <linux/notifier.h>
> +#include <linux/reboot.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/uaccess.h>
> +
> +#include <asm/system.h>
> +
> +#include "moxa_wdt.h"
> +
> +#define MOXA_WDT_VERSION		"v0.1.0"

Not needed, we have the git-repo-history.

> +#define HW_VENDOR_ID_H			0x87
> +#define HW_VENDOR_ID_L			0x83
> +
> +
> +static unsigned long wdt_is_open;
> +static char expect_close;
> +
> +static int timeout =3D DEFAULT_WATCHDOG_TIMEOUT;
> +module_param(timeout, int, 0);
> +MODULE_PARM_DESC(timeout,
> +	"Watchdog timeout in seconds. 1<=3D timeout <=3D63, default=3D"
> +		__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
> +
> +static int nowayout =3D WATCHDOG_NOWAYOUT;
> +module_param(nowayout, int, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be "
> +		"stopped once started (default=3DCONFIG_WATCHDOG_NOWAYOUT)");
> +
> +static int debug;
> +module_param(debug, int, 0);
> +MODULE_PARM_DESC(debug, "print the debug message in this driver");

Can go, there is a dynamic_debug Kconfig option.

> +
> +static spinlock_t wdt_lock =3D SPIN_LOCK_UNLOCKED;
> +
> +/**
> + *	wdt_start:
> + *
> + *	Start the watchdog driver.
> + */
> +
> +static int moxawdt_start(void)
> +{
> +	unsigned long flags;
> +	unsigned char val;
> +
> +	if (debug)
> +		pr_debug("wdt_start: timeout=3D%d\n", timeout);
> +
> +	spin_lock_irqsave(&wdt_lock, flags);
> +	superio_init();
> +	superio_select_dev(7);
> +	val =3D superio_get_reg(0x72) | 0x10;

How about register names instead of magic values?

> +	superio_set_reg(val, 0x72);
> +	superio_set_reg((timeout/1000), 0x73);

Spaces around operators. Please use checkpatch.pl for further hints.

> +	spin_unlock_irqrestore(&wdt_lock, flags);
> +	return 0;
> +}
> +
> +/**
> + *	wdt_stop:
> + *
> + *	Stop the watchdog driver.
> + */
> +
> +static int wdt_stop(void)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&wdt_lock, flags);
> +
> +	if (debug)
> +		pr_debug("wdt_disable\n");
> +	superio_init();
> +	superio_select_dev(7);	/* logic device 8 */
> +	superio_set_reg(0, 0x73);	/* Reg:F6 counter register */
> +	spin_unlock_irqrestore(&wdt_lock, flags);
> +	return 0;
> +}
> +
> +/**
> + *	wdt_ping:
> + *
> + *	Reload counter one with the watchdog heartbeat. We don't bother
> + *	reloading the cascade counter.
> + */
> +
> +static void wdt_ping(void)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&wdt_lock, flags);
> +
> +	if (debug)
> +		pr_debug("wdt_ping: timeout=3D%d\n", timeout);
> +	superio_init();
> +	superio_select_dev(7);    /* logic device 7 */
> +	superio_set_reg((timeout/1000), 0x73);    /* Reg:F6,30 sec */
> +	spin_unlock_irqrestore(&wdt_lock, flags);
> +}
> +
> +/**
> + *	wdt_verify_vendor:
> + *	return true if vendor ID match
> + */
> +
> +static int wdt_verify_vendor(void)
> +{
> +	unsigned char chip_id_h; /* chip id high byte */
> +	unsigned char chip_id_l; /* chip id low byte */

Comment can go IMHO (obvious).

> +
> +	superio_init();
> +	superio_select_dev(7);
> +	chip_id_h =3D superio_get_reg(0x20);
> +	chip_id_l =3D superio_get_reg(0x21);
> +	if ((chip_id_h =3D=3D HW_VENDOR_ID_H) && (chip_id_l =3D=3D HW_VENDOR_ID=
_L))
> +		return 0;
> +
> +	return -1;

-EINVAL?

> +}
> +
> +/**
> + *	wdt_set_timeout:
> + *	@t:		the new heartbeat value that needs to be set.
> + *
> + *	Set a new heartbeat value for the watchdog device. If the heartbeat
> + *	value is incorrect we keep the old value and return -EINVAL. If
> + *	successful we return 0.
> + */
> +
> +static int wdt_set_timeout(int *t)
> +{
> +	if (*t < WATCHDOG_MIN_TIMEOUT || *t > WATCHDOG_MAX_TIMEOUT) {
> +		*t =3D DEFAULT_WATCHDOG_TIMEOUT;
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int moxawdt_open(struct inode *inode, struct file *file)
> +{
> +
> +	if (test_and_set_bit(0, &wdt_is_open))
> +		return -EBUSY;
> +	/*
> +	 *	Activate
> +	 */

Comment can go (obvious).

> +	if (debug)
> +		pr_debug("moxawdt_open entry\n");
> +	moxawdt_start();
> +	return nonseekable_open(inode, file);
> +
> +	return 0;
> +}
> +
> +static int moxawdt_release(struct inode *inode, struct file *file)
> +{
> +	if (debug)
> +		pr_debug("moxawdt_release entry\n");
> +
> +	if (expect_close =3D=3D 42) {
> +		wdt_stop();
> +		clear_bit(0, &wdt_is_open);
> +	} else {
> +		pr_crit("wdt: WDT device closed unexpectedly.  WDT will not stop!\n");
> +		wdt_ping();
> +	}
> +	expect_close =3D 0;
> +
> +	return 0;
> +}
> +
> +static long moxawdt_ioctl(struct file *file,
> +		unsigned int cmd, unsigned long arg)
> +{
> +	void __user *argp =3D (void __user *)arg;
> +	int __user *p =3D argp;
> +	int new_timeout;
> +	int status;
> +
> +	static struct watchdog_info ident =3D {
> +		.options =3D		WDIOF_SETTIMEOUT|
> +					WDIOF_MAGICCLOSE|
> +					WDIOF_KEEPALIVEPING,
> +		.firmware_version =3D	1,
> +		.identity =3D		"MOXA2100WDT ",
> +	};
> +
> +	switch (cmd) {
> +	case WDIOC_GETSUPPORT:
> +		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
> +	case WDIOC_GETSTATUS:
> +		status =3D 1;
> +		return put_user(status, p);
> +	case WDIOC_GETBOOTSTATUS:
> +		return put_user(0, p);
> +	case WDIOC_KEEPALIVE:
> +		wdt_ping();
> +		return 0;
> +	case WDIOC_SETTIMEOUT:
> +		if (get_user(new_timeout, p))
> +			return -EFAULT;
> +		if (wdt_set_timeout(&new_timeout))
> +			return -EINVAL;
> +		wdt_ping();
> +		/* Fall */
> +	case WDIOC_GETTIMEOUT:
> +		return put_user(timeout, p);
> +	default:
> +		return -ENOTTY;
> +	}
> +	return 0;
> +}
> +
> +/*
> + *      moxawdt_write:
> + *      @file: file handle to the watchdog
> + *      @buf: buffer to write (unused as data does not matter here
> + *      @count: count of bytes
> + *      @ppos: pointer to the position to write. No seeks allowed
> + *
> + *      A write to a watchdog device is defined as a keepalive signal. A=
ny
> + *      write of data will do, as we we don't define content meaning.
> + */
> +
> +static ssize_t moxawdt_write(struct file *file, const char *buf, \
> +			    size_t count, loff_t *ppos)
> +{
> +	if (count) {
> +		if (!nowayout) {
> +			size_t i;
> +
> +			/* In case it was set long ago */
> +			for (i =3D 0; i !=3D count; i++) {
> +				char c;
> +				if (get_user(c, buf + i))
> +					return -EFAULT;
> +				if (c =3D=3D 'V')
> +					expect_close =3D 42;
> +			}
> +		}
> +
> +	}
> +	return count;
> +}
> +
> +/**
> + *	notify_sys:
> + *	@this: our notifier block
> + *	@code: the event being reported
> + *	@unused: unused
> + *
> + *	Our notifier is called on system shutdowns. We want to turn the card
> + *	off at reboot otherwise the machine will reboot again during memory
> + *	test or worse yet during the following fsck. This would suck, in fact
> + *	trust me - if it happens it does suck.
> + */
> +
> +static int wdt_notify_sys(struct notifier_block *this, unsigned long cod=
e,
> +	void *unused)
> +{
> +	if (code =3D=3D SYS_DOWN || code =3D=3D SYS_HALT)
> +		wdt_stop();
> +	return NOTIFY_DONE;
> +}
> +
> +/*
> + *	The WDT card needs to learn about soft shutdowns in order to
> + *	turn the timebomb registers off.
> + */
> +
> +static struct notifier_block wdt_notifier =3D {
> +	.notifier_call =3D wdt_notify_sys,
> +};
> +
> +static const struct file_operations moxawdt_fops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.llseek		=3D no_llseek,
> +	.open		=3D moxawdt_open,
> +	.write		=3D moxawdt_write,
> +	.unlocked_ioctl	=3D moxawdt_ioctl,
> +	.release	=3D moxawdt_release,
> +};
> +
> +static struct miscdevice wdt_miscdev =3D {
> +	.minor =3D WATCHDOG_MINOR,
> +	.name =3D "watchdog",
> +	.fops =3D &moxawdt_fops,
> +};
> +
> +static int __init moxawdt_init(void)
> +{
> +	int ret;
> +
> +	/* check timeout valid */

Comment can go (obvious).

> +	if (wdt_set_timeout(&timeout)) {
> +		pr_err("timeout value must be "
> +				"%lu < timeout < %lu, using %d\n",

String should fit into one line.

> +				WATCHDOG_MIN_TIMEOUT, WATCHDOG_MAX_TIMEOUT,
> +				timeout);
> +	}
> +
> +	if (!request_region(SUPERIO_PORT, 2, "moxawdt")) {
> +		pr_err("moxawdt_init: can't get I/O "
> +				"address 0x%x\n", SUPERIO_PORT);
> +		ret =3D -EBUSY;
> +		goto reqreg_err;
> +	}
> +
> +	/* we suppose to check magic id in case wrong devices */

Comment can go (obvious).

> +	if (wdt_verify_vendor()) {
> +		pr_err("hw device id not match!!\n");
> +		ret =3D -ENODEV;
> +		goto reqreg_err;
> +	}
> +
> +	ret =3D register_reboot_notifier(&wdt_notifier);
> +	if (ret) {
> +		pr_err("can't register reboot notifier\n");
> +		goto regreb_err;
> +	}
> +
> +	ret =3D misc_register(&wdt_miscdev);
> +	if (ret) {
> +		pr_err("Moxa V2100-LX WatchDog: Register misc fail !\n");
> +		goto regmisc_err;
> +	}
> +
> +	pr_info("Moxa V2100 Watchdog Driver, version %s\n", MOXA_WDT_VERSION);
> +	pr_info("initialized. (nowayout=3D%d)\n", nowayout);
> +	pr_info("initialized. (timeout=3D%d)\n", timeout);
> +	pr_info("initialized. (debug=3D%d)\n", debug);

Too excessive IMHO. Imagine every driver in your system printing that
much.

> +
> +	return 0;
> +
> +regmisc_err:
> +	unregister_reboot_notifier(&wdt_notifier);
> +regreb_err:
> +	release_region(SUPERIO_PORT, 2);
> +reqreg_err:
> +	return ret;
> +}
> +
> +static void __exit moxawdt_exit(void)
> +{
> +	misc_deregister(&wdt_miscdev);
> +	unregister_reboot_notifier(&wdt_notifier);
> +	release_region(SUPERIO_PORT, 2);
> +	superio_release();
> +}
> +
> +module_init(moxawdt_init);

Most people put this right below the referenced function.

> +module_exit(moxawdt_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Jimmy.Chen@moxa.com");
> +MODULE_DESCRIPTION("Moxa V2100-LX WDT driver");
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> +
> diff --git a/drivers/watchdog/moxa_wdt.h b/drivers/watchdog/moxa_wdt.h
> new file mode 100644
> index 0000000..3f3ff68
> --- /dev/null
> +++ b/drivers/watchdog/moxa_wdt.h
> @@ -0,0 +1,53 @@
> +/*
> + * serial driver for the MOXA V2100 platform.
> + *
> + * Copyright (c) MOXA Inc.  All rights reserved.
> + *	Jimmy Chen <jimmy.chen@moxa.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __X86__MOXAWDT__
> +#define __X86__MOXAWDT__
> +
> +#define	SUPERIO_PORT		((u8)0x2e)
> +
> +#define DEFAULT_WATCHDOG_TIMEOUT	(30UL*1000UL)	/* 30 seconds */
> +#define WATCHDOG_MIN_TIMEOUT	(1UL*1000UL)	/*  2 seconds */
> +#define WATCHDOG_MAX_TIMEOUT	(255UL*1000UL)	/* 255 seconds */
> +
> +unsigned char superio_get_reg(u8 val)
> +{
> +	outb_p(val, SUPERIO_PORT);
> +	val =3D inb_p(SUPERIO_PORT+1);
> +	return val;
> +}

Hmm, code in a header? Can't this go into the main source? Hmm, at least
it87_wdt.c has something very similar. Maybe it can even be shared? What
about locking BTW?

> +
> +void superio_set_reg(u8 val, u8 index)
> +{
> +	outb_p(index, SUPERIO_PORT);
> +	outb_p(val, (SUPERIO_PORT+1));
> +}
> +
> +void superio_select_dev(u8 val)
> +{
> +	superio_set_reg(val, 0x07);
> +}
> +
> +void superio_init(void)
> +{
> +	outb(0x87, SUPERIO_PORT);
> +	outb(0x01, SUPERIO_PORT);
> +	outb(0x55, SUPERIO_PORT);
> +	outb(0x55, SUPERIO_PORT);
> +}
> +
> +void superio_release(void)
> +{
> +	outb_p(0x02, SUPERIO_PORT);
> +	outb_p(0x02, SUPERIO_PORT+1);
> +}
> +
> +#endif	/* __X86__MOXAWDT__ */

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2/358ACgkQD27XaX1/VRsM6ACdHpkxuNqBulwj3/PNPA7j+3m6
miUAniJLjHL3tLLC5Azs94MRji7WAtlX
=zD5K
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
