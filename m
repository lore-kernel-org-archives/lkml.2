Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab0LFN6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:58:49 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54613 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0LFN6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:58:47 -0500
Message-ID: <4CFCED17.9060702@mvista.com>
Date: Mon, 06 Dec 2010 17:03:03 +0300
From: Valentine Barshak <vbarshak@mvista.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: USBHID: Fix race between disconnect and hiddev_ioctl
References: <20101203172746.GA31045@mvista.com> <20101203231611.GB22969@core.coreip.homeip.net> <201012042122.23852.oliver@neukum.org> <20101204203750.GA7326@core.coreip.homeip.net>
In-Reply-To: <20101204203750.GA7326@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Sat, Dec 04, 2010 at 09:22:23PM +0100, Oliver Neukum wrote:
>   
>> Am Samstag, 4. Dezember 2010, 00:16:12 schrieb Dmitry Torokhov:
>>     
>>>> Since disconnect can happen at any time, we can't initialize
>>>> struct hid_device *hid = hiddev->hid at the beginning of ioctl
>>>> and then use it.
>>>>
>>>> This change checks hiddev->exist flag while holding
>>>> the existancelock and uses hid_device only if it exists.
>>>>         
>>> Why didn't you take the lock and check hiddev->exist at the beginning of
>>> ioctl handler instead of pushing it down into individual command
>>> handlers? I guess it would slow down HIDIOCGVERSION but I think we could
>>> pay this price for code that is more clear ;)
>>>       
>> Strictly speaking you'd change the semantics. Right now you can execute
>> the ioctl even if you know you are holding an fd to a disconnected device
>> open.
>>     
>
> No, I do not think I would. I do not believe that the availability for
> HIDIOCGVERSION on disconnected device is spelled out in API/ABI spec. We
> only know that ioctl will either succeed or appropriate error code is
> returned. The fact that right now HIDIOCGVERSION is available on
> disconnected devices is just an implementation detail subject to change.
>
>   
It's not just HIDIOCGVERSION. A couple of other commands 
(HIDIOCGFLAG/HIDIOCSFLAG) didn't check device existence in the first 
place either.
Current implementation depends on when the device is actually removed.
If it has been removed before the hiddev_ioctl(), hiddev_ioctl() returns 
-EIO.
If the device is removed while hiddev_ioctl() is in progress, we either 
do not notice that and handle HIDIOCGVERSION and HIDIOCGFLAG/HIDIOCSFLAG
just fine, or return -ENODEV.
I'll submit a patch in a bit that applies on top of the "[PATCH] USB: 
USBHID: Fix race between disconnect and hiddev_ioctl" and makes the 
hiddev_ioctl() check
device existence before processing the command and always return -ENODEV 
in case the device has been removed.
Thanks,
Val.

