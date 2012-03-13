Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2CMV2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:28:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913Ab2CMV2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:28:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [Replacement][PATCH 2/6] PM / Domains: Fix hibernation restore of devices, v2
Date: Tue, 13 Mar 2012 22:32:42 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
References: <201203130123.16268.rjw@sisk.pl> <201203130124.59376.rjw@sisk.pl>
In-Reply-To: <201203130124.59376.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203132232.42915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 13, 2012, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> During resume from hibernation pm_genpd_restore_noirq() has to
> deal with software state left by pm_genpd_suspend_noirq() and
> unknown hardware state (the boot kernel may leave all PM domains and
> devices in arbitrary states).  For this reason, make it attempt to
> power cycle each domain when before resuming its first device to
> possibly get rid of any unwanted hardware state that may interfere
> with genpd_start_dev() later on.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I realized that this wasn't a good idea because of patch [3/6] (we
can't power cycle domains containing "always on" devices), so I
decided to only fix the really broken things in pm_genpd_restore_noirq().

Of course, patch [3/6] also needs to be updated on top of the below to
avoid starting "always on" devices in pm_genpd_restore_noirq() (it has
to assume that they will be "always on" in the boot kernel too, but that
seems to be a reasonable expectation).

Please note that those changes only affect resume from hibernation, so
they don't invalidate the testing that has already been carried out.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Domains: Fix hibernation restore of devices, v2

During resume from hibernation pm_genpd_restore_noirq() should only
power off domains whose suspend_power_off flags are set once and
not every time it is called for a device in the given domain.
Moreover, it shouldn't decrement genpd->suspended_count, because
that field is not touched during device freezing and therefore it is
always equal to 0 when pm_genpd_restore_noirq() runs for the first
device in the given domain.

This means pm_genpd_restore_noirq() may use genpd->suspended_count
to determine whether or not it it has been called for the domain in
question already in this cycle (it only needs to increment that
field every time it runs for this purpose) and whether or not it
should check if the domain needs to be powered off.  For that to
work, though, pm_genpd_prepare() has to clear genpd->suspended_count
when it runs for the first device in the given domain (in which case
that flag need not be cleared during domain initialization).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -764,8 +764,10 @@ static int pm_genpd_prepare(struct devic
 
 	genpd_acquire_lock(genpd);
 
-	if (genpd->prepared_count++ == 0)
+	if (genpd->prepared_count++ == 0) {
+		genpd->suspended_count = 0;
 		genpd->suspend_power_off = genpd->status == GPD_STATE_POWER_OFF;
+	}
 
 	genpd_release_lock(genpd);
 
@@ -1097,20 +1099,30 @@ static int pm_genpd_restore_noirq(struct
 	 * Since all of the "noirq" callbacks are executed sequentially, it is
 	 * guaranteed that this function will never run twice in parallel for
 	 * the same PM domain, so it is not necessary to use locking here.
+	 *
+	 * At this point suspended_count == 0 means we are being run for the
+	 * first time for the given domain in the present cycle.
 	 */
-	genpd->status = GPD_STATE_POWER_OFF;
-	if (genpd->suspend_power_off) {
+	if (genpd->suspended_count++ == 0) {
 		/*
-		 * The boot kernel might put the domain into the power on state,
-		 * so make sure it really is powered off.
+		 * The boot kernel might put the domain into arbitrary state,
+		 * so make it appear as powered off to pm_genpd_poweron(), so
+		 * that it tries to power it on in case it was really off.
 		 */
-		if (genpd->power_off)
-			genpd->power_off(genpd);
-		return 0;
+		genpd->status = GPD_STATE_POWER_OFF;
+		if (genpd->suspend_power_off) {
+			/*
+			 * If the domain was off before the hibernation, make
+			 * sure it will be off going forward.
+			 */
+			if (genpd->power_off)
+				genpd->power_off(genpd);
+
+			return 0;
+		}
 	}
 
 	pm_genpd_poweron(genpd);
-	genpd->suspended_count--;
 
 	return genpd_start_dev(genpd, dev);
 }
@@ -1617,7 +1629,6 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->poweroff_task = NULL;
 	genpd->resume_count = 0;
 	genpd->device_count = 0;
-	genpd->suspended_count = 0;
 	genpd->max_off_time_ns = -1;
 	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
 	genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;
