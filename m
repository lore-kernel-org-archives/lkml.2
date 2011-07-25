Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1GYU4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:56:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26793 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1GYU43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:56:29 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@lists.linux-foundation.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Nishanth Menon <nm@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Colin Cross <ccross@android.com>
Subject: [PATCH v2] PM: runtime: add might_sleep to PM runtime functions
Date: Mon, 25 Jul 2011 13:55:44 -0700
Message-Id: <1311627344-8097-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the entry points to pm runtime are not safe to
call in atomic context unless pm_runtime_irq_safe() has
been called.  Inspecting the code, it is not immediately
obvious that the functions sleep at all, as they run
inside a spin_lock_irqsave, but under some conditions
they can drop the lock and turn on irqs.

If a driver incorrectly calls the pm_runtime apis, it can
cause sleeping and irq processing when it expects to stay
in atomic context.

Add might_sleep_if to all the __pm_runtime_* entry points
to enforce correct usage.

Add pm_runtime_put_sync_autosuspend to the list of
functions that can be called in atomic context.

Signed-off-by: Colin Cross <ccross@android.com>
---
 Documentation/power/runtime_pm.txt |    1 +
 drivers/base/power/runtime.c       |   15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index c291233..1ad507c 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -469,6 +469,7 @@ pm_runtime_resume()
 pm_runtime_get_sync()
 pm_runtime_put_sync()
 pm_runtime_put_sync_suspend()
+pm_runtime_put_sync_autosuspend()
 
 5. Run-time PM Initialization, Device Probing and Removal
 
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 2e746f8..f3d8583 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -731,13 +731,16 @@ EXPORT_SYMBOL_GPL(pm_schedule_suspend);
  * return immediately if it is larger than zero.  Then carry out an idle
  * notification, either synchronous or asynchronous.
  *
- * This routine may be called in atomic context if the RPM_ASYNC flag is set.
+ * This routine may be called in atomic context if the RPM_ASYNC flag is set,
+ * or if pm_runtime_irq_safe() has been called.
  */
 int __pm_runtime_idle(struct device *dev, int rpmflags)
 {
 	unsigned long flags;
 	int retval;
 
+	might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
+
 	if (rpmflags & RPM_GET_PUT) {
 		if (!atomic_dec_and_test(&dev->power.usage_count))
 			return 0;
@@ -760,13 +763,16 @@ EXPORT_SYMBOL_GPL(__pm_runtime_idle);
  * return immediately if it is larger than zero.  Then carry out a suspend,
  * either synchronous or asynchronous.
  *
- * This routine may be called in atomic context if the RPM_ASYNC flag is set.
+ * This routine may be called in atomic context if the RPM_ASYNC flag is set,
+ * or if pm_runtime_irq_safe() has been called.
  */
 int __pm_runtime_suspend(struct device *dev, int rpmflags)
 {
 	unsigned long flags;
 	int retval;
 
+	might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
+
 	if (rpmflags & RPM_GET_PUT) {
 		if (!atomic_dec_and_test(&dev->power.usage_count))
 			return 0;
@@ -788,13 +794,16 @@ EXPORT_SYMBOL_GPL(__pm_runtime_suspend);
  * If the RPM_GET_PUT flag is set, increment the device's usage count.  Then
  * carry out a resume, either synchronous or asynchronous.
  *
- * This routine may be called in atomic context if the RPM_ASYNC flag is set.
+ * This routine may be called in atomic context if the RPM_ASYNC flag is set,
+ * or if pm_runtime_irq_safe() has been called.
  */
 int __pm_runtime_resume(struct device *dev, int rpmflags)
 {
 	unsigned long flags;
 	int retval;
 
+	might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
+
 	if (rpmflags & RPM_GET_PUT)
 		atomic_inc(&dev->power.usage_count);
 
-- 
1.7.4.1

