Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1G0Jzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:55:52 -0400
Received: from narfation.org ([79.140.41.39]:43151 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab1G0Jzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:55:47 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Subject: [PATCHv4 04/11] PM: Use *_dec_not_zero instead of *_add_unless
Date: Wed, 27 Jul 2011 11:47:43 +0200
Message-Id: <1311760070-21532-4-git-send-email-sven@narfation.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311760070-21532-1-git-send-email-sven@narfation.org>
References: <1311760070-21532-1-git-send-email-sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_dec_not_zero is defined for each architecture through
<linux/atomic.h> to provide the functionality of
atomic_add_unless(x, -1, 0).

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org
---
 drivers/base/power/runtime.c |    4 ++--
 include/linux/pm_runtime.h   |    2 +-
 kernel/power/hibernate.c     |    4 ++--
 kernel/power/user.c          |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 8dc247c..bda10d9 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -401,7 +401,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 
 		if (dev->parent) {
 			parent = dev->parent;
-			atomic_add_unless(&parent->power.child_count, -1, 0);
+			atomic_dec_not_zero(&parent->power.child_count);
 		}
 	}
 	wake_up_all(&dev->power.wait_queue);
@@ -841,7 +841,7 @@ int __pm_runtime_set_status(struct device *dev, unsigned int status)
 	if (status == RPM_SUSPENDED) {
 		/* It always is possible to set the status to 'suspended'. */
 		if (parent) {
-			atomic_add_unless(&parent->power.child_count, -1, 0);
+			atomic_dec_not_zero(&parent->power.child_count);
 			notify_parent = !parent->power.ignore_children;
 		}
 		goto out_set;
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index daac05d..3b4931c 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -63,7 +63,7 @@ static inline void pm_runtime_get_noresume(struct device *dev)
 
 static inline void pm_runtime_put_noidle(struct device *dev)
 {
-	atomic_add_unless(&dev->power.usage_count, -1, 0);
+	atomic_dec_not_zero(&dev->power.usage_count);
 }
 
 static inline bool device_run_wake(struct device *dev)
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 8f7b1db..0ba8d87 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -606,7 +606,7 @@ int hibernate(void)
 
 	mutex_lock(&pm_mutex);
 	/* The snapshot device should not be opened while we're running */
-	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
+	if (!atomic_dec_not_zero(&snapshot_device_available)) {
 		error = -EBUSY;
 		goto Unlock;
 	}
@@ -756,7 +756,7 @@ static int software_resume(void)
 		goto Unlock;
 
 	/* The snapshot device should not be opened while we're running */
-	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
+	if (!atomic_dec_not_zero(&snapshot_device_available)) {
 		error = -EBUSY;
 		swsusp_close(FMODE_READ);
 		goto Unlock;
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 42ddbc6..1c1cc01 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -72,7 +72,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 
 	mutex_lock(&pm_mutex);
 
-	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
+	if (!atomic_dec_not_zero(&snapshot_device_available)) {
 		error = -EBUSY;
 		goto Unlock;
 	}
-- 
1.7.5.4

