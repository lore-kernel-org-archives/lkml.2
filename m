Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1CUTCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:02:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52157 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1CUTCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w0FU3zLMzMlIdihiBnxW3Tr2WRCVpZcBGx6iaLsj9X7CgISdciDmrfT57PCOfKP4bX
         ddBrYeRx+iJ6iPGChp4VP3oqRPJnFSnM69c91ryz6WyFZVZgmHA6NAWjLUPPOcZ4sOsA
         zha04S4L50Sle29SyrbF7OC/7SAQDFucdbINE=
Date: Mon, 21 Mar 2011 19:02:39 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: heiko.carstens@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 09/22] mm, s390: add gfp flags variant of pud,
 pte, and pte allocations
Message-ID: <20110321190239.GA6541@prasad-kvm>
References: <20110318194341.GB4746@prasad-kvm>
 <20110318194600.GC4746@prasad-kvm>
 <20110318194740.GD4746@prasad-kvm>
 <20110318194929.GE4746@prasad-kvm>
 <20110318195035.GF4746@prasad-kvm>
 <20110318195141.GG4746@prasad-kvm>
 <20110318195307.GH4746@prasad-kvm>
 <20110318195507.GI4746@prasad-kvm>
 <20110318195643.GJ4746@prasad-kvm>
 <20110321093412.2776a69f@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321093412.2776a69f@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 09:34:12AM +0100, Martin Schwidefsky wrote:
> On Fri, 18 Mar 2011 19:56:44 +0000
> Prasad Joshi <prasadjoshi124@gmail.com> wrote:
> 
> > - Added function __crst_table_alloc() which is similar to crst_table_alloc()
> >   but accepts an extra argument gfp_t. The function uses given allocation
> >   flag to allocate pages.
> > 
> > - Added a function __page_table_alloc() to allocate page table entries. This
> >   function is allows caller to specify the page allocation flag. The
> >   allocation flag is then passed to alloc_page(). The rest of the function is
> >   copy of the original page_table_alloc().
> 
> The approach of this patch series seems straightforward, the only nitpick I
> have is the fact that two new functions __crst_table_alloc/__page_table_alloc
> are introduced. There aren't many call sites for the two original functions,
> namely 4 for crst_table_alloc and 3 for page_table_alloc. Why not add the
> gfp flag GFP_KERNEL to these call sites? Then the two additional functions
> would not be needed.

Thanks a lot Martin for your reply. Here is a new patch, which the changes
you suggested.

Generic changes
- Changed crst_table_alloc() to accept a new parameter gfp_t, allocate pages
  using the passed allocation flag.

- crst_table_upgrade() calls crst_table_alloc() with GFP_KERNEL.

- page_table_alloc() is also changned to accept a parameter gfp_t and allocate
  page using the passed allocation flag.

- vmem_pte_alloc() calls page_table_alloc() with GFP_KERNEL | __GFP_REPEAT

changes for 32 (31) bit architecture (s390)
- Added macros __pud_alloc_one, __pmd_alloc_one which are similar to
  pud_alloc_one and pmd_alloc_one respectively, but has an extra argument
  for gfp_t.

changes for 64 bit architecture (s390x)
- Added __pud_alloc_one() allow caller to pass the memory allocation flag.
  The function passes the allocation flag to crst_table_alloc().

- The function pud_alloc_one() is modified to call __pud_alloc_one() and
  pass GFP_KERNEL allocation flag.

- The similar changes are performed for pmd allocations

- pgd_populate_kernel() calls crst_table_alloc() with GFP_KERNEL

- Added marco __pte_alloc_one_kernel() to accept additional argument gfp_t.
  This argument is then passed to page_table_alloc() to allocate the page
  table entry.

- Modified pte_alloc_one_kernel() to call __pte_alloc_one_kernel() passing
  GFP_KERNEL|__GFP_REPEAT allocation flags.

- Modified pte_alloc_one() to call page_table_alloc() with allocation flag
  GFP_KERNEL | __GFP_REPEAT

