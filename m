Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1E1ScP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:32:15 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:36492 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab1E1ScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:32:13 -0400
Date: Sat, 28 May 2011 20:32:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: m68k: Convert to genirq (WIP)
Message-ID: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

Now sparc32 has beaten me, I pushed out my work in progress of converting m68k
to use the generic hardirq framework:

git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git m68k-genirq
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-genirq

It contains the following commits:

  [1] ide-{cd,floppy,tape}, keyboard: Do not include <linux/irq.>
  [2] m68k/irq: Rename irq_controller to irq_chip
  [3] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
  [4] m68k/irq: Rename irq_node to irq_data
  [5] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
  [6] m68k/irq: Rename setup_irq() to m68k_setup_irq() and make it static
  [7] m68k/irq: Extract irq_set_chip()
  [8] m68k/irq: Add genirq support
  [9] m68k/atari: Convert Atari to genirq

  [1] is a temporary(?) fix to avoid redefinitions during the remainder of
      the series,
  [2-7] refactor the current m68k irq framework to match the generic hardirq
        framework more closely w.r.t. to its (platform) users,
  [8] adds generic hardirq support to the core, which can be enabled through
      a config option, so both legacy and generic hardirq can coexist at the
      source level during the migration,
  [9] converts Atari to use generic hardirqs.

It's working on ARAnyM[*], which means user (non-autovectored) interrupts are
working.

Next on my list is Amiga, which will cover autovectored and chained interrupts.

Hopefully I'll have enough confidence after that to blindly convert the other
platforms I cannot test myself ;-)
Of course any help is welcome, especially for Mac (with its maze of interrupt
controllers) and Q40 (with its weird ISA interrupt mapping). The remainder of
the platforms seems to be fairly standard and simple.

Thanks!

P.S. The branch m68k-genirq may be rebased in the future.

[*] There are 2 warnings during boot though:

| NR_IRQS:72
| ------------[ cut here ]------------
| WARNING: at linux/kernel/irq/chip.c:559 0x2a191a()
| Modules linked in:
| Call Trace: [<0002767e>] warn_slowpath_common+0x4c/0x64
|  [<0004e81c>] irq_set_chip+0x0/0x66
|  [<000276aa>] warn_slowpath_null+0x14/0x1a
|  [<0004e728>] __irq_set_handler+0x11c/0x13c
|  [<0004ec7e>] handle_level_irq+0x0/0x9c
|  [<00003ef4>] m68k_setup_irq_controller+0x3c/0x50
|  [<0004ec7e>] handle_level_irq+0x0/0x9c
|  [<0004e81c>] irq_set_chip+0x0/0x66
|  [<00027dc8>] printk+0x0/0x1a
|  [<00322022>] __alloc_bootmem+0x0/0x1a
|  [<0031dea4>] atari_init_IRQ+0x2a/0xe8
|  [<0004ec7e>] handle_level_irq+0x0/0x9c
|  [<0031c450>] init_IRQ+0x28/0x2e
|  [<00027dc8>] printk+0x0/0x1a
|  [<0031a012>] start_kernel+0x196/0x3b0
|  [<0031931e>] _sinittext+0x31e/0x9c0
| 
| ---[ end trace 139ce121c98e96c9 ]---

and:

| ------------[ cut here ]------------
| WARNING: at linux/kernel/irq/handle.c:130 handle_irq_event_percpu+0xe6/0x148()
| irq 3 handler nfeth_interrupt+0x0/0x126 enabled interrupts
| Modules linked in:
| Call Trace: [<00027670>] warn_slowpath_common+0x3e/0x64
|  [<0002767e>] warn_slowpath_common+0x4c/0x64
|  [<0002770c>] warn_slowpath_fmt+0x2a/0x32
|  [<0004d01a>] handle_irq_event_percpu+0xe6/0x148
|  [<0004d01a>] handle_irq_event_percpu+0xe6/0x148
|  [<00009d64>] nfeth_interrupt+0x0/0x126
|  [<00027dc8>] printk+0x0/0x1a
|  [<0004d09c>] handle_irq_event+0x20/0x2c
|  [<0004ecce>] handle_level_irq+0x50/0x9c
|  [<002496b8>] schedule+0x0/0x31e
|  [<00006782>] do_IRQ+0x2e/0x44
|  [<00027dc8>] printk+0x0/0x1a
|  [<00003eb4>] __m68k_handle_int+0xe/0x12
|  [<000026e2>] auto_irqhandler_fixup+0x4/0x6
|  [<00027dc8>] printk+0x0/0x1a
|  [<00002c46>] default_idle+0x0/0xe
|  [<00002b0c>] cpu_idle+0x16/0x22
|  [<00002b18>] kernel_thread+0x0/0x4e
|  [<00248610>] rest_init+0x5c/0x62
|  [<0031a220>] start_kernel+0x3a4/0x3b0
|  [<000106aa>] ssincos+0x27e/0x2ac
|  [<000106aa>] ssincos+0x27e/0x2ac
|  [<0031931e>] _sinittext+0x31e/0x9c0
| 
| ---[ end trace 139ce121c98e96cb ]---

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
