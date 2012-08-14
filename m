Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab2HNBu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:50:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48650 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab2HNBt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:49:59 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@redhat.com,
        lauro.venancio@openbossa.org, jak@jak-linux.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] workqueue: gut system_nrt[_freezable]_wq()
Date: Mon, 13 Aug 2012 18:49:43 -0700
Message-Id: <1344908986-18152-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344908986-18152-1-git-send-email-tj@kernel.org>
References: <1344908986-18152-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all workqueues are non-reentrant, system[_freezable]_wq() are
equivalent to system_nrt[_freezable]_wq().  Replace the latter with
wrappers around system[_freezable]_wq().  The wrapping goes through
inline functions so that __deprecated can be added easily.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   23 ++++++++++++++---------
 kernel/workqueue.c        |   12 ++----------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b2716b6..b0a678b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -297,10 +297,6 @@ enum {
  * system_long_wq is similar to system_wq but may host long running
  * works.  Queue flushing might take relatively long.
  *
- * system_nrt_wq is non-reentrant and guarantees that any given work
- * item is never executed in parallel by multiple CPUs.  Queue
- * flushing might take relatively long.
- *
  * system_unbound_wq is unbound workqueue.  Workers are not bound to
  * any specific CPU, not concurrency managed, and all queued works are
  * executed immediately as long as max_active limit is not reached and
@@ -308,16 +304,25 @@ enum {
  *
  * system_freezable_wq is equivalent to system_wq except that it's
  * freezable.
- *
- * system_nrt_freezable_wq is equivalent to system_nrt_wq except that
- * it's freezable.
  */
 extern struct workqueue_struct *system_wq;
 extern struct workqueue_struct *system_long_wq;
-extern struct workqueue_struct *system_nrt_wq;
 extern struct workqueue_struct *system_unbound_wq;
 extern struct workqueue_struct *system_freezable_wq;
-extern struct workqueue_struct *system_nrt_freezable_wq;
+
+static inline struct workqueue_struct *__system_nrt_wq(void)
+{
+	return system_wq;
+}
+
+static inline struct workqueue_struct *__system_nrt_freezable_wq(void)
+{
+	return system_freezable_wq;
+}
+
+/* equivlalent to system_wq and system_freezable_wq, deprecated */
+#define system_nrt_wq			__system_nrt_wq()
+#define system_nrt_freezable_wq		__system_nrt_freezable_wq()
 
 extern struct workqueue_struct *
 __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 938adc0..ce39467 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -269,16 +269,12 @@ struct workqueue_struct {
 
 struct workqueue_struct *system_wq __read_mostly;
 struct workqueue_struct *system_long_wq __read_mostly;
-struct workqueue_struct *system_nrt_wq __read_mostly;
 struct workqueue_struct *system_unbound_wq __read_mostly;
 struct workqueue_struct *system_freezable_wq __read_mostly;
-struct workqueue_struct *system_nrt_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
 EXPORT_SYMBOL_GPL(system_long_wq);
-EXPORT_SYMBOL_GPL(system_nrt_wq);
 EXPORT_SYMBOL_GPL(system_unbound_wq);
 EXPORT_SYMBOL_GPL(system_freezable_wq);
-EXPORT_SYMBOL_GPL(system_nrt_freezable_wq);
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
@@ -3847,16 +3843,12 @@ static int __init init_workqueues(void)
 
 	system_wq = alloc_workqueue("events", 0, 0);
 	system_long_wq = alloc_workqueue("events_long", 0, 0);
-	system_nrt_wq = alloc_workqueue("events_nrt", WQ_NON_REENTRANT, 0);
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
 					    WQ_UNBOUND_MAX_ACTIVE);
 	system_freezable_wq = alloc_workqueue("events_freezable",
 					      WQ_FREEZABLE, 0);
-	system_nrt_freezable_wq = alloc_workqueue("events_nrt_freezable",
-			WQ_NON_REENTRANT | WQ_FREEZABLE, 0);
-	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq ||
-	       !system_unbound_wq || !system_freezable_wq ||
-		!system_nrt_freezable_wq);
+	BUG_ON(!system_wq || !system_long_wq || !system_unbound_wq ||
+	       !system_freezable_wq);
 	return 0;
 }
 early_initcall(init_workqueues);
-- 
1.7.7.3

