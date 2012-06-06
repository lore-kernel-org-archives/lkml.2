Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2FFPSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:18:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2FFPSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:18:11 -0400
Date: Wed, 6 Jun 2012 08:17:55 -0700
From: tip-bot for Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Message-ID: <tip-4af463d28f1a026e25c0b879fac2a0d2b7bff599@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, tglx@linutronix.de,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <4FCC2098.4030007@jp.fujitsu.com>
References: <4FCC2098.4030007@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/numa:
  Set numa_nodes_parsed at acpi_numa_memory_affinity_init()
Git-Commit-ID: 4af463d28f1a026e25c0b879fac2a0d2b7bff599
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:18:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4af463d28f1a026e25c0b879fac2a0d2b7bff599
Gitweb:     http://git.kernel.org/tip/4af463d28f1a026e25c0b879fac2a0d2b7bff599
Author:     Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
AuthorDate: Mon, 4 Jun 2012 11:42:32 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:58:39 +0200

x86/numa: Set numa_nodes_parsed at acpi_numa_memory_affinity_init()

When hot-adding a CPU, the system outputs following messages
since node_to_cpumask_map[2] was not allocated memory.

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

The reason is that the bit of node 2 was not set at
numa_nodes_parsed. numa_nodes_parsed is set by only
acpi_numa_processor_affinity_init /
acpi_numa_x2apic_affinity_init. Thus even if hot-added memory
which is same PXM as hot-added CPU is written in ACPI SRAT
Table, if the hot-added CPU is not written in ACPI SRAT table,
numa_nodes_parsed is not set.

But according to ACPI Spec Rev 5.0, it says about ACPI SRAT
table as follows: This optional table provides information that
allows OSPM to associate processors and memory ranges, including
ranges of memory provided by hot-added memory devices, with
system localities / proximity domains and clock domains.

It means that ACPI SRAT table only provides information for CPUs
present at boot time and for memory including hot-added memory.
So hot-added memory is written in ACPI SRAT table, but hot-added
CPU is not written in it. Thus numa_nodes_parsed should be set
by not only acpi_numa_processor_affinity_init /
acpi_numa_x2apic_affinity_init but also
acpi_numa_memory_affinity_init for the case.

Additionally, if system has cpuless memory node,
acpi_numa_processor_affinity_init /
acpi_numa_x2apic_affinity_init cannot set numa_nodes_parseds
since these functions cannot find cpu description for the node.
In this case, numa_nodes_parsed needs to be set by
acpi_numa_memory_affinity_init.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: liuj97@gmail.com
Cc: kosaki.motohiro@gmail.com
Link: http://lkml.kernel.org/r/4FCC2098.4030007@jp.fujitsu.com
[ merged it ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/srat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 732af3a..4599c3e 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -176,6 +176,8 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		return;
 	}
 
+	node_set(node, numa_nodes_parsed);
+
 	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
 	       node, pxm,
 	       (unsigned long long) start, (unsigned long long) end - 1);
