Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0JPSdC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 14:33:02 -0400
Received: from www.tglx.de ([62.245.132.106]:32824 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab0JPSdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 14:33:01 -0400
Date: Sat, 16 Oct 2010 20:32:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anand Gadiyar <gadiyar@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@elte.hu>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC] arm: genirq: fix boot on arm platforms
In-Reply-To: <1287077397-21781-1-git-send-email-gadiyar@ti.com>
Message-ID: <alpine.LFD.2.00.1010162029310.2496@localhost6.localdomain6>
References: <1287077397-21781-1-git-send-email-gadiyar@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010, Anand Gadiyar wrote:

> Commit b683de2b3 in linux-next as of 20101014 (genirq: Query
> arch for number of early descriptors) seems to have broken
> bootup on several ARM boards - my beagleboard gives the
> following dump with earlyprintk.
> 
> NR_IRQS:402
> Unable to handle kernel NULL pointer dereference at virtual address 00000028
> pgd = c0004000
> [00000028] *pgd=00000000
> Internal error: Oops: 5 [#1]
> last sysfs file:
> Modules linked in:
> CPU: 0    Not tainted  (2.6.36-rc7-next-20101014-linux-next-20101012+ #40)
> PC is at init_IRQ+0x14/0x48
> LR is at start_kernel+0x150/0x2c0
> pc : [<c000b474>]    lr : [<c0008944>]    psr: 800001d3
> sp : c0927fd0  ip : 000008d0  fp : 00000000
> r10: 00000000  r9 : 411fc083  r8 : 8002ca24
> r7 : c092a80c  r6 : c0439c44  r5 : c0439c48  r4 : c0979ac0
> r3 : 00000001  r2 : 00000000  r1 : 00000001  r0 : 00000000
> Flags: Nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c5387f  Table: 80004019  DAC: 00000015
> Process swapper (pid: 0, stack limit = 0xc09262f0)
> Stack: (0xc0927fd0 to 0xc0928000)
> 7fc0:                                     00000192 c0008944 c00085bc 00000000
> 7fe0: 00000000 c0439c48 00000000 10c5387d c0979c5c 80008034 00000000 00000000
> [<c000b474>] (init_IRQ+0x14/0x48) from [<c0008944>] (start_kernel+0x150/0x2c0)
> [<c0008944>] (start_kernel+0x150/0x2c0) from [<80008034>] (0x80008034)
> Code: e3a03000 ea000004 e3a02000 e2833001 (e5921028)
> ---[ end trace 1b75b31a2719ed1c ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> 
> We seem to be using desc->status without assigning desc to
> anything. Fix this by adding back the code that was originally
> there.

Yeah, sorry. That was my fault. I applied a patch only half.

Find below the missing chunk, which makes next boot on my ARM boards
again.

Thanks,

	tglx
---
diff --git a/arch/arm/include/asm/hw_irq.h b/arch/arm/include/asm/hw_irq.h
index 90831f6..5586b7c 100644
--- a/arch/arm/include/asm/hw_irq.h
+++ b/arch/arm/include/asm/hw_irq.h
@@ -24,4 +24,6 @@ void set_irq_flags(unsigned int irq, unsigned int flags);
 #define IRQF_PROBE	(1 << 1)
 #define IRQF_NOAUTOEN	(1 << 2)
 
+#define ARCH_IRQ_INIT_FLAGS	(IRQ_NOREQUEST | IRQ_NOPROBE)
+
 #endif
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 5456d11..36ad3be 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -154,12 +154,6 @@ void set_irq_flags(unsigned int irq, unsigned int iflags)
 
 void __init init_IRQ(void)
 {
-	struct irq_desc *desc;
-	int irq;
-
-	for (irq = 0; irq < nr_irqs; irq++)
-		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-
 	init_arch_irq();
 }
 
