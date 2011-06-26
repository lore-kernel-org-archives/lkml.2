Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1FZRtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 13:49:00 -0400
Received: from magic.merlins.org ([209.81.13.136]:48726 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1FZRsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 13:48:07 -0400
X-Greylist: delayed 2647 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jun 2011 13:48:07 EDT
Date: Sun, 26 Jun 2011 10:03:45 -0700
From: Marc MERLIN <marc@merlins.org>
To: lkml <linux-kernel@vger.kernel.org>
Message-ID: <20110626170345.GA26430@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux
 2.6.39.1-core2-volpreempt-noide-hm64-20110620/Debian squeeze/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 173.11.111.145
X-SA-Exim-Mail-From: merlin@merlins.org
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -100 AUTHED Received by Exim authenticated user
	* -0.0 T_RP_MATCHES_RCVD Envelope sender domain matches handover relay
	*      domain
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -1.5 GREYLIST_ISWHITE The incoming server has been whitelisted for this
	*      receipient and sender
Subject: All kinds of irq 16: nobody cared with Sandy Bridge Asus P8H67-M
 MB and multiple drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please Cc me on replies so that I can see them faster]

I've found various reports on the net, but usually they are one driver
or one card that's not doing the right thing.

In my case, it happens with multiple cards and drivers and I'm wondering if
it can be a motherboard bug somehow, and if there are linux kernel options
other than irqpoll which does not help, that can shed some light on this.

I just bought a new Sandy Bridge board:
        Manufacturer: ASUSTeK Computer INC.
	        Product Name: P8H67-M PRO
        Vendor: American Megatrends Inc.
	        Version: 1003
		Release Date: 05/10/2011

I suppose the onboard pata could be problematic, but if so why would it only 
fail when some special combination of cards share its irq?
03:00.0 IDE interface: VIA Technologies, Inc. Unknown device 0415
pata_via 0000:03:00.0: version 0.3.4
pata_via 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_via 0000:03:00.0: setting latency timer to 64

I started with 2.6.36 and now have the same problems with 2.6.39.1.
The MB has 2 PCIe slots, and 2 PCI slots.
3 slots get force routed on irq 16, and the last PCI slot is irq 19.
The onboard IDE is also irq 16.

I have tried 6 different PCI and PCIe cards:
- tg3 (gige)
- rtl8169 (gige)
- e100
- CMI8738-MC6
- sata_sil24 (sil 3132)
- sata_mv (marvell)

Pretty much all combinations where I have more than one PCI card plugged
in a slot routed to irq16 causes

irq 16: nobody cared (try booting with the "irqpoll" option)
(...)
handlers:
[<c037171b>] (ata_bmdma_interrupt+0x0/0x170)
[<f8450f1f>] (sil24_interrupt+0x0/0x443 [sata_sil24])
[<f8449d7a>] (e100_intr+0x0/0xa2 [e100])
Disabling IRQ #16

irqpoll makes no difference.

Moving the cards around helps if I only use 2 cards, one in the slot
with irq19 (currently sound card) and one in the slot with irq16.

Putting more than one card on irq 16 (not counting onboard pata) pretty
much always causes the dreaded message.

