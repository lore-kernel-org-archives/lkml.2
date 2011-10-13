Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1JMPvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:51:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:34656 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab1JMPvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:51:10 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: hjk@hansjkoch.de
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
        Kai Jiang <Kai.Jiang@freescale.com>
Subject: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Date: Thu, 13 Oct 2011 10:50:58 -0500
Message-Id: <1318521058-15662-1-git-send-email-galak@kernel.crashing.org>
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
easiest solution is to just change the type to 'phys_addr_t' which
should always be greater than or equal to the sizeof(void *) such that
it can properly hold any of the address types.

For physical address we can support up to a 44-bit physical address on a
typical 32-bit system as we utilize remap_pfn_range() for the mapping of
the memory region and pfn's are represnted by shifting the address by
the page size (typically 4k).

Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
Signed-off-by: Minghuan Lian <Minghuan.Lian@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
v3:
* Updated commit message to be correct w/regards to code
* Updated comment about addr field in uio_mem
v2:
* Use phys_addr_t instead of 'unsigned long long'
* Updated DocBook detail in uio-howto.tmpl

 Documentation/DocBook/uio-howto.tmpl |    2 +-
 drivers/uio/uio.c                    |    8 ++++----
 include/linux/uio_driver.h           |    7 +++++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 7c4b514d..54883de 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -529,7 +529,7 @@ memory (e.g. allocated with <function>kmalloc()</function>). There's also
 </para></listitem>
 
 <listitem><para>
-<varname>unsigned long addr</varname>: Required if the mapping is used.
+<varname>phys_addr_t addr</varname>: Required if the mapping is used.
 Fill in the address of your memory block. This address is the one that
 appears in sysfs.
 </para></listitem>
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 88f4444..43b7096 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -69,7 +69,7 @@ static ssize_t map_name_show(struct uio_mem *mem, char *buf)
 
 static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%lx\n", mem->addr);
+	return sprintf(buf, "0x%llx\n", (unsigned long long)mem->addr);
 }
 
 static ssize_t map_size_show(struct uio_mem *mem, char *buf)
@@ -79,7 +79,7 @@ static ssize_t map_size_show(struct uio_mem *mem, char *buf)
 
 static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%lx\n", mem->addr & ~PAGE_MASK);
+	return sprintf(buf, "0x%llx\n", (unsigned long long)mem->addr & ~PAGE_MASK);
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
index 4c618cd..ad16aa9 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -23,7 +23,10 @@ struct uio_map;
 /**
  * struct uio_mem - description of a UIO memory region
  * @name:		name of the memory region for identification
- * @addr:		address of the device's memory
+ * @addr:		address of the device's memory (phys_addr is used since
+ * 			addr can be logical, virtual, or physical & phys_addr_t
+ * 			should always be large enough to handle any of the
+ * 			address types)
  * @size:		size of IO
  * @memtype:		type of memory addr points to
  * @internal_addr:	ioremap-ped version of addr, for driver internal use
@@ -32,7 +35,7 @@ struct uio_map;
  */
 struct uio_mem {
 	const char		*name;
-	unsigned long		addr;
+	phys_addr_t		addr;
 	unsigned long		size;
 	int			memtype;
 	void __iomem		*internal_addr;
-- 
1.7.3.4

