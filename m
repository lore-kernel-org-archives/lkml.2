Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2HOSQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:16:59 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40568 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2HOSQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:16:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [Update][PATCH 3/3] PM / Runtime: Check device PM QoS setting before "no callbacks" check
Date: Wed, 15 Aug 2012 20:22:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1208151219170.1674-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208151219170.1674-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208152022.56224.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 15, 2012, Alan Stern wrote:
> On Tue, 14 Aug 2012, Rafael J. Wysocki wrote:
> 
> > 
> > If __dev_pm_qos_read_value(dev) returns a negative value,
> > rpm_suspend() should return -EPERM for dev even if its
> > power.no_callbacks flag is set.  For this to happen, the device's
> > power.no_callbacks flag has to be checked after the PM QoS check,
> > so modify the code accordingly.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/base/power/runtime.c |   12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > Index: linux/drivers/base/power/runtime.c
> > ===================================================================
> > --- linux.orig/drivers/base/power/runtime.c
> > +++ linux/drivers/base/power/runtime.c
> > @@ -388,6 +388,12 @@ static int rpm_suspend(struct device *de
> >  		goto repeat;
> >  	}
> >  
> > +	if (__dev_pm_qos_read_value(dev) < 0) {
> > +		/* Negative PM QoS constraint means "never suspend". */
> > +		retval = -EPERM;
> > +		goto out;
> > +	}
> > +
> >  	if (dev->power.no_callbacks)
> >  		goto no_callback;	/* Assume success. */
> >  
> > @@ -402,12 +408,6 @@ static int rpm_suspend(struct device *de
> >  		goto out;
> >  	}
> >  
> > -	if (__dev_pm_qos_read_value(dev) < 0) {
> > -		/* Negative PM QoS constraint means "never suspend". */
> > -		retval = -EPERM;
> > -		goto out;
> > -	}
> > -
> >  	__update_runtime_status(dev, RPM_SUSPENDING);
> >  
> >  	if (dev->pm_domain)
> 
> Wouldn't it be better to move the test into 
> rpm_check_suspend_allowed()?  Then it would apply to idle notifications 
> and pm_schedule_suspend().

Yes, that makes sense.

Updated patch is appended.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Check device PM QoS setting before "no callbacks"

If __dev_pm_qos_read_value(dev) returns a negative value,
rpm_suspend() should return -EPERM for dev even if its
power.no_callbacks flag is set.  For this to happen, the device's
power.no_callbacks flag has to be checked after the PM QoS check,
so move the PM QoS check to rpm_check_suspend_allowed() (this will
make it cover idle notifications as well as runtime suspend too).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/runtime.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -147,6 +147,8 @@ static int rpm_check_suspend_allowed(str
 	    || (dev->power.request_pending
 			&& dev->power.request == RPM_REQ_RESUME))
 		retval = -EAGAIN;
+	else if (__dev_pm_qos_read_value(dev) < 0)
+		retval = -EPERM;
 	else if (dev->power.runtime_status == RPM_SUSPENDED)
 		retval = 1;
 
@@ -402,12 +404,6 @@ static int rpm_suspend(struct device *de
 		goto out;
 	}
 
-	if (__dev_pm_qos_read_value(dev) < 0) {
-		/* Negative PM QoS constraint means "never suspend". */
-		retval = -EPERM;
-		goto out;
-	}
-
 	__update_runtime_status(dev, RPM_SUSPENDING);
 
 	if (dev->pm_domain)
