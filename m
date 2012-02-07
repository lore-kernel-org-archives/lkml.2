Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2BGOwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:52:24 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:40735 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab2BGOwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:52:23 -0500
Date: Tue, 7 Feb 2012 15:52:05 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org
Subject: Re: Linux 3.2.5
Message-ID: <20120207145205.GA22034@citd.de>
References: <20120206181622.GA28811@kroah.com>
 <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
 <20120207105835.GA12864@citd.de>
 <4F310DBC.1040501@ladisch.de>
 <20120207114806.GA15323@citd.de>
 <4F3118F7.8050205@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3118F7.8050205@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.2012 13:28, Clemens Ladisch wrote:
> Matthias Schniedermeyer wrote:
> > On 07.02.2012 12:40, Clemens Ladisch wrote:
> >> Matthias Schniedermeyer wrote:
> >>> On 07.02.2012 11:19, Clemens Ladisch wrote:
> >>>> Matthias Schniedermeyer wrote:
> >>>>> pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> >>>>
> >>>> Please try that kernel parameter.
> >>>
> >>> I don't want/need ASPM, disabled is fine with me.
> >>
> >> In your case, it appears that sound requires ASPM.
> >
> > OK. I will try that later today.
> >
> > But i'm not hopeful because in syslog it says:
> > ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> > ...
> > ACPI _OSC control for PCIe not granted, disabling ASPM
> >
> > So if ACPI doesn't want to relinquish control of ASPM, how is Linux
> > supposed to enable it?

So i am now running 3.2.5 with pcie_aspm=force and i have sound.

> According to your logs, 3.2.4 didn't touch device 5:0, while 3.2.5 does
> disable ASPM.  (Are there any other messages regarding 0000:05:00.0?)

>From the 3.2.5 with pcie_aspm=force this is:
[    0.792880] pci 0000:05:00.0: [1283:8892] type 1 class 0x000604
[    0.793040] pci 0000:05:00.0: supports D1 D2
[    0.793041] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.793047] pci 0000:05:00.0: PME# disabled
[    0.795440] pci 0000:05:00.0: PCI bridge to [bus 06-06]
[    0.795485] pci 0000:05:00.0:   bridge window [io  0xc000-0xcfff]
[    0.795491] pci 0000:05:00.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.815911] pci 0000:05:00.0: PCI bridge to [bus 06-06]
[    0.815949] pci 0000:05:00.0:   bridge window [io  0xc000-0xcfff]
[    0.815994] pci 0000:05:00.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.816484] pci 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.816527] pci 0000:05:00.0: setting latency timer to 64

> It appears that this patch introduces new logic that forcibly disables
> ASPM on pre-1.1 devices no matter what the BIOS says, although this
> breaks your sound.
> 
> ("Disable" can mean two things, tell the device to not do ASPM, or just
> not tell the device anything.)

As far as i understand the matter the change was supposed to do 
"nothing" whereas 3.2.4 did something, but in my case the opposite 
happend, whereas 3.2.4 didn't do something that 3.2.5 (without force) 
does.

The messages regarding aspm with 3.2.5 and foce are:
dmesg | grep -i aspm
[    0.000000] Command line: root=/dev/sda2 pcie_aspm=force
[    0.000000] Kernel command line: root=/dev/sda2 pcie_aspm=force
[    0.000000] PCIe ASPM is forcibly enabled
[    0.761782] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.795906] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.627705] e1000e 0000:03:00.0: Disabling ASPM  L1
[    4.259301] snd_emu10k1 0000:06:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16


I guess this whole mess is Mainboard specifc.
I have a another, very similar system but with an Asus P8H67-M PRO 
Mainbaord.

I just remotly booted that machine into 3.2.5, so i can't verify if the 
sound works, but as the dmesg-output appears identical to the previous 
boot of 3.2.0 so i guess i will work.

This is all i get for the system for aspm
dmesg | grep -i aspm
[    0.777824] e1000e 0000:02:00.0: Disabling ASPM L0s

So that mainboard has another BIOS/UEFI-Firmware and the 
PCIe-PCI-Bridge, the Soundblaster-Live is behind, is from another 
manufacture.

lspci -v -s 5:0
05:00.0 PCI bridge: ASMedia Technology Inc. ASM108x PCIe to PCI Bridge Controller (rev 01) (prog-if 01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=05, secondary=06, subordinate=06, sec-latency=32
        I/O behind bridge: 0000b000-0000bfff
        Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Device 8489





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

