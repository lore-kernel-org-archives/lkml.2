Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1IWK4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:56:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37754 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1IWK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:56:07 -0400
Subject: Re: [PATCHv6] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Date: Fri, 23 Sep 2011 13:58:50 +0300
In-Reply-To: <1316678312-8913-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1316678312-8913-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1316775538.19921.19.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 09:58 +0200, David Wagner wrote:

> +MODULE_PARM_DESC(volume,
> +	"Format: volume=<ubi_num>:<vol_id>\n"
> +	"Create a ubiblk device at init time.  Useful for mounting it as root "
> +	"device.");

I encourage people to use names, not IDs, because names are persistent,
while IDs may change when the configuration changes.

Take a look at UBI and how it handles the "mtd=" parameter. Do something
similar when you are parsing vol_id. IOW, I, as a user, would want to be
able to do:

ubimkvol -N "kuku" ...
modprobe ubiblk volume=0:kuku

(specify volume name "kuku").


> +/**
> + * ubiblk_inittime_volume - create a volume at init time

Please, stick to the same rule as UBI is using:
   1. If the function is non-static, always add an ubiblk prefix
   2. If the function is static, but it just makes sense to start with
      ubiblk_ prefix, fine. For example, ubiblk_init().
   3. Otherwise, no need to add ubiblk_ prefix for a static function.

IOW, please, do not automatically prefix all your functions with ubiblk_
prefix, especially when it brings no value and makes names longer.

I think this function is one of those which does not need that prefix.


> +/**
> + * ubi_ubiblk_init - initialize the module
> + *
> + * Get a major number and register to UBI notifications ; register the ioctl
> + * handler device

Nitpick: please, for consistency, put dots at the end of description.

> + */
> +static int __init ubi_ubiblk_init(void)

Name it ubiblk_init() please.

> +{
> +	int ret = 0;

The initialization is not needed.

> +
> +	ret = register_blkdev(0, "ubiblk");
> +	if (ret < 0)
> +		return ret;
> +	ubiblk_major = ret;
> +
> +	/* Check if the user wants a volume to be proxified at init time */
> +	if (volume)
> +		ubiblk_inittime_volume();

If you fail to create the block device the user requested using the
module parameters, you should exit with error code. IOW,
'ubiblk_inittime_volume()' has to return an error on failure.

> +
> +	ret = ubi_register_volume_notifier(&ubiblk_notifier, 1);
> +	if (ret < 0)
> +		goto out_unreg_blk;

If you previously created a block device in 'ubiblk_inittime_volume()',
and fail here, the error path will not destroy the block device, but it
should. IOW, you have a problem in your error path here.

> +
> +	ret = misc_register(&ctrl_dev);
> +	if (ret) {
> +		pr_err("can't register control device\n");
> +		goto out_unreg_notifier;
> +	}
> +
> +	pr_info("major device number is %d\n", ubiblk_major);
> +
> +	return ret;
> +
> +out_unreg_notifier:
> +	ubi_unregister_volume_notifier(&ubiblk_notifier);
> +out_unreg_blk:

if (volumes)
	ubiblk_destroy(xxx);

or something like that is needed here.

> +	unregister_blkdev(ubiblk_major, "ubiblk");
> +
> +	return ret;
> +}

> +/**
> + * ubi_ubiblk_exit - end of life
> + *
> + * unregister the block device major, unregister from UBI notifications,

Nitpick: please, start description with capital letter, for consistency.

> + * unregister the ioctl handler device stop the threads and free the memory.
> + */
> +static void __exit ubi_ubiblk_exit(void)

Please, name it simply 'ubiblk_exit()' instead.

> +{
> +	struct ubiblk_dev *next;
> +	struct ubiblk_dev *dev;
> +
> +	ubi_unregister_volume_notifier(&ubiblk_notifier);
> +	misc_deregister(&ctrl_dev);
> +
> +	list_for_each_entry_safe(dev, next, &ubiblk_devs, list) {
> +		/* The module is being forcefully removed */
> +		WARN_ON(dev->desc);
> +
> +		del_gendisk(dev->gd);
> +		blk_cleanup_queue(dev->rq);
> +		kthread_stop(dev->req_task);
> +		put_disk(dev->gd);
> +
> +		kfree(dev);

1. I think you should have an "ubiblk_destroy()" function, symmetric to
the "ubiblk_create()". And you'll also use it in the error path of the
init function, see above.

2. Please, could you explain what prevents the following crash/issue:

modprobe ubiblk volumes=0:0
mkfs.ext3 /dev/ubiblk0
mount -t ext3 /dev/ubiblk0 /mnt/fs
rmmod ubiblk

Not that I think this is a problem, I just do not realize what would
prevent ubiblk from being unloaded when it is mounted. Did you test this
scenario?

> +/*
> + * Copyright © Free Electrons, 2011
> + * Copyright © International Business Machines Corp., 2006
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
> + * the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + * Author: David Wagner
> + * Some code taken from ubi-user.h

Since this will be living in the UBI directory and be kind of part of
UBI sources, this comment is probably not needed. The same for the
ubiblk.c file.

> +/**
> + * ubiblk_ctrl_req - additional ioctl data structure

Nitpick: please, let's be consistent with the rest of the UBI code and
put dot at the end of the "heading" line of the kernel-doc comments for
structures, and functions as well.

-- 
Best Regards,
Artem Bityutskiy

