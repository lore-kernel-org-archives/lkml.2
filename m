Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1HQO1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:27:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40299 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab1HQO1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:27:42 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Felipe Balbi" <balbi@ti.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108171016370.2100-100000@iolanthe.rowland.org>
Date: Wed, 17 Aug 2011 16:27:39 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0c3sdm63l0zgt@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108171016370.2100-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 17 Aug 2011, Michal Nazarewicz wrote:
>> @@ -1609,8 +1603,7 @@ int usb_composite_probe(struct  
>> usb_composite_driver *driver,
>>  		driver->iProduct = driver->name;
>>  	composite_driver.function =  (char *) driver->name;
>>  	composite_driver.driver.name = driver->name;
>> -	composite_driver.speed = min((u8)composite_driver.speed,
>> -				     (u8)driver->max_speed);
>> +	composite_driver.speed = min(USB_SPEED_SUPER, driver->max_speed);

On Wed, 17 Aug 2011 16:20:15 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> I wonder if the min is needed here at all.  It doesn't seem to be doing
> any good.

Do you mean just doing “composite_driver.speed = driver->max_speed”?

>> --- a/drivers/usb/gadget/file_storage.c
>> +++ b/drivers/usb/gadget/file_storage.c
>> @@ -3562,11 +3562,7 @@ static void fsg_resume(struct usb_gadget *gadget)
>>  /*-------------------------------------------------------------------------*/
>>
>>  static struct usb_gadget_driver		fsg_driver = {
>> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>>  	.speed		= USB_SPEED_HIGH,
>> -#else
>> -	.speed		= USB_SPEED_FULL,
>> -#endif
>>  	.function	= (char *) fsg_string_product,
>>  	.unbind		= fsg_unbind,
>>  	.disconnect	= fsg_disconnect,

> You mustn't remove the .speed field entirely.  Set it to USB_SPEED_HIGH.
> The same goes for the other drivers below.

Please note that the field is not in fact removed.

I've removed it in composite_driver only but that's because it is later
set in usb_composite_probe() (ie. see hunk above).

>> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
>> index 1b24099..1869478 100644
>> --- a/drivers/usb/gadget/inode.c
>> +++ b/drivers/usb/gadget/inode.c
>
>> @@ -1015,9 +1013,8 @@ ep0_read (struct file *fd, char __user *buf,  
>> size_t len, loff_t *ptr)
>>  			if (dev->current_config) {
>>  				unsigned power;
>>
>> -				if (gadget_is_dualspeed(dev->gadget)
>> -						&& (dev->gadget->speed
>> -							== USB_SPEED_HIGH))
>> +				if (gadget_is_dualspeed(dev->gadget) &&
>> +				    (dev->gadget->speed == USB_SPEED_HIGH))
>>  					power = dev->hs_config->bMaxPower;
>>  				else
>>  					power = dev->config->bMaxPower;
>
> Please don't mix functional changes with cosmetic whitespace changes.

Will fix.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
