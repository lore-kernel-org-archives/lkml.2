Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0LCX1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:27:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53154 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab0LCX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:27:45 -0500
Message-ID: <4CF97DEF.7020403@mvista.com>
Date: Sat, 04 Dec 2010 02:31:59 +0300
From: Valentine Barshak <vbarshak@mvista.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: USBHID: Fix race between disconnect and hiddev_ioctl
References: <20101203172746.GA31045@mvista.com> <20101203231611.GB22969@core.coreip.homeip.net>
In-Reply-To: <20101203231611.GB22969@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Fri, Dec 03, 2010 at 08:27:46PM +0300, Valentine Barshak wrote:
>   
>> A USB HID device can be disconnected at any time.
>> If this happens right before or while hiddev_ioctl is in progress,
>> the hiddev_ioctl tries to access invalid hiddev->hid pointer.
>> When the hid device is disconnected, the hiddev_disconnect()
>> ends up with a call to hid_device_release() which frees
>> hid_device, but doesn't set the hiddev->hid pointer to NULL.
>> If the deallocated memory region has been re-used by the kernel,
>> this can cause a crash or memory corruption.
>>
>> Since disconnect can happen at any time, we can't initialize
>> struct hid_device *hid = hiddev->hid at the beginning of ioctl
>> and then use it.
>>
>> This change checks hiddev->exist flag while holding
>> the existancelock and uses hid_device only if it exists.
>>     
>
> Why didn't you take the lock and check hiddev->exist at the beginning of
> ioctl handler instead of pushing it down into individual command
> handlers? I guess it would slow down HIDIOCGVERSION but I think we could
> pay this price for code that is more clear ;)
>
>   
Well, some of the commands were already using the lock, while a couple 
of them doesn't seem to need it.
I've just added locking to the other commands that needed it. I guess I 
didn't want to rework the whole stuff
in order not to forget to unlock and return.
But I agree, the code would look a bit cleaner though if did as you say.

Thanks,
Val.

