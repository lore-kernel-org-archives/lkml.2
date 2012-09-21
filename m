Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab2IUTWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:22:55 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:38967 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411Ab2IUTWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:22:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH RESEND] PM / Runtime: let rpm_resume() succeed if RPM_ACTIVE, even when disabled
Date: Fri, 21 Sep 2012 21:29:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-pm@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Nishanth Menon <nm@ti.com>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1209211335100.1323-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1209211335100.1323-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209212129.24244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 21, 2012, Alan Stern wrote:
> On Thu, 20 Sep 2012, Rafael J. Wysocki wrote:
> 
> > On Thursday, September 20, 2012, Kevin Hilman wrote:
> > > From: Kevin Hilman <khilman@ti.com>
> > > 
> > > When runtime PM is disabled, what we want is for callbacks not to be
> > > called from then on.  However, currently, when runtime PM is disabled,
> > > operations such as 'get' will also fail even if the device is
> > > currently active.
> > > 
> > > Since calling 'get' on a device that is already RPM_ACTIVE does not
> > > involve calling the callbacks, it should be allowed to succeed, even
> > > if runtime PM is disabled.
> > > 
> > > This is particularily useful in runtime PM enabled drivers that are
> > > used during system suspend.  Because runtime PM is disabled during
> > > system suspend, currently any driver's use of pm_runtime_get* will
> > > fail with -EACCES.  This is expected if the device was already runtime
> > > suspended, but if the device is actually active (due to recent usage,
> > > autosuspend timeout not expired, or pm_runtime_resume() called in
> > > ->suspend() method), the pm_runtime_get*() call should actually
> > > succeed.
> > 
> > I'd say the problem is when the drive in question uses the return value of
> > pm_runtime_get_sync(), for example, to decide whether or not it is safe
> > to access the hardware.  In that case it may decide that accessing the
> > hardware is unsafe during system suspend, although that's not really the
> > case.  So the change you're proposing allows drivers of this kind  (and there
> > may be a substantial number of them) to be simplified slightly.
> 
> Kevin makes a good case that pm_runtime_resume() and related functions 
> should succeed even when runtime PM is disabled, if the device is 
> already in the desired state.
> 
> The same may be true for pm_runtime_suspend().  What do you think?

I've discussed that with Kevin.  The problem is that the runtime PM
status may be changed at will when runtime PM is disabled by using
__pm_runtime_set_status(), so the status generally cannod be trusted
if power.disable_depth > 0.

During system suspend, however, runtime PM is disabled by the core and
if neither the driver nor the subsystem has disabled it in the meantime,
the status should be actually valid.

> > > To permit the usage described above, add a check to rpm_resume() so
> > > that success is returned in the case where a driver is suspended (it's
> > > ->suspend callback has been called) but is still RPM_ACTIVE.
> > > 
> > > This patch was developed in close collaboration with Rafael J. Wysocki
> > > <rjw@sisk.pl>
> > > 
> > > Tested on AM3730/Beagle-xM where wakeup IRQ firing during the late
> > > suspend phase triggers runtime PM activity in the I2C driver since the
> > > wakeup IRQ is on an I2C-connected PMIC.
> > > 
> > > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > Signed-off-by: Kevin Hilman <khilman@ti.com>
> > 
> > OK, I wonder if anyone has any objections against this.  Alan?
> 
> The way the patch is written contradicts the documentation:
> 
>   * A request to execute ->runtime_resume() will cancel any pending or
>     scheduled requests to execute the other callbacks for the same device,
>     except for scheduled autosuspends.

I'm not sure where the contradiction is.  The patch simply changes the
behavior for disabled runtime PM, which is to return a nonzero value immediately
anyway.

> > > @@ -510,7 +510,8 @@ static int rpm_resume(struct device *dev, int rpmflags)
> > >  	if (dev->power.runtime_error)
> > >  		retval = -EINVAL;
> > >  	else if (dev->power.disable_depth > 0)
> > > -		retval = -EACCES;
> > > +		retval = dev->power.is_suspended && 
> > > +			dev->power.runtime_status == RPM_ACTIVE ? 1 : -EACCES;
> > >  	if (retval)
> > >  		goto out;
> 
> Also, the is_suspended test seems irrelevant in general -- it makes 
> sense in terms of the scenario Kevin described but that's not the 
> stated purpose of the patch.

Well, it is, although the changelog doesn't state it sufficiently clearly. :-)

It fact, it is an optimization, because the driver can have a "suspended"
flag that will be set in its .suspend() routine and then do something like:

ret = pm_runtime_get_sync(dev);
if (!ret || (private_driver_data(dev)->suspended && ret == -EACCES) {
  /* access the hardware */
}

but if the above patch is applied, the driver won't need to do that (and
that's something multiple drivers may need to do, so it seems to be worth
optimizing).

> Both of these problems can be addressed by writing the code as follows:
> 
> 	if (dev->power.runtime_error)
> 		retval = -EINVAL;
> 	else if (dev->power.disable_depth > 0) {
> 
> 		/* Special case: allow this if the device is already active */
> 		if (dev->power.runtime_status != RPM_ACTIVE)
> 			retval = -EACCES;
> 	}
> 	if (retval)
> 		goto out;

We could do that too, but I'm a bit concerned about the situations where
runtime PM is disabled by the driver itself or by the subsystem, because
in those cases whoever disables runtime PM would have to make sure that the
status still reflects the actual hardware state, but that's what the runtime
PM framework is for (among other things).

Thanks,
Rafael
