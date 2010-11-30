Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0K3TIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:08:53 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:36343 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756141Ab0K3TIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:51 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: YlCfrgQVM1noxEEMnK81BK7QGL7oBeyBuqzT8mRO1TcdRK5
 ZVPvfBqa_F08ailROpMLJyPQ8Hy37Ek.HM8i4GQjr3V7C7zC0UtGWTYoRXG3
 eamS0OYNBprRnWzA1LGbFTVvIiYEm1_85t.l4dAKQ6tpTXA25LH9QYhFGzyd
 jwIt7uWZWh7pV6FlsztqZJnoL1sBc2uKByn.SmW09WlLurSynGdihqqnKM.1
 .WSRkqb_9sYi8KxZSwiVMP923j6EsRsPYTrzdf5C3g.9IO1tAwd5ZdiUKcn3
 oL1x_j_IaC.6Mk_GQI2XM
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190849.422541374@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:21 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 14/18] lguest: Use this_cpu_ops
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_lguest
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_ops in a couple of places in lguest.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/lguest/boot.c       |    2 +-
 drivers/lguest/page_tables.c |    2 +-
 drivers/lguest/x86/core.c    |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c	2010-11-30 12:22:34.000000000 -0600
+++ linux-2.6/arch/x86/lguest/boot.c	2010-11-30 12:24:08.000000000 -0600
@@ -821,7 +821,7 @@ static void __init lguest_init_IRQ(void)
 
 	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
 		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
-		__get_cpu_var(vector_irq)[i] = i - FIRST_EXTERNAL_VECTOR;
+		__this_cpu_write(vector_irq[i]) = i - FIRST_EXTERNAL_VECTOR;
 		if (i != SYSCALL_VECTOR)
 			set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
Index: linux-2.6/drivers/lguest/page_tables.c
===================================================================
--- linux-2.6.orig/drivers/lguest/page_tables.c	2010-11-30 12:22:34.000000000 -0600
+++ linux-2.6/drivers/lguest/page_tables.c	2010-11-30 12:24:08.000000000 -0600
@@ -1137,7 +1137,7 @@ void free_guest_pagetable(struct lguest
  */
 void map_switcher_in_guest(struct lg_cpu *cpu, struct lguest_pages *pages)
 {
-	pte_t *switcher_pte_page = __get_cpu_var(switcher_pte_pages);
+	pte_t *switcher_pte_page = __this_cpu_read(switcher_pte_pages);
 	pte_t regs_pte;
 
 #ifdef CONFIG_X86_PAE
Index: linux-2.6/drivers/lguest/x86/core.c
===================================================================
--- linux-2.6.orig/drivers/lguest/x86/core.c	2010-11-30 12:22:34.000000000 -0600
+++ linux-2.6/drivers/lguest/x86/core.c	2010-11-30 12:24:08.000000000 -0600
@@ -90,8 +90,8 @@ static void copy_in_guest_info(struct lg
 	 * meanwhile).  If that's not the case, we pretend everything in the
 	 * Guest has changed.
 	 */
-	if (__get_cpu_var(lg_last_cpu) != cpu || cpu->last_pages != pages) {
-		__get_cpu_var(lg_last_cpu) = cpu;
+	if (__this_cpu_read(lg_last_cpu) != cpu || cpu->last_pages != pages) {
+		__this_cpu_read(lg_last_cpu) = cpu;
 		cpu->last_pages = pages;
 		cpu->changed = CHANGED_ALL;
 	}

