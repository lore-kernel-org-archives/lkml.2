Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab0KSWde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:33:34 -0500
Received: from kroah.org ([198.145.64.141]:44992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab0KSV62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:28 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:40 2010
Message-Id: <20101119215639.983226733@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Cliff Wickman <cpw@sgi.com>, kexec@lists.infradead.org,
        Ingo Molnar <mingo@elte.hu>
Subject: [15/82] mm, x86: Saving vmcore with non-lazy freeing of vmas
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cliff Wickman <cpw@sgi.com>

commit 3ee48b6af49cf534ca2f481ecc484b156a41451d upstream.

During the reading of /proc/vmcore the kernel is doing
ioremap()/iounmap() repeatedly. And the buildup of un-flushed
vm_area_struct's is causing a great deal of overhead. (rb_next()
is chewing up most of that time).

This solution is to provide function set_iounmap_nonlazy(). It
causes a subsequent call to iounmap() to immediately purge the
vma area (with try_purge_vmap_area_lazy()).

With this patch we have seen the time for writing a 250MB
compressed dump drop from 71 seconds to 44 seconds.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org
LKML-Reference: <E1OwHZ4-0005WK-Tw@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/io.h       |    1 +
 arch/x86/kernel/crash_dump_64.c |    1 +
 mm/vmalloc.c                    |    9 +++++++++
 3 files changed, 11 insertions(+)

--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -206,6 +206,7 @@ static inline void __iomem *ioremap(reso
 
 extern void iounmap(volatile void __iomem *addr);
 
+extern void set_iounmap_nonlazy(void);
 
 #ifdef __KERNEL__
 
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -46,6 +46,7 @@ ssize_t copy_oldmem_page(unsigned long p
 	} else
 		memcpy(buf, vaddr + offset, csize);
 
+	set_iounmap_nonlazy();
 	iounmap(vaddr);
 	return csize;
 }
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -513,6 +513,15 @@ static atomic_t vmap_lazy_nr = ATOMIC_IN
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


