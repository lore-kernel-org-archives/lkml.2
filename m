Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2BTIau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:30:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:15486 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab2BTIat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:30:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68275333"
Subject: Re: ahci: sata hotplug doesn't work after suspend
From: Lin Ming <ming.m.lin@intel.com>
To: Holger Macht <holger@homac.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20120219211709.GA30809@homac.suse.de>
References: <4F415775.7060003@suse.cz>
	 <20120219211709.GA30809@homac.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Feb 2012 16:30:46 +0800
Message-ID: <1329726646.3368.2.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 22:17 +0100, Holger Macht wrote:
> On So 19. Feb - 21:11:33, Jiri Slaby wrote:
> > Hi,
> > 
> > ahci hotplug stopped working here. It always worked (-next-20111206 is
> > the last known working for sure). I'm using -next and after plugging a
> > sata disk in, nothing happens. I don't *think* (in the traffic, it's
> > hard to tell for sure) an interrupt is generated either. I also *think*
> > that it works before suspend/resume, but not after. (Or maybe uptime
> > matters?)
> > 
> > This happens before suspend on plug-in:
> > ata3: exception Emask 0x50 SAct 0x0 SErr 0x40d0800 action 0xe frozen
> > ata3: irq_stat 0x00000040, connection status changed
> > ata3: SError: { HostInt PHYRdyChg CommWake 10B8B DevExch }
> > ata3: hard resetting link
> > ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata3.00: ATA-8: ST31000528AS, CC38, max UDMA/133
> > ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> > ata3.00: configured for UDMA/133
> > ata3: EH complete
> > scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC38 PQ: 0 ANSI: 5
> > sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> > sd 2:0:0:0: [sdc] Write Protect is off
> > sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> > sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
> > support DPO or FUA
> >  sdc: sdc1 sdc2
> > sd 2:0:0:0: [sdc] Attached SCSI disk
> > 
> > After suspend/resume and plug-in, nothing appears in dmesg. Storing "- -
> > -" to /sys/class/scsi_host/host*/scan doesn't help. It looks like the
> > line is completely dead, because only ata1 and ata2 say "hard resetting
> > link" after this (and another two disks are connected there).
> > 
> > I tried 'echo adapter >host_reset', but I get 'write error: Invalid
> > argument'.
> > 
> > 00:1f.2 SATA controller [0106]: Intel Corporation 82801IR/IO/IH
> > (ICH9R/DO/DH) 6 port SATA Controller [AHCI mode] [8086:2922] (rev 02)
> > (prog-if 01 [AHCI 1.0])
> >         Subsystem: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port
> > SATA Controller [AHCI mode] [8086:2922]
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > ParErr- Stepping- SERR- FastB2B- DisINTx+
> >         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> >         Latency: 0
> >         Interrupt: pin B routed to IRQ 43
> >         Region 0: I/O ports at cc00 [size=8]
> >         Region 1: I/O ports at c880 [size=4]
> >         Region 2: I/O ports at c800 [size=8]
> >         Region 3: I/O ports at c480 [size=4]
> >         Region 4: I/O ports at c400 [size=32]
> >         Region 5: Memory at feb7c800 (32-bit, non-prefetchable) [size=2K]
> >         Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
> >                 Address: fee0100c  Data: 4171
> >         Capabilities: [70] Power Management version 3
> >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > PME(D0-,D1-,D2-,D3hot+,D3cold-)
> >                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> >         Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
> >         Capabilities: [b0] Vendor Specific Information: Len=06 <?>
> >         Kernel driver in use: ahci
> > 
> > Any ideas what that could be?
> 
> I suspect this is caused by commit
> 9ee4f3933930abf5cc34f8e9d69fe0e08c18f602. Maybe you could verify? I
> bisected this a couple of days ago but didn't have time to look into it
> further. Maybe Lin can help here if this is the problematic commit.

I'll try to re-produce this issue first.

Regards,
Lin Ming

> 
> Regards,
>  Holger


