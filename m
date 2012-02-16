Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab2BPHJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 02:09:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:21054 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab2BPHI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 02:08:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="108491798"
Message-ID: <1329376106.28581.5.camel@rui.sh.intel.com>
Subject: Re: [RFC PATCH 1/6] ACPI: Introduce ACPI D3_COLD state support
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Date: Thu, 16 Feb 2012 15:08:26 +0800
In-Reply-To: <201202142329.16516.rjw@sisk.pl>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	 <201202132125.15537.rjw@sisk.pl>
	 <1329203228.19384.35.camel@rui.sh.intel.com>
	 <201202142329.16516.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 二, 2012-02-14 at 23:29 +0100, Rafael J. Wysocki wrote:
> On Tuesday, February 14, 2012, Zhang Rui wrote:
> > Hi, Rafael,
> > 
> > On 一, 2012-02-13 at 21:25 +0100, Rafael J. Wysocki wrote:
> > > On Monday, February 13, 2012, Lin Ming wrote:
> > > > From: Zhang Rui <rui.zhang@intel.com>
> > > > 
> > > > If a device has _PR3._ON, it means the device supports D3_HOT.
> > > > If a device has _PR3._OFF, it means the device supports D3_COLD.
> > > > Add the ability to validate and enter D3_COLD state in ACPI.
> > > > 
> > > > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > > 
> > > This is supposed to be ACPI 5.0 support, right?
> > > 
> > No, D3_HOT is introduced in ACPI spec 4.0.
> > According to the spec, _PR3 is used for devices that support both
> > D3(D3_COLD) and D3HOT.
> 
> Yes, it does.
> 
> > The confusion here is that Linux D3 equals ACPICA D3HOT and Linux
> > D3_COLD equals ACPICA D3.
> > For example, when enter Linux ACPI D3, the reference count of ACPI Power
> > Resources in _PR3 is increased by one.
> 
> That's correct.
> 
> > > So can anyone please tell me what part of the ACPI 5.0 spec is the
> > > basis of this patch, because I can't see that immediately?
> > > 
> > > The only places where D3Cold is _mentioned_ are Section 7.2.12 (_PRE, which
> > > appears to be new in 5.0), Section 7.2.20 (_S0W), Section 7.2.21 (_S1W),
> > > Section 7.2.22 (_S2W), Section 7.2.23 (_S3W) and Section 7.2.24 (_S4W).
> > > None of them mentions those _PR3._ON and _PR3._OFF things above.
> > > 
> > > Moreover, my understanding of the spec is that D3Cold means all of the
> > > power resources returned by _PR3 are "off" (whereas some of them will be
> > > "on" in D3hot).
> > > 
> > Agreed.
> > 
> > > > ---
> > > >  drivers/acpi/power.c |    4 ++--
> > > >  drivers/acpi/scan.c  |   10 +++++++++-
> > > >  2 files changed, 11 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > > > index 9ac2a9f..0d681fb 100644
> > > > --- a/drivers/acpi/power.c
> > > > +++ b/drivers/acpi/power.c
> > > > @@ -500,14 +500,14 @@ int acpi_power_transition(struct acpi_device *device, int state)
> > > >  {
> > > >  	int result;
> > > >  
> > > > -	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3))
> > > > +	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
> > > >  		return -EINVAL;
> > > >  
> > > >  	if (device->power.state == state)
> > > >  		return 0;
> > > >  
> > > >  	if ((device->power.state < ACPI_STATE_D0)
> > > > -	    || (device->power.state > ACPI_STATE_D3))
> > > > +	    || (device->power.state > ACPI_STATE_D3_COLD))
> > > >  		return -ENODEV;
> > > >  
> > > >  	/* TBD: Resources must be ordered. */
> > > > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > > > index 8ab80ba..a9d4391 100644
> > > > --- a/drivers/acpi/scan.c
> > > > +++ b/drivers/acpi/scan.c
> > > > @@ -881,8 +881,16 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
> > > >  
> > > >  			device->power.flags.power_resources = 1;
> > > >  			ps->flags.valid = 1;
> > > > -			for (j = 0; j < ps->resources.count; j++)
> > > > +			for (j = 0; j < ps->resources.count; j++) {
> > > >  				acpi_bus_add_power_resource(ps->resources.handles[j]);
> > > > +				/* Check for D3_COLD support. _PR3._OFF equals D3_COLD ? */
> > > > +				if (i == ACPI_STATE_D3) {
> > > > +					if (j == 0)
> > > > +						device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> > > > +					status = acpi_get_handle(ps->resources.handles[j], "_OFF",  &handle);
> > > > +					device->power.states[ACPI_STATE_D3_COLD].flags.valid &= ACPI_SUCCESS(status);
> > > > +				}
> > > > +			}
> > > 
> > > Sorry, but this doesn't make sense to me.  Power resources always have
> > > the _OFF method, right?
> > > 
> > I'm not sure.
> 
> That would be explicitly against the spec that says that power resources
> are *required* to have _ON, _OFF and _STA.
> 
> > I thought I had seen ACPI Power Resources without _OFF
> > control method somewhere in bugzilla, but I can not find it out now.
> 
> That, clearly, is a firmware bug.
> 
Okay, agreed.
so how about this? _PR3 equals D3_HOT support.

> > Hmm, how about set D3_COLD support if _PR3 exists, but leave a warning
> > message if _OFF doesn't exist, for now?
> 
> I don't think we need to set D3_COLD support at all.  In fact, it is always
> supported (as I said, if all power resources used by a device are off, the
> device is in D3_COLD pretty much by definition).
> 
Yeah, but it seems that Linux uses ACPI_D3 for both ACPICA D3_HOT and D3
(off). I'm generating a patch to remove ACPI_D3_COLD and introduce
D3_HOT support in Linux kernel.

thanks,
rui

