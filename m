Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3AIUSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:18:12 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36092 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3AIUSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:18:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 4/6] PCI/acpiphp: update ACPI hotplug slot information when PCI hotplug happens
Date: Wed, 09 Jan 2013 21:23:54 +0100
Message-ID: <2474473.EXPaz4HMXx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <50ED9B03.3020606@gmail.com>
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com> <5038693.7d3RCgbghD@vostro.rjw.lan> <50ED9B03.3020606@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 10, 2013 12:29:55 AM Jiang Liu wrote:
> On 01/09/2013 08:04 AM, Rafael J. Wysocki wrote:
> > On Wednesday, January 09, 2013 12:52:23 AM Jiang Liu wrote:
> >> Currently the acpiphp driver fails to update hotplug slot information under
> >> several conditions, such as:
> >> 1) The bridge device is removed through /sys/bus/pci/devices/.../remove
> >> 2) The bridge device is added/removed by PCI hotplug driver other than the
> >>    acpiphp driver itself. For example, if an IO expansion box with ACPI
> >>    hotplug slots available is hot-added by the pciehp driver, all ACPI
> >>    hotplug slots won't be discovered by the acpiphp driver.
> >>
> >> So hook the BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events to
> >> update ACPI hotplug slot information when PCI hotplug event happens.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> >> ---
> >>  drivers/pci/hotplug/acpiphp_glue.c |   62 ++++++++++++++++++++++++++++++++++--
> >>  1 file changed, 60 insertions(+), 2 deletions(-)
> >>
> snip
> >> +static struct notifier_block acpi_pci_hp_notifier = {
> >> +	.notifier_call = &acpi_pci_hp_notify_fn,
> >> +};
> >> +
> >>  static struct acpi_pci_driver acpi_pci_hp_driver = {
> >>  	.add =		add_bridge,
> >>  	.remove =	remove_bridge,
> >> @@ -1448,6 +1503,8 @@ int __init acpiphp_glue_init(void)
> >>  	else
> >>  		acpi_pci_register_driver(&acpi_pci_hp_driver);
> >>  
> >> +	bus_register_notifier(&pci_bus_type, &acpi_pci_hp_notifier);
> > 
> > Your previous patch adds a PCI bus notifier for a similar thing.  Why are
> > you adding another one here?
> Hi Rafael,
> 	The acpiphp driver could be built as a module, and this bus notifier
> is used to setup/tear down ACPI based PCI hotplug controllers under a PCI bridge.
> The previous patch is to add/remove PCI slots. The PCI slot and PCI hotplug
> controller are related but different objects, so we use two notifiers to support
> them all.

I would be much happier if those notifiers were not needed.  At least, I'm not
sure why they need to be invoked by the driver core during device registration.

In my opinion it would be much better if they were called only for the devices
that might need them instead of all PCI devices.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
