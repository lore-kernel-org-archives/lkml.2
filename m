Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab2DVLtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 07:49:35 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab2DVLtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 07:49:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v2] ACPI: D3 states cleanup
Date: Sun, 22 Apr 2012 13:54:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Aaron Lu <aaron.lu@amd.com>, Len Brown <lenb@kernel.org>,
        "linux-acpi" <linux-acpi@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
References: <1334884749.4927.6.camel@minggr> <201204201312.54949.rjw@sisk.pl> <CAF1ivSYxoN3dbrNztY4BGLFYg6wGvCyypLgwXuOFam7uKtBB1w@mail.gmail.com>
In-Reply-To: <CAF1ivSYxoN3dbrNztY4BGLFYg6wGvCyypLgwXuOFam7uKtBB1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204221354.11975.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 20, 2012, Lin Ming wrote:
> On Fri, Apr 20, 2012 at 7:12 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, April 20, 2012, Aaron Lu wrote:
> >> Hi,
> >>
> >> On Fri, Apr 20, 2012 at 01:37:35PM +0800, Lin Ming wrote:
> >> > > > > > There are two ACPI D3 states defined now:
> >> > > > > > ACPI_STATE_D3 and ACPI_STATE_D3_COLD.
> >> > > > > >
> >> > > > > > But the uses of these states are not clear/correct in some code.
> >> > > > > > For example, some code refer ACPI_STATE_D3 as D3hot and others refer
> >> > > > > > it as D3cold.
> >> > > > > >
> >> > > > > > This patch introduces ACPI_STATE_D3_HOT to refer to ACPI D3hot state.
> >> > > > > > And changes ACPI_STATE_D3 to refer to ACPI D3cold state only.
> >> > > > > > Also redefines ACPI_STATE_D3_COLD the same as ACPI_STATE_D3.
> >> > > > > >
> >> > > > >
> >> > > > > With this patch now, if a device has _PS3, then we will set its D3hot
> >> > > > > flag valid. This doesn't feel right to me, since per our discussion the
> >> > > > > other day, we should assume _PS3 will put the device into D3cold.
> >> > > > >
> >> > > > > Or do you mean: if _PS3 is available, then both D3hot and D3cold is
> >> > > > > valid from the perspective of acpi, it is the individual driver's
> >> > > > > responsibility to decide which state is actually valid and will be used.
> >> > > >
> >> > > > Right.
> >> > > >
> >> > > > ACPI_STATE_D3(same as ACPI_STATE_D3_COLD now) is always valid.
> >> > > >
> >> > >
> >> > > I mean, if _PS3 is available, can we say D3hot is valid?
> >> >
> >> > Yes.
> >> >
> >>
> >> OK, now I'm confused...
> >>
> >> First, let me try to clarify the meaning of acpi power state's valid
> >> flag.
> >>
> >> By valid, I suppose it means the device can be in that state, instead of
> >> we have a way to program this device to go into that state.
> >>
> >> e.g. D0 is valid means the device can be in D0 state, and D3_cold is
> >> valid means the device can be in D3_cold state. We unconditionally set
> >> these two states as valid, because we know every device supports these
> >> two states. But we might not be able to put the device into that state
> >> in software, since we might not have _PS0 or _PS3 control methods for it.
> >>
> >> And if we do have the _PSx or _PRx control methods, we knows we have a
> >> way to put the device into that state, and hence the device should be
> >> able to support that power state, so we will set that state as valid too.
> >>
> >> Is this correct?
> >>
> >> For D3hot, obviously not all device supports this state, so we will need
> >> to figure it out through the acpi table.
> >> I remembered Rafael said the following words the other day in a reply to
> >> my evaluate_ps3_when_entering_d3_cold_patch:
> >>
> >> -----------------------------------------------------------------------
> >> I'd rather say that with _PR3 we have the opportunity to avoid removing
> >> power completely from the device.  In other words, D3_hot is supported (and
> >> it is supported _only_ in that case).
> >> -----------------------------------------------------------------------
> >>
> >> So I think here is a problem, that if a device has only _PS3, why should
> >> we say D3hot is supported? Is there a reason for this that I missed?
> >
> > OK, I agree.  We need to special case the situation in which _PR3 is not
> > present, but _PS3 is.  IOW, we should do something like this in the loop in
> > acpi_bus_get_power_flags():
> >
> >
> >                /* State is valid if we have some power control */
> >                if (ps->resources.count
> >                    || (ps->flags.explicit_set && i < ACPI_STATE_D3))
> >                        ps->flags.valid = 1;
> 
> Will add below change.
>
> -               /* State is valid if we have some power control */
> -               if (ps->resources.count || ps->flags.explicit_set)
> +               /*
> +                * State is valid if we have some power control
> +                * D3hot state is only valid if _PR3 present
> +                */

Well, I'd say:

 +               /*
 +                * State is valid there are means to put the device into it.
 +                * D3hot is only valid if _PR3 present.
 +                */

> +               if (ps->resources.count ||
> +                   (ps->flags.explicit_set && i < ACPI_STATE_D3_HOT))
>                         ps->flags.valid = 1;
> 
> Rafael,
> 
> can I still add your ACK when send updated patch?

Sure.

Thanks,
Rafael
