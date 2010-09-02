Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0IBOWC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:22:02 -0400
Received: from lucidpixels.com ([75.144.35.66]:60402 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0IBOWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:22:00 -0400
Date: Thu, 2 Sep 2010 10:21:57 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: adam radford <aradford@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
In-Reply-To: <AANLkTi=SO1nZbFySAs8_+TmCZcKBPihN6xrZfJihBnXG@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1009020540500.22317@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan> <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com> <alpine.DEB.2.00.1008271306100.24692@p34.internal.lan> <alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
 <alpine.DEB.2.00.1008310717260.4858@p34.internal.lan> <alpine.DEB.2.00.1008310732120.5156@p34.internal.lan> <alpine.DEB.2.00.1008310820350.19249@p34.internal.lan> <alpine.DEB.2.00.1009010536070.14332@p34.internal.lan>
 <AANLkTi=SO1nZbFySAs8_+TmCZcKBPihN6xrZfJihBnXG@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Sep 2010, adam radford wrote:

> On Wed, Sep 1, 2010 at 2:40 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> Could the lock/unlock be causing the issue?
>> Again, in 2.6.34, there are no latency problems or controller resets.
>
> Justin,
>
> We are looking into this issue and should get back to you soon.
>
> The lock/unlock() kernel calls were not added by me but were part of a
> series of 'BKL pushdown' patches added by someone to all drivers with
> an ioctl interface.  If you think those might be related to your
> issue, you could try
> removing those 2 lines of code and recompiling.
>
> If you haven't already, please email you kernel .config files for both
> the working kernel and non working kernel to the 3ware/LSI support
> people you are in contact with.
>
> Thanks.
>
> -Adam
>

Hi,

Done, attached to the 3ware/LSI case, also available below:

wget http://home.comcast.net/~jpiszcz/20100902/2.6.34.1-config-good.txt
wget http://home.comcast.net/~jpiszcz/20100902/2.6.35.4-io-ctrl-resets.txt

Adam, per your recommendation, I removed the two kernel calls:
+       lock_kernel();
+       unlock_kernel();

Recompiled and the problem persisted, so I took the old driver and copied it
to the new kernel:

p34:/usr/src# cp linux-2.6.34.6/drivers/scsi/3w-9xxx.h linux-2.6.35.4/drivers/scsi/3w-9xxx.h
p34:/usr/src# cp linux-2.6.34.6/drivers/scsi/3w-9xxx.c linux-2.6.35.4/drivers/scsi/3w-9xxx.c
p34:/usr/src#

Moving the 2.6.34.6 driver to 2.6.35.4: success, so it is not a kernel bug,
but a driver issue:

Any other recommendations on what is going on here?

If it isn't the kernel locks, it must be something else:

--- linux-2.6.34.6/drivers/scsi/3w-9xxx.c       2010-08-26 19:44:38.000000000 -0400
+++ linux-2.6.35.4/drivers/scsi/3w-9xxx.c       2010-08-26 19:47:12.000000000 -0400
-   Written By: Adam Radford <linuxraid@amcc.com>
-   Modifications By: Tom Couch <linuxraid@amcc.com>
+   Written By: Adam Radford <linuxraid@lsi.com>
+   Modifications By: Tom Couch <linuxraid@lsi.com>
+   Copyright (C) 2010 LSI Corporation.
-   linuxraid@amcc.com
+   linuxraid@lsi.com
-   http://www.amcc.com
+   http://www.lsi.com
+   2.26.02.014 - Force 60 second timeout default.
-#define TW_DRIVER_VERSION "2.26.02.013"
+#define TW_DRIVER_VERSION "2.26.02.014"
-MODULE_AUTHOR ("AMCC");
+MODULE_AUTHOR ("LSI");
-static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
+static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-       .ioctl          = twa_chrdev_ioctl,
+       .unlocked_ioctl = twa_chrdev_ioctl,
-static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+       struct inode *inode = file->f_path.dentry->d_inode;
+       lock_kernel();
+
+       unlock_kernel();
+/* This function gets called when a disk is coming on-line */
+static int twa_slave_configure(struct scsi_device *sdev)
+{
+       /* Force 60 second timeout */
+       blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
+
+       return 0;
+} /* End twa_slave_configure() */
+
+       .slave_configure        = twa_slave_configure,


Justin.

