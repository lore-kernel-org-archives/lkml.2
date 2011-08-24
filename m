Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1HXUpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:45:43 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38029 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab1HXUpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:45:40 -0400
X-Sasl-enc: ++yS1Wh2O6GXRQdz06tOmTi0YDhVs9DY3tDaPsJcaHSA 1314218740
Date: Wed, 24 Aug 2011 13:45:33 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Add USBDEVFS_TRY_DISCONNECT ioctl
Message-ID: <20110824204533.GA19618@kroah.com>
References: <20110821164108.GC6229@kroah.com>
 <Pine.LNX.4.44L0.1108241612590.1643-200000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1108241612590.1643-200000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 04:32:31PM -0400, Alan Stern wrote:
> Okay, here's a sample patch.  Actually it's three patches, listed one 
> after another, but people can apply it like a single patch.
> 
>      1.	Introduce the USBDEVFS_TRY_DISCONNECT ioctl and the check_busy
> 	callback it uses.  Implement the callback in the usbfs driver; 
> 	this gives a way for programs to unbind kernel drivers without
> 	unbinding other userspace drivers.
> 
>      2.	Implement device-file reference tracking in the SCSI layer,
> 	and the device_open and device_close callbacks it uses.

Does this handle if the filesystem is being created or fscked, as it's
not mounted at that time.

> @@ -1647,9 +1653,16 @@ static int proc_ioctl(struct dev_state *
>  	else switch (ctl->ioctl_code) {
>  
>  	/* disconnect kernel driver from interface */
> +	case USBDEVFS_TRY_DISCONNECT:
>  	case USBDEVFS_DISCONNECT:
>  		if (intf->dev.driver) {
>  			driver = to_usb_driver(intf->dev.driver);
> +			if (ctl->ioctl_code == USBDEVFS_TRY_DISCONNECT &&
> +					driver->check_busy) {
> +				retval = driver->check_busy(intf);
> +				if (retval)
> +					break;
> +			}

I don't like the fact that if a driver doesn't contain check_busy() then
it will automatically fall back to looking like it was a DISCONNECT
call, which could give userspace a false sense of "everything was fine"
when trying this out.

Why not fail if that callback is not present?


I can't comment on the scsi layer, but what about devices that don't use
scsi?  Like "raw" block drivers?

thanks,

greg k-h
