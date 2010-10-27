Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab0J0Agb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:36:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:29122 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933331Ab0J0Aga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:36:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,243,1286175600"; 
   d="scan'208";a="671203817"
Subject: Re: [PATCH] apds9802als: add runtime PM support
From: Hong Liu <hong.liu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@linux.intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1010260944270.1634-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1010260944270.1634-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Wed, 27 Oct 2010 08:39:21 +0800
Message-ID: <1288139961.19329.401.camel@hongdev>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 21:51 +0800, Alan Stern wrote:
> On Tue, 26 Oct 2010, Hong Liu wrote:
> 
> > > > diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
> > > > index fbe4960..15f9436 100644
> > > > --- a/drivers/misc/apds9802als.c
> > > > +++ b/drivers/misc/apds9802als.c
> > > 
> > > > @@ -265,13 +274,34 @@ static int apds9802als_suspend(struct i2c_client *client, pm_message_t mesg)
> > > >  
> > > >  static int apds9802als_resume(struct i2c_client *client)
> > > >  {
> > > > -	struct als_data *data = i2c_get_clientdata(client);
> > > > +	als_set_default_config(client);
> > > > +
> > > > +	pm_runtime_get(&client->dev);
> > > > +	pm_runtime_put(&client->dev);
> > > > +	return 0;
> > > > +}
> > > 
> > 
> > Hi, Alan
> > 
> > Thanks for your review.
> > 
> > > This almost certainly does not do what you think.
> > > 
> > > pm_runtime_get() will increment the device's usage count and queue an 
> > > asynchronous resume request.  However, since the PM workqueue is frozen 
> > > during system sleep transitions, the device will remain suspended.
> > > 
> > > The pm_runtime_put() will decrement the usage count again, but since
> > > there is already an async resume on the queue it will not queue an
> > > async suspend.  The final result will be that when tasks are unfrozen,
> > > the device will finally be resumed -- long after it should have been.
> > > 
> > > It looks like what you want to do here is simply call
> > > apds9802als_runtime_resume() directly.  
> > 
> > You mean apds9802als_runtime_suspend()?
> 
> This is about the function listed above: apds9802als_resume().  It
> should call apds9802als_runtime_resume() directly.  I don't see any
> reason why you would want it to call apds9802als_runtime_suspend() --
> having a resume function that actually suspends the device doesn't make
> any sense.

In apds9802als_resume, I just want to power up the device, do some
configuration, and then runtime_suspend the device.

We don't have runtime_idle() implemented, the driver exported sysfs
entries to user space for data reading, and we do runtime_resume,
measaure data, runtime_suspend in the read/write funciton of those sysfs
entries. This is why I want to put the device into runtime suspend
manually whenever possible.


> 
> > I want to put the device into
> > runtime suspended state, can I just call pm_runtime_suspend() directly?
> 
> Why do you want apds9802als_resume() to put the device into a suspended 
> state?  Shouldn't it _resume_ the device?
> 
> > > And according to the advice in
> > > Documentation/power/runtime_pm.txt section 6, you should also call
> 
> Have you read that document?
> 
> > > 	pm_runtime_disable(dev);
> > > 	pm_runtime_set_active(dev);
> > > 	pm_runtime_enable(dev);
> > > 
> > > You probably also do not want the asynchronous calls to 
> > > pm_runtime_get() and pm_runtime_put() in apds9802als_probe().  A more 
> > > common sequence is:
> > > 
> > > 	pm_runtime_set_active(dev);
> > > 	pm_runtime_enable(dev);
> > 
> > I want to put the device into runtime suspend state after probe, so
> > pm_runtime_suspend() after these two calls is OK?
> 
> No.  Try doing what I said.  You should find that the device _does_ get
> runtime-suspended when the probe function returns.  Assuming you have
> defined a proper apds9802als_runtime_idle() function.

We don't have runtime_idle() implemented, so I have to manually put the
device into runtime suspend.

Thanks,
Hong

> 
> Alan Stern
> 


