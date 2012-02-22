Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2BVA5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 19:57:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:29237 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab2BVA5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 19:57:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="110592968"
Message-ID: <1329872267.1511.76.camel@rui.sh.intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 22 Feb 2012 08:57:47 +0800
In-Reply-To: <201202212243.52788.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
	 <201202210013.02397.rjw@sisk.pl>
	 <1329786806.1511.54.camel@rui.sh.intel.com>
	 <201202212243.52788.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 二, 2012-02-21 at 22:43 +0100, Rafael J. Wysocki wrote:
> On Tuesday, February 21, 2012, Zhang Rui wrote:
> > On 二, 2012-02-21 at 00:13 +0100, Rafael J. Wysocki wrote:
> > > > So how to handle this case, say, for a device in the generic PM domain
> > > > that supports 2 different low power state, D1 and D2.
> > > > D2 is deeper than D1, and it is kind of cold power off with remote
> > > > wakeup disabled. If the driver needs to runtime suspend the device with
> > > > remote wakeup enabled, it should set the device to D1, but it can not
> > > > set the RPM_SUSPEND?
> > > 
> > > The device is regarded as "suspended" if its bus type's (or PM domain's)
> > > .runtime_suspend() callback has been executed and has returned 0 (success).
> > > What the callback has actually done is not of any interest to the core.
> > > 
> > right.
> > 
> > > Now, the D1 and D2 case has to be handled by the bus (PM domain) and
> > > driver.  In both cases the device will be regarded as "suspended" and the
> > > core doesn't track the actual device state.
> > > 
> > 
> > 
> > > I think the problem here is that the PCI bus type's runtime PM callbacks
> > > aren't very sophisticated (they just choose the lowest possible low-power
> > > state and attempt to put the device into it) and I can see two possible
> > > ways to address that.
> > > 
> > > First, you can modify pci_pm_runtime_suspend/_resume() to handle multiple
> > > states (for example, to choose the target low-power state more intelligently
> > > than they do right now).  Second, you can add a PM domain that will do what
> > > you want from pci_pm_runtime_suspend/_resume() for a specific set of devices.
> > > 
> > But RPM_SUSPENDED is set by PM core after .runtime_suspend() being
> > invoked, even if device is in D1 instead of D2, right?
> > 
> > So the problem is that, if a device in a generic power domain supports
> > two low power state, one is compatible with generic power domain power
> > off and another is not, how can the device driver pass this information
> > to the generic power domain, i.e. how to runtime suspend a device while
> > keep the generic power domain always on?
> 
> There are two "low-power" levels in the generic PM domains framework.  The
> first one is the per-device low-power in which devices are put into their
> individual (programmable) low-power states by the domain .dev_ops->stop()
> callback.  The second one is when .stop() has been called for all devices,
> so presumably all of them are in programmable low-power states and it's
> possible to switch the entire domain off.  This is done by the domain
> .power_off() callback.
> 
> It seems that the trick might be to make .dev_ops->stop() avoid turning off
> power resources for the last suspending device in the domain and leave that
> to domain .power_off().
> 
Yeah, that's a good idea.
so how about this proposal for ZPODD.
1. create an ACPI generic power domain for every device that has an _PR3
   method, the SATA port in this case.
2. add sr device to the generic power domain via genpd APIs.
   this can be done either in ATA port driver or in sr driver.
3. the .power_off callback of the generic power domain
   a) checks if all the devices allows power off (for the trick above)
   b) turns off the power resources in _PR3.

thanks,
rui

