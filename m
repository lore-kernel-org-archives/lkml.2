Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab1JLOgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:36:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:59018 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab1JLOgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:36:07 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: hjk@hansjkoch.de
Cc: gregkh@suse.de, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Kai Jiang <Kai.Jiang@freescale.com>
Subject: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Date: Wed, 12 Oct 2011 09:35:45 -0500
Message-Id: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kai Jiang <Kai.Jiang@freescale.com>

To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
extend the width of 'addr' in struct uio_mem.  Numerous platforms like
embedded PPC, ARM, and X86 have support for systems with larger physical
address than logical.

Since 'addr' may contain a physical, logical, or virtual address the
easiest solution is to just change the type to 'unsigned long long'
regardless of which type is utilized.

For physical address we can support up to a 44-bit physical address on a
typical 32-bit system as we utilize remap_pfn_range() for the mapping of
the memory region and pfn's are represnted by shifting the address by
the page size (typically 4k).

Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
Signed-off-by: Minghuan Lian <Minghuan.Lian@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/uio/uio.c          |    8 ++++----
 include/linux/uio_driver.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index d2efe82..a927c51 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -69,7 +69,7 @@ static ssize_t map_name_show(struct uio_mem *mem, char *buf)
 
 static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%lx\n", mem->addr);
+	return sprintf(buf, "0x%llx\n", mem->addr);
 }
 
 static ssize_t map_size_show(struct uio_mem *mem, char *buf)
@@ -79,7 +79,7 @@ static ssize_t map_size_show(struct uio_mem *mem, char *buf)
 
 static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%lx\n", mem->addr & ~PAGE_MASK);
+	return sprintf(buf, "0x%llx\n", mem->addr & ~PAGE_MASK);
 }
 
 struct map_sysfs_entry {
@@ -634,8 +634,8 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
 		page = virt_to_page(idev->info->mem[mi].addr + offset);
 	else
-		page = vmalloc_to_page((void *)idev->info->mem[mi].addr
-							+ offset);
+		page = vmalloc_to_page((void *)(unsigned long)
+				idev->info->mem[mi].addr + offset);
 	get_page(page);
 	vmf->page = page;
 	return 0;
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 665517c..c1fdb19 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -31,7 +31,7 @@ struct uio_map;
  */
 struct uio_mem {
 	const char		*name;
-	unsigned long		addr;
+	unsigned long long	addr;
 	unsigned long		size;
 	int			memtype;
 	void __iomem		*internal_addr;
-- 
1.7.3.4

