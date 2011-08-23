Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1HWOPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:15:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46906 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab1HWOPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:15:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:
	mime-version:content-transfer-encoding:from:organization:date:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=oeW9Ky01+h/y8XFazklFj0ZW4NoeCrmhJcfvS1t05RrLYZiQhiMa9TVJFMx5r4WuQ
	aAHoa8j0ioBVeKZv92oJw==
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
 <op.v0n5y4o0vgw7ix@mnazarewicz-glaptop>
 <20110823135817.GJ1341@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Date: Tue, 23 Aug 2011 16:15:08 +0200
Message-ID: <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <20110823135817.GJ1341@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 15:58:17 +0200, Felipe Balbi <balbi@ti.com> wrote:

>> On Sat, 20 Aug 2011 01:28:06 +0200, Felipe Balbi <balbi@ti.com> wrote:
>>> IMHO the logic is inverted here. It should start from the function
>>> drivers. They should say which USB speeds they support, that would go  
>>> up to composite layer and composite would call e.g.
>>> usb_gadget_set_speed(gadget, maximum_speed);
>>
>> This is actually not how composite works at the moment.  Currently,
>
> my suggestion was exactly to change that :-) Speed is something
> functions support. composite.c shouldn't dictate which speed functions
> should use, rather composite.c should use the maximum speed which all
> functions support.

Strictly speaking, composite.c does not dictate anything.   It just copies
what the composite gadget driver declared as maximum speed.

My understanding was that one could consciously create a composite gadget
such that not all of the functions support all of the speeds.

I would suggest leaving everything as is, expect if usb_composite_driver's
max_speed is set to USB_SPEED_UNKNOWN in which case composite would iterate
over all the functions and figure out the maximum speed that all of the
functions support.

>> a composite gadget can declare a maximum speed of say “high” even if
>> all the functions do not support that speed.  Of course when host asks
>> about descriptors for given speed, only functions that support that
>> speed will be returned (and hence only configurations that have at
>> least one function supporting that speed).
>>
>> Whether the behaviour should be changed is, in my opinion, issue
>> separate from the patchset that I'm sending.
>
> I wouldn't say that, actually. Just replacing is_dualspeed with
> max_speed isn't changing much and if you want to make that part of the
> code better, why not doing The Right Thing(TM) ?

I'm just saying that the main reason for this patchset is to get rid of
the USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED Kconfig options.  So
the purpose of changing is_dualspeed with max_speed is to be able to
check if gadget is super speed at run-time so that gadget_is_superspeed()
can be implemented.

So I would like to just get this done and then figure out what to do with
composite.c.  How does that sound?

> All of the speed negotiation between composite.c and f_*.c should happen
> before even connecting to host

Yep, obviously.  The usb_gadget_probe_driver() is called at the very and
once all the functions and everything is added so composite.c can do all
the analysis it wants and figure out the maximum speed.

> (before attaching data pullups, enabling IRQs, etc), that's exactly why
> me and Sebastian have decided (at that time off list) to add
> udc_start()/udc_stop() methods.

I don't really follow why those would be needed...

> One of the reason was that it would be a quite intrusive change to
> all UDC drivers, second we wanted to give maintainers/authors of
> those UDC drivers some grace period for the change, third  when
> all UDCs are converted, it allow us to do the speed negotiation
> before connecting to host.

Again, I don't follow.  We can figure out the max_speed before calling
usb_gadget_probe_driver() just fine.  We don't even have to have UDC
to figure that out (ie. gadget driver's max_speed does not change
depending on UDC, right?).

>>> how about "current_speed" ?
>>
>> Is there a big advantage?  That would change external interface and I  
>> don't see reason to do so.  Of course, udc class is quite recent so if
>> you feel we can ignore this issue I can go forward with that change.

> you already maximum_speed (below) and speed alone looses some extra
> hint of what kind of information will be there. I think it's better to
> change this to current_speed and make a symbolic link called 'speed'
> which we can keep for the next 5 years and remove it in e.g. Linux v5.0

OK, I'll do that (as soon as I figure out/recall how to make symlinks that
is ;) ).

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
