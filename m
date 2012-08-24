Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab2HXIzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:55:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:36310 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2HXIzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,302,1344236400"; 
   d="scan'208";a="137354056"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, jbeulich@suse.com
Subject: [PATCH] xen: fix logical error in tlb flushing
Date: Fri, 24 Aug 2012 16:55:13 +0800
Message-Id: <1345798513-3566-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While TLB_FLUSH_ALL gets passed as 'end' argument to
flush_tlb_others(), the Xen code was made to check its 'start'
parameter. That may give a incorrect op.cmd to MMUEXT_INVLPG_MULTI
instead of MMUEXT_TLB_FLUSH_MULTI. Then it causes some page can not
be flushed from TLB.

This patch fixed this issue.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/xen/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b65a761..5141d80 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1283,7 +1283,7 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
 
 	args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
-	if (start != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
+	if (end != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
 		args->op.cmd = MMUEXT_INVLPG_MULTI;
 		args->op.arg1.linear_addr = start;
 	}
-- 
1.7.5.4

