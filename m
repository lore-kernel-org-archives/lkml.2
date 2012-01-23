Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2AWVJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:09:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57353 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2AWVJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:09:04 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] irqdesc: Consolidate irq reservation logic
Date: Mon, 23 Jan 2012 14:08:59 -0700
Message-Id: <1327352939-14907-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_reserve_irqs() and irq_alloc_descs() use largely identical code for
finding the range of irqs to reserve.  This patch consolidates it into
a single function

v2: Fix bug where irq_alloc_desc() was returning -EEXIST always

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdesc.c |   45 ++++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index d86e254..11feb2f 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -339,18 +339,15 @@ void irq_free_descs(unsigned int from, unsigned int cnt)
 EXPORT_SYMBOL_GPL(irq_free_descs);
 
 /**
- * irq_alloc_descs - allocate and initialize a range of irq descriptors
+ * __irq_reserve_irqs() - reserve a range of irq numbers
  * @irq:	Allocate for specific irq number if irq >= 0
  * @from:	Start the search from this irq number
  * @cnt:	Number of consecutive irqs to allocate.
- * @node:	Preferred node on which the irq descriptor should be allocated
- * @owner:	Owning module (can be NULL)
  *
  * Returns the first irq number or error code
  */
-int __ref
-__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
-		  struct module *owner)
+static int __ref
+__irq_reserve_irqs(int irq, unsigned int from, unsigned int cnt)
 {
 	int start, ret;
 
@@ -379,12 +376,30 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 
 	bitmap_set(allocated_irqs, start, cnt);
 	mutex_unlock(&sparse_irq_lock);
-	return alloc_descs(start, cnt, node, owner);
+	return start;
 
 err:
 	mutex_unlock(&sparse_irq_lock);
 	return ret;
 }
+
+/**
+ * irq_alloc_descs - allocate and initialize a range of irq descriptors
+ * @irq:	Allocate for specific irq number if irq >= 0
+ * @from:	Start the search from this irq number
+ * @cnt:	Number of consecutive irqs to allocate.
+ * @node:	Preferred node on which the irq descriptor should be allocated
+ * @owner:	Owning module (can be NULL)
+ *
+ * Returns the first irq number of the reserved range or an error code
+ */
+int __ref
+__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
+		  struct module *owner)
+{
+	int start = __irq_reserve_irqs(irq, from, cnt);
+	return start < 0 ? start : alloc_descs(start, cnt, node, owner);
+}
 EXPORT_SYMBOL_GPL(__irq_alloc_descs);
 
 /**
@@ -396,20 +411,8 @@ EXPORT_SYMBOL_GPL(__irq_alloc_descs);
  */
 int irq_reserve_irqs(unsigned int from, unsigned int cnt)
 {
-	unsigned int start;
-	int ret = 0;
-
-	if (!cnt || (from + cnt) > nr_irqs)
-		return -EINVAL;
-
-	mutex_lock(&sparse_irq_lock);
-	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
-	if (start == from)
-		bitmap_set(allocated_irqs, start, cnt);
-	else
-		ret = -EEXIST;
-	mutex_unlock(&sparse_irq_lock);
-	return ret;
+	int start = __irq_reserve_irqs(from, from, cnt);
+	return start < 0 ? start : 0;
 }
 
 /**
-- 
1.7.5.4

