Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab2FDCnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 22:43:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42836 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060Ab2FDCm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 22:42:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4FCC2098.4030007@jp.fujitsu.com>
Date: Mon, 04 Jun 2012 11:42:32 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, liuj97@gmail.com,
        kosaki.motohiro@gmail.com, rientjes@google.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Patch v2] x86 : set numa_nodes_parsed at acpi_numa_memory_affinity_init
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot-adding a CPU, the system outputs following messages since
node_to_cpumask_map[2] was not allocated memory.

Booting Node 2 Processor 32 APIC 0xc0
node_to_cpumask_map[2] NULL
Pid: 0, comm: swapper/32 Tainted: G       A     3.3.5-acd #21
Call Trace:
 [<ffffffff81048845>] debug_cpumask_set_cpu+0x155/0x160
 [<ffffffff8105e28a>] ? add_timer_on+0xaa/0x120
 [<ffffffff8150665f>] numa_add_cpu+0x1e/0x22
 [<ffffffff815020bb>] identify_cpu+0x1df/0x1e4
 [<ffffffff815020d6>] identify_econdary_cpu+0x16/0x1d
 [<ffffffff81504614>] smp_store_cpu_info+0x3c/0x3e
 [<ffffffff81505263>] smp_callin+0x139/0x1be
 [<ffffffff815052fb>] start_secondary+0x13/0xeb

The reason is that the bit of node 2 was not set at numa_nodes_parsed.
numa_nodes_parsed is set by only acpi_numa_processor_affinity_init /
acpi_numa_x2apic_affinity_init. Thus even if hot-added memory which is
same PXM as hot-added CPU is written in ACPI SRAT Table, if the
hot-added CPU is not written in ACPI SRAT table, numa_nodes_parsed is
not set.

But according to ACPI Spec Rev 5.0, it says about ACPI SRAT table as follows:
This optional table provides information that allows OSPM to associate
processors and memory ranges, including ranges of memory provided by
hot-added memory devices, with system localities / proximity domains
and clock domains.

It means that ACPI SRAT table only provides information for CPUs present
at boot time and for memory including hot-added memory. So hot-added memory
is written in ACPI SRAT table, but hot-added CPU is not written in it.
Thus numa_nodes_parsed should be set by not only
acpi_numa_processor_affinity_init / acpi_numa_x2apic_affinity_init
but also acpi_numa_memory_affinity_init for the case.

Additionally, if system has cpuless memory node,
acpi_numa_processor_affinity_init / acpi_numa_x2apic_affinity_init cannot
set numa_nodes_parseds since these functions cannot find cpu description
for the node. In this case, numa_nodes_parsed needs to be set by
acpi_numa_memory_affinity_init.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 arch/x86/mm/srat.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-3.4/arch/x86/mm/srat.c
===================================================================
--- linux-3.4.orig/arch/x86/mm/srat.c	2012-05-21 07:29:13.000000000 +0900
+++ linux-3.4/arch/x86/mm/srat.c	2012-05-29 05:28:27.353916902 +0900
@@ -176,6 +176,8 @@
 		return;
 	}

+	node_set(node, numa_nodes_parsed);
+
 	printk(KERN_INFO "SRAT: Node %u PXM %u %Lx-%Lx\n", node, pxm,
 	       start, end);
 }

