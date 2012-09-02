Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2IBUGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 16:06:35 -0400
Received: from smtp1.uu.se ([130.238.7.54]:44741 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab2IBUGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:06:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20547.48101.900727.735398@pilspetsen.it.uu.se>
Date: Sun, 2 Sep 2012 22:04:53 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Adko Branil <adkobranil@yahoo.com>
Cc: Borislav Petkov <bp@alien8.de>, Jeff Garzik <jgarzik@pobox.com>,
        Mikael Pettersson <mikpe@it.uu.se>,
        linux-ide <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
In-Reply-To: <1346325007.23643.YahooMailNeo@web124706.mail.ne1.yahoo.com>
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com>
	<20120826130152.GA20021@liondog.tnic>
	<1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com>
	<20120827215952.GA18719@liondog.tnic>
	<1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com>
	<20120830095808.GB24680@liondog.tnic>
	<1346325007.23643.YahooMailNeo@web124706.mail.ne1.yahoo.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adko Branil writes:
 > >Right near the end there's a lockdep warning about a deadlock
 > 
 > >between sata_promise's hardreset thing and the machine getting a
 > >ata_bmdma_interrupt.
 > 
 > >But since I don't know this code, it would be nice if you could take a
 > >look at it.
 > 
 > I picked up 3 more dmesg after rebooting, and 2 more oopses.
 >  I will put here just pieces from dmesgs about these locks, they differs slightly each-other:
 > 
 > ***********************************************************************************
 > 1.
 > 
 > 
 > [    1.859215] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
 > [    1.943678] 
 > [    1.943679] =================================
 > [    1.943680] [ INFO: inconsistent lock state ]
 > [    1.943682] 3.5.2 #4 Not tainted
 > [    1.943683] ---------------------------------
 > [    1.943684] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
 > [    1.943686] swapper/1/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 > [    1.943687]  (&(&host->lock)->rlock){?.+...}, at: [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
 > [    1.943695] {HARDIRQ-ON-W} state was registered at:
 > [    1.943696]   [<ffffffff810998fb>] __lock_acquire+0x61b/0x1af0
 > [    1.943701]   [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
 > [    1.943703]   [<ffffffff81b4d051>] _raw_spin_lock+0x31/0x40
 > [    1.943708]   [<ffffffff8190b3c5>] pdc_sata_hardreset+0x85/0x100
 > [    1.943711]   [<ffffffff818eabba>] ata_do_reset+0x3a/0x90
 > [    1.943713]   [<ffffffff818edd72>] ata_eh_reset+0x372/0xe00
 > [    1.943716]   [<ffffffff818eec25>] ata_eh_recover+0x2a5/0x13d0
 > [    1.943718]   [<ffffffff818f073d>] ata_do_eh+0x4d/0xb0
 > [    1.943721]   [<ffffffff818f33ba>] ata_sff_error_handler+0xca/0x120
 > [    1.943723]   [<ffffffff8190a9e4>] pdc_error_handler+0x24/0x30
 > [    1.943725]   [<ffffffff818f029c>] ata_scsi_port_error_handler+0x47c/0x800
 > [    1.943728]   [<ffffffff818f06be>] ata_scsi_error+0x9e/0xd0
 > [    1.943730]   [<ffffffff816732e8>] scsi_error_handler+0xf8/0x500
 > [    1.943734]   [<ffffffff810654fe>] kthread+0xae/0xc0
 > [    1.943737]   [<ffffffff81b4f5f4>] kernel_thread_helper+0x4/0x10
 > [    1.943740] irq event stamp: 51304
 > [    1.943741] hardirqs last  enabled at (51301): [<ffffffff8100ab7d>] default_idle+0x5d/0x1b0
 > [    1.943745] hardirqs last disabled at (51302): [<ffffffff81b4da67>] common_interrupt+0x67/0x6c
 > [    1.943748] softirqs last  enabled at (51304): [<ffffffff810498d3>] _local_bh_enable+0x13/0x20
 > [    1.943752] softirqs last disabled at (51303): [<ffffffff8104a355>] irq_enter+0x75/0x90
 > [    1.943754] 
 > [    1.943754] other info that might help us debug this:
 > [    1.943755]  Possible unsafe locking scenario:
 > [    1.943755] 
 > [    1.943755]        CPU0
 > [    1.943755]        ----
 > [    1.943756]   lock(&(&host->lock)->rlock);
 > [    1.943757]   <Interrupt>
 > [    1.943758]     lock(&(&host->lock)->rlock);

I was initially able to reproduce the lockdep warning, and wrote
a crude test patch, but now I can't seem to reproduce the warning
with or without that patch, so I'm not sure what to make of it.

pdc_hard_reset_port needs to serialize because hard reset has to flip
a port-specific bit in a controller register that's shared by all ports,
so it takes the host lock. But now an interrupt occurs during the hard
reset, and pdc_interrupt also has to take the host lock. (I don't know
why the interrupt occurs, hotplug events are supposed to have been masked
by ->freeze before ->hardreset. It might come from a different device,
my test machine has multiple ATA controllers from different vendors,
and some of them do share IRQ.)

Jeff: ->hardreset is called with the host lock NOT held, right?

I think I'll have to introduce a new private lock just for serializing
pdc_hard_reset_port. Expect a patch next weekend (I'll be away from
my Promise test equipment until then.)

/Mikael
