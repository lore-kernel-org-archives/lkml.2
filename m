Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab1FWVQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:16:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54305 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759981Ab1FWVQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:16:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system sleep
Date: Thu, 23 Jun 2011 23:16:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.1106231656340.2033-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106231656340.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106232316.56769.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 23, 2011, Alan Stern wrote:
> On Thu, 23 Jun 2011, Rafael J. Wysocki wrote:
> 
> > > > Index: linux-2.6/drivers/base/power/runtime.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/drivers/base/power/runtime.c
> > > > +++ linux-2.6/drivers/base/power/runtime.c
> > > > @@ -455,12 +455,14 @@ static int rpm_resume(struct device *dev
> > > >  	dev_dbg(dev, "%s flags 0x%x\n", __func__, rpmflags);
> > > >  
> > > >   repeat:
> > > > -	if (dev->power.runtime_error)
> > > > +	if (dev->power.runtime_error) {
> > > >  		retval = -EINVAL;
> > > > -	else if (dev->power.disable_depth > 0)
> > > > -		retval = -EAGAIN;
> > > > -	if (retval)
> > > >  		goto out;
> > > > +	} else if (dev->power.disable_depth > 0) {
> > > > +		if (!(rpmflags & RPM_GET_PUT))
> > > > +			retval = -EAGAIN;
> > > 
> > > Do you also want to check the current status?  If it isn't RPM_ACTIVE 
> > > then perhaps you should return an error.
> > 
> > That depends on whether or not we want RPM_ACTIVE to have any meaning for
> > devices whose power.disable_depth is nonzero.  My opinion is that if
> > power.disable_depth is nonzero, the runtime PM status of the device
> > shouldn't matter (it may be changed on the fly in ways that need not
> > reflect the real status).
> 
> Then maybe this disable_depth > 0 case should return something other
> than 0.  Something new, like -EACCES.  That way the caller would
> realize something strange was going on but wouldn't have to treat the 
> situation as an error.

I would be fine with that, but then we'd need to reserve that error code,
so that it's not returned by subsystem callbacks (or even we should convert
it to a different error code if it is returned by the subsystem callback in
rpm_resume()). 

> After all, the return value from pm_runtime_get_sync() is documented to 
> be the error code for the underlying pm_runtime_resume().  It doesn't 
> refer to the increment operation -- that always succeeds.

That means we should change the caller, which is the SCSI subsystem in this
particular case, to check the error code.  The problem with this approach
is that the same error code may be returned in a different situation, so
we should prevent that from happening in the first place.  Still, suppose
that we do that and that the caller checks the error code.  What is it
supposed to do in that situation?  The only reasonable action for the
caller is to ignore the error code if it means disable_depth > 0 and go
on with whatever it has to do, but that's what it will do if the
pm_runtime_get_sync() returns 0 in that situation.

So, in my opinion it simply may be best to update the documentation of
pm_runtime_get_sync() along with the code changes. :-)

Thanks,
Rafael
