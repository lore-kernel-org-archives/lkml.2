Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2HMQYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:24:01 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42171 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752386Ab2HMQYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:24:00 -0400
Date: Mon, 13 Aug 2012 12:23:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH][Alternative][RFC] PM / Runtime: Introduce driver runtime
 PM work routine
In-Reply-To: <201208130021.44405.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1208131156390.15086-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012, Rafael J. Wysocki wrote:

> > Firstly, the patch doesn't do anything in the case where the device is
> > already at full power.
> 
> This is intentional, because I'm not sure that the code to be run
> if pm_runtime_get() returns 1 should always be pm_runtime_work().
> 
> For example, the driver may want to acquire a lock before running
> pm_runtime_get() and execute that code under the lock.

Your reason above makes sense, but the example isn't quite right.  If
the driver wants to execute the callback under a lock then the callback
has to take that lock -- this is necessary because of the async
workqueue case.

In other words, you're saying there may well be situations where the
synchronous and async cases need to run slightly different code.  True 
enough.

> > Secondly, is it necessary for __pm_runtime_barrier() to wait for the 
> > callback routine?
> 
> I believe so.  At least that's what is documented about __pm_runtime_barrier().
> 
> > More generally, does __pm_runtime_barrier() really 
> > do what it's supposed to do?  What happens if it runs at the same time 
> > as another thread is executing the pm_runtime_put(parent) call at the 
> > end of rpm_resume(), or the rpm_resume(parent, 0) in the middle?
> 
> So these are two different situations.  When pm_runtime_put(parent) is
> executed, the device has been resumed and no runtime PM code _for_ _the_
> _device_ is running (although the trace_rpm_return_int() is at a wrong
> place in my opinion).  The second one is more interesting, but it really
> is equivalent to calling pm_runtime_resume() (in a different thread)
> after __pm_runtime_barrier() has run.

__pm_runtime_barrier() has never made very strong guarantees about 
runtime_resume callbacks.  But the kerneldoc does claim that any 
pending callbacks will have been completed, and that claim evidently is 
violated in the rpm_resume(parent,0) case.  Maybe the kerneldoc needs 
to be changed, or maybe we need to fix the code.

> > For instance, consider what happens in the "no_callbacks" case where
> > the parent is already active.
> 
> The no_callbacks case is actually interesting, because I think that the
> function should return 1 in that case.  Otherwise, the caller of
> pm_runtime_get() may think that it has to wait for the device to resume,
> which isn't the case.  So, this seems to need fixing now.

Right.

> Moreover, if power.no_callbacks is set, the RPM_SUSPENDING and RPM_RESUMING
> status values are impossible, as far as I can say, so the entire "no callbacks"
> section should be moved right after the check against RPM_ACTIVE.  The same
> appears to apply to the analogous "no callbacks" check in rpm_suspend() (i.e.
> it should be done earlier).

I'm not so sure about that.  Basically we've got two conditions:

	if (A) {
		...
	}
	if (B) {
		...
	}

where A and B can never both be true.  In this situation it doesn't 
make much difference what order you do the tests.  We should use 
whichever order is better for adding the RPM_RUN_WORK code.

Alan Stern

