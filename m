Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab2DKXPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:15:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673Ab2DKXPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:15:17 -0400
Message-Id: <20120411231022.424170202@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiang Liu <jiang.liu@huawei.com>,
        Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 25/78] genirq: Adjust irq thread affinity on IRQ_SET_MASK_OK_NOCOPY return value
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

commit f5cb92ac82d06cb583c1f66666314c5c0a4d7913 upstream.

irq_move_masked_irq() checks the return code of
chip->irq_set_affinity() only for 0, but IRQ_SET_MASK_OK_NOCOPY is
also a valid return code, which is there to avoid a redundant copy of
the cpumask. But in case of IRQ_SET_MASK_OK_NOCOPY we not only avoid
the redundant copy, we also fail to adjust the thread affinity of an
eventually threaded interrupt handler.

Handle IRQ_SET_MASK_OK (==0) and IRQ_SET_MASK_OK_NOCOPY(==1) return
values correctly by checking the valid return values seperately.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Keping Chen <chenkeping@huawei.com>
Link: http://lkml.kernel.org/r/1333120296-13563-2-git-send-email-jiang.liu@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/migration.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -43,12 +43,16 @@ void irq_move_masked_irq(struct irq_data
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


