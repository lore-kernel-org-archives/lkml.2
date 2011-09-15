Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab1IOMlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:41:00 -0400
Received: from smtp.citrix.com ([66.165.176.89]:3997 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933617Ab1IOMk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:57 -0400
X-IronPort-AV: E=Sophos;i="4.68,387,1312171200"; 
   d="scan'208";a="17185376"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 5/6] xen: xenbus: remove xenbus_map_ring_valloc() and xenbus_map_ring_vfree()
Date: Thu, 15 Sep 2011 13:40:10 +0100
Message-ID: <1316090411-22608-6-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

xenbus_map_ring_valloc() and xenbus_map_ring_vfree() are no longer
used.  Drivers should use xenbus_map_ring_page() instead.

xenbus_map_ring() and xenbus_unmap_ring also have no users outside of
the file and are made static.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/ia64/xen/grant-table.c        |    2 +-
 drivers/xen/xenbus/xenbus_client.c |  119 ++----------------------------------
 include/xen/xenbus.h               |    9 +---
 3 files changed, 7 insertions(+), 123 deletions(-)

diff --git a/arch/ia64/xen/grant-table.c b/arch/ia64/xen/grant-table.c
index 48cca37..4b72424 100644
--- a/arch/ia64/xen/grant-table.c
+++ b/arch/ia64/xen/grant-table.c
@@ -54,7 +54,7 @@ struct vm_struct *xen_alloc_vm_area(unsigned long size)
 	area->size = size;
 	area->pages = NULL;
 	area->nr_pages = nr_pages;
-	area->phys_addr = 0;	/* xenbus_map_ring_valloc uses this field!  */
+	area->phys_addr = 0;
 
 	return area;
 
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 504325b..3c64be8 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -419,58 +419,6 @@ int xenbus_free_evtchn(struct xenbus_device *dev, int port)
 }
 EXPORT_SYMBOL_GPL(xenbus_free_evtchn);
 
-
-/**
- * xenbus_map_ring_valloc
- * @dev: xenbus device
- * @gnt_ref: grant reference
- * @vaddr: pointer to address to be filled out by mapping
- *
- * Based on Rusty Russell's skeleton driver's map_page.
- * Map a page of memory into this domain from another domain's grant table.
- * xenbus_map_ring_valloc allocates a page of virtual address space, maps the
- * page to that address, and sets *vaddr to that address.
- * Returns 0 on success, and GNTST_* (see xen/include/interface/grant_table.h)
- * or -ENOMEM on error. If an error is returned, device will switch to
- * XenbusStateClosing and the error message will be saved in XenStore.
- */
-int xenbus_map_ring_valloc(struct xenbus_device *dev, int gnt_ref, void **vaddr)
-{
-	struct gnttab_map_grant_ref op = {
-		.flags = GNTMAP_host_map,
-		.ref   = gnt_ref,
-		.dom   = dev->otherend_id,
-	};
-	struct vm_struct *area;
-
-	*vaddr = NULL;
-
-	area = xen_alloc_vm_area(PAGE_SIZE);
-	if (!area)
-		return -ENOMEM;
-
-	op.host_addr = (unsigned long)area->addr;
-
-	if (HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, &op, 1))
-		BUG();
-
-	if (op.status != GNTST_okay) {
-		xen_free_vm_area(area);
-		xenbus_dev_fatal(dev, op.status,
-				 "mapping in shared page %d from domain %d",
-				 gnt_ref, dev->otherend_id);
-		return op.status;
-	}
-
-	/* Stuff the handle in an unused field */
-	area->phys_addr = (unsigned long)op.handle;
-
-	*vaddr = area->addr;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xenbus_map_ring_valloc);
-
-
 /**
  * xenbus_map_ring
  * @dev: xenbus device
@@ -485,8 +433,8 @@ EXPORT_SYMBOL_GPL(xenbus_map_ring_valloc);
  * or -ENOMEM on error. If an error is returned, device will switch to
  * XenbusStateClosing and the error message will be saved in XenStore.
  */
