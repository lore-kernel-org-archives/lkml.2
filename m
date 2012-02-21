Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2BUVkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:40:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab2BUVkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:40:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Tue, 21 Feb 2012 22:43:52 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org> <201202210013.02397.rjw@sisk.pl> <1329786806.1511.54.camel@rui.sh.intel.com>
In-Reply-To: <1329786806.1511.54.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202212243.52788.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 21, 2012, Zhang Rui wrote:
> On 二, 2012-02-21 at 00:13 +0100, Rafael J. Wysocki wrote:
> > > So how to handle this case, say, for a device in the generic PM domain
> > > that supports 2 different low power state, D1 and D2.
> > > D2 is deeper than D1, and it is kind of cold power off with remote
> > > wakeup disabled. If the driver needs to runtime suspend the device with
> > > remote wakeup enabled, it should set the device to D1, but it can not
> > > set the RPM_SUSPEND?
> > 
> > The device is regarded as "suspended" if its bus type's (or PM domain's)
> > .runtime_suspend() callback has been executed and has returned 0 (success).
> > What the callback has actually done is not of any interest to the core.
> > 
> right.
> 
> > Now, the D1 and D2 case has to be handled by the bus (PM domain) and
> > driver.  In both cases the device will be regarded as "suspended" and the
> > core doesn't track the actual device state.
> > 
> 
> 
> > I think the problem here is that the PCI bus type's runtime PM callbacks
> > aren't very sophisticated (they just choose the lowest possible low-power
> > state and attempt to put the device into it) and I can see two possible
> > ways to address that.
> > 
> > First, you can modify pci_pm_runtime_suspend/_resume() to handle multiple
> > states (for example, to choose the target low-power state more intelligently
> > than they do right now).  Second, you can add a PM domain that will do what
> > you want from pci_pm_runtime_suspend/_resume() for a specific set of devices.
> > 
> But RPM_SUSPENDED is set by PM core after .runtime_suspend() being
> invoked, even if device is in D1 instead of D2, right?
> 
> So the problem is that, if a device in a generic power domain supports
> two low power state, one is compatible with generic power domain power
> off and another is not, how can the device driver pass this information
> to the generic power domain, i.e. how to runtime suspend a device while
> keep the generic power domain always on?

There are two "low-power" levels in the generic PM domains framework.  The
first one is the per-device low-power in which devices are put into their
individual (programmable) low-power states by the domain .dev_ops->stop()
callback.  The second one is when .stop() has been called for all devices,
so presumably all of them are in programmable low-power states and it's
possible to switch the entire domain off.  This is done by the domain
.power_off() callback.

It seems that the trick might be to make .dev_ops->stop() avoid turning off
power resources for the last suspending device in the domain and leave that
to domain .power_off().

Thanks,
Rafael
