Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2BEW1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:38 -0500
Received: from 1wt.eu ([62.212.114.60]:62155 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab2BEW1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:33 -0500
Message-Id: <20120205220952.100717855@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:51 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 62/91] [PATCH] x86, mm: Add __get_user_pages_fast()
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

Introduce a gup_fast() variant which is usable from IRQ/NMI context.

[ WT: this one is only needed for next patch ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Nick Piggin <npiggin@suse.de>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/gup.c  |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h |    6 +++++
 2 files changed, 62 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/arch/x86/mm/gup.c
===================================================================
--- longterm-2.6.27.orig/arch/x86/mm/gup.c	2012-02-05 22:34:33.105915236 +0100
+++ longterm-2.6.27/arch/x86/mm/gup.c	2012-02-05 22:34:43.693914996 +0100
@@ -219,6 +219,62 @@
 	return 1;
 }
 
+/*
+ * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
+ * back to the regular GUP.
+ */
+int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			  struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long addr, len, end;
+	unsigned long next;
+	unsigned long flags;
+	pgd_t *pgdp;
+	int nr = 0;
+
+	start &= PAGE_MASK;
+	addr = start;
+	len = (unsigned long) nr_pages << PAGE_SHIFT;
+	end = start + len;
+	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
+					(void __user *)start, len)))
+		return 0;
+
+	/*
+	 * XXX: batch / limit 'nr', to avoid large irq off latency
+	 * needs some instrumenting to determine the common sizes used by
+	 * important workloads (eg. DB2), and whether limiting the batch size
+	 * will decrease performance.
+	 *
+	 * It seems like we're in the clear for the moment. Direct-IO is
+	 * the main guy that batches up lots of get_user_pages, and even
+	 * they are limited to 64-at-a-time which is not so many.
+	 */
+	/*
+	 * This doesn't prevent pagetable teardown, but does prevent
+	 * the pagetables and pages from being freed on x86.
+	 *
+	 * So long as we atomically load page table pointers versus teardown
+	 * (which we do on x86, with the above PAE exception), we can follow the
+	 * address down to the the page and take a ref on it.
+	 */
+	local_irq_save(flags);
+	pgdp = pgd_offset(mm, addr);
+	do {
+		pgd_t pgd = *pgdp;
+
+		next = pgd_addr_end(addr, end);
+		if (pgd_none(pgd))
+			break;
+		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+			break;
+	} while (pgdp++, addr = next, addr != end);
+	local_irq_restore(flags);
+
+	return nr;
+}
+
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages)
 {
Index: longterm-2.6.27/include/linux/mm.h
===================================================================
--- longterm-2.6.27.orig/include/linux/mm.h	2012-02-05 22:34:33.099915218 +0100
+++ longterm-2.6.27/include/linux/mm.h	2012-02-05 22:34:43.701916289 +0100
@@ -850,6 +850,12 @@
 			struct page **pages);
 
 /*
+ * doesn't attempt to fault and will return short.
+ */
+int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			  struct page **pages);
+
+/*
  * A callback you can register to apply pressure to ageable caches.
  *
  * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should


