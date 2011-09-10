Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab1IJOiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 10:38:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42584 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab1IJOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 10:38:14 -0400
From: tom.leiming@gmail.com
To: rjw@sisk.pl, stern@rowland.harvard.edu
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/2] PM/runtime: handle ->runtime_suspend failure correctly
Date: Sat, 10 Sep 2011 22:37:22 +0800
Message-Id: <1315665442-4194-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315665442-4194-1-git-send-email-tom.leiming@gmail.com>
References: <1315665442-4194-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

If ->runtime_suspend returns -EAGAIN or -EBUSY, the device should
still be in ACTIVE state, so it is not needed to handle defered
resume and idle notification to its parent; if ->runtime_suspend
returns other fatal failure, it doesn't make sense to process defered
resume and send idle notification to its parent.

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
 drivers/base/power/runtime.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 441b5a3..6fa3241 100644
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
@@ -422,6 +425,9 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 	}
 	wake_up_all(&dev->power.wait_queue);
 
+	if (retval)
+		goto out;
+
 	if (dev->power.deferred_resume) {
 		rpm_resume(dev, 0);
 		retval = -EAGAIN;
-- 
1.7.4.1

