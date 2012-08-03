Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2HCRqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:46:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34680 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2HCRoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:44:24 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        tomi.valkeinen@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] workqueue: introduce WORK_OFFQ_FLAG_*
Date: Fri,  3 Aug 2012 10:43:54 -0700
Message-Id: <1344015839-21800-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344015839-21800-1-git-send-email-tj@kernel.org>
References: <1344015839-21800-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Low WORK_STRUCT_FLAG_BITS bits of work_struct->data contain
WORK_STRUCT_FLAG_* and flush color.  If the work item is queued, the
rest point to the cpu_workqueue with WORK_STRUCT_CWQ set; otherwise,
WORK_STRUCT_CWQ is clear and the bits contain the last CPU number -
either a real CPU number or one of WORK_CPU_*.

Scheduled addition of mod_delayed_work[_on]() requires an additional
flag, which is used only while a work item is off queue.  There are
more than enough bits to represent off-queue CPU number on both 32 and
64bits.  This patch introduces WORK_OFFQ_FLAG_* which occupy the lower
part of the @work->data high bits while off queue.  This patch doesn't
define any actual OFFQ flag yet.

Off-queue CPU number is now shifted by WORK_OFFQ_CPU_SHIFT, which adds
the number of bits used by OFFQ flags to WORK_STRUCT_FLAG_SHIFT, to
make room for OFFQ flags.

To avoid shift width warning with large WORK_OFFQ_FLAG_BITS, ulong
cast is added to WORK_STRUCT_NO_CPU and, just in case, BUILD_BUG_ON()
to check that there are enough bits to accomodate off-queue CPU number
is added.

This patch doesn't make any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    8 +++++++-
 kernel/workqueue.c        |   14 +++++++++-----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index ab95fef..f562674 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -68,9 +68,15 @@ enum {
 	WORK_STRUCT_FLAG_BITS	= WORK_STRUCT_COLOR_SHIFT +
 				  WORK_STRUCT_COLOR_BITS,
 
+	/* data contains off-queue information when !WORK_STRUCT_CWQ */
+	WORK_OFFQ_FLAG_BASE	= WORK_STRUCT_FLAG_BITS,
+	WORK_OFFQ_FLAG_BITS	= 0,
+	WORK_OFFQ_CPU_SHIFT	= WORK_OFFQ_FLAG_BASE + WORK_OFFQ_FLAG_BITS,
+
+	/* convenience constants */
 	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
-	WORK_STRUCT_NO_CPU	= WORK_CPU_NONE << WORK_STRUCT_FLAG_BITS,
+	WORK_STRUCT_NO_CPU	= (unsigned long)WORK_CPU_NONE << WORK_OFFQ_CPU_SHIFT,
 
 	/* bit mask for work_busy() return values */
 	WORK_BUSY_PENDING	= 1 << 0,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0f50f40..eeae770 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -533,9 +533,9 @@ static int work_next_color(int color)
 }
 
 /*
- * A work's data points to the cwq with WORK_STRUCT_CWQ set while the
- * work is on queue.  Once execution starts, WORK_STRUCT_CWQ is
- * cleared and the work data contains the cpu number it was last on.
+ * While queued, %WORK_STRUCT_CWQ is set and non flag bits of a work's data
+ * contain the pointer to the queued cwq.  Once execution starts, the flag
+ * is cleared and the high bits contain OFFQ flags and CPU number.
  *
  * set_work_cwq(), set_work_cpu_and_clear_pending() and clear_work_data()
  * can be used to set the cwq, cpu or clear work->data.  These functions
@@ -565,7 +565,7 @@ static void set_work_cwq(struct work_struct *work,
 static void set_work_cpu_and_clear_pending(struct work_struct *work,
 					   unsigned int cpu)
 {
-	set_work_data(work, cpu << WORK_STRUCT_FLAG_BITS, 0);
+	set_work_data(work, (unsigned long)cpu << WORK_OFFQ_CPU_SHIFT, 0);
 }
 
 static void clear_work_data(struct work_struct *work)
@@ -592,7 +592,7 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 		return ((struct cpu_workqueue_struct *)
 			(data & WORK_STRUCT_WQ_DATA_MASK))->pool->gcwq;
 
-	cpu = data >> WORK_STRUCT_FLAG_BITS;
+	cpu = data >> WORK_OFFQ_CPU_SHIFT;
 	if (cpu == WORK_CPU_NONE)
 		return NULL;
 
@@ -3724,6 +3724,10 @@ static int __init init_workqueues(void)
 	unsigned int cpu;
 	int i;
 
+	/* make sure we have enough bits for OFFQ CPU number */
+	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_CPU_SHIFT)) <
+		     WORK_CPU_LAST);
+
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	cpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
-- 
1.7.7.3

