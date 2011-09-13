Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1IMN1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:27:30 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:49267 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1IMN06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:26:58 -0400
Message-Id: <20110913132653.979044245@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 13 Sep 2011 15:26:36 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com, akpm@linux-foundation.org
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v2 1/2] kdump: Add infrastructure for unmapping crashkernel memory
References: <20110913132635.063397500@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-common-crash_map_pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch introduces a mechanism that allows architecture backends to
remove page tables for the crashkernel memory. This can protect the loaded
kdump kernel from being overwritten by broken kernel code.  Two new
functions crash_map_reserved_pages() and crash_unmap_reserved_pages() are
added that can be implemented by architecture code.  The
crash_map_reserved_pages() function is called before and
crash_unmap_reserved_pages() after the crashkernel segments are loaded.  The
functions are also called in crash_shrink_memory() to create/remove page
tables when the crashkernel memory size is reduced.

To support architectures that have large pages this patch also introduces
a new define KEXEC_CRASH_MEM_ALIGN. The crashkernel start and size must 
always be aligned with KEXEC_CRASH_MEM_ALIGN.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/kexec.h |    6 ++++++
 kernel/kexec.c        |   21 +++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -37,6 +37,10 @@
 #define KEXEC_CRASH_CONTROL_MEMORY_LIMIT KEXEC_CONTROL_MEMORY_LIMIT
 #endif
 
+#ifndef KEXEC_CRASH_MEM_ALIGN
+#define KEXEC_CRASH_MEM_ALIGN PAGE_SIZE
+#endif
+
 #define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
 #define KEXEC_CORE_NOTE_NAME "CORE"
 #define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
@@ -133,6 +137,8 @@ extern void crash_kexec(struct pt_regs *
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
 void crash_save_vmcoreinfo(void);
+void crash_map_reserved_pages(void);
+void crash_unmap_reserved_pages(void);
 void arch_crash_save_vmcoreinfo(void);
 void vmcoreinfo_append_str(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -999,6 +999,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 			kimage_free(xchg(&kexec_crash_image, NULL));
 			result = kimage_crash_alloc(&image, entry,
 						     nr_segments, segments);
+			crash_map_reserved_pages();
 		}
 		if (result)
 			goto out;
@@ -1015,6 +1016,8 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 				goto out;
 		}
 		kimage_terminate(image);
+		if (flags & KEXEC_ON_CRASH)
+			crash_unmap_reserved_pages();
 	}
 	/* Install the new kernel, and  Uninstall the old */
 	image = xchg(dest_image, image);
@@ -1026,6 +1029,18 @@ out:
 	return result;
 }
 
+/*
+ * Add and remove page tables for crashkernel memory
+ *
+ * Provide an empty default implementation here -- architecture
+ * code may override this
+ */
+void __weak crash_map_reserved_pages(void)
+{}
+
+void __weak crash_unmap_reserved_pages(void)
+{}
+
 #ifdef CONFIG_COMPAT
 asmlinkage long compat_sys_kexec_load(unsigned long entry,
 				unsigned long nr_segments,
@@ -1134,14 +1149,16 @@ int crash_shrink_memory(unsigned long ne
 		goto unlock;
 	}
 
-	start = roundup(start, PAGE_SIZE);
-	end = roundup(start + new_size, PAGE_SIZE);
+	start = roundup(start, KEXEC_CRASH_MEM_ALIGN);
+	end = roundup(start + new_size, KEXEC_CRASH_MEM_ALIGN);
 
+	crash_map_reserved_pages();
 	crash_free_reserved_phys_range(end, crashk_res.end);
 
 	if ((start == end) && (crashk_res.parent != NULL))
 		release_resource(&crashk_res);
 	crashk_res.end = end - 1;
+	crash_unmap_reserved_pages();
 
 unlock:
 	mutex_unlock(&kexec_mutex);

