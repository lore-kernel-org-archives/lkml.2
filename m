Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501Ab1FWW6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:58:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54502 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933303Ab1FWW6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:58:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system sleep
Date: Fri, 24 Jun 2011 00:59:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
References: <Pine.LNX.4.44L0.1106231727180.2033-100000@iolanthe.rowland.org> <201106240035.14913.rjw@sisk.pl>
In-Reply-To: <201106240035.14913.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106240059.38687.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 24, 2011, Rafael J. Wysocki wrote:
> On Thursday, June 23, 2011, Alan Stern wrote:
> > On Thu, 23 Jun 2011, Rafael J. Wysocki wrote:
> > 
> > > > Then maybe this disable_depth > 0 case should return something other
> > > > than 0.  Something new, like -EACCES.  That way the caller would
> > > > realize something strange was going on but wouldn't have to treat the 
> > > > situation as an error.
> > > 
> > > I would be fine with that, but then we'd need to reserve that error code,
> > > so that it's not returned by subsystem callbacks (or even we should convert
> > > it to a different error code if it is returned by the subsystem callback in
> > > rpm_resume()). 
> > > 
> > > > After all, the return value from pm_runtime_get_sync() is documented to 
> > > > be the error code for the underlying pm_runtime_resume().  It doesn't 
> > > > refer to the increment operation -- that always succeeds.
> > > 
> > > That means we should change the caller, which is the SCSI subsystem in this
> > > particular case, to check the error code.  The problem with this approach
> > > is that the same error code may be returned in a different situation, so
> > > we should prevent that from happening in the first place.  Still, suppose
> > > that we do that and that the caller checks the error code.  What is it
> > > supposed to do in that situation?  The only reasonable action for the
> > > caller is to ignore the error code if it means disable_depth > 0 and go
> > > on with whatever it has to do, but that's what it will do if the
> > > pm_runtime_get_sync() returns 0 in that situation.
> > > 
> > > So, in my opinion it simply may be best to update the documentation of
> > > pm_runtime_get_sync() along with the code changes. :-)
> > 
> > The only reason you're doing this is for the SCSI error-handler 
> > routine?
> 
> Yes, it is.
> 
> > I think it would be easier to change that routine instead of the PM 
> > core.  It should be smart enough to know that a runtime PM call isn't 
> > needed during a system sleep transition, i.e., between the scsi_host's 
> > suspend and resume callbacks.  Maybe check the new is_suspended flag.  
> > You'd also have to make sure the scsi_host wasn't runtime suspended 
> > when the sleep begins, rather like PCI.
> 
> Well, I think the problem is still there even at run time if runtime PM
> happens to be disabled for shost_gendev (this probably never happens in
> practice, though, except when runtime PM is disabled during system
> suspend, which also wasn't done before).
> 
> > I'm still not clear on why the error handler needs to run at this time.
> 
> Because SATA ports are suspended with the help of the SCSI error handling
> mechanism (which Tejun claims is the best way to do that).
> 
> But the thing done by scsi_autopm_get_host() is entirely reasonable
> (maybe except that calling pm_runtime_put_sync() after failing
> pm_runtime_get_sync() is rather pointless, pm_runtime_put_noidle() would
> be sufficient), but it doesn't work for disabled runtime PM.
> 
> So, the question is whether or not what scsi_autopm_get_host() does should work
> when runtime PM is disabled and I think it should.  Hence the patch.
> 
> Now, I agree that the proposed change is a little ugly, because it makes
> "resume with taking reference" behave differently from "resume".  The
> solution to that would be to return a special error code in the "disabled
> runtime PM" case.  However, in that case we'd need to change the runtime PM
> code in general to return this particular error code in the "disabled runtime
> PM" case and to prevent this error code from being returned in other
> circumstances.  In addition to that, we'de need to change the SCSI code, of
> course.
> 
> Do you think that would be better?

I've carried out this exercise to see how complicated it is going to be
and it doesn't really seem to be _that_ complicated.  The appended patch
illustrates this, but it hasn't been tested, so caveat emptor.

Thanks,
Rafael

---
 drivers/base/power/runtime.c |    9 +++++----
 drivers/scsi/scsi_pm.c       |    8 ++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -135,8 +135,9 @@ static int rpm_check_suspend_allowed(str
 
 	if (dev->power.runtime_error)
 		retval = -EINVAL;
-	else if (atomic_read(&dev->power.usage_count) > 0
-	    || dev->power.disable_depth > 0)
+	else if (dev->power.disable_depth > 0)
+		retval = -EACCES;
+	else if (atomic_read(&dev->power.usage_count) > 0)
 		retval = -EAGAIN;
 	else if (!pm_children_suspended(dev))
 		retval = -EBUSY;
@@ -262,7 +263,7 @@ static int rpm_callback(int (*cb)(struct
 		spin_lock_irq(&dev->power.lock);
 	}
 	dev->power.runtime_error = retval;
-	return retval;
+	return retval != -EACCES ? retval : -EIO;
 }
 
 /**
@@ -458,7 +459,7 @@ static int rpm_resume(struct device *dev
 	if (dev->power.runtime_error)
 		retval = -EINVAL;
 	else if (dev->power.disable_depth > 0)
-		retval = -EAGAIN;
+		retval = -EACCES;
 	if (retval)
 		goto out;
 
Index: linux-2.6/drivers/scsi/scsi_pm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_pm.c
+++ linux-2.6/drivers/scsi/scsi_pm.c
@@ -144,9 +144,9 @@ int scsi_autopm_get_device(struct scsi_d
 	int	err;
 
 	err = pm_runtime_get_sync(&sdev->sdev_gendev);
-	if (err < 0)
+	if (err < 0 && err !=-EACCES)
 		pm_runtime_put_sync(&sdev->sdev_gendev);
-	else if (err > 0)
+	else
 		err = 0;
 	return err;
 }
@@ -173,9 +173,9 @@ int scsi_autopm_get_host(struct Scsi_Hos
 	int	err;
 
 	err = pm_runtime_get_sync(&shost->shost_gendev);
-	if (err < 0)
+	if (err < 0 && err !=-EACCES)
 		pm_runtime_put_sync(&shost->shost_gendev);
-	else if (err > 0)
+	else
 		err = 0;
 	return err;
 }
