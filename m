Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2HMTuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 15:50:54 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36363 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab2HMTuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 15:50:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH][Alternative][RFC] PM / Runtime: Introduce driver runtime PM work routine
Date: Mon, 13 Aug 2012 21:56:48 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <Pine.LNX.4.44L0.1208131454310.21234-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208131454310.21234-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208132156.48942.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 13, 2012, Alan Stern wrote:
> On Mon, 13 Aug 2012, Rafael J. Wysocki wrote:
> 
> > > __pm_runtime_barrier() has never made very strong guarantees about 
> > > runtime_resume callbacks.  But the kerneldoc does claim that any 
> > > pending callbacks will have been completed, and that claim evidently is 
> > > violated in the rpm_resume(parent,0) case.
> > 
> > "Flush all pending requests for the device from pm_wq and wait for all
> > runtime PM operations involving the device in progress to complete."
> > 
> > It doesn't mention the parent.
> 
> You're missing the point.  Suppose you do an async resume and while the
> workqueue routine is executing pm_resume(parent,0), another thread
> calls pm_runtime_barrier() for the same device.  The barrier will
> return more or less immediately, even though there is a runtime PM
> operation involving the device (that is, the async resume) still in
> progress.  The rpm_resume() routine was running before
> pm_runtime_barrier() was called and will still be running afterward.

I see what you mean now.

> > But I agree, it's not very clear.
> > 
> > > Maybe the kerneldoc needs to be changed, or maybe we need to fix the code.
> > 
> > If anything, I'd change the kerneldoc.  The code pretty much has to be
> > what it is in this respect.
> 
> I'm not sure what guarantees pm_runtime_barrier() _can_ make about
> runtime_resume callbacks.  If you call that routine while the device is
> suspended then a runtime_resume callback could occur at any moment,
> because userspace can write "on" to the power/control attribute
> whenever it wants to.
> 
> I guess the best we can say is that if you call pm_runtime_barrier()  
> after updating the dev_pm_ops method pointers then after the barrier
> returns, the old method pointers will not be invoked and the old method
> routines will not be running.  So we need an equivalent guarantee with
> regard to the pm_runtime_work pointer.  (Yes, we could use a better 
> name for that pointer.)
> 
> Which means the code in the patch isn't quite right, because it saves 
> the pm_runtime_work pointer before calling rpm_resume().  Maybe we 
> should avoid looking at the pointer until rpm_resume() returns.

Yes, we can do that.

Alternatively, we can set power.work_in_progress before calling
rpm_resume(dev, 0) (i.e. regard the resume as a part of the work) to make
the barrier wait for all of it to complete.

> > I think that it's better to reorder the checks so that the final ordering is:
> > 
> > * check power.no_callbacks and parent status
> > * check RPM_RUN_WORK
> > * check RPM_RESUMING || RPM_SUSPENDING
> > * check RPM_ASYNC
> > 
> > so that we don't schedule the execution of pm_runtime_work() if
> > power.no_callbacks is set and the parent is active and we still do the
> > power.deferred_resume optimization if RPM_RUN_WORK is unset.
> 
> That seems reasonable.

OK

Thanks,
Rafael
