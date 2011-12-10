Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968Ab1LJMRH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:17:07 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51488 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1LJMRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:17:04 -0500
MIME-Version: 1.0
In-Reply-To: <4EE20531.7000607@ladisch.de>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
	<20111130154445.GA27198@gere.osrc.amd.com>
	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
	<4EDB6C10.10102@ladisch.de>
	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
	<CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>
	<CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com>
	<CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com>
	<4EDBA70E.3090905@ladisch.de>
	<CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com>
	<CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com>
	<4EE0B156.4080708@ladisch.de>
	<CAPRPZsDmbfESXov1XzOYXv6WSTFAevNwD5jyBdwGU--kffLaMQ@mail.gmail.com>
	<4EE1C55B.9010708@ladisch.de>
	<CAPRPZsDtPhjm2S5QxDSkDV2zsz+ABCkL_Rkeq-=Fnpx4+Czzcw@mail.gmail.com>
	<4EE20531.7000607@ladisch.de>
Date: Sat, 10 Dec 2011 13:10:29 +0100
Message-ID: <CAPRPZsBfLyWBSEO7UHc9irpKq-AhjT053BFQV=tamPYTb7SvsQ@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Temporarily disabling an irq is different from completely shutting it
> down.

Yes, but when unloading / reloading the driver, it seems that, at
least for the I/O-APIC, no more than that actually happens. (I've read
the original Intel I/O-APIC datasheet and the only way to clear a
pending IRQ is to do it by means of a message from the (local) APIC -
apart from some dirty trickery with modifying the IRQ type entry)

>>> All PCI interrupts (whether 'real' lines in hardware or emulated with
>>> PCIe messages) end up at the I/O-APIC.
>>
>> That would mean that the IO-APIC would decode MSI messages.

I was wrong there. Indeed the INTx Assert/Deassert messages are
entirely different and picked up by the I/O-APIC. The fact that,
without legacy PCI interrupts, IRQs 17 and 18 have never failed
indicates that the problem lies with the PCI/PCIe bridge. I'm thinking
of the following scenario:
- PCI device raises IRQ line.
- Bridge sees the transition and signals Assert.
- Assert travels through the PCIe fabric and arrives at the I/O-APIC.
- CPU services the IRQ, and does at least one (slow) PCI read to have
the device deassert its IRQ line. In practice, more PCI read/writes
are needed, requiring the bridge to do some PCIe traffic generation.
- Bridge sees the IRQ line trasition and signals Deassert, This
message has only a few usecs to arrive at the I/O-APIC.
- _However_ the CPU has by large already handled the IRQ and gets
interrupted again before the Deassert ever gets out. The resulting PCI
bus traffic further delays the Deassert message (due to e.g. PCIe
transmit credit exhaustion).

Another scenarion is an electrical problem such as insufficient margin
for high INTx signal detection. But I'll have to wire the setup to
test that.

My idea is that if we would not immediately hammer the bridge with
PCIe transactions, the Deassert message may eventually arrive ? Also,
is there any control by Linux of the credits issued ?

I therefore patched the polling system by detecting a stuck IRQ
already after 10 unserviced IRQs. Then the polling system will take
over for 50 cycles (5 seconds), after which the IRQ is reenabled. The
10 cycles may seem not too much, but usually there are no unserviced
IRQs at all, and I reenable the IRQ anyway after 5 seconds. And the
storms, if the IRQ is really stuck, are very small bursts of 10 IRQs,
causing no significant overhead. The alternative is a system unable to
run Linux.

It is not very elegant, but it gets the job done and allows the kernel
to recover from a single upset. Also, interrupt storms lasting over 1
second are avoided.


Results so far:


dmesg log:

