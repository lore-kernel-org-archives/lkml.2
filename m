Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1HRUNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:13:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab1HRUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:13:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=wzEiAl4+pdziyxuDXnT1naFkJycrWdfC5y+YHYIe5tavB1QeoZgle1fRHVT+1rRJ9
	0fmGMvfK2J0OGwLMbpiNA==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sergei Shtylyov" <sshtylyov@mvista.com>, "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108181323360.1912-100000@iolanthe.rowland.org>
Date: Thu, 18 Aug 2011 22:13:09 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0fef7e2vgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108181323360.1912-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 19:27:21 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:

> On Thu, 18 Aug 2011, Michal Nazarewicz wrote:
>
>> For the most part, usb_composite_probe() is called only once in module's
>> init function.  As far as I know, only g_ffs calls it several times.  So
>> in all cases expect for g_ffs, composite_driver.speed =
>> min(composite_driver.speed,
>> driver->max_speed) should have the same effect as composite_driver.speed
>> = driver->max_speed.
>>
>> > For example, if you have a composite gadget where one of the function
>> > drivers can handle SuperSpeed and the other can't go beyond high  
>> speed,
>> > the overall gadget must never run faster than high speed.
>>
>> Shouldn't that be dealt in usb_add_function()?  I cannot see any code  
>> that would do that here atm though.

> Maybe you're right.  But isn't that too late?  The UDC driver has to
> know the gadget driver's limitations before it can connect to the host.

usb_add_function() is called before usb_composite_probe() which only then
calls usb_gadget_probe_driver().

What's more, if I understand it correctly, comment in usb_add_function()
says that we support all the speeds usb_composite_driver structure claims
we do but then return different sets of functions depending on speed.  Ie.
if a function is only full speed and host requests high speed,  
configuration
will lack that function.  The comment in question is:

	/* We allow configurations that don't work at both speeds.
	 * If we run into a lowspeed Linux system, treat it the same
	 * as full speed ... it's the function drivers that will need
	 * to avoid bulk and ISO transfers. */

usb_add_function() then proceeds to set config->fullspeed,  
config->highspeed
and config->superspeed depending on what descriptors function provides.

Those are later used in config_desc() where it iterates over all
configurations checking which have functions supporting given speed:

	list_for_each_entry(c, &cdev->configs, list) {
		switch (speed) {
		case USB_SPEED_SUPER: if (!c->superspeed) continue; break;
		case USB_SPEED_HIGH: if (!c->highspeed) continue; break;
		default: if (!c->fullspeed) continue;
		}
		if (w_value == 0)
			return config_buf(c, speed, cdev->req->buf, type);
		w_value--;
	}

config_buf() at the same time, iterates over all functions and skips the  
ones
that do not provide descriptors for given speed:

	list_for_each_entry(f, &config->functions, list) {
		switch (speed) {
		case USB_SPEED_SUPER: descriptors = f->ss_descriptors; break;
		case USB_SPEED_HIGH: descriptors = f->hs_descriptors; break;
		default: descriptors = f->descriptors;
		}
		if (!descriptors)
			continue;
[...]
	}

So I think that your suggestion to use composite_driver.speed =
driver->max_speed was by all means correct.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
