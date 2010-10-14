Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0JNRa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:30:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48490 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab0JNRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 13:30:28 -0400
From: Anand Gadiyar <gadiyar@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Anand Gadiyar <gadiyar@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH RFC] arm: genirq: fix boot on arm platforms
Date: Thu, 14 Oct 2010 22:59:57 +0530
Message-Id: <1287077397-21781-1-git-send-email-gadiyar@ti.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b683de2b3 in linux-next as of 20101014 (genirq: Query
arch for number of early descriptors) seems to have broken
bootup on several ARM boards - my beagleboard gives the
following dump with earlyprintk.

NR_IRQS:402
Unable to handle kernel NULL pointer dereference at virtual address 00000028
pgd = c0004000
[00000028] *pgd=00000000
Internal error: Oops: 5 [#1]
last sysfs file:
Modules linked in:
CPU: 0    Not tainted  (2.6.36-rc7-next-20101014-linux-next-20101012+ #40)
PC is at init_IRQ+0x14/0x48
LR is at start_kernel+0x150/0x2c0
pc : [<c000b474>]    lr : [<c0008944>]    psr: 800001d3
sp : c0927fd0  ip : 000008d0  fp : 00000000
r10: 00000000  r9 : 411fc083  r8 : 8002ca24
r7 : c092a80c  r6 : c0439c44  r5 : c0439c48  r4 : c0979ac0
r3 : 00000001  r2 : 00000000  r1 : 00000001  r0 : 00000000
Flags: Nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387f  Table: 80004019  DAC: 00000015
Process swapper (pid: 0, stack limit = 0xc09262f0)
Stack: (0xc0927fd0 to 0xc0928000)
7fc0:                                     00000192 c0008944 c00085bc 00000000
7fe0: 00000000 c0439c48 00000000 10c5387d c0979c5c 80008034 00000000 00000000
[<c000b474>] (init_IRQ+0x14/0x48) from [<c0008944>] (start_kernel+0x150/0x2c0)
[<c0008944>] (start_kernel+0x150/0x2c0) from [<80008034>] (0x80008034)
Code: e3a03000 ea000004 e3a02000 e2833001 (e5921028)
---[ end trace 1b75b31a2719ed1c ]---
Kernel panic - not syncing: Attempted to kill the idle task!

We seem to be using desc->status without assigning desc to
anything. Fix this by adding back the code that was originally
there.

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <linux@arm.linux.org.uk>
---
I'm not 100% sure this is the correct fix. I'm just reporting
that this small change allows me to boot again.

Apologies if some of you get this twice - a typo in git-send-email
caused the mail to bounce from some accounts, so I'm resending.

 arch/arm/kernel/irq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: mainline/arch/arm/kernel/irq.c
===================================================================
--- mainline.orig/arch/arm/kernel/irq.c
+++ mainline/arch/arm/kernel/irq.c
@@ -157,8 +157,10 @@ void __init init_IRQ(void)
 	struct irq_desc *desc;
 	int irq;
 
-	for (irq = 0; irq < nr_irqs; irq++)
+	for (irq = 0; irq < nr_irqs; irq++) {
+		desc = irq_to_desc_alloc_node(irq, 0);
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
+	}
 
 	init_arch_irq();
 }