...
[   25.605552] init: plymouth-upstart-bridge main process (508) killed
by TERM signal
[   26.641229] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[ 1607.941232] irq 19: nobody cared (try booting with the "irqpoll" option)
[ 1607.941244] Pid: 0, comm: swapper Not tainted 3.2.0-rc4 #5
[ 1607.941248] Call Trace:
[ 1607.941252]  <IRQ>  [<ffffffff810bbe9d>] __report_bad_irq+0x3d/0xe0
[ 1607.941269]  [<ffffffff810bc147>] note_interrupt+0x157/0x200
[ 1607.941276]  [<ffffffff810b9a54>] handle_irq_event_percpu+0xc4/0x290
[ 1607.941282]  [<ffffffff810b9c68>] handle_irq_event+0x48/0x70
[ 1607.941288]  [<ffffffff810bcb1a>] handle_fasteoi_irq+0x5a/0xe0
[ 1607.941295]  [<ffffffff81004012>] handle_irq+0x22/0x40
[ 1607.941301]  [<ffffffff8150712a>] do_IRQ+0x5a/0xd0
[ 1607.941311]  [<ffffffff814feceb>] common_interrupt+0x6b/0x6b
[ 1607.941314]  <EOI>  [<ffffffff81423b10>] ? ladder_select_state+0x180/0x180
[ 1607.941325]  [<ffffffff81422904>] ? cpuidle_idle_call+0xf4/0x230
[ 1607.941331]  [<ffffffff814228c8>] ? cpuidle_idle_call+0xb8/0x230
[ 1607.941338]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[ 1607.941345]  [<ffffffff814e2910>] rest_init+0x94/0xa4
[ 1607.941350]  [<ffffffff81aafba4>] start_kernel+0x3a7/0x3b4
[ 1607.941357]  [<ffffffff81aaf322>] x86_64_start_reservations+0x132/0x136
[ 1607.941363]  [<ffffffff81aaf416>] x86_64_start_kernel+0xf0/0xf7
[ 1607.941367] handlers:
[ 1607.941378] [<ffffffffa006f4f0>] e1000_intr
[ 1607.941382] Disabling IRQ 19
[ 1608.040189] Polling IRQ.
[ 1608.140227] Polling IRQ.
...
[ 1612.840243] Polling IRQ.
[ 1612.940039] Polling IRQ.
[ 1613.040185] Reenabling IRQ.
[ 1908.541558] irq 19: nobody cared (try booting with the "irqpoll" option)
[ 1908.541570] Pid: 0, comm: swapper Not tainted 3.2.0-rc4 #5
[ 1908.541574] Call Trace:
[ 1908.541578]  <IRQ>  [<ffffffff810bbe9d>] __report_bad_irq+0x3d/0xe0
[ 1908.541595]  [<ffffffff810bc147>] note_interrupt+0x157/0x200
[ 1908.541602]  [<ffffffff810b9a54>] handle_irq_event_percpu+0xc4/0x290
[ 1908.541608]  [<ffffffff810b9c68>] handle_irq_event+0x48/0x70
[ 1908.541614]  [<ffffffff810bcb1a>] handle_fasteoi_irq+0x5a/0xe0
[ 1908.541620]  [<ffffffff81004012>] handle_irq+0x22/0x40
[ 1908.541627]  [<ffffffff8150712a>] do_IRQ+0x5a/0xd0
[ 1908.541633]  [<ffffffff814feceb>] common_interrupt+0x6b/0x6b
[ 1908.541637]  <EOI>  [<ffffffff81423b34>] ? menu_reflect+0x24/0x50
[ 1908.541647]  [<ffffffff810011da>] ? cpu_idle+0x8a/0x130
[ 1908.541652]  [<ffffffff81001215>] ? cpu_idle+0xc5/0x130
[ 1908.541659]  [<ffffffff814e2910>] rest_init+0x94/0xa4
[ 1908.541665]  [<ffffffff81aafba4>] start_kernel+0x3a7/0x3b4
[ 1908.541672]  [<ffffffff81aaf322>] x86_64_start_reservations+0x132/0x136
[ 1908.541678]  [<ffffffff81aaf416>] x86_64_start_kernel+0xf0/0xf7
[ 1908.541681] handlers:
[ 1908.541695] [<ffffffffa006f4f0>] e1000_intr
[ 1908.541699] Disabling IRQ 19
[ 1908.640189] Polling IRQ.
[ 1908.740186] Polling IRQ.
...
[ 1913.440205] Polling IRQ.
[ 1913.540205] Polling IRQ.
[ 1913.640088] Reenabling IRQ.
[ 2319.361659] irq 19: nobody cared (try booting with the "irqpoll" option)
[ 2319.361671] Pid: 0, comm: swapper Not tainted 3.2.0-rc4 #5
[ 2319.361675] Call Trace:
[ 2319.361679]  <IRQ>  [<ffffffff810bbe9d>] __report_bad_irq+0x3d/0xe0
[ 2319.361696]  [<ffffffff810bc147>] note_interrupt+0x157/0x200
[ 2319.361702]  [<ffffffff810b9a54>] handle_irq_event_percpu+0xc4/0x290
[ 2319.361709]  [<ffffffff810b9c68>] handle_irq_event+0x48/0x70
[ 2319.361715]  [<ffffffff810bcb1a>] handle_fasteoi_irq+0x5a/0xe0
[ 2319.361721]  [<ffffffff81004012>] handle_irq+0x22/0x40
[ 2319.361727]  [<ffffffff8150712a>] do_IRQ+0x5a/0xd0
[ 2319.361734]  [<ffffffff814feceb>] common_interrupt+0x6b/0x6b
[ 2319.361737]  <EOI>  [<ffffffff81009926>] ? native_sched_clock+0x26/0x70
[ 2319.361754]  [<ffffffffa00cd0de>] ?
acpi_idle_enter_simple+0xd0/0x102 [processor]
[ 2319.361762]  [<ffffffffa00cd0ce>] ?
acpi_idle_enter_simple+0xc0/0x102 [processor]
[ 2319.361769]  [<ffffffff814228c8>] cpuidle_idle_call+0xb8/0x230
[ 2319.361776]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[ 2319.361783]  [<ffffffff814e2910>] rest_init+0x94/0xa4
[ 2319.361789]  [<ffffffff81aafba4>] start_kernel+0x3a7/0x3b4
[ 2319.361796]  [<ffffffff81aaf322>] x86_64_start_reservations+0x132/0x136
[ 2319.361802]  [<ffffffff81aaf416>] x86_64_start_kernel+0xf0/0xf7
[ 2319.361806] handlers:
[ 2319.361816] [<ffffffffa006f4f0>] e1000_intr
[ 2319.361820] Disabling IRQ 19
[ 2319.460205] Polling IRQ.
[ 2319.560207] Polling IRQ.
...
[ 2324.260030] Polling IRQ.
[ 2324.360118] Polling IRQ.
[ 2324.460064] Reenabling IRQ.
[ 2782.285470] irq 19: nobody cared (try booting with the "irqpoll" option)
[ 2782.285482] Pid: 0, comm: swapper Not tainted 3.2.0-rc4 #5
[ 2782.285486] Call Trace:
[ 2782.285490]  <IRQ>  [<ffffffff810bbe9d>] __report_bad_irq+0x3d/0xe0
[ 2782.285507]  [<ffffffff810bc147>] note_interrupt+0x157/0x200
[ 2782.285514]  [<ffffffff810b9a54>] handle_irq_event_percpu+0xc4/0x290
[ 2782.285520]  [<ffffffff810b9c68>] handle_irq_event+0x48/0x70
[ 2782.285526]  [<ffffffff810bcb1a>] handle_fasteoi_irq+0x5a/0xe0
[ 2782.285532]  [<ffffffff81004012>] handle_irq+0x22/0x40
[ 2782.285539]  [<ffffffff8150712a>] do_IRQ+0x5a/0xd0
[ 2782.285545]  [<ffffffff814feceb>] common_interrupt+0x6b/0x6b
[ 2782.285548]  <EOI>  [<ffffffff81009926>] ? native_sched_clock+0x26/0x70
[ 2782.285566]  [<ffffffffa00cd0d3>] ?
acpi_idle_enter_simple+0xc5/0x102 [processor]
[ 2782.285574]  [<ffffffffa00cd0ce>] ?
acpi_idle_enter_simple+0xc0/0x102 [processor]
[ 2782.285581]  [<ffffffff814228c8>] cpuidle_idle_call+0xb8/0x230
[ 2782.285588]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[ 2782.285594]  [<ffffffff814e2910>] rest_init+0x94/0xa4
[ 2782.285600]  [<ffffffff81aafba4>] start_kernel+0x3a7/0x3b4
[ 2782.285607]  [<ffffffff81aaf322>] x86_64_start_reservations+0x132/0x136
[ 2782.285613]  [<ffffffff81aaf416>] x86_64_start_kernel+0xf0/0xf7
[ 2782.285617] handlers:
[ 2782.285627] [<ffffffffa006f4f0>] e1000_intr
[ 2782.285631] Disabling IRQ 19
[ 2782.384226] Polling IRQ.
[ 2782.484041] Polling IRQ.
...
[ 2787.184224] Polling IRQ.
[ 2787.284223] Polling IRQ.
[ 2787.384222] Reenabling IRQ.
[ 3485.689347] irq 19: nobody cared (try booting with the "irqpoll" option)
[ 3485.689360] Pid: 0, comm: swapper Not tainted 3.2.0-rc4 #5
[ 3485.689364] Call Trace:
[ 3485.689368]  <IRQ>  [<ffffffff810bbe9d>] __report_bad_irq+0x3d/0xe0
[ 3485.689385]  [<ffffffff810bc147>] note_interrupt+0x157/0x200
[ 3485.689392]  [<ffffffff810b9a54>] handle_irq_event_percpu+0xc4/0x290
[ 3485.689398]  [<ffffffff810b9c68>] handle_irq_event+0x48/0x70
[ 3485.689404]  [<ffffffff810bcb1a>] handle_fasteoi_irq+0x5a/0xe0
[ 3485.689411]  [<ffffffff81004012>] handle_irq+0x22/0x40
[ 3485.689417]  [<ffffffff8150712a>] do_IRQ+0x5a/0xd0
[ 3485.689424]  [<ffffffff814feceb>] common_interrupt+0x6b/0x6b
[ 3485.689427]  <EOI>  [<ffffffff81009926>] ? native_sched_clock+0x26/0x70
[ 3485.689444]  [<ffffffffa00cd0d3>] ?
acpi_idle_enter_simple+0xc5/0x102 [processor]
[ 3485.689452]  [<ffffffffa00cd0ce>] ?
acpi_idle_enter_simple+0xc0/0x102 [processor]
[ 3485.689459]  [<ffffffff814228c8>] cpuidle_idle_call+0xb8/0x230
[ 3485.689466]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[ 3485.689472]  [<ffffffff814e2910>] rest_init+0x94/0xa4
[ 3485.689478]  [<ffffffff81aafba4>] start_kernel+0x3a7/0x3b4
[ 3485.689485]  [<ffffffff81aaf322>] x86_64_start_reservations+0x132/0x136
[ 3485.689491]  [<ffffffff81aaf416>] x86_64_start_kernel+0xf0/0xf7
[ 3485.689495] handlers:
[ 3485.689505] [<ffffffffa006f4f0>] e1000_intr
[ 3485.689509] Disabling IRQ 19
[ 3485.788062] Polling IRQ.
[ 3485.888240] Polling IRQ.
...
[ 3490.588069] Polling IRQ.
[ 3490.688209] Polling IRQ.
[ 3490.788079] Reenabling IRQ.
[ 3810.336883] irq 19: nobody cared (try booting with the "irqpoll" option)
[ 3810.336896] Pid: 1764, comm: sshd Not tainted 3.2.0-rc4 #5
[ 3810.336900] Call Trace:
[ 3810.336904]  <IRQ>  [<ffffffff810bbe9d>] __report_bad_irq+0x3d/0xe0
[ 3810.336921]  [<ffffffff810bc147>] note_interrupt+0x157/0x200
[ 3810.336927]  [<ffffffff810b9a54>] handle_irq_event_percpu+0xc4/0x290
[ 3810.336935]  [<ffffffff810500e5>] ? __local_bh_enable+0x35/0x90
[ 3810.336941]  [<ffffffff810b9c68>] handle_irq_event+0x48/0x70
[ 3810.336947]  [<ffffffff810bcb1a>] handle_fasteoi_irq+0x5a/0xe0
[ 3810.336954]  [<ffffffff81004012>] handle_irq+0x22/0x40
[ 3810.336960]  [<ffffffff8150712a>] do_IRQ+0x5a/0xd0
[ 3810.336966]  [<ffffffff814feceb>] common_interrupt+0x6b/0x6b
[ 3810.336969]  <EOI>  [<ffffffff810310a3>] ? __wake_up+0x53/0x70
[ 3810.336979]  [<ffffffff81154780>] ? fget_light+0xa0/0x100
[ 3810.336985]  [<ffffffff81166516>] do_select+0x336/0x6e0
[ 3810.336991]  [<ffffffff81165ee0>] ? poll_freewait+0xe0/0xe0
[ 3810.336996]  [<ffffffff81165fd0>] ? __pollwait+0xf0/0xf0
[ 3810.337001]  [<ffffffff81165fd0>] ? __pollwait+0xf0/0xf0
[ 3810.337006]  [<ffffffff81165fd0>] ? __pollwait+0xf0/0xf0
[ 3810.337011]  [<ffffffff81165fd0>] ? __pollwait+0xf0/0xf0
[ 3810.337016]  [<ffffffff81165fd0>] ? __pollwait+0xf0/0xf0
[ 3810.337020]  [<ffffffff81165fd0>] ? __pollwait+0xf0/0xf0
[ 3810.337025]  [<ffffffff81165fd0>] ? __pollwait+0xf0/0xf0
[ 3810.337030]  [<ffffffff81165fd0>] ? __pollwait+0xf0/0xf0
[ 3810.337035]  [<ffffffff81165fd0>] ? __pollwait+0xf0/0xf0
[ 3810.337040]  [<ffffffff81166a91>] core_sys_select+0x1d1/0x320
[ 3810.337047]  [<ffffffff8103ee11>] ? get_parent_ip+0x11/0x50
[ 3810.337053]  [<ffffffff81501bfd>] ? sub_preempt_count+0x9d/0xd0
[ 3810.337060]  [<ffffffff810728a1>] ? __srcu_read_unlock+0x41/0x70
[ 3810.337065]  [<ffffffff81190f82>] ? fsnotify+0x1c2/0x2a0
[ 3810.337071]  [<ffffffff81166c9b>] sys_select+0xbb/0x100
[ 3810.337078]  [<ffffffff8115338a>] ? sys_write+0x4a/0x90
[ 3810.337083]  [<ffffffff8150582b>] system_call_fastpath+0x16/0x1b
[ 3810.337087] handlers:
[ 3810.337102] [<ffffffffa006f4f0>] e1000_intr
[ 3810.337106] Disabling IRQ 19
[ 3810.436188] Polling IRQ.
[ 3810.536226] Polling IRQ.
...
