Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019Ab2CMAjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:39:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964854Ab2CMAYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 2/6] PM / Domains: Fix hibernation restore of devices
Date: Tue, 13 Mar 2012 01:24:59 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
References: <201203130123.16268.rjw@sisk.pl>
In-Reply-To: <201203130123.16268.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130124.59376.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

During resume from hibernation pm_genpd_restore_noirq() has to
deal with software state left by pm_genpd_suspend_noirq() and
unknown hardware state (the boot kernel may leave all PM domains and
devices in arbitrary states).  For this reason, make it attempt to
power cycle each domain when before resuming its first device to
possibly get rid of any unwanted hardware state that may interfere
with genpd_start_dev() later on.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -770,8 +770,10 @@ static int pm_genpd_prepare(struct devic
 
 	genpd_acquire_lock(genpd);
 
-	if (genpd->prepared_count++ == 0)
+	if (genpd->prepared_count++ == 0) {
+		genpd->suspended_count = 0;
 		genpd->suspend_power_off = genpd->status == GPD_STATE_POWER_OFF;
+	}
 
 	genpd_release_lock(genpd);
 
@@ -1103,20 +1105,24 @@ static int pm_genpd_restore_noirq(struct
 	 * Since all of the "noirq" callbacks are executed sequentially, it is
 	 * guaranteed that this function will never run twice in parallel for
 	 * the same PM domain, so it is not necessary to use locking here.
+	 *
+	 * At this point suspended_count == 0 means this routing is being run
+	 * for the first time for the given domain in the present cycle.
 	 */
-	genpd->status = GPD_STATE_POWER_OFF;
-	if (genpd->suspend_power_off) {
+	if (genpd->suspended_count++ == 0) {
 		/*
-		 * The boot kernel might put the domain into the power on state,
-		 * so make sure it really is powered off.
+		 * The boot kernel might put the domain into arbitrary state,
+		 * so make sure it is powered off.
 		 */
+		genpd->status = GPD_STATE_POWER_OFF;
 		if (genpd->power_off)
 			genpd->power_off(genpd);
-		return 0;
 	}
 
+	if (genpd->suspend_power_off)
+		return 0;
+
 	pm_genpd_poweron(genpd);
-	genpd->suspended_count--;
 
 	return genpd_start_dev(genpd, dev);
 }
@@ -1623,7 +1629,6 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->poweroff_task = NULL;
 	genpd->resume_count = 0;
 	genpd->device_count = 0;
-	genpd->suspended_count = 0;
 	genpd->max_off_time_ns = -1;
 	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
 	genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;

