Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab1FBHd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:33:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:43200 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226Ab1FBHdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:33:55 -0400
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linville@tuxdriver.com, LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>, zajec5@gmail.com
In-Reply-To: <alpine.DEB.2.01.1106012057130.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
	 <alpine.DEB.2.01.1106011712270.21697@trent.utfs.org>
	 <1306983467.29297.51.camel@pasglop>
	 <alpine.DEB.2.01.1106012057130.21697@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 17:33:28 +1000
Message-ID: <1307000008.29297.59.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 21:27 -0700, Christian Kujau wrote:
> On Thu, 2 Jun 2011 at 12:57, Benjamin Herrenschmidt wrote:
> > Ok, thanks a lot, It looks rather trivial actually: That new workaround
> > is PCIe specific but is called unconditionally, and will do bad things
> > non-PCIe implementations.
> 
> OK, with your patch applied to Linus' latest git tree the machine 
> continues to boot. Also, with the latest tree, the "machine is stuck after 
> ide-cd init" problem[0] went away.
> 
> For this particular problem and patch, feel free to add:
> 
> Tested-by: Christian Kujau <lists@nerdbynature.de>
> 
> However, shortly after boot and loggin in to the box remotely, the bux did 
> not respond any more. I'm not sure if these are related to those SSB/PCIe 
> changes, but somehow I hope they are - bisecting those would take much 
> longer, as it's not an "instant" death:
> 
>  * http://nerdbynature.de/bits/3.0-rc1/linux-3.0-rc1_stuck1.jpg
>  * http://nerdbynature.de/bits/3.0-rc1/linux-3.0-rc1_stuck2.jpg
> 
> This is what an OCR program made of it:

I think this is another problem that I'm in the middle of trying to
figure out.

It -looks- to me that something goes wrong in the tty code when a large
file is piped through a pty, causing the kernel to hang for minutes in
the workqueue / ldisk flush code. I've just sent an initial report to
Alan Cox about it and am currently bisecting it.

Cheers,
Ben.

> irq euent stamp: 185804850
> hardirqs last enabled at (185904849): [<c04005b0>] _raw_spin_unlock_irqrestore+0x40/0x?e
> hardirqs last disabled at (185904850): [<c00120b8>] reenable_mmu+0x24/0x78
> Softirqs last enabled at (185892414): [<c000fe8c>] call_do_softirq+0x14/0x24
> softirqs last disabled at (18589240?): [<c000fe8c>] call_do_softirq+0x14/0x24
> NIP: e04005b4 LR: e04005b0 CTR: 00000000
> REGS: ef92be10 TRHP: 0901 Not tainted (3.0.0-rel-00049-g1fa?b6a-dirtg)
> MSB: 00009032 <EE.ME.IR.DR> CR: 42002084
> TRSK = ef8d0000[38B] ’kuorker/0:2’ THREAD:
> GPR00: c04005b0 ef92bec0 efBd0000 00000001
> GPR08: 00000000 0b14aed0 0049a306 00030600
> HIP [c01005b1] _rau_spin_unlock_irqrestore+0x44/0x?c
> LR [c04005b0] _rau_spin_unlock_irqrestore+0x40/0x?c
> Call Trace:
> [ef92bec0] [c04005b0] _raw_spin_unlock_irqrestore+0x40/0x?c (unreliable)
> [ef92bed0] [c029c504] flush_tu_ldisc+0x121/0x230
> [ef92bf10] [c001c86c] process_one_uork+0x1c1/0x4cB
> [ef92bfS0] [c004efac] worker_thread+0x1?8/0x3c1
> [ef92bf90] [c0051148] kthread+0x81/0x88
> [ef92hff0] [c0810390] kernel_thread+0x1c/0x68
> 
> XER: 20000000
> ef92a000 ef8d0660 00000006 00000000 18614000 22002088
> Instruction dump:
> ??? 93e1060c ?c9f23?B 38800001 90010011 4bc6e9a9 ?fc3i`3?8 4be61a69
> ?3e08080 11820021 1bc6b515 ?fe00124
> B8c16008 ?c0803a6 83c1000c
> 
> Well, the picture is way better :-\
> 
> Thanks,
> Christian.
> 
> [0] http://nerdbynature.de/bits/3.0-rc1/linux-3.0-rc1-cdrom.jpg


