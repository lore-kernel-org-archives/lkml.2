Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab2KLQc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:32:29 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41800 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751625Ab2KLQc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:32:27 -0500
Date: Mon, 12 Nov 2012 11:32:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Huang Ying <ying.huang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <1352699744.7176.169.camel@yhuang-dev>
Message-ID: <Pine.LNX.4.44L0.1211121110520.26926-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Huang Ying wrote:

> > > Is it absolute necessary to call pm_runtime_set_suspended?  If the
> > > device is disabled, the transition to SUSPENDED state will not be
> > > triggered even if the device is ACTIVE.
> > 
> > It's not absolutely necessary to do this, but we ought to because it 
> > will allow the device's parent to be suspended.  If we leave the device 
> > in the ACTIVE state then the parent can't be suspended, even when the 
> > device is disabled.
> 
> I think this is the hard part of the issue.  Now "disabled" and
> SUSPENDED state is managed by hand.  IMHO, if we changed
> pm_runtime_allow() as you said, we need to change the rule too.  Maybe
> something as follow:
> 
> - remove pm_runtime_set_suspended/pm_runtime_set_active

We can't remove them entirely.  They are needed for situations where 
the device's physical state is different from what the PM core thinks; 
they tell the PM core what the actual state is.

> - in pm_runtime_disable/pm_runtime_allow, put device into SUSPENDED
> state if runtime PM is not forbidden.

That doesn't make sense.  Runtime PM is never forbidden after 
pm_runtime_allow is called; that's its purpose.

> - in pm_runtime_forbid/pm_runtime_enable, put device into ACTIVE state.

Why should pm_runtime_enable put the device into the ACTIVE state?

No, I think a better approach is simply to say that the device will
never be allowed to be in the SUSPENDED state if runtime PM is
forbidden.  We already enforce this when the device is enabled for 
runtime PM, so we would have to start enforcing it when the device is 
disabled.

This means:

	pm_runtime_set_suspended should fail if dev->power.runtime_auto
	is clear.

	pm_runtime_forbid should call pm_runtime_set_active if
	dev->power.disable_depth > 0.  (This would run into a problem
	if the parent is suspended and disabled.  Maybe 
	pm_runtime_forbid should fail when this happens.)

Finally, we probably should make a third change even though it isn't
strictly necessary:

	pm_runtime_allow should call pm_runtime_set_suspended if
	dev->power.disable_depth > 0.

Rafael, what do you think?

Alan Stern

