Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1FSTgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 15:36:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1FSTgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 15:36:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] calling runtime PM from system PM methods
Date: Sun, 19 Jun 2011 21:36:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
References: <Pine.LNX.4.44L0.1106191042510.11375-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106191042510.11375-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192136.51572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 19, 2011, Alan Stern wrote:
> On Sun, 19 Jun 2011, Rafael J. Wysocki wrote:
> 
> > Well, that was kind of difficult to debug, but not impossible. :-)
> > 
> > The problem here turns out to be related to the SCSI subsystem.
> > Namely, when the AHCI controller is suspended, it uses the SCSI error
> > handling mechanism for scheduling the suspend operation (I'm still at a little
> > loss why that is necessary, but Tejun says it is :-)).  This (after several
> > convoluted operations) causes scsi_error_handler() to be woken up and
> > it calls scsi_autopm_get_host(shost), which returns error code (-EAGAIN),
> > because the runtime PM has been disabled at the host level.
> 
> Oh no.  I was afraid something like this was going to happen 
> eventually.
> 
> It's clear that we don't want runtime PM kicking in while the SCSI 
> error handler is running.  That's why I added the 
> scsi_autopm_get_host().  But this also means we will run into trouble 
> if the error handler needs to be used during a power transition.
> 
> > This happens because scsi_autopm_get_host() uses
> > pm_runtime_get_sync(&shost->shost_gendev) and returns error code when
> > shost_gendev.power.disable_depth is nonzero.
> 
> Maybe get_sync doesn't need to return an error if the runtime status is 
> already ACTIVE.  I'm not sure about this; it's just an idea...

Well, if disable_depth > 0, ACTIVE isn't really well defined.  As I said,
though, I think it makes sense for pm_runtime_get_sync() to return 0 when
disable_depth > 0, because the grabbing of a reference is successful anyway and
the caller may assume that the device is accessible in that case.

In the meantime I rethought the __pm_runtime_disable() part of my previous
patch and I now think it's not necessary to complicate it any more.  Of course,
we need not check if runtime resume is pending in __device_suspend(), because
we've done it already in dpm_prepare(), but the barrier part should better be
done in there too.

Updated patch is appended.

Thanks,
Rafael

---
 drivers/base/power/main.c    |    6 ++++++
 drivers/base/power/runtime.c |   10 ++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -521,6 +521,9 @@ static int device_resume(struct device *
 	if (!dev->power.is_suspended)
 		goto Unlock;
 
+	pm_runtime_get_noresume(dev);
+	pm_runtime_enable(dev);
+
 	if (dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
 		error = pm_op(dev, &dev->pwr_domain->ops, state);
@@ -557,6 +560,7 @@ static int device_resume(struct device *
 
  End:
 	dev->power.is_suspended = false;
+	pm_runtime_put_noidle(dev);
 
  Unlock:
 	device_unlock(dev);
@@ -896,6 +900,8 @@ static int __device_suspend(struct devic
 
 	if (error)
 		async_error = error;
+	else if (dev->power.is_suspended)
+		__pm_runtime_disable(dev, false);
 
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
