Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab1JLDy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 23:54:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59788 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1JLDyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 23:54:25 -0400
From: ming.lei@canonical.com
To: rjw@sisk.pl
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/2] PM/runtime: handle ->runtime_suspend failure correctly
Date: Wed, 12 Oct 2011 11:53:33 +0800
Message-Id: <1318391613-24364-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318391613-24364-1-git-send-email-ming.lei@canonical.com>
References: <1318391613-24364-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <ming.lei@canonical.com>

If ->runtime_suspend returns -EAGAIN or -EBUSY, the device should
still be in ACTIVE state, so it is not needed to send idle notification
to its parent; if ->runtime_suspend returns other fatal failure, it
doesn't make sense to send idle notification to its parent.

So skip these when failure is returned from ->runtime_suspend, also
update comments for this handling in rpm_suspend.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/power/runtime.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index aa23a64..6bb3aaf 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -291,11 +291,11 @@ static int rpm_callback(int (*cb)(struct device *), struct device *dev)
  * another suspend has been started earlier, either return immediately
  * or wait for it to finish, depending on the RPM_NOWAIT and RPM_ASYNC
  * flags. If the RPM_ASYNC flag is set then queue a suspend request;
- * otherwise run the ->runtime_suspend() callback directly. If a deferred
- * resume was requested while the callback was running then carry it out;
- * otherwise send an idle notification for its parent (if the suspend
- * succeeded and both ignore_children of parent->power and irq_safe of
- * dev->power are not set).
+ * otherwise run the ->runtime_suspend() callback directly. When
+ * ->runtime_suspend succeeded, if a deferred resume was requested while
+ * the callback was running then carry it out, otherwise send an idle
+ * notification for its parent (if the suspend succeeded and both
+ * ignore_children of parent->power and irq_safe of dev->power are not set).
  *
  * This function must be called under dev->power.lock with interrupts disabled.
  */
@@ -420,15 +420,16 @@ static int rpm_suspend(struct device *dev, int rpmflags)
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
1.7.5.4

