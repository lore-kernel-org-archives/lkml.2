Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2EVI3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:29:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60789 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2EVI3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:29:11 -0400
Message-ID: <4FBB4E51.6020607@suse.cz>
Date: Tue, 22 May 2012 10:29:05 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120517 Thunderbird/13.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-hid-core: Set intfdata to NULL if probe fails
References: <1337629176-1624-1-git-send-email-hdegoede@redhat.com> <4FBB469B.50801@suse.cz> <4FBB49CE.9020408@redhat.com>
In-Reply-To: <4FBB49CE.9020408@redhat.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 10:09 AM, Hans de Goede wrote:
> Hi,
> 
> On 05/22/2012 09:56 AM, Jiri Slaby wrote:
>> On 05/21/2012 09:39 PM, Hans de Goede wrote:
>>> other drivers which rely on frameworks which only call dev_set_drvdata
>>> on the interface's device if no drvdata has been set
>>
>> This looks very broken as it relies on an undocumented behavior.
> 
> I don't see how expecting intfdata to be NULL when an USB driver's
> probe function gets called is broken, esp. since most
> USB drivers will unconditionally set intfdata to something from
> their probe functions, so it seems reasonable to assume that it is
> not pointing to anything before probe gets called.

As you can see, it is not.

>> If they
>> want to do that they should:
>> * set intfdata to NULL
>> * call some hook that may set intfdata
>> * set intfdata to whatever they want if it is still NULL
>>
>> Right?
> 
> Wrong, why would they need to explictly NULL intfdata?

Because they test it against NULL later?

> it should
> be NULL when their probe gets called.

No, this is not documented anywhere as far as I can see. And many
drivers just don't do that. The same for PCI and likely other buses
(like HID).

> I cannot believe we are
> even having this discussion, are you really trying to argue
> that leaving intfdata as a dangling pointer, rather then setting
> it to NULL (*) is better???

No, the patch looks correct. But you are expecting something which is
not still guaranteed.

>> What are those frameworks?
> v4l2-device.c does this, the call sequence is:
> 
> -some driver's probe method gets called
> -that driver can either call dev_set_drvdata itself, if it has its
>  own uses for it, or leave it as is (which should be NULL at this point)

(No, it should not. Change all the drivers or the USB and PCI cores,
document that and then you can expect it.)

> -v4l2_device_register gets called on a v4l2_device struct, with a
>  device argument, if that device does not have any drvdata set, it will
>  set drvdata to point to the v4l2_device struct.

As it stands, v4l now actually depends on its drivers to set intfdata
unconditionally. Either to NULL or some valid pointer...

regards,
-- 
js
suse labs


