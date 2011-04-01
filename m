Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1DAApN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 20:45:13 -0400
Received: from [69.28.251.93] ([69.28.251.93]:33588 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab1DAApM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 20:45:12 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 20:45:12 EDT
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Michael Sundius <msundius@cisco.com>, David VomLehn <dvomlehn@cisco.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andy Whitcroft <apw@shadowen.org>, Jon Fraser <jfraser@broadcom.com>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>
Subject: [PATCH v2] MIPS: Kernel crashes on boot with SPARSEMEM + HIGHMEM enabled
Date: Thu, 31 Mar 2011 17:27:07 -0700
Message-Id: <c300b67a7a723369872c0b9a023d0b2e@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Sundius <msundius@cisco.com>

Fix 3 problems in the MIPS SPARSEMEM implementation:

1) mem_init() sets/clears PG_reserved on all pages in the HIGHMEM range
without checking to see whether the page descriptor actually exists.

2) bootmem_init() never calls memory_present() on HIGHMEM pages, so
page descriptors are never created for them if SPARSEMEM is enabled.

3) bootmem_init() calls memory_present() on lowmem pages before bootmem
is fully set up.  This is bad because memory_present() can allocate
bootmem in some circumstances (e.g. if SPARSEMEM_EXTREME ever got
enabled).

Signed-off-by: Michael Sundius <msundius@cisco.com>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Cc: stable@kernel.org
---
 arch/mips/kernel/setup.c |   18 +++++++++++++++++-
 arch/mips/mm/init.c      |    3 +++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 8ad1d56..1f9f902 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -390,7 +390,6 @@ static void __init bootmem_init(void)
 
 		/* Register lowmem ranges */
 		free_bootmem(PFN_PHYS(start), size << PAGE_SHIFT);
-		memory_present(0, start, end);
 	}
 
 	/*
@@ -402,6 +401,23 @@ static void __init bootmem_init(void)
 	 * Reserve initrd memory if needed.
 	 */
 	finalize_initrd();
+
+	/*
+	 * Call memory_present() on all valid ranges, for SPARSEMEM.
+	 * This must be done after setting up bootmem, since memory_present()
+	 * may allocate bootmem.
+	 */
+	for (i = 0; i < boot_mem_map.nr_map; i++) {
+		unsigned long start, end;
+
+		if (boot_mem_map.map[i].type != BOOT_MEM_RAM)
+			continue;
+
+		start = PFN_UP(boot_mem_map.map[i].addr);
+		end   = PFN_DOWN(boot_mem_map.map[i].addr
+				    + boot_mem_map.map[i].size);
+		memory_present(0, start, end);
+	}
 }
 
 #endif	/* CONFIG_SGI_IP27 */
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 279599e..78a4cf2 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -392,6 +392,9 @@ void __init mem_init(void)
 	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
 		struct page *page = pfn_to_page(tmp);
 
+		if (!pfn_valid(tmp))
+			continue;
+
 		if (!page_is_ram(tmp)) {
 			SetPageReserved(page);
 			continue;
-- 
1.7.4.2
