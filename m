Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab1D3RKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 13:10:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab1D3RKU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 13:10:20 -0400
MIME-Version: 1.0
In-Reply-To: <web-515907842@zbackend1.aha.ru>
References: <web-515866242@zbackend1.aha.ru> <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com> <20110430025545.GI9487@ZenIV.linux.org.uk>
 <20110430030243.GJ9487@ZenIV.linux.org.uk> <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
 <web-515898476@zbackend1.aha.ru> <BANLkTi=ujRJYG80F=HKqgz2nPeE5Gro+JA@mail.gmail.com>
 <web-515901951@zbackend1.aha.ru> <BANLkTi=o7NynvukkzE5ZhRHPu43=OV0_Ow@mail.gmail.com>
 <web-515904487@zbackend1.aha.ru> <BANLkTimDHTB+NF8EzjvjBvu0e+MHt8tP1Q@mail.gmail.com>
 <web-515907842@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Apr 2011 10:09:23 -0700
Message-ID: <BANLkTimu=XAj5JDewT9OGTCNHZBf2Oa5+Q@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>, Jens Axboe <jaxboe@fusionio.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/29 werner <w.landgraf@ru.ru>:
> Pls see enclosed:
>
> / lspci š -vvxx
> / dmesg

Ok.

So what strikes me is that it looks like you're basically booting a
"allyesconfig" kernel, or at least something that has a _ton_ of crazy
drivers and filesystems that are entirely irrelevant for your setup.

And I'm wondering whether your problems are due to some buggy driver
that stomps on something that it shouldn't. It's clearly a regression
(your 2.6.38.4 dmesg shows the same "lots of irrelevant drivers and
filesystems" issue, but works for you), but it may explain why others
aren't seeing the problem. Your 2.6.39-rc5 dmesg does have a few new
drivers in it, and that seems to be because they simply didn't exist
back in 2.6.38 (but I didn't check).

So your lspci shows a AMD system with a nvidia chipset:

  00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)
  00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
  00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
  00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
  00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev
a2) (prog-if 10 [OHCI])
  00:02.1 USB Controller: nVidia Corporation MCP61 USB Controller (rev
a2) (prog-if 20 [EHCI])
  00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)
(prog-if 01 [Subtractive decode])
  00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio (rev a2)
  00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2)
(prog-if 8a [Master SecP PriP])
  00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev
a2) (prog-if 85 [Master SecO PriO])
  00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev
a2) (prog-if 00 [Normal decode])
  00:0b.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev
a2) (prog-if 00 [Normal decode])
  00:0c.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev
a2) (prog-if 00 [Normal decode])
  00:0d.0 VGA compatible controller: nVidia Corporation GeForce 6100
nForce 405 (rev a2) (prog-if 00 [VGA])
  00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
  00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
  00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
  00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
  01:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
  04:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit
Ethernet Adapter (rev b0)

and in particular, your IDE/SATA controllers are clearly nVidia. But
the generic IDE driver seems to be a bit confused:

  Uniform Multi-Platform E-IDE driver
  amd74xx 0000:00:06.0: UDMA133 controller
  amd74xx 0000:00:06.0: IDE controller (0x10de:0x03ec rev 0xa2)
  amd74xx 0000:00:06.0: IDE port disabled
  amd74xx 0000:00:06.0: not 100% native mode: will probe irqs later
      ide0: BM-DMA at 0xffa0-0xffa7
  Probing IDE interface ide0...
  ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
  ide_generic: please use "probe_mask=0x3f" module parameter for
probing all legacy ISA IDE ports

but that shouldn't matter, since it doesn't actually find anything there.

But could you try using a more reasonable config, and see if the
problem goes away? Don't configure logfs (you don't use it), don't
configure all the crazy random SCSI drivers, don't configure all the
laptop drivers etc (that cause various management drivers to be loaded
even though you don't even have the hardware afaik):

 ...
  XGIfb: Options (null)
  asus_wmi: Asus Management GUID not found
  asus_wmi: Management GUID not found
  asus_wmi: Management GUID not found
  msi_laptop: driver 0.5 successfully loaded.
  compal-laptop: Motherboard not recognized (You could try the
module's force-parameter)
  dell-wmi: No known WMI GUID found
  dell_wmi_aio: No known WMI GUID found
  acer_wmi: Acer Laptop ACPI-WMI Extras
  acer_wmi: No or unsupported WMI interface, unable to load
  acerhdf: Acer Aspire One Fan driver, v.0.5.24
  acerhdf: unknown (unsupported) BIOS version System
manufacturer/System Product Name/0413   , please report, aborting!
  hp_accel: driver loaded
  hdaps: supported laptop not found!
  hdaps: driver init failed (ret=-19)!
  fujitsu-laptop: driver 0.6.0 successfully loaded.
  This machine doesn't have MSI-hotkeys through WMI
  Topstar Laptop ACPI extras driver loaded
 ...

because if any of them corrupt memory or something like that, we
obviously want to find that bug, but we don't want to think it's some
bug in the drivers you actually _use_.

So if you could try a minimal config that supports only the hardware
(and filesystems) you actually _have_ and use (ie just disable IDE
entirely - you don't want it, you want the SATA_nv driver), that would
be great. Does that work better for you?

And if it does work better, then it would be really interesting to
start enabling things again, and see what causes the problem.

Ok?

                                    Linus
