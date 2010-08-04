Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab0HDJQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:16:15 -0400
Received: from mx3.sophos.com ([74.202.89.160]:35558 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761Ab0HDJQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:16:12 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: 2.6.35 hangs on early boot in KVM
Date: Wed, 4 Aug 2010 10:16:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <201008031028.57263.tvrtko.ursulin@sophos.com> <201008040918.58318.tvrtko.ursulin@sophos.com> <4C592D60.5050309@kernel.org>
In-Reply-To: <4C592D60.5050309@kernel.org>
MIME-Version: 1.0
Message-ID: <201008041016.09176.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2010 10:16:09,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2010 10:16:10,
	Serialize complete at 04/08/2010 10:16:10
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 Aug 2010 10:05:36 Yinghai Lu wrote:
> On 08/04/2010 01:18 AM, Tvrtko Ursulin wrote:
> > On Tuesday 03 Aug 2010 21:57:48 Yinghai Lu wrote:
> >> On Tue, Aug 3, 2010 at 8:59 AM, Tvrtko Ursulin
> >>
> >> <tvrtko.ursulin@sophos.com> wrote:
> >>> On Tuesday 03 Aug 2010 16:17:20 Tvrtko Ursulin wrote:
> >>>> On Tuesday 03 Aug 2010 15:57:03 Tvrtko Ursulin wrote:
> >>>>> On Tuesday 03 Aug 2010 15:51:08 Avi Kivity wrote:
> >>>>>>   On 08/03/2010 12:28 PM, Tvrtko Ursulin wrote:
> >>>>>>> I have basically built 2.6.35 with make oldconfig from a working
> >>>>>>> 2.6.34. Latter works fine in kvm while 2.6.35 hangs very early. I
> >>>>>>> see nothing after grub (have early printk and verbose bootup
> >>>>>>> enabled), just a blinking VGA cursor and CPU at 100%.
> >>>>>>
> >>>>>> Please copy kvm@vger.kernel.org on kvm issues.
> >>>>>>
> >>>>>>> CONFIG_PRINTK_TIME=y
> >>>>>>
> >>>>>> Try disabling this as a workaround.
> >>>>>
> >>>>> I am in the middle of a bisect run with five builds left to go,
> >>>>> currently I have:
> >>>>>
> >>>>> bad 537b60d17894b7c19a6060feae40299d7109d6e7
> >>>>> good 93c9d7f60c0cb7715890b1f9e159da6f4d1f5a65
> >>>>
> >>>> Bisect is looking good, narrowed it to ten revisions, but I am not
> >>>> sure to make it to the end today:
> >>>>
> >>>> bad cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea
> >>>> good 41d59102e146a4423a490b8eca68a5860af4fe1c
> >>>
> >>> Bisect points the finger to "x86, ioapic: In mpparse use
> >>> mp_register_ioapic" (cf7500c0ea133d66f8449d86392d83f840102632), so I am
> >>> copying Eric. No idea whether this commit is solely to blame or it is a
> >>> combined interaction with KVM, but I am sure you guys will know.
> >>>
> >>> If you want me to test something else please shout.
> >>
> >> please try attached patch, to see if it help.
> >
> > No luck (no visible difference, no output on VGA or serial console). (Btw
> > there is a typo in pin_2_irq_leagcy so that you do not push it directly).
>
> can you try current tip with
> earlyprintk=ttyS0,115200 or console=uart8250,io,0x3f8,115200?

Not the tip but 2.6.35 with earlyprintk=ttyS0,115200:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35 (root@kvm-ktest-32) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #4
SMP Wed Aug 4 09:15:10 BST 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000002bbfd000 (usable)
[    0.000000]  BIOS-e820: 000000002bbfd000 - 000000002bc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x2bbfd max_arch_pfn = 0x100000
[    0.000000] PAT not supported by CPU.
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (reserved)
[    0.000000]  modified: 0000000000001000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f400 (usable)
[    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000002bbfd000 (usable)
[    0.000000]  modified: 000000002bbfd000 - 000000002bc00000 (reserved)
[    0.000000]  modified: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] found SMP MP-table at [c00f85c0] f85c0
[    0.000000] init_memory_mapping: 0000000000000000-000000002bbfd000
[    0.000000] RAMDISK: 1fa29000 - 20d3e000
[    0.000000] 699MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 2bbfd000
[    0.000000]   low ram: 0 - 2bbfd000
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:82a341, boot clock
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0002bbfd
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000002
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0002bbfd
[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] I/O APIC #1 Version 17 at 0xFEC00000.
[    0.000000] BUG: unable to handle kernel paging request at ffffb030
[    0.000000] IP: [<c011d136>] native_apic_mem_read+0x16/0x20
[    0.000000] *pde = 00832067 *pte = 00000000
[    0.000000] Oops: 0000 [#1] SMP
[    0.000000] last sysfs file:
[    0.000000] Modules linked in:
[    0.000000]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.35 #4 /Bochs
[    0.000000] EIP: 0060:[<c011d136>] EFLAGS: 00010093 CPU: 0
[    0.000000] EIP is at native_apic_mem_read+0x16/0x20
[    0.000000] EAX: ffffb030 EBX: 00000001 ECX: c061f220 EDX: fffff000
[    0.000000] ESI: 00000001 EDI: 00000000 EBP: c060bde8 ESP: c060bde4
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    0.000000] Process swapper (pid: 0, ti=c060b000 task=c061f220 task.ti=c060b000)
[    0.000000] Stack:
[    0.000000]  c011c352 c060be34 c0686380 c0598971 00000000 00000000 c060be1a 00000000
[    0.000000] <0> 00005000 00000046 c0124548 c01247e8 c060be28 c012a95c 00000005 00000000
[    0.000000] <0> 00000001 00000000 00000000 00000001 c060be3c c0686502 c060be6c c06865ce
[    0.000000] Call Trace:
[    0.000000]  [<c011c352>] ? get_physical_broadcast+0x22/0x50
[    0.000000]  [<c0686380>] ? io_apic_get_unique_id+0x78/0x1d1
[    0.000000]  [<c0124548>] ? native_set_pte_at+0x8/0x10
[    0.000000]  [<c01247e8>] ? native_flush_tlb_single+0x8/0x10
[    0.000000]  [<c012a95c>] ? set_pte_vaddr+0x6c/0x80
[    0.000000]  [<c0686502>] ? io_apic_unique_id+0x29/0x2b
[    0.000000]  [<c06865ce>] ? mp_register_ioapic+0xca/0x11a
[    0.000000]  [<c0683bfb>] ? MP_ioapic_info+0x44/0x4a
[    0.000000]  [<c0684158>] ? default_get_smp_config+0x334/0x490
[    0.000000]  [<c068ff6c>] ? free_area_init_nodes+0x30c/0x314
[    0.000000]  [<c03e5599>] ? read_pci_config_16+0x9/0x40
[    0.000000]  [<c067cab7>] ? setup_arch+0xa04/0xa5e
[    0.000000]  [<c0144e15>] ? vprintk+0x375/0x480
[    0.000000]  [<c01758db>] ? trace_hardirqs_off+0xb/0x10
[    0.000000]  [<c048fe0d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
[    0.000000]  [<c0679714>] ? start_kernel+0xdc/0x378
[    0.000000]  [<c06790d7>] ? i386_start_kernel+0xd7/0xdf
[    0.000000] Code: 4c 62 c0 8d 84 08 00 c0 ff ff 89 10 5d c3 8d b4 26 00 00 00 00 55 89 e5 e8 64 65 fe
ff 8b 15 cc 4c 62 c0 5d 8d 84 10 00 c0 ff ff <8b> 00 c3 8d b4 26 00 00 00 00 55 89 e5 53 e8 43 65 fe ff
8b 15
[    0.000000] EIP: [<c011d136>] native_apic_mem_read+0x16/0x20 SS:ESP 0068:c060bde4
[    0.000000] CR2: 00000000ffffb030
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] Pid: 0, comm: swapper Tainted: G      D     2.6.35 #4
[    0.000000] Call Trace:
[    0.000000]  [<c048c225>] ? printk+0x1d/0x20
[    0.000000]  [<c048c18b>] panic+0x5a/0xd7
[    0.000000]  [<c0148b19>] do_exit+0x7a9/0x840
[    0.000000]  [<c0145059>] ? kmsg_dump+0x139/0x160
[    0.000000]  [<c048c225>] ? printk+0x1d/0x20
[    0.000000]  [<c0106b15>] oops_end+0x95/0xd0
[    0.000000]  [<c0125dc6>] no_context+0xc6/0x160
[    0.000000]  [<c0125f10>] __bad_area_nosemaphore+0xb0/0x160
[    0.000000]  [<c01245e8>] ? _paravirt_ident_32+0x8/0x10
[    0.000000]  [<c0125fd7>] bad_area_nosemaphore+0x17/0x20
[    0.000000]  [<c0126269>] do_page_fault+0xb9/0x410
[    0.000000]  [<c01261b0>] ? do_page_fault+0x0/0x410
[    0.000000]  [<c0490864>] error_code+0x78/0x80
[    0.000000]  [<c017007b>] ? timer_list_show+0x7cb/0xf00
[    0.000000]  [<c011d136>] ? native_apic_mem_read+0x16/0x20
[    0.000000]  [<c011c352>] ? get_physical_broadcast+0x22/0x50
[    0.000000]  [<c0686380>] io_apic_get_unique_id+0x78/0x1d1
[    0.000000]  [<c0124548>] ? native_set_pte_at+0x8/0x10
[    0.000000]  [<c01247e8>] ? native_flush_tlb_single+0x8/0x10
[    0.000000]  [<c012a95c>] ? set_pte_vaddr+0x6c/0x80
[    0.000000]  [<c0686502>] io_apic_unique_id+0x29/0x2b
[    0.000000]  [<c06865ce>] mp_register_ioapic+0xca/0x11a
[    0.000000]  [<c0683bfb>] MP_ioapic_info+0x44/0x4a
[    0.000000]  [<c0684158>] default_get_smp_config+0x334/0x490
[    0.000000]  [<c068ff6c>] ? free_area_init_nodes+0x30c/0x314
[    0.000000]  [<c03e5599>] ? read_pci_config_16+0x9/0x40
[    0.000000]  [<c067cab7>] setup_arch+0xa04/0xa5e
[    0.000000]  [<c0144e15>] ? vprintk+0x375/0x480
[    0.000000]  [<c01758db>] ? trace_hardirqs_off+0xb/0x10
[    0.000000]  [<c048fe0d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
[    0.000000]  [<c0679714>] start_kernel+0xdc/0x378
[    0.000000]  [<c06790d7>] i386_start_kernel+0xd7/0xdf
[    0.000000] Unknown interrupt or fault at: 00000246 00000060 c012422a
[    0.000000] Pid: 0, comm: swapper Tainted: G      D     2.6.35 #4
[    0.000000] Call Trace:
[    0.000000]  [<c048c225>] ? printk+0x1d/0x20
[    0.000000]  [<c04844c1>] ignore_int+0x3d/0x46
[    0.000000]  [<c012422a>] ? native_irq_enable+0xa/0x10
[    0.000000]  [<c048c1f6>] ? panic+0xc5/0xd7
[    0.000000]  [<c048c1f6>] ? panic+0xc5/0xd7
[    0.000000]  [<c012422a>] ? native_irq_enable+0xa/0x10
[    0.000000]  [<c048c1fc>] ? panic+0xcb/0xd7
[    0.000000]  [<c0148b19>] do_exit+0x7a9/0x840
[    0.000000]  [<c0145059>] ? kmsg_dump+0x139/0x160
[    0.000000]  [<c048c225>] ? printk+0x1d/0x20
[    0.000000]  [<c0106b15>] oops_end+0x95/0xd0
[    0.000000]  [<c0125dc6>] no_context+0xc6/0x160
[    0.000000]  [<c0125f10>] __bad_area_nosemaphore+0xb0/0x160
[    0.000000]  [<c01245e8>] ? _paravirt_ident_32+0x8/0x10
[    0.000000]  [<c0125fd7>] bad_area_nosemaphore+0x17/0x20
[    0.000000]  [<c0126269>] do_page_fault+0xb9/0x410
[    0.000000]  [<c01261b0>] ? do_page_fault+0x0/0x410
[    0.000000]  [<c0490864>] error_code+0x78/0x80
[    0.000000]  [<c017007b>] ? timer_list_show+0x7cb/0xf00
[    0.000000]  [<c011d136>] ? native_apic_mem_read+0x16/0x20
[    0.000000]  [<c011c352>] ? get_physical_broadcast+0x22/0x50
[    0.000000]  [<c0686380>] io_apic_get_unique_id+0x78/0x1d1
[    0.000000]  [<c0124548>] ? native_set_pte_at+0x8/0x10
[    0.000000]  [<c01247e8>] ? native_flush_tlb_single+0x8/0x10
[    0.000000]  [<c012a95c>] ? set_pte_vaddr+0x6c/0x80
[    0.000000]  [<c0686502>] io_apic_unique_id+0x29/0x2b
[    0.000000]  [<c06865ce>] mp_register_ioapic+0xca/0x11a
[    0.000000]  [<c0683bfb>] MP_ioapic_info+0x44/0x4a
[    0.000000]  [<c0684158>] default_get_smp_config+0x334/0x490
[    0.000000]  [<c068ff6c>] ? free_area_init_nodes+0x30c/0x314
[    0.000000]  [<c03e5599>] ? read_pci_config_16+0x9/0x40
[    0.000000]  [<c067cab7>] setup_arch+0xa04/0xa5e
[    0.000000]  [<c0144e15>] ? vprintk+0x375/0x480
[    0.000000]  [<c01758db>] ? trace_hardirqs_off+0xb/0x10
[    0.000000]  [<c048fe0d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
[    0.000000]  [<c0679714>] start_kernel+0xdc/0x378
[    0.000000]  [<c06790d7>] i386_start_kernel+0xd7/0xdf


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
