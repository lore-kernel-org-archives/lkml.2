Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1IZTOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:14:31 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55863 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab1IZTON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:14:13 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: [PATCH 1/6] [RFC] suspend: Block suspend when wakeups are in-progress
Date: Mon, 26 Sep 2011 12:13:49 -0700
Message-Id: <1317064434-1829-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current pm_stay_awake/pm_relax api, reads to
/sys/power/wakeup_count will block when pm_stay_awake() has been
called. Then once pm_relax() returns, the read will unblock and return
the wakeup_count value. This value can be echo'ed back into wakeup_count,
and if no other wakeup events have occured, the system can be suspended
by calling "echo mem > /sys/power/state".

This method is somewhat advisory, as if a wakeup event has occured
between the reading of /sys/power/wakeup_count and the attempt to suspend,
that attempt to suspend will fail. However, if a second attmept to suspend
is tried, without checking /sys/power/wakeup_count, the suspend will
succeed.

Similarly, if pm_stay_awake() has been called, and then a suspend is
attepted wihtout checking /sys/power/wakeup_count, the suspend will
succeed, despite the pm_relax() call not having been made.

This patch tries to make the pm_stay_awake() call a bit more enforcing,
such that any attempt to suspend that occurs while a wakeup is in progress
will fail. Once the matching pm_relax() has been called, suspend will
succeed.

This does not change the blocking behavior of /sys/power/wakeup_count,
or the suspend failure if a stale wakeup count has been echo'ed into
the /sys/power/wakeup_count.

Also modified the hibernate path in the same way.

CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: arve@android.com
CC: markgross@thegnar.org
CC: Alan Stern <stern@rowland.harvard.edu>
CC: amit.kucheria@linaro.org
CC: farrowg@sg.ibm.com
CC: Dmitry Fink (Palm GBU) <Dmitry.Fink@palm.com>
CC: linux-pm@lists.linux-foundation.org
CC: khilman@ti.com
CC: Magnus Damm <damm@opensource.se>
CC: mjg@redhat.com 
CC: peterz@infradead.org 
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/base/power/wakeup.c |   13 +++++++++++++
 include/linux/suspend.h     |    3 +++
 kernel/power/hibernate.c    |    5 +++++
 kernel/power/suspend.c      |    5 +++++
 4 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 84f7c7d..0722873 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -580,6 +580,19 @@ static void pm_wakeup_update_hit_counts(void)
 	rcu_read_unlock();
 }
 
+
+bool pm_wakeup_in_progress(void)
+{
+	unsigned int cnt, inpr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&events_lock, flags);
+	split_counters(&cnt, &inpr);
+	spin_unlock_irqrestore(&events_lock, flags);
+
+	return (inpr != 0);
+}
+
 /**
  * pm_wakeup_pending - Check if power transition in progress should be aborted.
  *
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 6bbcef2..c9403a1 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -294,6 +294,7 @@ extern int unregister_pm_notifier(struct notifier_block *nb);
 extern bool events_check_enabled;
 
 extern bool pm_wakeup_pending(void);
+extern bool pm_wakeup_in_progress(void);
 extern bool pm_get_wakeup_count(unsigned int *count);
 extern bool pm_save_wakeup_count(unsigned int count);
 #else /* !CONFIG_PM_SLEEP */
@@ -311,6 +312,8 @@ static inline int unregister_pm_notifier(struct notifier_block *nb)
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 
 static inline bool pm_wakeup_pending(void) { return false; }
+static inline bool pm_wakeup_in_progress(void) { return false; }
+
 #endif /* !CONFIG_PM_SLEEP */
 
 extern struct mutex pm_mutex;
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 8f7b1db..22dc22c 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -611,6 +611,11 @@ int hibernate(void)
 		goto Unlock;
 	}
 
+	if (pm_wakeup_in_progress()) {
+		error = -EBUSY;
+		goto Unlock;
+	}
+
 	pm_prepare_console();
 	error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
 	if (error)
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index b6b71ad..b2dba52 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -281,6 +281,11 @@ int enter_state(suspend_state_t state)
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
+	if (pm_wakeup_in_progress()) {
+		error = -EBUSY;
+		goto Unlock;
+	}
+
 	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
 	printk("done.\n");
-- 
1.7.3.2.146.gca209

