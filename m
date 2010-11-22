Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943Ab0KVF0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 00:26:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59344 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0KVF0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 00:26:14 -0500
Message-ID: <4CE9FED1.1050008@kernel.org>
Date: Sun, 21 Nov 2010 21:25:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
CC: Myron Stowe <myron.stowe@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] x86, acpi: Parse all SRAT cpu entries even have cpu num limitation
References: <20101104041236.GA9389@helgaas.com>	 <1288937844.3234.1.camel@edumazet-laptop> <1289500084.2698.12.camel@zim>	 <201011121152.30204.knikanth@suse.de> <1289756161.2814.29.camel@zim>	 <AANLkTikUnLc8L_0+CQOwPgr-oifws=sqnFPxWz46MTCi@mail.gmail.com> <1290123161.2447.27.camel@zim>
In-Reply-To: <1290123161.2447.27.camel@zim>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recent Intel new system have different order in MADT, aka will list all thread0
at first, then all thread1.
But SRAT table still old order, it will list cpus in one socket all together.

If the user have compiled limited NR_CPUS or boot with nr_cpus=, could have missed
to put some cpus apic id to node mapping into apicid_to_node[].

for example for 4 sockets system with 64 cpus with nr_cpus=32 will get crash...

[    9.106288] Total of 32 processors activated (136190.88 BogoMIPS).
[    9.235021] divide error: 0000 [#1] SMP 
[    9.235315] last sysfs file: 
[    9.235481] CPU 1 
[    9.235592] Modules linked in:
[    9.245398] 
[    9.245478] Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-tip-yh-01782-ge92ef79-dirty #274      /Sun Fire x4800
[    9.265415] RIP: 0010:[<ffffffff81075a8f>]  [<ffffffff81075a8f>] select_task_rq_fair+0x4f0/0x623
...
[    9.645938] RIP  [<ffffffff81075a8f>] select_task_rq_fair+0x4f0/0x623
[    9.665356]  RSP <ffff88103f8d1c40>
[    9.665568] ---[ end trace 2296156d35fdfc87 ]---

So let just parse all cpu entries in SRAT.

Also add apicid checking with MAX_LOCAL_APIC, in case We could out of boundaries of
apicid_to_node[].

it fixes following bug too.
https://bugzilla.kernel.org/show_bug.cgi?id=22662

Reported-and-Tested-by: Wu Fengguang <fengguang.wu@intel.com>
Reported-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Tested-by: Myron Stowe <myron.stowe@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/acpi/boot.c |    7 +++++++
 arch/x86/mm/srat_64.c       |    8 ++++++++
 drivers/acpi/numa.c         |   14 ++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -198,6 +198,13 @@ static void __cpuinit acpi_register_lapi
 {
 	unsigned int ver = 0;
 
+#ifdef CONFIG_X86_64
+	if (id >= (MAX_APICS-1)) {
+		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
+		return;
+	}
+#endif
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -134,6 +134,10 @@ acpi_numa_x2apic_affinity_init(struct ac
 	}
 
 	apic_id = pa->apic_id;
+	if (apic_id >= MAX_LOCAL_APIC) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid is too big\n", pxm, apic_id, node);
+		return;
+	}
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
@@ -168,6 +172,10 @@ acpi_numa_processor_affinity_init(struct
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
+	if (apic_id >= MAX_LOCAL_APIC) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		return;
+	}
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
Index: linux-2.6/drivers/acpi/numa.c
===================================================================
--- linux-2.6.orig/drivers/acpi/numa.c
+++ linux-2.6/drivers/acpi/numa.c
@@ -275,13 +275,23 @@ acpi_table_parse_srat(enum acpi_srat_typ
 int __init acpi_numa_init(void)
 {
 	int ret = 0;
+	int nr_cpu_entries = nr_cpu_ids;
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
+	 * SRAT cpu entries could have different order with that in MADT.
+	 * So go over all cpu entries in SRAT to get apicid to node mapping.
+	 */
+	nr_cpu_entries = MAX_LOCAL_APIC;
+#endif
 
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				     acpi_parse_x2apic_affinity, nr_cpu_ids);
+				     acpi_parse_x2apic_affinity, nr_cpu_entries);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				     acpi_parse_processor_affinity, nr_cpu_ids);
+				     acpi_parse_processor_affinity, nr_cpu_entries);
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
