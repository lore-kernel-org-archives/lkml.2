Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab2EIWsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:48:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46669 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2EIWsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:48:41 -0400
MIME-Version: 1.0
In-Reply-To: <tip-re15l0jqjtpz709oxozt2zoh@git.kernel.org>
References: <tip-re15l0jqjtpz709oxozt2zoh@git.kernel.org>
Date: Wed, 9 May 2012 15:48:40 -0700
X-Google-Sender-Auth: TbxPLU3jswLZLFoQLDRwwjUQjMI
Message-ID: <CAE9FiQVu7KP=rabe5_jYZyEGpW7sv6wkK9wumJfW1vk2=+cYKA@mail.gmail.com>
Subject: Re: [tip:sched/core] x86/numa: Check for nonsensical topologies on
 real hw as well
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, tj@kernel.org,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 5:59 AM, tip-bot for Ingo Molnar
<mingo@kernel.org> wrote:
> Commit-ID:  ad7687dde8780a0d618a3e3b5a62bb383696fc22
> Gitweb:     http://git.kernel.org/tip/ad7687dde8780a0d618a3e3b5a62bb383696fc22
> Author:     Ingo Molnar <mingo@kernel.org>
> AuthorDate: Wed, 9 May 2012 13:31:47 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 9 May 2012 13:32:35 +0200
>
> x86/numa: Check for nonsensical topologies on real hw as well
>
> Instead of only checking nonsensical topologies on numa-emu, do it
> on real hardware as well, and print a warning.
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: x86@kernel.org
> Link: http://lkml.kernel.org/n/tip-re15l0jqjtpz709oxozt2zoh@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/smpboot.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index edfd03a..7c53d96 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -337,10 +337,10 @@ void __cpuinit set_cpu_sibling_map(int cpu)
>                for_each_cpu(i, cpu_sibling_setup_mask) {
>                        struct cpuinfo_x86 *o = &cpu_data(i);
>
> -#ifdef CONFIG_NUMA_EMU
> -                       if (cpu_to_node(cpu) != cpu_to_node(i))
> +                       if (cpu_to_node(cpu) != cpu_to_node(i)) {
> +                               WARN_ONCE(1, "sched: CPU #%d's thread-sibling CPU #%d not on the same node! [node %d != %d]. Ignoring sibling dependency.\n", cpu, i, cpu_to_node(cpu), cpu_to_node(i));
>                                continue;
> -#endif
> +                       }
>
>                        if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
>                                if (c->phys_proc_id == o->phys_proc_id &&
> @@ -365,10 +365,10 @@ void __cpuinit set_cpu_sibling_map(int cpu)
>        }
>
>        for_each_cpu(i, cpu_sibling_setup_mask) {
> -#ifdef CONFIG_NUMA_EMU
> -               if (cpu_to_node(cpu) != cpu_to_node(i))
> +               if (cpu_to_node(cpu) != cpu_to_node(i)) {
> +                       WARN_ONCE(1, "sched: CPU #%d's core-sibling CPU #%d not on the same node! [node %d != %d]. Ignoring sibling dependency.\n", cpu, i, cpu_to_node(cpu), cpu_to_node(i));
>                        continue;
> -#endif
> +               }
>
>                if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
>                    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {

get wrong warning on system without using numa emu.

------------[ cut here ]------------
WARNING: at arch/x86/kernel/smpboot.c:320 set_cpu_sibling_map+0x9c/0x382()
Hardware name: Sun Blade X6270 M3
sched: CPU #8's thread-sibling CPU #0 not on the same node! [node 1 !=
0]. Ignoring sibling dependency.
Modules linked in:

Pid: 0, comm: swapper/8 Not tainted 3.4.0-rc6-yh-03506-gac97716-dirty #308
Call Trace:
 [<ffffffff8106a7d1>] warn_slowpath_common+0x83/0x9b
 [<ffffffff8106a88c>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff81d78b78>] set_cpu_sibling_map+0x9c/0x382
 [<ffffffff81d77aca>] ? mcheck_cpu_init+0xcf/0x11c
 [<ffffffff81d760ce>] ? identify_cpu+0x24c/0x251
 [<ffffffff81d78f5c>] smp_callin+0xfe/0x114
 [<ffffffff81d78f8a>] start_secondary+0x18/0xc4
 [<ffffffff81d78f72>] ? smp_callin+0x114/0x114
---[ end trace b0a3493fd2ab781d ]---
------------[ cut here ]------------
WARNING: at arch/x86/kernel/smpboot.c:348 set_cpu_sibling_map+0x20f/0x382()
Hardware name: Sun Blade X6270 M3
sched: CPU #8's core-sibling CPU #0 not on the same node! [node 1 !=
0]. Ignoring sibling dependency.
Modules linked in:

Pid: 0, comm: swapper/8 Tainted: G        W
3.4.0-rc6-yh-03506-gac97716-dirty #308
Call Trace:
 [<ffffffff8106a7d1>] warn_slowpath_common+0x83/0x9b
 [<ffffffff8106a88c>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff81d78ceb>] set_cpu_sibling_map+0x20f/0x382
 [<ffffffff81d77aca>] ? mcheck_cpu_init+0xcf/0x11c
 [<ffffffff81d760ce>] ? identify_cpu+0x24c/0x251
 [<ffffffff81d78f5c>] smp_callin+0xfe/0x114
 [<ffffffff81d78f8a>] start_secondary+0x18/0xc4
 [<ffffffff81d78f72>] ? smp_callin+0x114/0x114
---[ end trace b0a3493fd2ab781e ]---

SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 0 -> APIC 0x02 -> Node 0
SRAT: PXM 0 -> APIC 0x04 -> Node 0
SRAT: PXM 0 -> APIC 0x06 -> Node 0
SRAT: PXM 0 -> APIC 0x08 -> Node 0
SRAT: PXM 0 -> APIC 0x0a -> Node 0
SRAT: PXM 0 -> APIC 0x0c -> Node 0
SRAT: PXM 0 -> APIC 0x0e -> Node 0
SRAT: PXM 1 -> APIC 0x20 -> Node 1
SRAT: PXM 1 -> APIC 0x22 -> Node 1
SRAT: PXM 1 -> APIC 0x24 -> Node 1
SRAT: PXM 1 -> APIC 0x26 -> Node 1
SRAT: PXM 1 -> APIC 0x28 -> Node 1
SRAT: PXM 1 -> APIC 0x2a -> Node 1
SRAT: PXM 1 -> APIC 0x2c -> Node 1
SRAT: PXM 1 -> APIC 0x2e -> Node 1
SRAT: PXM 0 -> APIC 0x01 -> Node 0
SRAT: PXM 0 -> APIC 0x03 -> Node 0
SRAT: PXM 0 -> APIC 0x05 -> Node 0
SRAT: PXM 0 -> APIC 0x07 -> Node 0
SRAT: PXM 0 -> APIC 0x09 -> Node 0
SRAT: PXM 0 -> APIC 0x0b -> Node 0
SRAT: PXM 0 -> APIC 0x0d -> Node 0
SRAT: PXM 0 -> APIC 0x0f -> Node 0
SRAT: PXM 1 -> APIC 0x21 -> Node 1
SRAT: PXM 1 -> APIC 0x23 -> Node 1
SRAT: PXM 1 -> APIC 0x25 -> Node 1
SRAT: PXM 1 -> APIC 0x27 -> Node 1
SRAT: PXM 1 -> APIC 0x29 -> Node 1
SRAT: PXM 1 -> APIC 0x2b -> Node 1
SRAT: PXM 1 -> APIC 0x2d -> Node 1
SRAT: PXM 1 -> APIC 0x2f -> Node 1


ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x28] enabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x2a] enabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x2c] enabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x2e] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] enabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x29] enabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x2b] enabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x2d] enabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x2f] enabled)


