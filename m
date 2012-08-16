Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2HPNMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:12:49 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:12138 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HPNMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:12:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336348800"; 
   d="scan'208";a="14040419"
From: Attilio Rao <attilio.rao@citrix.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v2 1/2] XEN/X86: Improve semantic support for pagetable_reserve PVOPS
Date: Thu, 16 Aug 2012 13:59:35 +0100
Message-ID: <1345121976-11169-2-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Allow xen_mapping_pagetable_reserve() to handle a start different from
  pgt_buf_start, but still bigger than it.
- Add checks to xen_mapping_pagetable_reserve() and native_pagetable_reserve()
  for verifying start and end are contained in the range
  [pgt_buf_start, pgt_buf_top].
- In xen_mapping_pagetable_reserve(), change printk into pr_debug.
- In xen_mapping_pagetable_reserve(), print out diagnostic only if there is
  an actual need to do that (or, in other words, if there are actually some
  pages going to switch from RO to RW).

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/mm/init.c |    4 ++++
 arch/x86/xen/mmu.c |   22 ++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e0e6990..c5849b6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -92,6 +92,10 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 
 void __init native_pagetable_reserve(u64 start, u64 end)
 {
+	if (start < PFN_PHYS(pgt_buf_start) || end > PFN_PHYS(pgt_buf_top))
+		panic("Invalid address range: [%llu - %llu] should be a subset of [%llu - %llu]\n"
+			start, end, PFN_PHYS(pgt_buf_start),
+			PFN_PHYS(pgt_buf_top));
 	memblock_reserve(start, end - start);
 }
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b65a761..66d73a2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1180,12 +1180,30 @@ static void __init xen_pagetable_setup_start(pgd_t *base)
 
 static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
 {
+	u64 begin;
+
+	begin = PFN_PHYS(pgt_buf_start);
+
+	if (start < begin || end > PFN_PHYS(pgt_buf_top))
+		panic("Invalid address range: [%llu - %llu] should be a subset of [%llu - %llu]\n"
+			start, end, begin, PFN_PHYS(pgt_buf_top));
+
+	/* set RW the initial range */
+	if  (start != begin)
+		pr_debug("xen: setting RW the range %llx - %llx\n",
+			begin, start);
+	while (begin < start) {
+		make_lowmem_page_readwrite(__va(begin));
+		begin += PAGE_SIZE;
+	}
+
 	/* reserve the range used */
 	native_pagetable_reserve(start, end);
 
 	/* set as RW the rest */
-	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
-			PFN_PHYS(pgt_buf_top));
+	if (end != PFN_PHYS(pgt_buf_top))
+		pr_debug("xen: setting RW the range %llx - %llx\n",
+			end, PFN_PHYS(pgt_buf_top));
 	while (end < PFN_PHYS(pgt_buf_top)) {
 		make_lowmem_page_readwrite(__va(end));
 		end += PAGE_SIZE;
-- 
1.7.2.5

