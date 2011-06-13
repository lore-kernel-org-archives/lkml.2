Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1FMTPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:15:52 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37748 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569Ab1FMTPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:15:51 -0400
X-Sasl-enc: iHTPgEjVv7q1MJjAmuX9/3goKLwKlSRWRnnQEuwuZdWi 1307992550
Date: Mon, 13 Jun 2011 12:15:16 -0700
From: Greg KH <greg@kroah.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Unbinding drivers for resources that are in use
Message-ID: <20110613191516.GA5511@kroah.com>
References: <Pine.LNX.4.44L0.1106131048080.1983-100000@iolanthe.rowland.org>
 <20110613154218.GA32124@kroah.com>
 <4DF64DD3.8070106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF64DD3.8070106@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 07:50:11PM +0200, Hans de Goede wrote:
> Allow me to clarify things a bit. Alan's mail is based on a previous
> discussion on the usb-list. What I suggested there is to not change the
> unbind semantics, but instead add a try_unbind or some such function
> which would allow userspace to request an unbind, and only have it
> success if the device is not in use,  this would still require some sort
> of "device in use" tracking, but that would not block the current
> existing unbind.

Yes, I was part of that discussion and remember it well.  I still don't
think this is a good idea :)

> I have a in my mind very clear cut use case for this, redirection of
> usb devices from the host to a vm, this is currently supported by
> at least vmware, virtualbox and qemu(-kvm). Currently these vm
> providers do usb redirection by simply unbinding the current driver,
> in case of vmware and virtualbox the user can do this with a single
> click.

Understood.

> However this is not always a good thing, if the usb device in question
> is a storage devices and writes are still pending (or some app has files
> open on the mount of the device), the IMHO correct thing to happen
> would be for the user to a get a "Sorry the device is busy" dialog
> box rather then getting potential fs corruption / a crashing app.

And they can get just such a dialog box if the userspace program decides
to actually check to see if the device is in use before it does this.
There is nothing keeping that from happening today, why do we need to
rework the kernel internals to provide this right now?

> Likewise if the usb device is a printer a printjob is currently being
> spooled, we don't want the usblp driver to get unbind halfway through
> the job, etc.

True, but remember, the printer spooler always keeps the device node
open, so you never know if a job is being sent or not.

And even if you did know, what's to keep it from starting up inbetween
asking if it is idle and doing the disconnect if the device node is
always open?  Same goes for sound devices and lots of other types of
devices.

> My initial proposal was to add a new usbfs_try_disconnect ioctl for
> interfaces, and a new usb driver callback for this, which then for
> example the usb-storage driver could implement.
> 
> Alan correctly pointed out that adding a driver callback to the
> usb mass storage driver which checks if disconnecting is ok, is
> currently not possible, because there is no such thing as device
> busy tracking. There is module busy tracking, but that only tracks
> if of any usb-storage linked disks are mounted, not a single
> device.

Yeah, and I think you would get lost down in the scsi and block code if
you were to try to implement something like this within the kernel.

Again, userspace knows all of this information today, and can decide to
unbind the device or not based on it.  Why does the kernel have to be
the one tracking all of it?  Especially as the policy will depend on the
different type of device to be able to determine if it is safe to unbind
or not.

thanks,

greg k-h
