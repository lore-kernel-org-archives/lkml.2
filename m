Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2FCFPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 01:15:09 -0400
Received: from www84.your-server.de ([213.133.104.84]:37002 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2FCFPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 01:15:07 -0400
Message-ID: <1338700522.4801.8.camel@wall-e>
Subject: Re: [PATCH] add new NRP power meter USB device driver
From: Stefani Seibold <stefani@seibold.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, thomas.braunstorfinger@rohde-schwarz.com
Date: Sun, 03 Jun 2012 07:15:22 +0200
In-Reply-To: <201206022224.21443.oliver@neukum.org>
References: <1338653939-2090-1-git-send-email-stefani@seibold.net>
	 <201206022224.21443.oliver@neukum.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 02.06.2012, 22:24 +0200 schrieb Oliver Neukum:
> Am Samstag, 2. Juni 2012, 18:18:59 schrieb stefani@seibold.net:
> > +static int bulks_in_submit(struct usb_nrpz *dev)
> > +{
> > +	int ret;
> > +	unsigned i;
> > +
> > +	for (i = 0; i != ARRAY_SIZE(dev->in_urbs); ++i) {
> > +		usb_anchor_urb(&dev->in_urbs[i], &dev->in_running);
> > +
> > +		ret = usb_submit_urb(&dev->in_urbs[i], GFP_KERNEL);
> > +		if (ret) {
> > +			usb_kill_anchored_urbs(&dev->in_running);
> > +			return ret;
> > +		}
> > +	}
> > +	return 0;
> > +}
> 
> This is used in the resume code path. During resume you
> cannot swap, as the swap device may still be asleep.
> Therefore GFP_NOIO should be used. It's considered
> best practice to pass the gfp parameter to such methods.
> 

Good point. Fixed.
 
> > +static ssize_t nrpz_read(struct file *file, char __user *buffer, size_t count,
> > +				loff_t *ppos)
> > +{
> > +	struct usb_nrpz *dev = file->private_data;
> > +	int ret;
> > +	struct urb *urb;
> > +	size_t n;
> > +
> > +	/* verify that we actually have some data to read */
> > +	if (!count)
> > +		return 0;
> > +
> > +	/* lock the read data */
> > +	if (file->f_flags & O_NONBLOCK) {
> > +		if (!mutex_trylock(&dev->read_mutex))
> > +			return -EAGAIN;
> 
> Congratulations. I overlooked this. Does skeleton do it right?
> 

This issue was reported by Alan Cox. Skeleton must be also fixed.
 
> > +	} else {
> > +		ret = mutex_lock_interruptible(&dev->read_mutex);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	for (;;) {
> > +		urb = urb_list_get(&dev->read_lock, &dev->in_avail);
> > +		if (urb)
> > +			break;
> > +
> > +		/* verify that the device wasn't unplugged */
> > +		if (!dev->connected) {
> > +			ret = -ENODEV;
> > +			goto exit;
> > +		}
> > +
> > +		if (file->f_flags & O_NONBLOCK) {
> > +			ret = -EAGAIN;
> > +			goto exit;
> > +		}
> > +
> > +		ret = wait_event_interruptible(dev->wq,
> > +			!list_empty(&dev->in_avail) || !dev->connected);
> > +		if (ret) {
> > +			ret = -ERESTARTSYS;
> > +			goto exit;
> > +		}
> > +	}
> > +
> > +	if (!urb->status) {
> > +		n = min(count, urb->actual_length);
> > +
> > +		if (copy_to_user(buffer, urb->transfer_buffer, n)) {
> > +			urb_list_add(&dev->read_lock, urb, &dev->in_avail);
> > +			ret = -EFAULT;
> > +			goto exit;
> > +		}
> > +	} else {
> > +		n = -EPIPE;
> > +	}
> > +
> > +	usb_anchor_urb(urb, &dev->in_running);
> > +
> > +	ret = usb_submit_urb(urb, GFP_KERNEL);
> > +	if (ret) {
> > +		usb_unanchor_urb(urb);
> > +		urb_list_add_tail(&dev->read_lock, urb, &dev->in_avail);
> > +		urb->status = ret;
> 
> That is a bug. You will report that error the next time the URB comes up.
> That's wrong. I think you need a special error code that will cause you
> to just resubmit the URB and go for the next URB.
> 

I think it is okay to push it back to the tail of the list and the next
time i will get this URB i will report this error to the userspace. This
keeps the order of the errors. But i will do more investigation on this.

> > +	case NRPZ_GETSENSORINFO:
> > +	 {

Kick away in the next release :-(

> > +static int nrpz_release(struct inode *inode, struct file *file)
> > +{
> > +	struct usb_nrpz *dev = file->private_data;
> > +
> > +	if (dev == NULL)
> > +		return -ENODEV;
> > +
> > +	usb_kill_anchored_urbs(&dev->in_running);
> > +	usb_kill_anchored_urbs(&dev->out_running);
> 
> Isn't this a noop as you've implemented flush() ?
> 

No, it is not a noop. flush() can be interrupted and will only handle
the out_running urbs.

> > +
> > +	bulks_release(dev->out_urbs, ARRAY_SIZE(dev->out_urbs), dev->out_size);
> > +	bulks_release(dev->in_urbs, ARRAY_SIZE(dev->in_urbs), dev->in_size);
> > +
> > +	/* decrement the count on our device */
> > +	kref_put(&dev->kref, nrpz_delete);
> > +
> > +	spin_lock_irq(&dev->read_lock);
> > +	dev->in_use = false;
> > +	spin_unlock_irq(&dev->read_lock);
> 
> Looks like a use after free. You should drop the reference as the very
> last thing.
> 

Thanks. One of this nasty little tiny race conditions... 

Greetings,
Stefani