- The changes for both architectures help in fixing Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/s390/include/asm/pgalloc.h |   37 ++++++++++++++++++++++++++++---------
 arch/s390/mm/pgtable.c          |   13 +++++++------
 arch/s390/mm/vmem.c             |    2 +-
 3 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
index 082eb4e..8068669 100644
--- a/arch/s390/include/asm/pgalloc.h
+++ b/arch/s390/include/asm/pgalloc.h
@@ -19,11 +19,11 @@
 
 #define check_pgt_cache()	do {} while (0)
 
-unsigned long *crst_table_alloc(struct mm_struct *, int);
+unsigned long *crst_table_alloc(struct mm_struct *, int, gfp_t);
 void crst_table_free(struct mm_struct *, unsigned long *);
 void crst_table_free_rcu(struct mm_struct *, unsigned long *);
 
-unsigned long *page_table_alloc(struct mm_struct *);
+unsigned long *page_table_alloc(struct mm_struct *, gfp_t);
 void page_table_free(struct mm_struct *, unsigned long *);
 void page_table_free_rcu(struct mm_struct *, unsigned long *);
 void disable_noexec(struct mm_struct *, struct task_struct *);
@@ -62,9 +62,11 @@ static inline unsigned long pgd_entry_type(struct mm_struct *mm)
 	return _SEGMENT_ENTRY_EMPTY;
 }
 
+#define __pud_alloc_one(mm,address,mask)		({ BUG(); ((pud_t *)2); })
 #define pud_alloc_one(mm,address)		({ BUG(); ((pud_t *)2); })
 #define pud_free(mm, x)				do { } while (0)
 
+#define __pmd_alloc_one(mm,address,mask)		({ BUG(); ((pmd_t *)2); })
 #define pmd_alloc_one(mm,address)		({ BUG(); ((pmd_t *)2); })
 #define pmd_free(mm, x)				do { } while (0)
 
@@ -88,22 +90,34 @@ static inline unsigned long pgd_entry_type(struct mm_struct *mm)
 int crst_table_upgrade(struct mm_struct *, unsigned long limit);
 void crst_table_downgrade(struct mm_struct *, unsigned long limit);
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
+static inline pud_t *__pud_alloc_one(struct mm_struct *mm,
+		unsigned long address, gfp_t gfp_mask)
 {
-	unsigned long *table = crst_table_alloc(mm, mm->context.noexec);
+	unsigned long *table = crst_table_alloc(mm, mm->context.noexec, gfp_mask);
 	if (table)
 		crst_table_init(table, _REGION3_ENTRY_EMPTY);
 	return (pud_t *) table;
 }
+
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	return __pud_alloc_one(mm, address, GFP_KERNEL);
+}
 #define pud_free(mm, pud) crst_table_free(mm, (unsigned long *) pud)
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long vmaddr)
+static inline pmd_t *__pmd_alloc_one(struct mm_struct *mm,
+		unsigned long vmaddr, gfp_t gfp_mask)
 {
-	unsigned long *table = crst_table_alloc(mm, mm->context.noexec);
+	unsigned long *table = crst_table_alloc(mm, mm->context.noexec, gfp_mask);
 	if (table)
 		crst_table_init(table, _SEGMENT_ENTRY_EMPTY);
 	return (pmd_t *) table;
 }
+
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long vmaddr)
+{
+	return __pmd_alloc_one(mm, vmaddr, GFP_KERNEL);
+}
 #define pmd_free(mm, pmd) crst_table_free(mm, (unsigned long *) pmd)
 
 static inline void pgd_populate_kernel(struct mm_struct *mm,
@@ -146,7 +160,7 @@ static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 	INIT_LIST_HEAD(&mm->context.crst_list);
 	INIT_LIST_HEAD(&mm->context.pgtable_list);
 	return (pgd_t *)
-		crst_table_alloc(mm, user_mode == SECONDARY_SPACE_MODE);
+		crst_table_alloc(mm, user_mode == SECONDARY_SPACE_MODE, GFP_KERNEL);
 }
 #define pgd_free(mm, pgd) crst_table_free(mm, (unsigned long *) pgd)
 
