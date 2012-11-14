Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422911Ab2KNNh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:37:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:16674 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422805Ab2KNNhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:37:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,250,1352102400"; 
   d="scan'208";a="219493495"
Message-ID: <1352900114.5254.3.camel@yhuang-mobile.sh.intel.com>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and
 forbidden
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 14 Nov 2012 21:35:14 +0800
In-Reply-To: <2028148.7b9pFIymgn@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1211131102330.1292-100000@iolanthe.rowland.org>
	 <1352855308.7176.232.camel@yhuang-dev> <2028148.7b9pFIymgn@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 10:52 +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 14, 2012 09:08:28 AM Huang Ying wrote:
> > On Tue, 2012-11-13 at 11:10 -0500, Alan Stern wrote:
> > > On Tue, 13 Nov 2012, Huang Ying wrote:
> > > 
> > > > > This is not quite right.  Consider a device that is in runtime suspend 
> > > > > when a system sleep starts.  When the system sleep ends, the device 
> > > > > will be resumed but the PM core will still think its state is 
> > > > > SUSPENDED.  The subsystem has to tell the PM core that the device is 
> > > > > now ACTIVE.  Currently, subsystems do this by calling 
> > > > > pm_runtime_disable, pm_runtime_set_active, pm_runtime_enable.  Under 
> > > > > your scheme this wouldn't work; the pm_runtime_set_active call would 
> > > > > fail because the device was !forbidden.
> > > > 
> > > > Thanks for your information.  For this specific situation, is it
> > > > possible to call pm_runtime_resume() or pm_request_resume() for the
> > > > device?
> > > 
> > > No, because the device already is at full power.  The subsystem just
> > > needs to tell the PM core that it is.
> > > 
> > > > > > PM.  Device can always work with full power.
> > > > > 
> > > > > It can't if the parent is in SUSPEND.  If necessary, the user can write 
> > > > > "on" to the parent's power/control attribute first.
> > > > 
> > > > Is it possible to call pm_runtime_set_active() for the parent if the
> > > > parent is disabled and SUSPENDED.
> > > 
> > > Doing that is possible, but it might not work.  The parent might
> > > actually be at low power; calling pm_runtime_set_active wouldn't change
> > > the physical power level.  Basically, it's not safe to assume anything
> > > about devices that are disabled for runtime PM.
> > > 
> > > > It appears that there is race condition between this and the
> > > > pm_runtime_disable, pm_runtime_set_active, pm_runtime_enable sequence
> > > > you mentioned ealier.
> > > > 
> > > > thread 1			thread 2
> > > > pm_runtime_disable
> > > > pm_runtime_set_active
> > > > 				pm_runtime_allow
> > > > 				  pm_runtime_set_suspended
> > > > pm_runtime_enable
> > > 
> > > This can't happen in the situation I described earlier because during
> > > system sleep transitions, no other user threads are allowed to run.  
> > > All of them except the one actually carrying out the transition are
> > > frozen.
> > 
> > Thanks for your kind explanation.
> > 
> > After talking with you, my feeling is that the disabled state is obscure
> > and error-prone.  So I suggest not to use it if possible.  Maybe we can
> > 
> >  - make changes suggested by Alan to make disabled state better.
> 
> What changes specifically do you mean to be precise?

I mean the following changes from Alan's email.

        pm_runtime_set_suspended should fail if dev->power.runtime_auto
        is clear.

        pm_runtime_forbid should call pm_runtime_set_active if
        dev->power.disable_depth > 0.  (This would run into a problem
        if the parent is suspended and disabled.  Maybe 
        pm_runtime_forbid should fail when this happens.)

For the second one, is it possible that the device is really in low
power state when pm_runtime_forbid is called?  That situation is hard to
deal with too.

> >  - use Rafael's solution to solve this specific issue, and avoid the
> > usage of disabled state here.
> 
> Well, I think that the PCI subsystem should just enable runtime PM for
> all devices upfront and keep it enabled going forward.
> 
> My patch is incomplete, however, because it doesn't deal with probe/remove
> correctly at this point (which Alan pointed out earlier in the thread).

Yes.

Best Regards,
Huang Ying


