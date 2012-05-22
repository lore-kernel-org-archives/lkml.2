Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2EVJdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:33:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab2EVJdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:33:24 -0400
Message-ID: <4FBB5D4C.9090804@redhat.com>
Date: Tue, 22 May 2012 11:33:00 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-hid-core: Set intfdata to NULL if probe fails
References: <1337629176-1624-1-git-send-email-hdegoede@redhat.com> <4FBB469B.50801@suse.cz> <4FBB49CE.9020408@redhat.com> <4FBB4E51.6020607@suse.cz>
In-Reply-To: <4FBB4E51.6020607@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/22/2012 10:29 AM, Jiri Slaby wrote:
> On 05/22/2012 10:09 AM, Hans de Goede wrote:
>> Hi,
>>
>> On 05/22/2012 09:56 AM, Jiri Slaby wrote:
>>> On 05/21/2012 09:39 PM, Hans de Goede wrote:
>>>> other drivers which rely on frameworks which only call dev_set_drvdata
>>>> on the interface's device if no drvdata has been set
>>>
>>> This looks very broken as it relies on an undocumented behavior.
>>
>> I don't see how expecting intfdata to be NULL when an USB driver's
>> probe function gets called is broken, esp. since most
>> USB drivers will unconditionally set intfdata to something from
>> their probe functions, so it seems reasonable to assume that it is
>> not pointing to anything before probe gets called.
>
> As you can see, it is not.

Notice I used the word "reasoanble" I still believe it is reasonable
to expect intfdata to be NULL. intfdata is just an alias for dev_drvdata,
and if no driver is bound to a device what should its drvdata be?

So we have:
1) A device which does not have a driver bound
2) A potential drivers probe method being called (which will only
    happen if 1. is true)
3) That probe method expecting drvdata to be NULL since no driver is
    bound

Surprise surprise (not). If no driver is bound what else can drvdata
be but NULL, anything else would be a reminisce of a previous driver,
and thus very likely a dangling pointer.

>> it should
>> be NULL when their probe gets called.
>
> No, this is not documented anywhere as far as I can see. And many
> drivers just don't do that. The same for PCI and likely other buses
> (like HID).

Well on driver unbind the USB core explictly sets intfdata to NULL,
which to me clearly signals intent that intfdata should be NULL when
no driver is bound.

The usb code does not do clear intfdata on probe fail, I don't know why,
likely because it expects a failed probe to not set it in the first
place! But it probably is a very good idea to make the USB core set
intfdata to NULL after a failed probe to ensure that it is NULL
when no driver is bound, independent of driver behavior.

>> I cannot believe we are
>> even having this discussion, are you really trying to argue
>> that leaving intfdata as a dangling pointer, rather then setting
>> it to NULL (*) is better???
>
> No, the patch looks correct. But you are expecting something which is
> not still guaranteed.

Well then lets work towards making it guaranteed, since I still believe
the following holds true:
1) drvdata is for a driver to store a pointer to driver specific data
2) If no driver is bound, there is no driver specific data associated with
    the device
3) Thus logically drvdata should be NULL if no driver is bound.

I'll do a patch for the USB-core to ensure that intfdata gets set to NULL
on probe failure.

Regards,

Hans
