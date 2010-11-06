Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab0KFSci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:32:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38325 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751828Ab0KFScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:32:36 -0400
Date: Sat, 6 Nov 2010 14:32:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>,
        Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC PATCH 1/5] usb-hcd: implement polling a specific usb device
In-Reply-To: <1288983906-31129-2-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1011061422080.28403-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010, Jason Wessel wrote:

> This patch adds a generic capability to poll a specific usb device and
> run its completion handler.
> 
> There will be two users of this functionality.
>  1) usb serial port console devices
>  2) usb keyboards for use with kdb
> 
> Any time the usb_irq_poll() function is called it has the possibility
> to queue some urbs for completion at a later time.  Any code that uses
> the usb_irq_poll() function must call usb_poll_irq_schedule_flush()
> before all the other usb devices will start working again.

...

> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c

> @@ -1562,6 +1567,17 @@ void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb, int status)
>  
>  	/* pass ownership to the completion handler */
>  	urb->status = status;
> +	if (unlikely(usb_poll_hcd_device)) {
> +		/*
> +		 * Any other device than the one being polled should get
> +		 * queued for a later flush.
> +		 */
> +		if (usb_poll_hcd_device != urb->dev) {
> +			INIT_LIST_HEAD(&urb->poll_list);

Why initialize the list_head here if the next line is going to 
overwrite it?

> +			list_add(&urb->poll_list, &delayed_usb_complete_queue);

You need to use list_add_tail, not list_add.  This is supposed to be a 
queue, not a LIFO stack.

> +			return;
> +		}
> +	}
>  	urb->complete (urb);
>  	atomic_dec (&urb->use_count);
>  	if (unlikely(atomic_read(&urb->reject)))
> @@ -2425,6 +2441,47 @@ usb_hcd_platform_shutdown(struct platform_device* dev)
>  }
>  EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
>  
> +void usb_poll_irq(struct usb_device *udev)
> +{

Please add a little kerneldoc explaining what this function does and 
why it is here.  Also mention that it must be called with interrupts 
disabled.

> +	struct usb_hcd *hcd;
> +
> +	hcd = bus_to_hcd(udev->bus);
> +	usb_poll_hcd_device = udev;
> +	usb_hcd_irq(0, hcd);
> +	usb_poll_hcd_device = NULL;
> +}
> +EXPORT_SYMBOL_GPL(usb_poll_irq);
> +
> +static void usb_poll_irq_flush_helper(struct work_struct *dummy)
> +{
> +	struct urb *urb;
> +	struct urb *scratch;
> +	unsigned long flags;
> +
> +	mutex_lock(&usb_poll_irq_flush_mutex);

What is this mutex used for?

> +	local_irq_save(flags);

Isn't this function meant to be called with interrupts disabled on all 
CPUs anyway?

> +	list_for_each_entry_safe(urb, scratch, &delayed_usb_complete_queue,
> +				 poll_list) {
> +		list_del(&urb->poll_list);
> +		urb->complete(urb);
> +		atomic_dec(&urb->use_count);
> +		if (unlikely(atomic_read(&urb->reject)))
> +			wake_up(&usb_kill_urb_queue);
> +		usb_put_urb(urb);
> +	}
> +	local_irq_restore(flags);
> +	mutex_unlock(&usb_poll_irq_flush_mutex);
> +}
> +
> +static DECLARE_WORK(usb_poll_irq_flush_work, usb_poll_irq_flush_helper);
> +
> +
> +void usb_poll_irq_schedule_flush(void)
> +{
> +	schedule_work(&usb_poll_irq_flush_work);
> +}
> +EXPORT_SYMBOL_GPL(usb_poll_irq_schedule_flush);

Why do you want to do this in a workqueue?  Just move all the code from 
usb_poll_irq_flush_helper over here directly.


> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h

> @@ -1188,6 +1192,7 @@ struct urb {
>  	struct list_head urb_list;	/* list head for use by the urb's
>  					 * current owner */
>  	struct list_head anchor_list;	/* the URB may be anchored */
> +	struct list_head poll_list;	/* Added to the poll queue */
>  	struct usb_anchor *anchor;
>  	struct usb_device *dev;		/* (in) pointer to associated device */
>  	struct usb_host_endpoint *ep;	/* (internal) pointer to endpoint */

You don't need to add an additional list_head to struct urb -- it
already contains too much stuff.  Simply use urb_list; that's what it's
for.

Alan Stern

