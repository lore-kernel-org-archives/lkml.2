Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab2KAXNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:13:37 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab2KAXNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:13:32 -0400
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
Date: Fri, 02 Nov 2012 00:17:37 +0100
Message-ID: <2690277.s5TEOPtmaZ@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQWiRcaC3dKQFUHoC0qe0TneW2T+CYNZPEic5At_QcP0rw@mail.gmail.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan> <9809109.C0U00708CM@vostro.rjw.lan> <CAE9FiQWiRcaC3dKQFUHoC0qe0TneW2T+CYNZPEic5At_QcP0rw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 01, 2012 03:38:19 PM Yinghai Lu wrote:
> On Thu, Nov 1, 2012 at 2:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> So you are going to replace acpi_device/acpi_driver with
> >> platform_device/platform_driver ?
> >
> > Not exactly.  Let me start from the big picture, though. :-)
> >
> > First off, we need to unify the handling of devices by the ACPI subsystem
> > regardless of whether they are on a specific bus, like PCI, or they are
> > busless "platform" devices.
> >
> > Currently, if a device is on a specific bus *and* there is a device node in the
> > ACPI namespace corresponding to it, there will be two objects based on
> > struct device for it eventually, the "physical node", like struct pci_dev, and
> > the "ACPI node" represented by struct acpi_device.  They are associated with
> > each other through the code in drivers/acpi/glue.c.  In turn, if the device is
> > busless and not discoverable natively, we only create the "ACPI node" struct
> > acpi_device thing for it.  Those ACPI nodes are then *sometimes* bind to
> > drivers (represented by struct acpi_driver).
> >
> > The fact that the busless devices are *sometimes* handled by binding drivers
> > directly to struct acpi_device while the other devices are handled through
> > glue.c confuses things substantially and causes problems to happen right now
> > (for example, acpi_driver drivers sometimes attempt to bind to things that have
> > other native drivers and should really be handled by them).
> > Furthermore, the situation will only get worse over time if we don't do
> > anything about that, because we're going to see more and more devices that
> > won't be discoverable natively and will have corresponding nodes in the ACPI
> > namespace and we're going to see more buses whose devices will have such
> > nodes.
> >
> > Moreover, for many of those devices there are native drivers present in
> > the kernel tree already, because they will be based on IP blocks used in
> > the current hardware (for example, we may see ARM-based systems based on
> > exactly the same hardware with ACPI BIOSes and without them).  That applies
> > to busless devices as well as to devices on specific buses.
> >
> > Now, the problem is how the unification is going to be done and I honestly
> > don't think we have much *choice* here.  Namely, for PCI (and other devices
> > discoverable natively) we pretty much have to do the glue.c thing (or something
> > equivalent), because we need to match what we've discovered natively against
> > the information from the ACPI tables in the BIOS.  This means that for busless
> > devices we need to create "physical" nodes as well, so that all of them are
> > handled by drivers binding to the "physical" node rather than to struct
> > acpi_device.  This also will allow us to reuse the existing drivers with
> > minimum modifications (well, hopefully).
> 
> ok, acpi_driver will be killed at first.
> 
> acpi_pci_root_driver will be converted to platform driver or
> add acpi_pci_host_bridge to work with pci_host_bridge.

Yup.

> BTW,  the problem for hotadd pci root bus,
> the acpi_driver ops.add can pci root bus and create pci dev before all
> acpi device get
> created still there.
>     https://lkml.org/lkml/2012/10/5/569

Yes, I'm aware of that, it's on my todo list FWIW. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
