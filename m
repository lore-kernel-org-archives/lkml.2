Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab2EaJV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:21:27 -0400
Received: from www84.your-server.de ([213.133.104.84]:59053 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab2EaJVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:21:24 -0400
Message-ID: <1338456100.6454.82.camel@wall-e>
Subject: Re: [PATCH] add new NRP power meter USB device driver
From: Stefani Seibold <stefani@seibold.net>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, gregkh@linuxfoundation.org,
        thomas.braunstorfinger@rohde-schwarz.com
Date: Thu, 31 May 2012 11:21:40 +0200
In-Reply-To: <201205311020.50076.oneukum@suse.de>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
	 <201205301010.22913.oneukum@suse.de> <1338450221.6454.16.camel@wall-e>
	 <201205311020.50076.oneukum@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 10:20 +0200, Oliver Neukum wrote:

> > > 
> > > > +		if (arg) {
> > > > +			ret = wait_event_interruptible_timeout(
> > > > +				dev->out_running.wait,
> > > > +				list_empty(&dev->out_running.urb_list),
> > > > +				msecs_to_jiffies(arg));
> > > > +			if (!ret)
> > > > +				return -ETIMEDOUT;
> > > > +			if (ret < 0)
> > > > +				return ret;
> > > > +			return 0;
> > > > +		} else {
> > > > +			return wait_event_interruptible(
> > > > +				dev->out_running.wait,
> > > > +				list_empty(&dev->out_running.urb_list));
> > > > +		}
> > > > +		break;
> > > 
> > > This is very ugly. If you need fsync(), then implement it.
> > > 
> > 
> > fsync() did not meat the requirements, since i need in some case a
> > timeout for the device. poll() will also not help, since it signals only
> > that there is space to write.
> 
> Well, then implement fsync() with interruptible sleep and use a timer
> in user space.
> 

But this will not solve the problem of older software which is still
depending on this ioctl.


> Yes, but this seems to be buggy:
> 
> +	ret = usb_submit_urb(urb, GFP_KERNEL);
> +	if (ret) {
> +		usb_unanchor_urb(urb);
> +		urb_list_add_tail(&dev->read_lock, urb, &dev->in_avail);
> +		nrpz_err("Failed submitting read urb (error %d)", ret);
> +	}
> 
> You have already transfered the data to user space. It seems to me that you
> need to zero out the URB and need to handle the case of getting an URB
> without data.
> 

Okay, i understand what you mean. Zeroing out is not necessary since
usb_submit_urb will set urb->status to -EINPROGRESS. This behavior is
well documented.

I checked it again, and it will work perfectly in case of an error.

And in my opinion it is safe to reuse an urb without reinitialization,
this is a common practice in the callback handlers, so i see no reason
why this should not work in the read() function.

> > > > +static int nrpz_pre_reset(struct usb_interface *intf)
> > > > +{
> > > > +	struct usb_nrpz *dev = usb_get_intfdata(intf);
> > > > +
> > > > +	if (dev)
> > > > +		nrpz_draw_down(dev);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int nrpz_post_reset(struct usb_interface *intf)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > 
> > > And you don't tell user space that the device has been reset?
> > > And what restarts reading?
> > > 
> > 
> > I have no idea how to do this. But i will have a look in the kernel
> > source and figure it out.
> 
> There probably is no generic answer. But I presume a reset will
> reinit the device and destroy anything you set up before, so I guess
> the next read() or write() after a reset has to return an error code that
> tells user space that it has to redo its setup.
> 

Is it okay to kick out the whole ..._reset() thing, since i have no idea
what it is good for.

Greetings,
Stefani


