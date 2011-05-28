Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1E1VXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 17:23:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:60146 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1E1VXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 17:23:37 -0400
Date: Sun, 29 May 2011 05:23:47 +0800
From: Greg KH <gregkh@suse.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH v2] arch/tile: add hypervisor-based character driver for
 SPI flash ROM
Message-ID: <20110528212347.GA11303@suse.de>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
 <4DD6FB9E.2050604@tilera.com>
 <20110521032102.GD19907@suse.de>
 <201105211133.50238.arnd@arndb.de>
 <4DD7C3A7.5010402@tilera.com>
 <BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com>
 <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 11:13:54AM -0400, Chris Metcalf wrote:
> --- /dev/null
> +++ b/drivers/char/tile-srom.c
> @@ -0,0 +1,453 @@
> +/*
> + * Copyright 2011 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + *
> + * SPI Flash ROM driver
> + *
> + * This source code is derived from code provided in "Linux Device
> + * Drivers" by Alessandro Rubini and Jonathan Corbet, published by
> + * O'Reilly & Associates.
> + */

LDD version 2?  Wow, this driver is old.

> +MODULE_LICENSE("Dual BSD/GPL");

Wait, where did the BSD come from?  You just said it was GPL only above
in the header of the file?

> +/**
> + * srom_setup_cdev() - Set up a device instance in the cdev table.
> + * @dev: Per-device SROM state.
> + * @index: Device to set up.
> + */
> +static void srom_setup_cdev(struct srom_dev *dev, int index)
> +{
> +	int err, devno = MKDEV(srom_major, index);
> +
> +	cdev_init(&dev->cdev, &srom_fops);
> +	dev->cdev.owner = THIS_MODULE;
> +	dev->cdev.ops = &srom_fops;
> +	err = cdev_add(&dev->cdev, devno, 1);
> +	/* Fail gracefully if need be */
> +	if (err)
> +		pr_notice("Error %d adding srom%d", err, index);
> +}

As you are only using 1 minor device, why not just use a misc device
instead?  It's simpler, and you get the sysfs code for free, which you
forgot to do, so your device node will never show up in userspace :(

thanks,

greg k-h