@@ -172,8 +186,13 @@ static inline void pmd_populate(struct mm_struct *mm,
 /*
  * page table entry allocation/free routines.
  */
-#define pte_alloc_one_kernel(mm, vmaddr) ((pte_t *) page_table_alloc(mm))
-#define pte_alloc_one(mm, vmaddr) ((pte_t *) page_table_alloc(mm))
+#define __pte_alloc_one_kernel(mm, vmaddr, mask) \
+	((pte_t *) page_table_alloc((mm), (mask)))
+#define pte_alloc_one_kernel(mm, vmaddr) \
+	((pte_t *) __pte_alloc_one_kernel((mm), (vmaddr), GFP_KERNEL|__GFP_REPEAT)
+
+#define pte_alloc_one(mm, vmaddr) \
+	 ((pte_t *) page_table_alloc((mm), GFP_KERNEL | __GFP_REPEAT))
 
 #define pte_free_kernel(mm, pte) page_table_free(mm, (unsigned long *) pte)
 #define pte_free(mm, pte) page_table_free(mm, (unsigned long *) pte)
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index e1850c2..9bf1632 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -125,15 +125,16 @@ static int __init parse_vmalloc(char *arg)
 }
 early_param("vmalloc", parse_vmalloc);
 
-unsigned long *crst_table_alloc(struct mm_struct *mm, int noexec)
+unsigned long *crst_table_alloc(struct mm_struct *mm, int noexec,
+		gfp_t gfp_mask)
 {
-	struct page *page = alloc_pages(GFP_KERNEL, ALLOC_ORDER);
+	struct page *page = alloc_pages(gfp_mask, ALLOC_ORDER);
 
 	if (!page)
 		return NULL;
 	page->index = 0;
 	if (noexec) {
-		struct page *shadow = alloc_pages(GFP_KERNEL, ALLOC_ORDER);
+		struct page *shadow = alloc_pages(gfp_mask, ALLOC_ORDER);
 		if (!shadow) {
 			__free_pages(page, ALLOC_ORDER);
 			return NULL;
@@ -197,7 +198,7 @@ int crst_table_upgrade(struct mm_struct *mm, unsigned long limit)
 
 	BUG_ON(limit > (1UL << 53));
 repeat:
-	table = crst_table_alloc(mm, mm->context.noexec);
+	table = crst_table_alloc(mm, mm->context.noexec, GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 	spin_lock_bh(&mm->page_table_lock);
@@ -267,7 +268,7 @@ void crst_table_downgrade(struct mm_struct *mm, unsigned long limit)
 /*
  * page table entry allocation/free routines.
  */
-unsigned long *page_table_alloc(struct mm_struct *mm)
+unsigned long *page_table_alloc(struct mm_struct *mm, gfp_t gfp_mask)
 {
 	struct page *page;
 	unsigned long *table;
@@ -284,7 +285,7 @@ unsigned long *page_table_alloc(struct mm_struct *mm)
 	}
 	if (!page) {
 		spin_unlock_bh(&mm->context.list_lock);
-		page = alloc_page(GFP_KERNEL|__GFP_REPEAT);
+		page = alloc_page(gfp_mask);
 		if (!page)
 			return NULL;
 		pgtable_page_ctor(page);
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 34c43f2..f7e8716 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -66,7 +66,7 @@ static pte_t __ref *vmem_pte_alloc(void)
 	pte_t *pte;
 
 	if (slab_is_available())
-		pte = (pte_t *) page_table_alloc(&init_mm);
+		pte = (pte_t *) page_table_alloc(&init_mm, GFP_KERNEL | __GFP_REPEAT);
 	else
 		pte = alloc_bootmem(PTRS_PER_PTE * sizeof(pte_t));
 	if (!pte)
-- 
1.7.0.4


> 
> -- 
> blue skies,
>    Martin.
> 
> "Reality continues to ruin my life." - Calvin.
> 
