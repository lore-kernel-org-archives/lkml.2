Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1HWFKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 01:10:32 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:54564 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1HWFKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 01:10:22 -0400
Date: Mon, 22 Aug 2011 23:10:21 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>
cc: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, torvalds@linux-foundation.org,
        mporter@ti.com, Kevin Hilman <khilman@ti.com>,
        "Govindraj.R" <govindraj.raja@ti.com>
Subject: [PATCH] tty: omap-serial: fix boot hang by converting to use a
 threaded IRQ handler (was Re: [PATCH] irq: always set IRQF_ONESHOT if no
 primary handler is specified)
In-Reply-To: <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com>
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de> <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com> <4E4D4A5F.202@linutronix.de> <20110818213418.GA20509@legolas.emea.dhcp.ti.com> <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert the omap-serial hardirq handler to a threaded IRQ handler. Without 
this patch, OMAP boards which use the on-board OMAP UARTs and the 
omap-serial driver will not boot to userspace after commit 
f3637a5f2e2eb391ff5757bc83fb5de8f9726464 ("irq: Always set IRQF_ONESHOT if 
no primary handler is specified").  Enabling CONFIG_DEBUG_SHIRQ reveals 
'IRQ handler type mismatch' errors:

IRQ handler type mismatch for IRQ 74
current handler: serial idle
[<c001b124>] (unwind_backtrace+0x0/0xf0) from [<c009c900>] (__setup_irq+0x42c/0x464)
[<c009c900>] (__setup_irq+0x42c/0x464) from [<c009ca08>] (request_threaded_irq+0xd0/0x148)
[<c009ca08>] (request_threaded_irq+0xd0/0x148) from [<c029d398>] (serial_omap_startup+0x30/0x2dc)
[<c029d398>] (serial_omap_startup+0x30/0x2dc) from [<c0295a38>] (uart_startup+0x5c/0x1ac)

(etc.)

It turns out that the omap-serial code used one threaded IRQ
handler[1][2] and one non-threaded IRQ handler[3] that shared the same
IRQ.  During the 3.1-rc series, a patch was merged[4] that caused
IRQF_ONESHOT to be set on the threaded handler, but the non-threaded
handler did not have IRQF_ONESHOT set.  Since interrupt handlers
that share the same IRQ must also share the presence or absence of
IRQF_ONESHOT[5], this new commit caused a mismatch that prevented the
non-threaded IRQ from registering.

Fix by converting the non-threaded IRQ handler in omap-serial.c to a
threaded IRQ handler.  Ideally we would not have to make this type of
change during the -rc series, but the commit that caused this behavior
was itself merged between v3.1-rc2 and v3.1-rc3.  In the long term, it
would be good to get rid of the shared IRQ handler hack in
arch/arm/mach-omap2/serial.c.

This change has been boot-tested on OMAP3530 BeagleBoard and
OMAP4430ES2 PandaBoard, and static suspend has been lightly tested on
the BeagleBoard.

Pantelis Antoniou <pantelis.antoniou@gmail.com> originally reported
the boot failure.

1. arch/arm/mach-omap2/serial.c line 550, as of Linux v3.1-rc3.  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/arm/mach-omap2/serial.c;h=466fc722fa0f39f03b8d93cf84e4dae4f57fd029;hb=fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c#l550

2. arch/arm/mach-omap2/serial.c line 563, as of Linux v3.1-rc3.  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/arm/mach-omap2/serial.c;h=466fc722fa0f39f03b8d93cf84e4dae4f57fd029;hb=fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c#l563

3. drivers/tty/serial/omap-serial.c line 464, as of Linux v3.1-rc3.  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/tty/serial/omap-serial.c;h=c37df8d0fa2819261dffccc5bc4d0180b9531f49;hb=fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c#l464

4. Commit f3637a5f2e2eb391ff5757bc83fb5de8f9726464 ("irq: Always set
   IRQF_ONESHOT if no primary handler is specified")

5. Gleixner, Thomas. _[patch 2/5] genirq: Allow shared oneshot
   interrupts_.  http://lkml.org/lkml/2011/2/23/511

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Pantelis Antoniou <pantelis.antoniou@gmail.com>
Cc: Govindraj.R <govindraj.raja@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/omap-serial.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index c37df8d..e83a769 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -461,8 +461,8 @@ static int serial_omap_startup(struct uart_port *port)
 	/*
 	 * Allocate the IRQ
 	 */
-	retval = request_irq(up->port.irq, serial_omap_irq, up->port.irqflags,
-				up->name, up);
+	retval = request_threaded_irq(up->port.irq, NULL, serial_omap_irq,
+				      up->port.irqflags, up->name, up);
 	if (retval)
 		return retval;
 
-- 
1.7.5.4

