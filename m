Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab1GJJKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:10:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab1GJJJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:09:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 6/6 v2] PM / Domains: Improve handling of wakeup devices during system suspend
Date: Sun, 10 Jul 2011 11:09:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>
References: <201107062248.35586.rjw@sisk.pl> <201107101059.30322.rjw@sisk.pl>
In-Reply-To: <201107101059.30322.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107101109.36176.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Kevin points out that if there's a device that can wake up the system
from sleep states, but it doesn't generate wakeup signals by itself
(they are generated on its behalf by other parts of the system) and
it currently is not enabled to wake up the system (that is,
device_may_wakeup() returns "false" for it), we may need to change
its wakeup settings during system suspend (for example, the device
might have been configured to signal remote wakeup from the system's
working state, as needed by runtime PM).  Therefore the generic PM
domains code should invoke the system suspend callbacks provided by
the device's driver, which it doesn't do if the PM domain is powered
off during the system suspend's "prepare" stage.  This is a valid
point.  Moreover, this code also should make sure that system wakeup
devices that are enabled to wake up the system from sleep states and
have to remain active for this purpose are not suspended while the
system is in a sleep state.

To avoid the above issues, make the generic PM domains' .prepare()
routine, pm_genpd_prepare(), force runtime resume of devices whose
system wakeup settings may need to be changed during system suspend
or that should remain active while the system is in a sleep state to
be able to wake it up from that state.

Reported-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -482,6 +482,33 @@ static void pm_genpd_sync_poweroff(struc
 }
 
 /**
+ * resume_needed - Check whether to resume a device before system suspend.
+ * @dev: Device to check.
+ * @genpd: PM domain the device belongs to.
+ *
+ * There are two cases in which a device that can wake up the system from sleep
+ * states should be resumed by pm_genpd_prepare(): (1) if the device is enabled
+ * to wake up the system and it has to remain active for this purpose while the
+ * system is in the sleep state and (2) if the device is not enabled to wake up
+ * the system from sleep states and it generally doesn't generate wakeup signals
+ * by itself (those signals are generated on its behalf by other parts of the
+ * system).  In the latter case it may be necessary to reconfigure the device's
+ * wakeup settings during system suspend, because it may have been set up to
+ * signal remote wakeup from the system's working state as needed by runtime PM.
+ * Return 'true' in either of the above cases.
+ */
+static bool resume_needed(struct device *dev, struct generic_pm_domain *genpd)
+{
+	bool active_wakeup;
+
+	if (!device_can_wakeup(dev))
+		return false;
+
+	active_wakeup = genpd->active_wakeup && genpd->active_wakeup(dev);
+	return device_may_wakeup(dev) ? active_wakeup : !active_wakeup;
+}
+
+/**
  * pm_genpd_prepare - Start power transition of a device in a PM domain.
  * @dev: Device to start the transition of.
  *
@@ -515,6 +542,9 @@ static int pm_genpd_prepare(struct devic
 		return -EBUSY;
 	}
 
+	if (resume_needed(dev, genpd))
+		pm_runtime_resume(dev);
+
 	genpd_acquire_lock(genpd);
 
 	if (genpd->prepared_count++ == 0)

