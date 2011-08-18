Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1HRRFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:05:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39746 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1HRRF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:05:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=NC2HfOiot8lvMHEfM9aEXi7ve5iJRCXU4EG+JGCemlKKi9dIjW/TqlDHsEphFIKp9
	97uQ05meXRQcxUwr1uvzQ==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sergei Shtylyov" <sshtylyov@mvista.com>, "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108181055240.1912-100000@iolanthe.rowland.org>
Date: Thu, 18 Aug 2011 19:05:20 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0e5q6pyvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108181055240.1912-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 16:59:28 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:

> On Thu, 18 Aug 2011, Michal Nazarewicz wrote:
>
>> On Wed, 17 Aug 2011 23:09:37 +0200, Alan Stern  
>> <stern@rowland.harvard.edu>
>> wrote:
>> > I see what's going on here.  Your original patch was wrong and then my
>> > correction was wrong as well.
>> >
>> > This line has to remain the way it was (although those (u8) typecasts
>> > don't seem to be necessary).  Above, you have to initialize
>> > composite_driver.speed to an appropriate value, probably
>> > USB_SPEED_SUPER.
>> >
>> > What you didn't realize in your original patch is that
>> > usb_composite_probe() gets called more than once.  Each time it is
>> > called, it has to adjust composite_driver.speed.
>>
>> That's sneaky of composite.c...  But is it desired behaviour?
>
> Yes, it is.
>
>>  I cannot
>> came up with a situation where that's what we want.  I would imagine  
>> that
>> usb_composite_probe() should assume the same speed for given
>> usb_composite_driver regardless if some other slower  
>> usb_composite_driver
>> was loaded.
>
> The speed being calculated isn't the speed of the usb_composite_driver;
> it's the speed of the usb_gadget_driver.  The gadget itself cannot be
> allowed to run faster than its internal drivers can handle.

Yeah, that's why you set usb_gadget_driver's speed to the speed declared
in usb_composite_driver.

For the most part, usb_composite_probe() is called only once in module's
init function.  As far as I know, only g_ffs calls it several times.  So
in all cases expect for g_ffs, composite_driver.speed =  
min(composite_driver.speed,
driver->max_speed) should have the same effect as composite_driver.speed
= driver->max_speed.

> For example, if you have a composite gadget where one of the function
> drivers can handle SuperSpeed and the other can't go beyond high speed,
> the overall gadget must never run faster than high speed.

Shouldn't that be dealt in usb_add_function()?  I cannot see any code that
would do that here atm though.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