I however got one very puzzling error with an e100 in the separate irq19
slot once too:
kernel: irq 19: nobody cared (try booting with the "irqpoll" option)
kernel: Pid: 0, comm: swapper Tainted: G        W   2.6.36.0-core2smp-volpreempt-noide-hm64-20100724 #1
kernel: Call Trace:
kernel:  [<c016c7b2>] __report_bad_irq+0x2e/0x6f
kernel:  [<c016c8e6>] note_interrupt+0xf3/0x149
kernel:  [<c016b869>] ? handle_IRQ_event+0x1d/0x9c
kernel:  [<c016cf10>] handle_fasteoi_irq+0x84/0xa2
kernel:  [<c0104683>] handle_irq+0x3b/0x48
kernel:  [<c0103ebc>] do_IRQ+0x41/0x9a
kernel:  [<c0102e30>] common_interrupt+0x30/0x38
kernel:  [<f8776ed2>] ? acpi_idle_enter_bm+0x245/0x281 [processor]
kernel:  [<c03688d6>] cpuidle_idle_call+0x77/0xa9
kernel:  [<c0101a6b>] cpu_idle+0x8e/0xab
kernel:  [<c03e945c>] rest_init+0x58/0x5a
kernel:  [<c05cd8c5>] start_kernel+0x318/0x31d
kernel:  [<c05cd0c9>] i386_start_kernel+0xc9/0xd0
kernel: handlers:
kernel: [<f85ece3a>] (e100_intr+0x0/0xa0 [e100])
kernel: Disabling IRQ #19
(this was just a test, I don't otherwise use that e100 which works fine elsewhere).


This configuration is stable, but anything else on irq16 apparently
regardless of the card, causes issues:
           CPU0       CPU1       CPU2       CPU3       
  0:        151          0          0          0   IO-APIC-edge      timer
  1:          8          0          0          0   IO-APIC-edge      i8042
  4:       1315          0          0          0   IO-APIC-edge      serial
  5:          0          0          0          0   IO-APIC-edge      parport0
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 16:    1240641          0          0          0   IO-APIC-fasteoi   pata_via, sata_sil24
 17:          0          0          0          0   IO-APIC-fasteoi   xhci_hcd:usb1
 18:      11031          0          0          0   IO-APIC-fasteoi   eth1
 19:     312990          0          0          0   IO-APIC-fasteoi   CMI8738-MC6
 20:          0          0          0          0   IO-APIC-fasteoi   ahci
 22:        624          0          0          0   IO-APIC-fasteoi   hda_intel
 23:    3289687          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, ehci_hcd:usb3
NMI:        143         41         64         47   Non-maskable interrupts
LOC:     545170     213741     439101     194418   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:        143         41         64         47   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:       3479       2084      18780       2195   Rescheduling interrupts
CAL:        874       1979       1417       1741   Function call interrupts
TLB:        691        472       1722       1781   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          4          4          4          4   Machine check polls
ERR:          0
MIS:          0

Below are various combinations of failures in case they help:

kernel: irq 16: nobody cared (try booting with the "irqpoll" option)
kernel: Pid: 0, comm: swapper Tainted: G        W   2.6.36.0-core2smp-volpreempt-noide-hm64-20100724 #1
kernel: Call Trace:
kernel:  [<c016c7b2>] __report_bad_irq+0x2e/0x6f
kernel:  [<c016c8e6>] note_interrupt+0xf3/0x149
kernel:  [<c016b869>] ? handle_IRQ_event+0x1d/0x9c
kernel:  [<c016cf10>] handle_fasteoi_irq+0x84/0xa2
kernel:  [<c0104683>] handle_irq+0x3b/0x48
kernel:  [<c0103ebc>] do_IRQ+0x41/0x9a
kernel:  [<c0102e30>] common_interrupt+0x30/0x38
kernel:  [<f8506ed2>] ? acpi_idle_enter_bm+0x245/0x281 [processor]
kernel:  [<c03688d6>] cpuidle_idle_call+0x77/0xa9
kernel:  [<c0101a6b>] cpu_idle+0x8e/0xab
kernel:  [<c03e945c>] rest_init+0x58/0x5a
kernel:  [<c05cd8c5>] start_kernel+0x318/0x31d
kernel:  [<c05cd0c9>] i386_start_kernel+0xc9/0xd0
kernel: handlers:
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<f87a3989>] (mv_interrupt+0x0/0x765 [sata_mv])
kernel: [<c033d3b5>] (ata_bmdma_interrupt+0x0/0x16f)
kernel: [<f87d402a>] (snd_cmipci_interrupt+0x0/0xde [snd_cmipci])
kernel: Disabling IRQ #16


kernel: handlers:
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<c033d3b5>] (ata_bmdma_interrupt+0x0/0x16f)
kernel: [<f8865989>] (mv_interrupt+0x0/0x765 [sata_mv])
kernel: [<f8b9102a>] (snd_cmipci_interrupt+0x0/0xde [snd_cmipci])
kernel: Disabling IRQ #16

kernel: irq 16: nobody cared (try booting with the "irqpoll" option)
kernel: handlers:
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<f84fcde6>] (sil24_interrupt+0x0/0x432 [sata_sil24])
kernel: [<c033d3b5>] (ata_bmdma_interrupt+0x0/0x16f)
kernel: [<f8484e3a>] (e100_intr+0x0/0xa0 [e100])
kernel: Disabling IRQ #16

