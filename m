Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0INOip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:38:45 -0400
Received: from medousa.rus.uni-stuttgart.de ([129.69.1.57]:32999 "EHLO
	medousa.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab0INOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:38:44 -0400
Message-ID: <4C8F88EC.2020009@math.tu-berlin.de>
Date: Tue, 14 Sep 2010 16:38:36 +0200
From: Thomas Richter <thor@math.tu-berlin.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: parport_pc: irq= parameter with limited usefulness, kernel hang on
 PPC/OldWorldMac
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks, (please reply to thor@math.tu-berlin.de for additional 
questions or feedback),

this is a bug report concerning the parport_pc driver on a somewhat 
exotic hardware that seems to be related
to the unability to switch the module into polling mode:

The system is a beige G3 old-world PPC mac with PCI slots, one of the 
slots contains a NetMOS-based parallel port
card. The system worked happily in this configuration for kernel 2.6.28, 
but things broke on (at least) 2.6.31 and
are (at least) still broken on 2.6.32.21. Symptoms are that the system 
hangs completely as soon as data is
printed out over /dev/lp0. It does then not even react on the 
SysReq-keys (option of course compiled into the kernel),
though if you're lucky, you get a stack-dump. Unfortunately, there is no 
way to get it out of the system as you need
to shut down the power the tough way to get it back working, so I only 
took notes manually:

Exception: 501 at handle_IRQ_event+0x34/0x124
    LR=handle_edge_irq+0x138/0x180
Exception: 501 at __do_softirq+0x68/0x120
    LR=do_softirq+0x48/0x58
Exceptin: 901 at parport_ieee1284_write_compat+0x1a8/0x250
    LR=parport_ieee1284_write_compat+0x19c/0x250

There are several strange things with these:

*) Under at least 2.6.31 and up, the kernel assigns IRQ 25 to the card. 
Under 2.6.28 and below, the card
was run in polling mode (i.e. irq was -1, not 25).

*) Furthermore, the above report suggests that the system wants to 
handle an edge-triggered IRQ, though
according to /proc/interrupts, IRQ 25 is level-triggered.

I was then hoping to persuade the system back into a working stage by 
passing a module parameter to parport_pc:

irq=none dma=none

should, according to the documentation and the parport_pc.c source do 
that. For reasons beyond me, the kernel module wants
to be smarter than I and *still* enables the IRQ. I'm pretty sure that 
shouldn't happen, and a irq=none should be
definite, and not just a suggestion, but please correct me if I'm wrong.

I can get the system back to working with the following trick (urgh!, 
don't try this at home):

*) First, load parport_pc without any parameters. It will then detect an 
SPP port at 0x540 and will enable the irq 25 for
the card.

*) Unload parport_pc,

and reload it as follows:

*) modprobe parport_pc io=0x450 dma=none irq=none

It then "moans" a bit:

Caused by (from SRR1=49030): Transfer error ack signal
IN from bad port 852 at d1a4e898
Machine check in kernel mode.
Caused by (from SRR1=49030): Transfer error ack signal
IN from bad port 852 at d1a4e93c

however, the parport is then successfully in polling mode and works 
happily (well, maybe not happily, but it works at least).

Thus, for me, there seem to be at least two unrelated bugs:

*) parport_pc should take irq=none seriously and should not silently 
override it,
*) parport_pc should at least not crash the system completely in case 
the IRQ is enabled.

The latter *might* be an issue with the G3 powermac hardware, which is 
of course weird and has a couple of hardware
issues of its own.

Thanks,
    Thomas


