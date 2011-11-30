Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab1K3Ppf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:45:35 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45477 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1K3Ppd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:45:33 -0500
Date: Wed, 30 Nov 2011 16:44:46 +0100
From: Borislav Petkov <bp@amd64.org>
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
Cc: linux-kernel@vger.kernel.org, shane.huang@amd.com
Subject: Re: Unhandled IRQs on AMD E-450
Message-ID: <20111130154445.GA27198@gere.osrc.amd.com>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Shane.

Shane, can you guys take a look at this, sounds like some unfortunate
sharing of AHCI and network IRQ numbers.

Thanks.

On Tue, Nov 29, 2011 at 10:44:42PM +0100, Jeroen Van den Keybus wrote:
> On an Asus E45M1-M PRO (AMD E-450) board with 64-bit Linux 3.0.0
> (Ubuntu) and 3.2.0, I regularly get (more detailed logs at the end):
> 
> 
> Nov 28 04:35:29 zacate kernel: [29581.259926] irq 16: nobody cared
> (try booting with the "irqpoll" option)
> Nov 28 04:35:29 zacate kernel: [29581.259945] Pid: 0, comm: swapper
> Tainted: P            3.0.0-13-generic #22-Ubuntu
> ...
> Nov 28 04:35:29 zacate kernel: [29581.260171] handlers:
> Nov 28 04:35:29 zacate kernel: [29581.260204] [<ffffffffa0085ee0>] irq_handler
> Nov 28 04:35:29 zacate kernel: [29581.260216] [<ffffffffa048efe0>] azx_interrupt
> Nov 28 04:35:29 zacate kernel: [29581.260223] Disabling IRQ #16
> 
> 
> Nov 24 21:25:41 zacate kernel: [  190.503838] irq 19: nobody cared
> (try booting with the "irqpoll" option)
> Nov 24 21:25:41 zacate kernel: [  190.503856] Pid: 0, comm: swapper
> Tainted: P            3.0.0-13-generic #22-Ubuntu
> ...
> Nov 24 21:25:41 zacate kernel: [  190.504052] handlers:
> Nov 24 21:25:41 zacate kernel: [  190.504085] [<ffffffffa0001f40>]
> ahci_interrupt
> Nov 24 21:25:41 zacate kernel: [  190.504101] [<ffffffffa004e6c0>] e1000_intr
> Nov 24 21:25:41 zacate kernel: [  190.504108] Disabling IRQ #19
> 
> 
> I also tried with an untainted 3.2.0-rc2 kernel, in which I also
> disabled threadirqs:
> 
> 
> Nov 24 20:50:41 zacate kernel: [   57.366678] irq 19: nobody cared
> (try booting with the "irqpoll" option)
> Nov 24 20:50:41 zacate kernel: [   57.366690] Pid: 0, comm: swapper
> Not tainted 3.2.0-rc2 #5
> 
> 
> The affected IRQ lines in /proc/interrupts:
> 
>  16:        333        771   IO-APIC-fasteoi   firewire_ohci, hda_intel
> ...
>  19:      39128      15165   IO-APIC-fasteoi   ahci, eth1
>  40:      25641         59   PCI-MSI-edge      eth0
>  41:          0          0   PCI-MSI-edge      xhci_hcd
>  42:          0          0   PCI-MSI-edge      xhci_hcd
>  43:          0          0   PCI-MSI-edge      xhci_hcd
>  44:          2        404   PCI-MSI-edge      hda_intel
>  45:          0          3   PCI-MSI-edge      fglrx[0]@PCI:0:1:0
> 
> 
> The dmesg lines directly pertaining to IRQ 16 and IRQ 19
> 
> [    0.328032] pci 0000:00:15.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.328056] pci 0000:00:15.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.328077] pci 0000:00:15.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.328127] pci 0000:00:15.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.671164] firewire_ohci 0000:05:02.0: PCI INT A -> GSI 16 (level,
> low) -> IRQ 16
> [    5.074619] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
> low) -> IRQ 16
> 
> [    2.010643] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [    2.073026] xhci_hcd 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [    2.090881] xhci_hcd 0000:06:00.0: irq 19, io mem 0xfe900000
> [    2.091040] xhci_hcd 0000:06:00.0: irq 41 for MSI/MSI-X
> [    2.091050] xhci_hcd 0000:06:00.0: irq 42 for MSI/MSI-X
> [    2.091059] xhci_hcd 0000:06:00.0: irq 43 for MSI/MSI-X
> [    2.115098] e1000 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [    5.041614] HDA Intel 0000:00:01.1: PCI INT B -> GSI 19 (level,
> low) -> IRQ 19
> [    5.041711] HDA Intel 0000:00:01.1: irq 44 for MSI/MSI-X
> 
> 
> What I noted:
> 
> - The problem (IRQ lines 16 and 19 getting disabled) occurs fairly
> often, but losing 19 occurs much more frequently than 16.
> - The problem with IRQ19 goes away (at least sufficiently long not to
> be occurring within 24h) when module e1000 is unloaded.
> - The problem persists with and without forced IRQ threading.
> - The problem persists with pci=nocsr.
> - The problem persists with irqfixup.
> - When IRQ19 dies, disk I/O access becomes very slow and unreliable.
> 
> 
> What could be going wrong here ? I note that at least 3 devices
> (00:15.x, 05:02.0 and 00:14.2) have their IRQ lines routed to IRQ 16,
> but I see only 2 handlers in the dmesg log and /proc/interrupts. The
> same applies to IRQ 19 (4 devices: 00:11.0, 06:00.0, 05:01.0 and
> 00:01.0). It is true that some of these ultimately seem to switch to
> MSI (06:00.0 and 00:01.0), but so does the video card (00:01.0), which
> does not route to any IRQ beforehand.
> 
> Before I try finding the problem, I would like to know what a
> plausible failure mechanism is, so if anyone could give a hint on
> where to start looking...
> 
> Thanks for your opinion (and please also CC to my PM address - not
> (yet) subscribed to the LKML),
> 
> 
> J.
> 
> 
> More detailed logs:
> 
> Nov 28 04:35:29 zacate kernel: [29581.259926] irq 16: nobody cared
> (try booting with the "irqpoll" option)
> Nov 28 04:35:29 zacate kernel: [29581.259945] Pid: 0, comm: swapper
> Tainted: P            3.0.0-13-generic #22-Ubuntu
> Nov 28 04:35:29 zacate kernel: [29581.259952] Call Trace:
> Nov 28 04:35:29 zacate kernel: [29581.259958]  <IRQ>
> [<ffffffff810cf96d>] __report_bad_irq+0x3d/0xe0
> Nov 28 04:35:29 zacate kernel: [29581.259986]  [<ffffffff810cfd95>]
> note_interrupt+0x135/0x180
> Nov 28 04:35:29 zacate kernel: [29581.259998]  [<ffffffff810cdd89>]
> handle_irq_event_percpu+0xa9/0x220
> Nov 28 04:35:29 zacate kernel: [29581.260008]  [<ffffffff810cdf4e>]
> handle_irq_event+0x4e/0x80
> Nov 28 04:35:29 zacate kernel: [29581.260019]  [<ffffffff810d06c4>]
> handle_fasteoi_irq+0x64/0xf0
> Nov 28 04:35:29 zacate kernel: [29581.260029]  [<ffffffff8100c252>]
> handle_irq+0x22/0x40
> Nov 28 04:35:29 zacate kernel: [29581.260040]  [<ffffffff815f422a>]
> do_IRQ+0x5a/0xe0
> Nov 28 04:35:29 zacate kernel: [29581.260050]  [<ffffffff815ea913>]
> common_interrupt+0x13/0x13
> Nov 28 04:35:29 zacate kernel: [29581.260056]  <EOI>
> [<ffffffff813725fb>] ? arch_local_irq_enable+0x8/0xd
> Nov 28 04:35:29 zacate kernel: [29581.260079]  [<ffffffff810887a5>] ?
> sched_clock_idle_wakeup_event+0x15/0x20
> Nov 28 04:35:29 zacate kernel: [29581.260089]  [<ffffffff813730ed>]
> acpi_idle_enter_simple+0xcc/0x102
> Nov 28 04:35:29 zacate kernel: [29581.260100]  [<ffffffff814ab5c2>]
> cpuidle_idle_call+0xa2/0x1d0
> Nov 28 04:35:29 zacate kernel: [29581.260112]  [<ffffffff8100920b>]
> cpu_idle+0xab/0x100
> Nov 28 04:35:29 zacate kernel: [29581.260124]  [<ffffffff815b858e>]
> rest_init+0x72/0x74
> Nov 28 04:35:29 zacate kernel: [29581.260134]  [<ffffffff81ad0c2b>]
> start_kernel+0x3d4/0x3df
> Nov 28 04:35:29 zacate kernel: [29581.260144]  [<ffffffff81ad0388>]
> x86_64_start_reservations+0x132/0x136
> Nov 28 04:35:29 zacate kernel: [29581.260156]  [<ffffffff81ad0140>] ?
> early_idt_handlers+0x140/0x140
> Nov 28 04:35:29 zacate kernel: [29581.260165]  [<ffffffff81ad0459>]
> x86_64_start_kernel+0xcd/0xdc
> Nov 28 04:35:29 zacate kernel: [29581.260171] handlers:
> Nov 28 04:35:29 zacate kernel: [29581.260204] [<ffffffffa0085ee0>] irq_handler
> Nov 28 04:35:29 zacate kernel: [29581.260216] [<ffffffffa048efe0>] azx_interrupt
> Nov 28 04:35:29 zacate kernel: [29581.260223] Disabling IRQ #16
> 
> 
> Nov 24 21:25:41 zacate kernel: [  190.503838] irq 19: nobody cared
> (try booting with the "irqpoll" option)
> Nov 24 21:25:41 zacate kernel: [  190.503856] Pid: 0, comm: swapper
> Tainted: P            3.0.0-13-generic #22-Ubuntu
> Nov 24 21:25:41 zacate kernel: [  190.503864] Call Trace:
> Nov 24 21:25:41 zacate kernel: [  190.503870]  <IRQ>
> [<ffffffff810cf96d>] __report_bad_irq+0x3d/0xe0
> Nov 24 21:25:41 zacate kernel: [  190.503898]  [<ffffffff810cfd95>]
> note_interrupt+0x135/0x180
> Nov 24 21:25:41 zacate kernel: [  190.503909]  [<ffffffff810cdd89>]
> handle_irq_event_percpu+0xa9/0x220
> Nov 24 21:25:41 zacate kernel: [  190.503920]  [<ffffffff810cdf4e>]
> handle_irq_event+0x4e/0x80
> Nov 24 21:25:41 zacate kernel: [  190.503930]  [<ffffffff810d06c4>]
> handle_fasteoi_irq+0x64/0xf0
> Nov 24 21:25:41 zacate kernel: [  190.503940]  [<ffffffff8100c252>]
> handle_irq+0x22/0x40
> Nov 24 21:25:41 zacate kernel: [  190.503952]  [<ffffffff815f422a>]
> do_IRQ+0x5a/0xe0
> Nov 24 21:25:41 zacate kernel: [  190.503961]  [<ffffffff815ea913>]
> common_interrupt+0x13/0x13
> Nov 24 21:25:41 zacate kernel: [  190.503967]  <EOI>
> [<ffffffff81094482>] ? tick_nohz_stop_sched_tick+0x2a2/0x3f0
> Nov 24 21:25:41 zacate kernel: [  190.503992]  [<ffffffff810091d5>]
> cpu_idle+0x75/0x100
> Nov 24 21:25:41 zacate kernel: [  190.504004]  [<ffffffff815b858e>]
> rest_init+0x72/0x74
> Nov 24 21:25:41 zacate kernel: [  190.504014]  [<ffffffff81ad0c2b>]
> start_kernel+0x3d4/0x3df
> Nov 24 21:25:41 zacate kernel: [  190.504024]  [<ffffffff81ad0388>]
> x86_64_start_reservations+0x132/0x136
> Nov 24 21:25:41 zacate kernel: [  190.504036]  [<ffffffff81ad0140>] ?
> early_idt_handlers+0x140/0x140
> Nov 24 21:25:41 zacate kernel: [  190.504045]  [<ffffffff81ad0459>]
> x86_64_start_kernel+0xcd/0xdc
> Nov 24 21:25:41 zacate kernel: [  190.504052] handlers:
> Nov 24 21:25:41 zacate kernel: [  190.504085] [<ffffffffa0001f40>]
> ahci_interrupt
> Nov 24 21:25:41 zacate kernel: [  190.504101] [<ffffffffa004e6c0>] e1000_intr
> Nov 24 21:25:41 zacate kernel: [  190.504108] Disabling IRQ #19
> 
> 
> Nov 24 20:50:41 zacate kernel: [   57.366678] irq 19: nobody cared
> (try booting with the "irqpoll" option)
> Nov 24 20:50:41 zacate kernel: [   57.366690] Pid: 0, comm: swapper
> Not tainted 3.2.0-rc2 #5
> Nov 24 20:50:41 zacate kernel: [   57.366694] Call Trace:
> Nov 24 20:50:41 zacate kernel: [   57.366697]  <IRQ>
> [<ffffffff810bb9cd>] __report_bad_irq+0x3d/0xe0
> Nov 24 20:50:41 zacate kernel: [   57.366715]  [<ffffffff810bbe0d>]
> note_interrupt+0x14d/0x210
> Nov 24 20:50:41 zacate kernel: [   57.366721]  [<ffffffff810b98a4>]
> handle_irq_event_percpu+0xc4/0x290
> Nov 24 20:50:41 zacate kernel: [   57.366728]  [<ffffffff810b9ab8>]
> handle_irq_event+0x48/0x70
> Nov 24 20:50:41 zacate kernel: [   57.366733]  [<ffffffff810bc7fa>]
> handle_fasteoi_irq+0x5a/0xe0
> Nov 24 20:50:41 zacate kernel: [   57.366740]  [<ffffffff81004012>]
> handle_irq+0x22/0x40
> Nov 24 20:50:41 zacate kernel: [   57.366747]  [<ffffffff81506b6a>]
> do_IRQ+0x5a/0xd0
> Nov 24 20:50:41 zacate kernel: [   57.366753]  [<ffffffff814fe72b>]
> common_interrupt+0x6b/0x6b
> Nov 24 20:50:41 zacate kernel: [   57.366756]  <EOI>
> [<ffffffff81009906>] ? native_sched_clock+0x26/0x70
> Nov 24 20:50:41 zacate kernel: [   57.366773]  [<ffffffffa00cc0d3>] ?
> acpi_idle_enter_simple+0xc5/0x102 [processor]
> Nov 24 20:50:41 zacate kernel: [   57.366781]  [<ffffffffa00cc0ce>] ?
> acpi_idle_enter_simple+0xc0/0x102 [processor]
> Nov 24 20:50:41 zacate kernel: [   57.366788]  [<ffffffff814223a8>]
> cpuidle_idle_call+0xb8/0x230
> Nov 24 20:50:41 zacate kernel: [   57.366795]  [<ffffffff81001215>]
> cpu_idle+0xc5/0x130
> Nov 24 20:50:41 zacate kernel: [   57.366802]  [<ffffffff814e2360>]
> rest_init+0x94/0xa4
> Nov 24 20:50:41 zacate kernel: [   57.366809]  [<ffffffff81aafba4>]
> start_kernel+0x3a7/0x3b4
> Nov 24 20:50:41 zacate kernel: [   57.366815]  [<ffffffff81aaf322>]
> x86_64_start_reservations+0x132/0x136
> Nov 24 20:50:41 zacate kernel: [   57.366821]  [<ffffffff81aaf416>]
> x86_64_start_kernel+0xf0/0xf7
> Nov 24 20:50:41 zacate kernel: [   57.366824] handlers:
> Nov 24 20:50:41 zacate kernel: [   57.366834] [<ffffffffa0043c10>]
> ahci_interrupt
> Nov 24 20:50:41 zacate kernel: [   57.366843] [<ffffffffa006f4f0>] e1000_intr
> Nov 24 20:50:41 zacate kernel: [   57.366847] Disabling IRQ #19
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
