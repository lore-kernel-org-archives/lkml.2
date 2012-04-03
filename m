Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2DCNCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:02:12 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48800 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910Ab2DCNCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:02:10 -0400
MIME-Version: 1.0
Date: Tue, 3 Apr 2012 09:02:08 -0400
X-Google-Sender-Auth: bxS9GCSvIgNsiu_03eTVTiAavfY
Message-ID: <CAOvdn6WiaOxMh=b0LX6GEK4p8RiZQYamGb-qPyThfOf=E_wj6g@mail.gmail.com>
Subject: 3.2.14 pvops crash in xen_irq_init
From: Ben Guthro <ben@guthro.net>
To: Konrad Rzeszutek <konrad@darnok.org>, Greg Kroah-Hartman <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad / Greg -

Having just pulled down the new & shiny 3.2.14 kernel from Greg K-H -
I'm seeing a new crash, that I didn't see in prior kernels of this
series.

I'm hoping that either Konrad, or Greg might be able to give me some
insight into what might be happening here, so I can narrow down which
of the 150, or so patches that came in with 3.2.14 might be the
culprit.

It looks like the crash is originating in
driver/xen/events.c in xen_irq_init()
on the lines

<snip>
struct irq_desc *desc = irq_to_desc(irq);

/* By default all event channels notify CPU#0. */
cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
</snip>

desc ends up being NULL, and we dereference it in the next line.
(see stack trace below)

Was there anything in the 3.2.14 patches that would have caused a
change in behavior of irq_to_desc?

I looked at events.c in the tip, and noticed some differences in
__init xen_init_IRQ that originated with


commit 9846ff10af12f9e7caac696737db6c990592a74a
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Mon Jan 30 16:21:48 2012 +0000

    xen: support pirq_eoi_map



However, other than that, the file is largely the same. Is this a
necessary change for the stable tree?


Any thoughts would be appreciated.

Ben Guthro



