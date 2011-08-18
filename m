Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1HRUpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:45:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12956 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1HRUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:45:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=XBwX32uRAxsq8EblTFaAw34LcLeTHQclIrVAK8+Qv6V8j3hCAHN90g0blVPrhmx24
	y0foY8/b/Ea/g5ydfsyhg==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sergei Shtylyov" <sshtylyov@mvista.com>, "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108181623390.1628-100000@iolanthe.rowland.org>
Date: Thu, 18 Aug 2011 22:44:59 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0ffw9bzvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108181623390.1628-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 18 Aug 2011, Michal Nazarewicz wrote:
>> usb_add_function() is called before usb_composite_probe() which only  
>> then calls usb_gadget_probe_driver().
>>
>> What's more, if I understand it correctly, comment in usb_add_function()
>> says that we support all the speeds usb_composite_driver structure  
>> claims we do but then return different sets of functions depending
>> on speed.   Ie. if a function is only full speed and host requests
>> high speed, configuration will lack that function.  The comment in
>> question is:
>>
>> 	/* We allow configurations that don't work at both speeds.
>> 	 * If we run into a lowspeed Linux system, treat it the same
>> 	 * as full speed ... it's the function drivers that will need
>> 	 * to avoid bulk and ISO transfers. */
>>
>> usb_add_function() then proceeds to set config->fullspeed,
>> config->highspeed and config->superspeed depending on what
>> descriptors function provides.

On Thu, 18 Aug 2011 22:30:14 +0200, Alan Stern wrote:
> Have you misinterpreted that comment?

Might be. ;)

[...]

>> So I think that your suggestion to use composite_driver.speed =
>> driver->max_speed was by all means correct.

> Okay, that line was probably all right, but it seems that something
> else needs to be changed.  In a composite gadget, if none of the
> function drivers support SuperSpeed then we don't want
> composite_driver.speed to be set to USB_SPEED_SUPER.  It would be
> foolish to allow the UDC to connect at a speed which would make the
> gadget useless.

My understanding is that that's the purpose of driver->max_speed.
Composite gadget's author is supposed to set it to the maximum speed
he intends his gadget to run with.

This have some consequences of course: driver->max_speed may be set
to super speed where no function actually supports super speed so
if host chooses this speed we will return no configuration (which
I don't know if it's even legal).

At the same time, author may consciously decide to set
driver->max_speed to some value that not all functions support
aware that depending on speed host chooses, different functions
will be available.

The best composite layer can do, is try to check whether there
is at least one configuration supporting the speed
driver->max_speed declares and if not, decrease it or return
with error.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
