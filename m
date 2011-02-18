Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1BRM6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 07:58:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:38491 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1BRM6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 07:58:13 -0500
Message-ID: <4D5E6CE1.9020908@canonical.com>
Date: Fri, 18 Feb 2011 13:58:09 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org
CC: Jeff Garzik <jgarzik@pobox.com>, Andy Whitcroft <apw@canonical.com>
Subject: Some hints needed how to handle SATA ALPM failures
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mail is trying to summarize a problem that seems to be ongoing for
a number of mainline releases (at least for certain HW) and for which we
would like some advise as to how to best approach diagnosis and fix.

In order to reduce power usage we have been trying to make use of the SATA
ALPM feature in various kernel releases.  However this has resulted in
reports [1] of users who see timeouts on SATA commands apparently
triggered by link power state change, and disk corruption as a result. If
recollection is right this happened on 2.6.31, 2.6.32, and 2.6.35 at least.
The most recent example was a 2.6.35 based kernel running on a system with a
Nvidia MCP67 AHCI controller [2] and a WD disk drive [3].

We are hoping that those working more closely with the SATA code might
be aware of this issue.  As the symptoms are so severe (data corruption)
we have ALPM disabled globally, but this does make it hard to get more
targeted information on affected platforms.

As getting testing is tricky, we are keen to get some advise as to how we
might better diagnose this issue should we be able to get some testing.
We would also like to better understand what information is available and
what valuable in such a diagnosis.  Perhaps someone remembers fixing it (for
some other hw).

* Is this problem likely only related to the controller or may the drive have
  some influence as well? The diagnostics[4] sound a bit like the link fails
  to recover in a way it is supposed to.
* Should the error message already show sufficient information or would there
  be additional debug data that is helpful and what would that be?

Any advice appreciated. Should we file a bugzilla bug report to discuss this?

Thanks.
Stefan

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/539467
[2] 00:09.0 IDE interface [0101]: nVidia Corporation MCP67 AHCI Controller
            [10de:0550] (rev a2) (prog-if 85 [Master SecO PriO])
        Subsystem: Acer Incorporated [ALI] Device [1025:0126]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
                 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
                <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 23
        Region 0: I/O ports at 30f0 [size=8]
        Region 1: I/O ports at 30e4 [size=4]
        Region 2: I/O ports at 30e8 [size=8]
        Region 3: I/O ports at 30e0 [size=4]
        Region 4: I/O ports at 30d0 [size=16]
        Region 5: Memory at d0884000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [44] Power Management version 2
          Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
                 PME(D0-,D1-,D2-,D3hot-,D3cold-)
          Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] SATA HBA v1.0 InCfgSpace
        Capabilities: [b0] MSI: Enable- Count=1/8 Maskable- 64bit+
          Address: 0000000000000000  Data: 0000
        Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
        Kernel driver in use: ahci
        Kernel modules: ahci
[3] Model=WDC WD2500BEVS-22UST0, FwRev=01.01A01, SerialNo=WD-WXE108A79290
    Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
    RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=50
    BuffType=unknown, BuffSize=8192kB, MaxMultSect=16, MultSect=16
    CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=488397168
    IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
    PIO modes: pio0 pio3 pio4
    DMA modes: mdma0 mdma1 mdma2
    UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
    AdvancedPM=yes: unknown setting WriteCache=enabled
    Drive conforms to: Unspecified: ATA/ATAPI-1,2,3,4,5,6,7
[4] [12348.040077] ata3.00: exception Emask 0x0 SAct 0x1 SErr 0x150000
                            action 0x6 frozen
    [12348.040086] ata3: SError: { PHYRdyChg CommWake Dispar }
    [12348.040091] ata3.00: failed command: READ FPDMA QUEUED
    [12348.040099] ata3.00: cmd 60/10:00:b0:94:c5/00:00:03:00:00/40
                            tag 0 ncq 8192 in
    [12348.040101]          res 40/00:00:00:4f:c2/00:00:00:00:00/00
                            Emask 0x4 (timeout)
    [12348.040104] ata3.00: status: { DRDY }
    [12348.040112] ata3: hard resetting link
    [12348.390082] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
    [12348.404414] ata3.00: configured for UDMA/133
    [12348.404550] ata3.00: device reported invalid CHS sector 0
    [12348.404570] ata3: EH complete
