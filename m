Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1HSBrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 21:47:03 -0400
Received: from ebb05.tieto.com ([131.207.168.36]:58881 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1HSBrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 21:47:01 -0400
X-AuditID: 83cfa824-b7be9ae000000a40-00-4e4dc093f59e
Message-ID: <4E4DC418.8050009@tieto.com>
Date: Fri, 19 Aug 2011 10:02:00 +0800
From: Yang Rui Rui <ruirui.r.yang@tieto.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Michal Nazarewicz <mnazarewicz@google.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Ruirui R <ruirui.r.yang@tietoenator.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108181055240.1912-100000@iolanthe.rowland.org> <op.v0e5q6pyvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <op.v0e5q6pyvgw7ix@mnazarewicz-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2011 01:05 AM, Michal Nazarewicz wrote:
> On Thu, 18 Aug 2011 16:59:28 +0200, Alan Stern<stern@rowland.harvard.edu>
> wrote:
>
>> On Thu, 18 Aug 2011, Michal Nazarewicz wrote:
>>
>>> On Wed, 17 Aug 2011 23:09:37 +0200, Alan Stern
>>> <stern@rowland.harvard.edu>
>>> wrote:
>>>> I see what's going on here.  Your original patch was wrong and then my
>>>> correction was wrong as well.
>>>>
>>>> This line has to remain the way it was (although those (u8) typecasts
>>>> don't seem to be necessary).  Above, you have to initialize
>>>> composite_driver.speed to an appropriate value, probably
>>>> USB_SPEED_SUPER.
>>>>
>>>> What you didn't realize in your original patch is that
>>>> usb_composite_probe() gets called more than once.  Each time it is
>>>> called, it has to adjust composite_driver.speed.
>>>
>>> That's sneaky of composite.c...  But is it desired behaviour?
>>
>> Yes, it is.
>>
>>>   I cannot
>>> came up with a situation where that's what we want.  I would imagine
>>> that
>>> usb_composite_probe() should assume the same speed for given
>>> usb_composite_driver regardless if some other slower
>>> usb_composite_driver
>>> was loaded.
>>
>> The speed being calculated isn't the speed of the usb_composite_driver;
>> it's the speed of the usb_gadget_driver.  The gadget itself cannot be
>> allowed to run faster than its internal drivers can handle.
>
> Yeah, that's why you set usb_gadget_driver's speed to the speed declared
> in usb_composite_driver.

This is what I means in before reply, musb_gadget_start will check the speed set here.
if it != USB_SPEED_HIGH it will return -EINVAL.

>
> For the most part, usb_composite_probe() is called only once in module's
> init function.  As far as I know, only g_ffs calls it several times.  So
> in all cases expect for g_ffs, composite_driver.speed =
> min(composite_driver.speed,
> driver->max_speed) should have the same effect as composite_driver.speed
> = driver->max_speed.

For original code, ifndef CONFIG_USB_GADGET_SUPERSPEED and max_speed = USB_SPEED_SUPER
then the result will be:

composite_driver.speed = min(USB_SPEED_HIGH, USB_SPEED_SUPER)

For patched code, composite_driver.speed = USB_SPEED_SUPER

>
>> For example, if you have a composite gadget where one of the function
>> drivers can handle SuperSpeed and the other can't go beyond high speed,
>> the overall gadget must never run faster than high speed.
>
> Shouldn't that be dealt in usb_add_function()?  I cannot see any code that
> would do that here atm though.
>


-- 
Thanks
Yang Ruirui
