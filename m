Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab2BAHLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:11:51 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:57195 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2BAHLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:11:50 -0500
X-Greylist: delayed 1228 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Feb 2012 02:11:50 EST
Message-ID: <20264.57575.421403.709428@ipc1.ka-ro>
Date: Wed, 1 Feb 2012 07:51:19 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [3.3-rc2] Race condition in ONESHOT IRQ handler disabling IRQ forever
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there is a race condition in the threaded IRQ handler code for oneshot
interrupts that may lead to disabling an IRQ indefinitely. IRQs are
masked before calling the hard-irq handler and are unmasked only after
the soft-irq handler has been run. Thus if the hard-irq handler
returns IRQ_HANDLED instead of IRQ_WAKE_THREAD, meaning the soft-irq
will not be called, the interrupt will remain masked forever.

This can happen due to a short pulse on the interrupt line, that
triggers the interrupt logic, but goes undetected by the hard-irq
handler. The problem can be reproduced with the TSC2007 touch
controller driver that uses ONESHOT interrupts.

The problem arises also with interrupt controllers that latch a level
triggered IRQ until it is acknowledged (like the i.MX28 does).
In this case the IRQ status bit will remain asserted after the
soft-irq finishes and retrigger the interrupt while the interrupt line
is already deasserted.

The following patch would solve the problem, but I'm not sure whether
it's the Right Thing(TM) to do. Especially wrt. shared interrupts.

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 470d08c..93beadb 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -146,6 +146,11 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
 			random |= action->flags;
+			/* unmask the IRQ that has been left masked
+			 * due to race condition
+			 */
+			if (res == IRQ_HANDLED && (action->flags & IRQF_ONESHOT))
+				unmask_irq(desc);
 			break;
 
 		default:

Best regards,

Lothar Wassmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
