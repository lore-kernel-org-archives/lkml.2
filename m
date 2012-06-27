Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2F0DZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 23:25:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2F0DZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 23:25:00 -0400
Message-ID: <1340767488.17253.4.camel@cr0>
Subject: Re: [PATCH 04/12] frv: remove km_type definitions
From: Cong Wang <amwang@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Date: Wed, 27 Jun 2012 11:24:48 +0800
In-Reply-To: <CAMuHMdXkMBSkkXosJkd47n+RznpMBhzBGyLshA+gwdmZ=4dm6A@mail.gmail.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
	 <1340445863-16111-5-git-send-email-amwang@redhat.com>
	 <CAMuHMdXkMBSkkXosJkd47n+RznpMBhzBGyLshA+gwdmZ=4dm6A@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-dR+j6v7IeYm2PHCRfx/Y"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dR+j6v7IeYm2PHCRfx/Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2012-06-26 at 22:25 +0200, Geert Uytterhoeven wrote:
> 
> "enum km_type" and "__KM_CACHE" are still used in
> arch/frv/include/asm/highmem.h:

Oops! I missed __KM_* types... Fortunately, the following patch could
probably fix it.

Thanks!

----------------------->

All callers of kmap_atomic_primary() use __KM_CACHE, so it can be
removed safely, and __kmap_atomic_primary() only check if 'type' if
__KM_CACHE or not, so 'type' can be changed to a boolean as well.

Ditto for kunmap_atomic_primary()/__kunmap_atomic_primary().


--=-dR+j6v7IeYm2PHCRfx/Y
Content-Disposition: attachment; filename="frv.diff"
Content-Type: text/x-patch; name="frv.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/arch/frv/include/asm/highmem.h b/arch/frv/include/asm/highmem.h
index 716956a..b3adc93 100644
--- a/arch/frv/include/asm/highmem.h
+++ b/arch/frv/include/asm/highmem.h
@@ -76,15 +76,16 @@ extern struct page *kmap_atomic_to_page(void *ptr);
 
 #ifndef __ASSEMBLY__
 
