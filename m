Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0IBTrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:47:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab0IBTri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:47:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after abort
Date: Thu, 2 Sep 2010 21:46:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1009020946580.1513-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009020946580.1513-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009022146.03359.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010, Alan Stern wrote:
> On Wed, 1 Sep 2010, Colin Cross wrote:
> 
> > Only wait on a parent device during resume if the parent device is
> > suspended.
> > 
> > Consider three drivers, A, B, and C.  The parent of A is C, and C
> > has async_suspend set.  On boot, C->power.completion is initialized
> > to 0.
> > 
> > During the first suspend:
> > suspend_devices_and_enter(...)
> >  dpm_resume(...)
> >   device_suspend(A)
> >   device_suspend(B) returns error, aborts suspend
> >  dpm_resume_end(...)
> >    dpm_resume(...)
> >     device_resume(A)
> >      dpm_wait(A->parent == C)
> >       wait_for_completion(C->power.completion)
> > 
> > The wait_for_completion will never complete, because
> > complete_all(C->power.completion) will only be called from
> > device_suspend(C) or device_resume(C), neither of which is called
> > if suspend is aborted before C.
> 
> This would work okay if C->power.completion had been initialized to the 
> completed state during boot, right?
> 
> > After a successful suspend->resume cycle, where B doesn't abort
> > suspend, C->power.completion is left in the completed state by the
> > call to device_resume(C), and the same call path will work if B
> > aborts suspend.
> > 
> > Signed-off-by: Colin Cross <ccross@android.com>
> > ---
> >  drivers/base/power/main.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > index cb784a0..e159910 100644
> > --- a/drivers/base/power/main.c
> > +++ b/drivers/base/power/main.c
> > @@ -526,7 +526,8 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
> >  	TRACE_DEVICE(dev);
> >  	TRACE_RESUME(0);
> >  
> > -	dpm_wait(dev->parent, async);
> > +	if (dev->parent && dev->parent->power.status >= DPM_OFF)
> > +		dpm_wait(dev->parent, async);
> >  	device_lock(dev);
> >  
> >  	dev->power.status = DPM_RESUMING;
> 
> I think it would be better to change device_pm_init() and add a 
> complete_all().

I agree.

Who's writing the patch?

Rafael
