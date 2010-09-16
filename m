Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0IPQmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:42:04 -0400
Received: from relay3.sgi.com ([192.48.152.1]:44716 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753109Ab0IPQmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:42:03 -0400
To: kexec@lists.infradead.org, mingo@elte.hu
Subject: [PATCH] x86: saving vmcore with non-lazy freeing of vmas 
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1OwHZ4-0005WK-Tw@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 16 Sep 2010 11:44:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

During the reading of /proc/vmcore the kernel is doing ioremap()/iounmap()
repeatedly. And the buildup of un-flushed vm_area_struct's is causing
a great deal of overhead. (rb_next() is chewing up most of that time).

This solution is to provide function set_iounmap_nonlazy(). It causes a
subsequent call to iounmap() to immediately purge the vma area (with
try_purge_vmap_area_lazy()).

With this patch we have seen the time for writing a 250MB compressed dump
drop from 71 seconds to 44 seconds.

Diffed against 2.6.36-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/include/asm/io.h       |    1 +
 arch/x86/kernel/crash_dump_64.c |    1 +
 mm/vmalloc.c                    |    9 +++++++++
 3 files changed, 11 insertions(+)

Index: linus.current/arch/x86/kernel/crash_dump_64.c
===================================================================
--- linus.current.orig/arch/x86/kernel/crash_dump_64.c
+++ linus.current/arch/x86/kernel/crash_dump_64.c
@@ -46,6 +46,7 @@ ssize_t copy_oldmem_page(unsigned long p
 	} else
 		memcpy(buf, vaddr + offset, csize);
 
+	set_iounmap_nonlazy();
 	iounmap(vaddr);
 	return csize;
 }
Index: linus.current/mm/vmalloc.c
===================================================================
--- linus.current.orig/mm/vmalloc.c
+++ linus.current/mm/vmalloc.c
@@ -517,6 +517,15 @@ static atomic_t vmap_lazy_nr = ATOMIC_IN
 static void purge_fragmented_blocks_allcpus(void);
 
 /*
+ * called before a call to iounmap() if the caller wants vm_area_struct's
+ * immediately freed.
+ */
+void set_iounmap_nonlazy(void)
+{
+	atomic_set(&vmap_lazy_nr, lazy_max_pages()+1);
+}
+
+/*
  * Purges all lazily-freed vmap areas.
  *
  * If sync is 0 then don't purge if there is already a purge in progress.
Index: linus.current/arch/x86/include/asm/io.h
===================================================================
--- linus.current.orig/arch/x86/include/asm/io.h
+++ linus.current/arch/x86/include/asm/io.h
@@ -206,6 +206,7 @@ static inline void __iomem *ioremap(reso
 
 extern void iounmap(volatile void __iomem *addr);
 
+extern void set_iounmap_nonlazy(void);
 
 #ifdef __KERNEL__
 
