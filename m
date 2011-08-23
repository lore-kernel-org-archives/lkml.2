Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1HWP0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:26:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37544 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1HWP0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:26:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=Lp9vleqceQf/OTyyUK3QixUx8VEIo7lpZJawPdai+VeEHzavWd3Ta8uo83NX0OqiH
	bPxDjOB99XufpmZuIU9HA==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
 <Pine.LNX.4.44L0.1108231030270.2069-100000@iolanthe.rowland.org>
 <20110823145759.GM1341@legolas.emea.dhcp.ti.com>
 <op.v0n9l9h9vgw7ix@mnazarewicz-glaptop>
 <20110823151105.GP1341@legolas.emea.dhcp.ti.com>
Date: Tue, 23 Aug 2011 17:26:24 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0oaia2bvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <20110823151105.GP1341@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Aug 23, 2011 at 05:07:11PM +0200, Michal Nazarewicz wrote:
>> If you look at config_buf() in composite.c, you'll notice that composite
>> just skips functions that do not support current speed.  This means,  
>> that if a connection uses high speed but given function can handle only
>> full speed, it won't be included in the descriptors.
>>
>> config_buf() is called from config_desc() which similarly, iterates over
>> configurations skipping the ones that do not support given speed.
>>
>> Configuration is defined to support given speed if at least one function
>> that is added to that configuration supports that speed (see
>> usb_add_function()).

On Tue, 23 Aug 2011 17:11:06 +0200, Felipe Balbi <balbi@ti.com> wrote:
> I'm trying to think if this is really what we want. This might mean
> $current_config will be different depending if we connect it to SS, HS
> or FS hubs.

What do you mean by $current_config?  The bConfigurationValue will be
the same for "the same" configuration regardless of speed but different
configurations may be available for different speeds and "the same"
configuration in various speeds might have different functions.

So just for the sake of having something concrete, let's say we have:

Configuration #1 with
   function A supporting FS and HS and
   function B supporting FS only.
Configuration #2 with
   function B supporting FS only.
Configuration #3 with
   function A supporting FS and HS and
   function C supporting HS only (dunno if that makes sense).

When connected to FS hub, we will return the following:

Configuration #1: A, B
Configuration #2: B
Configuration #3: A

When connect to HS hub, we will return the following:

Configuration #1: A
Configuration #3: A, C

And similarly to bConfigurationValue, the interface IDs may have holes in
them.

Whether that's what we want, I don't know...  But if I understand
composite.c correctly, that's how it is implemented now.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
