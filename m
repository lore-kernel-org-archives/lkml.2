Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2EaIYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:24:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2EaIYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:24:11 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH] add new NRP power meter USB device driver
Date: Thu, 31 May 2012 10:20:50 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, gregkh@linuxfoundation.org,
        thomas.braunstorfinger@rohde-schwarz.com
References: <1338318858-24144-1-git-send-email-stefani@seibold.net> <201205301010.22913.oneukum@suse.de> <1338450221.6454.16.camel@wall-e>
In-Reply-To: <1338450221.6454.16.camel@wall-e>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205311020.50076.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 31. Mai 2012, 09:43:41 schrieb Stefani Seibold:
> Hi Oliver,
> 
> Thanks for the review.
> 
> On Wed, 2012-05-30 at 10:10 +0200, Oliver Neukum wrote:
> > Am Dienstag, 29. Mai 2012, 21:14:18 schrieb stefani@seibold.net:
> >  
> > > The device will be controlled by a SCPI like interface.
> > 
> > Are there other devices using that standard whose interface you might reuse?
> >  
> > 
> 
> There are a lot of instruments from many different manufacturer which
> use the SCPI standard. But there is now way to bring them together. The
> commands are well defined, but there are a lot of vendor specific
> commands. And the communication path are differing, which can be
> IEEE488, USB, Socket, Serial and more.

This is unfortunate. It would be much better if we could have a /dev/spiX
in form of a character device.

> > > +		if (copy_to_user(buffer, urb->transfer_buffer, n)) {
> > > +			urb_list_add(&dev->read_lock, urb, &dev->in_avail);
> > > +			ret = -EFAULT;
> > > +			goto exit;
> > 
> > Is there a good reason you don't resubmit in this case?
> > 
> 
> The data was not successfully transfered to the user space, so it will
> stay again on the top of the input urb list.

I see. Unusual approach, but perfectly valid.
  
> > > +static long nrpz_compat_ioctl(struct file *file, unsigned int cmd,
> > > +		unsigned long arg)
> > > +{
> > > +	struct usb_nrpz *dev;
> > > +	int ret;
> > > +
> > > +	dev = (struct usb_nrpz *)file->private_data;
> > > +
> > > +	/* verify that the device wasn't unplugged */
> > > +	if (!dev->intf)
> > > +		return -ENODEV;
> > 
> > Locking?
> > 
> 
> I see no reason why. But i will change it in the next version.

1. Multithreaded tasks
2. Check for disconnect

> > > +	case NRPZ_START:
> > > +	 {
> > > +		u8 device_state[128];
> > 
> > DMA on stack. This may ail on some architectures. You need to use
> > kmalloc() or better kzalloc().
> > 
> 
> Never heard about this problem. The driver will work since years on X86,
> PPC and ARM platforms. But it will be fixes in the next version.

On PPC you were lucky. However the window for the race is small.
In a nutshell, your buffer may share a cacheline with something else
on the stack. If you read that something else on some architectures
DMA after that will not invalidate the cache line and the CPU will see
the old content of the stack before the DMA in the buffer.

And on a few architectures (ia64, ... IIRC) the stack may be incapable
of DMA at all.
 
> > > +	case NRPZ_WRITE_DONE:
> > 
> > EEEEEEK!
> > 
> > > +		if (arg) {
> > > +			ret = wait_event_interruptible_timeout(
> > > +				dev->out_running.wait,
> > > +				list_empty(&dev->out_running.urb_list),
> > > +				msecs_to_jiffies(arg));
> > > +			if (!ret)
> > > +				return -ETIMEDOUT;
> > > +			if (ret < 0)
> > > +				return ret;
> > > +			return 0;
> > > +		} else {
> > > +			return wait_event_interruptible(
> > > +				dev->out_running.wait,
> > > +				list_empty(&dev->out_running.urb_list));
> > > +		}
> > > +		break;
> > 
> > This is very ugly. If you need fsync(), then implement it.
> > 
> 
> fsync() did not meat the requirements, since i need in some case a
> timeout for the device. poll() will also not help, since it signals only
> that there is space to write.

Well, then implement fsync() with interruptible sleep and use a timer
in user space.

> > > +
> > > +	ret = bulks_init(dev,
> > > +			 dev->out_urbs,
> > > +			 ARRAY_SIZE(dev->out_urbs),
> > > +			 usb_sndbulkpipe(dev->udev, dev->out_epAddr),
> > > +			 dev->out_size,
> > > +			 nrpz_write_callback);
> > > +	if (ret)
> > > +		goto error;
> > > +
> > > +	for (i = 0; i != ARRAY_SIZE(dev->in_urbs); ++i) {
> > > +		usb_anchor_urb(&dev->in_urbs[i], &dev->in_running);
> > > +
> > > +		ret = usb_submit_urb(&dev->in_urbs[i], GFP_KERNEL);
> > 
> > You do this here and only here. So this will see a slow attrition if you don't resubmit for som reason.
> > 
> 
> No, i resubmit the urb in the nrpz_read() function.

Yes, but this seems to be buggy:

+	ret = usb_submit_urb(urb, GFP_KERNEL);
+	if (ret) {
+		usb_unanchor_urb(urb);
+		urb_list_add_tail(&dev->read_lock, urb, &dev->in_avail);
+		nrpz_err("Failed submitting read urb (error %d)", ret);
+	}

You have already transfered the data to user space. It seems to me that you
need to zero out the URB and need to handle the case of getting an URB
without data.

> > > +static int nrpz_pre_reset(struct usb_interface *intf)
> > > +{
> > > +	struct usb_nrpz *dev = usb_get_intfdata(intf);
> > > +
> > > +	if (dev)
> > > +		nrpz_draw_down(dev);
> > > +	return 0;
> > > +}
> > > +
> > > +static int nrpz_post_reset(struct usb_interface *intf)
> > > +{
> > > +	return 0;
> > > +}
> > 
> > And you don't tell user space that the device has been reset?
> > And what restarts reading?
> > 
> 
> I have no idea how to do this. But i will have a look in the kernel
> source and figure it out.

There probably is no generic answer. But I presume a reset will
reinit the device and destroy anything you set up before, so I guess
the next read() or write() after a reset has to return an error code that
tells user space that it has to redo its setup.

	Regards
		Oliver
