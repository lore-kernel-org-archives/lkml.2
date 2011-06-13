Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1FMPme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:42:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46934 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126Ab1FMPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:42:31 -0400
X-Sasl-enc: 6GE1Yonfmzf6n14ae7XwE2euYXSMeieXxVY48QM3z5Nm 1307979750
Date: Mon, 13 Jun 2011 08:42:18 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: Unbinding drivers for resources that are in use
Message-ID: <20110613154218.GA32124@kroah.com>
References: <Pine.LNX.4.44L0.1106131048080.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106131048080.1983-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 11:10:57AM -0400, Alan Stern wrote:
> The kernel prevents modules from being unloaded if they are being used.  
> But it doesn't have any analogous mechanism for preventing a driver 
> being unbound from a device that's in use.
> 
> For example, suppose a SATA disk contains a mounted filesystem.  If the
> user writes the corresponding device name to
> /sys/bus/scsi/drivers/sd/unbind without unmounting the filesystem, the
> drive will become inaccessible and data may be lost.  The same problem
> arises with USB devices and programs using usbfs to unbind a device
> from its kernel driver.
> 
> It's true that the "unbind" attribute has mode 0200 and therefore can 
> be written only by the superuser.  Still, this puts the onus on 
> userspace to determine whether or not a device is being used.  The 
> kernel could easily keep track of this automatically and atomically 
> -- userspace can't do this without races.
> 
> Therefore I'm asking if the driver core should add a refcount to every
> struct device for keeping track of the number of open file references
> (or other types of resource) using this device.  If this number is
> nonzero, the kernel should prevent the device from being unbound from
> its driver -- except of course in cases where the device has been
> hot-unplugged; there's nothing we can do to prevent errors when this
> happens.
> 
> Changes to the refcount would have to propagate up the device tree: If 
> a device holds an important resource then we don't want any of the 
> device's ancestors to become inaccessible either.  This would be easy 
> to implement.
> 
> Should we do it?

No, people are starting to use 'unbind' as a poor-man's verison of
revoke(), by simulating the device removal from the driver, even if the
device is being used by someone at that point in time.

And that's a good thing, as that is what revoke() really wants to do,
you want to clean up whatever that device was doing and make the file
handles stale, and allow a different user to then connect to the device
if needed.

So I really would not want to disallow this type of functionality, which
adding reference counts and preventing unbind from working would cause.

thanks,

greg k-h
