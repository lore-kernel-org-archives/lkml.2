Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1LDU4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 15:56:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab1LDU4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 15:56:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Domains: Fix default system suspend/resume operations
Date: Sun, 4 Dec 2011 21:59:10 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112042159.10576.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit d23b9b00cdde5c93b914a172cecd57d5625fcd04 (PM / Domains: Rework
system suspend callback routines (v2)) broke the system suspend and
resume handling by devices belonging to generic PM domains, because
it used freeze/thaw callbacks instead of suspend/resume ones and
didn't initialize device callbacks for system suspend/resume
properly at all.  Fix those problems.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

This patch is on top of linux-pm/pm-domains.

Thanks,
Rafael

---
 drivers/base/power/domain.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -1360,7 +1360,7 @@ static int pm_genpd_default_restore_stat
  */
 static int pm_genpd_default_suspend(struct device *dev)
 {
-	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.freeze;
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.suspend;
 
 	return cb ? cb(dev) : pm_generic_suspend(dev);
 }
@@ -1371,7 +1371,7 @@ static int pm_genpd_default_suspend(stru
  */
 static int pm_genpd_default_suspend_late(struct device *dev)
 {
-	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.freeze_late;
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.suspend_late;
 
 	return cb ? cb(dev) : pm_generic_suspend_noirq(dev);
 }
@@ -1382,7 +1382,7 @@ static int pm_genpd_default_suspend_late
  */
 static int pm_genpd_default_resume_early(struct device *dev)
 {
-	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.thaw_early;
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.resume_early;
 
 	return cb ? cb(dev) : pm_generic_resume_noirq(dev);
 }
@@ -1393,7 +1393,7 @@ static int pm_genpd_default_resume_early
  */
 static int pm_genpd_default_resume(struct device *dev)
 {
-	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.thaw;
+	int (*cb)(struct device *__dev) = dev_gpd_data(dev)->ops.resume;
 
 	return cb ? cb(dev) : pm_generic_resume(dev);
 }
@@ -1487,10 +1487,10 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->domain.ops.complete = pm_genpd_complete;
 	genpd->dev_ops.save_state = pm_genpd_default_save_state;
 	genpd->dev_ops.restore_state = pm_genpd_default_restore_state;
-	genpd->dev_ops.freeze = pm_genpd_default_suspend;
-	genpd->dev_ops.freeze_late = pm_genpd_default_suspend_late;
-	genpd->dev_ops.thaw_early = pm_genpd_default_resume_early;
-	genpd->dev_ops.thaw = pm_genpd_default_resume;
+	genpd->dev_ops.suspend = pm_genpd_default_suspend;
+	genpd->dev_ops.suspend_late = pm_genpd_default_suspend_late;
+	genpd->dev_ops.resume_early = pm_genpd_default_resume_early;
+	genpd->dev_ops.resume = pm_genpd_default_resume;
 	genpd->dev_ops.freeze = pm_genpd_default_freeze;
 	genpd->dev_ops.freeze_late = pm_genpd_default_freeze_late;
 	genpd->dev_ops.thaw_early = pm_genpd_default_thaw_early;
