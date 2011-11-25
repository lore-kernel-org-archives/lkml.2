Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1KYNwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 08:52:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:29179 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab1KYNv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 08:51:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,571,1315206000"; 
   d="scan'208";a="79128130"
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system
 suspend
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
In-Reply-To: <Pine.LNX.4.44L0.1111241906020.26861-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1111241906020.26861-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 21:50:39 +0800
Message-ID: <1322229039.4246.8.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-25 at 08:17 +0800, Alan Stern wrote:
> On Thu, 24 Nov 2011, Tejun Heo wrote:
> 
> > Hello,
> > 
> > On Thu, Nov 24, 2011 at 2:54 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > Therefore, when entering the SUSPEND or HIBERNATE stages of system
> > > sleep, we can skip the callback to the driver if the device is already
> > > in runtime suspend. �When entering the FREEZE stage, however, we should
> > > first issue a runtime resume. �The overhead of doing this is
> > > negligible, because a suspended drive would be spun up during the THAW
> > > stage of hibernation anyway.
> > 
> > My brain is half fried at the moment so maybe you're saying the same
> > thing, but I hope this is something simple. Like...
> > 
> >     /* for libata runtime suspend is equivalent to suspend */
> >     if (runtime suspended && target == SUSPEND) {
> >         yeah! skip drive pm ops;
> >     } else {
> >         end runtime pm;
> >         ask EH to enter target PM state;
> >     }
> 
> Almost.  More like this:
> 
> 	/*
> 	 * sd is the only high-level SCSI driver to implement runtime 
> 	 * PM, and sd treats runtime suspend, system suspend, and 
> 	 * system hibernate identically (but not system freeze).
> 	 */
> 	if (runtime-suspended) {
> 		if (target == SUSPEND || target == HIBERNATE)
> 			return 0;	/* already suspended */
> 		/* wake up device so that FREEZE will succeed */
> 		pm_runtime_resume();
> 	}
> 	tell device driver to enter target PM state

Below is the updated patch with your suggested patch description and
comments.

Looks OK?

Subject: [PATCH] [SCSI] check runtime PM status in system PM

The only high-level SCSI driver that currently implements runtime PM is
sd, and sd treats runtime suspend exactly the same as the SUSPEND and
HIBERNATE stages of system sleep, but not the same as the FREEZE stage.

Therefore, when entering the SUSPEND or HIBERNATE stages of system
sleep, we can skip the callback to the driver if the device is already
in runtime suspend.  When entering the FREEZE stage, however, we should
first issue a runtime resume.  The overhead of doing this is
negligible, because a suspended drive would be spun up during the THAW
stage of hibernation anyway.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_pm.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d329f8b..a633076 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -49,8 +49,22 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		/*
+		 * sd is the only high-level SCSI driver to implement runtime
+		 * PM, and sd treats runtime suspend, system suspend, and
+		 * system hibernate identically (but not system freeze).
+		 */
+		if (pm_runtime_suspended(dev)) {
+			if (msg.event == PM_EVENT_SUSPEND ||
+			    msg.event == PM_EVENT_HIBERNATE)
+				return 0;	/* already suspended */
+
+			/* wake up device so that FREEZE will succeed */
+			pm_runtime_resume(dev);
+		}
 		err = scsi_dev_type_suspend(dev, msg);
+	}
 	return err;
 }

--- 
Thanks,
Lin Ming

> 
> libata does not contain the SCSI device driver; it contains the host
> driver.
> 
> > I really don't think we need to optimize this further than this.
> 
> The above has two lines (plus comments) of optimization.  Okay?
> 
> Alan Stern
> 


