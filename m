Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2KMXjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:39:17 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:42075 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab2KMXjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:39:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
Date: Wed, 14 Nov 2012 00:43:32 +0100
Message-ID: <2088233.vqA5Fcid1o@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1211121110520.26926-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1211121110520.26926-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 12, 2012 11:32:26 AM Alan Stern wrote:
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
> 
> > - in pm_runtime_forbid/pm_runtime_enable, put device into ACTIVE state.
> 
> Why should pm_runtime_enable put the device into the ACTIVE state?
> 
> No, I think a better approach is simply to say that the device will
> never be allowed to be in the SUSPENDED state if runtime PM is
> forbidden.  We already enforce this when the device is enabled for 
> runtime PM, so we would have to start enforcing it when the device is 
> disabled.

Sorry for the delay, I needed to take care of some ACPI changes urgently.

(Without reading the rest of the thread yet) I think that would be
a reasonable approach.

> This means:
> 
> 	pm_runtime_set_suspended should fail if dev->power.runtime_auto
> 	is clear.
> 
> 	pm_runtime_forbid should call pm_runtime_set_active if
> 	dev->power.disable_depth > 0.  (This would run into a problem
> 	if the parent is suspended and disabled.  Maybe 
> 	pm_runtime_forbid should fail when this happens.)
> 
> Finally, we probably should make a third change even though it isn't
> strictly necessary:
> 
> 	pm_runtime_allow should call pm_runtime_set_suspended if
> 	dev->power.disable_depth > 0.
> 
> Rafael, what do you think?

As I said, sounds reasonable.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
