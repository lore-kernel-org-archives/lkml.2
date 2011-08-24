Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1HXVfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:35:04 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46726 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791Ab1HXVfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:35:01 -0400
X-Sasl-enc: qjqstfYyhLyhByQmkJpEY0pmsZafNmKT55rnFbthUcc5 1314221700
Date: Wed, 24 Aug 2011 14:34:33 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Add USBDEVFS_TRY_DISCONNECT ioctl
Message-ID: <20110824213433.GA16970@kroah.com>
References: <20110824204533.GA19618@kroah.com>
 <Pine.LNX.4.44L0.1108241707110.1643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1108241707110.1643-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 05:18:57PM -0400, Alan Stern wrote:
> On Wed, 24 Aug 2011, Greg KH wrote:
> 
> > On Wed, Aug 24, 2011 at 04:32:31PM -0400, Alan Stern wrote:
> > > Okay, here's a sample patch.  Actually it's three patches, listed one 
> > > after another, but people can apply it like a single patch.
> > > 
> > >      1.	Introduce the USBDEVFS_TRY_DISCONNECT ioctl and the check_busy
> > > 	callback it uses.  Implement the callback in the usbfs driver; 
> > > 	this gives a way for programs to unbind kernel drivers without
> > > 	unbinding other userspace drivers.
> > > 
> > >      2.	Implement device-file reference tracking in the SCSI layer,
> > > 	and the device_open and device_close callbacks it uses.
> > 
> > Does this handle if the filesystem is being created or fscked, as it's
> > not mounted at that time.
> 
> Yes, because the device file is held open by mkfs or fsck.  You can 
> test this easily enough, in a nondestructive way, by using this little 
> shell script:
> 
> 	echo -n 'Press RETURN to continue... '
> 	read </dev/tty
> 
> Stick that in a file, and run the file with input redirected to the 
> appropriate /dev/sd? file.

Ok, good, just wondering.

> > > @@ -1647,9 +1653,16 @@ static int proc_ioctl(struct dev_state *
> > >  	else switch (ctl->ioctl_code) {
> > >  
> > >  	/* disconnect kernel driver from interface */
> > > +	case USBDEVFS_TRY_DISCONNECT:
> > >  	case USBDEVFS_DISCONNECT:
> > >  		if (intf->dev.driver) {
> > >  			driver = to_usb_driver(intf->dev.driver);
> > > +			if (ctl->ioctl_code == USBDEVFS_TRY_DISCONNECT &&
> > > +					driver->check_busy) {
> > > +				retval = driver->check_busy(intf);
> > > +				if (retval)
> > > +					break;
> > > +			}
> > 
> > I don't like the fact that if a driver doesn't contain check_busy() then
> > it will automatically fall back to looking like it was a DISCONNECT
> > call, which could give userspace a false sense of "everything was fine"
> > when trying this out.
> > 
> > Why not fail if that callback is not present?
> 
> It could be made to work that way.  I had to choose, so I chose to make
> TRY_DISCONNECT work like DISCONNECT when the callback was missing.
> Doing it as you suggest might be better though, because then the user
> program could decide what to do if the kernel driver doesn't support
> TRY_DISCONNECT.
> 
> What would be a good error code for that case?  -EOPNOTSUPP?  Or the 
> traditional -ENOTTY?

-ENOTTY is the correct thing here.

> > I can't comment on the scsi layer, but what about devices that don't use
> > scsi?  Like "raw" block drivers?
> 
> You mean things like Pete Zaitcev's ub driver?  They would need an
> equivalent change.

Ok, and if we return the correct error code, as shown above, if the
TRY_DISCONNECT was not there, then userspace could fall back on the
"what do I do now?" logic.

If you can get the scsi people to accept that part, I'll take the usb
portion, nice job.

greg k-h
