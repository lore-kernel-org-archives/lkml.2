Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab1BJV5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:57:35 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53283 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab1BJV5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:57:34 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH powerpc 1/2] powerpc: protect per-CPU access with preempt_disable
Date: Thu, 10 Feb 2011 13:57:26 -0800
Message-Id: <1297375047-18608-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110210215710.GA18429@linux.vnet.ibm.com>
References: <20110210215710.GA18429@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hpte_need_flush() function accesses the ppc64_tlb_batch per-CPU
variable with preemption enabled, a bug that this patch fixes.  Perhaps
crudely.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/pgtable-ppc64.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
index 2b09cd5..6ed08ab 100644
--- a/arch/powerpc/include/asm/pgtable-ppc64.h
+++ b/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -228,8 +228,11 @@ static inline unsigned long pte_update(struct mm_struct *mm,
 		assert_pte_locked(mm, addr);
 
 #ifdef CONFIG_PPC_STD_MMU_64
-	if (old & _PAGE_HASHPTE)
+	if (old & _PAGE_HASHPTE) {
+		preempt_disable();
 		hpte_need_flush(mm, addr, ptep, old, huge);
+		preempt_enable();
+	}
 #endif
 
 	return old;
-- 
1.7.3.2

