Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1EYGeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:34:22 -0400
Received: from mail4.comsite.net ([205.238.176.238]:53363 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1EYGeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:34:21 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [PATCH RFC 4/4] irq: allow a per-allocation upper limit when allocating irqs
From: Milton Miller <miltonm@bga.com>
Message-Id: <alloc-irq-range-v2@mdm.bga.com>
In-Reply-To: <generic-irq-changes@mdm.bga.com>
References: <generic-irq-changes@mdm.bga.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 25 May 2011 01:34:18 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the option to specify an upper limit to the irq numbers for
each allocation.  The limit is non-inclusive, and 0 means no limit
needed by caller.

Some irq chips can support a relative large and arbitrary range,
but not infinite.  For example, they may use the linux irq number
as the msi desciptor data, which for msi is 16 bits.

Since e7bcecb7b1 (genirq: Make nr_irqs runtime expandable), checking
NR_IRQS or even nr_irqs is not sufficient to enforce such requirements
when sparse irqs are configured.

Based on an irc discussion, make the limit per call instead of an
arch callback or global setting.

If the requested count is above the limit, return -ENOMEM as if
nr_irqs could not be expanded, assuming the limit was specified at
a different layer than the count.

This code does not try to keep the prior semantics of irq_alloc_descs
when irq was non-negative but not equal to from.  I believe it was an
implementation artifact instead of a designed feature that one could
specify search starting from 4 and fail if the allocated irq was not
exactly 6, confirming that the intervening irqs were reserved.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Milton Miller <miltonm@bga.com>


Thomas,

This is still RFC because I haven't gotten far enough in my series
to actually use the patch yet.  If you choose not to apply it now,
should I submit a patch to enforce irq matches from if its not -1
(or otherwise negative)?

Contrasting to Grant's earlier proposal, this patch:
(1) has a non-inclusive limit, sutiable for showing size of an array etc.
(2) has no redundant parameter for a specific irq to be allocated after inlines
(3) avoids searching areas that will be rejected by calculating the end,
    which also simpifies the search result check.

milton

Index: work.git/include/linux/irq.h
===================================================================
--- work.git.orig/include/linux/irq.h	2011-05-25 01:01:50.230468165 -0500
+++ work.git/include/linux/irq.h	2011-05-25 01:02:11.478479716 -0500
@@ -546,10 +546,20 @@ static inline struct msi_desc *irq_data_
 	return d->msi_desc;
 }
 
-int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node);
+int irq_alloc_descs_range(unsigned int from, unsigned int limit, unsigned int cnt, int node);
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
 
+int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
+{
+	if (irq < 0)
+		return irq_alloc_descs_range(from, 0, cnt, node);
+	/* fail if specified start at 4 and obtain 6 */
+	if (irq != from)
+		return -EEXIST;
+	return irq_alloc_descs_range(from, from + cnt, cnt, node);
+}
+
 static inline int irq_alloc_desc(int node)
 {
 	return irq_alloc_descs(-1, 0, 1, node);
Index: work.git/kernel/irq/irqdesc.c
===================================================================
--- work.git.orig/kernel/irq/irqdesc.c	2011-05-25 01:02:11.454480436 -0500
+++ work.git/kernel/irq/irqdesc.c	2011-05-25 01:04:03.441480315 -0500
@@ -343,27 +343,37 @@ void irq_free_descs(unsigned int from, u
 EXPORT_SYMBOL_GPL(irq_free_descs);
 
 /**
- * irq_alloc_descs - allocate and initialize a range of irq descriptors
- * @irq:	Allocate for specific irq number if irq >= 0
+ * irq_alloc_descs_range - allocate and initialize a range of irq descriptors
  * @from:	Start the search from this irq number
+ * @limit:	Unless zero, all irq numbers must be less than this value
  * @cnt:	Number of consecutive irqs to allocate.
  * @node:	Preferred node on which the irq descriptor should be allocated
  *
  * Returns the first irq number or error code
  */
-int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
+int irq_alloc_descs_range(unsigned int from, unsigned int limit,
+		unsigned int cnt, int node)
 {
-	int start, ret;
+	unsigned int start, end;
+	int ret;
 
 	if (!cnt)
 		return -EINVAL;
+	if (limit) {
+		if (cnt > limit)
+			return -ENOMEM;
+		if (from > limit - cnt)
+			return -EINVAL;
+		end = min_t(unsigned int, limit, IRQ_BITMAP_BITS);
+	} else {
+		end = IRQ_BITMAP_BITS;
+	}
 
 	mutex_lock(&sparse_irq_lock);
 
-	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
-					   from, cnt, 0);
+	start = bitmap_find_next_zero_area(allocated_irqs, end, from, cnt, 0);
 	ret = -EEXIST;
-	if (irq >=0 && start != irq)
+	if (start >= end)
 		goto err;
 
 	if (start + cnt > nr_irqs) {
@@ -380,7 +390,7 @@ err:
 	mutex_unlock(&sparse_irq_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(irq_alloc_descs);
+EXPORT_SYMBOL_GPL(irq_alloc_descs_range);
 
 /**
  * irq_reserve_irqs - mark irqs allocated
