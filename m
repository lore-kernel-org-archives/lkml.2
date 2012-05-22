Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2EVIKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab2EVIKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:10:11 -0400
Message-ID: <4FBB49CE.9020408@redhat.com>
Date: Tue, 22 May 2012 10:09:50 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-hid-core: Set intfdata to NULL if probe fails
References: <1337629176-1624-1-git-send-email-hdegoede@redhat.com> <4FBB469B.50801@suse.cz>
In-Reply-To: <4FBB469B.50801@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/22/2012 09:56 AM, Jiri Slaby wrote:
> On 05/21/2012 09:39 PM, Hans de Goede wrote:
>> other drivers which rely on frameworks which only call dev_set_drvdata
>> on the interface's device if no drvdata has been set
>
> This looks very broken as it relies on an undocumented behavior.

I don't see how expecting intfdata to be NULL when an USB driver's
probe function gets called is broken, esp. since most
USB drivers will unconditionally set intfdata to something from
their probe functions, so it seems reasonable to assume that it is
not pointing to anything before probe gets called.

Also note that on disconnect / forced unbind, the USB core
will set intfdata to NULL. itself, enforcing it to be NULL
for unbound interfaces, except when a probe function
screws up and sets intfdata even though the probe failed.

> If they
> want to do that they should:
> * set intfdata to NULL
> * call some hook that may set intfdata
> * set intfdata to whatever they want if it is still NULL
>
> Right?

Wrong, why would they need to explictly NULL intfdata? it should
be NULL when their probe gets called. I cannot believe we are
even having this discussion, are you really trying to argue
that leaving intfdata as a dangling pointer, rather then setting
it to NULL (*) is better???

*) or moving the setting of it to a point where probe can no longer
fail.

> What are those frameworks?
v4l2-device.c does this, the call sequence is:

-some driver's probe method gets called
-that driver can either call dev_set_drvdata itself, if it has its
  own uses for it, or leave it as is (which should be NULL at this point)
-v4l2_device_register gets called on a v4l2_device struct, with a
  device argument, if that device does not have any drvdata set, it will
  set drvdata to point to the v4l2_device struct.

The purpose of this is to try and bring some standardization to what
drvdata will point to for v4l2 devices. But this whole shebang is not
really relevant.

Leaving around a dangling pointer in any circumstancces is just BAD,
very very BAD.

Regards,

Hans





>
>> Signed-off-by: Hans de Goede<hdegoede@redhat.com>
>> ---
>>   drivers/hid/usbhid/hid-core.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
>> index 5bf91db..70d760f 100644
>> --- a/drivers/hid/usbhid/hid-core.c
>> +++ b/drivers/hid/usbhid/hid-core.c
>> @@ -1296,6 +1296,7 @@ err_free:
>>   	kfree(usbhid);
>>   err:
>>   	hid_destroy_device(hid);
>> +	usb_set_intfdata(intf, NULL);
>>   	return ret;
>>   }
>>
>>
