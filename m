Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1GHFKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:10:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab1GHFEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:00 2011
Message-Id: <20110708001700.537694111@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [080/107] PM: Fix async resume following suspend failure
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 6d0e0e84f66d32c33511984dd3badd32364b863c upstream.

The PM core doesn't handle suspend failures correctly when it comes to
asynchronously suspended devices.  These devices are moved onto the
dpm_suspended_list as soon as the corresponding async thread is
started up, and they remain on the list even if they fail to suspend
or the sleep transition is cancelled before they get suspended.  As a
result, when the PM core unwinds the transition, it tries to resume
the devices even though they were never suspended.

This patch (as1474) fixes the problem by adding a new "is_suspended"
flag to dev_pm_info.  Devices are resumed only if the flag is set.

[rjw:
 * Moved the dev->power.is_suspended check into device_resume(),
   because we need to complete dev->power.completion and clear
   dev->power.is_prepared too for devices whose
   dev->power.is_suspended flags are unset.
 * Fixed __device_suspend() to avoid setting dev->power.is_suspended
   if async_error is different from zero.]

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/power/main.c |   14 ++++++++++++--
 include/linux/pm.h        |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -58,6 +58,7 @@ static int async_error;
 void device_pm_init(struct device *dev)
 {
 	dev->power.is_prepared = false;
+	dev->power.is_suspended = false;
 	init_completion(&dev->power.completion);
 	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
@@ -519,6 +520,9 @@ static int device_resume(struct device *
 	 */
 	dev->power.is_prepared = false;
 
+	if (!dev->power.is_suspended)
+		goto Unlock;
+
 	if (dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
 		pm_op(dev, &dev->pwr_domain->ops, state);
@@ -553,6 +557,9 @@ static int device_resume(struct device *
 	}
 
  End:
+	dev->power.is_suspended = false;
+
+ Unlock:
 	device_unlock(dev);
 	complete_all(&dev->power.completion);
 
@@ -838,11 +845,11 @@ static int __device_suspend(struct devic
 	device_lock(dev);
 
 	if (async_error)
-		goto End;
+		goto Unlock;
 
 	if (pm_wakeup_pending()) {
 		async_error = -EBUSY;
-		goto End;
+		goto Unlock;
 	}
 
 	if (dev->type && dev->type->pm) {
@@ -880,6 +887,9 @@ static int __device_suspend(struct devic
 	}
 
  End:
+	dev->power.is_suspended = !error;
+
+ Unlock:
 	device_unlock(dev);
 	complete_all(&dev->power.completion);
 
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -426,6 +426,7 @@ struct dev_pm_info {
 	unsigned int		can_wakeup:1;
 	unsigned int		async_suspend:1;
 	bool			is_prepared:1;	/* Owned by the PM core */
+	bool			is_suspended:1;	/* Ditto */
 	spinlock_t		lock;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;


