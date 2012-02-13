Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2BMTeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:34:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50276 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab2BMTeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:34:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Mon, 13 Feb 2012 20:38:12 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202132038.12927.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 13, 2012, Alan Stern wrote:
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

I'd rather say all it knows about is "suspended" and "active", which mean
"the device is not processing I/O" and "the device may be processing I/O",
respectively.  A "suspended" device may or may not be in a low-power state,
but the runtime PM core doesn't care about that.

> Before doing an ad-hoc implementation, it would be best to step back
> and think about other subsystems.  Other sorts of devices may well have
> multiple low-power states.  What's the best way for this to be
> supported by the PM core?

Well, I honestly don't think there's any way they all can be covered at the
same time and that's why we chose to support only "suspended" and "active"
as defined above.  The handling of multiple low-power states must be
implemented outside of the runtime PM core (like in the PCI core, for example).

Thanks,
Rafael
