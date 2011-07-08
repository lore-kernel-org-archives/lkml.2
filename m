Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab1GHEil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:38:41 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57046 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1GHEij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110707093928.GA15325@flint.arm.linux.org.uk>
References: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com>
	<20110630074301.GC27959@flint.arm.linux.org.uk>
	<BANLkTimBTayh_mjOLMZbz3D+wqdtZ10=wA@mail.gmail.com>
	<20110630112804.GA21481@flint.arm.linux.org.uk>
	<BANLkTimo18w5yuE4jtATPvbgENCL04LMpA@mail.gmail.com>
	<BANLkTimupUqpLDdDvMRjB+Js0xW59MTOQA@mail.gmail.com>
	<20110707093928.GA15325@flint.arm.linux.org.uk>
Date: Fri, 8 Jul 2011 12:38:38 +0800
Message-ID: <CA+gQ4tczHA2NGyLaVFjDs6CQjeQZbzNCCBU0zX4HVgaF4VFEFQ@mail.gmail.com>
Subject: Re: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause OOPS
From: Qin Dehua <qindehua@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/7 Russell King <rmk@arm.linux.org.uk>:
> Could you try commenting out:
>
> +       if (dir != DMA_TO_DEVICE)
> +               outer_inv_range(paddr, paddr + size);
>
> in ___dma_page_dev_to_cpu and:
>
> +       if (dir != DMA_TO_DEVICE) {
> +               unsigned long paddr = __pa(kaddr);
> +               outer_inv_range(paddr, paddr + size);
> +       }
>
> in ___dma_single_dev_to_cpu please - and put a BUG_ON(dir == DMA_BIDIRECTIONAL)
> in their place (because that won't be handled correctly with that change.)

After doing the above changes, the kernel just report  BUG_ON(dir ==
DMA_BIDIRECTIONAL):

kernel BUG at arch/arm/mm/dma-mapping.c:526!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = 80004000
[00000000] *pgd=00000000
Internal error: Oops: 805 [#1]
last sysfs file:
Modules linked in:
CPU: 0    Not tainted  (2.6.38.8+ #57)
PC is at __bug+0x1c/0x28
LR is at __bug+0x18/0x28
pc : [<8002b0d4>]    lr : [<8002b0d0>]    psr: 60000013
sp : 80419e90  ip : 00000007  fp : 00001000
r10: f18fb0ec  r9 : 00000005  r8 : 71932000
r7 : 81376640  r6 : 00001000  r5 : 00000000  r4 : 00000000
r3 : 00000000  r2 : 60000013  r1 : 0000219b  r0 : 00000033
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0400397f  Table: 00004018  DAC: 00000035
Process swapper (pid: 0, stack limit = 0x80418278)
Stack: (0x80419e90 to 0x8041a000)
9e80:                                     80533ba1 8002d474 80419ec4 80419ea8
9ea0: 80033e40 00000003 00000004 f18fb0c0 f18fb0c0 8028948c 80419edc 80419ec8
9ec0: 80032ea4 f18fb0c0 8041eb10 00000000 00000000 00000100 f188a984 f188a980
9ee0: 00000000 802895d8 80532b80 f188a98c 00000000 00000004 718d2040 00000001
9f00: 80043dc0 00000000 8041eb10 80532a20 00000018 00000100 0000000a 80418000
9f20: 8041e994 8003e960 00000006 00000001 80532a5c 8003e444 f18a39c0 80420630
9f40: 00000001 00000001 804278a0 00000000 8041a000 000202c0 69056819 00020258
9f60: 00000000 8002704c ffffffff 80419fac 00000005 80027b7c 8039b020 000000ce
9f80: 00000000 60000013 80418000 80431eac 8041cabc 8041a000 000202c0 69056819
9fa0: 00020258 00000000 80423734 80419fc0 8002907c 80028eb4 60000013 ffffffff
9fc0: 8041a0e8 80431e78 80431e00 800089e8 80008344 00000000 00000000 80022dc0
9fe0: 00000000 0400397d 8041a024 800231c4 8041cab0 00008034 00000000 00000000
[<8002b0d4>] (__bug+0x1c/0x28) from [<8002d474>]
(___dma_page_dev_to_cpu+0x7c/0x84)
[<8002d474>] (___dma_page_dev_to_cpu+0x7c/0x84) from [<8028948c>]
(iop_adma_run_tx_complete_actions+0x204/0x288)
[<8028948c>] (iop_adma_run_tx_complete_actions+0x204/0x288) from
[<802895d8>] (__iop_adma_slot_cleanup+0xc8/0x34c)
[<802895d8>] (__iop_adma_slot_cleanup+0xc8/0x34c) from [<8003e960>]
(tasklet_action+0x70/0xec)
[<8003e960>] (tasklet_action+0x70/0xec) from [<8003e444>]
(__do_softirq+0x88/0x124)
[<8003e444>] (__do_softirq+0x88/0x124) from [<8002704c>] (asm_do_IRQ+0x4c/0x98)
[<8002704c>] (asm_do_IRQ+0x4c/0x98) from [<80027b7c>] (__irq_svc+0x3c/0x80)
Exception stack(0x80419f78 to 0x80419fc0)
9f60:                                                       8039b020 000000ce
9f80: 00000000 60000013 80418000 80431eac 8041cabc 8041a000 000202c0 69056819
9fa0: 00020258 00000000 80423734 80419fc0 8002907c 80028eb4 60000013 ffffffff
[<80027b7c>] (__irq_svc+0x3c/0x80) from [<80028eb4>] (cpu_idle+0x8c/0xa4)
[<80028eb4>] (cpu_idle+0x8c/0xa4) from [<800089e8>] (start_kernel+0x224/0x2f4)
[<800089e8>] (start_kernel+0x224/0x2f4) from [<00008034>] (0x8034)
Code: e1a01000 e59f000c eb003ca2 e3a03000 (e5833000)
---[ end trace 6b4795e8111d3a81 ]---
Kernel panic - not syncing: Fatal exception in interrupt
[<8002ced8>] (unwind_backtrace+0x0/0xf0) from [<8003930c>] (panic+0x5c/0x1a0)
[<8003930c>] (panic+0x5c/0x1a0) from [<8002b60c>] (die+0x188/0x1bc)
[<8002b60c>] (die+0x188/0x1bc) from [<8002df68>] (__do_kernel_fault+0x68/0x88)
[<8002df68>] (__do_kernel_fault+0x68/0x88) from [<8002e0d0>]
(do_page_fault+0x148/0x214)
[<8002e0d0>] (do_page_fault+0x148/0x214) from [<800272e0>]
(do_DataAbort+0x38/0x9c)
[<800272e0>] (do_DataAbort+0x38/0x9c) from [<80027b2c>] (__dabt_svc+0x4c/0x60)
Exception stack(0x80419e48 to 0x80419e90)
9e40:                   00000033 0000219b 60000013 00000000 00000000 00000000
9e60: 00001000 81376640 71932000 00000005 f18fb0ec 00001000 00000007 80419e90
9e80: 8002b0d0 8002b0d4 60000013 ffffffff
[<80027b2c>] (__dabt_svc+0x4c/0x60) from [<8002b0d4>] (__bug+0x1c/0x28)
[<8002b0d4>] (__bug+0x1c/0x28) from [<8002d474>]
(___dma_page_dev_to_cpu+0x7c/0x84)
[<8002d474>] (___dma_page_dev_to_cpu+0x7c/0x84) from [<8028948c>]
(iop_adma_run_tx_complete_actions+0x204/0x288)
[<8028948c>] (iop_adma_run_tx_complete_actions+0x204/0x288) from
[<802895d8>] (__iop_adma_slot_cleanup+0xc8/0x34c)
[<802895d8>] (__iop_adma_slot_cleanup+0xc8/0x34c) from [<8003e960>]
(tasklet_action+0x70/0xec)
[<8003e960>] (tasklet_action+0x70/0xec) from [<8003e444>]
(__do_softirq+0x88/0x124)
[<8003e444>] (__do_softirq+0x88/0x124) from [<8002704c>] (asm_do_IRQ+0x4c/0x98)
[<8002704c>] (asm_do_IRQ+0x4c/0x98) from [<80027b7c>] (__irq_svc+0x3c/0x80)
Exception stack(0x80419f78 to 0x80419fc0)
9f60:                                                       8039b020 000000ce
9f80: 00000000 60000013 80418000 80431eac 8041cabc 8041a000 000202c0 69056819
9fa0: 00020258 00000000 80423734 80419fc0 8002907c 80028eb4 60000013 ffffffff
[<80027b7c>] (__irq_svc+0x3c/0x80) from [<80028eb4>] (cpu_idle+0x8c/0xa4)
[<80028eb4>] (cpu_idle+0x8c/0xa4) from [<800089e8>] (start_kernel+0x224/0x2f4)
[<800089e8>] (start_kernel+0x224/0x2f4) from [<00008034>] (0x8034)

Regards,
Qin Dehua
