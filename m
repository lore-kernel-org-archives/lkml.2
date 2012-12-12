Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab2LLW3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:29:48 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59064 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641Ab2LLW3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:29:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 1/6] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Wed, 12 Dec 2012 23:34:51 +0100
Message-ID: <10126255.CrXWio0rAn@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50C8A7AE.3030500@gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <4002729.BbipMAJtM0@vostro.rjw.lan> <50C8A7AE.3030500@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 12, 2012 11:50:06 PM Jiang Liu wrote:
> On 12/10/2012 07:00 AM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Currently, as soon as an ACPI device node object (struct acpi_device)
> > is created, the driver core attempts to probe ACPI drivers against
> > it.  That leads to some unpleasant side effects, like the fact that
> > the boot code path for ACPI namespace scanning is different from the
> > analogous hot-plug code path (during boot ACPI drivers are not
> > present when ACPI device node objects are registered, so they are
> > guaranteed not to be probed, which is not the case during hot-plug).
> > That, in turn, leads to unnecessary complications in the PCI
> > enumeration algorithm.
> > 
> > Reduce the differences between the boot and hot-plug cases by
> > splitting the ACPI namespace scanning for devices into two passes,
> > such that struct acpi_device objects are registerd in the first
> > patch without probing ACPI drivers and the drivers are probed
> > against them directly in the second pass.  This way ACPI drivers
> > can assume that all of the ACPI device node objects in the given
> > scope will be registered when their .add() routines run and the
> > hot-plug case becomes the same as the boot case from their
> > perspective.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/scan.c     |   96 +++++++++++++++++++++++++++++++++---------------
> >  include/acpi/acpi_bus.h |    1 
> >  2 files changed, 68 insertions(+), 29 deletions(-)
> > 
> > Index: linux/include/acpi/acpi_bus.h
> > ===================================================================
> > --- linux.orig/include/acpi/acpi_bus.h
> > +++ linux/include/acpi/acpi_bus.h
> > @@ -98,6 +98,7 @@ typedef void (*acpi_op_notify) (struct a
> >  struct acpi_bus_ops {
> >  	u32 acpi_op_add:1;
> >  	u32 acpi_op_start:1;
> > +	u32 acpi_op_match:1;
> >  };
> >  
> >  struct acpi_device_ops {
> > Index: linux/drivers/acpi/scan.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/scan.c
> > +++ linux/drivers/acpi/scan.c
> > @@ -494,7 +494,8 @@ static int acpi_bus_match(struct device
> >  	struct acpi_device *acpi_dev = to_acpi_device(dev);
> >  	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
> >  
> > -	return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
> > +	return acpi_dev->bus_ops.acpi_op_match
> > +		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
> >  }
> Hi Rafael,
> 	PCI host bridge hotplug has the same requirement to separate device
> enumeration from device driver binding. And VFIO has a similar requirement too.
> Yinghai and I have implemented two different solutions for PCI host bridge
> hotplug but all rejected by Greg. So it would be great if we could promote
> a common mechanism to the device core to temporarily disable binding drivers
> to devices, which could used to support ACPI hotplug, PCI hotplug and VFIO.

OK, but let's first have a good common use case, I think.  I mean, let's
implement it in each of these subsystems separately and then show that it
leads to simpler code if we move it up to the driver core.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
