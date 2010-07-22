Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab0GVMZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:25:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:38855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab0GVMZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:25:38 -0400
Message-ID: <4C4838B8.1080400@kernel.org>
Date: Thu, 22 Jul 2010 14:25:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Sachin Sant <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: [PATCH wq#for-next] workqueue: fix how cpu number is stored in work->data
References: <4C46CEA3.7040503@in.ibm.com>	<4C4718D5.1080902@kernel.org> <20100722112557.14b65077@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100722112557.14b65077@mschwide.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Jul 2010 12:25:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once a work starts execution, its data contains the cpu number it was
on instead of pointing to cwq.  This is added by commit 7a22ad75
(workqueue: carry cpu number in work data once execution starts) to
reliably determine the work was last on even if the workqueue itself
was destroyed inbetween.

Whether data points to a cwq or contains a cpu number was
distinguished by comparing the value against PAGE_OFFSET.  The
assumption was that a cpu number should be below PAGE_OFFSET while a
pointer to cwq should be above it.  However, on architectures which
use separate address spaces for user and kernel spaces, this doesn't
hold as PAGE_OFFSET is zero.

Fix it by using an explicit flag, WORK_STRUCT_CWQ, to mark what the
data field contains.  If the flag is set, it's pointing to a cwq;
otherwise, it contains a cpu number.

Reported on s390 and microblaze during linux-next testing.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sachin Sant <sachinp@in.ibm.com>
Reported-by: Michal Simek <michal.simek@petalogix.com>
Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
Yeah, that was a stupid assumption by me.  Can you guys please test
whether this fixes the problem?

Thanks.

 include/linux/workqueue.h |   14 ++++++++------
 kernel/workqueue.c        |   36 +++++++++++++-----------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index d74a529..5f76001 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -25,17 +25,19 @@ typedef void (*work_func_t)(struct work_struct *work);

 enum {
 	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
-	WORK_STRUCT_LINKED_BIT	= 1,	/* next work is linked to this one */
+	WORK_STRUCT_CWQ_BIT	= 1,	/* data points to cwq */
+	WORK_STRUCT_LINKED_BIT	= 2,	/* next work is linked to this one */
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
-	WORK_STRUCT_STATIC_BIT	= 2,	/* static initializer (debugobjects) */
-	WORK_STRUCT_COLOR_SHIFT	= 3,	/* color for workqueue flushing */
+	WORK_STRUCT_STATIC_BIT	= 3,	/* static initializer (debugobjects) */
+	WORK_STRUCT_COLOR_SHIFT	= 4,	/* color for workqueue flushing */
 #else
-	WORK_STRUCT_COLOR_SHIFT	= 2,	/* color for workqueue flushing */
+	WORK_STRUCT_COLOR_SHIFT	= 3,	/* color for workqueue flushing */
 #endif

 	WORK_STRUCT_COLOR_BITS	= 4,

 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
+	WORK_STRUCT_CWQ		= 1 << WORK_STRUCT_CWQ_BIT,
 	WORK_STRUCT_LINKED	= 1 << WORK_STRUCT_LINKED_BIT,
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 	WORK_STRUCT_STATIC	= 1 << WORK_STRUCT_STATIC_BIT,
@@ -56,8 +58,8 @@ enum {
 	WORK_CPU_LAST		= WORK_CPU_NONE,

 	/*
-	 * Reserve 6 bits off of cwq pointer w/ debugobjects turned
-	 * off.  This makes cwqs aligned to 64 bytes which isn't too
+	 * Reserve 7 bits off of cwq pointer w/ debugobjects turned
+	 * off.  This makes cwqs aligned to 128 bytes which isn't too
 	 * excessive while allowing 15 workqueue flush colors.
 	 */
 	WORK_STRUCT_FLAG_BITS	= WORK_STRUCT_COLOR_SHIFT +
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c11edc9..e5cb7fa 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -468,10 +468,9 @@ static int work_next_color(int color)
 }

 /*
- * Work data points to the cwq while a work is on queue.  Once
- * execution starts, it points to the cpu the work was last on.  This
- * can be distinguished by comparing the data value against
- * PAGE_OFFSET.
+ * A work's data points to the cwq with WORK_STRUCT_CWQ set while the
+ * work is on queue.  Once execution starts, WORK_STRUCT_CWQ is
+ * cleared and the work data contains the cpu number it was last on.
  *
  * set_work_{cwq|cpu}() and clear_work_data() can be used to set the
  * cwq, cpu or clear work->data.  These functions should only be
@@ -494,7 +493,7 @@ static void set_work_cwq(struct work_struct *work,
 			 unsigned long extra_flags)
 {
 	set_work_data(work, (unsigned long)cwq,
-		      WORK_STRUCT_PENDING | extra_flags);
+		      WORK_STRUCT_PENDING | WORK_STRUCT_CWQ | extra_flags);
 }

 static void set_work_cpu(struct work_struct *work, unsigned int cpu)
@@ -507,25 +506,24 @@ static void clear_work_data(struct work_struct *work)
 	set_work_data(work, WORK_STRUCT_NO_CPU, 0);
 }

-static inline unsigned long get_work_data(struct work_struct *work)
-{
-	return atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK;
-}
-
 static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
 {
-	unsigned long data = get_work_data(work);
+	unsigned long data = atomic_long_read(&work->data);

-	return data >= PAGE_OFFSET ? (void *)data : NULL;
+	if (data & WORK_STRUCT_CWQ)
+		return (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
+	else
+		return NULL;
 }

 static struct global_cwq *get_work_gcwq(struct work_struct *work)
 {
-	unsigned long data = get_work_data(work);
+	unsigned long data = atomic_long_read(&work->data);
 	unsigned int cpu;

-	if (data >= PAGE_OFFSET)
-		return ((struct cpu_workqueue_struct *)data)->gcwq;
+	if (data & WORK_STRUCT_CWQ)
+		return ((struct cpu_workqueue_struct *)
+			(data & WORK_STRUCT_WQ_DATA_MASK))->gcwq;

 	cpu = data >> WORK_STRUCT_FLAG_BITS;
 	if (cpu == WORK_CPU_NONE)
@@ -3501,14 +3499,6 @@ void __init init_workqueues(void)
 	unsigned int cpu;
 	int i;

-	/*
-	 * The pointer part of work->data is either pointing to the
-	 * cwq or contains the cpu number the work ran last on.  Make
-	 * sure cpu number won't overflow into kernel pointer area so
-	 * that they can be distinguished.
-	 */
-	BUILD_BUG_ON(WORK_CPU_LAST << WORK_STRUCT_FLAG_BITS >= PAGE_OFFSET);
-
 	hotcpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);

 	/* initialize gcwqs */
-- 
1.6.4.2

