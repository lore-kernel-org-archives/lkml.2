Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab0JZPAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:00:47 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48071 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0JZPAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:00:45 -0400
Date: Tue, 26 Oct 2010 17:03:06 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 1/7] USB: gadget: file_storage: put_device() in error
 recovery
In-reply-to: <Pine.LNX.4.44L0.1010261002210.1634-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Message-id: <op.vk6urgd87p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <Pine.LNX.4.44L0.1010261002210.1634-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 16:09:27 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 26 Oct 2010, Michal Nazarewicz wrote:
>> This commit fixes some issues with File-backed Storage Gadget
>> error recovery when registering LUN's devices.
>>
>> First of all, when device_register() fails the device still
>> needs to be put.  However, because lun_release() decreases
>> fsg->ref reference counter the counter must be incremented
>> beforehand.
>
> Correct.
>
>> Second of all, after any of the device_create_file()s fails,
>> device_unregister() is called which in turn (indirectly) calls
>> lun_release() which decrements fsg->ref.  So, again, the
>> reference counter must be incremented beforehand.
>
> Correct.
>
>> Lastly, if the first or the second device_create_file()
>> succeeds, the files are never removed.  To fix it,
>> device_remove_file() needs to be called.  This is done by
>> simply marking LUN as registered prior to creating files so
>> that fsg_unbind() can handle removing files.
>
> Correct.


>> Hope I'm not late for 37?
>
> No doubt it is too late to get into the merge window.

Ah, yes, that what I meant.  I was hoping to get the whole set in -rc1, since
some of the patches are purely coding style fixes.


>> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
>> index d4fdf65..e0504a1 100644
>> --- a/drivers/usb/gadget/file_storage.c
>> +++ b/drivers/usb/gadget/file_storage.c
>> @@ -3392,21 +3392,19 @@ static int __init fsg_bind(struct usb_gadget *gadget)
>>  		dev_set_name(&curlun->dev,"%s-lun%d",
>>  			     dev_name(&gadget->dev), i);
>>
>> -		if ((rc = device_register(&curlun->dev)) != 0) {
>> +		kref_get(&fsg->ref);
>> +		rc = device_register(&curlun->dev);
>> +		if (rc) {
>>  			INFO(fsg, "failed to register LUN%d: %d\n", i, rc);
>> -			goto out;
>> -		}
>> -		if ((rc = device_create_file(&curlun->dev,
>> -					&dev_attr_ro)) != 0 ||
>> -				(rc = device_create_file(&curlun->dev,
>> -					&dev_attr_nofua)) != 0 ||
>> -				(rc = device_create_file(&curlun->dev,
>> -					&dev_attr_file)) != 0) {
>> -			device_unregister(&curlun->dev);
>> +			put_device(&curlun->dev);
>>  			goto out;
>>  		}
>>  		curlun->registered = 1;
>> -		kref_get(&fsg->ref);
>> +
>> +		if ((rc = device_create_file(&curlun->dev, &dev_attr_ro))  ||
>> +		    (rc = device_create_file(&curlun->dev, &dev_attr_nofua)) ||
>> +		    (rc = device_create_file(&curlun->dev, &dev_attr_file)))
>> +			goto out;
>
> As long as you're changing these anyway, you may as well use the style
> most developers seem to prefer:
>
> 		rc = device_create_file(&curlun->dev, &dev_attr_ro);
> 		if (rc)
> 			goto out;
> 		...

But then it'd be total of 9 lines consisting of three 3-line ifs.  I decided
that it would be more readable with a single if even though it is not compliant
with coding style.  What do you think?  I can just resend it.

> After all, you did the same thing in the device_register() call above.
> Apart from this small matter, ACK.

Thanks.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
