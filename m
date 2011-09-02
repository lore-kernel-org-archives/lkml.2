Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab1IBMLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:11:44 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:46069 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1IBMLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:11:38 -0400
Date: Fri, 2 Sep 2011 22:14:15 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: m68k: [v5] Convert to genirq (WIP)
In-Reply-To: <alpine.OSX.2.00.1108271506320.190@ibook.local>
Message-ID: <alpine.OSX.2.00.1108300148040.435@ibook.local>
References: <CAMuHMdUZe0Y55ZPee+umJdEsmY5X-EB-KoC-w-SGEtbPMAcf3g@mail.gmail.com> <alpine.OSX.2.00.1108271506320.190@ibook.local>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 28 Aug 2011, I wrote:

>
> I also found that the mac_esp driver probe (when in PIO mode) locks up 
> the machine. I worked around this by changing the 
> disable_irq(IRQ_VIA2_3)/enable_irq(IRQ_VIA2_3) calls to 
> local_irq_save/local_irq_restore, but this is not a good solution.

This seems to be a bug in my mac_esp code. m68k's disable_irq() is 
actually equivalent to genirq's disable_irq_nosync(). Changing mac_esp to 
use disable_irq_nosync() fixes the issue under genirq.

I think these disable_irq/enable_irq calls are probably redundant. They 
don't seem to make any difference in practice. I'll send a patch when I've 
studied the code some more.

However, I found another problem. pmac_zilog oopses when its TTY is closed 
(see below). And macsonic does the same when the NIC is closed. The trace 
says that irq_shutdown() died trying to call the chip irq_mask routine, 
when desc->irq_data.chip (in a0) was NULL. Any ideas?

Finn


Unable to handle kernel NULL pointer dereference at virtual address   (null)
Oops: 00000000
Modules linked in:
PC: [<00000000>]   (null)
SR: 2700  SP: 02019d84  a2: 02017960
d0: 00000004    d1: 00000007    d2: 0031cadc    d3: 00000004
d4: 00002000    d5: 01c00710    a0: 00000000    a1: 00000000
Process init (pid: 1, task=02017960)
Frame format=7 eff addr=02019e10 ssw=05e6 faddr=00000000
wb 1 stat/addr/data: 0005 02109460 01c13e88
wb 2 stat/addr/data: 0000 0007b474 000771ac
wb 3 stat/addr/data: 0005 01c10b64 00000000
push data: 01c13e88 0201ac80 00000024 00000000
Stack from 02019dec:
        0004ce34 002f7fdc 0210edd0 0004c870 002f7fdc 00000004 0031cadc 00000bb
        002f7fdc 0031cadc 0004c8c6 00000004 0031cadc 00002000 00168b1c 0031cadc
        0017c296 00000004 0031cadc 00302000 00002000 020ca800 0017986e 0031cadc
        020ca820 00000001 00000001 00000000 00002008 020ca800 020f5000 0017a61a
        020f5000 020ca800 0210a7b0 00000000 00000002 01c00710 00000000 00000000
        020f5000 00000000 02109820 02019f34 01c00710 00000000 00164002 ffffffff
Call Trace: [<0004ce34>] irq_shutdown+0x48/0x54
 [<0004c870>] __free_irq+0x128/0x14e
 [<0004c8c6>] free_irq+0x30/0x80
 [<00002000>] _start+0x0/0x8
 [<00168b1c>] tty_chars_in_buffer+0x0/0x1a
 [<0017c296>] pmz_shutdown+0x28/0xe8
 [<00002000>] _start+0x0/0x8
 [<0017986e>] uart_shutdown+0x7e/0xb4
 [<00002008>] do_one_initcall+0x0/0x1c0
 [<0017a61a>] uart_close+0xe0/0x2a0
 [<00164002>] tty_release+0x58/0x472
 [<001640a4>] tty_release+0xfa/0x472
 [<00001000>] kernel_pg_dir+0x0/0x1000
 [<00001000>] kernel_pg_dir+0x0/0x1000
 [<0008dace>] alloc_fd+0x82/0x162
 [<00079b94>] fput+0x1aa/0x23a
 [<00079a6e>] fput+0x84/0x23a [<00076bca>] filp_close+0x4a/0x70
 [<00076c50>] sys_close+0x60/0x88
 [<0000269c>] syscall+0x8/0xc
 [<00001000>] kernel_pg_dir+0x0/0x1000
 [<0000c012>] res_func+0x48e/0x141a
 [<000021e4>] run_init_process+0x1c/0x22
 [<00002228>] init_post+0x3e/0xce
 [<000862aa>] sys_dup+0x0/0x58
 [<00327ad6>] kernel_init+0xe0/0xe8
 [<003279f6>] kernel_init+0x0/0xe8
 [<00002000>] _start+0x0/0x8
 [<00002960>] kernel_thread+0x3a/0x4e

Code: 0000 0000 0000 0000 0000 0000 0000 0000 Bad PC value.
Disabling lock debugging due to kernel taint


