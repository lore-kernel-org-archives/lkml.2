Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1LMTHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:07:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54092 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755167Ab1LMTHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:07:47 -0500
Date: Tue, 13 Dec 2011 14:07:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH v5 5/6] ata: add ata port system PM callbacks
In-Reply-To: <1323802667.3060.2.camel@hp6530s>
Message-ID: <Pine.LNX.4.44L0.1112131405560.1192-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Lin Ming wrote:

> > This suggests that the PM core is not the right place to solve the 
> > problem.  One possible solution is for the subsystem or device driver 
> > to call pm_runtime_get_sync(dev->parent) at the start of the 
> > system-resume procedure and pm_runtime_put_sync(dev->parent) at the 
> > end.
> 
> How about below?
> (Not tested yet)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index a633076..5cf9a19 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -71,9 +71,17 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
>  static int scsi_bus_resume_common(struct device *dev)
>  {
>  	int err = 0;
> +	bool put = false;
>  
> -	if (scsi_is_sdev_device(dev))
> +	if (scsi_is_sdev_device(dev)) {
> +		if (dev->parent && pm_runtime_suspended(dev->parent)) {
> +			pm_runtime_get_sync(dev->parent);
> +			put = true;
> +		}

You don't need to test anything.  Always call pm_runtime_get_sync().

>  		err = scsi_dev_type_resume(dev);
> +		if (put)
> +			pm_runtime_put_sync(dev->parent);

Same here.

> +	}
>  
>  	if (err == 0) {
>  		pm_runtime_disable(dev);

Alan Stern

