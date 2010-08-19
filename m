Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0HSLfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:35:08 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:56472 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0HSLfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:35:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Subject: Buggy MTRR configuration set by the BIOS without an easy fix
Date: Thu, 19 Aug 2010 13:34:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.2; KDE/4.5.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191335.00246.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I've been struggling with my Dell E6500 MTRR setup to configure the video RAM 
in write-combining mode.

The system memory map is

00000000-00000fff : reserved
00001000-0009bbff : System RAM
0009bc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000d7fff : pnp 00:0c
000d8000-000dffff : PCI Bus 0000:00
000e0000-000fffff : pnp 00:0c
00100000-7904d3ff : System RAM
  01000000-01521c44 : Kernel code
  01521c45-017a7cef : Kernel data
  01821000-018be5e3 : Kernel bss
7904d400-7904f3ff : ACPI Non-volatile Storage
7904f400-7bffffff : reserved
  79b00000-79bfffff : pnp 00:0c
7c000000-f7ffffff : PCI Bus 0000:00
  7c000000-7fffffff : PCI Bus 0000:03
    7c000000-7fffffff : PCI CardBus 0000:04
  80000000-801fffff : PCI Bus 0000:0b
  80200000-803fffff : PCI Bus 0000:0b
  80400000-805fffff : PCI Bus 0000:0c
  80600000-807fffff : PCI Bus 0000:0d
  80800000-809fffff : PCI Bus 0000:0d
  80a00000-80a00fff : Intel Flush Page
  84000000-87ffffff : PCI CardBus 0000:04
  e0000000-efffffff : 0000:00:02.0
  f0000000-f01fffff : PCI Bus 0000:0e
  f6500000-f65fffff : PCI Bus 0000:03
    f6500000-f6500fff : 0000:03:01.0
      f6500000-f6500fff : yenta_socket
    f65ff600-f65ff6ff : 0000:03:01.2
      f65ff600-f65ff6ff : mmc0
    f65ff800-f65fffff : 0000:03:01.1
      f65ff800-f65fffff : ohci1394
  f6600000-f68fffff : PCI Bus 0000:0e
  f6900000-f69fffff : PCI Bus 0000:0c
    f69fe000-f69fffff : 0000:0c:00.0
      f69fe000-f69fffff : iwlagn
  f6ad9ef0-f6ad9eff : 0000:00:03.0
  f6ad9f00-f6ad9fff : 0000:00:1f.3
  f6ada000-f6adafff : 0000:00:03.3                                                                                                                         
  f6adb000-f6adbfff : 0000:00:19.0                                                                                                                         
    f6adb000-f6adbfff : e1000e                                                                                                                             
  f6adc000-f6adffff : 0000:00:1b.0                                                                                                                         
    f6adc000-f6adffff : ICH HD audio
  f6ae0000-f6afffff : 0000:00:19.0
    f6ae0000-f6afffff : e1000e
  f6b00000-f6bfffff : 0000:00:02.1
  f6c00000-f6ffffff : 0000:00:02.0
f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
  f8000000-fbffffff : reserved
    f8000000-fbffffff : pnp 00:0c
fc000000-febfffff : PCI Bus 0000:00
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fec10000-fecfffff : PCI Bus 0000:00
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : pnp 00:08
fed18000-fed1bfff : reserved
  fed18000-fed1bfff : pnp 00:0c
fed1c000-fed1ffff : PCI Bus 0000:00
  fed1c000-fed1c3ff : 0000:00:1d.7
    fed1c000-fed1c3ff : ehci_hcd
  fed1c400-fed1c7ff : 0000:00:1a.7
    fed1c400-fed1c7ff : ehci_hcd
  fed1c800-fed1cfff : 0000:00:1f.2
    fed1c800-fed1cfff : pnp 00:0c
      fed1c800-fed1cfff : ahci
fed20000-fed8ffff : reserved
  fed20000-fed3ffff : pnp 00:0c
  fed40000-fed44fff : PCI Bus 0000:00
    fed40000-fed44fff : pnp 00:09
  fed45000-fed8ffff : pnp 00:0c
fed90000-fed9ffff : PCI Bus 0000:00
feda0000-feda5fff : reserved
  feda0000-feda3fff : pnp 00:0c
  feda4000-feda4fff : pnp 00:0c
  feda5000-feda5fff : pnp 00:0c
