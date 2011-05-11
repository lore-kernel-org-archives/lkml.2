Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab1EKW0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:26:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab1EKWZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:25:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: AHCI driver problem on SB700/SB800 w/ Acer Ferrari One
Date: Thu, 12 May 2011 00:25:34 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105120025.34531.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There seems to be a problem on my Acer box which is related to DIPM
and switching the power source.  Namely, when I detach the AC adapter from
the machine, the disk (which is an Intel SSD) freezes for a while and
something like this appears in dmesg:

[ 2177.808120] ata1.00: exception Emask 0x0 SAct 0x7 SErr 0xd0002 action 0x6 frozen
[ 2177.808140] ata1: SError: { RecovComm PHYRdyChg CommWake 10B8B }
[ 2177.808153] ata1.00: failed command: WRITE FPDMA QUEUED
[ 2177.808171] ata1.00: cmd 61/08:00:08:ed:37/00:00:06:00:00/40 tag 0 ncq 4096 out
[ 2177.808174]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 2177.808192] ata1.00: status: { DRDY }
[ 2177.808201] ata1.00: failed command: WRITE FPDMA QUEUED
[ 2177.808218] ata1.00: cmd 61/08:08:48:f4:c7/00:00:05:00:00/40 tag 1 ncq 4096 out
[ 2177.808220]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 2177.808239] ata1.00: status: { DRDY }
[ 2177.808247] ata1.00: failed command: WRITE FPDMA QUEUED
[ 2177.808275] ata1.00: cmd 61/08:10:50:f4:c7/00:00:05:00:00/40 tag 2 ncq 4096 out
[ 2177.808277]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 2177.808303] ata1.00: status: { DRDY }
[ 2177.808320] ata1: hard resetting link
[ 2187.812149] ata1: softreset failed (1st FIS failed)
[ 2187.812227] ata1: hard resetting link
[ 2188.304128] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2188.304774] ata1.00: configured for UDMA/133
[ 2188.320333] ata1.00: device reported invalid CHS sector 0
[ 2188.320361] ata1.00: device reported invalid CHS sector 0
[ 2188.320394] ata1: EH complete

Then, when the AC adapter is attached again, the SSD freezes again and this
appears in dmesg:

[178523.064145] ata1.00: qc timeout (cmd 0xef)
[178523.064228] ata1.00: failed to disable DIPM, Emask 0x4
[178523.064248] ata1: hard resetting link
[178523.556096] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[178523.556793] ata1.00: configured for UDMA/133
[178523.572051] ata1: EH complete

That seems to be reproducible 100% of the time.  Moreover, if the box is
suspended on AC power and then resume on battery power, something more serious
happens:

