Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab2IHBAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:00:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37387 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2IHBA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:00:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120823154503.15a45b14@feng-i7>
References: <5017D19B.5080806@redhat.com>
	<1343738627.27983.30.camel@gandalf.stny.rr.com>
	<5017D4AB.3090107@redhat.com>
	<1343740419.27983.33.camel@gandalf.stny.rr.com>
	<20120731234336.GA5526@localhost>
	<1343778699.27983.70.camel@gandalf.stny.rr.com>
	<20120731235705.GW2422@linux.vnet.ibm.com>
	<1343779778.27983.73.camel@gandalf.stny.rr.com>
	<20120801001811.GX2422@linux.vnet.ibm.com>
	<20120801004319.GA7043@localhost>
	<20120822025008.GA8066@localhost>
	<20120822154908.2e6ef3c0@feng-i7>
	<CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
	<20120823154503.15a45b14@feng-i7>
Date: Fri, 7 Sep 2012 18:00:23 -0700
X-Google-Sender-Auth: WC_DIqVqY6c1iFfDCqDb7pOy2m0
Message-ID: <CAE9FiQVXj6sLEs0GiBnVsKAbms-Bnt06xYeT01MBtSjNqaqypA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: Use local parameter pci_device_id for pci_get_subsys/class()
From: Yinghai Lu <yinghai@kernel.org>
To: Feng Tang <feng.tang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:45 AM, Feng Tang <feng.tang@intel.com> wrote:
> From 57a28ee5e7662ca28ba4c793aa037d64bd082dee Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Wed, 22 Aug 2012 15:41:51 +0800
> Subject: [PATCH 1/2] PCI: Use local parameter pci_device_id for pci_get_subsys/class()
>
> This fixes a kernel warning https://lkml.org/lkml/2012/7/31/682
>
> pci_get_subsys() may get called in late system reboot stage, using
> a sleepable kmalloc() sounds fragile and will casue a kernel warning
> with my recent commmit 55c844a "x86/reboot: Fix a warning message
> triggered by stop_other_cpus()" which disable local interrupt in
> late system shutdown/reboot phase. Using a local parameter instead
> will fix it and make it eligible for calling forom atomic context.
>
> Do the same change for the pci_get_class() as suggeted by Bjorn Helgaas
>
> Bisected-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  drivers/pci/search.c |   35 +++++++++++------------------------
>  1 files changed, 11 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 993d4a0..78a08b1 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -245,8 +245,7 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
>                                unsigned int ss_vendor, unsigned int ss_device,
>                                struct pci_dev *from)
>  {
> -       struct pci_dev *pdev;
> -       struct pci_device_id *id;
> +       struct pci_device_id id;
>
>         /*
>          * pci_find_subsys() can be called on the ide_setup() path,
> @@ -257,18 +256,12 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
>         if (unlikely(no_pci_devices()))
>                 return NULL;
>
> -       id = kzalloc(sizeof(*id), GFP_KERNEL);
> -       if (!id)
> -               return NULL;
> -       id->vendor = vendor;
> -       id->device = device;
> -       id->subvendor = ss_vendor;
> -       id->subdevice = ss_device;
> -
> -       pdev = pci_get_dev_by_id(id, from);
> -       kfree(id);
> +       id.vendor = vendor;
> +       id.device = device;
> +       id.subvendor = ss_vendor;
> +       id.subdevice = ss_device;
>
> -       return pdev;
> +       return pci_get_dev_by_id(&id, from);
>  }
>
>  /**
> @@ -307,19 +300,13 @@ pci_get_device(unsigned int vendor, unsigned int device, struct pci_dev *from)
>   */
>  struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from)
>  {
> -       struct pci_dev *dev;
> -       struct pci_device_id *id;
> +       struct pci_device_id id;
>
> -       id = kzalloc(sizeof(*id), GFP_KERNEL);
> -       if (!id)
> -               return NULL;
> -       id->vendor = id->device = id->subvendor = id->subdevice = PCI_ANY_ID;
> -       id->class_mask = PCI_ANY_ID;
> -       id->class = class;
> +       id.vendor = id.device = id.subvendor = id.subdevice = PCI_ANY_ID;
> +       id.class_mask = PCI_ANY_ID;
> +       id.class = class;
>
> -       dev = pci_get_dev_by_id(id, from);
> -       kfree(id);
> -       return dev;
> +       return pci_get_dev_by_id(&id, from);
>  }
>
>  /**

with this one in pci/next pci config in /sys are not created.

10:~ # lspci -tv
pcilib: Cannot open /sys/bus/pci/devices/0000:00:03.0/config
lspci: Unable to read the standard configuration space header of
device 0000:00:03.0
pcilib: Cannot open /sys/bus/pci/devices/0000:00:02.0/config
lspci: Unable to read the standard configuration space header of
device 0000:00:02.0
pcilib: Cannot open /sys/bus/pci/devices/0000:00:01.3/config
lspci: Unable to read the standard configuration space header of
device 0000:00:01.3
pcilib: Cannot open /sys/bus/pci/devices/0000:00:01.1/config
lspci: Unable to read the standard configuration space header of
device 0000:00:01.1
pcilib: Cannot open /sys/bus/pci/devices/0000:00:01.0/config
lspci: Unable to read the standard configuration space header of
device 0000:00:01.0
pcilib: Cannot open /sys/bus/pci/devices/0000:00:00.0/config
lspci: Unable to read the standard configuration space header of
device 0000:00:00.0
-[0000:00]-

bisected to this commit

ccee7d23102f5e5765ec24779c5b77472af8f79e is the first bad commit
commit ccee7d23102f5e5765ec24779c5b77472af8f79e
Author: Feng Tang <feng.tang@intel.com>
Date:   Thu Aug 23 15:45:03 2012 +0800

    PCI: Use pci_device_id on stack for pci_get_subsys/class() to avoid kmalloc

    This fixes a kernel warning https://lkml.org/lkml/2012/7/31/682

    pci_get_subsys() may get called in late system reboot stage, using
    a sleepable kmalloc() sounds fragile and will cause a kernel warning
    with my recent commmit 55c844a "x86/reboot: Fix a warning message
    triggered by stop_other_cpus()" which disable local interrupt in
    late system shutdown/reboot phase. Using a local parameter instead
    will fix it and make it eligible for calling forom atomic context.

    Do the same change for the pci_get_class() as suggested by Bjorn Helgaas

    [bhelgaas: changelog]
    Bisected-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

:040000 040000 dee62a035816b73abc68e40de8f21c7349efc4cb
70b2a6258bffa1ab963bd650d8f5d02da774fbce M	drivers

so the stack get overrun ?

Bjorn, I think it is this one that cause lspci broken that I mentioned
during meeting at San Diego.

Thanks

Yinghai
