Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab1H3G2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:28:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:54850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab1H3G2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:28:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43511010"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [RFC 2/2] ACPI, Add RAM mapping support to ACPI atomic IO support
Date: Tue, 30 Aug 2011 14:28:29 +0800
Message-Id: <1314685709-7280-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314685709-7280-1-git-send-email-ying.huang@intel.com>
References: <1314685709-7280-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, ACPI atomic IO support is used to access IO memory.  But in
EINJ, it may be used to access RAM to trigger the injected error.
This patch add RAM mapping support to satisfy EINJ requirement.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/atomicio.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
index 7489b89..edf2f11 100644
--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -32,6 +32,8 @@
 #include <linux/rculist.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
 #include <acpi/atomicio.h>
 
 #define ACPI_PFX "ACPI: "
@@ -97,6 +99,30 @@ static void __iomem *__acpi_try_ioremap(phys_addr_t paddr,
 		return NULL;
 }
 
+static void __iomem *acpi_map(phys_addr_t pg_off, unsigned long pg_sz)
+{
+	unsigned long pfn;
+
+	pfn = pg_off >> PAGE_SHIFT;
+	if (page_is_ram(pfn)) {
+		if (pg_sz > PAGE_SIZE)
+			return NULL;
+		return (void __iomem __force *)kmap(pfn_to_page(pfn));
+	} else
+		return ioremap(pg_off, pg_sz);
+}
+
+static void acpi_unmap(phys_addr_t pg_off, void __iomem *vaddr)
+{
+	unsigned long pfn;
+
+	pfn = pg_off >> PAGE_SHIFT;
+	if (page_is_ram(pfn))
+		kunmap(pfn_to_page(pfn));
+	else
+		iounmap(vaddr);
+}
+
 /*
  * Used to pre-map the specified IO memory area. First try to find
  * whether the area is already pre-mapped, if it is, increase the
@@ -119,7 +145,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
 
 	pg_off = paddr & PAGE_MASK;
 	pg_sz = ((paddr + size + PAGE_SIZE - 1) & PAGE_MASK) - pg_off;
-	vaddr = ioremap(pg_off, pg_sz);
+	vaddr = acpi_map(pg_off, pg_sz);
 	if (!vaddr)
 		return NULL;
 	map = kmalloc(sizeof(*map), GFP_KERNEL);
@@ -135,7 +161,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
 	vaddr = __acpi_try_ioremap(paddr, size);
 	if (vaddr) {
 		spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
-		iounmap(map->vaddr);
+		acpi_unmap(pg_off, map->vaddr);
 		kfree(map);
 		return vaddr;
 	}
@@ -144,7 +170,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
 
 	return map->vaddr + (paddr - map->paddr);
 err_unmap:
-	iounmap(vaddr);
+	acpi_unmap(pg_off, vaddr);
 	return NULL;
 }
 
@@ -177,7 +203,7 @@ static void acpi_post_unmap(phys_addr_t paddr, unsigned long size)
 		return;
 
 	synchronize_rcu();
-	iounmap(map->vaddr);
+	acpi_unmap(map->paddr, map->vaddr);
 	kfree(map);
 }
 
-- 
1.7.5.4

