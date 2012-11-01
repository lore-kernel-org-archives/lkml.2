Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275Ab2KAVRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:17:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51211 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2KAVRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:17:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 list <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 5/5] ACPI: Add support for platform bus type
Date: Thu, 01 Nov 2012 22:21:46 +0100
Message-ID: <9809109.C0U00708CM@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQUXk9AcR87B8PyLoW3JJveZMd7SqB9pDmfA8F320SCLng@mail.gmail.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan> <14394066.j8A8VXQzU7@vostro.rjw.lan> <CAE9FiQUXk9AcR87B8PyLoW3JJveZMd7SqB9pDmfA8F320SCLng@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 01, 2012 09:19:59 AM Yinghai Lu wrote:
> On Thu, Nov 1, 2012 at 7:35 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > @@ -1544,8 +1553,13 @@ static acpi_status acpi_bus_check_add(ac
> >> >          */
> >> >         device = NULL;
> >> >         acpi_bus_get_device(handle, &device);
> >> > -       if (ops->acpi_op_add && !device)
> >> > +       if (ops->acpi_op_add && !device) {
> >> >                 acpi_add_single_object(&device, handle, type, sta, ops);
> >> > +               /* Is the device a known good platform device? */
> >> > +               if (device
> >> > +                   && !acpi_match_device_ids(device, acpi_platform_device_ids))
> >> > +                       acpi_create_platform_device(device);
> >> > +       }
> >>
> >> That is ugly! any reason for not using acpi_driver for them.
> >
> > Yes, a couple of reasons.  First off, there are existing platform drivers for
> > these things already and there's no reason for creating a "glue" layer between
> > those drivers and struct acpi_device objects.  Second, we're going to get rid
> > of acpi_driver things entirely going forward (the existing ones will be replaced
> > by platform drivers or included into the ACPI core).
> 
> that should be glue between acpi_device and platform_device.
> 
> how are you going to handle removing path ? aka when acpi_device get
> trimed, how those platform get deleted?

This is a valid point.

Roughly, the idea is to walk the dev's list of physical nodes and call
.remove() for each of them in acpi_bus_remove().  Or to do something
equivalent to that.

However, we're not going to add any IDs of removable devices to
acpi_platform_device_ids[] for now, so we simply don't need to modify that
code path just yet (we'll modify it when we're about to add such devices to
that table).

> >> there is not reason to treat those platform_device different from pci
> >> root device and other pnp device.
> >
> > Well, I agree. :-)
> >
> > So those things you're talking about we'll be platform devices too in the
> > future.
> >
> >> something like attached patch. .add of acpi_driver ops could call
> >> acpi_create_platform_device.
> >
> > Been there, decided to do it differently this time.
> >
> 
> So you are going to replace acpi_device/acpi_driver with
> platform_device/platform_driver ?

Not exactly.  Let me start from the big picture, though. :-)

First off, we need to unify the handling of devices by the ACPI subsystem
regardless of whether they are on a specific bus, like PCI, or they are
busless "platform" devices.

Currently, if a device is on a specific bus *and* there is a device node in the
ACPI namespace corresponding to it, there will be two objects based on
struct device for it eventually, the "physical node", like struct pci_dev, and
the "ACPI node" represented by struct acpi_device.  They are associated with
each other through the code in drivers/acpi/glue.c.  In turn, if the device is
busless and not discoverable natively, we only create the "ACPI node" struct
acpi_device thing for it.  Those ACPI nodes are then *sometimes* bind to
drivers (represented by struct acpi_driver).

The fact that the busless devices are *sometimes* handled by binding drivers
directly to struct acpi_device while the other devices are handled through
glue.c confuses things substantially and causes problems to happen right now
(for example, acpi_driver drivers sometimes attempt to bind to things that have
other native drivers and should really be handled by them).
Furthermore, the situation will only get worse over time if we don't do
anything about that, because we're going to see more and more devices that
won't be discoverable natively and will have corresponding nodes in the ACPI
namespace and we're going to see more buses whose devices will have such
nodes.

Moreover, for many of those devices there are native drivers present in
the kernel tree already, because they will be based on IP blocks used in
the current hardware (for example, we may see ARM-based systems based on
exactly the same hardware with ACPI BIOSes and without them).  That applies
to busless devices as well as to devices on specific buses.

Now, the problem is how the unification is going to be done and I honestly
don't think we have much *choice* here.  Namely, for PCI (and other devices
discoverable natively) we pretty much have to do the glue.c thing (or something
equivalent), because we need to match what we've discovered natively against
the information from the ACPI tables in the BIOS.  This means that for busless
devices we need to create "physical" nodes as well, so that all of them are
handled by drivers binding to the "physical" node rather than to struct
acpi_device.  This also will allow us to reuse the existing drivers with
minimum modifications (well, hopefully).

Pretty much every ACPI developer I have discussed that with so far, including
people like Matthew Garrett and Zhang Rui who have been working on ACPI for
years, seems to agree that this is the way to go.

Thus, in the long run, acpi_driver drivers will be replaced by something else
(platform drivers seem to be a natural choice in many cases), but struct
acpi_device objects won't go away, at least not entirely.  My long haul plan
is to drop the "dev" component of struct acpi_device and rename it to something
like struct acpi_dev_node, to clarify its meaning.

I'm quite confident that this is doable.  The part I'm most concerned about is
the interactions with user space, because we need to pay attention not to break
the existing user space interfaces (that are actually used).  That said, I'm
not expecting this to be a one-shot transition.  Rather, this is going to take
time, like several kernel releases, and I'm sure there are details we need to
be very careful about.

That's one of the reasons why acpi_platform_device_ids[] is there: so that we
can carefully carry out the unification step by step.

> Did you ever try to start to the work to see if it is doable? aka do
> you have draft version to do that?

Unfortunately, I don't have anything I could share with you at the moment.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
