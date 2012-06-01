Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2FAOT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:19:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab2FAOT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:19:56 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH] add new NRP power meter USB device driver
Date: Fri, 1 Jun 2012 16:16:36 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, gregkh@linuxfoundation.org,
        thomas.braunstorfinger@rohde-schwarz.com
References: <1338318858-24144-1-git-send-email-stefani@seibold.net> <201205311020.50076.oneukum@suse.de> <1338456100.6454.82.camel@wall-e>
In-Reply-To: <1338456100.6454.82.camel@wall-e>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206011616.36284.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 31. Mai 2012, 11:21:40 schrieb Stefani Seibold:
> On Thu, 2012-05-31 at 10:20 +0200, Oliver Neukum wrote:
> 
> > > > 
> > > > > +		if (arg) {
> > > > > +			ret = wait_event_interruptible_timeout(
> > > > > +				dev->out_running.wait,
> > > > > +				list_empty(&dev->out_running.urb_list),
> > > > > +				msecs_to_jiffies(arg));
> > > > > +			if (!ret)
> > > > > +				return -ETIMEDOUT;
> > > > > +			if (ret < 0)
> > > > > +				return ret;
> > > > > +			return 0;
> > > > > +		} else {
> > > > > +			return wait_event_interruptible(
> > > > > +				dev->out_running.wait,
> > > > > +				list_empty(&dev->out_running.urb_list));
> > > > > +		}
> > > > > +		break;
> > > > 
> > > > This is very ugly. If you need fsync(), then implement it.
> > > > 
> > > 
> > > fsync() did not meat the requirements, since i need in some case a
> > > timeout for the device. poll() will also not help, since it signals only
> > > that there is space to write.
> > 
> > Well, then implement fsync() with interruptible sleep and use a timer
> > in user space.
> > 
> 
> But this will not solve the problem of older software which is still
> depending on this ioctl.

Yes. I guess it might be included in a depreated form. However
a sane alternative must be provided.

> > Yes, but this seems to be buggy:
> > 
> > +	ret = usb_submit_urb(urb, GFP_KERNEL);
> > +	if (ret) {
> > +		usb_unanchor_urb(urb);
> > +		urb_list_add_tail(&dev->read_lock, urb, &dev->in_avail);
> > +		nrpz_err("Failed submitting read urb (error %d)", ret);
> > +	}
> > 
> > You have already transfered the data to user space. It seems to me that you
> > need to zero out the URB and need to handle the case of getting an URB
> > without data.
> > 
> 
> Okay, i understand what you mean. Zeroing out is not necessary since
> usb_submit_urb will set urb->status to -EINPROGRESS. This behavior is
> well documented.
> 

Look more closely at the code:

int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
{
        int                             xfertype, max;
        struct usb_device               *dev;
        struct usb_host_endpoint        *ep;
        int                             is_out;

        if (!urb || urb->hcpriv || !urb->complete)
                return -EINVAL;
        dev = urb->dev;
        if ((!dev) || (dev->state < USB_STATE_UNAUTHENTICATED))
                return -ENODEV;

        /* For now, get the endpoint from the pipe.  Eventually drivers
         * will be required to set urb->ep directly and we will eliminate
         * urb->pipe.
         */
        ep = usb_pipe_endpoint(dev, urb->pipe);
        if (!ep)
                return -ENOENT;

        urb->ep = ep;
        urb->status = -EINPROGRESS;
        urb->actual_length = 0;

There are a few error conditions where this is not true.


> > There probably is no generic answer. But I presume a reset will
> > reinit the device and destroy anything you set up before, so I guess
> > the next read() or write() after a reset has to return an error code that
> > tells user space that it has to redo its setup.
> > 
> 
> Is it okay to kick out the whole ..._reset() thing, since i have no idea
> what it is good for.

That's an option. Users will get -ENODEV.

	Regards
		Oliver
