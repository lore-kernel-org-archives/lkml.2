Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1HWNso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:48:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab1HWNsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:48:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:
	mime-version:content-transfer-encoding:from:organization:date:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=n2SOwovT+j51nFs6Qtwybxo+ot/qMTwgkEbfOuj1aDnIroWrysyoMs6mDFoIFiATm
	K05VFdmNWGUJwTy0tbWfQ==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <cover.1313791722.git.mina86@mina86.com>
 <accba3196fa1fe04f6110b350c03488acb785abe.1313791722.git.mina86@mina86.com>
 <20110819232805.GC13317@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Date: Tue, 23 Aug 2011 15:48:30 +0200
Message-ID: <op.v0n5y4o0vgw7ix@mnazarewicz-glaptop>
In-Reply-To: <20110819232805.GC13317@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, I somehow missed this mail before.

> On Sat, Aug 20, 2011 at 12:33:00AM +0200, Michal Nazarewicz wrote:
>> This commit replaces usb_gadget's is_dualspeed field with
>> a max_speed field.
>>
>> This change is made so that one will be able to check at
>> run-time if given gadget supports super speed.

On Sat, 20 Aug 2011 01:28:06 +0200, Felipe Balbi <balbi@ti.com> wrote:
> IMHO the logic is inverted here. It should start from the function
> drivers. They should say which USB speeds they support, that would go up
> to composite layer and composite would call e.g.
> usb_gadget_set_speed(gadget, maximum_speed);

This is actually not how composite works at the moment.  Currently,
a composite gadget can declare a maximum speed of say “high” even if
all the functions do not support that speed.  Of course when host asks
about descriptors for given speed, only functions that support that
speed will be returned (and hence only configurations that have at
least one function supporting that speed).

Whether the behaviour should be changed is, in my opinion, issue separate
 from the patchset that I'm sending.

>> diff --git a/drivers/usb/gadget/udc-core.c  
>> b/drivers/usb/gadget/udc-core.c
>> index e1ecdbc..25058b4 100644
>> --- a/drivers/usb/gadget/udc-core.c
>> +++ b/drivers/usb/gadget/udc-core.c
>> @@ -371,14 +371,28 @@ static ssize_t usb_udc_softconn_store(struct  
>> device *dev,
>>  }
>>  static DEVICE_ATTR(soft_connect, S_IWUSR, NULL,  
>> usb_udc_softconn_store);
>>
>> -static ssize_t usb_udc_speed_show(struct device *dev,
>> +#define USB_UDC_SPEED_ATTR(name)					\
>> +ssize_t usb_udc_##name##_show(struct device *dev,			\
>> +		struct device_attribute *attr, char *buf)		\
>> +{									\
>> +	struct usb_udc *udc = container_of(dev, struct usb_udc, dev);	\
>> +	return snprintf(buf, PAGE_SIZE, "%s\n",				\
>> +			usb_device_speed_name(udc->gadget->name));	\
>> +}									\
>> +static DEVICE_ATTR(name, S_IRUSR, usb_udc_##name##_show, NULL)
>> +
>> +static USB_UDC_SPEED_ATTR(speed);
>
> how about "current_speed" ?

Is there a big advantage?  That would change external interface and I don't
see reason to do so.  Of course, udc class is quite recent so if you feel  
we can
ignore this issue I can go forward with that change.

>> +static USB_UDC_SPEED_ATTR(max_speed);
>
> in this case, humans will be reading sysfs, so maximum_speed will look
> nicer, IMHO.

I don't care much.  Will change.

>> +/* Provide "is_dualspeed" for backward compatibility. */
>> +static ssize_t usb_udc_is_dualspeed_show(struct device *dev,
>>  		struct device_attribute *attr, char *buf)
>>  {
>> -	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
>> -	return snprintf(buf, PAGE_SIZE, "%s\n",
>> -			usb_device_speed_name(udc->gadget->speed));
>> +	struct usb_udc *udc = container_of(dev, struct usb_udc, dev);
>> +	return snprintf(buf, PAGE_SIZE, "%d\n",
>> +			gadget_is_dualspeed(udc->gadget));
>>  }
>> -static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);
>> +static DEVICE_ATTR(is_dualspeed, S_IRUSR, usb_udc_is_dualspeed_show,  
>> NULL);
>
> maybe deprecate this one on feature-removal-schedule ??

Sure.

Also, if we decide to change “speed” to “current_speed”, we could just drop
this without the announcement.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
