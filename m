Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1AHLbD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 06:31:03 -0500
Received: from hydra.rus.uni-stuttgart.de ([129.69.1.55]:34570 "EHLO
	hydra.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab1AHLbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 06:31:00 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jan 2011 06:31:00 EST
Message-ID: <4D2848F0.8070906@rus.uni-stuttgart.de>
Date: Sat, 08 Jan 2011 12:22:24 +0100
From: Thomas Richter <richter@rus.uni-stuttgart.de>
Reply-To: richter@rus.uni-stuttgart.de
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: nvidia pata driver hangs on fsync
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

this is a bug report on drivers/ata/pata_amd.c for at least the kernel 
versions 2.6.32.27 and 2.6.35.10. It might affect other kernels.

Configuration is as follows:

Asus M2N-SLI board with Nforce4 chipset. lspci reports the following:

00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1)
00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2)
00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2)
00:06.1 Audio device: nVidia Corporation MCP55 High Definition Audio 
(rev a2)
00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:09.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:06.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 07)
01:06.1 Input device controller: Creative Labs SB Live! Game Port (rev 07)
01:07.0 Parallel controller: Timedia Technology Co Ltd Device 7268 (rev 01)
01:08.0 SCSI storage controller: Tekram Technology Co.,Ltd. TRM-S1040 
(rev 01)
01:0b.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A 
IEEE-1394a-2000 Controller (PHY/Link)
03:00.0 VGA compatible controller: nVidia Corporation NV43 [GeForce 6600 
GT] (rev a2)


Two CD/DVD/DVD-RAM drivers (master/slave) are connected to the PATA 
interface of the chipset and accessed via udma2 according to hdparm.
The PATA interface is accessed through drivers/ata/pata_amd.c.

Problem:

mke2fs hangs reliably on formatting a filing system on DVD-RAM(!), for 
either drive. Specifically, running mke2fs through strace shows that the 
writes and seeks go to the drive fine, but after writing inode 
information, mke2fs issues an fsync, and in that fsync the driver just 
hangs. The drives show no further activity, and the system must be 
rebooted to regain access. The issued command is:

mke2fs -t ext2 -b 2048 /dev/srX with X = 0 or 1 (hangs for master or 
slave, always reproducible)

The problem does not appear with the legacy IDE driver, i.e. through 
drivers/ide/amd74xx.c on which the cdroms work correctly and mke2fs 
works fine. Drives are here also configured for udma2:
/dev/hda:

ATAPI CD-ROM, with removable media
         Model Number:       _NEC DVD_RW ND-4571A
         Serial Number:
         Firmware Revision:  1-01
Standards:
         Likely used CD-ROM ATAPI-1
Configuration:
         DRQ response: 3ms.
         Packet size: 12 bytes
Capabilities:
         LBA, IORDY(cannot be disabled)
         DMA: mdma0 mdma1 mdma2 udma0 udma1 *udma2
              Cycle time: min=120ns recommended=120ns
         PIO: pio0 pio1 pio2 pio3 pio4
              Cycle time: no flow control=120ns  IORDY flow control=120ns

ATAPI CD-ROM, with removable media
         Model Number:       HL-DT-ST DVDRAM GSA-4040B
         Serial Number:      K2938AC0452
         Firmware Revision:  A304
Standards:
         Likely used CD-ROM ATAPI-1
Configuration:
         DRQ response: 50us.
         Packet size: 12 bytes
Capabilities:
         LBA, IORDY(can be disabled)
         DMA: mdma0 mdma1 mdma2 udma0 udma1 *udma2
              Cycle time: min=120ns recommended=120ns
         PIO: pio0 pio1 pio2 pio3 pio4
              Cycle time: no flow control=120ns  IORDY flow control=120ns
HW reset results:
         CBLID- above Vih
         Device num = 1

Greetings,

Thomas Richter

