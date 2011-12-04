Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1LDUC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 15:02:58 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55120 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab1LDUC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 15:02:56 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 1/3] PM / Sleep: Make [un]lock_system_sleep() generic
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, ebiederm@xmission.com, tj@kernel.org,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Mon, 05 Dec 2011 01:32:38 +0530
Message-ID: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120410-5140-0000-0000-0000005E7677
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The [un]lock_system_sleep() APIs were originally introduced to mutually
exclude memory hotplug and hibernation.

Directly using mutex_lock(&pm_mutex) to achieve mutual exclusion with
suspend or hibernation code can lead to freezing failures. However, the
APIs [un]lock_system_sleep() can be safely used to achieve the same, without
causing freezing failures.

So, since it would be beneficial to modify all the existing users of
mutex_lock(&pm_mutex) (in all parts of the kernel), so that they use these
safe APIs intead, make these APIs generic by removing the restriction that
they work only when CONFIG_HIBERNATE_CALLBACKS is set. Moreover, that
restriction didn't buy us anything anyway.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |   42 ++++++++++++++++++------------------------
 1 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 1f7fff4..d109847 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -331,6 +331,8 @@ static inline bool system_entering_hibernation(void) { return false; }
 #define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
 #define PM_POST_RESTORE		0x0006 /* Restore failed */
 
+extern struct mutex pm_mutex;
+
 #ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
 void restore_processor_state(void);
@@ -351,6 +353,21 @@ extern bool events_check_enabled;
 extern bool pm_wakeup_pending(void);
 extern bool pm_get_wakeup_count(unsigned int *count);
 extern bool pm_save_wakeup_count(unsigned int count);
+
+static inline void lock_system_sleep(void)
+{
+	/* simplified freezer_do_not_count() */
+	current->flags |= PF_FREEZER_SKIP;
+	mutex_lock(&pm_mutex);
+}
+
+static inline void unlock_system_sleep(void)
+{
+	mutex_unlock(&pm_mutex);
+	/* simplified freezer_count() */
+	current->flags &= ~PF_FREEZER_SKIP;
+}
+
 #else /* !CONFIG_PM_SLEEP */
 
 static inline int register_pm_notifier(struct notifier_block *nb)
@@ -366,32 +383,9 @@ static inline int unregister_pm_notifier(struct notifier_block *nb)
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 
 static inline bool pm_wakeup_pending(void) { return false; }
-#endif /* !CONFIG_PM_SLEEP */
-
-extern struct mutex pm_mutex;
-
-#ifndef CONFIG_HIBERNATE_CALLBACKS
 static inline void lock_system_sleep(void) {}
 static inline void unlock_system_sleep(void) {}
-
-#else
-
-/* Let some subsystems like memory hotadd exclude hibernation */
-
-static inline void lock_system_sleep(void)
-{
-	/* simplified freezer_do_not_count() */
-	current->flags |= PF_FREEZER_SKIP;
-	mutex_lock(&pm_mutex);
-}
-
-static inline void unlock_system_sleep(void)
-{
-	mutex_unlock(&pm_mutex);
-	/* simplified freezer_count() */
-	current->flags &= ~PF_FREEZER_SKIP;
-}
-#endif
+#endif /* !CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_ARCH_SAVE_PAGE_KEYS
 /*

