Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab2KLFzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 00:55:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:48164 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2KLFzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 00:55:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,759,1344236400"; 
   d="scan'208";a="245441955"
Message-ID: <1352699744.7176.169.camel@yhuang-dev>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and
 forbidden
From: Huang Ying <ying.huang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Mon, 12 Nov 2012 13:55:44 +0800
In-Reply-To: <Pine.LNX.4.44L0.1211112131500.16611-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1211112131500.16611-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-11 at 21:36 -0500, Alan Stern wrote:
> On Mon, 12 Nov 2012, Huang Ying wrote:
> 
> > > The first question: How should the PCI subsystem prevent the parents of 
> > > driverless VGA devices from being runtime suspended while userspace is 
> > > accessing them?
> > 
> > I think Rafael's patch is good for that.
> 
> But his patch isn't needed if we make these other changes.

Yes.

> > > The second question: Should the PM core allow devices that are disabled
> > > for runtime PM to be in the SUSPENDED state when
> > > dev->power.runtime_auto is clear?
> > 
> > I think that should not be allowed.
> 
> Disallowing it is okay with me too.  But it will require several 
> changes to the code, more than what your patch did.

Yes.  I think so too.

> > > Assuming we don't want to allow this, there's a third question: Should
> > > pm_runtime_allow call pm_runtime_set_suspended if the device is
> > > disabled?
> > 
> > Is it absolute necessary to call pm_runtime_set_suspended?  If the
> > device is disabled, the transition to SUSPENDED state will not be
> > triggered even if the device is ACTIVE.
> 
> It's not absolutely necessary to do this, but we ought to because it 
> will allow the device's parent to be suspended.  If we leave the device 
> in the ACTIVE state then the parent can't be suspended, even when the 
> device is disabled.

I think this is the hard part of the issue.  Now "disabled" and
SUSPENDED state is managed by hand.  IMHO, if we changed
pm_runtime_allow() as you said, we need to change the rule too.  Maybe
something as follow:

- remove pm_runtime_set_suspended/pm_runtime_set_active
- in pm_runtime_disable/pm_runtime_allow, put device into SUSPENDED
state if runtime PM is not forbidden.
- in pm_runtime_forbid/pm_runtime_enable, put device into ACTIVE state.

Best Regards,
Huang Ying


