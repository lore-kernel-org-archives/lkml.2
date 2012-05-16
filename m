Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab2EPMlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:41:00 -0400
Received: from mail1.sysgo.com ([176.9.26.183]:48599 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab2EPMk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:40:58 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2012 08:40:57 EDT
Message-ID: <4FB39EDA.3030807@sysgo.com>
Date: Wed, 16 May 2012 14:34:34 +0200
From: Alexander Sverdlin <asv@sysgo.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
CC: alexander.sverdlin.ext@nsn.com
Subject: Possible race in request_irq() (__setup_irq())
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I want to discuss possible race condition in __setup_irq() which is called from request_irq() function.
Unfortunately, we faced real crash with kernel 2.6.32.58 which is too far from current, but potential problem still persist in current linux-next.

This is what happens in 2.6.32.58 on our custom MIPS board:
-----------------------------------------------------------------
CPU 1 Unable to handle kernel paging request at virtual address 0000000000000008, epc == ffffffff801cb9f8, ra == ffffffff801cdef4
Oops[#1]:
Cpu 1
$ 0   : 0000000000000000 ffffffff80660008 0000000000000000 ffffffff805e5570
$ 4   : 000000000000002b 0000000000000000 0000000000080000 ffffffffffff00fe
$ 8   : 0000200300080000 0000000000000000 0000000000000000 a800000001000400
$12   : 000000001000cce0 000000001000001f a800000009400000 0000000000000000
$16   : ffffffff805db500 000000000000002b 8001070000000010 8001070000000238
$20   : 8001070000000220 0000000000000001 0000000000080000 000000000000002b
$24   : 0000000000000353 ffffffff80349ed8..................................
$28   : a8000000007ac000 a8000000007afc10 ffffffff80650000 ffffffff801cdef4
Hi    : 0000000000000000
Lo    : 0000000000000000
epc   : ffffffff801cb9f8 handle_IRQ_event+0x30/0x190
    Not tainted
ra    : ffffffff801cdef4 handle_percpu_irq+0x54/0xc0
Status: 1000cce2    KX SX UX KERNEL EXL.
Cause : 00800008
BadVA : 0000000000000008
PrId  : 000d900a (Cavium Octeon II)
Modules linked in: fsmddg_sfn srio_i2c eeprom bmu_ctrl sfp gpio_bmu leds_bmu led fsmddg_system_driver_mfd_dt fsmddg_paniclog ipv6 cramfs phram [last unloaded: fsmddg_sfn]
Process swapper (pid: 0, threadinfo=a8000000007ac000, task=a8000000007aae38, tls=0000000000000000)
Stack : ffffffff805db500 000000000000002b 8001070000000010 8001070000000238
        8001070000000220 0000000000000001 0000000000080000 8001070000000108
        ffffffff80650000 ffffffff801cdef4 0000000000000001 000000000000002b
        0000000000000001 ffffffff8015f094 000000000000002b ffffffff8011a594
        0000000000000000 ffffffff8066c290 ffffffff8066c290 0000000000000002
        ffffffff8065a758 ffffffff80650000 ffffffff80650000 800000000fd00000
        f5b3fdf8ceff7fff ffffffff80100880 0000000000000000 ffffffff80660008
        ffffffff80100a80 0000000000000000 0000000000100000 a80000004e5b7038
        000000001000cce0 ffffffffffff00fe 0000000000000001 0000000000000000
        0000000000000000 a800000001000400 0000000000000000 000000000000cc00
        ...
Call Trace:
[<ffffffff801cb9f8>] handle_IRQ_event+0x30/0x190
[<ffffffff801cdef4>] handle_percpu_irq+0x54/0xc0
[<ffffffff8015f094>] do_IRQ+0x2c/0x40
[<ffffffff8011a594>] plat_irq_dispatch+0x10c/0x1e8
[<ffffffff80100880>] ret_from_irq+0x0/0x4
[<ffffffff80100aa0>] r4k_wait+0x20/0x40
[<ffffffff8015fcc4>] cpu_idle+0x9c/0x108


Code: ffb30018  ffb20010  ffb10008 <dca20008> e8450002  00a0802d  41606020  3c028057  02e0982d.
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 3 seconds..octeon_restart SMP
-----------------------------------------------------------------

The reason for this is that IRQ is enabled before IRQ handler is actually configured. Please take a look at kernel/irq/manage.c of the linux-next, __setup_irq():

1053         if (!shared) {
1054                 init_waitqueue_head(&desc->wait_for_threads);
1055 
1056                 /* Setup the type (level, edge polarity) if configured: */
1057                 if (new->flags & IRQF_TRIGGER_MASK) {
1058                         ret = __irq_set_trigger(desc, irq,
1059                                         new->flags & IRQF_TRIGGER_MASK);
1060 
1061                         if (ret)
1062                                 goto out_mask;
1063                 }
1064 
1065                 desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
1066                                   IRQS_ONESHOT | IRQS_WAITING);
1067                 irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
1068 
1069                 if (new->flags & IRQF_PERCPU) {
1070                         irqd_set(&desc->irq_data, IRQD_PER_CPU);
1071                         irq_settings_set_per_cpu(desc);
1072                 }
1073 
1074                 if (new->flags & IRQF_ONESHOT)
1075                         desc->istate |= IRQS_ONESHOT;
1076 
1077                 if (irq_settings_can_autoenable(desc))
1078                         irq_startup(desc, true);

So in case no IRQ_NOAUTOEN flag was passed to request_irq() function, IRQ will be enabled here.

1079                 else
1080                         /* Undo nested disables: */
1081                         desc->depth = 1;
1082 
1083                 /* Exclude IRQ from balancing if requested */
1084                 if (new->flags & IRQF_NOBALANCING) {
1085                         irq_settings_set_no_balancing(desc);
1086                         irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
1087                 }
1088 
1089                 /* Set default affinity mask once everything is setup */
1090                 setup_affinity(irq, desc, mask);
1091 
1092         } else if (new->flags & IRQF_TRIGGER_MASK) {
1093                 unsigned int nmsk = new->flags & IRQF_TRIGGER_MASK;
1094                 unsigned int omsk = irq_settings_get_trigger_mask(desc);
1095 
1096                 if (nmsk != omsk)
1097                         /* hope the handler works with current  trigger mode */
1098                         pr_warning("irq %d uses trigger mode %u; requested %u\n",
1099                                    irq, nmsk, omsk);
1100         }
1101 
1102         new->irq = irq;
1103         *old_ptr = new;

Descriptor table for this IRQ will be filled with handler only here!

This code is inside raw_spin_lock_irqsave() protected region, but actually IRQ could be triggered on another core where IRQs are not disabled!
So if IRQ affinity is set up in the way that IRQ itself and request_irq() happen on different cores, IRQ that is already pending in hardware will occur
before it's handler is actually set up.

And this actually happens on our boards. The only reason the topic of the message contains "Possible" is that this race present in kernel for quite a long time and I have not found
any occurrences on other SMP systems than our Octeon. Other possible cause could be wrong usage of request_irq(), but the whole configuration seems to be legal:

IRQ affinity is set to 1 (core 0 processes IRQ).
request_irq() happens during kernel init on core 5. 
IRQ is already pending (but not enabled) before request_irq() happens.
IRQ is not shared and should be enabled by request_irq() automatically.

The fix could be like following. It also takes into account, that "desc" structure must be propagated to other cores on SMP, before
first IRQ occurs. Similar fix works fine with 2.6.32.58, as I'm currently unable to test linux-next on Octeon MIPS. 

This modification ensures that IRQs are only enabled when their
handler has actually been set up and propagated to other cores on SMP.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@sysgo.com>

diff -uprN linux.old/kernel/irq/manage.c linux/kernel/irq/manage.c
--- linux.old/kernel/irq/manage.c	2012-05-16 14:08:38.000000000 +0200
+++ linux/kernel/irq/manage.c	2012-05-16 14:19:16.000000000 +0200
@@ -1074,12 +1074,6 @@ __setup_irq(unsigned int irq, struct irq
 		if (new->flags & IRQF_ONESHOT)
 			desc->istate |= IRQS_ONESHOT;
 
-		if (irq_settings_can_autoenable(desc))
-			irq_startup(desc, true);
-		else
-			/* Undo nested disables: */
-			desc->depth = 1;
-
 		/* Exclude IRQ from balancing if requested */
 		if (new->flags & IRQF_NOBALANCING) {
 			irq_settings_set_no_balancing(desc);
@@ -1107,11 +1101,35 @@ __setup_irq(unsigned int irq, struct irq
 	desc->irqs_unhandled = 0;
 
 	/*
+	 * Enable IRQs ONLY after handler has been already written to the
+	 * descriptor, as IRQ can happen immediately on another core
+	 */
+	if (!shared) {
+		if (irq_settings_can_autoenable(desc)) {
+			/*
+			 * IRQ could immediately fire on another core, so make
+			 * sure, that changes to the descriptor are propagated
+			 * to other cores
+			 */
+			smp_mb();
+			irq_startup(desc, true);
+		} else {
+			/* Undo nested disables: */
+			desc->depth = 1;
+		}
+	}
+
+	/*
 	 * Check whether we disabled the irq via the spurious handler
 	 * before. Reenable it and give it another chance.
 	 */
 	if (shared && (desc->istate & IRQS_SPURIOUS_DISABLED)) {
 		desc->istate &= ~IRQS_SPURIOUS_DISABLED;
+		/*
+		 * IRQ could immediately fire on another core, so make sure,
+		 * that changes to the descriptor are propagated to other cores
+		 */
+		smp_mb();
 		__enable_irq(desc, irq, false);
 	}
 


-- 
Best regards,
Alexander Sverdlin.
