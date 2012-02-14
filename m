Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab2BNWcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:32:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52470 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab2BNWch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:32:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Tue, 14 Feb 2012 23:36:28 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com> <201202132148.04961.rjw@sisk.pl> <1329206396.19384.58.camel@rui.sh.intel.com>
In-Reply-To: <1329206396.19384.58.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202142336.28706.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 14, 2012, Zhang Rui wrote:
> On 一, 2012-02-13 at 21:48 +0100, Rafael J. Wysocki wrote:
> > On Monday, February 13, 2012, Lin Ming wrote:
> > > From: Zhang Rui <rui.zhang@intel.com>
> > > 
> > > ACPI Power Resource can power on/off a couple of devices.
> > > Introduce interfaces to register/unregister a device to/from
> > > an ACPI Power Resource.
> > > 
> > > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > > ---
> > >  drivers/acpi/power.c    |  128 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  include/acpi/acpi_bus.h |    2 +
> > >  2 files changed, 130 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > > index 0d681fb..a7e2305 100644
> > > --- a/drivers/acpi/power.c
> > > +++ b/drivers/acpi/power.c
> > > @@ -84,10 +84,25 @@ struct acpi_power_resource {
> > >  	u32 order;
> > >  	unsigned int ref_count;
> > >  	struct mutex resource_lock;
> > > +	struct list_head devices; /* list for devices powered by this PR */
> > >  };
> > >  
> > >  static struct list_head acpi_power_resource_list;
> > >  
> > > +/*
> > > + * When a power resource is turned on, all the devices are put to an uninitialized
> > > + * state although their ACPI states are still D0.
> > > + * To handle this, we need to keep a list of all devices powered by the power resource,
> > > + * and resume all of them.
> > > + * Currently, we only support this case:
> > > + * 1) multiple devices share the same power resoruce,
> > > + * 2) One device uses One Power Resource ONLY.
> > 
> > This is incorrect.  We actually support all combinations.
> 
> Agreed.
> 
> >   However, we don't
> > generally support checking what devices depend on the given power resource.
> > 
> Yes.
> But all the code in this patch is for runtime D3_COLD support only.
> At least for the BIOS code on hand, a device that support runtime
> D3_COLD uses one ACPI Power Resource only.
> We can add the support for all combinations if there are such kind of
> BIOS in the market, which I do not think there would be.
> 
> Besides, as a RFC version, I do not want to make a over designed
> proposal at the beginning.
> 
> > > + */
> > > +struct acpi_powered_device {
> > > +	struct list_head node;
> > > +	struct device *dev;
> > > +};
> > > +
> > >  /* --------------------------------------------------------------------------
> > >                               Power Resource Management
> > >     -------------------------------------------------------------------------- */
> > > @@ -455,6 +470,118 @@ int acpi_disable_wakeup_device_power(struct acpi_device *dev)
> > >                               Device Power Management
> > >     -------------------------------------------------------------------------- */
> > >  
> > > +int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
> > > +{
> > > +	struct acpi_power_resource *resource;
> > > +	struct acpi_device *acpi_dev, *res_dev;
> > > +	acpi_handle res_handle = NULL;
> > > +	struct acpi_powered_device *apd;
> > > +	int i;
> > > +	int ret;
> > > +
> > > +	if (!handle || !dev)
> > > +		return -EINVAL;
> > > +
> > > +	ret = acpi_bus_get_device(handle, &acpi_dev);
> > > +	if (ret)
> > > +		goto no_power_resource;
> > > +
> > > +	if (!acpi_dev->power.flags.power_resources)
> > > +		goto no_power_resource;
> > > +
> > > +	for (i = 0; i <= ACPI_STATE_D3; i++) {
> > > +		struct acpi_device_power_state *ps = &acpi_dev->power.states[i];
> > > +
> > > +		if (!ps->flags.valid)
> > > +			continue;
> > > +
> > > +		if (ps->resources.count > 1)
> > > +			return 0;
> > > +
> > > +		if (!res_handle)
> > > +			res_handle = ps->resources.handles[0];
> > > +		else if (res_handle != ps->resources.handles[0])
> > > +			return 0;
> > > +	}
> > 
> > I'm not sure what the above checks are needed for.  It seems that this function
> > will only be called from acpi_bus_add_power_resource() (which needs to be
> > modified for this purpose, BTW), so it doesn't need to check all those things
> > (those checks have been made already).
> > 
> No. These two APIs are introduced to support the runtime D3_COLD remote
> wakeup. And they should be invoked by drivers, either in driver code or
> via bus layer code.
> 
> Say, ATA port, who has _PR3 in its ACPI node, knows that it can enter
> D3_COLD at run time, and it supports remote wakeup in D3_COLD because it
> has _S0W (return value 4).
> When remote wakeup event is triggered, there is an ACPI event sent to
> the ATA controller/port, which sets the ATA controller/port back to D0
> state.
> At this time, what we actually need is to resume the ZPODD, rather than
> the ATA controller/port. To follow the runtime PM model (runtime resume
> starts from leaf devices),

Well, this isn't the case.  Parents are always resumed first.

> ATA code can use these two APIs to tell ACPI
> to runtime resume ZPODD device directly, because ZPODD is powered by
> this Power Resource as well.

I'm not exactly sure what you're trying to achieve and what you mean by
"resume a device directly"?  Do you want to run the device's resume
callback at the time when another device is being resumed?

Rafael
