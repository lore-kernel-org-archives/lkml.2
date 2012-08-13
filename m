Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2HMTUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 15:20:22 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38897 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752148Ab2HMTUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 15:20:21 -0400
Date: Mon, 13 Aug 2012 15:20:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH][Alternative][RFC] PM / Runtime: Introduce driver runtime
 PM work routine
In-Reply-To: <201208132047.08376.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1208131454310.21234-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012, Rafael J. Wysocki wrote:

> > __pm_runtime_barrier() has never made very strong guarantees about 
> > runtime_resume callbacks.  But the kerneldoc does claim that any 
> > pending callbacks will have been completed, and that claim evidently is 
> > violated in the rpm_resume(parent,0) case.
> 
> "Flush all pending requests for the device from pm_wq and wait for all
> runtime PM operations involving the device in progress to complete."
> 
> It doesn't mention the parent.

You're missing the point.  Suppose you do an async resume and while the
workqueue routine is executing pm_resume(parent,0), another thread
calls pm_runtime_barrier() for the same device.  The barrier will
return more or less immediately, even though there is a runtime PM
operation involving the device (that is, the async resume) still in
progress.  The rpm_resume() routine was running before
pm_runtime_barrier() was called and will still be running afterward.

> But I agree, it's not very clear.
> 
> > Maybe the kerneldoc needs to be changed, or maybe we need to fix the code.
> 
> If anything, I'd change the kerneldoc.  The code pretty much has to be
> what it is in this respect.

I'm not sure what guarantees pm_runtime_barrier() _can_ make about
runtime_resume callbacks.  If you call that routine while the device is
suspended then a runtime_resume callback could occur at any moment,
because userspace can write "on" to the power/control attribute
whenever it wants to.

I guess the best we can say is that if you call pm_runtime_barrier()  
after updating the dev_pm_ops method pointers then after the barrier
returns, the old method pointers will not be invoked and the old method
routines will not be running.  So we need an equivalent guarantee with
regard to the pm_runtime_work pointer.  (Yes, we could use a better 
name for that pointer.)

Which means the code in the patch isn't quite right, because it saves 
the pm_runtime_work pointer before calling rpm_resume().  Maybe we 
should avoid looking at the pointer until rpm_resume() returns.

> I think that it's better to reorder the checks so that the final ordering is:
> 
> * check power.no_callbacks and parent status
> * check RPM_RUN_WORK
> * check RPM_RESUMING || RPM_SUSPENDING
> * check RPM_ASYNC
> 
> so that we don't schedule the execution of pm_runtime_work() if
> power.no_callbacks is set and the parent is active and we still do the
> power.deferred_resume optimization if RPM_RUN_WORK is unset.

That seems reasonable.

Alan Stern

