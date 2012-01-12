Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2ALGI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:08:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44040 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2ALGI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:08:56 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] irqdesc: Consolidate irq reservation logic
Date: Wed, 11 Jan 2012 23:08:48 -0700
Message-Id: <1326348528-5671-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_reserve_irqs() and irq_alloc_descs() use largely identical code for
finding the range of irqs to reserve.  This patch consolidates it into
a single function

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdesc.c |   45 ++++++++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index d86e254..8a9e2ec 100644
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
 
@@ -378,13 +375,28 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 	}
 
 	bitmap_set(allocated_irqs, start, cnt);
-	mutex_unlock(&sparse_irq_lock);
-	return alloc_descs(start, cnt, node, owner);
-
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
@@ -396,20 +408,7 @@ EXPORT_SYMBOL_GPL(__irq_alloc_descs);
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
+	return __irq_reserve_irqs(from, from, cnt);
 }
 
 /**
-- 
1.7.5.4

