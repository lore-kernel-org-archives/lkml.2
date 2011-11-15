Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1KOQIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 11:08:55 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48228 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756459Ab1KOQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 11:08:53 -0500
Date: Tue, 15 Nov 2011 11:08:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Lin Ming <ming.m.lin@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH v2 4/4] ata: add ata port runtime PM callbacks
In-Reply-To: <20111115145425.GL30922@google.com>
Message-ID: <Pine.LNX.4.44L0.1111151052160.2345-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011, Tejun Heo wrote:

> On Tue, Nov 15, 2011 at 04:51:29PM +0800, Lin Ming wrote:
> > > This is not the right approach.  You should look instead at 
> > > scsi_dev_type_suspend() in scsi_pm.c.  If the device is already runtime 
> > > suspended then the routine should return immediately.
> > 
> > How about below?
> > 
> > diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> > index d329f8b..94b60bd 100644
> > --- a/drivers/scsi/scsi_pm.c
> > +++ b/drivers/scsi/scsi_pm.c
> > @@ -20,6 +20,9 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
> >  	struct device_driver *drv;
> >  	int err;
> >  
> > +	if (pm_runtime_suspended(dev))
> > +		return 0;
> > +
> 
> Something to be careful about is there are different types of suspend
> states (PMSG_*).  IIUC, runtime PM is using PMSG_SUSPEND.  Other
> states may or may not be compatible with PMSG_SUSPEND expectations, so
> you can skip suspend operation if the newly requested state is
> PMSG_SUSPEND but otherwise the controller needs to be woken up and
> told to comply to the new state.

That's right.  Surprisingly enough (and contrary to what I wrote
earlier), the sd_suspend() routine doesn't spin down a drive for
runtime suspend.  This probably should be considered a bug.

Anyway, it looks like the correct approach would be more like this:

 static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
 		pm_runtime_resume(dev);
 		err = scsi_dev_type_suspend(dev, msg);
+	}
 	return err;
 }

Alan Stern

