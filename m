Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2HLWPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 18:15:49 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab2HLWPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 18:15:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH][Alternative][RFC] PM / Runtime: Introduce driver runtime PM work routine
Date: Mon, 13 Aug 2012 00:21:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <Pine.LNX.4.44L0.1208121203590.17879-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208121203590.17879-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208130021.44405.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 12, 2012, Alan Stern wrote:
> On Thu, 9 Aug 2012, Rafael J. Wysocki wrote:
> 
> > There are some known concerns about this approach.
> > 
> > First of all, the patch at
> > 
> > https://patchwork.kernel.org/patch/1299781/
> > 
> > increases the size of struct device by the size of a pointer, which may seem to
> > be a bit excessive to somebody, although I personally don't think it's a big
> > problem.  We don't use _that_ many struct device objects for it to matter much.
> > 
> > Second, which is more important to me, it seems that for a given device func()
> > will always be the same pointer and it will be used by the device's driver
> > only.  In that case, most likely, it will be possible to determine the
> > address of func() at the time of driver initialization, so the setting and
> > clearing of power.func and passing the address of func() as an argument every
> > time __pm_runtime_get_and_call() is run may turn out to be an unnecessary
> > overhead.  Thus it may be more efficient to use a function pointer in struct
> > device_driver (it can't be located in struct dev_pm_ops, because some drivers
> > don't use it at all, like USB drivers, and it wouldn't be useful for subsystems
> > and PM domains) to store the address of func() permanently.
> > 
> > For the above reasons, the appended patch implements an alternative approach,
> > which is to modify the way pm_runtime_get() works so that, when the device is
> > not active, it will queue a resume request for the device _along_ _with_ the
> > execution of a driver routine provided through a new function pointer
> > .pm_runtime_work().  There also is pm_runtime_get_nowork() that won't do that
> > and works in the same way as the "old" pm_runtime_get().
> > 
> > Of course, the disadvantage of the new patch is that it makes the change
> > in struct device_driver, but perhaps it's not a big deal.
> > 
> > I wonder what you think.
> 
> I have some concerns about this patch.
> 
> Firstly, the patch doesn't do anything in the case where the device is
> already at full power.

This is intentional, because I'm not sure that the code to be run
if pm_runtime_get() returns 1 should always be pm_runtime_work().

For example, the driver may want to acquire a lock before running
pm_runtime_get() and execute that code under the lock.

> Should we invoke the callback routine 
> synchronously?  This loses the advantage of a workqueue's "pristine" 
> environment, but on the other hand it is much more efficient.

I'm not sure if it is always going to be more efficient.

