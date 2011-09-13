Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1IMN1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:27:00 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:45774 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1IMN06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:26:58 -0400
Message-Id: <20110913132654.157278466@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 13 Sep 2011 15:26:37 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com, akpm@linux-foundation.org
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v2 2/2] s390: Add architecture code for unmapping crashkernel memory
References: <20110913132635.063397500@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-arch-crash_map_pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch implements the crash_map_pages() function for s390.
KEXEC_CRASH_MEM_ALIGN is set to HPAGE_SIZE, in order to support
kernel mappings that use large pages.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/include/asm/kexec.h    |    3 +++
 arch/s390/kernel/machine_kexec.c |   31 +++++++++++++++++++++++++++++++
 arch/s390/kernel/setup.c         |   10 ++++++----
 3 files changed, 40 insertions(+), 4 deletions(-)

--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -36,6 +36,9 @@
 /* Allocate one page for the pdp and the second for the code */
 #define KEXEC_CONTROL_PAGE_SIZE 4096
 
+/* Alignment of crashkernel memory */
+#define KEXEC_CRASH_MEM_ALIGN HPAGE_SIZE
+
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_S390
 
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -243,6 +243,37 @@ static void __machine_kdump(void *image)
 #endif
 
 /*
+ * Map or unmap crashkernel memory
+ */
+static void crash_map_pages(int enable)
+{
+	unsigned long size = crashk_res.end - crashk_res.start + 1;
+
+	BUG_ON(crashk_res.start % KEXEC_CRASH_MEM_ALIGN ||
+	       size % KEXEC_CRASH_MEM_ALIGN);
+	if (enable)
+		vmem_add_mapping(crashk_res.start, size);
+	else
+		vmem_remove_mapping(crashk_res.start, size);
+}
+
+/*
+ * Map crashkernel memory
+ */
+void crash_map_reserved_pages(void)
+{
+	crash_map_pages(1);
+}
+
+/*
+ * Unmap crashkernel memory
+ */
+void crash_unmap_reserved_pages(void)
+{
+	crash_map_pages(0);
+}
+
+/*
  * Give back memory to hypervisor before new kdump is loaded
  */
 static int machine_kexec_prepare_kdump(void)
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -446,6 +446,7 @@ static void __init setup_resources(void)
 		res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
 		switch (memory_chunk[i].type) {
 		case CHUNK_READ_WRITE:
+		case CHUNK_CRASHK:
 			res->name = "System RAM";
 			break;
 		case CHUNK_READ_ONLY:
@@ -706,8 +707,8 @@ static void __init reserve_crashkernel(v
 			       &crash_base);
 	if (rc || crash_size == 0)
 		return;
-	crash_base = PAGE_ALIGN(crash_base);
-	crash_size = PAGE_ALIGN(crash_size);
+	crash_base = ALIGN(crash_base, KEXEC_CRASH_MEM_ALIGN);
+	crash_size = ALIGN(crash_size, KEXEC_CRASH_MEM_ALIGN);
 	if (register_memory_notifier(&kdump_mem_nb))
 		return;
 	if (!crash_base)
@@ -727,7 +728,7 @@ static void __init reserve_crashkernel(v
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
 	insert_resource(&iomem_resource, &crashk_res);
-	reserve_kdump_bootmem(crash_base, crash_size, CHUNK_READ_WRITE);
+	reserve_kdump_bootmem(crash_base, crash_size, CHUNK_CRASHK);
 	pr_info("Reserving %lluMB of memory at %lluMB "
 		"for crashkernel (System RAM: %luMB)\n",
 		crash_size >> 20, crash_base >> 20, memory_end >> 20);
@@ -802,7 +803,8 @@ setup_memory(void)
 	for (i = 0; i < MEMORY_CHUNKS && memory_chunk[i].size > 0; i++) {
 		unsigned long start_chunk, end_chunk, pfn;
 
-		if (memory_chunk[i].type != CHUNK_READ_WRITE)
+		if (memory_chunk[i].type != CHUNK_READ_WRITE &&
+		    memory_chunk[i].type != CHUNK_CRASHK)
 			continue;
 		start_chunk = PFN_DOWN(memory_chunk[i].addr);
 		end_chunk = start_chunk + PFN_DOWN(memory_chunk[i].size);

