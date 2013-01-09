Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab3AIQ6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:58:30 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60963 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3AIQ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:58:29 -0500
Message-ID: <50EDA1B1.3050501@gmail.com>
Date: Thu, 10 Jan 2013 00:58:25 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 3/6] ACPI/pci_slot: update PCI slot information when
 PCI hotplug event happens
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com> <1357663945-16054-4-git-send-email-jiang.liu@huawei.com> <9523101.J0n0M0VJmQ@vostro.rjw.lan>
In-Reply-To: <9523101.J0n0M0VJmQ@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,
	Thanks for your great efforts to review the patch.	

On 01/09/2013 08:01 AM, Rafael J. Wysocki wrote:
> Hi,
> 
> On Wednesday, January 09, 2013 12:52:22 AM Jiang Liu wrote:
snip
>>  
>> +static void acpi_pci_slot_notify_add(struct pci_dev *dev)
>> +{
>> +	acpi_handle handle;
>> +	struct callback_args context;
>> +
>> +	if (!dev->subordinate)
>> +		return;
>> +
>> +	mutex_lock(&slot_list_lock);
>> +	handle = DEVICE_ACPI_HANDLE(&dev->dev);
>> +	context.root_handle = acpi_find_root_bridge_handle(dev);
> 
> There's a patch under discussion that removes this function.
> 
> Isn't there any other way to do this?
	I will try to find a way to get rid of calling acpi_find_root_bridge_handle,
and it seems doable.

> 
>> +	if (handle && context.root_handle) {
>> +		context.pci_bus = dev->subordinate;
>> +		context.user_function = register_slot;
>> +		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
> 
> You can just pass 1 here I think.  Does the compiler complain?
Thanks for reminder, the (u32) is unnecessary.

> 
>> +				    register_slot, NULL, &context, NULL);
>> +	}
>> +	mutex_unlock(&slot_list_lock);
>> +}
>> +
>> +static void acpi_pci_slot_notify_del(struct pci_dev *dev)
>> +{
>> +	struct acpi_pci_slot *slot, *tmp;
>> +	struct pci_bus *bus = dev->subordinate;
>> +
>> +	if (!bus)
>> +		return;
>> +
>> +	mutex_lock(&slot_list_lock);
>> +	list_for_each_entry_safe(slot, tmp, &slot_list, list)
>> +		if (slot->pci_slot && slot->pci_slot->bus == bus) {
>> +			list_del(&slot->list);
>> +			pci_destroy_slot(slot->pci_slot);
>> +			put_device(&bus->dev);
>> +			kfree(slot);
>> +		}
>> +	mutex_unlock(&slot_list_lock);
>> +}
>> +
>> +static int acpi_pci_slot_notify_fn(struct notifier_block *nb,
>> +				   unsigned long event, void *data)
>> +{
>> +	struct device *dev = data;
>> +
>> +	switch (event) {
>> +	case BUS_NOTIFY_ADD_DEVICE:
>> +		acpi_pci_slot_notify_add(to_pci_dev(dev));
>> +		break;
> 
> Do I think correctly that this is going to be called for every PCI device
> added to the system, even if it's not a bridge?
You are right. Function acpi_pci_slot_notify_add() and acpi_pci_slot_notify_del()
will check whether it's a bridge. If preferred, I will move the check up into
acpi_pci_slot_notify_fn().

> 
>> +	case BUS_NOTIFY_DEL_DEVICE:
>> +		acpi_pci_slot_notify_del(to_pci_dev(dev));
>> +		break;
>> +	default:
>> +		return NOTIFY_DONE;
>> +	}
>> +
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block acpi_pci_slot_notifier = {
>> +	.notifier_call = &acpi_pci_slot_notify_fn,
>> +};
>> +
>>  static int __init
>>  acpi_pci_slot_init(void)
>>  {
>>  	dmi_check_system(acpi_pci_slot_dmi_table);
>>  	acpi_pci_register_driver(&acpi_pci_slot_driver);
>> +	bus_register_notifier(&pci_bus_type, &acpi_pci_slot_notifier);
> 
> I wonder if/why this has to be so convoluted?
> 
> We have found a PCI bridge in the ACPI namespace, so we've created a struct
> acpi_device for it and we've walked the namespace below it already.
> 
> Now we're creating a struct pci_dev for it and while registering it we're
> going to walk the namespace below the bridge again to find and register its
> slots and that is done indirectly from a bus type notifier.
> 
> Why can't we enumerate the slots directly upfront?
Do you mean to create the PCI slot devices when creating the ACPI devices?
I think there are two factors prevent us from doing that.
The first is that the ACPI pci_slot driver could be built as a module, so
we can't call into it from the ACPI core.
The second reason is that the PCI slot is associated with a PCI bus, and the
bus is only available until the PCI device has been created.

Thanks!
Gerry
> 
>> +
>>  	return 0;
>>  }
>>  
>>  static void __exit
>>  acpi_pci_slot_exit(void)
>>  {
>> +	bus_unregister_notifier(&pci_bus_type, &acpi_pci_slot_notifier);
>>  	acpi_pci_unregister_driver(&acpi_pci_slot_driver);
>>  }
> 
> Thanks,
> Rafael
> 
> 

