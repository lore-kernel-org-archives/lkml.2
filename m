Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab1ANHcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:32:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57179
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980Ab1ANHc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:32:26 -0500
Date: Thu, 13 Jan 2011 23:32:59 -0800 (PST)
Message-Id: <20110113.233259.157492570.davem@davemloft.net>
To: linux-ide@vger.kernel.org
CC: linux-kernel@vger.kernel.org, marvin@mydatex.cz, tglx@linutronix.de
Subject: IRQ enable/disable BUG in IDE w/shared IRQs
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As far as I know this issue has been around forever.

The bug report is at:

https://bugzilla.kernel.org/show_bug.cgi?id=16481

The important part of the backtrace is:

[    4.003171] WARNING: at kernel/irq/manage.c:290 __enable_irq+0x2f/0x55()
 ...
[    4.003176] Unbalanced enable for IRQ 19
 ...
[    4.003255]  [<c107314d>] ? __enable_irq+0x2f/0x55
[    4.003259]  [<c1073415>] ? enable_irq+0x31/0x4c
[    4.003270]  [<fb915145>] ? ide_probe_port+0x4b7/0x4de [ide_core]
[    4.003280]  [<fb915641>] ? ide_host_register+0x204/0x4e7 [ide_core]

IRQ 19 on this system is shared between the it8213 IDE controller
and one of the USB host controllers.

The condition doesn't trigger every time, only some boots, which sort
of implies a race.

The function ide_probe_port() will unconditionally do a disable_irq()/
enable_irq() around the drive probing sequence.  It does this even if
the IRQ has not been registered yet by IDE.

Normally, this is fine, since if the IRQ is not registered then
irq_desc->depth is 1 and the disable/enable sequence will behave as
essentially a NOP.  If the IRQ is registered by IDE itself, then this
sequence would really disable and then re-enable the IRQ.  That's fine
too.

But this all falls apart if the IDE interrupt line is shared and one
of those other entities does the request_irq() in the middle the
enable/disable sequence.

As far as I can tell the bad sequence is:

	ide_probe_irq			USB host controller driver

			->depth starts at "1"

	disable_irq()
	    ->depth now "2"

					request_irq()
					  ->depth reset to "0"
	enable_irq()
	    ->depth is "0", warning triggers

It would seem that there is an implicit disallowing of playing
with the enable/disable state of an IRQ until request_irq() has
been by someone first, otherwise the above sequence can trigger.

The ATA layer doesn't operate this way, it always requests the IRQ
before doing anything else wrt. interrupts on it.

I suppose I can change IDE to behave this way too, but the less
changes I make to IDE the better and there are also some subtle issues
wrt. dynamic IDE probing I need to look into to get this right.

I have a hard time believing we've gotten away with this for so long.
Maybe it really is that rare to share the IDE interrupts with other
stuff?

Any comments?

