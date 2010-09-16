Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0IPUhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:37:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35522 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab0IPUhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:37:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] PM: Fix potential issue with failing asynchronous suspend (was: Re: [PATCH] PM: Prevent waiting ...)
Date: Thu, 16 Sep 2010 22:36:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
References: <Pine.LNX.4.44L0.1009031311190.1548-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009031311190.1548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009162236.39660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 03, 2010, Alan Stern wrote:
> On Fri, 3 Sep 2010, Colin Cross wrote:
> 
> > >> I think there's another race condition during suspend.  If an
> > >> asynchronous device calls device_pm_wait_for_dev on a device that
> > >> hasn't had device_suspend called on it yet, power.completion will
> > >> still be set from initialization or the last time it completed resume,
> > >> and it won't wait.
> > >
> > > That can't happen in a properly-designed system.  It would mean the
> > > async device didn't suspend because it was waiting for a device which
> > > was registered before it -- and that would deadlock even if you used
> > > synchronous suspend.
> > I see - from the earlier thread, if devices need to break the tree
> > model for suspend, they still have to follow the list ordering.
> 
> Right.  After all, the user can force the system into doing a 
> synchronous suspend whenever he wants.
> 
> > >> Assuming that problem is fixed somehow, there's also a deadlock
> > >> possibility.  Consider 3 devices.  A, B, and C, registered in that
> > >> order.  A is async, and the suspend handler calls
> > >> device_pm_wait_for_dev(C).  B's suspend handler returns an error.  A's
> > >> suspend handler is now stuck waiting on C->power.completion, but
> > >> device_suspend(C) will never be called.
> > >
> > > Why not?  The normal suspend order is last-to-first, so C will be
> > > suspended before B.
> > Reverse A and C, but then the earlier comment applies.
> 
> Exactly.
> 
> > >> There are also an unhandled edge condition - what is the expected
> > >> behavior for a call to device_pm_wait_for_dev on a device if the
> > >> suspend handler for that device returns an error?  Currently, the
> > >> calling device will continue as if the target device had suspended.
> > >
> > > It looks like __device_suspend needs to set async_error.  Which means
> > > async_suspend doesn't need to set it.  This is indeed a bug.
> > Is this sufficient?  The waiting device will complete its suspend
> > handler, and then be resumed, but the waited-on device never
> > suspended.  Are drivers expected to handle that case?
> 
> Sorry, my reply wasn't very good.  There are _two_ related problems:
> drivers calling device_pm_wait_for_dev and also the internal call where
> __device_suspend calls dpm_wait_for_children.  They're both subject to
> this bug, and my comment referred to the second problem rather than the
> one you raised.
> 
> The entire "if (error) {"  block can be moved from async_suspend to the
> end of __device_suspend, with suitable adjustment to the string
> constant in the error message.

In fact this message belongs in async_suspend() (the "synchronous" code has
its own version).

> At the same time,
> device_pm_wait_for_dev should return async_error instead of returning
> void.  Which means its callers will have to check the return value (I
> don't think there are very many callers at the moment).  Together those 
> changes should fix everything.

So, I think the patch below should fix the issue.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Fix potential issue with failing asynchronous suspend

There is a potential issue with the asynchronous suspend code that
a device driver suspending asynchronously may not notice that it
should back off.  There are two failing scenarions, (1) when the
driver is waiting for a driver suspending synchronously to complete
and that second driver returns error code, in which case async_error
won't be set and the waiting driver will continue suspending and (2)
after the driver has called device_pm_wait_for_dev() and the waited
for driver returns error code, in which case the caller of
device_pm_wait_for_dev() will not know that there was an error and
will continue suspending.

To fix this issue make __device_suspend() set async_error, so
async_suspend() doesn't need to set it any more, and make
device_pm_wait_for_dev() return async_error, so that its callers
can check whether or not they should continue suspending.

No more changes are necessary, since device_pm_wait_for_dev() is
not used by any drivers' suspend routines at the moment.

Reported-by: Colin Cross <ccross@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   15 +++++++++------
 include/linux/pm.h        |    7 +++++--
 2 files changed, 14 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -51,6 +51,8 @@ static pm_message_t pm_transition;
  */
 static bool transition_started;
 
+static int async_error;
+
 /**
  * device_pm_init - Initialize the PM-related part of a device object.
  * @dev: Device object being initialized.
@@ -602,6 +604,7 @@ static void dpm_resume(pm_message_t stat
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
+	async_error = 0;
 
 	list_for_each_entry(dev, &dpm_list, power.entry) {
 		if (dev->power.status < DPM_OFF)
@@ -831,8 +834,6 @@ static int legacy_suspend(struct device 
 	return error;
 }
 
-static int async_error;
-
 /**
  * device_suspend - Execute "suspend" callbacks for given device.
  * @dev: Device to handle.
@@ -887,6 +888,9 @@ static int __device_suspend(struct devic
 	device_unlock(dev);
 	complete_all(&dev->power.completion);
 
+	if (error)
+		async_error = error;
+
 	return error;
 }
 
@@ -896,10 +900,8 @@ static void async_suspend(void *data, as
 	int error;
 
 	error = __device_suspend(dev, pm_transition, true);
-	if (error) {
+	if (error)
 		pm_dev_err(dev, pm_transition, " async", error);
-		async_error = error;
-	}
 
 	put_device(dev);
 }
@@ -1087,8 +1089,9 @@ EXPORT_SYMBOL_GPL(__suspend_report_resul
  * @dev: Device to wait for.
  * @subordinate: Device that needs to wait for @dev.
  */
-void device_pm_wait_for_dev(struct device *subordinate, struct device *dev)
+int device_pm_wait_for_dev(struct device *subordinate, struct device *dev)
 {
 	dpm_wait(dev, subordinate->power.async_suspend);
+	return async_error;
 }
 EXPORT_SYMBOL_GPL(device_pm_wait_for_dev);
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -559,7 +559,7 @@ extern void __suspend_report_result(cons
 		__suspend_report_result(__func__, fn, ret);		\
 	} while (0)
 
-extern void device_pm_wait_for_dev(struct device *sub, struct device *dev);
+extern int device_pm_wait_for_dev(struct device *sub, struct device *dev);
 #else /* !CONFIG_PM_SLEEP */
 
 #define device_pm_lock() do {} while (0)
@@ -572,7 +572,10 @@ static inline int dpm_suspend_start(pm_m
 
 #define suspend_report_result(fn, ret)		do {} while (0)
 
-static inline void device_pm_wait_for_dev(struct device *a, struct device *b) {}
+static inline int device_pm_wait_for_dev(struct device *a, struct device *b)
+{
+	return 0;
+}
 #endif /* !CONFIG_PM_SLEEP */
 
 /* How to reorder dpm_list after device_move() */
