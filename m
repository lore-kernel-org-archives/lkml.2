Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1ASXBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:01:15 -0500
Received: from relay3.sgi.com ([192.48.152.1]:40743 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755090Ab1ASXBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:01:12 -0500
Message-Id: <20110119230107.134657025@gulag1.americas.sgi.com>
References: <20110119230106.341785959@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 19 Jan 2011 17:01:11 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH 5/6] x86: Minimize SRAT messages
Content-Disposition: inline; filename=minimize-srat-msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Condense the SRAT: messages to show all APIC id's for the
node on a single line.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 arch/x86/mm/srat_64.c |   16 ++++++++++++----
 drivers/acpi/numa.c   |    3 +++
 2 files changed, 15 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/arch/x86/mm/srat_64.c
+++ linux-2.6.32/arch/x86/mm/srat_64.c
@@ -115,6 +115,7 @@ acpi_numa_x2apic_affinity_init(struct ac
 {
 	int pxm, node;
 	int apic_id;
+	static int last_node = -1, last_pxm = -1;
 
 	if (srat_disabled())
 		return;
@@ -136,8 +137,16 @@ acpi_numa_x2apic_affinity_init(struct ac
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
-	       pxm, apic_id, node);
+	if (node != last_node) {
+		pr_info("SRAT: Node %u: PXM:APIC %u:%u",
+		       node, pxm, apic_id);
+		last_node = node;
+		last_pxm = pxm;
+	} else if (pxm != last_pxm) {
+		pr_cont(" %u:%u", pxm, apic_id);
+		last_pxm = pxm;
+	} else
+		pr_cont(" :%u", apic_id);
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
@@ -294,8 +303,7 @@ acpi_numa_memory_affinity_init(struct ac
 			nd->end = end;
 	}
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
-	       start, end);
+	pr_info("SRAT: Node %u PXM %u %lx+%lx\n", node, pxm, start, end-start);
 	e820_register_active_regions(node, start >> PAGE_SHIFT,
 				     end >> PAGE_SHIFT);
 
--- linux-2.6.32.orig/drivers/acpi/numa.c
+++ linux-2.6.32/drivers/acpi/numa.c
@@ -290,6 +290,9 @@ int __init acpi_numa_init(void)
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
 				      acpi_parse_x2apic_affinity, NR_CPUS);
+		/* insure trailing newline is output */
+		pr_cont("\n");
+
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				      acpi_parse_processor_affinity, NR_CPUS);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,

-- 
