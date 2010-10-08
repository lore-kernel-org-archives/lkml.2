Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680Ab0JHX0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 19:26:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57852 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260Ab0JHX0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 19:26:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: PM / Runtime: Remove idle notification after failing suspend (was: Re: [linux-pm] [PATCH] PM: add synchronous ...)
Date: Sat, 9 Oct 2010 01:24:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1010021004150.15874-100000@netrider.rowland.org> <201010030006.33454.rjw@sisk.pl>
In-Reply-To: <201010030006.33454.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010090124.56493.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 03, 2010, Rafael J. Wysocki wrote:
> On Saturday, October 02, 2010, Alan Stern wrote:
> > On Fri, 1 Oct 2010, Rafael J. Wysocki wrote:
> ...
> 
> > > If we removed the immediate idle notification after a successful resume, it
> > > might need to be reworked slightly.
> > 
> > My suggestion was that we remove the idle notification after a failed 
> > suspend, not the notification after a successful resume.
> 
> And I said I was fine with that.

Actaully, I think we can do that right away.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Remove idle notification after failing suspend

If runtime suspend of a device fails returning -EAGAIN or -EBUSY,
which means that it's safe to try to suspend it again, the PM core
runs the runtime idle helper function for it.  Unfortunately this may
lead to problems, for example for PCI devices whose drivers don't
implement the ->runtime_idle() callback, because in that case the
PCI bus type's ->runtime_idle() always calls pm_runtime_suspend()
for the given device.  Thus, if it is automatically called by a
driver's ->runtime_suspend() returning -EAGAIN or -EBUSY, it will
cause the suspend to happen again possibly causing a busy loop to
appear.  To avoid that, remove the idle notification after failing
runtime suspend of a device altogether and let the callers of
pm_runtime_suspend() repeat the operation if need be.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/runtime.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -281,7 +281,6 @@ static int rpm_suspend(struct device *de
 {
 	int (*callback)(struct device *);
 	struct device *parent = NULL;
-	bool notify = false;
 	int retval;
 
 	dev_dbg(dev, "%s flags 0x%x\n", __func__, rpmflags);
@@ -383,13 +382,10 @@ static int rpm_suspend(struct device *de
 	if (retval) {
 		__update_runtime_status(dev, RPM_ACTIVE);
 		dev->power.deferred_resume = 0;
-		if (retval == -EAGAIN || retval == -EBUSY) {
-			if (dev->power.timer_expires == 0)
-				notify = true;
+		if (retval == -EAGAIN || retval == -EBUSY)
 			dev->power.runtime_error = 0;
-		} else {
+		else
 			pm_runtime_cancel_pending(dev);
-		}
 	} else {
  no_callback:
 		__update_runtime_status(dev, RPM_SUSPENDED);
@@ -408,9 +404,6 @@ static int rpm_suspend(struct device *de
 		goto out;
 	}
 
-	if (notify)
-		rpm_idle(dev, 0);
-
 	if (parent && !parent->power.ignore_children) {
 		spin_unlock_irq(&dev->power.lock);
 
