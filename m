Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0JZGAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:00:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:45986 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab0JZGAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:00:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,239,1286175600"; 
   d="scan'208";a="340452841"
Subject: Re: [PATCH] apds9802als: add runtime PM support
From: Hong Liu <hong.liu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@linux.intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1010211418520.1718-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1010211418520.1718-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Tue, 26 Oct 2010 14:05:17 +0800
Message-ID: <1288073117.19329.392.camel@hongdev>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 02:34 +0800, Alan Stern wrote:
> On Fri, 15 Oct 2010, Alan Cox wrote:
> 
> > From: Hong Liu <hong.liu@intel.com>
> > 
> > 
> >     Update the driver for the needed runtime power features. Remove the old
> >     user controlled power functions.
> > 
> >     Signed-off-by: Hong Liu <hong.liu@intel.com>
> >     Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> > diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
> > index fbe4960..15f9436 100644
> > --- a/drivers/misc/apds9802als.c
> > +++ b/drivers/misc/apds9802als.c
> 
> > @@ -265,13 +274,34 @@ static int apds9802als_suspend(struct i2c_client *client, pm_message_t mesg)
> >  
> >  static int apds9802als_resume(struct i2c_client *client)
> >  {
> > -	struct als_data *data = i2c_get_clientdata(client);
> > +	als_set_default_config(client);
> > +
> > +	pm_runtime_get(&client->dev);
> > +	pm_runtime_put(&client->dev);
> > +	return 0;
> > +}
> 

Hi, Alan

Thanks for your review.

> This almost certainly does not do what you think.
> 
> pm_runtime_get() will increment the device's usage count and queue an 
> asynchronous resume request.  However, since the PM workqueue is frozen 
> during system sleep transitions, the device will remain suspended.
> 
> The pm_runtime_put() will decrement the usage count again, but since
> there is already an async resume on the queue it will not queue an
> async suspend.  The final result will be that when tasks are unfrozen,
> the device will finally be resumed -- long after it should have been.
> 
> It looks like what you want to do here is simply call
> apds9802als_runtime_resume() directly.  

You mean apds9802als_runtime_suspend()? I want to put the device into
runtime suspended state, can I just call pm_runtime_suspend() directly?

> And according to the advice in
> Documentation/power/runtime_pm.txt section 6, you should also call
> 
> 	pm_runtime_disable(dev);
> 	pm_runtime_set_active(dev);
> 	pm_runtime_enable(dev);
> 
> You probably also do not want the asynchronous calls to 
> pm_runtime_get() and pm_runtime_put() in apds9802als_probe().  A more 
> common sequence is:
> 
> 	pm_runtime_set_active(dev);
> 	pm_runtime_enable(dev);

I want to put the device into runtime suspend state after probe, so
pm_runtime_suspend() after these two calls is OK?

Thanks,
Hong

> 
> Alan Stern
> 


