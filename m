Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1HRNTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:19:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5550 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab1HRNTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:19:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=elDhKg53SpqPxdXewGoSzlVwn6Q/YJcFqwr3vVWeNKrEQRtbqepPwaXQVFSd/dsER
	giPLuuTNzRALLBMcVhj/A==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sergei Shtylyov" <sshtylyov@mvista.com>, "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108171704280.2100-100000@iolanthe.rowland.org>
Date: Thu, 18 Aug 2011 15:19:20 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0evaiyqvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108171704280.2100-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 17 Aug 2011, Michal Nazarewicz wrote:
>> --- a/drivers/usb/gadget/composite.c
>> +++ b/drivers/usb/gadget/composite.c
>> @@ -1559,12 +1559,6 @@ composite_resume(struct usb_gadget *gadget)
>>  /*-------------------------------------------------------------------------*/
>>
>>  static struct usb_gadget_driver composite_driver = {
>> -#ifdef CONFIG_USB_GADGET_SUPERSPEED
>> -	.speed		= USB_SPEED_SUPER,
>> -#else
>> -	.speed		= USB_SPEED_HIGH,
>> -#endif
>> -
>>  	.unbind		= composite_unbind,
>>
>>  	.setup		= composite_setup,
>> @@ -1609,8 +1603,7 @@ int usb_composite_probe(struct  
>> usb_composite_driver *driver,
>>  		driver->iProduct = driver->name;
>>  	composite_driver.function =  (char *) driver->name;
>>  	composite_driver.driver.name = driver->name;
>> -	composite_driver.speed = min((u8)composite_driver.speed,
>> -				     (u8)driver->max_speed);
>> +	composite_driver.speed = driver->max_speed;
>>  	composite = driver;
>>  	composite_gadget_bind = bind;

On Wed, 17 Aug 2011 23:09:37 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> I see what's going on here.  Your original patch was wrong and then my
> correction was wrong as well.
>
> This line has to remain the way it was (although those (u8) typecasts
> don't seem to be necessary).  Above, you have to initialize
> composite_driver.speed to an appropriate value, probably
> USB_SPEED_SUPER.
>
> What you didn't realize in your original patch is that
> usb_composite_probe() gets called more than once.  Each time it is
> called, it has to adjust composite_driver.speed.

That's sneaky of composite.c...  But is it desired behaviour?  I cannot
came up with a situation where that's what we want.  I would imagine that
usb_composite_probe() should assume the same speed for given
usb_composite_driver regardless if some other slower usb_composite_driver
was loaded.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
