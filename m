Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0JKNXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:23:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:58164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab0JKNXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:23:16 -0400
Message-ID: <4CB30F9A.9030809@kernel.org>
Date: Mon, 11 Oct 2010 15:22:34 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH wq#for-next] workqueue: add and use WQ_MEM_RECLAIM flag
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Oct 2010 13:22:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add WQ_MEM_RECLAIM flag which currently maps to WQ_RESCUER, mark
WQ_RESCUER as internal and replace all external WQ_RESCUER usages to
WQ_MEM_RECLAIM.

This makes the API users express the intent of the workqueue instead
of indicating the internal mechanism used to guarantee forward
progress.  This is also to make it cleaner to add more semantics to
WQ_MEM_RECLAIM.  For example, if deemed necessary, memory reclaim
workqueues can be made highpri.

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
---
WQ_RESCUER is a bit too specific to be directly used by workqueue
users.  Let's clean it up before the usage is widespread.  If nobody
objects, I'd like to route this through the workqueue tree.  Also, as
WQ_RESCUER isn't removed, this won't break anything from other trees
and those can be updated later.

Thanks.

 Documentation/workqueue.txt |   29 +++++++++++++++--------------
 drivers/ata/libata-sff.c    |    2 +-
 fs/gfs2/main.c              |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c  |    2 +-
 include/linux/workqueue.h   |   11 ++++++-----
 kernel/workqueue.c          |    7 +++++++
 6 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
index e4498a2..996a27d 100644
--- a/Documentation/workqueue.txt
+++ b/Documentation/workqueue.txt
@@ -196,11 +196,11 @@ resources, scheduled and executed.
 	suspend operations.  Work items on the wq are drained and no
 	new work item starts execution until thawed.

-  WQ_RESCUER
+  WQ_MEM_RECLAIM

 	All wq which might be used in the memory reclaim paths _MUST_
-	have this flag set.  This reserves one worker exclusively for
-	the execution of this wq under memory pressure.
+	have this flag set.  The wq is guaranteed to have at least one
+	execution context regardless of memory pressure.

   WQ_HIGHPRI

@@ -356,11 +356,11 @@ If q1 has WQ_CPU_INTENSIVE set,

 6. Guidelines

-* Do not forget to use WQ_RESCUER if a wq may process work items which
-  are used during memory reclaim.  Each wq with WQ_RESCUER set has one
-  rescuer thread reserved for it.  If there is dependency among
-  multiple work items used during memory reclaim, they should be
-  queued to separate wq each with WQ_RESCUER.
+* Do not forget to use WQ_MEM_RECLAIM if a wq may process work items
+  which are used during memory reclaim.  Each wq with WQ_MEM_RECLAIM
+  set has an execution context reserved for it.  If there is
+  dependency among multiple work items used during memory reclaim,
+  they should be queued to separate wq each with WQ_MEM_RECLAIM.

 * Unless strict ordering is required, there is no need to use ST wq.

@@ -368,12 +368,13 @@ If q1 has WQ_CPU_INTENSIVE set,
   recommended.  In most use cases, concurrency level usually stays
   well under the default limit.

-* A wq serves as a domain for forward progress guarantee (WQ_RESCUER),
-  flush and work item attributes.  Work items which are not involved
-  in memory reclaim and don't need to be flushed as a part of a group
-  of work items, and don't require any special attribute, can use one
-  of the system wq.  There is no difference in execution
-  characteristics between using a dedicated wq and a system wq.
+* A wq serves as a domain for forward progress guarantee
+  (WQ_MEM_RECLAIM, flush and work item attributes.  Work items which
+  are not involved in memory reclaim and don't need to be flushed as a
+  part of a group of work items, and don't require any special
+  attribute, can use one of the system wq.  There is no difference in
+  execution characteristics between using a dedicated wq and a system
+  wq.

 * Unless work items are expected to consume a huge amount of CPU
   cycles, using a bound wq is usually beneficial due to the increased
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index e30c537..f5296bb 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -3335,7 +3335,7 @@ void ata_sff_port_init(struct ata_port *ap)

 int __init ata_sff_init(void)
 {
-	ata_sff_wq = alloc_workqueue("ata_sff", WQ_RESCUER, WQ_MAX_ACTIVE);
+	ata_sff_wq = alloc_workqueue("ata_sff", WQ_MEM_RECLAIM, WQ_MAX_ACTIVE);
 	if (!ata_sff_wq)
 		return -ENOMEM;

diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index b1e9630..1c5f460 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -140,7 +140,7 @@ static int __init init_gfs2_fs(void)

 	error = -ENOMEM;
 	gfs_recovery_wq = alloc_workqueue("gfs_recovery",
-					  WQ_NON_REENTRANT | WQ_RESCUER, 0);
+					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
 	if (!gfs_recovery_wq)
 		goto fail_wq;

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 286e36e..6838aef 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1933,7 +1933,7 @@ xfs_buf_init(void)
 		goto out;

 	xfslogd_workqueue = alloc_workqueue("xfslogd",
-					WQ_RESCUER | WQ_HIGHPRI, 1);
+					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index e33ff4a..03bbe90 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -243,11 +243,12 @@ enum {
 	WQ_NON_REENTRANT	= 1 << 0, /* guarantee non-reentrance */
 	WQ_UNBOUND		= 1 << 1, /* not bound to any cpu */
 	WQ_FREEZEABLE		= 1 << 2, /* freeze during suspend */
-	WQ_RESCUER		= 1 << 3, /* has an rescue worker */
+	WQ_MEM_RECLAIM		= 1 << 3, /* may be used for memory reclaim */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */

 	WQ_DYING		= 1 << 6, /* internal: workqueue is dying */
+	WQ_RESCUER		= 1 << 7, /* internal: workqueue has rescuer */

 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
@@ -309,7 +310,7 @@ __alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
 /**
  * alloc_ordered_workqueue - allocate an ordered workqueue
  * @name: name of the workqueue
- * @flags: WQ_* flags (only WQ_FREEZEABLE and WQ_RESCUER are meaningful)
+ * @flags: WQ_* flags (only WQ_FREEZEABLE and WQ_MEM_RECLAIM are meaningful)
  *
  * Allocate an ordered workqueue.  An ordered workqueue executes at
  * most one work item at any given time in the queued order.  They are
@@ -325,11 +326,11 @@ alloc_ordered_workqueue(const char *name, unsigned int flags)
 }

 #define create_workqueue(name)					\
-	alloc_workqueue((name), WQ_RESCUER, 1)
+	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
 #define create_freezeable_workqueue(name)			\
-	alloc_workqueue((name), WQ_FREEZEABLE | WQ_UNBOUND | WQ_RESCUER, 1)
+	alloc_workqueue((name), WQ_FREEZEABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
 #define create_singlethread_workqueue(name)			\
-	alloc_workqueue((name), WQ_UNBOUND | WQ_RESCUER, 1)
+	alloc_workqueue((name), WQ_UNBOUND | WQ_MEM_RECLAIM, 1)

 extern void destroy_workqueue(struct workqueue_struct *wq);

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b57a8ba..2c6871c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2848,6 +2848,13 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	unsigned int cpu;

 	/*
+	 * Workqueues which may be used during memory reclaim should
+	 * have a rescuer to guarantee forward progress.
+	 */
+	if (flags & WQ_MEM_RECLAIM)
+		flags |= WQ_RESCUER;
+
+	/*
 	 * Unbound workqueues aren't concurrency managed and should be
 	 * dispatched to workers immediately.
 	 */
-- 
1.7.1

