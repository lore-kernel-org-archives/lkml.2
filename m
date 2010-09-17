Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0IQI3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:29:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:59356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab0IQI3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:29:32 -0400
Date: Fri, 17 Sep 2010 08:29:04 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, stable@kernel.org, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, stable@kernel.org, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OwHZ4-0005WK-Tw@eag09.americas.sgi.com>
References: <E1OwHZ4-0005WK-Tw@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] mm, x86: Saving vmcore with non-lazy freeing of vmas
Message-ID: <tip-3ee48b6af49cf534ca2f481ecc484b156a41451d@git.kernel.org>
Git-Commit-ID: 3ee48b6af49cf534ca2f481ecc484b156a41451d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 08:29:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ee48b6af49cf534ca2f481ecc484b156a41451d
Gitweb:     http://git.kernel.org/tip/3ee48b6af49cf534ca2f481ecc484b156a41451d
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Thu, 16 Sep 2010 11:44:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Sep 2010 09:11:56 +0200

mm, x86: Saving vmcore with non-lazy freeing of vmas

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
Cc: <stable@kernel.org>
LKML-Reference: <E1OwHZ4-0005WK-Tw@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io.h       |    1 +
 arch/x86/kernel/crash_dump_64.c |    1 +
 mm/vmalloc.c                    |    9 +++++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 30a3e97..6a45ec4 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -206,6 +206,7 @@ static inline void __iomem *ioremap(resource_size_t offset, unsigned long size)
 
 extern void iounmap(volatile void __iomem *addr);
 
+extern void set_iounmap_nonlazy(void);
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index bf43188..9948288 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -46,6 +46,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	} else
 		memcpy(buf, vaddr + offset, csize);
 
+	set_iounmap_nonlazy();
 	iounmap(vaddr);
 	return csize;
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6b8889d..d8087f0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -517,6 +517,15 @@ static atomic_t vmap_lazy_nr = ATOMIC_INIT(0);
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
