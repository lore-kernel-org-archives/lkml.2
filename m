Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2D0WHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:07:46 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:3085 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2D0WHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:07:44 -0400
Message-ID: <1335564323.16730.41.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/4] ACPI: Set hotplug _OST support bit to _OSC
From: Toshi Kani <toshi.kani@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 27 Apr 2012 16:05:23 -0600
In-Reply-To: <1335460230.17002.62.camel@misato.fc.hp.com>
References: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
	 <1334096510-17319-2-git-send-email-toshi.kani@hp.com>
	 <CAErSpo6Ofm8qHUophN+oXrsKKfnJXvaEJUfFkEFwbXLfb4xZ=g@mail.gmail.com>
	 <1335460230.17002.62.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 11:10 -0600, Toshi Kani wrote:
> On Thu, 2012-04-26 at 09:16 -0600, Bjorn Helgaas wrote:
> > On Tue, Apr 10, 2012 at 4:21 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > > Added macro definitions of _OST source event and status codes.
> > > Also renamed OSC_SB_CPUHP_OST_SUPPORT to OSC_SB_HOTPLUG_OST_SUPPORT
> > > since this _OSC bit is not specific to CPU hotplug.  This bit is
> > > defined in table 6-147 of ACPI 5.0 as follows.
> > >
> > >  Bits:       3
> > >  Field Name: Insertion / Ejection _OST Processing Support
> > >  Definition: This bit is set if OSPM will evaluate the _OST
> > >              object defined under a device when processing
> > >              insertion and ejection source event codes.
> > >
> > > This patch sets OSC_SB_HOTPLUG_OST_SUPPORT to the platform-wide
> > > OSPM capabilities when CONFIG option of ACPI CPU hotplug or memory
> > > hotplug is enabled.
> > >
> > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > > ---
> > >  drivers/acpi/bus.c   |    5 +++++
> > >  include/linux/acpi.h |   26 +++++++++++++++++++++++++-
> > >  2 files changed, 30 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > > index 3263b68..a492d64 100644
> > > --- a/drivers/acpi/bus.c
> > > +++ b/drivers/acpi/bus.c
> > > @@ -544,6 +544,11 @@ static void acpi_bus_osc_support(void)
> > >        capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PPC_OST_SUPPORT;
> > >  #endif
> > >
> > > +#if defined(CONFIG_ACPI_HOTPLUG_CPU) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||\
> > > +                defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
> > > +       capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_HOTPLUG_OST_SUPPORT;
> > > +#endif
> > 
> > This seems a bit strange to me.  For one thing, the _OSC discussion
> > doesn't seem to indicate that _OST support is specific to CPU or
> > memory hotplug.  If we tell the platform that we support _OST, the
> > platform can assume that we'll evaluate _OST for *any* device, which
> > is not the case.  I guess this is just another reason why we need
> > hotplug support in the ACPI core, not in the individual drivers.  Then
> > we wouldn't have the ifdefs at all.
> 
> I agree, and it should be called for any device.  As you know, the issue
> is that the global system notify handler acpi_bus_notify() and driver's
> notify handler work independently, and their functionality conflicts
> each other.  I have not thought out yet, but my current thinking is that
> we may be able to integrate them into acpi_bus_notify() in the following
> way.  This model allows a choice -- use the default handler or driver's
> handler.  We can then call _OST for any device.  It can also eliminate
> redundant ACPI namespace walks performed by drivers when registering
> their notify handlers.  What do you think?
> 
> struct acpi_device_ops {
> 		:
>    acpi_op_sys_notify sys_notify;  // driver's system notify (new entry)
> }
> 
> acpi_bus_notify()
> {
> 	driver = lookup-driver-with-HID();
> 
> 	if ((driver) && (driver->ops->sys_notify)
> 		driver->ops.sys_notify();
> 	else
> 		Call the system default notify handler;
> 
> 	Call _OST if present;
> }

I looked at the this model more carefully.  While the basic idea of
integration seems doable, I realized that calling _OST as described in
the above pseudo code has some issue.  For instance,
container_notify_cb() only generates a KOBJ_OFFLINE event for
ACPI_NOTIFY_EJECT_REQUEST.  Since an eject operation may or may not
happen asynchronously via udev, the notify handler may not call _OST
(other than in-progress update).  So for now, _OST support needs to be
made for each driver basis.  The above model allows drivers to choose
the default notify handler, so it would help to have more consistent
behavior over the time.  Without such changes, acpi_bus_notify() cannot
perform anything since it conflicts with driver's handler. 

-Toshi


