Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2FHNqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:46:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36331 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756775Ab2FHNqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:46:04 -0400
Date: Fri, 8 Jun 2012 09:46:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, <oneukum@suse.de>,
        <alan@lxorguk.ukuu.org.uk>, <linux-usb@vger.kernel.org>
Subject: Re: RFC: remove usb_device pointer from usb_skeleton.c
In-Reply-To: <1339139935.16819.5.camel@wall-e>
Message-ID: <Pine.LNX.4.44L0.1206080943170.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012, Stefani Seibold wrote:

> Hi,
> 
> what do you think about this solution for removing the usb_device
> pointer from the struct usb_skel in the usb_skeleton driver?

There's nothing wrong with keeping the pointer there.  Why do you want 
to remove it?

> @@ -73,9 +73,12 @@ static struct usb_driver skel_driver;
>  static void skel_delete(struct kref *kref)
>  {
>  	struct usb_skel *dev = to_skel_dev(kref);
> +	struct usb_interface *interface = dev->interface;
> +	struct usb_device *udev = usb_get_dev(interface_to_usbdev(interface));
>  
>  	usb_free_urb(dev->bulk_in_urb);
> -	usb_put_dev(dev->udev);
> +	usb_put_dev(udev);

On the other hand, this usb_put_dev call is useless.  Why do you want 
to keep it?

> +	usb_put_intf(interface);

If you get rid of the usb_put_dev then this call is also useless.

>  	kfree(dev->bulk_in_buffer);
>  	kfree(dev);
>  }
> @@ -128,7 +131,7 @@ static int skel_release(struct inode *inode, struct file *file)
>  
>  	/* allow the device to be autosuspended */
>  	mutex_lock(&dev->io_mutex);
> -	if (dev->interface)
> +	if (dev->connected)

There's nothing really wrong with adding a "disconnected" flag.  But 
setting dev->interface to NULL works just as well, in my opinion.  It's 
a matter of taste.

Alan Stern

