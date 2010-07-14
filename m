Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0GNOXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:23:11 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34520 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0GNOXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:23:09 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 14 Jul 2010 16:24:23 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2] usb: gadget: storage: optional SCSI WRITE FUA bit
In-reply-to: <AANLkTil1eG5yzBxvryf-TZINYjeGph-rNz8eELQtm5tj@mail.gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Message-id: <op.vft7mxqm7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>
 <1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com>
 <op.vft2p6do7p4s8u@pikus>
 <AANLkTil1eG5yzBxvryf-TZINYjeGph-rNz8eELQtm5tj@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 15:44:58 +0200, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>>> @@ -93,6 +93,8 @@
>>>  *     removable               Default false, boolean for removable media
>>>  *     luns=N                  Default N = number of filenames, number of
>>>  *                                     LUNs to support
>>> + *     fua=b[,b...]            Default false, booleans for ignore FUA
>>> flag
>>> + *                                     in SCSI WRITE(6,10,12) commands
>>
>> I wonder if it makes sense to make it per-LUN.  I would imagine
>> that it's great to ignore FUA if the device has its own power supply
>> in which case after disconnect the data won't be lost.  This is a
>> per-device property not really per-LUN.  As such I'd make this option
>> global for the gadget.

> Make sense only for removable media with one partition.
> Otherwise. why we have sync option per partition f.e., not per device?

Ah, OK, I see why this is per LUN.  You want to be able not to ignore
FUA if the backing storage is a removable media, right?


>>> +       ssize_t         rc = count;

>> Not really needed here.

> See below

This still stands.  The “rc” is not needed.

>>> +       if (sscanf(buf, "%d", &i) != 1)
>>> +               return -EINVAL;

>> Why not simple_strtol() directly?

> I did it in the same way like fsg_store_ro() does.
> I have no objections to back to previous solution.

OK.  I'd use simpre_strol() myself.  Maybe even patched fsg_store_ro().

>>> +
>>> +       if (curlun->fua)
>>> +               fsg_lun_fsync_sub(curlun);

>> Shouldn't that read something like:
>>
>> +       if (!curlun->fua && i)
>> +               fsg_lun_fsync_sub(curlun);
>>
>> ie. there is no sense in syncing if FUA was active (in which case all
>> writes were synced already, right?) or if the new value is false (since
>> then user does not won't syncing).

> The idea is to sync data before switching from async mode.

But there can be a case of switching from async to async when syncing
is not necessary.  That's why I proposed the &&.  With fua = 1 meaning
ignore the flag my proposal would be:

+       if (!i && curlun->fua)
+               fsg_lun_fsync_sub(curlun);

> Actually fua = 1 means ignorance of that flag.

ignore_fua would be better name then I think.  This also stands for
module parameter.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
