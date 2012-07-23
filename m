Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2GWRer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:34:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:37765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2GWRep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:34:45 -0400
Message-ID: <1343064870.26034.23.camel@twins>
Subject: [RFC] page-table walkers vs memory order
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        paulmck <paulmck@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Mon, 23 Jul 2012 19:34:30 +0200
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While staring at mm/huge_memory.c I found a very under-commented
smp_wmb() in __split_huge_page_map(). It turns out that its copied from
__{pte,pmd,pud}_alloc() but forgot the useful comment (or a reference
thereto).

Now, afaict we're not good, as per that comment. Paul has since
convinced some of us that compiler writers are pure evil and out to get
us.

Therefore we should do what rcu_dereference() does and use
ACCESS_ONCE()/barrier() followed smp_read_barrier_depends() every time
we dereference a page-table pointer.


In particular it looks like things like
mm/memcontrol.c:mem_cgroup_count_precharge(), which use
walk_page_range() under down_read(&mm->mmap_sem) and can thus be
concurrent with __{pte,pmd,pud}_alloc() from faults (and possibly
itself) are quite broken on Alpha and subtly broken for those of us with
'creative' compilers.

Should I go do a more extensive audit of page-table walkers or are we
happy with the status quo?

---
 arch/x86/mm/gup.c |    6 +++---
 mm/pagewalk.c     |   24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dd74e46..4958fb1 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -150,7 +150,7 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 
 	pmdp = pmd_offset(&pud, addr);
 	do {
-		pmd_t pmd = *pmdp;
+		pmd_t pmd = ACCESS_ONCE(*pmdp);
 
 		next = pmd_addr_end(addr, end);
 		/*
@@ -220,7 +220,7 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 
 	pudp = pud_offset(&pgd, addr);
 	do {
-		pud_t pud = *pudp;
+		pud_t pud = ACCESS_ONCE(*pudp);
 
 		next = pud_addr_end(addr, end);
 		if (pud_none(pud))
@@ -280,7 +280,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
-		pgd_t pgd = *pgdp;
+		pgd_t pgd = ACCESS_ONCE(*pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 6c118d0..2ba2a74 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -10,6 +10,14 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	int err = 0;
 
 	pte = pte_offset_map(pmd, addr);
+	/*
+	 * Pairs with the smp_wmb() in __{pte,pmd,pud}_alloc() and
+	 * __split_huge_page_map(). Ideally we'd use ACCESS_ONCE() on the
+	 * actual dereference of p[gum]d, but that's hidden deep within the
+	 * bowels of {pte,pmd,pud}_offset.
+	 */
+	barrier();
+	smp_read_barrier_depends();
 	for (;;) {
 		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, walk);
 		if (err)
@@ -32,6 +40,14 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	int err = 0;
 
 	pmd = pmd_offset(pud, addr);
+	/*
+	 * Pairs with the smp_wmb() in __{pte,pmd,pud}_alloc() and
+	 * __split_huge_page_map(). Ideally we'd use ACCESS_ONCE() on the
+	 * actual dereference of p[gum]d, but that's hidden deep within the
+	 * bowels of {pte,pmd,pud}_offset.
+	 */
+	barrier();
+	smp_read_barrier_depends();
 	do {
 again:
 		next = pmd_addr_end(addr, end);
@@ -77,6 +93,14 @@ static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 	int err = 0;
 
 	pud = pud_offset(pgd, addr);
+	/*
+	 * Pairs with the smp_wmb() in __{pte,pmd,pud}_alloc() and
+	 * __split_huge_page_map(). Ideally we'd use ACCESS_ONCE() on the
+	 * actual dereference of p[gum]d, but that's hidden deep within the
+	 * bowels of {pte,pmd,pud}_offset.
+	 */
+	barrier();
+	smp_read_barrier_depends();
 	do {
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud)) {

