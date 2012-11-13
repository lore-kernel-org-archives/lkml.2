Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2KMBUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:20:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:32871 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab2KMBT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:19:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="241058220"
Message-ID: <1352769596.7176.194.camel@yhuang-dev>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and
 forbidden
From: Huang Ying <ying.huang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Tue, 13 Nov 2012 09:19:56 +0800
In-Reply-To: <Pine.LNX.4.44L0.1211121110520.26926-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1211121110520.26926-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 11:32 -0500, Alan Stern wrote:
> On Mon, 12 Nov 2012, Huang Ying wrote:
> 
> > > > Is it absolute necessary to call pm_runtime_set_suspended?  If the
> > > > device is disabled, the transition to SUSPENDED state will not be
> > > > triggered even if the device is ACTIVE.
> > > 
> > > It's not absolutely necessary to do this, but we ought to because it 
> > > will allow the device's parent to be suspended.  If we leave the device 
> > > in the ACTIVE state then the parent can't be suspended, even when the 
> > > device is disabled.
> > 
> > I think this is the hard part of the issue.  Now "disabled" and
> > SUSPENDED state is managed by hand.  IMHO, if we changed
> > pm_runtime_allow() as you said, we need to change the rule too.  Maybe
> > something as follow:
> > 
> > - remove pm_runtime_set_suspended/pm_runtime_set_active
> 
> We can't remove them entirely.  They are needed for situations where 
> the device's physical state is different from what the PM core thinks; 
> they tell the PM core what the actual state is.
> 
> > - in pm_runtime_disable/pm_runtime_allow, put device into SUSPENDED
> > state if runtime PM is not forbidden.
> 
> That doesn't make sense.  Runtime PM is never forbidden after 
> pm_runtime_allow is called; that's its purpose.

Sorry, my original idea is:

	pm_runtime_disable will put device into SUSPENDED state if
	dev->power.runtime_auto is clear.  pm_runtime_allow will put
	device into SUSPENDED state if dev->power.disable_depth > 0.

So in general, my original idea is to manage device runtime power state
automatically instead of manually, especially when device is in disabled
state.

	disabled + forbidden	-> ACTIVE
	disabled + !forbidden	-> SUSPENDED
	enabled + forbidden	-> ACTIVE
	enabled + !forbidden	-> auto

Why we can not do that?

> > - in pm_runtime_forbid/pm_runtime_enable, put device into ACTIVE state.
> 
> Why should pm_runtime_enable put the device into the ACTIVE state?
> 
> No, I think a better approach is simply to say that the device will
> never be allowed to be in the SUSPENDED state if runtime PM is
> forbidden.  We already enforce this when the device is enabled for 
> runtime PM, so we would have to start enforcing it when the device is 
> disabled.
> 
> This means:
> 
> 	pm_runtime_set_suspended should fail if dev->power.runtime_auto
> 	is clear.

I think we can WARN_ON() here.  Because the caller should responsible
for state consistence if they decide to manage runtime power state
manually.

> 	pm_runtime_forbid should call pm_runtime_set_active if
> 	dev->power.disable_depth > 0.  (This would run into a problem
> 	if the parent is suspended and disabled.  Maybe 
> 	pm_runtime_forbid should fail when this happens.)

pm_runtime_forbid() may be called via echo "on" > .../power/control.  I
think it is hard to refuse the request from user space to forbid runtime
PM.  Device can always work with full power.

> Finally, we probably should make a third change even though it isn't
> strictly necessary:
> 
> 	pm_runtime_allow should call pm_runtime_set_suspended if
> 	dev->power.disable_depth > 0.

I think this is something similar to manage device power state
automatically if disabled.

Best Regards,
Huang Ying

> Rafael, what do you think?
> 
> Alan Stern
> 


