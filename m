Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab2JJXBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:01:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41010 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756850Ab2JJXA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:00:57 -0400
X-Sasl-enc: UDqnsaSzRrJZ5Atr4dyEtRux7yO6LRY5+0/c8u8By7vM 1349910056
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Graf <agraf@suse.de>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 007/122] powerpc/iommu: Fix multiple issues with IOMMU pools code
Date: Thu, 11 Oct 2012 07:52:53 +0900
Message-Id: <20121010225339.317252972@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit d900bd7366463fd96a907b2c212242e2b68b27d8 upstream.

There are a number of issues in the recent IOMMU pools code:

- On a preempt kernel we might switch CPUs in the middle of building
  a scatter gather list. When this happens the handle hint passed in
  no longer falls within the local CPU's pool. Check for this and
  fall back to the pool hint.

- We were missing a spin_unlock/spin_lock in one spot where we
  switch pools.

- We need to provide locking around dart_tlb_invalidate_all and
  dart_tlb_invalidate_one now that the global lock is gone.

Reported-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/iommu.c      |    5 ++++-
 arch/powerpc/sysdev/dart_iommu.c |   12 ++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -215,7 +215,8 @@ static unsigned long iommu_range_alloc(s
 	spin_lock_irqsave(&(pool->lock), flags);
 
 again:
-	if ((pass == 0) && handle && *handle)
+	if ((pass == 0) && handle && *handle &&
+	    (*handle >= pool->start) && (*handle < pool->end))
 		start = *handle;
 	else
 		start = pool->hint;
@@ -236,7 +237,9 @@ again:
 		 * but on second pass, start at 0 in pool 0.
 		 */
 		if ((start & mask) >= limit || pass > 0) {
+			spin_unlock(&(pool->lock));
 			pool = &(tbl->pools[0]);
+			spin_lock(&(pool->lock));
 			start = pool->start;
 		} else {
 			start &= mask;
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -74,11 +74,16 @@ static int dart_is_u4;
 
 #define DBG(...)
 
+static DEFINE_SPINLOCK(invalidate_lock);
+
 static inline void dart_tlb_invalidate_all(void)
 {
 	unsigned long l = 0;
 	unsigned int reg, inv_bit;
 	unsigned long limit;
+	unsigned long flags;
+
+	spin_lock_irqsave(&invalidate_lock, flags);
 
 	DBG("dart: flush\n");
 
@@ -111,12 +116,17 @@ retry:
 			panic("DART: TLB did not flush after waiting a long "
 			      "time. Buggy U3 ?");
 	}
+
+	spin_unlock_irqrestore(&invalidate_lock, flags);
 }
 
 static inline void dart_tlb_invalidate_one(unsigned long bus_rpn)
 {
 	unsigned int reg;
 	unsigned int l, limit;
+	unsigned long flags;
+
+	spin_lock_irqsave(&invalidate_lock, flags);
 
 	reg = DART_CNTL_U4_ENABLE | DART_CNTL_U4_IONE |
 		(bus_rpn & DART_CNTL_U4_IONE_MASK);
@@ -138,6 +148,8 @@ wait_more:
 			panic("DART: TLB did not flush after waiting a long "
 			      "time. Buggy U4 ?");
 	}
+
+	spin_unlock_irqrestore(&invalidate_lock, flags);
 }
 
 static void dart_flush(struct iommu_table *tbl)