kernel: irq 16: nobody cared (try booting with the "irqpoll" option)
kernel: Pid: 0, comm: swapper Not tainted 2.6.36.0-core2smp-volpreempt-noide-hm64-20100724 #1
kernel: Call Trace:
kernel:  [<c016c7b2>] __report_bad_irq+0x2e/0x6f
kernel:  [<c016c8e6>] note_interrupt+0xf3/0x149
kernel:  [<c016b869>] ? handle_IRQ_event+0x1d/0x9c
kernel:  [<c016cf10>] handle_fasteoi_irq+0x84/0xa2
kernel:  [<c0104683>] handle_irq+0x3b/0x48
kernel:  [<c0103ebc>] do_IRQ+0x41/0x9a
kernel:  [<c0102e30>] common_interrupt+0x30/0x38
kernel:  [<c03685f9>] ? poll_idle+0x22/0x60
kernel:  [<c03688d6>] cpuidle_idle_call+0x77/0xa9
kernel:  [<c0101a6b>] cpu_idle+0x8e/0xab
kernel:  [<c03e945c>] rest_init+0x58/0x5a
kernel:  [<c05cd8c5>] start_kernel+0x318/0x31d
kernel:  [<c05cd0c9>] i386_start_kernel+0xc9/0xd0
kernel: handlers:
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<c033d3b5>] (ata_bmdma_interrupt+0x0/0x16f)
kernel: [<f8865989>] (mv_interrupt+0x0/0x765 [sata_mv])
kernel: Disabling IRQ #16

kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<c033d3b5>] (ata_bmdma_interrupt+0x0/0x16f)
kernel: [<f8865989>] (mv_interrupt+0x0/0x765 [sata_mv])
kernel: [<f8b9102a>] (snd_cmipci_interrupt+0x0/0xde [snd_cmipci])
kernel: Disabling IRQ #16

kernel: irq 19: nobody cared (try booting with the "irqpoll" option)
kernel: Pid: 0, comm: swapper Tainted: G        W   2.6.36.0-core2smp-volpreempt-noide-hm64-20100724 #1
kernel: Call Trace:
kernel:  [<c016c7b2>] __report_bad_irq+0x2e/0x6f
kernel:  [<c016c8e6>] note_interrupt+0xf3/0x149
kernel:  [<c016b869>] ? handle_IRQ_event+0x1d/0x9c
kernel:  [<c016cf10>] handle_fasteoi_irq+0x84/0xa2
kernel:  [<c0104683>] handle_irq+0x3b/0x48
kernel:  [<c0103ebc>] do_IRQ+0x41/0x9a
kernel:  [<c0102e30>] common_interrupt+0x30/0x38
kernel:  [<f8776ed2>] ? acpi_idle_enter_bm+0x245/0x281 [processor]
kernel:  [<c03688d6>] cpuidle_idle_call+0x77/0xa9
kernel:  [<c0101a6b>] cpu_idle+0x8e/0xab
kernel:  [<c03e945c>] rest_init+0x58/0x5a
kernel:  [<c05cd8c5>] start_kernel+0x318/0x31d
kernel:  [<c05cd0c9>] i386_start_kernel+0xc9/0xd0
kernel: handlers:
kernel: [<f85ece3a>] (e100_intr+0x0/0xa0 [e100])
kernel: Disabling IRQ #19

kernel: handlers:
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<c0284373>] (pcie_pme_irq+0x0/0x6f)
kernel: [<f84fcde6>] (sil24_interrupt+0x0/0x432 [sata_sil24])
kernel: [<c033d3b5>] (ata_bmdma_interrupt+0x0/0x16f)
kernel: [<f8484e3a>] (e100_intr+0x0/0xa0 [e100])
kernel: Disabling IRQ #16

kernel: handlers:
kernel: [<c037171b>] (ata_bmdma_interrupt+0x0/0x170)
kernel: [<f8450f1f>] (sil24_interrupt+0x0/0x443 [sata_sil24])
kernel: [<f8449d7a>] (e100_intr+0x0/0xa2 [e100])
kernel: Disabling IRQ #16

kernel: handlers:
kernel: [<c037171b>] (ata_bmdma_interrupt+0x0/0x170)
kernel: [<f845df1f>] (sil24_interrupt+0x0/0x443 [sata_sil24])
kernel: [<f8d9efbb>] (tg3_interrupt_tagged+0x0/0xa2 [tg3])
kernel: Disabling IRQ #16

kernel: handlers:
kernel: [<c037171b>] (ata_bmdma_interrupt+0x0/0x170)
kernel: [<f85f09c1>] (mv_interrupt+0x0/0x746 [sata_mv])
kernel: [<f87046c1>] (rtl8169_interrupt+0x0/0x2b5 [r8169])
kernel: Disabling IRQ #16

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
