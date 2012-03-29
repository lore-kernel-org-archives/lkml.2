Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935022Ab2C3W5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:57:20 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934879Ab2C3VFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:50 -0400
Message-Id: <201203302105.q2UL55ew006289@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:34:52 -0400
Subject: [PATCH] arch/tile: don't wait for migrating PTEs in an NMI handler
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:05.0241 (UTC) FILETIME=[C7CBDC90:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing so raises the possibility of self-deadlock if we are waiting
for a backtrace for an oprofile or perf interrupt while we are
in the middle of migrating our own stack page.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/fault.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 5f1fdeb..bcba159 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -204,9 +204,14 @@ static pgd_t *get_current_pgd(void)
  * interrupt or a critical region, and must do as little as possible.
  * Similarly, we can't use atomic ops here, since we may be handling a
  * fault caused by an atomic op access.
+ *
+ * If we find a migrating PTE while we're in an NMI context, and we're
+ * at a PC that has a registered exception handler, we don't wait,
+ * since this thread may (e.g.) have been interrupted while migrating
+ * its own stack, which would then cause us to self-deadlock.
  */
 static int handle_migrating_pte(pgd_t *pgd, int fault_num,
-				unsigned long address,
+				unsigned long address, unsigned long pc,
 				int is_kernel_mode, int write)
 {
 	pud_t *pud;
@@ -228,6 +233,8 @@ static int handle_migrating_pte(pgd_t *pgd, int fault_num,
 		pte_offset_kernel(pmd, address);
 	pteval = *pte;
 	if (pte_migrating(pteval)) {
+		if (in_nmi() && search_exception_tables(pc))
+			return 0;
 		wait_for_migration(pte);
 		return 1;
 	}
@@ -301,7 +308,7 @@ static int handle_page_fault(struct pt_regs *regs,
 	 * rather than trying to patch up the existing PTE.
 	 */
 	pgd = get_current_pgd();
-	if (handle_migrating_pte(pgd, fault_num, address,
+	if (handle_migrating_pte(pgd, fault_num, address, regs->pc,
 				 is_kernel_mode, write))
 		return 1;
 
@@ -666,7 +673,7 @@ struct intvec_state do_page_fault_ics(struct pt_regs *regs, int fault_num,
 	 */
 	if (fault_num == INT_DTLB_ACCESS)
 		write = 1;
-	if (handle_migrating_pte(pgd, fault_num, address, 1, write))
+	if (handle_migrating_pte(pgd, fault_num, address, pc, 1, write))
 		return state;
 
 	/* Return zero so that we continue on with normal fault handling. */
-- 
1.6.5.2

