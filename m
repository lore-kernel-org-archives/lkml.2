Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab3AHX6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:58:53 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35224 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab3AHX6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:58:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 4/6] PCI/acpiphp: update ACPI hotplug slot information when PCI hotplug happens
Date: Wed, 09 Jan 2013 01:04:34 +0100
Message-ID: <5038693.7d3RCgbghD@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357663945-16054-5-git-send-email-jiang.liu@huawei.com>
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com> <1357663945-16054-5-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 09, 2013 12:52:23 AM Jiang Liu wrote:
> Currently the acpiphp driver fails to update hotplug slot information under
> several conditions, such as:
> 1) The bridge device is removed through /sys/bus/pci/devices/.../remove
> 2) The bridge device is added/removed by PCI hotplug driver other than the
>    acpiphp driver itself. For example, if an IO expansion box with ACPI
>    hotplug slots available is hot-added by the pciehp driver, all ACPI
>    hotplug slots won't be discovered by the acpiphp driver.
> 
> So hook the BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events to
> update ACPI hotplug slot information when PCI hotplug event happens.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   62 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 60 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 3d6d4fd..16fe692 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -61,6 +61,7 @@ static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
>  static void acpiphp_sanitize_bus(struct pci_bus *bus);
>  static void acpiphp_set_hpp_values(struct pci_bus *bus);
>  static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
> +static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle);
>  
>  /* callback routine to check for the existence of a pci dock device */
>  static acpi_status
> @@ -420,12 +421,14 @@ static void add_host_bridge(struct acpi_pci_root *root)
>  	init_bridge_misc(bridge);
>  }
>  
> -
>  /* allocate and initialize PCI-to-PCI bridge data structure */
> -static void add_p2p_bridge(acpi_handle *handle)
> +static void add_p2p_bridge(acpi_handle handle)
>  {
>  	struct acpiphp_bridge *bridge;
>  
> +	if (acpiphp_handle_to_bridge(handle))
> +		return;
> +
>  	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
>  	if (bridge == NULL) {
>  		err("out of memory\n");
> @@ -1428,6 +1431,58 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>  	return AE_OK ;
>  }
>  
> +static void acpiphp_hp_notify_add(struct pci_dev *dev)
> +{
> +	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
> +
> +	if (!dev->subordinate || !handle)
> +		return;
> +
> +	/* check if this bridge has ejectable slots */
> +	if (detect_ejectable_slots(handle) > 0) {
> +		dbg("found PCI-to-PCI bridge at PCI %s\n", pci_name(dev));
> +		add_p2p_bridge(handle);
> +	}
> +}
> +
> +static void acpiphp_hp_notify_del(struct pci_dev *dev)
> +{
> +	struct acpiphp_bridge *bridge, *tmp;
> +	struct pci_bus *bus = dev->subordinate;
> +
> +	if (!bus)
> +		return;
> +
> +	list_for_each_entry_safe(bridge, tmp, &bridge_list, list)
> +		if (bridge->pci_bus == bus) {
> +			cleanup_bridge(bridge);
> +			break;
> +		}
> +}
> +
> +static int acpi_pci_hp_notify_fn(struct notifier_block *nb,
> +				 unsigned long event, void *data)
> +{
> +	struct device *dev = data;
> +
> +	switch (event) {
> +	case BUS_NOTIFY_ADD_DEVICE:
> +		acpiphp_hp_notify_add(to_pci_dev(dev));
> +		break;
> +	case BUS_NOTIFY_DEL_DEVICE:
> +		acpiphp_hp_notify_del(to_pci_dev(dev));
> +		break;
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block acpi_pci_hp_notifier = {
> +	.notifier_call = &acpi_pci_hp_notify_fn,
> +};
> +
>  static struct acpi_pci_driver acpi_pci_hp_driver = {
>  	.add =		add_bridge,
>  	.remove =	remove_bridge,
> @@ -1448,6 +1503,8 @@ int __init acpiphp_glue_init(void)
>  	else
>  		acpi_pci_register_driver(&acpi_pci_hp_driver);
>  
> +	bus_register_notifier(&pci_bus_type, &acpi_pci_hp_notifier);

Your previous patch adds a PCI bus notifier for a similar thing.  Why are
you adding another one here?


> +
>  	return 0;
>  }
>  
> @@ -1459,6 +1516,7 @@ int __init acpiphp_glue_init(void)
>   */
>  void  acpiphp_glue_exit(void)
>  {
> +	bus_unregister_notifier(&pci_bus_type, &acpi_pci_hp_notifier);
>  	acpi_pci_unregister_driver(&acpi_pci_hp_driver);
>  }

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
