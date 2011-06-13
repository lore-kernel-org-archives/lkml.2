Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1FMRtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:49:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab1FMRto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:49:44 -0400
Message-ID: <4DF64DD3.8070106@redhat.com>
Date: Mon, 13 Jun 2011 19:50:11 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Unbinding drivers for resources that are in use
References: <Pine.LNX.4.44L0.1106131048080.1983-100000@iolanthe.rowland.org> <20110613154218.GA32124@kroah.com>
In-Reply-To: <20110613154218.GA32124@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/13/2011 05:42 PM, Greg KH wrote:
> On Mon, Jun 13, 2011 at 11:10:57AM -0400, Alan Stern wrote:
>> The kernel prevents modules from being unloaded if they are being used.
>> But it doesn't have any analogous mechanism for preventing a driver
>> being unbound from a device that's in use.
>>
>> For example, suppose a SATA disk contains a mounted filesystem.  If the
>> user writes the corresponding device name to
>> /sys/bus/scsi/drivers/sd/unbind without unmounting the filesystem, the
>> drive will become inaccessible and data may be lost.  The same problem
>> arises with USB devices and programs using usbfs to unbind a device
>> from its kernel driver.
>>
>> It's true that the "unbind" attribute has mode 0200 and therefore can
>> be written only by the superuser.  Still, this puts the onus on
>> userspace to determine whether or not a device is being used.  The
>> kernel could easily keep track of this automatically and atomically
>> -- userspace can't do this without races.
>>
>> Therefore I'm asking if the driver core should add a refcount to every
>> struct device for keeping track of the number of open file references
>> (or other types of resource) using this device.  If this number is
>> nonzero, the kernel should prevent the device from being unbound from
>> its driver -- except of course in cases where the device has been
>> hot-unplugged; there's nothing we can do to prevent errors when this
>> happens.
>>
>> Changes to the refcount would have to propagate up the device tree: If
>> a device holds an important resource then we don't want any of the
>> device's ancestors to become inaccessible either.  This would be easy
>> to implement.
>>
>> Should we do it?
>
> No, people are starting to use 'unbind' as a poor-man's verison of
> revoke(), by simulating the device removal from the driver, even if the
> device is being used by someone at that point in time.
>
> And that's a good thing, as that is what revoke() really wants to do,
> you want to clean up whatever that device was doing and make the file
> handles stale, and allow a different user to then connect to the device
> if needed.
>
> So I really would not want to disallow this type of functionality, which
> adding reference counts and preventing unbind from working would cause.

Allow me to clarify things a bit. Alan's mail is based on a previous
discussion on the usb-list. What I suggested there is to not change the
unbind semantics, but instead add a try_unbind or some such function
which would allow userspace to request an unbind, and only have it
success if the device is not in use,  this would still require some sort
of "device in use" tracking, but that would not block the current
existing unbind.

I have a in my mind very clear cut use case for this, redirection of
usb devices from the host to a vm, this is currently supported by
at least vmware, virtualbox and qemu(-kvm). Currently these vm
providers do usb redirection by simply unbinding the current driver,
in case of vmware and virtualbox the user can do this with a single
click.

However this is not always a good thing, if the usb device in question
is a storage devices and writes are still pending (or some app has files
open on the mount of the device), the IMHO correct thing to happen
would be for the user to a get a "Sorry the device is busy" dialog
box rather then getting potential fs corruption / a crashing app.

Likewise if the usb device is a printer a printjob is currently being
spooled, we don't want the usblp driver to get unbind halfway through
the job, etc.

My initial proposal was to add a new usbfs_try_disconnect ioctl for
interfaces, and a new usb driver callback for this, which then for
example the usb-storage driver could implement.

Alan correctly pointed out that adding a driver callback to the
usb mass storage driver which checks if disconnecting is ok, is
currently not possible, because there is no such thing as device
busy tracking. There is module busy tracking, but that only tracks
if of any usb-storage linked disks are mounted, not a single
device.

Regards,

Hans
