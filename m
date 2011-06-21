Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab1FUXsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:48:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab1FUXse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:48:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system sleep
Date: Wed, 22 Jun 2011 01:49:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.1106211031410.2327-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106211031410.2327-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106220149.17380.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 21, 2011, Alan Stern wrote:
> On Mon, 20 Jun 2011, Rafael J. Wysocki wrote:
> 
> > > Ah, okay.  The PCI part makes sense then.
> > 
> > OK, so the appended patch is a modification of the $subject one using
> > pm_runtime_put_sync() instead of pm_runtime_put_noidle().
> 
> Yes, it looks good.

Cool, thanks!

> > So, your point is that while .suspend() or .resume() are running, the
> > synchronization between runtime PM and system suspend/resume should be the
> > subsystem's problem, right?
> 
> Almost but not quite.  I was talking about the time period between 
> .prepare() and .suspend() (and also the time period between .resume() 
> and .complete()).
> 
> It's probably okay to prevent pm_runtime_suspend() from working during
> .suspend() or .resume(), but it's not a good idea to prevent
> pm_runtime_resume() from working then.

OK, but taking a reference by means of pm_runtime_get_noresume() won't
block pm_runtime_resume().

> > I actually see a reason for doing this.  Namely, I don't really think
> > driver writers should be bothered with preventing races between different
> > PM callbacks from happening.  Runtime PM takes care of that at run time,
> > the design of the system suspend/resume code ensures that the callbacks
> > for the same device are executed sequentially, but if we allow runtime PM
> > callbacks to be executed in parallel with system suspend/resume callbacks,
> > someone has to prevent those callbacks from racing with each other.
> > 
> > Now, if you agree that that shouldn't be a driver's task, then it has to
> > be the subsystem's one and I'm not sure what a subsystem can do other than
> > disabling runtime PM or at least taking a reference on every device before
> > calling device drivers' .suspend() callbacks.
> > 
> > Please note, I think that .prepare() and .complete() are somewhat special,
> > so perhaps we should allow those to race with runtime PM callbacks, but IMO
> > allowing .suspend() and .resume() to race with .runtime_suspend() and
> > .runtime_resume() is not a good idea.
> 
> Races in the period after .suspend() and before .resume() will be 
> handled by disabling runtime PM when .suspend() returns and enabling it 
> before calling .resume().

OK

> During the .suspend and .resume callbacks, races with
> .runtime_suspend() can be prevented by calling
> pm_runtime_get_noresume() just before .suspend() and then calling
> pm_runtime_put_sync() just after .resume().

So, you seem to suggest to call pm_runtime_get_noresume() in
__device_suspend() and pm_runtime_put_sync() in device_resume().
That would be fine by me, perhaps up to the "sync" part of the "put".

> Races with .runtime_resume() can be handled to some extent by putting a
> runtime barrier immediately after the pm_runtime_get_noresume() call,
> but that's not a perfect solution.  Is it good enough?

It's not worse than what we had before, so I guess it should be enough.

> > > What I'm suggesting is to revert the commit but at the same time,
> > > move the get_noresume() into __device_suspend() and the put_sync() into 
> > > device_resume().
> > 
> > What about doing pm_runtime_get_noresume() and the pm_runtime_barrier()
> > in dpm_prepare(), but _after_ calling device_prepare() and doing
> > pm_runtime_put_noidle() in dpm_complete() _before_ calling .complete()
> > from the subsystem
> 
> This does not address the issue of allowing runtime suspends in the 
> windows between .prepare() - .suspend() and .resume() - .complete().

OK

> >  (a _put_sync() at this point will likely invoke
> > .runtime_idle() from the subsystem before executing .complete(), which may
> > not be desirable)?
> 
> It should be allowed.  The purpose of .complete() is not to re-enable
> runtime power management of the device; it is to release resources
> (like memory) allocated during .prepare() and perhaps also to allow new
> children to be registered under the device.

Right.  But does "allowed" mean the core _should_ do it at this point?
We may as well call pm_runtime_idle() directly from rpm_complete(), but
perhaps it's better to call it from device_resume(), so that it runs in
parallel for async devices.

Thanks,
Rafael
