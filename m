Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030421Ab2CTD1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:27:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45039 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570Ab2CTD1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:27:15 -0400
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 2/4] compat: backport work_busy()
Date: Mon, 19 Mar 2012 20:26:59 -0700
Message-Id: <1332214021-9716-3-git-send-email-mcgrof@frijolero.org>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
In-Reply-To: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

Best we can do is just tell the users of we are WORK_BUSY_PENDING
for older kernels. The ckmake log:

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

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 compat/compat-2.6.36.c        |   24 ++++++++++++++++++++++++
 include/linux/compat-2.6.28.h |    4 ++++
 include/linux/compat-2.6.36.h |    8 ++++++++
 3 files changed, 36 insertions(+)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index b79609c..9190ecd 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -145,6 +145,30 @@ void compat_flush_scheduled_work(void)
 }
 EXPORT_SYMBOL_GPL(compat_flush_scheduled_work);
 
+/**
+ * work_busy - test whether a work is currently pending or running
+ * @work: the work to be tested
+ *
+ * Test whether @work is currently pending or running.  There is no
+ * synchronization around this function and the test result is
+ * unreliable and only useful as advisory hints or for debugging.
+ * Especially for reentrant wqs, the pending state might hide the
+ * running state.
+ *
+ * RETURNS:
+ * OR'd bitmask of WORK_BUSY_* bits.
+ */
+unsigned int work_busy(struct work_struct *work)
+{
+	unsigned int ret = 0;
+
+	if (work_pending(work))
+		ret |= WORK_BUSY_PENDING;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(work_busy);
+
 void compat_system_workqueue_create()
 {
 	system_wq = alloc_workqueue("events", 0, 0);
diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index c0ca70b..e336f39 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -9,6 +9,8 @@
 #include <linux/if_ether.h>
 #include <linux/usb.h>
 #include <linux/types.h>
+#include <linux/types.h>
+#include <linux/cpumask.h>
 
 #ifndef ETH_P_PAE
 #define ETH_P_PAE 0x888E      /* Port Access Entity (IEEE 802.1X) */
@@ -16,6 +18,8 @@
 
 #include <linux/pci.h>
 
+typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } compat_cpumask_t;
+
 #if defined(CONFIG_X86) || defined(CONFIG_X86_64) || defined(CONFIG_PPC)
 /*
  * CONFIG_PHYS_ADDR_T_64BIT was added as new to all architectures
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 4768e63..56d5961 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -168,6 +168,14 @@ int compat_schedule_delayed_work_on(int cpu,
 				    unsigned long delay);
 void compat_flush_scheduled_work(void);
 
+enum {
+	/* bit mask for work_busy() return values */
+	WORK_BUSY_PENDING       = 1 << 0,
+	WORK_BUSY_RUNNING       = 1 << 1,
+};
+
+extern unsigned int work_busy(struct work_struct *work);
+
 #define schedule_work(work) compat_schedule_work(work)
 #define schedule_work_on(cpu, work) compat_schedule_work_on(cpu, work)
 #define schedule_delayed_work(dwork, delay) compat_schedule_delayed_work(dwork, delay)
-- 
1.7.10.rc1.22.gf5241

