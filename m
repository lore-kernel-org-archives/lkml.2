Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641Ab1IOMmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:42:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27875 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933592Ab1IOMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:52 -0400
X-IronPort-AV: E=Sophos;i="4.68,387,1312171200"; 
   d="scan'208";a="163268193"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 1/6] xen: add functions for mapping foreign pages over pages
Date: Thu, 15 Sep 2011 13:40:06 +0100
Message-ID: <1316090411-22608-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Add xenbus_map_ring_page() and xenbus_unmap_ring_page() which map and
unmap foreign pages over a page instead of mapping them into vmalloc
address space.  This avoids having to do an expensive
vmalloc_sync_all().

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/xen/xenbus/xenbus_client.c |   68 ++++++++++++++++++++++++++++++++++++
 include/xen/xenbus.h               |    3 ++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index cdacf92..504325b 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -32,6 +32,7 @@
 
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <asm/xen/hypervisor.h>
 #include <xen/interface/xen.h>
@@ -39,6 +40,7 @@
 #include <xen/events.h>
 #include <xen/grant_table.h>
 #include <xen/xenbus.h>
+#include <xen/page.h>
 
 const char *xenbus_strstate(enum xenbus_state state)
 {
@@ -509,6 +511,44 @@ EXPORT_SYMBOL_GPL(xenbus_map_ring);
 
 
 /**
+ * xenbus_map_ring_page - map a foreign page into a kernel page
+ * @dev: xenbus device
+ * @gnt_ref: grant reference
+ * @page: return the page the foreign page has been mapped to
+ *
+ * Map a foreign page from another domain's grant table into a newly
+ * allocated page in this domain.  The page must be unmapped with
+ * xenbus_unmap_ring_page().
+ *
+ * Returns 0 on success, and -ENOMEM or GNTST_* (see
+ * include/xen/interface/grant_table.h) on error.
+ */
+int xenbus_map_ring_page(struct xenbus_device *dev, int gnt_ref,
+			 struct page **page)
+{
+	struct page *new_page;
+	grant_ref_t handle;
+	int ret;
+
+	new_page = alloc_page(GFP_KERNEL);
+	if (!new_page)
+		return -ENOMEM;
+
+	ret = xenbus_map_ring(dev, gnt_ref, &handle, page_address(new_page));
+	if (ret < 0)
+		goto err;
+
+	new_page->private = handle;
+	*page = new_page;
+	return 0;
+
+err:
+	__free_page(new_page);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xenbus_map_ring_page);
+
+/**
  * xenbus_unmap_ring_vfree
  * @dev: xenbus device
  * @vaddr: addr to unmap
@@ -593,6 +633,34 @@ int xenbus_unmap_ring(struct xenbus_device *dev,
 }
 EXPORT_SYMBOL_GPL(xenbus_unmap_ring);
 
+/**
+ * xenbus_unmap_ring_page - unmap an foreign page from a kernel page
+ * @dev: xenbus device
+ * @page: page the foreign page was mapped to
+ *
+ * Unmap a foreign page previously mapped with xenbus_map_ring_page().
+ * The page is freed.
+ */
+void xenbus_unmap_ring_page(struct xenbus_device *dev, struct page *page)
+{
+	int ret;
+
+	ret = xenbus_unmap_ring(dev, page->private, page_address(page));
+	if (ret < 0)
+		return;
+
+	/*
+	 * Restore the original PTE of this page before freeing it.
+	 */
+	ret = HYPERVISOR_update_va_mapping(
+		(unsigned long)page_address(page),
+		mfn_pte(get_phys_to_machine(page_to_pfn(page)), PAGE_KERNEL),
+		0);
+	BUG_ON(ret);
+
+	__free_page(page);
+}
+EXPORT_SYMBOL_GPL(xenbus_unmap_ring_page);
 
 /**
  * xenbus_read_driver_state
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index aceeca7..ebde2fd 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -212,10 +212,13 @@ int xenbus_map_ring_valloc(struct xenbus_device *dev,
 			   int gnt_ref, void **vaddr);
 int xenbus_map_ring(struct xenbus_device *dev, int gnt_ref,
 			   grant_handle_t *handle, void *vaddr);
+int xenbus_map_ring_page(struct xenbus_device *dev, int gnt_ref,
+			 struct page **page);
 
 int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr);
 int xenbus_unmap_ring(struct xenbus_device *dev,
 		      grant_handle_t handle, void *vaddr);
+void xenbus_unmap_ring_page(struct xenbus_device *dev, struct page *page);
 
 int xenbus_alloc_evtchn(struct xenbus_device *dev, int *port);
 int xenbus_bind_evtchn(struct xenbus_device *dev, int remote_port, int *port);
-- 
1.7.2.5

