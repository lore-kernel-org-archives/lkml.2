Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0C2KEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:04:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab0C2KEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:04:53 -0400
Date: Mon, 29 Mar 2010 12:04:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb:Push BKL on open down into the drivers
In-Reply-To: <201001131533.15704.oliver@neukum.org>
Message-ID: <alpine.LNX.2.00.1003291159470.24576@pobox.suse.cz>
References: <201001131533.15704.oliver@neukum.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010, Oliver Neukum wrote:

> From 271f10a4643c788be08cc481dc594ee87af25140 Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Wed, 13 Jan 2010 14:46:08 +0100
> Subject: [PATCH 4/5] usb:Push BKL on open down into the drivers
> 
> Straightforward push into the drivers to allow
> auditing individual drivers separately
> 
> Signed-off-by: Oliver Neukum <oliver@neukum.org>
> ---
>  drivers/hid/usbhid/hiddev.c           |    7 +++++--
>  drivers/media/video/dabusb.c          |    8 +++++++-
>  drivers/staging/frontier/alphatrack.c |    2 ++
>  drivers/staging/frontier/tranzport.c  |    2 ++
>  drivers/usb/class/cdc-wdm.c           |    3 +++
>  drivers/usb/class/usblp.c             |    3 +++
>  drivers/usb/class/usbtmc.c            |    3 +++
>  drivers/usb/core/file.c               |    2 --
>  drivers/usb/image/mdc800.c            |    3 +++
>  drivers/usb/misc/adutux.c             |    3 +++
>  drivers/usb/misc/ftdi-elan.c          |   15 ++++++++++++---
>  drivers/usb/misc/idmouse.c            |    8 +++++++-
>  drivers/usb/misc/iowarrior.c          |    4 ++++
>  drivers/usb/misc/ldusb.c              |   12 ++++++++++--
>  drivers/usb/misc/legousbtower.c       |    3 +++
>  drivers/usb/misc/rio500.c             |    3 ++-
>  drivers/usb/misc/sisusbvga/sisusb.c   |   14 ++++++++++++--
>  drivers/usb/misc/usblcd.c             |    5 +++++
>  drivers/usb/misc/vstusb.c             |    9 ++++++++-
>  drivers/usb/usb-skeleton.c            |    3 +++
>  20 files changed, 97 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
> index 867e084..433602a 100644
> --- a/drivers/hid/usbhid/hiddev.c
> +++ b/drivers/hid/usbhid/hiddev.c
> @@ -265,9 +265,10 @@ static int hiddev_release(struct inode * inode, struct file * file)
>  static int hiddev_open(struct inode *inode, struct file *file)
>  {
>  	struct hiddev_list *list;
> -	int res;
> +	int res, i;
>  
> -	int i = iminor(inode) - HIDDEV_MINOR_BASE;
> +	lock_kernel();
> +	i = iminor(inode) - HIDDEV_MINOR_BASE;
>  
>  	if (i >= HIDDEV_MINORS || i < 0 || !hiddev_table[i])
>  		return -ENODEV;
> @@ -313,10 +314,12 @@ static int hiddev_open(struct inode *inode, struct file *file)
>  			usbhid_open(hid);
>  		}
>  
> +	unlock_kernel();
>  	return 0;
>  bail:
>  	file->private_data = NULL;
>  	kfree(list);
> +	unlock_kernel();
>  	return res;
>  }
>  
[ ... snip ... ]
> diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
> index bfc6c2e..c3536f1 100644
> --- a/drivers/usb/core/file.c
> +++ b/drivers/usb/core/file.c
> @@ -34,7 +34,6 @@ static int usb_open(struct inode * inode, struct file * file)
>  	int err = -ENODEV;
>  	const struct file_operations *old_fops, *new_fops = NULL;
>  
> -	lock_kernel();
>  	down_read(&minor_rwsem);
>  	c = usb_minors[minor];
>  
> @@ -53,7 +52,6 @@ static int usb_open(struct inode * inode, struct file * file)
>  	fops_put(old_fops);
>   done:
>  	up_read(&minor_rwsem);
> -	unlock_kernel();
>  	return err;
>  }
>  

Hi Oliver,

looking at this a little bit more, this seems wrong, at least for the 
hiddev case. The reason is -- it changes the dependency order of BKL and 
minor_rwsem.

For hiddev, this causes a problem, as you introduced BKL into 
hiddev_connect() exactly because of the proper dependency -- we have the 
BKL there to avoid race after usb_register_dev() -- once the device node 
has been created, open() could happen on it.

The obvious fix -- introducing mutex to guard hiddev_table[] -- is wrong 
work, as usb_open() and usb_register_dev() both take minor_rwsem, thus 
there will be AB-BA deadlock between this mutex and minor_rwsem. 

So you avoided this situation by BKL (as usb_open() has been taking it in 
the right order), but now we are exactly in AB-BA deadlock situation 
because of the reversed dependency between BKL and minor_rwsem.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
