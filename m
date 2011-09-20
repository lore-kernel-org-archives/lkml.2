Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab1ITBjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 21:39:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:52041 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab1ITBjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 21:39:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="50392874"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 6/8] ACPI, Add RAM mapping support to ACPI atomic IO support
Date: Tue, 20 Sep 2011 09:38:59 +0800
Message-Id: <1316482741-21799-7-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316482741-21799-1-git-send-email-ying.huang@intel.com>
References: <1316482741-21799-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one of our testing machine, the following EINJ command lines:

  # echo 0x10000000 > param1
  # echo 0xfffffffffffff000 > param2
  # echo 0x8 > error_type
  # echo 1 > error_inject

Will get:

  echo: write error: Input/output error

The EIO comes from:

    rc = apei_exec_pre_map_gars(&trigger_ctx);

The root cause is as follow.  Normally, ACPI atomic IO support is used
to access IO memory.  But in EINJ of that machine, it is used to
access RAM to trigger the injected error.  And the ioremap() called by
apei_exec_pre_map_gars() can not map the RAM.

This patch add RAM mapping support to ACPI atomic IO support to
satisfy EINJ requirement.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/atomicio.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

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
@@ -97,6 +99,30 @@ static void __iomem *__acpi_try_ioremap(
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
@@ -119,7 +145,7 @@ static void __iomem *acpi_pre_map(phys_a
 
 	pg_off = paddr & PAGE_MASK;
 	pg_sz = ((paddr + size + PAGE_SIZE - 1) & PAGE_MASK) - pg_off;
-	vaddr = ioremap(pg_off, pg_sz);
+	vaddr = acpi_map(pg_off, pg_sz);
 	if (!vaddr)
 		return NULL;
 	map = kmalloc(sizeof(*map), GFP_KERNEL);
@@ -135,7 +161,7 @@ static void __iomem *acpi_pre_map(phys_a
 	vaddr = __acpi_try_ioremap(paddr, size);
 	if (vaddr) {
 		spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
-		iounmap(map->vaddr);
+		acpi_unmap(pg_off, map->vaddr);
 		kfree(map);
 		return vaddr;
 	}
@@ -144,7 +170,7 @@ static void __iomem *acpi_pre_map(phys_a
 
 	return map->vaddr + (paddr - map->paddr);
 err_unmap:
-	iounmap(vaddr);
+	acpi_unmap(pg_off, vaddr);
 	return NULL;
 }
 
@@ -177,7 +203,7 @@ static void acpi_post_unmap(phys_addr_t
 		return;
 
 	synchronize_rcu();
-	iounmap(map->vaddr);
+	acpi_unmap(map->paddr, map->vaddr);
 	kfree(map);
 }
 
