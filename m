Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422745Ab2JLKiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:38:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62384 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1422685Ab2JLKiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:38:02 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344182400"; 
   d="scan'208";a="5990013"
Message-ID: <5077F2C4.4000203@cn.fujitsu.com>
Date: Fri, 12 Oct 2012 18:36:52 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 22/40] PCI, acpiphp: Separate out hot-add support of pci
 host bridge
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com> <1348080894-23412-1-git-send-email-yinghai@kernel.org> <1348080894-23412-23-git-send-email-yinghai@kernel.org>
In-Reply-To: <1348080894-23412-23-git-send-email-yinghai@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:37:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:37:49,
	Serialize complete at 2012/10/12 18:37:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

When I was reviewing this patch, I found a little problem.

Please refer to email:
[PATCH 0/3] Find pci root bridges by comparing HID from 
acpi_device_info, not acpi_device.

I could be wrong. :)
If I didn't consider your idea correct, or you have a better solution,
please let me know.

Thanks. :)


On 09/20/2012 02:54 AM, Yinghai Lu wrote:
> It causes confusion.
>
> We may only need acpi hp for pci host bridge.
>
> Split host bridge hot-add support to pci_root_hp, and keep acpiphp simple.
>
> Also remove not used res_lock in the struct.
>
> -v2: put back pci_root_hp change in one patch
> -v3: add pcibios_resource_survey_bus() calling
> -v4: remove not needed code with remove_bridge
> -v5: put back support for acpiphp support for slots just on root bus.
> -v6: change some functions to *_p2p_* to make it more clean.
>
> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
> ---
>   drivers/acpi/Makefile              |    1 +
>   drivers/acpi/pci_root_hp.c         |  238 ++++++++++++++++++++++++++++++++++++
>   drivers/pci/hotplug/acpiphp_glue.c |   59 +++-------
>   3 files changed, 254 insertions(+), 44 deletions(-)
>   create mode 100644 drivers/acpi/pci_root_hp.c
>
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 47199e2..c9abd4c 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -36,6 +36,7 @@ acpi-y				+= processor_core.o
>   acpi-y				+= ec.o
>   acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
>   acpi-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
> +acpi-$(CONFIG_HOTPLUG)		+= pci_root_hp.o
>   acpi-y				+= power.o
>   acpi-y				+= event.o
>   acpi-y				+= sysfs.o
> diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
> new file mode 100644
> index 0000000..e07c31b
> --- /dev/null
> +++ b/drivers/acpi/pci_root_hp.c
> @@ -0,0 +1,238 @@
> +/*
> + * Separated from drivers/pci/hotplug/acpiphp_glue.c
> + *	only support root bridge
> + */
> +
> +#include<linux/init.h>
> +#include<linux/module.h>
> +
> +#include<linux/kernel.h>
> +#include<linux/pci.h>
> +#include<linux/mutex.h>
> +#include<linux/slab.h>
> +#include<linux/acpi.h>
> +
> +static LIST_HEAD(acpi_root_bridge_list);
> +struct acpi_root_bridge {
> +	struct list_head list;
> +	acpi_handle handle;
> +	u32 flags;
> +};
> +
> +/* bridge flags */
> +#define ROOT_BRIDGE_HAS_EJ0	(0x00000002)
> +#define ROOT_BRIDGE_HAS_PS3	(0x00000080)
> +
> +#define ACPI_STA_FUNCTIONING	(0x00000008)
> +
> +static struct acpi_root_bridge *acpi_root_handle_to_bridge(acpi_handle handle)
> +{
> +	struct acpi_root_bridge *bridge;
> +
> +	list_for_each_entry(bridge,&acpi_root_bridge_list, list)
> +		if (bridge->handle == handle)
> +			return bridge;
> +
> +	return NULL;
> +}
> +
> +/* allocate and initialize host bridge data structure */
> +static void add_acpi_root_bridge(acpi_handle handle)
> +{
> +	struct acpi_root_bridge *bridge;
> +	acpi_handle dummy_handle;
> +	acpi_status status;
> +
> +	/* if the bridge doesn't have _STA, we assume it is always there */
> +	status = acpi_get_handle(handle, "_STA",&dummy_handle);
> +	if (ACPI_SUCCESS(status)) {
> +		unsigned long long tmp;
> +
> +		status = acpi_evaluate_integer(handle, "_STA", NULL,&tmp);
> +		if (ACPI_FAILURE(status)) {
> +			printk(KERN_DEBUG "%s: _STA evaluation failure\n",
> +						 __func__);
> +			return;
> +		}
> +		if ((tmp&  ACPI_STA_FUNCTIONING) == 0)
> +			/* don't register this object */
> +			return;
> +	}
> +
> +	bridge = kzalloc(sizeof(struct acpi_root_bridge), GFP_KERNEL);
> +	if (!bridge)
> +		return;
> +
> +	bridge->handle = handle;
> +
> +	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0",&dummy_handle)))
> +		bridge->flags |= ROOT_BRIDGE_HAS_EJ0;
> +	if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS3",&dummy_handle)))
> +		bridge->flags |= ROOT_BRIDGE_HAS_PS3;
> +
> +	list_add(&bridge->list,&acpi_root_bridge_list);
> +}
> +
> +struct acpi_root_hp_work {
> +	struct work_struct work;
> +	acpi_handle handle;
> +	u32 type;
> +	void *context;
> +};
> +
> +static void alloc_acpi_root_hp_work(acpi_handle handle, u32 type,
> +					void *context,
> +					void (*func)(struct work_struct *work))
> +{
> +	struct acpi_root_hp_work *hp_work;
> +	int ret;
> +
> +	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
> +	if (!hp_work)
> +		return;
> +
> +	hp_work->handle = handle;
> +	hp_work->type = type;
> +	hp_work->context = context;
> +
> +	INIT_WORK(&hp_work->work, func);
> +	ret = queue_work(kacpi_hotplug_wq,&hp_work->work);
> +	if (!ret)
> +		kfree(hp_work);
> +}
> +
> +/* Program resources in newly inserted bridge */
> +static void acpi_root_configure_bridge(acpi_handle handle)
> +{
> +	struct acpi_pci_root *root = acpi_pci_find_root(handle);
> +
> +	pcibios_resource_survey_bus(root->bus);
> +	pci_assign_unassigned_bus_resources(root->bus);
> +}
> +
> +static void handle_root_bridge_insertion(acpi_handle handle)
> +{
> +	struct acpi_device *device, *pdevice;
> +	acpi_handle phandle;
> +	int ret_val;
> +
> +	acpi_get_parent(handle,&phandle);
> +	if (acpi_bus_get_device(phandle,&pdevice)) {
> +		printk(KERN_DEBUG "no parent device, assuming NULL\n");
> +		pdevice = NULL;
> +	}
> +	if (!acpi_bus_get_device(handle,&device)) {
> +		/* check if  pci root_bus is removed */
> +		struct acpi_pci_root *root = acpi_driver_data(device);
> +		if (pci_find_bus(root->segment, root->secondary.start))
> +			return;
> +
> +		printk(KERN_DEBUG "bus exists... trim\n");
> +		/* this shouldn't be in here, so remove
> +		 * the bus then re-add it...
> +		 */
> +		ret_val = acpi_bus_trim(device, 1);
> +		printk(KERN_DEBUG "acpi_bus_trim return %x\n", ret_val);
> +	}
> +	if (acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE)) {
> +		printk(KERN_ERR "cannot add bridge to acpi list\n");
> +		return;
> +	}
> +	acpi_root_configure_bridge(handle);
> +	if (acpi_bus_start(device))
> +		printk(KERN_ERR "cannot start bridge\n");
> +}
> +
> +static void _handle_hotplug_event_root(struct work_struct *work)
> +{
> +	struct acpi_root_bridge *bridge;
> +	char objname[64];
> +	struct acpi_buffer buffer = { .length = sizeof(objname),
> +				      .pointer = objname };
> +	struct acpi_root_hp_work *hp_work;
> +	acpi_handle handle;
> +	u32 type;
> +
> +	hp_work = container_of(work, struct acpi_root_hp_work, work);
> +	handle = hp_work->handle;
> +	type = hp_work->type;
> +
> +	bridge = acpi_root_handle_to_bridge(handle);
> +
> +	acpi_get_name(handle, ACPI_FULL_PATHNAME,&buffer);
> +
> +	switch (type) {
> +	case ACPI_NOTIFY_BUS_CHECK:
> +		/* bus enumerate */
> +		printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
> +				 objname);
> +		if (!bridge) {
> +			handle_root_bridge_insertion(handle);
> +			add_acpi_root_bridge(handle);
> +		}
> +
> +		break;
> +
> +	case ACPI_NOTIFY_DEVICE_CHECK:
> +		/* device check */
> +		printk(KERN_DEBUG "%s: Device check notify on %s\n", __func__,
> +				 objname);
> +		if (!bridge) {
> +			handle_root_bridge_insertion(handle);
> +			add_acpi_root_bridge(handle);
> +		}
> +		break;
> +
> +	default:
> +		printk(KERN_WARNING "notify_handler: unknown event type 0x%x for %s\n",
> +				 type, objname);
> +		break;
> +	}
> +
> +	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
> +}
> +
> +static void handle_hotplug_event_root(acpi_handle handle, u32 type,
> +					void *context)
> +{
> +	alloc_acpi_root_hp_work(handle, type, context,
> +				_handle_hotplug_event_root);
> +}
> +
> +static acpi_status __init
> +find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> +{
> +	char objname[64];
> +	struct acpi_buffer buffer = { .length = sizeof(objname),
> +				      .pointer = objname };
> +	int *count = (int *)context;
> +
> +	if (!acpi_is_root_bridge(handle))
> +		return AE_OK;
> +
> +	(*count)++;
> +
> +	acpi_get_name(handle, ACPI_FULL_PATHNAME,&buffer);
> +
> +	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +				handle_hotplug_event_root, NULL);
> +	printk(KERN_DEBUG "acpi root: %s notify handler installed\n", objname);
> +
> +	add_acpi_root_bridge(handle);
> +
> +	return AE_OK;
> +}
> +
> +static int __init acpi_pci_root_hp_init(void)
> +{
> +	int num = 0;
> +
> +	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> +		ACPI_UINT32_MAX, find_root_bridges, NULL,&num, NULL);
> +
> +	printk(KERN_DEBUG "Found %d acpi root devices\n", num);
> +
> +	return 0;
> +}
> +
> +subsys_initcall(acpi_pci_root_hp_init);
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 6cb1923..00fa414 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -521,10 +521,13 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
>   	acpi_status status;
>   	acpi_handle handle = bridge->handle;
>
> -	status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +	if (bridge->type != BRIDGE_TYPE_HOST) {
> +		status = acpi_remove_notify_handler(handle,
> +					    ACPI_SYSTEM_NOTIFY,
>   					    handle_hotplug_event_bridge);
> -	if (ACPI_FAILURE(status))
> -		err("failed to remove notify handler\n");
> +		if (ACPI_FAILURE(status))
> +			err("failed to remove notify handler\n");
> +	}
>
>   	if ((bridge->type != BRIDGE_TYPE_HOST)&&
>   	((bridge->flags&  BRIDGE_HAS_EJ0)&&  bridge->func)) {
> @@ -607,9 +610,6 @@ static void remove_bridge(acpi_handle handle)
>   	bridge = acpiphp_handle_to_bridge(handle);
>   	if (bridge)
>   		cleanup_bridge(bridge);
> -	else
> -		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> -					   handle_hotplug_event_bridge);
>   }
>
>   static int power_on_slot(struct acpiphp_slot *slot)
> @@ -1110,18 +1110,12 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
>   }
>
>   /* Program resources in newly inserted bridge */
> -static int acpiphp_configure_bridge (acpi_handle handle)
> +static int acpiphp_configure_p2p_bridge(acpi_handle handle)
>   {
> -	struct pci_bus *bus;
> +	struct pci_dev *pdev = acpi_get_pci_dev(handle);
> +	struct pci_bus *bus = pdev->subordinate;
>
> -	if (acpi_is_root_bridge(handle)) {
> -		struct acpi_pci_root *root = acpi_pci_find_root(handle);
> -		bus = root->bus;
> -	} else {
> -		struct pci_dev *pdev = acpi_get_pci_dev(handle);
> -		bus = pdev->subordinate;
> -		pci_dev_put(pdev);
> -	}
> +	pci_dev_put(pdev);
>
>   	pci_bus_size_bridges(bus);
>   	pci_bus_assign_resources(bus);
> @@ -1131,7 +1125,7 @@ static int acpiphp_configure_bridge (acpi_handle handle)
>   	return 0;
>   }
>
> -static void handle_bridge_insertion(acpi_handle handle, u32 type)
> +static void handle_p2p_bridge_insertion(acpi_handle handle, u32 type)
>   {
>   	struct acpi_device *device, *pdevice;
>   	acpi_handle phandle;
> @@ -1151,9 +1145,9 @@ static void handle_bridge_insertion(acpi_handle handle, u32 type)
>   		err("cannot add bridge to acpi list\n");
>   		return;
>   	}
> -	if (!acpiphp_configure_bridge(handle)&&
> +	if (!acpiphp_configure_p2p_bridge(handle)&&
>   		!acpi_bus_start(device))
> -		add_bridge(handle);
> +		add_p2p_bridge(handle);
>   	else
>   		err("cannot configure and start bridge\n");
>
> @@ -1239,7 +1233,7 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
>
>   	if (acpi_bus_get_device(handle,&device)) {
>   		/* This bridge must have just been physically inserted */
> -		handle_bridge_insertion(handle, type);
> +		handle_p2p_bridge_insertion(handle, type);
>   		goto out;
>   	}
>
> @@ -1416,21 +1410,6 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
>   			      _handle_hotplug_event_func);
>   }
>
> -static acpi_status
> -find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> -{
> -	int *count = (int *)context;
> -
> -	if (!acpi_is_root_bridge(handle))
> -		return AE_OK;
> -
> -	(*count)++;
> -	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> -				    handle_hotplug_event_bridge, NULL);
> -
> -	return AE_OK ;
> -}
> -
>   static struct acpi_pci_driver acpi_pci_hp_driver = {
>   	.add =		add_bridge,
>   	.remove =	remove_bridge,
> @@ -1441,15 +1420,7 @@ static struct acpi_pci_driver acpi_pci_hp_driver = {
>    */
>   int __init acpiphp_glue_init(void)
>   {
> -	int num = 0;
> -
> -	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> -			ACPI_UINT32_MAX, find_root_bridges, NULL,&num, NULL);
> -
> -	if (num<= 0)
> -		return -1;
> -	else
> -		acpi_pci_register_driver(&acpi_pci_hp_driver);
> +	acpi_pci_register_driver(&acpi_pci_hp_driver);
>
>   	return 0;
>   }

