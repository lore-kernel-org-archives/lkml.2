Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2KMFM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:12:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:30615 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab2KMFMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:12:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="167556059"
Message-ID: <1352783539.7176.212.camel@yhuang-dev>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and
 forbidden
From: Huang Ying <ying.huang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Tue, 13 Nov 2012 13:12:19 +0800
In-Reply-To: <Pine.LNX.4.44L0.1211122120140.6961-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1211122120140.6961-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 21:32 -0500, Alan Stern wrote:
> On Tue, 13 Nov 2012, Huang Ying wrote:
> 
> > Sorry, my original idea is:
> > 
> > 	pm_runtime_disable will put device into SUSPENDED state if
> > 	dev->power.runtime_auto is clear.  pm_runtime_allow will put
> > 	device into SUSPENDED state if dev->power.disable_depth > 0.
> 
> That's close to what I suggested.
> 
> > So in general, my original idea is to manage device runtime power state
> > automatically instead of manually, especially when device is in disabled
> > state.
> > 
> > 	disabled + forbidden	-> ACTIVE
> > 	disabled + !forbidden	-> SUSPENDED
> 
> This is not quite right.  Consider a device that is in runtime suspend 
> when a system sleep starts.  When the system sleep ends, the device 
> will be resumed but the PM core will still think its state is 
> SUSPENDED.  The subsystem has to tell the PM core that the device is 
> now ACTIVE.  Currently, subsystems do this by calling 
> pm_runtime_disable, pm_runtime_set_active, pm_runtime_enable.  Under 
> your scheme this wouldn't work; the pm_runtime_set_active call would 
> fail because the device was !forbidden.

Thanks for your information.  For this specific situation, is it
possible to call pm_runtime_resume() or pm_request_resume() for the
device?

> > 	enabled + forbidden	-> ACTIVE
> > 	enabled + !forbidden	-> auto
> > 
> > Why we can not do that?
> 
> See above.  What we can do instead is:
> 
> 	disabled + forbidden	-> ACTIVE
> 	disabled + !forbidden	-> anything
> 
> which is basically what I proposed.
>
> > > This means:
> > > 
> > > 	pm_runtime_set_suspended should fail if dev->power.runtime_auto
> > > 	is clear.
> > 
> > I think we can WARN_ON() here.  Because the caller should responsible
> > for state consistence if they decide to manage runtime power state
> > manually.
> 
> No.  Drivers should not have to worry about whether runtime PM is 
> forbidden.  Worrying about that is the PM core's job.

En...  It appears that what caller can do is just do not call
pm_runtime_set_suspended() if forbidden.  So your method should be
better.

> > > 	pm_runtime_forbid should call pm_runtime_set_active if
> > > 	dev->power.disable_depth > 0.  (This would run into a problem
> > > 	if the parent is suspended and disabled.  Maybe 
> > > 	pm_runtime_forbid should fail when this happens.)
> > 
> > pm_runtime_forbid() may be called via echo "on" > .../power/control.  I
> > think it is hard to refuse the request from user space to forbid runtime
> > PM.  Device can always work with full power.
> 
> It can't if the parent is in SUSPEND.  If necessary, the user can write 
> "on" to the parent's power/control attribute first.

Is it possible to call pm_runtime_set_active() for the parent if the
parent is disabled and SUSPENDED.

> > > Finally, we probably should make a third change even though it isn't
> > > strictly necessary:
> > > 
> > > 	pm_runtime_allow should call pm_runtime_set_suspended if
> > > 	dev->power.disable_depth > 0.
> > 
> > I think this is something similar to manage device power state
> > automatically if disabled.
> 
> Yes, it is similar but not exactly the same as your proposal.

It appears that there is race condition between this and the
pm_runtime_disable, pm_runtime_set_active, pm_runtime_enable sequence
you mentioned ealier.

thread 1			thread 2
pm_runtime_disable
pm_runtime_set_active
				pm_runtime_allow
				  pm_runtime_set_suspended
pm_runtime_enable

Best Regards,
Huang Ying


