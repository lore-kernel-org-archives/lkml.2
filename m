Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab1BQSvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:51:41 -0500
Received: from relay1.sgi.com ([192.48.179.29]:39366 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab1BQSvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:51:36 -0500
Message-Id: <20110217185132.417819224@gulag1.americas.sgi.com>
References: <20110217185131.960038922@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 17 Feb 2011 12:51:34 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86: Minimize SRAT messages
Content-Disposition: inline; filename=minimize-srat-msgs.v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Condense the SRAT: messages to show all APIC id's for the
node on a single line.

v1: Added pertinent __init & __initdata specifiers.
v2: updated to apply to x86-tip

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 arch/x86/mm/srat_64.c |   16 ++++++++++++----
 drivers/acpi/numa.c   |    3 +++
 2 files changed, 15 insertions(+), 4 deletions(-)

--- linux.orig/arch/x86/mm/srat_64.c
+++ linux/arch/x86/mm/srat_64.c
@@ -116,6 +116,7 @@ acpi_numa_x2apic_affinity_init(struct ac
 {
 	int pxm, node;
 	int apic_id;
+	static int __initdata last_node = -1, last_pxm = -1;
 
 	if (srat_disabled())
 		return;
@@ -141,8 +142,16 @@ acpi_numa_x2apic_affinity_init(struct ac
 	set_apicid_to_node(apic_id, node);
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
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
@@ -301,8 +310,7 @@ acpi_numa_memory_affinity_init(struct ac
 			nd->end = end;
 	}
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
-	       start, end);
+	pr_info("SRAT: Node %u PXM %u %lx+%lx\n", node, pxm, start, end-start);
 
 	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
 		update_nodes_add(node, start, end);
--- linux.orig/drivers/acpi/numa.c
+++ linux/drivers/acpi/numa.c
@@ -286,6 +286,9 @@ int __init acpi_numa_init(void)
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
 				     acpi_parse_x2apic_affinity, 0);
+		/* insure trailing newline is output */
+		pr_cont("\n");
+
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				     acpi_parse_processor_affinity, 0);
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,

-- 
