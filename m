Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2BNGRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 01:17:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:16166 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2BNGRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 01:17:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="66322357"
Message-ID: <1329200243.19384.16.camel@rui.sh.intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Tue, 14 Feb 2012 14:17:23 +0800
In-Reply-To: <201202132038.12927.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
	 <201202132038.12927.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 一, 2012-02-13 at 20:38 +0100, Rafael J. Wysocki wrote:
> On Monday, February 13, 2012, Alan Stern wrote:
> > On Mon, 13 Feb 2012, Lin Ming wrote:
> > 
> > > From: Zhang Rui <rui.zhang@intel.com>
> > > 
> > > Introduce flag can_power_off in device structure to support runtime
> > > power off/on.
> > > 
> > > Note that, for a specific device driver,
> > > "support runtime power off/on" means that the driver .runtime_suspend
> > > callback needs to
> > > 1) save all the context so that it can restore the device back to the previous
> > >    working state after powered on.
> > > 2) set can_power_off flag to tell the driver model that it's ready for power off.
> > > 
> > > The following example shows how this works.
> > > 
> > > device A
> > >  |---------|
> > >  v         v
> > > device B  device C
> > > 
> > > A is the parent of device B and device C, and device A/B/C shares the
> > > same power logic
> > > (Only device A knows how to turn on/off the power).
> > > 
> > > In order to power off A, B, C at runtime,
> > > 1) device B and device C should support runtime power off
> > >    (runtime suspended with can_power_off flag set)
> > > 2) pm idle request for device A is fired by runtime PM core.
> > > 3) in device A .runtime_suspend callback, it tries to set can_power_off flag.
> > > 4) if succeed, it means all its children have been ready for power off
> > >    and it can turn off the power at any time.
> > > 5) if failed, it means at least one of its children does not support runtime
> > >    power off, thus the power can not be turned off.
> > 
> > I'm not sure if this is really the right approach.  What you're trying 
> > to do is implement two different low-power states, basically D3hot and 
> > D3cold.  Currently the runtime PM core doesn't support such things; all 
> > it knows about is low power and full power.
> 
> I'd rather say all it knows about is "suspended" and "active", which mean
> "the device is not processing I/O" and "the device may be processing I/O",
> respectively.  A "suspended" device may or may not be in a low-power state,
> but the runtime PM core doesn't care about that.
> 
yes, I know that.

> > Before doing an ad-hoc implementation, it would be best to step back
> > and think about other subsystems.  Other sorts of devices may well have
> > multiple low-power states.  What's the best way for this to be
> > supported by the PM core?
> 
> Well, I honestly don't think there's any way they all can be covered at the
> same time and that's why we chose to support only "suspended" and "active"
> as defined above.

> The handling of multiple low-power states must be
> implemented outside of the runtime PM core (like in the PCI core, for example).

Surely I'd prefer to implement it in the bus code, :), but the problem
is that several buses maybe involved at the same time.
Let's take ZPODD for example,
ZPODD is attached to a SATA port. Only SATA port knows that it can be
runtime powered off, because its ACPI node has _PR3._OFF.
But when ATA layer code tries to put SATA port to D3_COLD at runtime,it
must make sure all the devices/drivers in the same power domain are
ready for power off, and in this case, we need to get this info from
SCSI layer.

thanks,
rui