-int xenbus_map_ring(struct xenbus_device *dev, int gnt_ref,
-		    grant_handle_t *handle, void *vaddr)
+static int xenbus_map_ring(struct xenbus_device *dev, int gnt_ref,
+			   grant_handle_t *handle, void *vaddr)
 {
 	struct gnttab_map_grant_ref op = {
 		.host_addr = (unsigned long)vaddr,
@@ -502,13 +450,12 @@ int xenbus_map_ring(struct xenbus_device *dev, int gnt_ref,
 		xenbus_dev_fatal(dev, op.status,
 				 "mapping in shared page %d from domain %d",
 				 gnt_ref, dev->otherend_id);
+		*handle = 0;
 	} else
 		*handle = op.handle;
 
 	return op.status;
 }
-EXPORT_SYMBOL_GPL(xenbus_map_ring);
-
 
 /**
  * xenbus_map_ring_page - map a foreign page into a kernel page
@@ -549,61 +496,6 @@ err:
 EXPORT_SYMBOL_GPL(xenbus_map_ring_page);
 
 /**
- * xenbus_unmap_ring_vfree
- * @dev: xenbus device
- * @vaddr: addr to unmap
- *
- * Based on Rusty Russell's skeleton driver's unmap_page.
- * Unmap a page of memory in this domain that was imported from another domain.
- * Use xenbus_unmap_ring_vfree if you mapped in your memory with
- * xenbus_map_ring_valloc (it will free the virtual address space).
- * Returns 0 on success and returns GNTST_* on error
- * (see xen/include/interface/grant_table.h).
- */
-int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr)
-{
-	struct vm_struct *area;
-	struct gnttab_unmap_grant_ref op = {
-		.host_addr = (unsigned long)vaddr,
-	};
-
-	/* It'd be nice if linux/vmalloc.h provided a find_vm_area(void *addr)
-	 * method so that we don't have to muck with vmalloc internals here.
-	 * We could force the user to hang on to their struct vm_struct from
-	 * xenbus_map_ring_valloc, but these 6 lines considerably simplify
-	 * this API.
-	 */
-	read_lock(&vmlist_lock);
-	for (area = vmlist; area != NULL; area = area->next) {
-		if (area->addr == vaddr)
-			break;
-	}
-	read_unlock(&vmlist_lock);
-
-	if (!area) {
-		xenbus_dev_error(dev, -ENOENT,
-				 "can't find mapped virtual address %p", vaddr);
-		return GNTST_bad_virt_addr;
-	}
-
-	op.handle = (grant_handle_t)area->phys_addr;
-
-	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, &op, 1))
-		BUG();
-
-	if (op.status == GNTST_okay)
-		xen_free_vm_area(area);
-	else
-		xenbus_dev_error(dev, op.status,
-				 "unmapping page at handle %d error %d",
-				 (int16_t)area->phys_addr, op.status);
-
-	return op.status;
-}
-EXPORT_SYMBOL_GPL(xenbus_unmap_ring_vfree);
-
-
-/**
  * xenbus_unmap_ring
  * @dev: xenbus device
  * @handle: grant handle
@@ -613,8 +505,8 @@ EXPORT_SYMBOL_GPL(xenbus_unmap_ring_vfree);
  * Returns 0 on success and returns GNTST_* on error
  * (see xen/include/interface/grant_table.h).
  */
-int xenbus_unmap_ring(struct xenbus_device *dev,
-		      grant_handle_t handle, void *vaddr)
+static int xenbus_unmap_ring(struct xenbus_device *dev,
+			     grant_handle_t handle, void *vaddr)
 {
 	struct gnttab_unmap_grant_ref op = {
 		.host_addr = (unsigned long)vaddr,
@@ -631,7 +523,6 @@ int xenbus_unmap_ring(struct xenbus_device *dev,
 
 	return op.status;
 }
-EXPORT_SYMBOL_GPL(xenbus_unmap_ring);
 
 /**
  * xenbus_unmap_ring_page - unmap an foreign page from a kernel page
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index ebde2fd..d73d320 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -208,16 +208,9 @@ int xenbus_watch_pathfmt(struct xenbus_device *dev, struct xenbus_watch *watch,
 
 int xenbus_switch_state(struct xenbus_device *dev, enum xenbus_state new_state);
 int xenbus_grant_ring(struct xenbus_device *dev, unsigned long ring_mfn);
-int xenbus_map_ring_valloc(struct xenbus_device *dev,
-			   int gnt_ref, void **vaddr);
-int xenbus_map_ring(struct xenbus_device *dev, int gnt_ref,
-			   grant_handle_t *handle, void *vaddr);
+
 int xenbus_map_ring_page(struct xenbus_device *dev, int gnt_ref,
 			 struct page **page);
-
-int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr);
-int xenbus_unmap_ring(struct xenbus_device *dev,
-		      grant_handle_t handle, void *vaddr);
 void xenbus_unmap_ring_page(struct xenbus_device *dev, struct page *page);
 
 int xenbus_alloc_evtchn(struct xenbus_device *dev, int *port);
-- 
1.7.2.5