-#define __kmap_atomic_primary(type, paddr, ampr)						\
+#define __kmap_atomic_primary(cached, paddr, ampr)						\
 ({												\
 	unsigned long damlr, dampr;								\
 												\
 	dampr = paddr | xAMPRx_L | xAMPRx_M | xAMPRx_S | xAMPRx_SS_16Kb | xAMPRx_V;		\
 												\
-	if (type != __KM_CACHE)									\
+	if (!cached)										\
 		asm volatile("movgs %0,dampr"#ampr :: "r"(dampr) : "memory");			\
 	else											\
+		/* cache flush page attachment point */						\
 		asm volatile("movgs %0,iampr"#ampr"\n"						\
 			     "movgs %0,dampr"#ampr"\n"						\
 			     :: "r"(dampr) : "memory"						\
@@ -112,29 +113,20 @@ extern struct page *kmap_atomic_to_page(void *ptr);
 	(void *) damlr;										  \
 })
 
-static inline void *kmap_atomic_primary(struct page *page, enum km_type type)
+static inline void *kmap_atomic_primary(struct page *page)
 {
 	unsigned long paddr;
 
 	pagefault_disable();
 	paddr = page_to_phys(page);
 
-	switch (type) {
-        case 0:		return __kmap_atomic_primary(0, paddr, 2);
-        case 1:		return __kmap_atomic_primary(1, paddr, 3);
-        case 2:		return __kmap_atomic_primary(2, paddr, 4);
-        case 3:		return __kmap_atomic_primary(3, paddr, 5);
-
-	default:
-		BUG();
-		return NULL;
-	}
+        return __kmap_atomic_primary(1, paddr, 2);
 }
 
-#define __kunmap_atomic_primary(type, ampr)				\
+#define __kunmap_atomic_primary(cached, ampr)				\
 do {									\
 	asm volatile("movgs gr0,dampr"#ampr"\n" ::: "memory");		\
-	if (type == __KM_CACHE)						\
+	if (cached)							\
 		asm volatile("movgs gr0,iampr"#ampr"\n" ::: "memory");	\
 } while(0)
 
@@ -143,17 +135,9 @@ do {									\
 	asm volatile("tlbpr %0,gr0,#4,#1" : : "r"(vaddr) : "memory");	\
 } while(0)
 
-static inline void kunmap_atomic_primary(void *kvaddr, enum km_type type)
+static inline void kunmap_atomic_primary(void *kvaddr)
 {
-	switch (type) {
-        case 0:		__kunmap_atomic_primary(0, 2);	break;
-        case 1:		__kunmap_atomic_primary(1, 3);	break;
-        case 2:		__kunmap_atomic_primary(2, 4);	break;
-        case 3:		__kunmap_atomic_primary(3, 5);	break;
-
-	default:
-		BUG();
-	}
+        __kunmap_atomic_primary(1, 2);
 	pagefault_enable();
 }
 
diff --git a/arch/frv/mb93090-mb00/pci-dma.c b/arch/frv/mb93090-mb00/pci-dma.c
index 4f8d8bc..8247897 100644
--- a/arch/frv/mb93090-mb00/pci-dma.c
+++ b/arch/frv/mb93090-mb00/pci-dma.c
@@ -62,14 +62,14 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	dampr2 = __get_DAMPR(2);
 
 	for (i = 0; i < nents; i++) {
-		vaddr = kmap_atomic_primary(sg_page(&sg[i]), __KM_CACHE);
+		vaddr = kmap_atomic_primary(sg_page(&sg[i]));
 
 		frv_dcache_writeback((unsigned long) vaddr,
 				     (unsigned long) vaddr + PAGE_SIZE);
 
 	}
 
-	kunmap_atomic_primary(vaddr, __KM_CACHE);
+	kunmap_atomic_primary(vaddr);
 	if (dampr2) {
 		__set_DAMPR(2, dampr2);
 		__set_IAMPR(2, dampr2);
diff --git a/arch/frv/mm/cache-page.c b/arch/frv/mm/cache-page.c
index b24ade2..8e09dae 100644
--- a/arch/frv/mm/cache-page.c
+++ b/arch/frv/mm/cache-page.c
@@ -26,11 +26,11 @@ void flush_dcache_page(struct page *page)
 
 	dampr2 = __get_DAMPR(2);
 
-	vaddr = kmap_atomic_primary(page, __KM_CACHE);
+	vaddr = kmap_atomic_primary(page);
 
 	frv_dcache_writeback((unsigned long) vaddr, (unsigned long) vaddr + PAGE_SIZE);
 
-	kunmap_atomic_primary(vaddr, __KM_CACHE);
+	kunmap_atomic_primary(vaddr);
 
 	if (dampr2) {
 		__set_DAMPR(2, dampr2);
@@ -54,12 +54,12 @@ void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
 
 	dampr2 = __get_DAMPR(2);
 
-	vaddr = kmap_atomic_primary(page, __KM_CACHE);
+	vaddr = kmap_atomic_primary(page);
 
 	start = (start & ~PAGE_MASK) | (unsigned long) vaddr;
 	frv_cache_wback_inv(start, start + len);
 
-	kunmap_atomic_primary(vaddr, __KM_CACHE);
+	kunmap_atomic_primary(vaddr);
 
 	if (dampr2) {
 		__set_DAMPR(2, dampr2);
diff --git a/arch/frv/mm/highmem.c b/arch/frv/mm/highmem.c
index 31902c9..bed9a9b 100644
--- a/arch/frv/mm/highmem.c
+++ b/arch/frv/mm/highmem.c
@@ -50,11 +50,11 @@ void *kmap_atomic(struct page *page)
 	/*
 	 * The first 4 primary maps are reserved for architecture code
 	 */
-	case 0:		return __kmap_atomic_primary(4, paddr, 6);
-	case 1:		return __kmap_atomic_primary(5, paddr, 7);
-	case 2:		return __kmap_atomic_primary(6, paddr, 8);
-	case 3:		return __kmap_atomic_primary(7, paddr, 9);
-	case 4:		return __kmap_atomic_primary(8, paddr, 10);
+	case 0:		return __kmap_atomic_primary(0, paddr, 6);
+	case 1:		return __kmap_atomic_primary(0, paddr, 7);
+	case 2:		return __kmap_atomic_primary(0, paddr, 8);
+	case 3:		return __kmap_atomic_primary(0, paddr, 9);
+	case 4:		return __kmap_atomic_primary(0, paddr, 10);
 
 	case 5 ... 5 + NR_TLB_LINES - 1:
 		return __kmap_atomic_secondary(type - 5, paddr);
@@ -70,11 +70,11 @@ void __kunmap_atomic(void *kvaddr)
 {
 	int type = kmap_atomic_idx();
 	switch (type) {
-	case 0:		__kunmap_atomic_primary(4, 6);	break;
-	case 1:		__kunmap_atomic_primary(5, 7);	break;
-	case 2:		__kunmap_atomic_primary(6, 8);	break;
-	case 3:		__kunmap_atomic_primary(7, 9);	break;
-	case 4:		__kunmap_atomic_primary(8, 10);	break;
+	case 0:		__kunmap_atomic_primary(0, 6);	break;
+	case 1:		__kunmap_atomic_primary(0, 7);	break;
+	case 2:		__kunmap_atomic_primary(0, 8);	break;
+	case 3:		__kunmap_atomic_primary(0, 9);	break;
+	case 4:		__kunmap_atomic_primary(0, 10);	break;
 
 	case 5 ... 5 + NR_TLB_LINES - 1:
 		__kunmap_atomic_secondary(type - 5, kvaddr);

--=-dR+j6v7IeYm2PHCRfx/Y--

