Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1KXMWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:22:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:49497 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab1KXMWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:22:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="79607766"
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system
 suspend
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
In-Reply-To: <Pine.LNX.4.44L0.1111231149300.2111-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1111231149300.2111-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 24 Nov 2011 20:21:27 +0800
Message-ID: <1322137287.2597.10.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 01:02 +0800, Alan Stern wrote:
> On Wed, 23 Nov 2011, Lin Ming wrote:
> 
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > scsi device runtime PM is using PMSG_SUSPEND. System PM may use other state
> > that may not be compatiable with PMSG_SUSPEND.
> 
> Actually SCSI runtime PM uses PMSG_AUTO_AUTOSUSPEND, which is the same
> as PMSG_SUSPEND except that the PM_EVENT_AUTO bit is also set in the
> pm_message.event field.  Currently they _are_ compatible.
> 
> > So we need to runtime resume the device before system suspend.
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> > 
> > Alan,
> > 
> > Could you add your Signed-off-by?
> > Free free to change the commit logs.
> 
> I don't know; this is a little questionable.
> 
> The point of this patch is to handle drivers that do different things
> for runtime suspend and system sleep.  The only SCSI driver that
> currently supports runtime suspend is sd, and it treats runtime suspend
> the same as system sleep.  (Earlier I said it doesn't spin down disks
> for runtime suspend -- that was wrong, it does.  It skips the spin-down
> step only for PM_EVENT_FREEZE, which is part of the hibernation
> procedure.)
> 
> Until other SCSI drivers support runtime suspend, this patch shouldn't 
> be needed.  And spinning up runtime-suspended disks could add a lengthy 
> delay to the system sleep transition, so it's better not to do this if 
> at all possible.

For sd driver, PMSG_SUSPEND and PMSG_HIBERNATE are compatible with
PMSG_AUTO_SUSPEND. PMSG_FREEZE is not compatible.

So we only need to runtime resume sd for PMSG_FREEZE case.
How about below?

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 549ea72..e2759d9 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -50,7 +50,13 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 	int err = 0;
 
 	if (scsi_is_sdev_device(dev)) {
-		pm_runtime_resume(dev);
+		if (pm_runtime_suspended(dev)) {
+			if (msg.event == PM_EVENT_FREEZE)
+				pm_runtime_resume(dev);
+			else
+				return 0;
+		}
+
 		err = scsi_dev_type_suspend(dev, msg);
 	}
 	return err;

Lin Ming

> 
> Alan Stern
> 
> >  drivers/scsi/scsi_pm.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> > index d329f8b..549ea72 100644
> > --- a/drivers/scsi/scsi_pm.c
> > +++ b/drivers/scsi/scsi_pm.c
> > @@ -49,8 +49,10 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
> >  {
> >  	int err = 0;
> >  
> > -	if (scsi_is_sdev_device(dev))
> > +	if (scsi_is_sdev_device(dev)) {
> > +		pm_runtime_resume(dev);
> >  		err = scsi_dev_type_suspend(dev, msg);
> > +	}
> >  	return err;
> >  }
> 


