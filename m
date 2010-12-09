Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0LICBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:01:55 -0500
Received: from ozlabs.org ([203.10.76.45]:47784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab0LICBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:01:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: x86@kernel.org
Subject: [PATCH 2/2] lguest: restore boot speed
Date: Thu, 9 Dec 2010 12:31:48 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>
References: <201012091230.53907.rusty@rustcorp.com.au>
In-Reply-To: <201012091230.53907.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012091231.48182.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lguest is dumb and drops *all* the pagetables for set_pte (which is
only used for kernel mapping manipulation, so it's OK without highmem).

But it's used a lot in boot, too.  As a guest optimization, we
suppressed this flushing until the first page switch.  Now we have
initial_page_table, that happens much earlier, so extend the heuristic
to wait until we switch to something other than the swapper_pg_dir or
initial_page_table.

As measured on my laptop under kvm, this dropped the time-to-mount-root
from 48 seconds to 4.3 seconds.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/lguest/boot.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -531,7 +531,10 @@ static void lguest_write_cr3(unsigned lo
 {
 	lguest_data.pgdir = cr3;
 	lazy_hcall1(LHCALL_NEW_PGTABLE, cr3);
-	cr3_changed = true;
+
+	/* These two page tables are simple, linear, and used during boot */
+	if (cr3 != __pa(swapper_pg_dir) && cr3 != __pa(initial_page_table))
+		cr3_changed = true;
 }
 
 static unsigned long lguest_read_cr3(void)
@@ -703,9 +706,9 @@ static void lguest_set_pmd(pmd_t *pmdp, 
  * to forget all of them.  Fortunately, this is very rare.
  *
  * ... except in early boot when the kernel sets up the initial pagetables,
- * which makes booting astonishingly slow: 1.83 seconds!  So we don't even tell
- * the Host anything changed until we've done the first page table switch,
- * which brings boot back to 0.25 seconds.
+ * which makes booting astonishingly slow: 48 seconds!  So we don't even tell
+ * the Host anything changed until we've done the first real page table switch,
+ * which brings boot back to 4.3 seconds.
  */
 static void lguest_set_pte(pte_t *ptep, pte_t pteval)
 {
