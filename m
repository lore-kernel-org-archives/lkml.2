Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1ANKa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:30:56 -0500
Received: from www.tglx.de ([62.245.132.106]:48126 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1ANKau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:30:50 -0500
Date: Fri, 14 Jan 2011 11:30:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, marvin@mydatex.cz
Subject: Re: IRQ enable/disable BUG in IDE w/shared IRQs
In-Reply-To: <20110113.233259.157492570.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.1101141031320.2678@localhost6.localdomain6>
References: <20110113.233259.157492570.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, David Miller wrote:
> As far as I know this issue has been around forever.
> 
> The bug report is at:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16481
> 
> The important part of the backtrace is:
> 
> [    4.003171] WARNING: at kernel/irq/manage.c:290 __enable_irq+0x2f/0x55()
>  ...
> [    4.003176] Unbalanced enable for IRQ 19
>  ...
> [    4.003255]  [<c107314d>] ? __enable_irq+0x2f/0x55
> [    4.003259]  [<c1073415>] ? enable_irq+0x31/0x4c
> [    4.003270]  [<fb915145>] ? ide_probe_port+0x4b7/0x4de [ide_core]
> [    4.003280]  [<fb915641>] ? ide_host_register+0x204/0x4e7 [ide_core]
> 
> IRQ 19 on this system is shared between the it8213 IDE controller
> and one of the USB host controllers.
> 
> The condition doesn't trigger every time, only some boots, which sort
> of implies a race.
> 
> The function ide_probe_port() will unconditionally do a disable_irq()/
> enable_irq() around the drive probing sequence.  It does this even if
> the IRQ has not been registered yet by IDE.
> 
> Normally, this is fine, since if the IRQ is not registered then
> irq_desc->depth is 1 and the disable/enable sequence will behave as
> essentially a NOP.  If the IRQ is registered by IDE itself, then this
> sequence would really disable and then re-enable the IRQ.  That's fine
> too.
> 
> But this all falls apart if the IDE interrupt line is shared and one
> of those other entities does the request_irq() in the middle the
> enable/disable sequence.
> 
> As far as I can tell the bad sequence is:
> 
> 	ide_probe_irq			USB host controller driver
> 
> 			->depth starts at "1"
> 
> 	disable_irq()
> 	    ->depth now "2"
> 
> 					request_irq()
> 					  ->depth reset to "0"
> 	enable_irq()
> 	    ->depth is "0", warning triggers
> 
> It would seem that there is an implicit disallowing of playing
> with the enable/disable state of an IRQ until request_irq() has
> been by someone first, otherwise the above sequence can trigger.

Probably nobody every thought about this :)
 
> The ATA layer doesn't operate this way, it always requests the IRQ
> before doing anything else wrt. interrupts on it.
> 
> I suppose I can change IDE to behave this way too, but the less
> changes I make to IDE the better and there are also some subtle issues
> wrt. dynamic IDE probing I need to look into to get this right.

We could check for depth > 1 and just decrement depth by one in
request_irq, but I'm quite reluctant to do so w/o extensive testing.

OTOH, nested disables should not be the common case either, but who
knows what legacy stuff will break.

> I have a hard time believing we've gotten away with this for so long.
> Maybe it really is that rare to share the IDE interrupts with other
> stuff?

IIRC, the legacy IDE interrupts were 14/15 and those were never shared.

Thanks,

	tglx
