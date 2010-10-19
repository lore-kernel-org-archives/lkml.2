Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab0JSLSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:18:46 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49801 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978Ab0JSLSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:18:01 -0400
X-IronPort-AV: E=Sophos;i="4.57,350,1283745600"; 
   d="scan'208";a="118686969"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 08/10] xen: use host E820 map for dom0
Date: Tue, 19 Oct 2010 12:17:16 +0100
Message-Id: <1287487038-6643-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
X-OriginalArrivalTime: 19 Oct 2010 11:18:01.0484 (UTC) FILETIME=[4AB114C0:01CB6F7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

When running as initial domain, get the real physical memory map from
xen using the XENMEM_machine_memory_map hypercall and use it to setup
the e820 regions.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/setup.c           |   48 +++++++++++++++++++++++++++++++++++++--
 include/xen/interface/memory.h |   28 +++++++++++++++++++++++
 2 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 62ceb78..516cba8 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -107,14 +107,56 @@ static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
 
 char * __init xen_memory_setup(void)
 {
+	static __initdata struct e820entry map[E820MAX];
+
 	unsigned long max_pfn = xen_start_info->nr_pages;
+	struct xen_memory_map memmap;
+	unsigned long long mem_end;
+	int op;
+	int rc;
+	int i;
 
 	max_pfn = min(MAX_DOMAIN_PAGES, max_pfn);
+	mem_end = PFN_PHYS((u64)max_pfn);
+
+	memmap.nr_entries = E820MAX;
+	set_xen_guest_handle(memmap.buffer, map);
+
+	op = xen_initial_domain() ?
+		XENMEM_machine_memory_map :
+		XENMEM_memory_map;
+	rc = HYPERVISOR_memory_op(op, &memmap);
+	if (rc == -ENOSYS) {
+		memmap.nr_entries = 1;
+		map[0].addr = 0ULL;
+		map[0].size = mem_end;
+		/* 8MB slack (to balance backend allocations). */
+		map[0].size += 8ULL << 20;
+		map[0].type = E820_RAM;
+		rc = 0;
+	}
+	BUG_ON(rc);
 
 	e820.nr_map = 0;
-
-	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
-
+	for (i = 0; i < memmap.nr_entries; i++) {
+		unsigned long long end = map[i].addr + map[i].size;
+		if (map[i].type == E820_RAM) {
+			if (map[i].addr > mem_end) {
+				printk(KERN_WARNING "You need to increase the "
+						"CONFIG_XEN_MAX_DOMAIN_MEMORY value to take "
+						"advantage of the extra %llu gobs of memory!\n",
+						map[i].size);
+				continue;
+			}
+			if (end > mem_end) {
+				/* Truncate region to max_mem. */
+				map[i].size -= end - mem_end;
+			}
+		}
+		if (map[i].size > 0)
+			e820_add_region(map[i].addr, map[i].size, map[i].type);
+	}
+	
 	/*
 	 * Even though this is normal, usable memory under Xen, reserve
 	 * ISA memory anyway because too many things think they can poke
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index d3938d3..4c4b817 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -186,6 +186,34 @@ struct xen_translate_gpfn_list {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_translate_gpfn_list);
 
+/*
+ * Returns the pseudo-physical memory map as it was when the domain
+ * was started (specified by XENMEM_set_memory_map).
+ * arg == addr of struct xen_memory_map.
+ */
+#define XENMEM_memory_map           9
+struct xen_memory_map {
+    /*
+     * On call the number of entries which can be stored in buffer. On
+     * return the number of entries which have been stored in
+     * buffer.
+     */
+    unsigned int nr_entries;
+
+    /*
+     * Entries in the buffer are in the same format as returned by the
+     * BIOS INT 0x15 EAX=0xE820 call.
+     */
+    GUEST_HANDLE(void) buffer;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_memory_map);
+
+/*
+ * Returns the real physical memory map. Passes the same structure as
+ * XENMEM_memory_map.
+ * arg == addr of struct xen_memory_map.
+ */
+#define XENMEM_machine_memory_map   10
 
 /*
  * Prevent the balloon driver from changing the memory reservation
-- 
1.5.6.5

