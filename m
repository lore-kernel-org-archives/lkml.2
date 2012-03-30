Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936167Ab2C3VoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:44:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55265 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934792Ab2C3VbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:31:25 -0400
X-Sasl-enc: AzT/A8ZTj05V/Z5tet/TES63PAeX3D9jKxSj7fyAv/I7 1333143083
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:51 2012
Message-Id: <20120330194851.386330482@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 126/175] PM / Domains: Fix hibernation restore of devices, v2
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Rafael J. Wysocki <rjw@sisk.pl>

This is a backport of mainline commit
65533bbf63b4f37723fdfedc73d0653958973323.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/domain.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -764,8 +764,10 @@ static int pm_genpd_prepare(struct devic
 
 	genpd_acquire_lock(genpd);
 
-	if (genpd->prepared_count++ == 0)
+	if (genpd->prepared_count++ == 0) {
+		genpd->suspended_count = 0;
 		genpd->suspend_power_off = genpd->status == GPD_STATE_POWER_OFF;
+	}
 
 	genpd_release_lock(genpd);
 
@@ -1041,20 +1043,28 @@ static int pm_genpd_restore_noirq(struct
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
+		}
 	}
 
 	pm_genpd_poweron(genpd);
-	genpd->suspended_count--;
 	genpd_start_dev(genpd, dev);
 
 	return genpd_resume_early(genpd, dev);
@@ -1558,7 +1568,6 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->poweroff_task = NULL;
 	genpd->resume_count = 0;
 	genpd->device_count = 0;
-	genpd->suspended_count = 0;
 	genpd->max_off_time_ns = -1;
 	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
 	genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;


