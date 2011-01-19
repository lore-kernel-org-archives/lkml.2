Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1ASRHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:07:05 -0500
Received: from ixqw-mail-out.ixiacom.com ([66.77.12.12]:1210 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab1ASRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:07:03 -0500
Message-ID: <4D371A35.5000009@ixiacom.com>
Date: Wed, 19 Jan 2011 09:07:01 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: UIO  null parent for __uio_register_device and uio_device_name()
References: <4D366104.1000400@ixiacom.com> <20110119145619.GA17399@local> <4D370654.7020400@ixiacom.com> <20110119163005.GA12979@kroah.com>
In-Reply-To: <20110119163005.GA12979@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/01/2011 8:30 AM, Greg KH wrote:
>> No probing is required in this scenario.
> 
> Great, then create a platform device for your "hardware device" and you
> should be fine, right?

Greg,

I suppose so. I don't understand the need to enforce !parent
since device_create() seems to be fine with a NULL parent.

Would you explain what is to be gained by requiring !parent
at the Linux UIO level ?

>> Working on the implementation of our new system last night I realise
>> that our new configuration runs very lean, and I now do not have the
>> use of udev to populate /dev/uio[0-9].
> 
> Then what populates your other device nodes?

I believe they are fixed in the root file system (ie the major numbers
are fixed). It is also possible that /etc/rcS script does the rest with
judicious mknod invocations.

>> This new configuration runs so lean that I don't have access to sysfs.
> 
> I really find this hard to believe.  Why would you not configure sysfs
> in your system?

The needs of our hardware and application are such that one of the key system
designers told me:

	For the record, sysfs affects interface scalability in two ways: adds a 
	significant memory overhead (IIRC 300-500 bytes per interface) and slows down 
	device registration and de-registration.

>> The result is that I need to figure out the major/minor device number in
>> order to access the Linux UIO device. I will advertise this through /proc/
>> entries specific to the UIO client driver. We can then use this information
>> to mknod /dev/uio[0-9].
> 
> Heh, you have /proc/ but not /sys/?  Someone needs to move out of the
> 90's :)

LOL  Yes, I see your point.

>> I've added uio_device_chrdev() alongside uio_device_name() to allow
>> us to figure out the coordinates of the Linux UIO device.
> 
> Ick, no, please use the sysfs files that are alredy present for such a
> thing, don't reinvent the wheel, I will not accept such a change.

I think you're telling me you won't accept either of:

a. uio_device_name()
b. uio_device_chrdev()


It is not my intention to reinvent the wheel. The problem I have
is that the wheel in question won't fit my application context.


I'm trying to figure out how to get this done without a kernel
change, but I don't have many options left.


I think I can do the following:

o Use device_create() to make a parent before calling uio_register_device.

o Have the application search through /proc/devices to yield the major number
  of the uio driver.


With no sysfs, I cannot think of a way to get hold of the minor number allocated
to this instance of the Linux UIO device, and without that I can't open() the
device driver.


Earl
