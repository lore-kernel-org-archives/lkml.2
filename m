Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2BTXJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:09:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33907 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab2BTXJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:09:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Tue, 21 Feb 2012 00:13:02 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org> <201202180054.49284.rjw@sisk.pl> <1329708181.1511.18.camel@rui.sh.intel.com>
In-Reply-To: <1329708181.1511.18.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202210013.02397.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 20, 2012, Zhang Rui wrote:
> On 六, 2012-02-18 at 00:54 +0100, Rafael J. Wysocki wrote:
> > 
> > > > have been working on a similar one for several months now. :-)
> > > 
> > > That's why generic power domain is introduced?
> > > Can you tell me what's your idea please?
> > > It would be GREAT if you can share your experience on this.
> > 
> > Well, a power domain (which seems to be what you have in the ZPODD case)
> > is analogous to a package with multiple CPU cores.  In that case you
> > can put individual cores into per-core low-power ("idle") states (that
> > roughly corresponds to the D1-D3hot device states) or you can put the
> > whole package into a low-power state ("package idle") resulting in the
> > removal of power from all the cores (more-or-less).  Now, it has to be
> > decided which approach to use and if the "package idle" is used, it may
> > be necessary to restore the cores' "state" when they are "resumed".
> > 
> > Analogously, for devices in a power domain you usually can use some
> > programmable mechanism to put each of them into some sort of a low-power
> > state (e.g. D3hot or "stop clock" etc.) such that the device may be programmed
> > to go out of it.  Alternatively, you can use a different mechanism to
> > remove power from the entire domain, in which case devices, when power is
> > restored, may need to be re-initialized.  Of course, you need to know when
> > this happens, so that you know when to carry out the re-initialization.
> > 
> > Our approach in the generic PM domains framework is, essentially, to provide
> > a special set of PM callbacks ("domain callbacks") that are run (by the PM
> > core) instead of bus-type PM callbacks.  Those domain callbacks are added to
> > every device in the domain through its pm_domain pointer.  Of course, this
> > means that devices have to be added to the domains explicitly and we have some
> > helpers for that.  We also use some additional data structures allowing the
> > domain callbacks to track devices in the domain.
> > 
> > Now, when a device in a domain is "suspended" (meaning its runtime PM status
> > changes from "active" to "suspended"), the domain callbacks check if this is
> > the last device in the domain whose status is "active" at that point.  If
> > that is not the case, they simply call a special .stop() callback to put the
> > device into a "normal" per-device low-power state (the .stop() callback may be
> > defined per device and in principle it may be designed to call the bus-type
> > or driver .runtime_suspend() callback for the device).  Otherwise (i.e. if
> > this is the last device in the domain whose status was "active" before) and if
> > the PM QoS constraints allow that to happen, power is removed from the domain
> > as a whole.  Then, all devices in the domain are marked as "need re-init upon
> > resume" and the resume domain callbacks take care of re-initializing them as
> > appropriate when their status changes from "suspended" back to "active".  [The
> > domain callbacks use the subsys_data pointer in dev_pm_info to attach their own
> > data to device objects.]
> > 
> > The actual code is more complicated than that, but that's the idea.
> > 
> Yeah, I have read the generic PM domain code before. and I have a
> question about the generic PM domain code.
> 
> genpd->pow_off is invoked if all devices in a generic PM domain are
> pm_runtime_suspended(). This suggests that the device driver can set
> RPM_SUSPENDED flag only if it is able to bring the device from a cold
> power off, right?

A device driver can _never_ set the RPM_SUSPENDED, the core does that.

> So how to handle this case, say, for a device in the generic PM domain
> that supports 2 different low power state, D1 and D2.
> D2 is deeper than D1, and it is kind of cold power off with remote
> wakeup disabled. If the driver needs to runtime suspend the device with
> remote wakeup enabled, it should set the device to D1, but it can not
> set the RPM_SUSPEND?

The device is regarded as "suspended" if its bus type's (or PM domain's)
.runtime_suspend() callback has been executed and has returned 0 (success).
What the callback has actually done is not of any interest to the core.

Now, the D1 and D2 case has to be handled by the bus (PM domain) and
driver.  In both cases the device will be regarded as "suspended" and the
core doesn't track the actual device state.

I think the problem here is that the PCI bus type's runtime PM callbacks
aren't very sophisticated (they just choose the lowest possible low-power
state and attempt to put the device into it) and I can see two possible
ways to address that.

First, you can modify pci_pm_runtime_suspend/_resume() to handle multiple
states (for example, to choose the target low-power state more intelligently
than they do right now).  Second, you can add a PM domain that will do what
you want from pci_pm_runtime_suspend/_resume() for a specific set of devices.

Thanks,
Rafael
