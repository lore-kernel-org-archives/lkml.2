Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2LMMPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 07:15:39 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60270 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab2LMMPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 07:15:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 6/6] ACPI: Change the ordering of acpi_bus_check_add()
Date: Thu, 13 Dec 2012 13:20:42 +0100
Message-ID: <7342480.cnAd5Im6q1@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAErSpo6jnjfJUadZKutpn4CXz0YMKccwSuG7idionFPjF-5VCw@mail.gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <2268672.Pe9OEEVsRc@vostro.rjw.lan> <CAErSpo6jnjfJUadZKutpn4CXz0YMKccwSuG7idionFPjF-5VCw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 12, 2012 06:00:28 PM Bjorn Helgaas wrote:
> On Sun, Dec 9, 2012 at 4:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > If acpi_bus_check_add() is called for a handle already having an
> > existing struct acpi_device object attached, it is not necessary to
> > check the type and status of the device correspondig to it, so
> > change the ordering of acpi_bus_check_add() to avoid that.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/scan.c |   18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> >
> > Index: linux/drivers/acpi/scan.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/scan.c
> > +++ linux/drivers/acpi/scan.c
> > @@ -1582,6 +1582,10 @@ static acpi_status acpi_bus_check_add(ac
> >         acpi_status status;
> >         int result;
> >
> > +       acpi_bus_get_device(handle, &device);
> > +       if (device)
> > +               goto out;
> > +
> >         result = acpi_bus_type_and_status(handle, &type, &sta);
> >         if (result)
> >                 return AE_OK;
> > @@ -1602,17 +1606,13 @@ static acpi_status acpi_bus_check_add(ac
> >          * We may already have an acpi_device from a previous enumeration.  If
> >          * so, we needn't add it again, but we may still have to start it.
> 
> It looks like this comment might need updating, since we no longer
> even get here if we already have an acpi_device.  Presumably you take
> care of the "start" it mentions elsewhere now.

I think you're right, will update.

Thanks,
Rafael


> >          */
> > -       acpi_bus_get_device(handle, &device);
> > -       if (!device) {
> > -               acpi_add_single_object(&device, handle, type, sta,
> > -                                      ACPI_BUS_ADD_BASIC);
> > -               if (!device)
> > -                       return AE_CTRL_DEPTH;
> > +       acpi_add_single_object(&device, handle, type, sta, ACPI_BUS_ADD_BASIC);
> > +       if (!device)
> > +               return AE_CTRL_DEPTH;
> >
> > -               device->add_type = context ?
> > -                                       ACPI_BUS_ADD_START : ACPI_BUS_ADD_MATCH;
> > -       }
> > +       device->add_type = context ? ACPI_BUS_ADD_START : ACPI_BUS_ADD_MATCH;
> >
> > + out:
> >         if (!*return_value)
> >                 *return_value = device;
> 
> I think all (both) callers of acpi_bus_check_add() supply a
> return_value pointer, so you could just remove the test.
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
