Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0LOWVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:21:10 -0500
Received: from claw.goop.org ([74.207.240.146]:47885 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab0LOWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/9] mm: remove unused "token" argument from apply_to_page_range callback.
Date: Wed, 15 Dec 2010 14:19:47 -0800
Message-Id: <4ebf6bc10f88c474b94174410142b2cefd432c5c.1292450600.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The argument is basically the struct page of the pte_t * passed into
the callback.  But there's no need to pass that, since it can be fairly
easily derived from the pte_t * itself if needed (and no current users
need to do that anyway).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/grant-table.c |    6 ++----
 arch/x86/xen/mmu.c         |    3 +--
 include/linux/mm.h         |    3 +--
 mm/memory.c                |    2 +-
 mm/vmalloc.c               |    2 +-
 5 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 49ba9b5..5bf892a 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -44,8 +44,7 @@
 
 #include <asm/pgtable.h>
 
-static int map_pte_fn(pte_t *pte, struct page *pmd_page,
-		      unsigned long addr, void *data)
+static int map_pte_fn(pte_t *pte, unsigned long addr, void *data)
 {
 	unsigned long **frames = (unsigned long **)data;
 
@@ -54,8 +53,7 @@ static int map_pte_fn(pte_t *pte, struct page *pmd_page,
 	return 0;
 }
 
-static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
-			unsigned long addr, void *data)
+static int unmap_pte_fn(pte_t *pte, unsigned long addr, void *data)
 {
 
 	set_pte_at(&init_mm, addr, pte, __pte(0));
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 44924e5..2b2b98a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2656,8 +2656,7 @@ struct remap_data {
 	struct mmu_update *mmu_update;
 };
 
-static int remap_area_mfn_pte_fn(pte_t *ptep, pgtable_t token,
-				 unsigned long addr, void *data)
+static int remap_area_mfn_pte_fn(pte_t *ptep, unsigned long addr, void *data)
 {
 	struct remap_data *rmd = data;
 	pte_t pte = pte_mkspecial(pfn_pte(rmd->mfn++, rmd->prot));
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 721f451..c51d1fc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1416,8 +1416,7 @@ struct page *follow_page(struct vm_area_struct *, unsigned long address,
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 
-typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
-			void *data);
+typedef int (*pte_fn_t)(pte_t *pte, unsigned long addr, void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
 
diff --git a/mm/memory.c b/mm/memory.c
index 02e48aa..999f953 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1944,7 +1944,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	token = pmd_pgtable(*pmd);
 
 	do {
-		err = fn(pte++, token, addr, data);
+		err = fn(pte++, addr, data);
 		if (err)
 			break;
 	} while (addr += PAGE_SIZE, addr != end);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index eb5cc7d..e95980a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2059,7 +2059,7 @@ void  __attribute__((weak)) vmalloc_sync_all(void)
 }
 
 
-static int f(pte_t *pte, pgtable_t table, unsigned long addr, void *data)
+static int f(pte_t *pte, unsigned long addr, void *data)
 {
 	/* apply_to_page_range() does all the hard work. */
 	return 0;
-- 
1.7.3.3

