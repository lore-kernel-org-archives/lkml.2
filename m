Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916Ab1FWRpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:45:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53570 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933066Ab1FWRp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:45:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system sleep
Date: Thu, 23 Jun 2011 19:46:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.1106221011240.1977-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106221011240.1977-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106231946.30004.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 22, 2011, Alan Stern wrote:
> On Wed, 22 Jun 2011, Rafael J. Wysocki wrote:
> 
> > > It's probably okay to prevent pm_runtime_suspend() from working during
> > > .suspend() or .resume(), but it's not a good idea to prevent
> > > pm_runtime_resume() from working then.
> > 
> > OK, but taking a reference by means of pm_runtime_get_noresume() won't
> > block pm_runtime_resume().
> 
> Exactly my point -- we don't need to (and don't want to) block 
> pm_runtime_resume during the .suspend() and .resume() callbacks.
> 
> > > During the .suspend and .resume callbacks, races with
> > > .runtime_suspend() can be prevented by calling
> > > pm_runtime_get_noresume() just before .suspend() and then calling
> > > pm_runtime_put_sync() just after .resume().
> > 
> > So, you seem to suggest to call pm_runtime_get_noresume() in
> > __device_suspend() and pm_runtime_put_sync() in device_resume().
> 
> Yes.  Also perhaps call pm_runtime_barrier() immediately after 
> get_noresume.
> 
> > That would be fine by me, perhaps up to the "sync" part of the "put".
> 
> The main feature of this design is that it allows runtime PM to work 
> between .resume() and .complete().  If you do a put_noidle instead of 
> put_sync then you may prevent runtime PM from working properly.
> 
> > > >  (a _put_sync() at this point will likely invoke
> > > > .runtime_idle() from the subsystem before executing .complete(), which may
> > > > not be desirable)?
> > > 
> > > It should be allowed.  The purpose of .complete() is not to re-enable
> > > runtime power management of the device; it is to release resources
> > > (like memory) allocated during .prepare() and perhaps also to allow new
> > > children to be registered under the device.
> > 
> > Right.  But does "allowed" mean the core _should_ do it at this point?
> > We may as well call pm_runtime_idle() directly from rpm_complete(), but
> > perhaps it's better to call it from device_resume(), so that it runs in
> > parallel for async devices.
> 
> Calling pm_runtime_put_noidle() followed by pm_runtime_idle() is 
> essentially the same as calling pm_runtime_put_sync() anyway.
> 
> If a subsystem really does want to block runtime PM between the 
> .resume() and .complete() callbacks, it can do its own get_noresume and 
> put_sync -- just as you have done with PCI.

OK, so what about the appended patch (the last hunk is necessary to make the
SCSI error handling work when runtime PM is disabled, it should be a separate
patch)?

Rafael

---
 drivers/base/power/main.c    |   27 ++++++++++++++++++++++-----
 drivers/base/power/runtime.c |   10 ++++++----
 2 files changed, 28 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -505,6 +505,7 @@ static int legacy_resume(struct device *
 static int device_resume(struct device *dev, pm_message_t state, bool async)
 {
 	int error = 0;
+	bool put = false;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
@@ -521,6 +522,9 @@ static int device_resume(struct device *
 	if (!dev->power.is_suspended)
 		goto Unlock;
 
+	pm_runtime_enable(dev);
+	put = true;
+
 	if (dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
 		error = pm_op(dev, &dev->pwr_domain->ops, state);
@@ -563,6 +567,10 @@ static int device_resume(struct device *
 	complete_all(&dev->power.completion);
 
 	TRACE_RESUME(error);
+
+	if (put)
+		pm_runtime_put_sync(dev);
+
 	return error;
 }
 
@@ -843,16 +851,22 @@ static int __device_suspend(struct devic
 	int error = 0;
 
 	dpm_wait_for_children(dev, async);
-	device_lock(dev);
 
 	if (async_error)
-		goto Unlock;
+		return 0;
+
+	pm_runtime_get_noresume(dev);
+	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
+		pm_wakeup_event(dev, 0);
 
 	if (pm_wakeup_pending()) {
+		pm_runtime_put_sync(dev);
 		async_error = -EBUSY;
-		goto Unlock;
+		return 0;
 	}
 
+	device_lock(dev);
+
 	if (dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
 		error = pm_op(dev, &dev->pwr_domain->ops, state);
@@ -890,12 +904,15 @@ static int __device_suspend(struct devic
  End:
 	dev->power.is_suspended = !error;
 
- Unlock:
 	device_unlock(dev);
 	complete_all(&dev->power.completion);
 
-	if (error)
+	if (error) {
+		pm_runtime_put_sync(dev);
 		async_error = error;
+	} else if (dev->power.is_suspended) {
+		__pm_runtime_disable(dev, false);
+	}
 
 	return error;
 }
Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -455,12 +455,14 @@ static int rpm_resume(struct device *dev
 	dev_dbg(dev, "%s flags 0x%x\n", __func__, rpmflags);
 
  repeat:
-	if (dev->power.runtime_error)
+	if (dev->power.runtime_error) {
 		retval = -EINVAL;
-	else if (dev->power.disable_depth > 0)
-		retval = -EAGAIN;
-	if (retval)
 		goto out;
+	} else if (dev->power.disable_depth > 0) {
+		if (!(rpmflags & RPM_GET_PUT))
+			retval = -EAGAIN;
+		goto out;
+	}
 
 	/*
 	 * Other scheduled or pending requests need to be canceled.  Small
