Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1GaRxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:53:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36729 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab1GaRww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:52:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/9] PM / Domains: Do not take parent locks to modify subdomain counters
Date: Sun, 31 Jul 2011 19:48:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
References: <201107311946.06654.rjw@sisk.pl>
In-Reply-To: <201107311946.06654.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107311948.26609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After the subdomain counter in struct generic_pm_domain has been
changed into an atomic_t field, it is possible to modify
pm_genpd_poweron() and pm_genpd_poweroff() so that they don't take
the parents locks.  This requires pm_genpd_poweron() to increment
the parent's subdomain counter before calling itself recursively
for the parent and to decrement it if an error is to be returned.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   70 +++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 39 deletions(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -93,12 +93,7 @@ int pm_genpd_poweron(struct generic_pm_d
 	int ret = 0;
 
  start:
-	if (parent) {
-		genpd_acquire_lock(parent);
-		mutex_lock_nested(&genpd->lock, SINGLE_DEPTH_NESTING);
-	} else {
-		mutex_lock(&genpd->lock);
-	}
+	mutex_lock(&genpd->lock);
 
 	if (genpd->status == GPD_STATE_ACTIVE
 	    || (genpd->prepared_count > 0 && genpd->suspend_power_off))
@@ -109,31 +104,33 @@ int pm_genpd_poweron(struct generic_pm_d
 		goto out;
 	}
 
-	if (parent && parent->status != GPD_STATE_ACTIVE) {
+	if (parent) {
+		genpd_sd_counter_inc(parent);
+
 		mutex_unlock(&genpd->lock);
-		genpd_release_lock(parent);
 
 		ret = pm_genpd_poweron(parent);
-		if (ret)
+		if (ret) {
+			genpd_sd_counter_dec(parent);
 			return ret;
+		}
 
+		parent = NULL;
 		goto start;
 	}
 
-	if (genpd->power_on) {
+	if (genpd->power_on)
 		ret = genpd->power_on(genpd);
-		if (ret)
-			goto out;
-	}
 
-	genpd_set_active(genpd);
-	if (parent)
-		genpd_sd_counter_inc(parent);
+	if (ret) {
+		if (genpd->parent)
+			genpd_sd_counter_dec(genpd->parent);
+	} else {
+		genpd_set_active(genpd);
+	}
 
  out:
 	mutex_unlock(&genpd->lock);
-	if (parent)
-		genpd_release_lock(parent);
 
 	return ret;
 }
@@ -293,7 +290,8 @@ static int pm_genpd_poweroff(struct gene
 	genpd->poweroff_task = current;
 
 	list_for_each_entry_reverse(dle, &genpd->dev_list, node) {
-		ret = __pm_genpd_save_device(dle, genpd);
+		ret = atomic_read(&genpd->sd_count) == 0 ?
+			__pm_genpd_save_device(dle, genpd) : -EBUSY;
 		if (ret) {
 			genpd_set_active(genpd);
 			goto out;
@@ -308,38 +306,32 @@ static int pm_genpd_poweroff(struct gene
 		}
 	}
 
-	parent = genpd->parent;
-	if (parent) {
-		mutex_unlock(&genpd->lock);
-
-		genpd_acquire_lock(parent);
-		mutex_lock_nested(&genpd->lock, SINGLE_DEPTH_NESTING);
-
-		if (genpd_abort_poweroff(genpd)) {
-			genpd_release_lock(parent);
+	if (genpd->power_off) {
+		if (atomic_read(&genpd->sd_count) > 0) {
+			ret = -EBUSY;
 			goto out;
 		}
-	}
 
-	if (genpd->power_off) {
+		/*
+		 * If sd_count > 0 at this point, one of the children hasn't
+		 * managed to call pm_genpd_poweron() for the parent yet after
+		 * incrementing it.  In that case pm_genpd_poweron() will wait
+		 * for us to drop the lock, so we can call .power_off() and let
+		 * the pm_genpd_poweron() restore power for us (this shouldn't
+		 * happen very often).
+		 */
 		ret = genpd->power_off(genpd);
 		if (ret == -EBUSY) {
 			genpd_set_active(genpd);
-			if (parent)
-				genpd_release_lock(parent);
-
 			goto out;
 		}
 	}
 
 	genpd->status = GPD_STATE_POWER_OFF;
 
-	if (parent) {
-		if (genpd_sd_counter_dec(parent))
-			genpd_queue_power_off_work(parent);
-
-		genpd_release_lock(parent);
-	}
+	parent = genpd->parent;
+	if (parent && genpd_sd_counter_dec(parent))
+		genpd_queue_power_off_work(parent);
 
  out:
 	genpd->poweroff_task = NULL;

