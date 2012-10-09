Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2JIElJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:41:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45545 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2JIElB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:41:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 09/10] x86, mm: Hide pgt_buf_* into internal to xen
Date: Mon,  8 Oct 2012 21:39:17 -0700
Message-Id: <1349757558-10856-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only should be used by init.c and init_64.c and init_32.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/include/asm/init.h |    2 ++
 arch/x86/mm/init.c          |    5 +++++
 arch/x86/xen/mmu.c          |    2 +-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 4f13998..b69e537 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -16,4 +16,6 @@ extern unsigned long __initdata pgt_buf_start;
 extern unsigned long __meminitdata pgt_buf_end;
 extern unsigned long __meminitdata pgt_buf_top;
 
+bool is_pfn_in_early_pgt_buf(unsigned long pfn);
+
 #endif /* _ASM_X86_INIT_32_H */
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6622d35..1becfbd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -21,6 +21,11 @@ unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
 unsigned long __meminitdata pgt_buf_top;
 
+bool __init is_pfn_in_early_pgt_buf(unsigned long pfn)
+{
+	return pfn >= pgt_buf_start && pfn < pgt_buf_top;
+}
+
 int after_bootmem;
 
 int direct_gbpages
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 7607a33..25f68bc 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1410,7 +1410,7 @@ static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
 	 * If the new pfn is within the range of the newly allocated
 	 * kernel pagetable, make sure it is RO.
 	 */
-	if (pfn >= pgt_buf_start && pfn < pgt_buf_top)
+	if (is_pfn_in_early_pgt_buf(pfn))
 		pte = pte_wrprotect(pte);
 
 	return pte;
-- 
1.7.7

