Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3AIASx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:18:53 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1083 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3AIASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:18:52 -0500
Message-ID: <1357690721.1890.15.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] x86: srat: simplify memory affinity init error handling
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Jan 2013 16:18:41 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi_numa_memory_affinity_init() function can fail in several
scenarios, use a single point of error return.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 arch/x86/mm/srat.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 4ddf497..1100423 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -149,39 +149,40 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	int node, pxm;
 
 	if (srat_disabled())
-		return -1;
-	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
-		bad_srat();
-		return -1;
-	}
+		goto err;
+	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity))
+		goto badsrat;
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
-		return -1;
-
+		goto err;
 	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
-		return -1;
+		goto err;
+
 	start = ma->base_address;
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
 	if (acpi_srat_revision <= 1)
 		pxm &= 0xff;
+
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
-		bad_srat();
-		return -1;
+		goto badsrat;
 	}
 
-	if (numa_add_memblk(node, start, end) < 0) {
-		bad_srat();
-		return -1;
-	}
+	if (numa_add_memblk(node, start, end) < 0)
+		goto badsrat;
 
 	node_set(node, numa_nodes_parsed);
 
 	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
 	       node, pxm,
 	       (unsigned long long) start, (unsigned long long) end - 1);
+
 	return 0;
+badsrat:
+	bad_srat();
+err:
+	return -1;
 }
 
 void __init acpi_numa_arch_fixup(void) {}
-- 
1.7.11.7



