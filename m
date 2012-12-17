Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab2LQIJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 03:09:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45366 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2LQIJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 03:09:48 -0500
MIME-Version: 1.0
In-Reply-To: <6849411.jDP7VSUtXm@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
	<CAE9FiQWejZEj35okrHfuw6QQJNKNj2b+67yg+iGKEqYhgsaHCg@mail.gmail.com>
	<6849411.jDP7VSUtXm@vostro.rjw.lan>
Date: Mon, 17 Dec 2012 00:09:46 -0800
X-Google-Sender-Auth: VahRMpLTorHLsO-JuQnvSjbEdoM
Message-ID: <CAE9FiQWLU9GjHaTi8eyuRFTp=agADhROAzHJkDfOiWvUAE6U0A@mail.gmail.com>
Subject: Re: [PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, tony.luck@intel.com,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 11:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, December 16, 2012 09:27:49 PM Yinghai Lu wrote:
>> On Sun, Dec 16, 2012 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >
>> > The ACPI handles of PCI root bridges need to be known to
>> > acpi_bind_one(), so that it can create the appropriate
>> > "firmware_node" and "physical_node" files for them, but currently
>> > the way it gets to know those handles is not exactly straightforward
>> > (to put it lightly).
>> >
>> > This is how it works, roughly:
>> >
>> >   1. acpi_bus_scan() finds the handle of a PCI root bridge,
>> >      creates a struct acpi_device object for it and passes that
>> >      object to acpi_pci_root_add().
>> >
>> >   2. acpi_pci_root_add() creates a struct acpi_pci_root object,
>> >      populates its "device" field with its argument's address
>> >      (device->handle is the ACPI handle found in step 1).
>> >
>> >   3. The struct acpi_pci_root object created in step 2 is passed
>> >      to pci_acpi_scan_root() and used to get resources that are
>> >      passed to pci_create_root_bus().
>> >
>> >   4. pci_create_root_bus() creates a struct pci_host_bridge object
>> >      and passes its "dev" member to device_register().
>> >
>> >   5. platform_notify(), which for systems with ACPI is set to
>> >      acpi_platform_notify(), is called.
>> >
>> > So far, so good.  Now it starts to be "interesting".
>> >
>> >   6. acpi_find_bridge_device() is used to find the ACPI handle of
>> >      the given device (which is the PCI root bridge) and executes
>> >      acpi_pci_find_root_bridge(), among other things, for the
>> >      given device object.
>> >
>> >   7. acpi_pci_find_root_bridge() uses the name (sic!) of the given
>> >      device object to extract the segment and bus numbers of the PCI
>> >      root bridge and passes them to acpi_get_pci_rootbridge_handle().
>> >
>> >   8. acpi_get_pci_rootbridge_handle() browses the list of ACPI PCI
>> >      root bridges and finds the one that matches the given segment
>> >      and bus numbers.  Its handle is then used to initialize the
>> >      ACPI handle of the PCI root bridge's device object by
>> >      acpi_bind_one().  However, this is *exactly* the ACPI handle we
>> >      started with in step 1.
>> >
>> > Needless to say, this is quite embarassing, but it may be avoided
>> > thanks to commit f3fd0c8 (ACPI: Allow ACPI handles of devices to be
>> > initialized in advance), which makes it possible to initialize the
>> > ACPI handle of a device before passing it to device_register().
>> > Namely, if pci_acpi_scan_root() could easily pass the root bridge's
>> > ACPI handle to pci_create_root_bus(), the latter could set the ACPI
>> > handle in its struct pci_host_bridge object's "dev" member before
>> > passing it to device_register() and steps 6-8 above wouldn't be
>> > necessary any more.
>> >
>> > To make that happen I decided to repurpose the 4th argument of
>> > pci_create_root_bus(), because that allowed me to avoid defining
>> > additional callbacks or similar things and didn't seem to impact
>> > architectures without ACPI substantially.
>> >
>> > Only x86 and ia64 are affected directly, there should be no
>> > functional changes resulting from this on other architectures.
>>
>> that is good one to avoid that find_root_bridge...
>>
>> >
>> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> > ---
>> >
>> > Should apply to the current Linus' tree, boots correctly on x86(-64).
>
>> >
>> > ---
>> >  arch/ia64/pci/pci.c              |    5 ++++-
>> >  arch/powerpc/kernel/pci-common.c |    3 ++-
>> >  arch/sparc/kernel/pci.c          |    3 ++-
>> >  arch/x86/pci/acpi.c              |    5 ++++-
>> >  drivers/acpi/pci_root.c          |   18 ------------------
>> >  drivers/pci/pci-acpi.c           |   19 -------------------
>> >  drivers/pci/probe.c              |   16 +++++++++++-----
>> >  include/acpi/acpi_bus.h          |    1 -
>> >  include/linux/pci.h              |    9 ++++++++-
>> >  9 files changed, 31 insertions(+), 48 deletions(-)
>>
>> you need to update other arch for pci_create_root_bus
>>
>> arch/powerpc/kernel/pci-common.c:       bus =
>> pci_create_root_bus(hose->parent, hose->first_busno,
>
> I thought I addressed this one, didn't I?
>
>> arch/s390/pci/pci.c:    zdev->bus = pci_create_root_bus(NULL,
>> ZPCI_BUS_NR, &pci_root_ops,
>
> This one appears to have been removed.  There's no pci_create_root_bus()
> in all arch/s390, as far as I can say.

at least it is there on linus tree today.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=arch/s390/pci/pci.c;h=7ed38e5e3028689543c8c6356ef49b3a45546cd6;hb=HEAD

line 890

>
>> arch/sparc/kernel/pci.c:        bus = pci_create_root_bus(parent,
>> pbm->pci_first_busno, pbm->pci_ops,
>
> I modified this one too, is that not sufficient?
>
>> drivers/parisc/dino.c:  dino_dev->hba.hba_bus = bus =
>> pci_create_root_bus(&dev->dev,
>> drivers/parisc/lba_pci.c:               pci_create_root_bus(&dev->dev,
>> lba_dev->hba.bus_num.start,
>
> These two pass NULL as the 4th argument to pci_create_root_bus() and don't
> need to be updated, AFAICS.

then how could
-       b->sysdata = sysdata;
+       b->sysdata = sys_info->sysdata;

be survived ? need to change to

+       b->sysdata = sys_info?sys_info->sysdata : NULL;

>
>> >
>> > Index: linux/arch/x86/pci/acpi.c
>> > ===================================================================
>> > --- linux.orig/arch/x86/pci/acpi.c
>> > +++ linux/arch/x86/pci/acpi.c
>> > @@ -450,6 +450,7 @@ struct pci_bus * __devinit pci_acpi_scan
>> >         LIST_HEAD(resources);
>> >         struct pci_bus *bus = NULL;
>> >         struct pci_sysdata *sd;
>> > +       struct pci_root_sys_info si;
>> >         int node;
>> >  #ifdef CONFIG_ACPI_NUMA
>> >         int pxm;
>> > @@ -486,6 +487,8 @@ struct pci_bus * __devinit pci_acpi_scan
>> >         sd = &info->sd;
>> >         sd->domain = domain;
>> >         sd->node = node;
>> > +       si.acpi_node.handle = device->handle;
>> > +       si.sysdata = sd;
>>
>> maybe you can try to have si.acpi_handle directly ?
>
> I did it this way for handle to be compiled out when CONFIG_ACPI is not set
> (struct acpi_dev_node is an empty structure in that case).

ok.
