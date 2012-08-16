Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195Ab2HPQKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:10:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55473 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093Ab2HPQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:10:20 -0400
Date: Thu, 16 Aug 2012 17:09:54 +0100
From: Will Deacon <will.deacon@arm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: hugetlb: flush dcache before returning zeroed huge
 page to userspace
Message-ID: <20120816160954.GA4330@mudshark.cambridge.arm.com>
References: <20120709141324.GK7315@mudshark.cambridge.arm.com>
 <alpine.LSU.2.00.1207091622470.2261@eggly.anvils>
 <20120710094513.GB9108@mudshark.cambridge.arm.com>
 <20120710104234.GI9108@mudshark.cambridge.arm.com>
 <20120711174802.GG13498@mudshark.cambridge.arm.com>
 <20120712111659.GF21013@tiehlicka.suse.cz>
 <20120712112645.GG2816@mudshark.cambridge.arm.com>
 <20120712115708.GG21013@tiehlicka.suse.cz>
 <20120807160337.GC16877@mudshark.cambridge.arm.com>
 <20120808162607.GA7885@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808162607.GA7885@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 05:26:07PM +0100, Michal Hocko wrote:
> I guess the cleanest way is to hook into dequeue_huge_page_node and add
> something like arch_clear_hugepage_flags.

I hooked into enqueue_huge_page instead, but how about something like this?:

Will

--- >8

>From 92f785a58bbc378c194800a2b12360528bdf4c6f Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Mon, 13 Aug 2012 18:08:13 +0100
Subject: [PATCH] mm: hugetlb: add arch hook for clearing page flags before entering pool

The core page allocator ensures that page flags are zeroed when freeing
pages via free_pages_check. A number of architectures (ARM, PPC, MIPS)
rely on this property to treat new pages as dirty with respect to the
data cache and perform the appropriate flushing before mapping the pages
into userspace.

This can lead to cache synchronisation problems when using hugepages,
since the allocator keeps its own pool of pages above the usual page
allocator and does not reset the page flags when freeing a page into
the pool.

This patch adds a new architecture hook, arch_clear_hugepage_flags, so
that architectures which rely on the page flags being in a particular
state for fresh allocations can adjust the flags accordingly when a
page is freed into the pool.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/ia64/include/asm/hugetlb.h    |    6 ++++++
 arch/mips/include/asm/hugetlb.h    |    4 ++++
 arch/powerpc/include/asm/hugetlb.h |    6 ++++++
 arch/s390/include/asm/hugetlb.h    |    1 +
 arch/sh/include/asm/hugetlb.h      |    6 ++++++
 arch/sparc/include/asm/hugetlb.h   |    4 ++++
 arch/tile/include/asm/hugetlb.h    |    4 ++++
 arch/x86/include/asm/hugetlb.h     |    4 ++++
 mm/hugetlb.c                       |    1 +
 9 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/hugetlb.h b/arch/ia64/include/asm/hugetlb.h
index da55c63..2adaa60 100644
--- a/arch/ia64/include/asm/hugetlb.h
+++ b/arch/ia64/include/asm/hugetlb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_IA64_HUGETLB_H
 #define _ASM_IA64_HUGETLB_H
 
+#include <asm/cacheflush.h>
 #include <asm/page.h>
 
 
@@ -77,4 +78,9 @@ static inline void arch_release_hugepage(struct page *page)
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+	flush_dcache_page(page);
+}
+
 #endif /* _ASM_IA64_HUGETLB_H */
diff --git a/arch/mips/include/asm/hugetlb.h b/arch/mips/include/asm/hugetlb.h
index 58d3688..bd94946 100644
--- a/arch/mips/include/asm/hugetlb.h
+++ b/arch/mips/include/asm/hugetlb.h
@@ -112,4 +112,8 @@ static inline void arch_release_hugepage(struct page *page)
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #endif /* __ASM_HUGETLB_H */
diff --git a/arch/powerpc/include/asm/hugetlb.h b/arch/powerpc/include/asm/hugetlb.h
index dfdb95b..52696e6 100644
--- a/arch/powerpc/include/asm/hugetlb.h
+++ b/arch/powerpc/include/asm/hugetlb.h
@@ -2,6 +2,7 @@
 #define _ASM_POWERPC_HUGETLB_H
 
 #ifdef CONFIG_HUGETLB_PAGE
+#include <asm/cacheflush.h>
 #include <asm/page.h>
 
 extern struct kmem_cache *hugepte_cache;
@@ -151,6 +152,11 @@ static inline void arch_release_hugepage(struct page *page)
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+	flush_dcache_page(page);
+}
+
 #else /* ! CONFIG_HUGETLB_PAGE */
 static inline void flush_hugetlb_page(struct vm_area_struct *vma,
 				      unsigned long vmaddr)
diff --git a/arch/s390/include/asm/hugetlb.h b/arch/s390/include/asm/hugetlb.h
index 799ed0f..faa7655 100644
--- a/arch/s390/include/asm/hugetlb.h
+++ b/arch/s390/include/asm/hugetlb.h
@@ -33,6 +33,7 @@ static inline int prepare_hugepage_range(struct file *file,
 }
 
 #define hugetlb_prefault_arch_hook(mm)		do { } while (0)
+#define arch_clear_hugepage_flags(page)		do { } while (0)
 
 int arch_prepare_hugepage(struct page *page);
 void arch_release_hugepage(struct page *page);
diff --git a/arch/sh/include/asm/hugetlb.h b/arch/sh/include/asm/hugetlb.h
index 967068f..b3808c7 100644
--- a/arch/sh/include/asm/hugetlb.h
+++ b/arch/sh/include/asm/hugetlb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_SH_HUGETLB_H
 #define _ASM_SH_HUGETLB_H
 
+#include <asm/cacheflush.h>
 #include <asm/page.h>
 
 
@@ -89,4 +90,9 @@ static inline void arch_release_hugepage(struct page *page)
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+	clear_bit(PG_dcache_clean, &page->flags);
+}
+
 #endif /* _ASM_SH_HUGETLB_H */
diff --git a/arch/sparc/include/asm/hugetlb.h b/arch/sparc/include/asm/hugetlb.h
index 1770610..e7927c9 100644
--- a/arch/sparc/include/asm/hugetlb.h
+++ b/arch/sparc/include/asm/hugetlb.h
@@ -82,4 +82,8 @@ static inline void arch_release_hugepage(struct page *page)
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #endif /* _ASM_SPARC64_HUGETLB_H */
diff --git a/arch/tile/include/asm/hugetlb.h b/arch/tile/include/asm/hugetlb.h
index b204238..0f885af 100644
--- a/arch/tile/include/asm/hugetlb.h
+++ b/arch/tile/include/asm/hugetlb.h
@@ -106,6 +106,10 @@ static inline void arch_release_hugepage(struct page *page)
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #ifdef CONFIG_HUGETLB_SUPER_PAGES
 static inline pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
 				       struct page *page, int writable)
diff --git a/arch/x86/include/asm/hugetlb.h b/arch/x86/include/asm/hugetlb.h
index 439a9ac..bdd35db 100644
--- a/arch/x86/include/asm/hugetlb.h
+++ b/arch/x86/include/asm/hugetlb.h
@@ -90,4 +90,8 @@ static inline void arch_release_hugepage(struct page *page)
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #endif /* _ASM_X86_HUGETLB_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bc72712..78fafd5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -509,6 +509,7 @@ void copy_huge_page(struct page *dst, struct page *src)
 static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
+	arch_clear_hugepage_flags(page);
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
-- 
1.7.4.1

