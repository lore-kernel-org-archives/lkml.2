Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2FFNyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:54:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab2FFNyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:54:09 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: stefani@seibold.net
Subject: Re: [PATCH] fix usb skeleton driver
Date: Wed, 6 Jun 2012 15:50:51 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
References: <1338988998-9061-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1338988998-9061-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206061550.51264.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Juni 2012, 15:23:18 schrieb stefani@seibold.net:

> Grek ask me to do this in more pieces, but i will post it for a first RFC.

I've put comments into the code.

> @@ -48,8 +49,7 @@ MODULE_DEVICE_TABLE(usb, skel_table);
>  
>  /* Structure to hold all of our device specific stuff */
>  struct usb_skel {
> -	struct usb_device	*udev;			/* the usb device for this device */
> -	struct usb_interface	*interface;		/* the interface for this device */
> +	struct usb_device	*udev;			/* the usb device */

???

>  	struct semaphore	limit_sem;		/* limiting the number of writes in progress */
>  	struct usb_anchor	submitted;		/* in case we need to retract our submissions */
>  	struct urb		*bulk_in_urb;		/* the urb to read data with */
> @@ -62,15 +62,19 @@ struct usb_skel {
>  	int			errors;			/* the last request tanked */
>  	bool			ongoing_read;		/* a read is going on */
>  	bool			processed_urb;		/* indicates we haven't processed the urb */
> +	bool			connected;		/* connected flag */
> +	bool			in_use;			/* in use flag */
>  	spinlock_t		err_lock;		/* lock for errors */
>  	struct kref		kref;
> -	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
> +	struct mutex		io_mutex;		/* synchronize I/O */
>  	struct completion	bulk_in_completion;	/* to wait for an ongoing read */
>  };
>  #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
>  
>  static struct usb_driver skel_driver;
> -static void skel_draw_down(struct usb_skel *dev);
> +
> +/* synchronize open/release with disconnect */
> +static DEFINE_MUTEX(sync_mutex);
>  
>  static void skel_delete(struct kref *kref)
>  {
> @@ -86,15 +90,13 @@ static int skel_open(struct inode *inode, struct file *file)
>  {
>  	struct usb_skel *dev;
>  	struct usb_interface *interface;
> -	int subminor;
> -	int retval = 0;
> +	int retval;
>  
> -	subminor = iminor(inode);
> +	/* lock against skel_disconnect() */
> +	mutex_lock(&sync_mutex);
>  
> -	interface = usb_find_interface(&skel_driver, subminor);
> +	interface = usb_find_interface(&skel_driver, iminor(inode));
>  	if (!interface) {
> -		pr_err("%s - error, can't find device for minor %d\n",
> -			__func__, subminor);
>  		retval = -ENODEV;
>  		goto exit;
>  	}
> @@ -105,52 +107,61 @@ static int skel_open(struct inode *inode, struct file *file)
>  		goto exit;
>  	}
>  
> -	/* increment our usage count for the device */
> -	kref_get(&dev->kref);
> -
> -	/* lock the device to allow correctly handling errors
> -	 * in resumption */
> -	mutex_lock(&dev->io_mutex);
> +	if (dev->in_use) {
> +		retval = -EBUSY;
> +		goto exit;
> +	}

For an example driver we don't want exclusive open by default.
>
>  	retval = usb_autopm_get_interface(interface);
>  	if (retval)
> -		goto out_err;
> +		goto exit;
> +
> +	/* increment our usage count for the device */
> +	kref_get(&dev->kref);
> +
> +	dev->in_use = true;
> +	mutex_unlock(&sync_mutex);
>  
>  	/* save our object in the file's private structure */
>  	file->private_data = dev;
> -	mutex_unlock(&dev->io_mutex);
> -
> +	return 0;
>  exit:
> +	mutex_unlock(&sync_mutex);
>  	return retval;
>  }


>  static void skel_read_bulk_callback(struct urb *urb)
>  {
>  	struct usb_skel *dev;
> @@ -179,7 +195,7 @@ static void skel_read_bulk_callback(struct urb *urb)
>  		if (!(urb->status == -ENOENT ||
>  		    urb->status == -ECONNRESET ||
>  		    urb->status == -ESHUTDOWN))
> -			dev_err(&dev->interface->dev,
> +			dev_err(&urb->dev->dev,
>  				"%s - nonzero write bulk status received: %d\n",
>  				__func__, urb->status);
>  
> @@ -187,7 +203,7 @@ static void skel_read_bulk_callback(struct urb *urb)
>  	} else {
>  		dev->bulk_in_filled = urb->actual_length;
>  	}
> -	dev->ongoing_read = 0;
> +	dev->ongoing_read = false;

And here we have a very subtle SMP race
which can be seen only in another place.

>  	spin_unlock(&dev->err_lock);
>  
>  	complete(&dev->bulk_in_completion);
> @@ -195,7 +211,7 @@ static void skel_read_bulk_callback(struct urb *urb)
>  

>  static ssize_t skel_read(struct file *file, char *buffer, size_t count,
>  			 loff_t *ppos)
>  {
> -	struct usb_skel *dev;
> -	int rv;
> -	bool ongoing_io;
> -
> -	dev = file->private_data;
> +	struct usb_skel *dev = file->private_data;
> +	int retval;
>  
>  	/* if we cannot read at all, return EOF */
>  	if (!dev->bulk_in_urb || !count)
>  		return 0;
>  
>  	/* no concurrent readers */
> -	rv = mutex_lock_interruptible(&dev->io_mutex);
> -	if (rv < 0)
> -		return rv;
> +	if (file->f_flags & O_NONBLOCK) {
> +		if (!mutex_trylock(&dev->io_mutex))
> +			return -EAGAIN;
> +	} else {
> +		retval = mutex_lock_interruptible(&dev->io_mutex);
> +		if (retval < 0)
> +			return retval;
> +	}
>  
> -	if (!dev->interface) {		/* disconnect() was called */
> -		rv = -ENODEV;
> +	if (!dev->connected) {		/* disconnect() was called */
> +		retval = -ENODEV;
>  		goto exit;
>  	}
>  
>  	/* if IO is under way, we must not touch things */
>  retry:
> -	spin_lock_irq(&dev->err_lock);
> -	ongoing_io = dev->ongoing_read;
> -	spin_unlock_irq(&dev->err_lock);
> -
> -	if (ongoing_io) {
> +	if (dev->ongoing_read) {
>  		/* nonblocking IO shall not wait */
>  		if (file->f_flags & O_NONBLOCK) {
> -			rv = -EAGAIN;
> +			retval = -EAGAIN;
>  			goto exit;
>  		}
>  		/*
>  		 * IO may take forever
>  		 * hence wait in an interruptible state
>  		 */
> -		rv = wait_for_completion_interruptible(&dev->bulk_in_completion);
> -		if (rv < 0)
> +		retval = wait_for_completion_interruptible(&dev->bulk_in_completion);
> +		if (retval < 0)
>  			goto exit;
>  		/*
>  		 * by waiting we also semiprocessed the urb
> @@ -288,12 +298,12 @@ retry:
>  	}
>  
>  	/* errors must be reported */
> -	rv = dev->errors;
> -	if (rv < 0) {
> +	retval = dev->errors;

And here we hit the race pointed out above. And this one is for the
gourmets of races. On some architectures we are hitting a memory
ordering race here.

You cannot be sure that dev->errors is valid if ongoing_read == false
because there is no locking involved. The CPU on which the interrupt handler
has run may have scheduled the write to ongoing_read before the write
to dev->error and you can run into the window.

You must use smp_wmb() between the writes and smp_rmb() between
the reads.

(And Greg will come after me for this suggestion and wield his canoo as a cudgel)

> +	if (retval < 0) {
>  		/* any error is reported once */
>  		dev->errors = 0;
> -		/* to preserve notifications about reset */
> -		rv = (rv == -EPIPE) ? rv : -EIO;
> +		/* to preseretvale notifications about reset */
> +		retval = (retval == -EPIPE) ? retval : -EIO;
>  		/* no data to deliver */
>  		dev->bulk_in_filled = 0;
>  		/* report it */
> @@ -315,8 +325,8 @@ retry:
>  			 * all data has been used
>  			 * actual IO needs to be done
>  			 */
> -			rv = skel_do_read_io(dev, count);
> -			if (rv < 0)
> +			retval = skel_do_read_io(dev, count);
> +			if (retval < 0)
>  				goto exit;
>  			else
>  				goto retry;
> @@ -329,9 +339,9 @@ retry:
>  		if (copy_to_user(buffer,
>  				 dev->bulk_in_buffer + dev->bulk_in_copied,
>  				 chunk))
> -			rv = -EFAULT;
> +			retval = -EFAULT;
>  		else
> -			rv = chunk;
> +			retval = chunk;
>  
>  		dev->bulk_in_copied += chunk;
>  
> @@ -343,16 +353,16 @@ retry:
>  			skel_do_read_io(dev, count - chunk);
>  	} else {
>  		/* no data in the buffer */
> -		rv = skel_do_read_io(dev, count);
> -		if (rv < 0)
> +		retval = skel_do_read_io(dev, count);
> +		if (retval < 0)
>  			goto exit;
>  		else if (!(file->f_flags & O_NONBLOCK))
>  			goto retry;
> -		rv = -EAGAIN;
> +		retval = -EAGAIN;
>  	}
>  exit:
>  	mutex_unlock(&dev->io_mutex);
> -	return rv;
> +	return retval;
>  }
>  

	Regards
		Oliver
