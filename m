Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0EZQab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:30:31 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:33792 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0EZQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:30:29 -0400
Date: Wed, 26 May 2010 18:31:28 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Suzuki Poulose <suzuki@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: provide init_mm mm_context initializer
Message-ID: <20100526163128.GA2160@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Provide an INIT_MM_CONTEXT intializer macro which can be used to
statically initialize mm_struct:mm_context of init_mm.  This way we
can get rid of code which will do the initialization at run time (on
s390).
In addition the current code can be found at a place where it is not
expected.  So let's have a common initializer which architectures
can use if needed.

This is based on a patch from Suzuki Poulose.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Suzuki Poulose <suzuki@in.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/s390/include/asm/mmu.h |    5 +++++
 arch/s390/mm/vmem.c         |    4 ----
 mm/init-mm.c                |    6 ++++++
 3 files changed, 11 insertions(+), 4 deletions(-)

--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -13,4 +13,9 @@ typedef struct {
 	int alloc_pgste; /* cloned contexts will have extended page tables */
 } mm_context_t;
 
+#define INIT_MM_CONTEXT(name)						      \
+	.context.list_lock    = __SPIN_LOCK_UNLOCKED(name.context.list_lock), \
+	.context.crst_list    = LIST_HEAD_INIT(name.context.crst_list),	      \
+	.context.pgtable_list = LIST_HEAD_INIT(name.context.pgtable_list),
+
 #endif
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -332,10 +332,6 @@ void __init vmem_map_init(void)
 	unsigned long start, end;
 	int i;
 
-	spin_lock_init(&init_mm.context.list_lock);
-	INIT_LIST_HEAD(&init_mm.context.crst_list);
-	INIT_LIST_HEAD(&init_mm.context.pgtable_list);
-	init_mm.context.noexec = 0;
 	ro_start = ((unsigned long)&_stext) & PAGE_MASK;
 	ro_end = PFN_ALIGN((unsigned long)&_eshared);
 	for (i = 0; i < MEMORY_CHUNKS && memory_chunk[i].size > 0; i++) {
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -7,6 +7,11 @@
 
 #include <asm/atomic.h>
 #include <asm/pgtable.h>
+#include <asm/mmu.h>
+
+#ifndef INIT_MM_CONTEXT
+#define INIT_MM_CONTEXT(name)
+#endif
 
 struct mm_struct init_mm = {
 	.mm_rb		= RB_ROOT,
@@ -17,4 +22,5 @@ struct mm_struct init_mm = {
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
 	.cpu_vm_mask	= CPU_MASK_ALL,
+	INIT_MM_CONTEXT(init_mm)
 };
