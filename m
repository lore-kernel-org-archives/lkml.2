Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1CMSY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 14:24:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1CMSY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 14:24:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [REVIEW] NVM Express driver
Date: Sun, 13 Mar 2011 19:24:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110303204749.GY3663@linux.intel.com>
In-Reply-To: <20110303204749.GY3663@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103131924.25032.arnd@arndb.de>
X-Provags-ID: V02:K0:Cg3jA2V1iAkTuphpodeaBW8k/fDa+WefDW7e7oY6WRf
 UPlbuaONVeSDJW3KGiBdnWv+ZY+Y+aZanGXeW3+vAbk7rndz8P
 GlIpaSxiGHhZ8ClNj/YwE+bqGf7S5LNg3NdgeWCyT5UdYseV72
 +jFWZgzfSM7BHexqy3viI3aaFaF5yN9znnl6ocOxrz6WjZuJ7T
 OD/DiT1oAcui22Y5HbgnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 March 2011 21:47:49 Matthew Wilcox wrote:

> You may have seen the recent announcement of the NVM Express spec;
> here's the driver.  I've put a git tree up on kernel.org with
> all the history that's fit to be released (earlier versions
> were full of Intel codenames and are not suited to public
> consumption).  If you'd rather review the history, it's at
> http://git.kernel.org/?p=linux/kernel/git/willy/nvme.git;a=summary

Looks really nice overall, I only have a few comments about
the ioctl interface. As Greg already commented, it would be
good to reduce the number of ioctl commands to a minimum.

> +static int nvme_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
> +                                                       unsigned long arg)
> +{
> +       struct nvme_ns *ns = bdev->bd_disk->private_data;
> +
> +       switch (cmd) {
> +       case NVME_IOCTL_IDENTIFY_NS:
> +               return nvme_identify(ns, arg, 0);
> +       case NVME_IOCTL_IDENTIFY_CTRL:
> +               return nvme_identify(ns, arg, 1);
> +       case NVME_IOCTL_GET_RANGE_TYPE:
> +               return nvme_get_range_type(ns, arg);
> +       case NVME_IOCTL_SUBMIT_IO:
> +               return nvme_submit_io(ns, (void __user *)arg);
> +       case NVME_IOCTL_DOWNLOAD_FW:
> +               return nvme_download_firmware(ns, (void __user *)arg);
> +       case NVME_IOCTL_ACTIVATE_FW:
> +               return nvme_activate_firmware(ns, arg);
> +       default:
> +               return -ENOTTY;
> +       }
> +}

The argument is a pointer for all of these, as far as I can tell,
so you could do the typecast here once instead of doing it for
two of them.

> +static const struct block_device_operations nvme_fops = {
> +       .owner          = THIS_MODULE,
> +       .ioctl          = nvme_ioctl,
> +};

This is missing a .compat_ioctl pointer to work with 32 bit user
space. The data structures all seem compatible, so that should
be a trivial change.

> +#define NVME_IOCTL_IDENTIFY_NS _IOW('N', 0x40, struct nvme_id_ns)
> +#define NVME_IOCTL_IDENTIFY_CTRL _IOW('N', 0x41, struct nvme_id_ctrl)
> +#define NVME_IOCTL_GET_RANGE_TYPE _IOW('N', 0x42, struct nvme_lba_range_type)
> +#define NVME_IOCTL_SUBMIT_IO   _IOWR('N', 0x43, struct nvme_rw_command)
> +#define NVME_IOCTL_DOWNLOAD_FW _IOR('N', 0x44, struct nvme_dlfw)
> +#define NVME_IOCTL_ACTIVATE_FW _IO('N', 0x45)

I believe you have confused read and write here. IIRC, _IOW means
copy_from_user and _IOR means copy_to_user.

The code for NVME_IOCTL_SUBMIT_IO takes a nvme_user_io argument,
not nvme_rw_command.

You might want to have an upper bound on the amount of user data
that one can pass to SUBMIT_IO and others.

	Arnd
