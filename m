Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0LQDME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:12:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28532 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0LQDMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:12:02 -0500
Message-ID: <4D0AD486.9020704@kernel.org>
Date: Thu, 16 Dec 2010 19:09:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: [PATCH -v2 2/2] x86, acpi: Parse all SRAT cpu entries even have cpu
 num limitation
References: <20101111100628.GA24728@localhost> <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost> <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost> <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost> <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost> <4CDEE314.6090107@kernel.org> <20101113235746.GA9458@localhost> <4CDF3DA1.2090806@kernel.org> <4D093ABB.4030206@zytor.com> <4D0943D5.1090404@kernel.org> <4D094703.7080701@zytor.com> <4D0AD464.2020408@kernel.org>
In-Reply-To: <4D0AD464.2020408@kernel.org>
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

-v2: expand to 32bit according to hpa
   need to add MAX_LOCAL_APIC for 32bit

Reported-and-Tested-by: Wu Fengguang <fengguang.wu@intel.com>
Reported-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Tested-by: Myron Stowe <myron.stowe@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/acpi/boot.c |    5 +++++
 arch/x86/mm/srat_32.c       |    1 +
 arch/x86/mm/srat_64.c       |   10 ++++++++++
 drivers/acpi/numa.c         |   14 ++++++++++++--
 4 files changed, 28 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -198,6 +198,11 @@ static void __cpuinit acpi_register_lapi
 {
 	unsigned int ver = 0;
 
+	if (id >= (MAX_LOCAL_APIC-1)) {
+		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
+		return;
+	}
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
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		return;
+	}
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
@@ -168,6 +172,12 @@ acpi_numa_processor_affinity_init(struct
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
+
+	if (apic_id >= MAX_LOCAL_APIC) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		return;
+	}
+
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
+#ifdef CONFIG_X86
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
Index: linux-2.6/arch/x86/mm/srat_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_32.c
+++ linux-2.6/arch/x86/mm/srat_32.c
@@ -92,6 +92,7 @@ acpi_numa_processor_affinity_init(struct
 	/* mark this node as "seen" in node bitmap */
 	BMAP_SET(pxm_bitmap, cpu_affinity->proximity_domain_lo);
 
+	/* don't need to check apic_id here, because it is always 8 bits */
 	apicid_to_pxm[cpu_affinity->apic_id] = cpu_affinity->proximity_domain_lo;
 
 	printk(KERN_DEBUG "CPU %02x in proximity domain %02x\n",
