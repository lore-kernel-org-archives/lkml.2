Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993Ab2FBF5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 01:57:21 -0400
Received: from www84.your-server.de ([213.133.104.84]:55645 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933795Ab2FBF5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 01:57:20 -0400
Message-ID: <1338616656.25409.10.camel@wall-e>
Subject: Re: [PATCH] add new NRP power meter USB device driver
From: Stefani Seibold <stefani@seibold.net>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, gregkh@linuxfoundation.org,
        thomas.braunstorfinger@rohde-schwarz.com
Date: Sat, 02 Jun 2012 07:57:36 +0200
In-Reply-To: <201206011616.36284.oneukum@suse.de>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
	 <201205311020.50076.oneukum@suse.de> <1338456100.6454.82.camel@wall-e>
	 <201206011616.36284.oneukum@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 16:16 +0200, Oliver Neukum wrote:
> Am Donnerstag, 31. Mai 2012, 11:21:40 schrieb Stefani Seibold:
> > On Thu, 2012-05-31 at 10:20 +0200, Oliver Neukum wrote:
> > 
> > > > > 
> > > > > > +		if (arg) {
> > > > > > +			ret = wait_event_interruptible_timeout(
> > > > > > +				dev->out_running.wait,
> > > > > > +				list_empty(&dev->out_running.urb_list),
> > > > > > +				msecs_to_jiffies(arg));
> > > > > > +			if (!ret)
> > > > > > +				return -ETIMEDOUT;
> > > > > > +			if (ret < 0)
> > > > > > +				return ret;
> > > > > > +			return 0;
> > > > > > +		} else {
> > > > > > +			return wait_event_interruptible(
> > > > > > +				dev->out_running.wait,
> > > > > > +				list_empty(&dev->out_running.urb_list));
> > > > > > +		}
> > > > > > +		break;
> > > > > 
> > > > > This is very ugly. If you need fsync(), then implement it.
> > > > > 
> > > > 
> > > > fsync() did not meat the requirements, since i need in some case a
> > > > timeout for the device. poll() will also not help, since it signals only
> > > > that there is space to write.
> > > 
> > > Well, then implement fsync() with interruptible sleep and use a timer
> > > in user space.
> > > 
> > 
> > But this will not solve the problem of older software which is still
> > depending on this ioctl.
> 
> Yes. I guess it might be included in a depreated form. However
> a sane alternative must be provided.
> 

I will implement the fsync() function. But your idea using an alarm
timer will break many libraries like Qt or GLIB, which depends on the
the exclusive use of the alarm timer.

I know, there is always a way to do it, but for the average coder will
create a piece of complex code, full of races and pretenses.

Also you would not believe, but most of the developer i know are not
familiar with implementing signal safe code. 

> > > Yes, but this seems to be buggy:
> > > 
> > > +	ret = usb_submit_urb(urb, GFP_KERNEL);
> > > +	if (ret) {
> > > +		usb_unanchor_urb(urb);
> > > +		urb_list_add_tail(&dev->read_lock, urb, &dev->in_avail);
> > > +		nrpz_err("Failed submitting read urb (error %d)", ret);
> > > +	}
> > > 
> > > You have already transfered the data to user space. It seems to me that you
> > > need to zero out the URB and need to handle the case of getting an URB
> > > without data.
> > > 
> > 
> > Okay, i understand what you mean. Zeroing out is not necessary since
> > usb_submit_urb will set urb->status to -EINPROGRESS. This behavior is
> > well documented.
> > 
> 
> Look more closely at the code:
> 
> int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
> {
>         int                             xfertype, max;
>         struct usb_device               *dev;
>         struct usb_host_endpoint        *ep;
>         int                             is_out;
> 
>         if (!urb || urb->hcpriv || !urb->complete)
>                 return -EINVAL;
>         dev = urb->dev;
>         if ((!dev) || (dev->state < USB_STATE_UNAUTHENTICATED))
>                 return -ENODEV;
> 
>         /* For now, get the endpoint from the pipe.  Eventually drivers
>          * will be required to set urb->ep directly and we will eliminate
>          * urb->pipe.
>          */
>         ep = usb_pipe_endpoint(dev, urb->pipe);
>         if (!ep)
>                 return -ENOENT;
> 
>         urb->ep = ep;
>         urb->status = -EINPROGRESS;
>         urb->actual_length = 0;
> 
> There are a few error conditions where this is not true.
> 

Yes, but i am not sure if this conditions will be true by an already
correct initialized urb. Anyway, i will fix it.


