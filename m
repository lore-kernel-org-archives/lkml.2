Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2BNGHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 01:07:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:7395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2BNGHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 01:07:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125132830"
Message-ID: <1329199627.19384.6.camel@rui.sh.intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
From: Zhang Rui <rui.zhang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Tue, 14 Feb 2012 14:07:07 +0800
In-Reply-To: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 一, 2012-02-13 at 10:01 -0500, Alan Stern wrote:
> On Mon, 13 Feb 2012, Lin Ming wrote:
> 
> > From: Zhang Rui <rui.zhang@intel.com>
> > 
> > Introduce flag can_power_off in device structure to support runtime
> > power off/on.
> > 
> > Note that, for a specific device driver,
> > "support runtime power off/on" means that the driver .runtime_suspend
> > callback needs to
> > 1) save all the context so that it can restore the device back to the previous
> >    working state after powered on.
> > 2) set can_power_off flag to tell the driver model that it's ready for power off.
> > 
> > The following example shows how this works.
> > 
> > device A
> >  |---------|
> >  v         v
> > device B  device C
> > 
> > A is the parent of device B and device C, and device A/B/C shares the
> > same power logic
> > (Only device A knows how to turn on/off the power).
> > 
> > In order to power off A, B, C at runtime,
> > 1) device B and device C should support runtime power off
> >    (runtime suspended with can_power_off flag set)
> > 2) pm idle request for device A is fired by runtime PM core.
> > 3) in device A .runtime_suspend callback, it tries to set can_power_off flag.
> > 4) if succeed, it means all its children have been ready for power off
> >    and it can turn off the power at any time.
> > 5) if failed, it means at least one of its children does not support runtime
> >    power off, thus the power can not be turned off.
> 
> I'm not sure if this is really the right approach.  What you're trying 
> to do is implement two different low-power states, basically D3hot and 
> D3cold.  Currently the runtime PM core doesn't support such things; all 
> it knows about is low power and full power.
> 
Exactly.
what I'm trying to fix here is to add a "special" runtime low power
state, aka, power off.

> Before doing an ad-hoc implementation, it would be best to step back
> and think about other subsystems.  Other sorts of devices may well have
> multiple low-power states.  What's the best way for this to be
> supported by the PM core?
> 
I thought about this before, e.g. introduce support for multiple runtime
low power states in runtime PM core, like suspend/hibernate for system
low power states. But I'm not sure if this is workable because the low
power states varies between devices/buses/platforms.

So I decided to introduce a special low power state, aka, runtime power
off, first, which means the same thing to different
devices/buses/platforms.

thanks,
rui


