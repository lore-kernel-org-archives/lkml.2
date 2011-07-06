Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1GFVBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:01:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33641 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab1GFVBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:01:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/5 v1] PM / Domains: Allow callbacks to execute arbitrary runtime PM helpers
Date: Wed, 6 Jul 2011 23:00:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>
References: <201107062248.35586.rjw@sisk.pl>
In-Reply-To: <201107062248.35586.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107062300.08884.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

A deadlock may occur if one of the PM domains' .start_device() or
.stop_device() callbacks or a device driver's .runtime_suspend() or
.runtime_resume() callback executed by the core generic PM domain
code uses a "wrong" runtime PM helper function.  This happens, for
example, if .runtime_resume() from one device's driver calls
pm_runtime_resume() for another device in the same PM domain.
A similar situation may take place if a device's parent is in the
same PM domain, in which case the runtime PM framework may execute
pm_genpd_runtime_resume() automatically for the parent (if it is
suspended at the moment).  This, of course, is undesirable, so
the generic PM domains code should be modified to prevent it from
happening.

The runtime PM framework guarantees that pm_genpd_runtime_suspend()
and pm_genpd_runtime_resume() won't be executed in parallel for
the same device, so the generic PM domains code need not worry
about those cases.  Still, it needs to prevent the other possible
race conditions between pm_genpd_runtime_suspend(),
pm_genpd_runtime_resume(), pm_genpd_poweron() and pm_genpd_poweroff()
from happening and it needs to avoid deadlocks at the same time.
To this end, modify the generic PM domains code to relax
synchronization rules so that:

* pm_genpd_poweron() doesn't wait for the PM domain status to
  change from GPD_STATE_BUSY.  If it finds that the status is
  not GPD_STATE_POWER_OFF, it returns without powering the domain on
  (it may modify the status depending on the circumstances).

* pm_genpd_poweroff() returns as soon as it finds that the PM
  domain's status changed from GPD_STATE_BUSY after it's released
  the PM domain's lock.

* pm_genpd_runtime_suspend() doesn't wait for the PM domain status
  to change from GPD_STATE_BUSY after executing the domain's
  .stop_device() callback and executes pm_genpd_poweroff() only
  if pm_genpd_runtime_resume() is not executed in parallel.

* pm_genpd_runtime_resume() doesn't wait for the PM domain status
  to change from GPD_STATE_BUSY after executing pm_genpd_poweron()
  and sets the domain's status to GPD_STATE_BUSY and increments its
  counter of resuming devices (introduced by this change) immediately
  after acquiring the lock.  The counter of resuming devices is then
  decremented after executing __pm_genpd_runtime_resume() for the
  device and the domain's status is reset to GPD_STATE_ACTIVE (unless
  there are more resuming devices in the domain, in which case the
  status remains GPD_STATE_BUSY).

