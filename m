Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1GaRxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:53:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1GaRwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:52:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 7/9] PM / Domains: Rename GPD_STATE_WAIT_PARENT to GPD_STATE_WAIT_MASTER
Date: Sun, 31 Jul 2011 19:51:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
References: <201107311946.06654.rjw@sisk.pl>
In-Reply-To: <201107311946.06654.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107311951.37713.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since it is now possible for a PM domain to have multiple masters
instead of one parent, rename the "wait for parent" status to reflect
the new situation.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   34 +++++++++++++++++-----------------
 include/linux/pm_domain.h   |    2 +-
 2 files changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -98,7 +98,7 @@ int __pm_genpd_poweron(struct generic_pm
 	for (;;) {
 		prepare_to_wait(&genpd->status_wait_queue, &wait,
 				TASK_UNINTERRUPTIBLE);
-		if (genpd->status != GPD_STATE_WAIT_PARENT)
+		if (genpd->status != GPD_STATE_WAIT_MASTER)
 			break;
 		mutex_unlock(&genpd->lock);
 
@@ -124,7 +124,7 @@ int __pm_genpd_poweron(struct generic_pm
 	 */
 	list_for_each_entry(link, &genpd->slave_links, slave_node) {
 		genpd_sd_counter_inc(link->master);
-		genpd->status = GPD_STATE_WAIT_PARENT;
+		genpd->status = GPD_STATE_WAIT_MASTER;
 
 		mutex_unlock(&genpd->lock);
 
@@ -258,7 +258,7 @@ static void __pm_genpd_restore_device(st
  */
 static bool genpd_abort_poweroff(struct generic_pm_domain *genpd)
 {
-	return genpd->status == GPD_STATE_WAIT_PARENT
+	return genpd->status == GPD_STATE_WAIT_MASTER
 		|| genpd->status == GPD_STATE_ACTIVE || genpd->resume_count > 0;
 }
 
@@ -300,7 +300,7 @@ static int pm_genpd_poweroff(struct gene
 	 * (4) System suspend is in progress.
 	 */
 	if (genpd->status == GPD_STATE_POWER_OFF
-	    || genpd->status == GPD_STATE_WAIT_PARENT
+	    || genpd->status == GPD_STATE_WAIT_MASTER
 	    || genpd->resume_count > 0 || genpd->prepared_count > 0)
 		return 0;
 
Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -13,7 +13,7 @@
 
 enum gpd_status {
 	GPD_STATE_ACTIVE = 0,	/* PM domain is active */
-	GPD_STATE_WAIT_PARENT,	/* PM domain's parent is being waited for */
+	GPD_STATE_WAIT_MASTER,	/* PM domain's master is being waited for */
 	GPD_STATE_BUSY,		/* Something is happening to the PM domain */
 	GPD_STATE_REPEAT,	/* Power off in progress, to be repeated */
 	GPD_STATE_POWER_OFF,	/* PM domain is off */

