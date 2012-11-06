Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2KFAdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:33:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:55405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab2KFAdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:33:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,719,1344236400"; 
   d="scan'208";a="215573286"
Message-ID: <1352161991.31033.122.camel@yhuang-dev>
Subject: Re: [PATCH RESEND] ACPI/PCI: Make PCI devices notified when its
 power resource turned on
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Date: Tue, 06 Nov 2012 08:33:11 +0800
In-Reply-To: <CAErSpo5zZdxeUFtsKjfb+FcLvAWD-MBorSwTppge9HQ5GCL7_g@mail.gmail.com>
References: <1348667971-30876-1-git-send-email-ying.huang@intel.com>
	 <CAErSpo5zZdxeUFtsKjfb+FcLvAWD-MBorSwTppge9HQ5GCL7_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 17:02 -0700, Bjorn Helgaas wrote:
> On Wed, Sep 26, 2012 at 7:59 AM, Huang Ying <ying.huang@intel.com> wrote:
> > Sorry for bothering.  It appears that this patch should go through ACPI
> > tree because code changed are under drivers/acpi.
> >
> > A set of power resources may be shared by multiple devices.  When all
> > devices share one set of power resources is put into D3_COLD state,
> > the power resources will be turned off.  When one of the device is
> > waked, the power resource will be turned on and all devices share it
> > will be powered on to D0uninitialized state.  These devices should be
> > resumed, so that they can get opportunity to go to low power state
> > later.
> >
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> 
> I had applied this to my for-linus branch, headed for v3.7, but had to
> drop it because it introduced these warnings:
> 
> drivers/acpi/pci_bind.c: In function 'acpi_pci_unbind':
> drivers/acpi/pci_bind.c:48:2: warning: passing argument 1 of
> 'acpi_power_resource_unregister_device' from incompatible pointer type
> [enabled by default]
> include/acpi/acpi_bus.h:346:6: note: expected 'struct device *' but
> argument is of type 'struct pci_dev *'
> drivers/acpi/pci_bind.c: In function 'acpi_pci_bind':
> drivers/acpi/pci_bind.c:75:2: warning: passing argument 1 of
> 'acpi_power_resource_register_device' from incompatible pointer type
> [enabled by default]
> include/acpi/acpi_bus.h:345:5: note: expected 'struct device *' but
> argument is of type 'struct pci_dev *'
> 
> Apparently this wasn't tested :-(

It's my fault.  I apologize for that.  It appear that I turn a RFC to
PATCH without testing.  Will be more careful for next time.

Best Regards,
Huang Ying

> > ---
> >  drivers/acpi/pci_bind.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > --- a/drivers/acpi/pci_bind.c
> > +++ b/drivers/acpi/pci_bind.c
> > @@ -45,6 +45,7 @@ static int acpi_pci_unbind(struct acpi_d
> >
> >         device_set_run_wake(&dev->dev, false);
> >         pci_acpi_remove_pm_notifier(device);
> > +       acpi_power_resource_unregister_device(dev, device->handle);
> >
> >         if (!dev->subordinate)
> >                 goto out;
> > @@ -71,6 +72,7 @@ static int acpi_pci_bind(struct acpi_dev
> >                 return 0;
> >
> >         pci_acpi_add_pm_notifier(device, dev);
> > +       acpi_power_resource_register_device(dev, device->handle);
> >         if (device->wakeup.flags.run_wake)
> >                 device_set_run_wake(&dev->dev, true);
> >


