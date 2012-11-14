Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab2KNBIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:08:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:63665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab2KNBIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:08:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="168057990"
Message-ID: <1352855308.7176.232.camel@yhuang-dev>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and
 forbidden
From: Huang Ying <ying.huang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 14 Nov 2012 09:08:28 +0800
In-Reply-To: <Pine.LNX.4.44L0.1211131102330.1292-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1211131102330.1292-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-13 at 11:10 -0500, Alan Stern wrote:
> On Tue, 13 Nov 2012, Huang Ying wrote:
> 
> > > This is not quite right.  Consider a device that is in runtime suspend 
> > > when a system sleep starts.  When the system sleep ends, the device 
> > > will be resumed but the PM core will still think its state is 
> > > SUSPENDED.  The subsystem has to tell the PM core that the device is 
> > > now ACTIVE.  Currently, subsystems do this by calling 
> > > pm_runtime_disable, pm_runtime_set_active, pm_runtime_enable.  Under 
> > > your scheme this wouldn't work; the pm_runtime_set_active call would 
> > > fail because the device was !forbidden.
> > 
> > Thanks for your information.  For this specific situation, is it
> > possible to call pm_runtime_resume() or pm_request_resume() for the
> > device?
> 
> No, because the device already is at full power.  The subsystem just
> needs to tell the PM core that it is.
> 
> > > > PM.  Device can always work with full power.
> > > 
> > > It can't if the parent is in SUSPEND.  If necessary, the user can write 
> > > "on" to the parent's power/control attribute first.
> > 
> > Is it possible to call pm_runtime_set_active() for the parent if the
> > parent is disabled and SUSPENDED.
> 
> Doing that is possible, but it might not work.  The parent might
> actually be at low power; calling pm_runtime_set_active wouldn't change
> the physical power level.  Basically, it's not safe to assume anything
> about devices that are disabled for runtime PM.
> 
> > It appears that there is race condition between this and the
> > pm_runtime_disable, pm_runtime_set_active, pm_runtime_enable sequence
> > you mentioned ealier.
> > 
> > thread 1			thread 2
> > pm_runtime_disable
> > pm_runtime_set_active
> > 				pm_runtime_allow
> > 				  pm_runtime_set_suspended
> > pm_runtime_enable
> 
> This can't happen in the situation I described earlier because during
> system sleep transitions, no other user threads are allowed to run.  
> All of them except the one actually carrying out the transition are
> frozen.

Thanks for your kind explanation.

After talking with you, my feeling is that the disabled state is obscure
and error-prone.  So I suggest not to use it if possible.  Maybe we can

 - make changes suggested by Alan to make disabled state better.
 - use Rafael's solution to solve this specific issue, and avoid the
usage of disabled state here.

Best Regards,
Huang Ying


