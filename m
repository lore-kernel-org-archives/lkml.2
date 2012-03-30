Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384Ab2C3PUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:20:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43953 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab2C3PUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:20:12 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] IRQ: correctly handle return value from chip->irq_set_affinity() in irq_move_masked_irq()
Date: Fri, 30 Mar 2012 23:11:33 +0800
Message-Id: <1333120296-13563-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com>
References: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chip->irq_set_affinity() may return IRQ_SET_MASK_OK_NOCOPY if the mask has
been copied to desc->irq_data.affinity, but irq_move_masked_irq() incorrectly
treats that return value as error code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 kernel/irq/migration.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 4742090..c3c8975 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -43,12 +43,16 @@ void irq_move_masked_irq(struct irq_data *idata)
 	 * masking the irqs.
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
-		   < nr_cpu_ids))
-		if (!chip->irq_set_affinity(&desc->irq_data,
-					    desc->pending_mask, false)) {
+		   < nr_cpu_ids)) {
+		int ret = chip->irq_set_affinity(&desc->irq_data,
+						 desc->pending_mask, false);
+		switch (ret) {
+		case IRQ_SET_MASK_OK:
 			cpumask_copy(desc->irq_data.affinity, desc->pending_mask);
+		case IRQ_SET_MASK_OK_NOCOPY:
 			irq_set_thread_affinity(desc);
 		}
+	}
 
 	cpumask_clear(desc->pending_mask);
 }
-- 
1.7.5.4

