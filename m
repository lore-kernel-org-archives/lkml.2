Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab2DIVUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:20:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60912 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab2DIVUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:20:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Date: Mon, 9 Apr 2012 23:24:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: huang ying <huang.ying.caritas@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Aaron Lu <aaron.lu@amd.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>,
        Yan Zheng <zheng.z.yan@intel.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com> <201204090141.36766.rjw@sisk.pl> <1333938285.26747.8.camel@yhuang-dev>
In-Reply-To: <1333938285.26747.8.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204092324.31004.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 09, 2012, Huang Ying wrote:
> On Mon, 2012-04-09 at 01:41 +0200, Rafael J. Wysocki wrote:
> > > >
> > > > If _PS3 is present, then _PR3 may or may not be present.  In the latter case
> > > > we can only execute _PS3 in the hope it does the right thing, but as long
> > > > as we restore the device's configuration registers while resuming it (which is
> > > > done by all of our PCI device resume callback routines as far as I can say),
> > > > the only possible difference is the resume latency (which may be greater if
> > > > power is removed from the device entirely).
> > > 
> > > Another difference between D3Hot and D3Cold for PCI devices is config
> > > space availability.  That is, in D3Hot, you can access D3Hot, while in
> > > D3Cold you can not do that.  For example, PME poll logic need to be
> > > disabled if we put device into D3Cold.
> > 
> > We're not talking about PCI here.  PCI D3hot/D3cold is actually well defined,
> > while the ACPI "couterparts" aren't.  And BTW I know the properties of the PCI
> > power management states. :-)
> 
> I see.
> 
> > > > However, in that case we shouldn't
> > > > turn off the device's power resources after _PS3 has been executed (if we
> > > > turned them off, power would be removed from the device, which wouldn't be
> > > > what PCI wanted).  So, to handle this particular case we need to pass
> > > > ACPI_STATE_D3_HOT to acpi_bus_set_power(), meaning "avoid going into D3_cold,
> > > > if possible".
> > > >
> > > > In both _PS3 and _PR3 are present, we should evaluate _PS3 and then turn off
> > > > the power resources listed as "off" by _PR3 (and turn on the power resoruces
> > > > listed by it as "on"), but we need to restore the configuration registers of
> > > > the device while resuming it.  I think this is handled correctly without
> > > > modifications.
> > > >
> > > > If neither _PS3 nor _PR3 is present, we shouldn't turn off the device's
> > > > power resources, because PCI doesn't want power to be removed from the device.
> > > 
> > > For PCI device plugged into system via slot (not integrated into PCH
> > > or motherboard), there is no ACPI handle associate with it, so that
> > > there are neither _PS3 nor _PR3 presented.  But it is still possible
> > > to turn off the device power via the associated PCIe port, which has
> > > _PS3 and/or _PR3 presented.  I think that situation is reasonable too.
> > 
> > Again, this hasn't anything to do with ACPI.
> > 
> > We're discussing standard interfaces exposed by ACPI.  That is, if I say
> > "to turn of the device's power resources" I mean to call _OFF for all of the
> > power resources listed by _PR0 for that device.  Nothing more or less than
> > that.
> > 
> > > > In summary, if PCI wants the device to be put into PCI_D3hot and _PS3 is
> > > > present, we should evaluate _PS3.  However, we shouldn't turn the device's
> > > > power resources off unless _PR3 is present, in which case we can turn off
> > > > the power resources listed by it as "off".
> > > 
> > > How to turn the device's power resources off without _PR3?  It may be
> > > possible via PCIe port as I said above.  Do you mean that?  Or
> > > something else?
> > 
> > If _PR0 is present, it returns the list of power resources needed by the
> > device.  If you turn them all off, the assumption is that power has been
> > removed from the device, so it is in D3(cold).
> 
> So.  If PCI wants the device to be put into PCI_D3hot and _PS3 is
> present.  We should evaluate _PS3 AND set the pci_dev->current_state to
> PCI_D3cold?

No, I believe we should use the standard PCI PM interface to put the device
into PCI_D3hot and skip the execution of _PS3 (which is not what we do now,
but that's only because acpi_pci_set_power_state() doesn't distinguish
ACPI D3_hot from ACPI D3_cold).

If the standard PCI PM interface is not supported, the PCI_D3hot state is not
well defined for the device.

Thanks,
Rafael