[178881.824160] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0xd0002 action 0x6 frozen
[178881.824203] ata1: SError: { RecovComm PHYRdyChg CommWake 10B8B }
[178881.824223] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824249] ata1.00: cmd 61/08:00:00:d0:9e/00:00:01:00:00/40 tag 0 ncq 4096 out
[178881.824252]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824288] ata1.00: status: { DRDY }
[178881.824304] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824328] ata1.00: cmd 61/08:08:48:d0:9e/00:00:01:00:00/40 tag 1 ncq 4096 out
[178881.824331]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824366] ata1.00: status: { DRDY }
[178881.824381] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824405] ata1.00: cmd 61/08:10:00:d2:9e/00:00:01:00:00/40 tag 2 ncq 4096 out
[178881.824408]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824443] ata1.00: status: { DRDY }
[178881.824457] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824481] ata1.00: cmd 61/08:18:20:d3:9e/00:00:01:00:00/40 tag 3 ncq 4096 out
[178881.824484]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824519] ata1.00: status: { DRDY }
[178881.824534] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824557] ata1.00: cmd 61/10:20:90:da:9e/00:00:01:00:00/40 tag 4 ncq 8192 out
[178881.824560]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824595] ata1.00: status: { DRDY }
[178881.824610] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824633] ata1.00: cmd 61/08:28:c0:5a:6c/00:00:01:00:00/40 tag 5 ncq 4096 out
[178881.824637]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824671] ata1.00: status: { DRDY }
[178881.824710] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824731] ata1.00: cmd 61/10:30:48:5f:98/00:00:01:00:00/40 tag 6 ncq 8192 out
[178881.824734]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824760] ata1.00: status: { DRDY }
[178881.824773] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824794] ata1.00: cmd 61/08:38:e0:1a:a4/00:00:01:00:00/40 tag 7 ncq 4096 out
[178881.824797]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824823] ata1.00: status: { DRDY }
[178881.824836] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824856] ata1.00: cmd 61/08:40:90:29:ac/00:00:01:00:00/40 tag 8 ncq 4096 out
[178881.824859]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824885] ata1.00: status: { DRDY }
[178881.824898] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824919] ata1.00: cmd 61/08:48:a0:33:a4/00:00:01:00:00/40 tag 9 ncq 4096 out
[178881.824922]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.824949] ata1.00: status: { DRDY }
[178881.824961] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.824982] ata1.00: cmd 61/08:50:c8:51:ac/00:00:01:00:00/40 tag 10 ncq 4096 out
[178881.824985]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825012] ata1.00: status: { DRDY }
[178881.825025] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825046] ata1.00: cmd 61/10:58:00:50:96/00:00:01:00:00/40 tag 11 ncq 8192 out
[178881.825049]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825075] ata1.00: status: { DRDY }
[178881.825087] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825108] ata1.00: cmd 61/08:60:20:50:96/00:00:01:00:00/40 tag 12 ncq 4096 out
[178881.825111]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825137] ata1.00: status: { DRDY }
[178881.825149] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825170] ata1.00: cmd 61/08:68:40:50:96/00:00:01:00:00/40 tag 13 ncq 4096 out
[178881.825173]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825199] ata1.00: status: { DRDY }
[178881.825212] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825232] ata1.00: cmd 61/10:70:e0:4c:94/00:00:01:00:00/40 tag 14 ncq 8192 out
[178881.825235]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825261] ata1.00: status: { DRDY }
[178881.825273] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825294] ata1.00: cmd 61/10:78:80:55:7b/00:00:01:00:00/40 tag 15 ncq 8192 out
[178881.825297]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825323] ata1.00: status: { DRDY }
[178881.825335] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825356] ata1.00: cmd 61/08:80:68:60:64/00:00:01:00:00/40 tag 16 ncq 4096 out
[178881.825359]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825385] ata1.00: status: { DRDY }
[178881.825398] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825419] ata1.00: cmd 61/08:88:c8:5a:6c/00:00:01:00:00/40 tag 17 ncq 4096 out
[178881.825422]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825449] ata1.00: status: { DRDY }
[178881.825461] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825461] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825482] ata1.00: cmd 61/08:90:b8:b6:64/00:00:01:00:00/40 tag 18 ncq 4096 out
[178881.825485]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825512] ata1.00: status: { DRDY }
[178881.825524] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825545] ata1.00: cmd 61/10:98:a8:a2:6d/00:00:01:00:00/40 tag 19 ncq 8192 out
[178881.825548]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825574] ata1.00: status: { DRDY }
[178881.825587] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825608] ata1.00: cmd 61/08:a0:58:f6:76/00:00:01:00:00/40 tag 20 ncq 4096 out
[178881.825611]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825637] ata1.00: status: { DRDY }
[178881.825649] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825670] ata1.00: cmd 61/08:a8:e0:28:3b/00:00:06:00:00/40 tag 21 ncq 4096 out
[178881.825673]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825699] ata1.00: status: { DRDY }
[178881.825712] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825732] ata1.00: cmd 61/48:b0:c0:1e:a5/01:00:04:00:00/40 tag 22 ncq 167936 out
[178881.825735]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825761] ata1.00: status: { DRDY }
[178881.825774] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825794] ata1.00: cmd 61/08:b8:78:c1:37/00:00:06:00:00/40 tag 23 ncq 4096 out
[178881.825798]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825824] ata1.00: status: { DRDY }
[178881.825836] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825857] ata1.00: cmd 61/18:c0:98:c1:37/00:00:06:00:00/40 tag 24 ncq 12288 out
[178881.825860]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825886] ata1.00: status: { DRDY }
[178881.825899] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825919] ata1.00: cmd 61/08:c8:10:c1:37/00:00:06:00:00/40 tag 25 ncq 4096 out
[178881.825923]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.825949] ata1.00: status: { DRDY }
[178881.825961] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.825982] ata1.00: cmd 61/10:d0:30:c1:37/00:00:06:00:00/40 tag 26 ncq 8192 out
[178881.825985]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.826011] ata1.00: status: { DRDY }
[178881.826024] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.826045] ata1.00: cmd 61/18:d8:50:c1:37/00:00:06:00:00/40 tag 27 ncq 12288 out
[178881.826048]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.826074] ata1.00: status: { DRDY }
[178881.826086] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.826107] ata1.00: cmd 61/08:e0:d8:a2:35/00:00:06:00:00/40 tag 28 ncq 4096 out
[178881.826110]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.826137] ata1.00: status: { DRDY }
[178881.826149] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.826170] ata1.00: cmd 61/08:e8:d0:a3:35/00:00:06:00:00/40 tag 29 ncq 4096 out
[178881.826173]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.826199] ata1.00: status: { DRDY }
[178881.826211] ata1.00: failed command: WRITE FPDMA QUEUED
[178881.826232] ata1.00: cmd 61/08:f0:50:e5:64/00:00:06:00:00/40 tag 30 ncq 4096 out
[178881.826235]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[178881.826261] ata1.00: status: { DRDY }
[178881.826278] ata1: hard resetting link
[178891.824149] ata1: softreset failed (1st FIS failed)
[178891.824188] ata1: hard resetting link
[178892.320170] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[178892.320874] ata1.00: configured for UDMA/133
[178892.336156] ata1.00: device reported invalid CHS sector 0
[178892.336199] ata1.00: device reported invalid CHS sector 0
[178892.336218] ata1.00: device reported invalid CHS sector 0
[178892.336236] ata1.00: device reported invalid CHS sector 0
[178892.336254] ata1.00: device reported invalid CHS sector 0
[178892.336272] ata1.00: device reported invalid CHS sector 0
[178892.336290] ata1.00: device reported invalid CHS sector 0
[178892.336308] ata1.00: device reported invalid CHS sector 0
[178892.336327] ata1.00: device reported invalid CHS sector 0
[178892.336345] ata1.00: device reported invalid CHS sector 0
[178892.336363] ata1.00: device reported invalid CHS sector 0
[178892.336381] ata1.00: device reported invalid CHS sector 0
[178892.336399] ata1.00: device reported invalid CHS sector 0
[178892.336418] ata1.00: device reported invalid CHS sector 0
[178892.336436] ata1.00: device reported invalid CHS sector 0
[178892.336455] ata1.00: device reported invalid CHS sector 0
[178892.336474] ata1.00: device reported invalid CHS sector 0
[178892.336492] ata1.00: device reported invalid CHS sector 0
[178892.336512] ata1.00: device reported invalid CHS sector 0
[178892.336530] ata1.00: device reported invalid CHS sector 0
[178892.336548] ata1.00: device reported invalid CHS sector 0
[178892.336567] ata1.00: device reported invalid CHS sector 0
[178892.336586] ata1.00: device reported invalid CHS sector 0
[178892.336604] ata1.00: device reported invalid CHS sector 0
[178892.336622] ata1.00: device reported invalid CHS sector 0
[178892.336640] ata1.00: device reported invalid CHS sector 0
[178892.336658] ata1.00: device reported invalid CHS sector 0
[178892.336677] ata1.00: device reported invalid CHS sector 0
[178892.336694] ata1.00: device reported invalid CHS sector 0
[178892.336712] ata1.00: device reported invalid CHS sector 0
[178892.336731] ata1.00: device reported invalid CHS sector 0
[178892.336837] ata1: EH complete

This doesn't happen if the box is both suspended and resumed on battery
power.

I have verified that the issue described above doesn't happen with
the appended patch applied.

The hardware is:

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
        Subsystem: Acer Incorporated [ALI] Device 029e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 22
        Region 0: I/O ports at 8420 [size=8]
        Region 1: I/O ports at 8414 [size=4]
        Region 2: I/O ports at 8418 [size=8]
        Region 3: I/O ports at 8410 [size=4]
        Region 4: I/O ports at 8400 [size=16]
        Region 5: Memory at f0508000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [70] SATA HBA v1.0 InCfgSpace
        Kernel driver in use: ahci

[    3.336087] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.340777] ata1.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
[    3.345233] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.350070] ata1.00: configured for UDMA/133
[    3.354969] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5

Please tell me if there's anything I can do as a permanent workaround.

Thanks,
Rafael


---
 drivers/ata/ahci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/ata/ahci.c
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.c
+++ linux-2.6/drivers/ata/ahci.c
@@ -193,7 +193,7 @@ static const struct ata_port_info ahci_p
 	[board_ahci_sb700] =	/* for SB700 and SB800 */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
-		.flags		= AHCI_FLAG_COMMON,
+		.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NO_DIPM,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_sb600_ops,