init_cpu_to_node:
cpu 0 -> apicid 0x0 -> node 0
cpu 1 -> apicid 0x2 -> node 0
cpu 2 -> apicid 0x4 -> node 0
cpu 3 -> apicid 0x6 -> node 0
cpu 4 -> apicid 0x8 -> node 0
cpu 5 -> apicid 0xa -> node 0
cpu 6 -> apicid 0xc -> node 0
cpu 7 -> apicid 0xe -> node 0
cpu 8 -> apicid 0x20 -> node 1
cpu 9 -> apicid 0x22 -> node 1
cpu 10 -> apicid 0x24 -> node 1
cpu 11 -> apicid 0x26 -> node 1
cpu 12 -> apicid 0x28 -> node 1
cpu 13 -> apicid 0x2a -> node 1
cpu 14 -> apicid 0x2c -> node 1
cpu 15 -> apicid 0x2e -> node 1
cpu 16 -> apicid 0x1 -> node 0
cpu 17 -> apicid 0x3 -> node 0
cpu 18 -> apicid 0x5 -> node 0
cpu 19 -> apicid 0x7 -> node 0
cpu 20 -> apicid 0x9 -> node 0
cpu 21 -> apicid 0xb -> node 0
cpu 22 -> apicid 0xd -> node 0
cpu 23 -> apicid 0xf -> node 0
cpu 24 -> apicid 0x21 -> node 1
cpu 25 -> apicid 0x23 -> node 1
cpu 26 -> apicid 0x25 -> node 1
cpu 27 -> apicid 0x27 -> node 1
cpu 28 -> apicid 0x29 -> node 1
cpu 29 -> apicid 0x2b -> node 1
cpu 30 -> apicid 0x2d -> node 1
cpu 31 -> apicid 0x2f -> node 1
