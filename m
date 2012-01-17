Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2AQMYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:24:50 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:51589 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab2AQMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:25 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 31/50] ACPI, Add RAM mapping support to ACPI atomic IO support
Date: Tue, 17 Jan 2012 07:21:23 -0500
Message-id: <76da3fb3575e39fb23b2c072997ccd1187a2ce9d.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

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
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/atomicio.c |   41 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
index 1016f18..d4a5b3d 100644
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
@@ -97,6 +99,37 @@ static void __iomem *__acpi_try_ioremap(phys_addr_t paddr,
 		return NULL;
 }
 
+#ifndef CONFIG_IA64
+#define should_use_kmap(pfn)	page_is_ram(pfn)
+#else
+/* ioremap will take care of cache attributes */
+#define should_use_kmap(pfn)	0
+#endif
+
+static void __iomem *acpi_map(phys_addr_t pg_off, unsigned long pg_sz)
+{
+	unsigned long pfn;
+
+	pfn = pg_off >> PAGE_SHIFT;
+	if (should_use_kmap(pfn)) {
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
@@ -119,7 +152,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
 
 	pg_off = paddr & PAGE_MASK;
 	pg_sz = ((paddr + size + PAGE_SIZE - 1) & PAGE_MASK) - pg_off;
-	vaddr = ioremap(pg_off, pg_sz);
+	vaddr = acpi_map(pg_off, pg_sz);
 	if (!vaddr)
 		return NULL;
 	map = kmalloc(sizeof(*map), GFP_KERNEL);
@@ -135,7 +168,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
 	vaddr = __acpi_try_ioremap(paddr, size);
 	if (vaddr) {
 		spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
-		iounmap(map->vaddr);
+		acpi_unmap(pg_off, map->vaddr);
 		kfree(map);
 		return vaddr;
 	}
@@ -144,7 +177,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
 
 	return map->vaddr + (paddr - map->paddr);
 err_unmap:
-	iounmap(vaddr);
+	acpi_unmap(pg_off, vaddr);
 	return NULL;
 }
 
@@ -177,7 +210,7 @@ static void acpi_post_unmap(phys_addr_t paddr, unsigned long size)
 		return;
 
 	synchronize_rcu();
-	iounmap(map->vaddr);
+	acpi_unmap(map->paddr, map->vaddr);
 	kfree(map);
 }
 
-- 
1.7.9.rc1

