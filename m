Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2HMSlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:41:16 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2HMSlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:41:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH][Alternative][RFC] PM / Runtime: Introduce driver runtime PM work routine
Date: Mon, 13 Aug 2012 20:47:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <Pine.LNX.4.44L0.1208131156390.15086-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208131156390.15086-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208132047.08376.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 13, 2012, Alan Stern wrote:
> On Mon, 13 Aug 2012, Rafael J. Wysocki wrote:
> 
> > > Firstly, the patch doesn't do anything in the case where the device is
> > > already at full power.
> > 
> > This is intentional, because I'm not sure that the code to be run
> > if pm_runtime_get() returns 1 should always be pm_runtime_work().
> > 
> > For example, the driver may want to acquire a lock before running
> > pm_runtime_get() and execute that code under the lock.
> 
> Your reason above makes sense, but the example isn't quite right.  If
> the driver wants to execute the callback under a lock then the callback
> has to take that lock -- this is necessary because of the async
> workqueue case.

I thought about this scenario:

* acquire lock
* do something
* ret = pm_runtime_get(dev);
* if (ret > 0)
      do something more
* pm_runtime_put(dev);
* release lock

in which the "do something more" thing cannot be the same as the contents
of the .pm_runtime_work() callback (I notice that I have a collision of
names between the callback and the workqueue function in runtime.c), unless
that callback doesn't acquire the same lock.

> In other words, you're saying there may well be situations where the
> synchronous and async cases need to run slightly different code.

Yes.

> True enough.

:-)

> > > Secondly, is it necessary for __pm_runtime_barrier() to wait for the 
> > > callback routine?
> > 
> > I believe so.  At least that's what is documented about __pm_runtime_barrier().
> > 
> > > More generally, does __pm_runtime_barrier() really 
> > > do what it's supposed to do?  What happens if it runs at the same time 
> > > as another thread is executing the pm_runtime_put(parent) call at the 
> > > end of rpm_resume(), or the rpm_resume(parent, 0) in the middle?
> > 
> > So these are two different situations.  When pm_runtime_put(parent) is
> > executed, the device has been resumed and no runtime PM code _for_ _the_
> > _device_ is running (although the trace_rpm_return_int() is at a wrong
> > place in my opinion).  The second one is more interesting, but it really
> > is equivalent to calling pm_runtime_resume() (in a different thread)
> > after __pm_runtime_barrier() has run.
> 
> __pm_runtime_barrier() has never made very strong guarantees about 
> runtime_resume callbacks.  But the kerneldoc does claim that any 
> pending callbacks will have been completed, and that claim evidently is 
> violated in the rpm_resume(parent,0) case.

"Flush all pending requests for the device from pm_wq and wait for all
runtime PM operations involving the device in progress to complete."

It doesn't mention the parent.

But I agree, it's not very clear.

> Maybe the kerneldoc needs to be changed, or maybe we need to fix the code.

If anything, I'd change the kerneldoc.  The code pretty much has to be
what it is in this respect.

> > > For instance, consider what happens in the "no_callbacks" case where
> > > the parent is already active.
> > 
> > The no_callbacks case is actually interesting, because I think that the
> > function should return 1 in that case.  Otherwise, the caller of
> > pm_runtime_get() may think that it has to wait for the device to resume,
> > which isn't the case.  So, this seems to need fixing now.
> 
> Right.
> 
> > Moreover, if power.no_callbacks is set, the RPM_SUSPENDING and RPM_RESUMING
> > status values are impossible, as far as I can say, so the entire "no callbacks"
> > section should be moved right after the check against RPM_ACTIVE.  The same
> > appears to apply to the analogous "no callbacks" check in rpm_suspend() (i.e.
> > it should be done earlier).
> 
> I'm not so sure about that.  Basically we've got two conditions:
> 
> 	if (A) {
> 		...
> 	}
> 	if (B) {
> 		...
> 	}
> 
> where A and B can never both be true.  In this situation it doesn't 
> make much difference what order you do the tests.  We should use 
> whichever order is better for adding the RPM_RUN_WORK code.

OK, fair enough.

I think that it's better to reorder the checks so that the final ordering is:

* check power.no_callbacks and parent status
* check RPM_RUN_WORK
* check RPM_RESUMING || RPM_SUSPENDING
* check RPM_ASYNC

so that we don't schedule the execution of pm_runtime_work() if
power.no_callbacks is set and the parent is active and we still do the
power.deferred_resume optimization if RPM_RUN_WORK is unset.

Thanks,
Rafael
