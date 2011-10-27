Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1J0SaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 14:30:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51138 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754353Ab1J0SaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 14:30:10 -0400
Date: Thu, 27 Oct 2011 14:30:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: RE: [PATCH] PM: fix calculation mistake in roll-over cases
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6D123A0AFF@BGMAIL02.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1110271426100.2004-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011, Venu Byravarasu wrote:

> > From: venu byravarasu <vbyravarasu@nvidia.com>
> > 
> > In case of jiffies roll over, delta is made zero.
> > Hence fixing it, after taking roll over into consideration.
> > 
> > Signed-off-by: venu byravarasu <vbyravarasu@nvidia.com>
> > ---
> > When jiffies roll over, calculation of time spent in the
> > current state (stored in variable 'delta') is incorrect.
> > Hence fixing it, after taking roll over into consideration.
> > 
> >  drivers/base/power/runtime.c |    7 ++++---
> >  1 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> > index 1079e03..bd93fb0 100644
> > --- a/drivers/base/power/runtime.c
> > +++ b/drivers/base/power/runtime.c
> > @@ -30,12 +30,13 @@ static int rpm_suspend(struct device *dev, int rpmflags);
> >  void update_pm_runtime_accounting(struct device *dev)
> >  {
> >  	unsigned long now = jiffies;
> > -	int delta;
> > +	unsigned long delta;

That change is correct.

> > +	unsigned long max_num = ~0;

max_num is not needed.

> >  
> >  	delta = now - dev->power.accounting_timestamp;
> >  
> > -	if (delta < 0)
> > -		delta = 0;

That change is correct.

> > +	if (now < dev->power.accounting_timestamp)
> > +		delta = max_num - dev->power.accounting_timestamp + now;

These two lines are not needed.

> >  
> >  	dev->power.accounting_timestamp = now;
> 
> > I'm not sure how this is supposed to improve things.  Care to give more
> > details?
> Below two items were taken care with this change:
> 1. Value of now is jiffies which is unsigned long.
> As it is being stored in delta of 'int' type, for all values of now > 0x80000000,
> Delta will be made 0 with the original if condition.
> By changing delta to unsigned long, this is taken care.

Yes, that's the right thing to do.

> 2. Even if delta is made unsigned, in cases of jiffies roll over, delta will be zero.
> That is also being taken care with the code added as part of if condition.

Since delta is now unsigned, the "if (delta < 0)" test can never
succeed.  Therefore it can be removed.

The new lines you added with max_num don't seem to serve any useful 
purpose.  All they do is recalculate the same value that delta had 
before, but with an off-by-one error.

Alan Stern

