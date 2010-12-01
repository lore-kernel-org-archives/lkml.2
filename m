Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0LAXv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 18:51:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46316 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab0LAXvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 18:51:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors unnecessarily
Date: Thu, 2 Dec 2010 00:50:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>
References: <Pine.LNX.4.44L0.1012011013500.1629-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1012011013500.1629-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012020050.31171.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 01, 2010, Alan Stern wrote:
> On Tue, 30 Nov 2010, Rafael J. Wysocki wrote:
> 
> > > Provided you repair the error that Lei Ming pointed out.  That's the 
> > > problem with functions that return Boolean values -- you have to name 
> > > them very carefully.  Ideally the name should be a predicate or a
> > > question.
> > 
> > I already have fixed it.
> > 
> > The name is unfortunate indeed, perhaps it's better to call that function
> > pm_new_wakeup_events() or something like this.
> 
> Or pm_any_wakeup_events().  And reverse the meaning of the return
> value, of course -- it would be good to explain the return value in 
> the kerneldoc.

OK, so please let me know what you think of the appended patch (on top of the
previous one).

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Wakeup: Replace pm_check_wakeup_events() with pm_wakeup_pending()

To avoid confusion with the meaning and return value of
pm_check_wakeup_events() replace it with pm_wakeup_pending() that
will work the other way around (ie. return true when system-wide
power transition should be aborted).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c   |    2 +-
 drivers/base/power/wakeup.c |   20 ++++++++++----------
 include/linux/suspend.h     |    4 ++--
 kernel/power/hibernate.c    |    4 ++--
 kernel/power/process.c      |    2 +-
 kernel/power/suspend.c      |    2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -542,26 +542,26 @@ static void pm_wakeup_update_hit_counts(
 }
 
 /**
- * pm_check_wakeup_events - Check for new wakeup events.
+ * pm_wakeup_pending - Check if power transition in progress should be aborted.
  *
  * Compare the current number of registered wakeup events with its preserved
- * value from the past to check if new wakeup events have been registered since
- * the old value was stored.  Check if the current number of wakeup events being
- * processed is zero.
+ * value from the past and return true if new wakeup events have been registered
+ * since the old value was stored.  Also return true if the current number of
+ * wakeup events being processed is different from zero.
  */
-bool pm_check_wakeup_events(void)
+bool pm_wakeup_pending(void)
 {
 	unsigned long flags;
-	bool ret = true;
+	bool ret = false;
 
 	spin_lock_irqsave(&events_lock, flags);
 	if (events_check_enabled) {
-		ret = ((unsigned int)atomic_read(&event_count) == saved_count)
-			&& !atomic_read(&events_in_progress);
-		events_check_enabled = ret;
+		ret = ((unsigned int)atomic_read(&event_count) != saved_count)
+			|| atomic_read(&events_in_progress);
+		events_check_enabled = !ret;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
-	if (!ret)
+	if (ret)
 		pm_wakeup_update_hit_counts();
 	return ret;
 }
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -292,7 +292,7 @@ extern int unregister_pm_notifier(struct
 /* drivers/base/power/wakeup.c */
 extern bool events_check_enabled;
 
-extern bool pm_check_wakeup_events(void);
+extern bool pm_wakeup_pending(void);
 extern bool pm_get_wakeup_count(unsigned int *count);
 extern bool pm_save_wakeup_count(unsigned int count);
 #else /* !CONFIG_PM_SLEEP */
@@ -309,7 +309,7 @@ static inline int unregister_pm_notifier
 
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 
-static inline bool pm_check_wakeup_events(void) { return true; }
+static inline bool pm_wakeup_pending(void) { return true; }
 #endif /* !CONFIG_PM_SLEEP */
 
 extern struct mutex pm_mutex;
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -1056,7 +1056,7 @@ static int dpm_prepare(pm_message_t stat
 		if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
 			pm_wakeup_event(dev, 0);
 
-		if (!pm_check_wakeup_events()) {
+		if (pm_wakeup_pending()) {
 			pm_runtime_put_sync(dev);
 			error = -EBUSY;
 		} else {
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -278,7 +278,7 @@ static int create_image(int platform_mod
 		goto Enable_irqs;
 	}
 
-	if (hibernation_test(TEST_CORE) || !pm_check_wakeup_events())
+	if (hibernation_test(TEST_CORE) || pm_wakeup_pending())
 		goto Power_up;
 
 	in_suspend = 1;
@@ -516,7 +516,7 @@ int hibernation_platform_enter(void)
 
 	local_irq_disable();
 	sysdev_suspend(PMSG_HIBERNATE);
-	if (!pm_check_wakeup_events()) {
+	if (pm_wakeup_pending()) {
 		error = -EAGAIN;
 		goto Power_up;
 	}
Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c
+++ linux-2.6/kernel/power/process.c
@@ -85,7 +85,7 @@ static int try_to_freeze_tasks(bool sig_
 		if (!todo || time_after(jiffies, end_time))
 			break;
 
-		if (!pm_check_wakeup_events()) {
+		if (pm_wakeup_pending()) {
 			wakeup = true;
 			break;
 		}
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -163,7 +163,7 @@ static int suspend_enter(suspend_state_t
 
 	error = sysdev_suspend(PMSG_SUSPEND);
 	if (!error) {
-		if (!suspend_test(TEST_CORE) && pm_check_wakeup_events()) {
+		if (!(suspend_test(TEST_CORE) || pm_wakeup_pending())) {
 			error = suspend_ops->enter(state);
 			events_check_enabled = false;
 		}