> (And we're talking about hot pathways, where efficiency matters.)  The 
> alternative, of course, is to have the driver invoke the callback 
> directly if pm_runtime_get() returns 1.

Sure.  If every user of .pm_runtime_work() ends up calling it when
pm_runtime_get() returns 1, then there will be a point to modify the
core to do that instead.  However, I'm not sure if that's going to be the
case at the moment.

> Secondly, is it necessary for __pm_runtime_barrier() to wait for the 
> callback routine?

I believe so.  At least that's what is documented about __pm_runtime_barrier().

> More generally, does __pm_runtime_barrier() really 
> do what it's supposed to do?  What happens if it runs at the same time 
> as another thread is executing the pm_runtime_put(parent) call at the 
> end of rpm_resume(), or the rpm_resume(parent, 0) in the middle?

So these are two different situations.  When pm_runtime_put(parent) is
executed, the device has been resumed and no runtime PM code _for_ _the_
_device_ is running (although the trace_rpm_return_int() is at a wrong
place in my opinion).  The second one is more interesting, but it really
is equivalent to calling pm_runtime_resume() (in a different thread)
after __pm_runtime_barrier() has run.

> Thirdly, I would reorganize the new code added to pm_runtime_work(); 
> see below.
> 
> 
> > @@ -533,6 +550,13 @@ static int rpm_resume(struct device *dev
> >  		goto out;
> >  	}
> >  
> > +	if ((rpmflags & RPM_ASYNC) && (rpmflags & RPM_RUN_WORK)) {
> > +		dev->power.run_driver_work = true;
> > +		rpm_queue_up_resume(dev);
> > +		retval = 0;
> > +		goto out;
> > +	}
> > +
> 
> The section of code just before the start of this hunk exits the
> routine if the device is already active.  Do you want to put this new
> section in the preceding "if" block?

Yes, I do.  This is to ensure that the execution of pm_runtime_work() will
be scheduled if RPM_RUN_WORK is set.

> Also, it feels odd to have this code here when there is another section
> lower down that also tests for RPM_ASYNC and does almost the same
> thing.  It suggests that this new section isn't in the right place.

Yes, it does.  However, the code between the two questions contains some checks
that I want to skip if RPM_RUN_WORK is set (otherwis, the execution of
pm_runtime_work() may not be scheduled at all).

> For instance, consider what happens in the "no_callbacks" case where
> the parent is already active.

The no_callbacks case is actually interesting, because I think that the
function should return 1 in that case.  Otherwise, the caller of
pm_runtime_get() may think that it has to wait for the device to resume,
which isn't the case.  So, this seems to need fixing now.

Moreover, if power.no_callbacks is set, the RPM_SUSPENDING and RPM_RESUMING
status values are impossible, as far as I can say, so the entire "no callbacks"
section should be moved right after the check against RPM_ACTIVE.  The same
appears to apply to the analogous "no callbacks" check in rpm_suspend() (i.e.
it should be done earlier).

After those changes I'd put "my" check against RPM_RUN_WORK after the
"no callbacks" check, but before the "RPM_SUSPENDING or RPM_RESUMING" one.

> > @@ -715,11 +736,29 @@ static void pm_runtime_work(struct work_
> >  		rpm_suspend(dev, RPM_NOWAIT | RPM_AUTO);
> >  		break;
> >  	case RPM_REQ_RESUME:
> > -		rpm_resume(dev, RPM_NOWAIT);
> > +		if (dev->power.run_driver_work && dev->driver->pm_runtime_work)
> > +			driver_work = dev->driver->pm_runtime_work;
> > +
> > +		dev->power.run_driver_work = false;
> > +		rpm_resume(dev, driver_work ? 0 : RPM_NOWAIT);
> >  		break;
> >  	}
> >  
> >   out:
> > +	if (driver_work) {
> > +		pm_runtime_get_noresume(dev);
> > +		dev->power.work_in_progress = true;
> > +		spin_unlock_irq(&dev->power.lock);
> > +
> > +		driver_work(dev);
> > +
> > +		spin_lock_irq(&dev->power.lock);
> > +		dev->power.work_in_progress = false;
> > +		wake_up_all(&dev->power.wait_queue);
> > +		pm_runtime_put_noidle(dev);
> > +		rpm_idle(dev, RPM_NOWAIT);
> > +	}
> > +
> 
> It seems very illgical to do all the callback stuff here, after the
> "switch" statement.  IMO it would make more sense to put it all
> together, more or less as follows:
> 
> 	case RPM_REQ_RESUME:
> 		if (dev->power.run_driver_work && dev->driver->pm_runtime_work) {
> 			driver_work = dev->driver->pm_runtime_work;
> 			dev->power.run_driver_work = false;
> 			dev->power.work_in_progress = true;
> 			pm_runtime_get_noresume(dev);
> 			rpm_resume(dev, 0);
> 			spin_unlock_irq(&dev->power.lock);
> 
> 			driver_work(dev);
> 
> 			spin_lock_irq(&dev->power.lock);
> 			dev->power.work_in_progress = false;
> 			wake_up_all(&dev->power.wait_queue);
> 			pm_runtime_put_noidle(dev);
> 			rpm_idle(dev, RPM_NOWAIT);
> 		} else {
> 			rpm_resume(dev, RPM_NOWAIT);
> 		}
> 		break;

OK

> Notice also that it's important to do the _get_noresume _before_
> calling rpm_resume().  Otherwise the device might get suspended again
> before the callback gets a chance to run.

You're right.  I forgot about dropping the lock in order to call
pm_runtime_put(parent).

Thanks,
Rafael
