Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2FFO3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:29:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44766 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab2FFO26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:28:58 -0400
MIME-Version: 1.0
In-Reply-To: <1338988998-9061-1-git-send-email-stefani@seibold.net>
References: <1338988998-9061-1-git-send-email-stefani@seibold.net>
Date: Wed, 6 Jun 2012 22:28:57 +0800
Message-ID: <CACVXFVPX-F820rgusEiC9F9XQNqYybi29Cd_hSyiN95c2OAWHg@mail.gmail.com>
Subject: Re: [PATCH] fix usb skeleton driver
From: Ming Lei <tom.leiming@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 9:23 PM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This is a fix for the USB skeleton driver to bring it in shape.
>
> - The usb_interface structure pointer will be no longer stored
> - Every access to the USB will be handled trought the usb_interface pointer
> - Add a new bool 'connected' for signaling a disconnect (== false)
> - Handle a non blocking read without blocking
> - Code cleanup
> - Synchronize disconnect() handler with open() and release(), to fix races
> - Introduced fsync
> - Single user mode
> - More code cleanup :-)
> - Save some bytes in the dev structure

So many purposes, you need to split your patches for review easily, :-)

>
> Some word about the open()/release() races with disconnect() of an USB device
> (which can happen any time):
> - The return interface pointer from usb_find_interface() could be already owned
>  by an other driver and no more longer handle by the skeleton driver.
> - Or the dev pointer return by usb_get_intfdata() could point to an already
>  release memory.
>
> This races can not handled by a per device mutex. Only a driver global mutex
> could do this job, since the kref_put() in the skel_disconnect() must be
> protected, otherwise skel_open() could access an already released memory.
>
> I know that this races are very small, but on heavy load or misdesigned or buggy
> hardware this could lead in a OOPS or unpredictable behavior.
>
> The patch is against linux 3.5.0 commit eea5b5510fc5545d15b69da8e485a7424ae388cf
>
> Grek ask me to do this in more pieces, but i will post it for a first RFC.
>
> Hope this helps
>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  drivers/usb/usb-skeleton.c |  218 ++++++++++++++++++++++----------------------
>  1 files changed, 108 insertions(+), 110 deletions(-)
>
> diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
> index 0616f23..fce5a54 100644
> --- a/drivers/usb/usb-skeleton.c
> +++ b/drivers/usb/usb-skeleton.c
> @@ -1,7 +1,8 @@
>  /*
> - * USB Skeleton driver - 2.2
> + * USB Skeleton driver - 2.3
>  *
>  * Copyright (C) 2001-2004 Greg Kroah-Hartman (greg@kroah.com)
> + * fixes by Stefani Seibold (stefani@seibold.net)
>  *
>  *     This program is free software; you can redistribute it and/or
>  *     modify it under the terms of the GNU General Public License as
> @@ -48,8 +49,7 @@ MODULE_DEVICE_TABLE(usb, skel_table);
>
>  /* Structure to hold all of our device specific stuff */
>  struct usb_skel {
> -       struct usb_device       *udev;                  /* the usb device for this device */
> -       struct usb_interface    *interface;             /* the interface for this device */
> +       struct usb_device       *udev;                  /* the usb device */
>        struct semaphore        limit_sem;              /* limiting the number of writes in progress */
>        struct usb_anchor       submitted;              /* in case we need to retract our submissions */
>        struct urb              *bulk_in_urb;           /* the urb to read data with */
> @@ -62,15 +62,19 @@ struct usb_skel {
>        int                     errors;                 /* the last request tanked */
>        bool                    ongoing_read;           /* a read is going on */
>        bool                    processed_urb;          /* indicates we haven't processed the urb */
> +       bool                    connected;              /* connected flag */
> +       bool                    in_use;                 /* in use flag */
>        spinlock_t              err_lock;               /* lock for errors */
>        struct kref             kref;
> -       struct mutex            io_mutex;               /* synchronize I/O with disconnect */
> +       struct mutex            io_mutex;               /* synchronize I/O */
>        struct completion       bulk_in_completion;     /* to wait for an ongoing read */
>  };
>  #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
>
>  static struct usb_driver skel_driver;
> -static void skel_draw_down(struct usb_skel *dev);
> +
> +/* synchronize open/release with disconnect */
> +static DEFINE_MUTEX(sync_mutex);
>
>  static void skel_delete(struct kref *kref)
>  {
> @@ -86,15 +90,13 @@ static int skel_open(struct inode *inode, struct file *file)
>  {
>        struct usb_skel *dev;
>        struct usb_interface *interface;
> -       int subminor;
> -       int retval = 0;
> +       int retval;
>
> -       subminor = iminor(inode);
> +       /* lock against skel_disconnect() */
> +       mutex_lock(&sync_mutex);

This one is not needed since we have minor_rwsem(drivers/usb/core/file.c)
to avoid the race.

>
> -       interface = usb_find_interface(&skel_driver, subminor);
> +       interface = usb_find_interface(&skel_driver, iminor(inode));
>        if (!interface) {
> -               pr_err("%s - error, can't find device for minor %d\n",
> -                       __func__, subminor);
>                retval = -ENODEV;
>                goto exit;
>        }
> @@ -105,52 +107,61 @@ static int skel_open(struct inode *inode, struct file *file)
>                goto exit;
>        }
>
> -       /* increment our usage count for the device */
> -       kref_get(&dev->kref);
> -
> -       /* lock the device to allow correctly handling errors
> -        * in resumption */
> -       mutex_lock(&dev->io_mutex);
> +       if (dev->in_use) {
> +               retval = -EBUSY;
> +               goto exit;
> +       }
>
>        retval = usb_autopm_get_interface(interface);
>        if (retval)
> -               goto out_err;
> +               goto exit;
> +
> +       /* increment our usage count for the device */
> +       kref_get(&dev->kref);
> +
> +       dev->in_use = true;
> +       mutex_unlock(&sync_mutex);
>
>        /* save our object in the file's private structure */
>        file->private_data = dev;
> -       mutex_unlock(&dev->io_mutex);
> -
> +       return 0;
>  exit:
> +       mutex_unlock(&sync_mutex);
>        return retval;
>  }
>
>  static int skel_release(struct inode *inode, struct file *file)
>  {
> -       struct usb_skel *dev;
> -
> -       dev = file->private_data;
> -       if (dev == NULL)
> -               return -ENODEV;
> +       struct usb_skel *dev = file->private_data;
>
> +       /* lock against skel_disconnect() */
> +       mutex_lock(&sync_mutex);

Since the reference count is held now, so is there any race between
release and disconnect?

>        /* allow the device to be autosuspended */
> -       mutex_lock(&dev->io_mutex);
> -       if (dev->interface)
> -               usb_autopm_put_interface(dev->interface);
> -       mutex_unlock(&dev->io_mutex);
> +       if (dev->connected)
> +               usb_autopm_put_interface(
> +                       usb_find_interface(&skel_driver, iminor(inode)));
> +       dev->in_use = false;
>
>        /* decrement the count on our device */
>        kref_put(&dev->kref, skel_delete);
> +       mutex_unlock(&sync_mutex);
>        return 0;
>  }
>
> -static int skel_flush(struct file *file, fl_owner_t id)
> +static void skel_draw_down(struct usb_skel *dev)
>  {
> -       struct usb_skel *dev;
> -       int res;
> +       int time;
> +
> +       time = usb_wait_anchor_empty_timeout(&dev->submitted, 1000);
> +       if (!time)
> +               usb_kill_anchored_urbs(&dev->submitted);
> +       usb_kill_urb(dev->bulk_in_urb);
> +}
>
> -       dev = file->private_data;
> -       if (dev == NULL)
> -               return -ENODEV;
> +static int skel_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> +{
> +       struct usb_skel *dev = file->private_data;
> +       int res;
>
>        /* wait for io to stop */
>        mutex_lock(&dev->io_mutex);
> @@ -167,6 +178,11 @@ static int skel_flush(struct file *file, fl_owner_t id)
>        return res;
>  }
>
> +static int skel_flush(struct file *file, fl_owner_t id)
> +{
> +       return skel_fsync(file, 0, LLONG_MAX, 0);
> +}
> +
>  static void skel_read_bulk_callback(struct urb *urb)
>  {
>        struct usb_skel *dev;
> @@ -179,7 +195,7 @@ static void skel_read_bulk_callback(struct urb *urb)
>                if (!(urb->status == -ENOENT ||
>                    urb->status == -ECONNRESET ||
>                    urb->status == -ESHUTDOWN))
> -                       dev_err(&dev->interface->dev,
> +                       dev_err(&urb->dev->dev,
>                                "%s - nonzero write bulk status received: %d\n",
>                                __func__, urb->status);
>
> @@ -187,7 +203,7 @@ static void skel_read_bulk_callback(struct urb *urb)
>        } else {
>                dev->bulk_in_filled = urb->actual_length;
>        }
> -       dev->ongoing_read = 0;
> +       dev->ongoing_read = false;
>        spin_unlock(&dev->err_lock);
>
>        complete(&dev->bulk_in_completion);
> @@ -195,7 +211,7 @@ static void skel_read_bulk_callback(struct urb *urb)
>
>  static int skel_do_read_io(struct usb_skel *dev, size_t count)
>  {
> -       int rv;
> +       int retval;
>
>        /* prepare a read */
>        usb_fill_bulk_urb(dev->bulk_in_urb,
> @@ -207,67 +223,61 @@ static int skel_do_read_io(struct usb_skel *dev, size_t count)
>                        skel_read_bulk_callback,
>                        dev);
>        /* tell everybody to leave the URB alone */
> -       spin_lock_irq(&dev->err_lock);
> -       dev->ongoing_read = 1;
> -       spin_unlock_irq(&dev->err_lock);
> +       dev->ongoing_read = true;
>
>        /* do it */
> -       rv = usb_submit_urb(dev->bulk_in_urb, GFP_KERNEL);
> -       if (rv < 0) {
> -               dev_err(&dev->interface->dev,
> +       retval = usb_submit_urb(dev->bulk_in_urb, GFP_KERNEL);
> +       if (retval < 0) {
> +               dev_err(&dev->udev->dev,
>                        "%s - failed submitting read urb, error %d\n",
> -                       __func__, rv);
> +                       __func__, retval);
>                dev->bulk_in_filled = 0;
> -               rv = (rv == -ENOMEM) ? rv : -EIO;
> -               spin_lock_irq(&dev->err_lock);
> -               dev->ongoing_read = 0;
> -               spin_unlock_irq(&dev->err_lock);
> +               retval = (retval == -ENOMEM) ? retval : -EIO;
> +               dev->ongoing_read = false;
>        }
>
> -       return rv;
> +       return retval;
>  }
>
>  static ssize_t skel_read(struct file *file, char *buffer, size_t count,
>                         loff_t *ppos)
>  {
> -       struct usb_skel *dev;
> -       int rv;
> -       bool ongoing_io;
> -
> -       dev = file->private_data;
> +       struct usb_skel *dev = file->private_data;
> +       int retval;
>
>        /* if we cannot read at all, return EOF */
>        if (!dev->bulk_in_urb || !count)
>                return 0;
>
>        /* no concurrent readers */
> -       rv = mutex_lock_interruptible(&dev->io_mutex);
> -       if (rv < 0)
> -               return rv;
> +       if (file->f_flags & O_NONBLOCK) {
> +               if (!mutex_trylock(&dev->io_mutex))
> +                       return -EAGAIN;
> +       } else {
> +               retval = mutex_lock_interruptible(&dev->io_mutex);
> +               if (retval < 0)
> +                       return retval;
> +       }
>
> -       if (!dev->interface) {          /* disconnect() was called */
> -               rv = -ENODEV;
> +       if (!dev->connected) {          /* disconnect() was called */
> +               retval = -ENODEV;
>                goto exit;
>        }
>
>        /* if IO is under way, we must not touch things */
>  retry:
> -       spin_lock_irq(&dev->err_lock);
> -       ongoing_io = dev->ongoing_read;
> -       spin_unlock_irq(&dev->err_lock);
> -
> -       if (ongoing_io) {
> +       if (dev->ongoing_read) {
>                /* nonblocking IO shall not wait */
>                if (file->f_flags & O_NONBLOCK) {
> -                       rv = -EAGAIN;
> +                       retval = -EAGAIN;
>                        goto exit;
>                }
>                /*
>                 * IO may take forever
>                 * hence wait in an interruptible state
>                 */
> -               rv = wait_for_completion_interruptible(&dev->bulk_in_completion);
> -               if (rv < 0)
> +               retval = wait_for_completion_interruptible(&dev->bulk_in_completion);
> +               if (retval < 0)
>                        goto exit;
>                /*
>                 * by waiting we also semiprocessed the urb
> @@ -288,12 +298,12 @@ retry:
>        }
>
>        /* errors must be reported */
> -       rv = dev->errors;
> -       if (rv < 0) {
> +       retval = dev->errors;
> +       if (retval < 0) {
>                /* any error is reported once */
>                dev->errors = 0;
> -               /* to preserve notifications about reset */
> -               rv = (rv == -EPIPE) ? rv : -EIO;
> +               /* to preseretvale notifications about reset */
> +               retval = (retval == -EPIPE) ? retval : -EIO;
>                /* no data to deliver */
>                dev->bulk_in_filled = 0;
>                /* report it */
> @@ -315,8 +325,8 @@ retry:
>                         * all data has been used
>                         * actual IO needs to be done
>                         */
> -                       rv = skel_do_read_io(dev, count);
> -                       if (rv < 0)
> +                       retval = skel_do_read_io(dev, count);
> +                       if (retval < 0)
>                                goto exit;
>                        else
>                                goto retry;
> @@ -329,9 +339,9 @@ retry:
>                if (copy_to_user(buffer,
>                                 dev->bulk_in_buffer + dev->bulk_in_copied,
>                                 chunk))
> -                       rv = -EFAULT;
> +                       retval = -EFAULT;
>                else
> -                       rv = chunk;
> +                       retval = chunk;
>
>                dev->bulk_in_copied += chunk;
>
> @@ -343,16 +353,16 @@ retry:
>                        skel_do_read_io(dev, count - chunk);
>        } else {
>                /* no data in the buffer */
> -               rv = skel_do_read_io(dev, count);
> -               if (rv < 0)
> +               retval = skel_do_read_io(dev, count);
> +               if (retval < 0)
>                        goto exit;
>                else if (!(file->f_flags & O_NONBLOCK))
>                        goto retry;
> -               rv = -EAGAIN;
> +               retval = -EAGAIN;
>        }
>  exit:
>        mutex_unlock(&dev->io_mutex);
> -       return rv;
> +       return retval;
>  }
>
>  static void skel_write_bulk_callback(struct urb *urb)
> @@ -366,7 +376,7 @@ static void skel_write_bulk_callback(struct urb *urb)
>                if (!(urb->status == -ENOENT ||
>                    urb->status == -ECONNRESET ||
>                    urb->status == -ESHUTDOWN))
> -                       dev_err(&dev->interface->dev,
> +                       dev_err(&urb->dev->dev,
>                                "%s - nonzero write bulk status received: %d\n",
>                                __func__, urb->status);
>
> @@ -384,14 +394,12 @@ static void skel_write_bulk_callback(struct urb *urb)
>  static ssize_t skel_write(struct file *file, const char *user_buffer,
>                          size_t count, loff_t *ppos)
>  {
> -       struct usb_skel *dev;
> +       struct usb_skel *dev = file->private_data;
>        int retval = 0;
>        struct urb *urb = NULL;
>        char *buf = NULL;
>        size_t writesize = min(count, (size_t)MAX_TRANSFER);
>
> -       dev = file->private_data;
> -
>        /* verify that we actually have some data to write */
>        if (count == 0)
>                goto exit;
> @@ -444,9 +452,7 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
>        }
>
>        /* this lock makes sure we don't submit URBs to gone devices */
> -       mutex_lock(&dev->io_mutex);
> -       if (!dev->interface) {          /* disconnect() was called */
> -               mutex_unlock(&dev->io_mutex);
> +       if (!dev->connected) {          /* disconnect() was called */
>                retval = -ENODEV;
>                goto error;
>        }
> @@ -460,9 +466,8 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
>
>        /* send the data out the bulk port */
>        retval = usb_submit_urb(urb, GFP_KERNEL);
> -       mutex_unlock(&dev->io_mutex);
>        if (retval) {
> -               dev_err(&dev->interface->dev,
> +               dev_err(&dev->udev->dev,
>                        "%s - failed submitting write urb, error %d\n",
>                        __func__, retval);
>                goto error_unanchor;
> @@ -496,6 +501,7 @@ static const struct file_operations skel_fops = {
>        .write =        skel_write,
>        .open =         skel_open,
>        .release =      skel_release,
> +       .fsync =        skel_fsync,
>        .flush =        skel_flush,
>        .llseek =       noop_llseek,
>  };
> @@ -534,7 +540,8 @@ static int skel_probe(struct usb_interface *interface,
>        init_completion(&dev->bulk_in_completion);
>
>        dev->udev = usb_get_dev(interface_to_usbdev(interface));
> -       dev->interface = interface;
> +       dev->connected = true;
> +       dev->in_use = false;
>
>        /* set up the endpoint information */
>        /* use only the first bulk-in and bulk-out endpoints */
> @@ -603,35 +610,26 @@ error:
>  static void skel_disconnect(struct usb_interface *interface)
>  {
>        struct usb_skel *dev;
> -       int minor = interface->minor;
>
> -       dev = usb_get_intfdata(interface);
> -       usb_set_intfdata(interface, NULL);
> +       dev_info(&interface->dev, "USB Skeleton disconnect #%d",
> +                       interface->minor);
>
>        /* give back our minor */
>        usb_deregister_dev(interface, &skel_class);
>
> -       /* prevent more I/O from starting */
> -       mutex_lock(&dev->io_mutex);
> -       dev->interface = NULL;
> -       mutex_unlock(&dev->io_mutex);
> -
> +       dev = usb_get_intfdata(interface);
>        usb_kill_anchored_urbs(&dev->submitted);
>
> -       /* decrement our usage count */
> -       kref_put(&dev->kref, skel_delete);
> -
> -       dev_info(&interface->dev, "USB Skeleton #%d now disconnected", minor);
> -}
> +       /* lock against skel_open() and skel_release() */
> +       mutex_lock(&sync_mutex);
> +       usb_set_intfdata(interface, NULL);
>
> -static void skel_draw_down(struct usb_skel *dev)
> -{
> -       int time;
> +       /* prevent more I/O from starting */
> +       dev->connected = false;
>
> -       time = usb_wait_anchor_empty_timeout(&dev->submitted, 1000);
> -       if (!time)
> -               usb_kill_anchored_urbs(&dev->submitted);
> -       usb_kill_urb(dev->bulk_in_urb);
> +       /* decrement our usage count */
> +       kref_put(&dev->kref, skel_delete);
> +       mutex_unlock(&sync_mutex);
>  }
>
>  static int skel_suspend(struct usb_interface *intf, pm_message_t message)
> --
> 1.7.8.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Thanks,
-- 
Ming Lei