This way, for example, if a device driver's .runtime_resume()
callback executes pm_runtime_resume() for another device in the same
PM domain, pm_genpd_poweron() called by pm_genpd_runtime_resume()
invoked by the runtime PM framework will not block and it will see
that there's nothing to do for it.  Next, the PM domain's lock will
be taken without waiting for its status to change from GPD_STATE_BUSY
and the device driver's .runtime_resume() callback will be executed.
In turn, if pm_runtime_suspend() is executed by one device driver's
.runtime_resume() callback for another device in the same PM domain,
pm_genpd_runtime_suspend() invoked by the runtime PM framework as
a result will notice that one of the devices in the domain is being
resumed, so it won't call pm_genpd_poweroff().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   97 +++++++++++++++++++++++++++-----------------
 include/linux/pm_domain.h   |    1 
 2 files changed, 62 insertions(+), 36 deletions(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -60,6 +60,12 @@ static void genpd_release_lock(struct ge
 	mutex_unlock(&genpd->lock);
 }
 
+static void genpd_set_active(struct generic_pm_domain *genpd)
+{
+	if (genpd->resume_count == 0)
+		genpd->status = GPD_STATE_ACTIVE;
+}
+
 /**
  * pm_genpd_poweron - Restore power to a given PM domain and its parents.
  * @genpd: PM domain to power up.
@@ -75,42 +81,24 @@ static int pm_genpd_poweron(struct gener
 
  start:
 	if (parent) {
-		mutex_lock(&parent->lock);
+		genpd_acquire_lock(parent);
 		mutex_lock_nested(&genpd->lock, SINGLE_DEPTH_NESTING);
 	} else {
 		mutex_lock(&genpd->lock);
 	}
-	/*
-	 * Wait for the domain to transition into either the active,
-	 * or the power off state.
-	 */
-	for (;;) {
-		prepare_to_wait(&genpd->status_wait_queue, &wait,
-				TASK_UNINTERRUPTIBLE);
-		if (genpd->status != GPD_STATE_BUSY)
-			break;
-		mutex_unlock(&genpd->lock);
-		if (parent)
-			mutex_unlock(&parent->lock);
-
-		schedule();
-
-		if (parent) {
-			mutex_lock(&parent->lock);
-			mutex_lock_nested(&genpd->lock, SINGLE_DEPTH_NESTING);
-		} else {
-			mutex_lock(&genpd->lock);
-		}
-	}
-	finish_wait(&genpd->status_wait_queue, &wait);
 
 	if (genpd->status == GPD_STATE_ACTIVE
 	    || (genpd->prepared_count > 0 && genpd->suspend_power_off))
 		goto out;
 
+	if (genpd->status == GPD_STATE_BUSY) {
+		genpd_set_active(genpd);
+		goto out;
+	}
+
 	if (parent && parent->status != GPD_STATE_ACTIVE) {
 		mutex_unlock(&genpd->lock);
-		mutex_unlock(&parent->lock);
+		genpd_release_lock(parent);
 
 		ret = pm_genpd_poweron(parent);
 		if (ret)
@@ -125,14 +113,14 @@ static int pm_genpd_poweron(struct gener
 			goto out;
 	}
 
-	genpd->status = GPD_STATE_ACTIVE;
+	genpd_set_active(genpd);
 	if (parent)
 		parent->sd_count++;
 
  out:
 	mutex_unlock(&genpd->lock);
 	if (parent)
-		mutex_unlock(&parent->lock);
+		genpd_release_lock(parent);
 
 	return ret;
 }
@@ -210,6 +198,20 @@ static void __pm_genpd_restore_device(st
 }
 
 /**
+ * genpd_abort_poweroff - Check if a PM domain power off should be aborted.
+ * @genpd: PM domain to check.
+ *
+ * Return true if a PM domain's status changed from GPD_STATE_BUSY during
+ * a "power off" operation, which means that a "power on" has occured in the
+ * meantime, or if its resume_count field is different from zero, which means
+ * that one of its devices has been resumed in the meantime.
+ */
+static bool genpd_abort_poweroff(struct generic_pm_domain *genpd)
+{
+	return genpd->status != GPD_STATE_BUSY || genpd->resume_count > 0;
+}
+
+/**
  * pm_genpd_poweroff - Remove power from a given PM domain.
  * @genpd: PM domain to power down.
  *
@@ -239,6 +241,14 @@ static int pm_genpd_poweroff(struct gene
 	if (not_suspended > genpd->in_progress)
 		return -EBUSY;
 
+	/*
+	 * Check if another instance of pm_genpd_poweroff() for the same domain
+	 * that has already started to call drivers' runtime suspend routines
+	 * is running in parallel with us.
+	 */
+	if (genpd->status == GPD_STATE_BUSY)
+		return 0;
+
 	if (genpd->gov && genpd->gov->power_down_ok) {
 		if (!genpd->gov->power_down_ok(&genpd->domain))
 			return -EAGAIN;
@@ -250,6 +260,9 @@ static int pm_genpd_poweroff(struct gene
 		ret = __pm_genpd_save_device(dle, genpd);
 		if (ret)
 			goto err_dev;
+
+		if (genpd_abort_poweroff(genpd))
+			return 0;
 	}
 
 	mutex_unlock(&genpd->lock);
@@ -262,6 +275,13 @@ static int pm_genpd_poweroff(struct gene
 		mutex_lock(&genpd->lock);
 	}
 
+	if (genpd_abort_poweroff(genpd)) {
+		if (parent)
+			genpd_release_lock(parent);
+
+		return 0;
+	}
+
 	if (genpd->power_off)
 		genpd->power_off(genpd);
 
@@ -282,7 +302,7 @@ static int pm_genpd_poweroff(struct gene
 	list_for_each_entry_continue(dle, &genpd->dev_list, node)
 		__pm_genpd_restore_device(dle, genpd);
 
-	genpd->status = GPD_STATE_ACTIVE;
+	genpd_set_active(genpd);
 	wake_up_all(&genpd->status_wait_queue);
 
 	return ret;
@@ -327,11 +347,13 @@ static int pm_genpd_runtime_suspend(stru
 			return ret;
 	}
 
-	genpd_acquire_lock(genpd);
-	genpd->in_progress++;
-	pm_genpd_poweroff(genpd);
-	genpd->in_progress--;
-	genpd_release_lock(genpd);
+	mutex_lock(&genpd->lock);
+	if (genpd->resume_count == 0) {
+		genpd->in_progress++;
+		pm_genpd_poweroff(genpd);
+		genpd->in_progress--;
+	}
+	mutex_unlock(&genpd->lock);
 
 	return 0;
 }
@@ -377,12 +399,14 @@ static int pm_genpd_runtime_resume(struc
 	if (ret)
 		return ret;
 
-	genpd_acquire_lock(genpd);
+	mutex_lock(&genpd->lock);
 	genpd->status = GPD_STATE_BUSY;
+	genpd->resume_count++;
 	__pm_genpd_runtime_resume(dev, genpd);
-	genpd->status = GPD_STATE_ACTIVE;
+	genpd->resume_count--;
+	genpd_set_active(genpd);
 	wake_up_all(&genpd->status_wait_queue);
-	genpd_release_lock(genpd);
+	mutex_unlock(&genpd->lock);
 
 	if (genpd->start_device)
 		genpd->start_device(dev);
@@ -1122,6 +1146,7 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->sd_count = 0;
 	genpd->status = is_off ? GPD_STATE_POWER_OFF : GPD_STATE_ACTIVE;
 	init_waitqueue_head(&genpd->status_wait_queue);
+	genpd->resume_count = 0;
 	genpd->device_count = 0;
 	genpd->suspended_count = 0;
 	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -34,6 +34,7 @@ struct generic_pm_domain {
 	unsigned int sd_count;	/* Number of subdomains with power "on" */
 	enum gpd_status status;	/* Current state of the domain */
 	wait_queue_head_t status_wait_queue;
+	unsigned int resume_count;	/* Number of devices being resumed */
 	unsigned int device_count;	/* Number of devices */
 	unsigned int suspended_count;	/* System suspend device counter */
 	unsigned int prepared_count;	/* Suspend counter of prepared devices */

