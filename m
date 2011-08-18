Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1HRNYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:24:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61590 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1HRNYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <op.v0ergn0d3l0zgt@mnazarewicz-glaptop>
References: <4E4B9D9C.2010607@linutronix.de>
	<fb37566fc5a85ea4e8711221253e5db98d919251.1313594405.git.mina86@mina86.com>
	<4E4C8077.9070809@tieto.com>
	<op.v0ergn0d3l0zgt@mnazarewicz-glaptop>
Date: Thu, 18 Aug 2011 21:24:07 +0800
Message-ID: <CABqxG0cyZf4nz323MwGAAUVLd_ME50vO0Jq0ik91=D_Vkxn3fA@mail.gmail.com>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED
From: Dave Young <hidave.darkstar@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Ruirui R <ruirui.r.yang@tietoenator.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 7:57 PM, Michal Nazarewicz <mina86@mina86.com> wrote:
> On Thu, 18 Aug 2011 05:01:11 +0200, Yang Rui Rui <ruirui.r.yang@tieto.com>
> wrote:
>>
>> I did not see the include/linux/usb/gadget.h changes, did you have another
>> patch?
>> There's  CONFIG_USB_GADGET_DUALSPEED ifdefs in gadget_is_dualspeed
>> function of the gadget.h
>> If so, I will get oops as before.
>
> Thanks, fixed.  I did “git add -u” while I was in drivers/usb/gadget so
> gadget.h did not get added and I've overlooked it.  Sorry about that.
>
>> On 08/17/2011 11:33 PM, Michal Nazarewicz wrote:
>>>
>>> --- a/drivers/usb/gadget/composite.c
>>> +++ b/drivers/usb/gadget/composite.c
>>> @@ -1559,12 +1559,6 @@ composite_resume(struct usb_gadget *gadget)
>>>
>>>  /*-------------------------------------------------------------------------*/
>>>
>>>  static struct usb_gadget_driver composite_driver = {
>>> -#ifdef CONFIG_USB_GADGET_SUPERSPEED
>>> -       .speed          = USB_SPEED_SUPER,
>>> -#else
>>> -       .speed          = USB_SPEED_HIGH,
>>> -#endif
>>> -
>>>         .unbind         = composite_unbind,
>>>
>>>         .setup          = composite_setup,
>>> @@ -1609,8 +1603,7 @@ int usb_composite_probe(struct usb_composite_driver
>>> *driver,
>>>                 driver->iProduct = driver->name;
>>>         composite_driver.function =  (char *) driver->name;
>>>         composite_driver.driver.name = driver->name;
>>> -       composite_driver.speed = min((u8)composite_driver.speed,
>>> -                                    (u8)driver->max_speed);
>>> +       composite_driver.speed = driver->max_speed;
>
>> This does not works, many drivers will check the driver->speed, ie in
>> musg_gadget.c
>
> Uh?  Not sure what you mean here.  Note that driver above is not the same
> structure as driver below.  composite_driver is what musb_gadget_start()
> will get.

For example I  got -EINVAL in musb_gadget_start in case
composite_driver.speed = USB_SPEED_SUPER

the driver param is the composite_driver in composite.c, isn't it?
>
>> static int musb_gadget_start(struct usb_gadget *g,
>>                 struct usb_gadget_driver *driver)
>> {
>>         struct musb             *musb = gadget_to_musb(g);
>>         unsigned long           flags;
>>         int                     retval = -EINVAL;
>>
>>         if (driver->speed != USB_SPEED_HIGH)
>>                 goto err0;
>> [snip]
>>
>>>         composite = driver;
>>>         composite_gadget_bind = bind;
>
> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
> ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
Yang RuiRui
