Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab1IVBde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 21:33:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51094 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1IVBdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 21:33:33 -0400
From: tom.leiming@gmail.com
To: rjw@sisk.pl, stern@rowland.harvard.edu
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/2] PM/runtime: handle ->runtime_suspend failure correctly
Date: Thu, 22 Sep 2011 09:33:16 +0800
Message-Id: <1316655196-4087-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315665442-4194-1-git-send-email-tom.leiming@gmail.com>
References: <1315665442-4194-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

If ->runtime_suspend returns -EAGAIN or -EBUSY, the device should
still be in ACTIVE state, so it is not needed to send idle notification
to its parent; if ->runtime_suspend returns other fatal failure, it
doesn't make sense to send idle notification to its parent.

So skip these when failure is returned from ->runtime_suspend, also add
comments for this handling in rpm_suspend.

This patch also updates comments for rpm_suspend:

- 'Cancel a pending idle notification' should be put before, also
should be changed as 'Cancel a pending idle notification or
autosuspend/suspend'

- idle notification for suspend failure has been removed, so update
comments for it

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
v1: some minor change on Alan's suggestion
---
 drivers/base/power/runtime.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 441b5a3..e3c6a8f 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -284,14 +284,17 @@ static int rpm_callback(int (*cb)(struct device *), struct device *dev)
  * @dev: Device to suspend.
  * @rpmflags: Flag bits.
  *
- * Check if the device's runtime PM status allows it to be suspended.  If
- * another suspend has been started earlier, either return immediately or wait
- * for it to finish, depending on the RPM_NOWAIT and RPM_ASYNC flags.  Cancel a
- * pending idle notification.  If the RPM_ASYNC flag is set then queue a
- * suspend request; otherwise run the ->runtime_suspend() callback directly.
- * If a deferred resume was requested while the callback was running then carry
- * it out; otherwise send an idle notification for the device (if the suspend
- * failed) or for its parent (if the suspend succeeded).
+ * Check if the device's runtime PM status allows it to be suspended. Cancel
+ * a pending idle notification or autosuspend/suspend. If another suspend has
+ * been started earlier, either return immediately or wait for it to finish,
+ * depending on the RPM_NOWAIT and RPM_ASYNC flags. If the RPM_ASYNC flag is
+ * set then queue a suspend request; otherwise run the ->runtime_suspend()
+ * callback directly. If ->runtime_suspend returns failure, just cancel
+ * pending request and wake up waited tasks, then return immediatelly.
+ * After ->runtime_suspend succeeded, if a deferred resume was requested
+ * while the callback was running then carry it out; otherwise send an idle
+ * notification for its parent (if both ignore_children and irq_safe
+ * are not set).
  *
  * This function must be called under dev->power.lock with interrupts disabled.
  */
@@ -410,15 +413,16 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 			dev->power.runtime_error = 0;
 		else
 			pm_runtime_cancel_pending(dev);
-	} else {
+		wake_up_all(&dev->power.wait_queue);
+		goto out;
+	}
  no_callback:
-		__update_runtime_status(dev, RPM_SUSPENDED);
-		pm_runtime_deactivate_timer(dev);
+	__update_runtime_status(dev, RPM_SUSPENDED);
+	pm_runtime_deactivate_timer(dev);
 
-		if (dev->parent) {
-			parent = dev->parent;
-			atomic_add_unless(&parent->power.child_count, -1, 0);
-		}
+	if (dev->parent) {
+		parent = dev->parent;
+		atomic_add_unless(&parent->power.child_count, -1, 0);
 	}
 	wake_up_all(&dev->power.wait_queue);
 
-- 
1.7.4.1

