Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2DHXhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:37:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59158 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2DHXhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:37:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Date: Mon, 9 Apr 2012 01:41:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andiry Xu <andiry.xu@amd.com>,
        Alex He <alex.he@amd.com>, Huang Ying <ying.huang@intel.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com> <201204011049.08609.rjw@sisk.pl> <CAC=cRTOA2YGvBUxNrx0aDAT0ivUaRKFjL0RLrRr8+Kz18CfTmA@mail.gmail.com>
In-Reply-To: <CAC=cRTOA2YGvBUxNrx0aDAT0ivUaRKFjL0RLrRr8+Kz18CfTmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204090141.36766.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 05, 2012, huang ying wrote:
> Hi, Rafael,

Hi,

> On Sun, Apr 1, 2012 at 4:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, April 01, 2012, Zhang Rui wrote:
> >> On 日, 2012-04-01 at 09:23 +0200, Rafael J. Wysocki wrote:
> >> > Hi,
> >> >
> >> > Sorry for the delayed response, I've been travelling recently.
> >> >
> >> > On Sunday, April 01, 2012, Lin Ming wrote:
> >> > > On Sun, 2012-04-01 at 13:56 +0800, Aaron Lu wrote:
> >> > > > Hi,
> >> > > >
> >> > > > On Sun, Apr 01, 2012 at 01:27:33PM +0800, Lin Ming wrote:
> >> > > > > > -           if (device->power.states[state].flags.explicit_set) {
> >> > > > > > +           /* If state is D3 Cold, try to evaluate _PS3 first */
> >> > > > > > +           if (state == ACPI_STATE_D3_COLD) {
> >> > > > > > +                   explicit_set = (ps - 1)->flags.explicit_set;
> >> > > > > > +                   object_name[3] -= 1;
> >> > > > > > +           }
> >> > > > >
> >> > > > > I'm not sure whether this works or not.
> >> > > > >
> >> > > > > From ACPI spec,
> >> > > > >
> >> > > > > _PS3 "is used to put the specific device into its D3hot or D3 state"
> >> > > > >
> >> > > > > D3 neither means D3hot nor D3cold. It's an old term before D3hot and
> >> > > > > D3cold were introduced.
> >> > > > I guess D3 has to mean something, right? :-)
> >> >
> >> > Well, not necessarily.
> >> >
> >> > The problem is what state the _PS3 method puts the device into: D3_hot or
> >> > D3_cold.
> >> >
> >> > Unfortunately, as far as I can say, ACPI 4.0 didn't specify any "official"
> >> > mapping between the "old" D3 and the "new" D3_{hod|cold} states, so we need to
> >> > figure out something.  In my opinion, the only reasonable approach is to
> >> > assume that the state _PS3 puts the device into is always D3_cold, becuase
> >> > _PS3 may remove power completely from the device.  It may not do that, but
> >> > we _must_ assume it does that in general.
> >> >
> >> There is a problem that I can think of.
> >> Say currently, ACPI always returns D3 when _PS3 exists.
> >
> > I'm not sure what you mean exactly, but please see below.
> >
> >> And this "ACPI_STATE_D3" is translated to PCI_D3hot.
> >> But with this approach, we're going to put these devices to PCI_D3cold
> >> instead, right?
> >> I'm not against this approach, but this may affect a lot of PCI devices,
> >> which we need to take care of, no?
> >
> > Do you mean acpi_pm_device_sleep_state() should be modified?  It doesn't
> > refer to whether or not _PS3 exists, as far as I can say.
> >
> > In the acpi_pci_set_power_state() code path, on the other hand, there are
> > two potentially problematic situations when PCI wants to put the device into
> > PCI_D3hot (which need not map 1:1 onto ACPI D3_hot), one of which is when _PS3
> > is present, and the other is when neither _PS3, nor _PR3 is present.
> >
> > If _PS3 is present, then _PR3 may or may not be present.  In the latter case
> > we can only execute _PS3 in the hope it does the right thing, but as long
> > as we restore the device's configuration registers while resuming it (which is
> > done by all of our PCI device resume callback routines as far as I can say),
> > the only possible difference is the resume latency (which may be greater if
> > power is removed from the device entirely).
> 
> Another difference between D3Hot and D3Cold for PCI devices is config
> space availability.  That is, in D3Hot, you can access D3Hot, while in
> D3Cold you can not do that.  For example, PME poll logic need to be
> disabled if we put device into D3Cold.

We're not talking about PCI here.  PCI D3hot/D3cold is actually well defined,
while the ACPI "couterparts" aren't.  And BTW I know the properties of the PCI
power management states. :-)

> > However, in that case we shouldn't
> > turn off the device's power resources after _PS3 has been executed (if we
> > turned them off, power would be removed from the device, which wouldn't be
> > what PCI wanted).  So, to handle this particular case we need to pass
> > ACPI_STATE_D3_HOT to acpi_bus_set_power(), meaning "avoid going into D3_cold,
> > if possible".
> >
> > In both _PS3 and _PR3 are present, we should evaluate _PS3 and then turn off
> > the power resources listed as "off" by _PR3 (and turn on the power resoruces
> > listed by it as "on"), but we need to restore the configuration registers of
> > the device while resuming it.  I think this is handled correctly without
> > modifications.
> >
> > If neither _PS3 nor _PR3 is present, we shouldn't turn off the device's
> > power resources, because PCI doesn't want power to be removed from the device.
> 
> For PCI device plugged into system via slot (not integrated into PCH
> or motherboard), there is no ACPI handle associate with it, so that
> there are neither _PS3 nor _PR3 presented.  But it is still possible
> to turn off the device power via the associated PCIe port, which has
> _PS3 and/or _PR3 presented.  I think that situation is reasonable too.

Again, this hasn't anything to do with ACPI.

We're discussing standard interfaces exposed by ACPI.  That is, if I say
"to turn of the device's power resources" I mean to call _OFF for all of the
power resources listed by _PR0 for that device.  Nothing more or less than
that.

> > In summary, if PCI wants the device to be put into PCI_D3hot and _PS3 is
> > present, we should evaluate _PS3.  However, we shouldn't turn the device's
> > power resources off unless _PR3 is present, in which case we can turn off
> > the power resources listed by it as "off".
> 
> How to turn the device's power resources off without _PR3?  It may be
> possible via PCIe port as I said above.  Do you mean that?  Or
> something else?

If _PR0 is present, it returns the list of power resources needed by the
device.  If you turn them all off, the assumption is that power has been
removed from the device, so it is in D3(cold).

PCI hotplug (and other standards) provide alternative means for removing
power from devices, but that's beyond the scope of what is being discussed
in this thread.

Thanks,
Rafael
