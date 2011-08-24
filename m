Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1HXVBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:01:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab1HXVBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:01:44 -0400
Message-ID: <4E556743.4000106@redhat.com>
Date: Wed, 24 Aug 2011 23:04:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Add USBDEVFS_TRY_DISCONNECT ioctl
References: <20110821164108.GC6229@kroah.com> <Pine.LNX.4.44L0.1108241612590.1643-200000@iolanthe.rowland.org> <20110824204533.GA19618@kroah.com>
In-Reply-To: <20110824204533.GA19618@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First of all: A big thanks to Alan for working on this. From my POV
the code looks good, but I'm only familiar with the usb parts
and not with the scsi parts.

One generic concern is the use of scsi_lock(host) in the
scsi_device_open / close callbacks. We need to be sure non
of the callers of these can already be holding the lock.

On 08/24/2011 10:45 PM, Greg KH wrote:
> On Wed, Aug 24, 2011 at 04:32:31PM -0400, Alan Stern wrote:
>> Okay, here's a sample patch.  Actually it's three patches, listed one
>> after another, but people can apply it like a single patch.
>>
>>       1.	Introduce the USBDEVFS_TRY_DISCONNECT ioctl and the check_busy
>> 	callback it uses.  Implement the callback in the usbfs driver;
>> 	this gives a way for programs to unbind kernel drivers without
>> 	unbinding other userspace drivers.
>>
>>       2.	Implement device-file reference tracking in the SCSI layer,
>> 	and the device_open and device_close callbacks it uses.
>
> Does this handle if the filesystem is being created or fscked, as it's
> not mounted at that time.
>
>> @@ -1647,9 +1653,16 @@ static int proc_ioctl(struct dev_state *
>>   	else switch (ctl->ioctl_code) {
>>
>>   	/* disconnect kernel driver from interface */
>> +	case USBDEVFS_TRY_DISCONNECT:
>>   	case USBDEVFS_DISCONNECT:
>>   		if (intf->dev.driver) {
>>   			driver = to_usb_driver(intf->dev.driver);
>> +			if (ctl->ioctl_code == USBDEVFS_TRY_DISCONNECT&&
>> +					driver->check_busy) {
>> +				retval = driver->check_busy(intf);
>> +				if (retval)
>> +					break;
>> +			}
>
> I don't like the fact that if a driver doesn't contain check_busy() then
> it will automatically fall back to looking like it was a DISCONNECT
> call, which could give userspace a false sense of "everything was fine"
> when trying this out.

I've to agree with Greg here, what to do in case of a driver not
implementing check_busy and thus not really offering USBDEVFS_TRY_DISCONNECT
is policy and thus should be left to userspace. I suggest we just return
-ENOTTY in case of USBDEVFS_TRY_DISCONNECT and the bound driver does not
have checkbusy, then userspace can decide wether to fallback to a regular
disconnect, or to give up.

Regards,

Hans
