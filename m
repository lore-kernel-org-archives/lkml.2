Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab2IUUWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:22:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48066 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757887Ab2IUUWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:22:14 -0400
Date: Fri, 21 Sep 2012 16:22:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kevin Hilman <khilman@deeprootsystems.com>, <linux-pm@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Nishanth Menon <nm@ti.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] PM / Runtime: let rpm_resume() succeed if
 RPM_ACTIVE, even when disabled
In-Reply-To: <201209212129.24244.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1209211611020.1323-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012, Rafael J. Wysocki wrote:

> > Kevin makes a good case that pm_runtime_resume() and related functions 
> > should succeed even when runtime PM is disabled, if the device is 
> > already in the desired state.
> > 
> > The same may be true for pm_runtime_suspend().  What do you think?
> 
> I've discussed that with Kevin.  The problem is that the runtime PM
> status may be changed at will when runtime PM is disabled by using
> __pm_runtime_set_status(), so the status generally cannod be trusted
> if power.disable_depth > 0.

Hmmm.  That same argument applies even when is_suspended is true.  
Runtime PM might have been disabled beforehand by the driver, so you 
still don't know whether to believe the status.

> During system suspend, however, runtime PM is disabled by the core and
> if neither the driver nor the subsystem has disabled it in the meantime,
> the status should be actually valid.

I suppose you could check that .disable_depth == 1.  That would mean 
only the core had disabled runtime PM.

> > The way the patch is written contradicts the documentation:
> > 
> >   * A request to execute ->runtime_resume() will cancel any pending or
> >     scheduled requests to execute the other callbacks for the same device,
> >     except for scheduled autosuspends.
> 
> I'm not sure where the contradiction is.  The patch simply changes the
> behavior for disabled runtime PM, which is to return a nonzero value immediately
> anyway.

It changes an error return to a non-error return.

However, if we limit the effects to times when the system is 
suspending then there shouldn't be any pending or scheduled requests 
anyway.  So okay, this isn't an issue.

> > > > @@ -510,7 +510,8 @@ static int rpm_resume(struct device *dev, int rpmflags)
> > > >  	if (dev->power.runtime_error)
> > > >  		retval = -EINVAL;
> > > >  	else if (dev->power.disable_depth > 0)
> > > > -		retval = -EACCES;
> > > > +		retval = dev->power.is_suspended && 
> > > > +			dev->power.runtime_status == RPM_ACTIVE ? 1 : -EACCES;
> > > >  	if (retval)
> > > >  		goto out;
> > 
> > Also, the is_suspended test seems irrelevant in general -- it makes 
> > sense in terms of the scenario Kevin described but that's not the 
> > stated purpose of the patch.
> 
> Well, it is, although the changelog doesn't state it sufficiently clearly. :-)

Good point.  The changelog needs to be improved.

> > Both of these problems can be addressed by writing the code as follows:
> > 
> > 	if (dev->power.runtime_error)
> > 		retval = -EINVAL;
> > 	else if (dev->power.disable_depth > 0) {
> > 
> > 		/* Special case: allow this if the device is already active */
> > 		if (dev->power.runtime_status != RPM_ACTIVE)
> > 			retval = -EACCES;
> > 	}
> > 	if (retval)
> > 		goto out;
> 
> We could do that too, but I'm a bit concerned about the situations where
> runtime PM is disabled by the driver itself or by the subsystem, because
> in those cases whoever disables runtime PM would have to make sure that the
> status still reflects the actual hardware state, but that's what the runtime
> PM framework is for (among other things).

All right, let's use Kevin's original scheme but add a test for 
disable_depth == 1.  I suggest changing the ?: operator to a regular 
"if" statement, because the new condition will be even longer than the 
old one (which I found a little hard to read in the first place).

And of course, a comment should be added to explain the reason for the
exception.

Kevin, how does this sound?

Alan Stern