[    7.060218] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000040
[    7.068307] IP: [<ffffffff8134318a>] xen_irq_init+0x1a/0xa0
[    7.074129] PGD 0
[    7.076272] Oops: 0002 [#1] SMP
[    7.079674] CPU 0
[    7.081552] Modules linked in:
[    7.085043]
[    7.086654] Pid: 1, comm: swapper/0 Not tainted 3.2.14-orc #1 Intel
Corporation 2012 Client Platform/LosLunas 2 CRB
[    7.097482] RIP: e030:[<ffffffff8134318a>]  [<ffffffff8134318a>]
xen_irq_init+0x1a/0xa0
[    7.105810] RSP: e02b:ffff880074ae3b90  EFLAGS: 00010202
[    7.111358] RAX: 0000000000000000 RBX: 00000000ffffffef RCX: 0000000000000001
[    7.118783] RDX: 0000000000000001 RSI: 00000000ffffffef RDI: 0000000000000001
[    7.126210] RBP: ffff880074ae3ba0 R08: ffff880076c00000 R09: 0000000000000000
[    7.133638] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000010
[    7.141066] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
[    7.148497] FS:  0000000000000000(0000) GS:ffff88007fe0e000(0000)
knlGS:0000000000000000
[    7.156911] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.162903] CR2: 0000000000000040 CR3: 0000000001a05000 CR4: 0000000000002660
[    7.170332] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.177760] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    7.185187] Process swapper/0 (pid: 1, threadinfo ffff880074ae2000,
task ffff880074ae8000)
[    7.193783] Stack:
[    7.195926]  00000000ffffffef 0000000000000010 ffff880074ae3c10
ffffffff813442e7
[    7.203622]  ffffffff8100142a 0000000000000000 ffffffff81827547
000000108100142a
[    7.211320]  0000000000000000 ffffffff8100142a 000000000000e030
0000000000000010
[    7.219017] Call Trace:
[    7.221619]  [<ffffffff813442e7>] xen_bind_pirq_gsi_to_irq+0x87/0x230
[    7.228328]  [<ffffffff8100142a>] ? hypercall_page+0x42a/0x1000
[    7.234502]  [<ffffffff8100142a>] ? hypercall_page+0x42a/0x1000
[    7.240677]  [<ffffffff81498e42>] xen_register_pirq+0x82/0xe0
[    7.246672]  [<ffffffff81498f1a>] xen_register_gsi.part.4+0x4a/0xd0
[    7.253205]  [<ffffffff81498fc0>] acpi_register_gsi_xen+0x20/0x30
[    7.259559]  [<ffffffff8102fe8f>] acpi_register_gsi+0xf/0x20
[    7.265466]  [<ffffffff8130eb18>] acpi_pci_irq_enable+0x12e/0x202
[    7.271820]  [<ffffffff8149adb9>] pcibios_enable_device+0x39/0x40
[    7.278175]  [<ffffffff812d891b>] do_pci_enable_device+0x4b/0x70
[    7.284438]  [<ffffffff812d89e8>] __pci_enable_device_flags+0xa8/0xf0
[    7.291150]  [<ffffffff812d8a43>] pci_enable_device+0x13/0x20
[    7.297147]  [<ffffffff812d3e88>] pci_enable_bridges+0x48/0x90
[    7.303234]  [<ffffffff81af6f8f>] pci_assign_unassigned_resources+0x1f0/0x224
[    7.310949]  [<ffffffff8138f827>] ? put_device+0x17/0x20
[    7.316502]  [<ffffffff81155abb>] ? kfree+0x3b/0x140
[    7.321688]  [<ffffffff812dbc6a>] ? pci_get_subsys+0x8a/0xc0
[    7.327595]  [<ffffffff81b087dc>] ? pcibios_allocate_bus_resources+0xa1/0xa1
[    7.334933]  [<ffffffff81b0884e>] pcibios_assign_resources+0x72/0x76
[    7.341556]  [<ffffffff81b0523a>] ? parse_pmtmr+0x56/0x56
[    7.347199]  [<ffffffff81002040>] do_one_initcall+0x40/0x180
[    7.353102]  [<ffffffff81acccd6>] kernel_init+0xca/0x149
[    7.358656]  [<ffffffff81583374>] kernel_thread_helper+0x4/0x10
[    7.364824]  [<ffffffff81581423>] ? int_ret_from_sys_call+0x7/0x1b
[    7.371269]  [<ffffffff815795fc>] ? retint_restore_args+0x5/0x6
[    7.377444]  [<ffffffff81583370>] ? gs_change+0x13/0x13
[    7.382905] Code: 41 5d 5d c3 66 66 66 66 2e 0f 1f 84 00 00 00 00
00 55 48 89 e5 41 54 53 66 66 66 66 90 89 fb e8 cd e4 d8 ff 48 8b 15
be 39 2c 00 <48> 89 50 40 48 8b 3d 9b d5 97 00 48 85 ff 74 56 ba 28 00
00 00
[    7.402414] RIP  [<ffffffff8134318a>] xen_irq_init+0x1a/0xa0
[    7.408321]  RSP <ffff880074ae3b90>
[    7.411986] CR2: 0000000000000040
[    7.415479] ---[ end trace e7360cfbb0fc0812 ]---
[    7.420325] Kernel panic - not syncing: Attempted to kill init!
[    7.426485] Pid: 1, comm: swapper/0 Tainted: G      D      3.2.14-orc #1
[    7.433468] Call Trace:
[    7.436067]  [<ffffffff8156e6ea>] panic+0x91/0x19d
[    7.441075]  [<ffffffff81068a39>] do_exit+0x759/0x880
[    7.446354]  [<ffffffff8157930e>] ? _raw_spin_unlock_irqrestore+0x1e/0x30
[    7.453428]  [<ffffffff8106610a>] ? kmsg_dump+0x4a/0xe0
[    7.458887]  [<ffffffff8157a2a0>] oops_end+0xb0/0xf0
[    7.464073]  [<ffffffff8156dfea>] no_context+0x214/0x223
[    7.469627]  [<ffffffff8100a58d>] ? xen_force_evtchn_callback+0xd/0x10
[    7.476428]  [<ffffffff8100ad42>] ? check_events+0x12/0x20
[    7.482155]  [<ffffffff8156e1c2>] __bad_area_nosemaphore+0x1c9/0x1e8
[    7.488775]  [<ffffffff8100a58d>] ? xen_force_evtchn_callback+0xd/0x10
[    7.495580]  [<ffffffff8100ad42>] ? check_events+0x12/0x20
[    7.501308]  [<ffffffff8156e1f4>] bad_area_nosemaphore+0x13/0x15
[    7.507569]  [<ffffffff8157cd96>] do_page_fault+0x426/0x520
[    7.513390]  [<ffffffff812bc2bf>] ? number.isra.2+0x31f/0x350
[    7.519382]  [<ffffffff812bb30a>] ? put_dec_full+0x2a/0xb0
[    7.525114]  [<ffffffff81363031>] ? n_tty_receive_buf+0x311/0x1240
[    7.531553]  [<ffffffff8100a58d>] ? xen_force_evtchn_callback+0xd/0x10
[    7.538358]  [<ffffffff8100ad42>] ? check_events+0x12/0x20
[    7.544085]  [<ffffffff8100a58d>] ? xen_force_evtchn_callback+0xd/0x10
[    7.550888]  [<ffffffff81579875>] page_fault+0x25/0x30
[    7.556257]  [<ffffffff8134318a>] ? xen_irq_init+0x1a/0xa0
[    7.561985]  [<ffffffff813442e7>] xen_bind_pirq_gsi_to_irq+0x87/0x230
[    7.568693]  [<ffffffff8100142a>] ? hypercall_page+0x42a/0x1000
[    7.574869]  [<ffffffff8100142a>] ? hypercall_page+0x42a/0x1000
[    7.581043]  [<ffffffff81498e42>] xen_register_pirq+0x82/0xe0
[    7.587039]  [<ffffffff81498f1a>] xen_register_gsi.part.4+0x4a/0xd0
[    7.593572]  [<ffffffff81498fc0>] acpi_register_gsi_xen+0x20/0x30
[    7.599927]  [<ffffffff8102fe8f>] acpi_register_gsi+0xf/0x20
[    7.605833]  [<ffffffff8130eb18>] acpi_pci_irq_enable+0x12e/0x202
[    7.612187]  [<ffffffff8149adb9>] pcibios_enable_device+0x39/0x40
[    7.618541]  [<ffffffff812d891b>] do_pci_enable_device+0x4b/0x70
[    7.624828]  [<ffffffff812d89e8>] __pci_enable_device_flags+0xa8/0xf0
[    7.631540]  [<ffffffff812d8a43>] pci_enable_device+0x13/0x20
[    7.637536]  [<ffffffff812d3e88>] pci_enable_bridges+0x48/0x90
[    7.643621]  [<ffffffff81af6f8f>] pci_assign_unassigned_resources+0x1f0/0x224
[    7.651050]  [<ffffffff8138f827>] ? put_device+0x17/0x20
[    7.656603]  [<ffffffff81155abb>] ? kfree+0x3b/0x140
[    7.661790]  [<ffffffff812dbc6a>] ? pci_get_subsys+0x8a/0xc0
[    7.667697]  [<ffffffff81b087dc>] ? pcibios_allocate_bus_resources+0xa1/0xa1
[    7.675035]  [<ffffffff81b0884e>] pcibios_assign_resources+0x72/0x76
[    7.681657]  [<ffffffff81b0523a>] ? parse_pmtmr+0x56/0x56
[    7.687300]  [<ffffffff81002040>] do_one_initcall+0x40/0x180
[    7.693203]  [<ffffffff81acccd6>] kernel_init+0xca/0x149
[    7.698755]  [<ffffffff81583374>] kernel_thread_helper+0x4/0x10
[    7.704925]  [<ffffffff81581423>] ? int_ret_from_sys_call+0x7/0x1b
[    7.711370]  [<ffffffff815795fc>] ? retint_restore_args+0x5/0x6
[    7.717545]  [<ffffffff81583370>] ? gs_change+0x13/0x13
