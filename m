Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2CTD11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:27:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53975 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564Ab2CTD1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:27:12 -0400
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@frijolero.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] compat: backport system work queues system_wq and system_long_wq
Date: Mon, 19 Mar 2012 20:26:58 -0700
Message-Id: <1332214021-9716-2-git-send-email-mcgrof@frijolero.org>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
In-Reply-To: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

mcgrof@tux ~/linux-stable (git::master)$ git describe --contains d320c038
v2.6.36-rc1~506^2~26

The commit d320c038 added some new system workqueues to allow us
to categorize order of priority on workqueue items. We had already
backported usage of system_nrt_wq but hadn't backported usage of
system_wq or system_long_wq. We address this now in this patch
by also ensuring that flush_workqueue() will flush these as
designed, that is only prioritizing system_wq. Given that older
kernels would be using the older keventd_wq for now we flush
that and then system_wq, allowing users of the system_long_wq
to be delayed as intended for backported kernel code using this
framework.

For newer kernels this is a no-op.

commit d320c03830b17af64e4547075003b1eeb274bc6c
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Jun 29 10:07:14 2010 +0200

    workqueue: s/__create_workqueue()/alloc_workqueue()/, and add system workqueues

    This patch makes changes to make new workqueue features available to
    its users.

    * Now that workqueue is more featureful, there should be a public
      workqueue creation function which takes paramters to control them.
      Rename __create_workqueue() to alloc_workqueue() and make 0
      max_active mean WQ_DFL_ACTIVE.  In the long run, all
      create_workqueue_*() will be converted over to alloc_workqueue().

    * To further unify access interface, rename keventd_wq to system_wq
      and export it.

    * Add system_long_wq and system_nrt_wq.  The former is to host long
      running works separately (so that flush_scheduled_work() dosen't
      take so long) and the latter guarantees any queued work item is
      never executed in parallel by multiple CPUs.  These will be used by
      future patches to update workqueue users.

    Signed-off-by: Tejun Heo <tj@kernel.org>

The ckmake [documented on 0] log:

Trying kernel                  3.3.0-030300rc2-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                        2.6.38-13-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                        2.6.31-22-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [OK]
Trying kernel                    2.6.24-020624-generic  [OK]

[0] https://github.com/mcgrof/compat/wiki

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 compat/compat-2.6.36.c        |   53 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/compat-2.6.36.h |   32 +++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index dfab2ea..b79609c 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -95,16 +95,67 @@ EXPORT_SYMBOL_GPL(compat_usb_scuttle_anchored_urbs);
 
 #endif /* CONFIG_COMPAT_USB_URB_THREAD_FIX */
 
+struct workqueue_struct *system_wq __read_mostly;
+struct workqueue_struct *system_long_wq __read_mostly;
 struct workqueue_struct *system_nrt_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_wq);
+EXPORT_SYMBOL_GPL(system_long_wq);
 EXPORT_SYMBOL_GPL(system_nrt_wq);
 
+int compat_schedule_work(struct work_struct *work)
+{
+	return queue_work(system_wq, work);
+}
+EXPORT_SYMBOL_GPL(compat_schedule_work);
+
+int compat_schedule_work_on(int cpu, struct work_struct *work)
+{
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
+	return queue_work_on(cpu, system_wq, work);
+#else
+	return queue_work(system_wq, work);
+#endif
+}
+EXPORT_SYMBOL_GPL(compat_schedule_work_on);
+
+int compat_schedule_delayed_work(struct delayed_work *dwork,
+                                 unsigned long delay)
+{
+	return queue_delayed_work(system_wq, dwork, delay);
+}
+EXPORT_SYMBOL_GPL(compat_schedule_delayed_work);
+
+int compat_schedule_delayed_work_on(int cpu,
+                                    struct delayed_work *dwork,
+                                    unsigned long delay)
+{
+	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
+}
+EXPORT_SYMBOL_GPL(compat_schedule_delayed_work_on);
+
+void compat_flush_scheduled_work(void)
+{
+	/*
+	 * It is debatable which one we should prioritize first, lets
+	 * go with the old kernel's one first for now (keventd_wq) and
+	 * if think its reasonable later we can flip this around.
+	 */
+	flush_workqueue(system_wq);
+	flush_scheduled_work();
+}
+EXPORT_SYMBOL_GPL(compat_flush_scheduled_work);
+
 void compat_system_workqueue_create()
 {
+	system_wq = alloc_workqueue("events", 0, 0);
+	system_long_wq = alloc_workqueue("events_long", 0, 0);
 	system_nrt_wq = create_singlethread_workqueue("events_nrt");
-	WARN_ON(!system_nrt_wq);
+	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
 }
 
 void compat_system_workqueue_destroy()
 {
+	destroy_workqueue(system_wq);
+	destroy_workqueue(system_long_wq);
 	destroy_workqueue(system_nrt_wq);
 }
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 314fb35..4768e63 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -137,11 +137,43 @@ static inline void skb_tx_timestamp(struct sk_buff *skb)
 {
 }
 
+/*
+ * System-wide workqueues which are always present.
+ *
+ * system_wq is the one used by schedule[_delayed]_work[_on]().
+ * Multi-CPU multi-threaded.  There are users which expect relatively
+ * short queue flush time.  Don't queue works which can run for too
+ * long.
+ *
+ * system_long_wq is similar to system_wq but may host long running
+ * works.  Queue flushing might take relatively long.
+ *
+ * system_nrt_wq is non-reentrant and guarantees that any given work
+ * item is never executed in parallel by multiple CPUs.  Queue
+ * flushing might take relatively long.
+ */
+extern struct workqueue_struct *system_wq;
+extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_nrt_wq;
 
 void compat_system_workqueue_create(void);
 void compat_system_workqueue_destroy(void);
 
+int compat_schedule_work(struct work_struct *work);
+int compat_schedule_work_on(int cpu, struct work_struct *work);
+int compat_schedule_delayed_work(struct delayed_work *dwork,
+				 unsigned long delay);
+int compat_schedule_delayed_work_on(int cpu,
+				    struct delayed_work *dwork,
+				    unsigned long delay);
+void compat_flush_scheduled_work(void);
+
+#define schedule_work(work) compat_schedule_work(work)
+#define schedule_work_on(cpu, work) compat_schedule_work_on(cpu, work)
+#define schedule_delayed_work(dwork, delay) compat_schedule_delayed_work(dwork, delay)
+#define schedule_delayed_work_on(cpu, dwork, delay) compat_schedule_delayed_work_on(cpu, dwork, delay)
+#define flush_scheduled_work(a) compat_flush_scheduled_work(a)
+
 #define br_port_exists(dev)	(dev->br_port)
 
 #else
-- 
1.7.10.rc1.22.gf5241