feda6000-feda6fff : pnp 00:0c
feda7000-fedfffff : PCI Bus 0000:00
fee00000-fee0ffff : reserved
  fee00000-fee0ffff : pnp 00:0c
    fee00000-fee00fff : Local APIC
fee10000-ff9fffff : PCI Bus 0000:00
ffa00000-ffbfffff : pnp 00:0c
ffc00000-ffdfffff : PCI Bus 0000:00
ffe60000-ffffffff : reserved

My CPU has 7 MTRRs setup by the BIOS the following way:

MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D7FFF write-protect
  D8000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask 800000000 write-back
  1 base 0E0000000 mask FE0000000 uncachable
  2 base 079C00000 mask FFFC00000 uncachable
  3 base 07A000000 mask FFE000000 uncachable
  4 base 07C000000 mask FFC000000 uncachable
  5 disabled
  6 disabled

The resulting memory configuration is

0000 0000 - 000f ffff					Covered by fixed-range MTRRs
0010 0000 - 79bf ffff					Write-back (MTRR 0)
79c0 0000 - 7fff ffff					Uncachable (MTRRS 2, 3 and 4)
8000 0000 - dfff ffff 					Write-back (MTRR 0)
e000 0000 - ffff ffff	 				Uncachable (MTRR 4)

I'm a bit suprised that the 8000 0000 - 87ff ffff range is configured as 
write-back, as it covers a PCI memory range. Maybe that's a BIOS bug that just 
goes unnoticed because no peripheral uses that range.

To configure video RAM in write-combining mode, I need to remove the write-
back mapping covering all system memory (as a write-combining mapping can't 
overlap with any other mapping) and reprogram the MTRRs accordingly.

If I keep the default uncached memory type, the MTRR setup closest to my 
memory map that I've been able to find is

0000 0000 - 000f ffff					Covered by fixed-range MTRRs
0010 0000 - 400f ffff (1024 MB)		Write-back (MTRR 0)
4010 0000 - 600f ffff (512 MB)		Write-back (MTRR 1)
6010 0000 - 700f ffff (256 MB)		Write-back (MTRR 2)
7010 0000 - 780f ffff (128 MB)		Write-back (MTRR 3)
7810 0000 - 790f ffff (16 MB)		Write-back (MTRR 4)
7910 0000 - 7fff ffff					Uncachable (default)
8000 0000 - 87ff ffff (128 MB)		Write-back (MTRR 5)
8800 0000 - dfff ffff					Uncachable (default)
e000 0000 - efff ffff (256 MB)		Write-combining (MTRR 6)
f000 0000 - ffff ffff					Uncachable (default)

Compared to what the BIOS configures, this will modify the 7910 0000 - 79bf 
ffff and 8800 0000 - dfff ffff ranges from write-back to uncachable. While the 
second range doesn't worry me as it's not used in the memory map (but maybe I 
should still worry :-)), the first one is reserved and used for an unknown (to 
me) purpose, so it could have a negative impact on performances.

Another solution would be to turn the default memory type from uncachable to 
write-back. The memory map would then become

0000 0000 - 000f ffff					Covered by fixed-range MTRRs
0010 0000 - 79bf ffff 					Write-back (default)
79c0 0000 - 79ff ffff (4 MB)			Uncachable (MTRR 0)
7a00 0000 - 7bff ffff (32 MB)		Uncachable (MTRR 1)
7c00 0000 - 7fff ffff (64 MB)		Uncachable (MTRR 2)
8000 0000 - dfff ffff					Write-back (default)
e000 0000 - efff ffff (256 MB)		Write-combining (MTRR 3)
f000 0000 - ffff ffff (256 MB)		Uncachable (MTRR 4)

The memory map will then be identical to what the BIOS configured (except for 
video RAM of course). The problem here is that /proc/mtrr doesn't support 
changing the default memory type, so I can't easily apply this configuration.

I'd appreciate if someone could help me to fix my MTRRs. Are my understanding 
of the problem and the two proposed solutions correct ? Should I use one of 
those two, or is there another easier/more efficient solution (maybe moving 
some PCI memory ranges around - if at all possible - to make the memory map 
simpler) ?

Please CC me on answers.

-- 
Regards,

Laurent Pinchart
