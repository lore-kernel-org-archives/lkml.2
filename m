Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2HDJlC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 05:41:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34044 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2HDJk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 05:40:56 -0400
Message-ID: <501CEE21.6000209@gmail.com>
Date: Sat, 04 Aug 2012 17:40:49 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
CC: Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Bob Moore <robert.moore@intel.com>, Huang Ying <ying.huang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <guohanjun@huawei.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, Gaohuai Han <hangaohuai@huawei.com>
Subject: Re: [RFC PATCH 2/3] ACPIHP: ACPI system device hotplug slot enumerator
References: <1343475772-21345-1-git-send-email-jiang.liu@huawei.com> <1343475772-21345-3-git-send-email-jiang.liu@huawei.com> <20120803151017.38a2190b.izumi.taku@jp.fujitsu.com>
In-Reply-To: <20120803151017.38a2190b.izumi.taku@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +/*
>> + * Guess type of a hotplug slot according to child devices connecting to it.
>> + */
>> +static enum acpihp_slot_type __init acpihp_enum_get_slot_type(u32 dev_types)
>> +{
>> +	BUG_ON(dev_types > 15);
>> +
>> +	switch (dev_types) {
>> +	case 0:
>> +		/* Generic CONTAINER */
>> +		return ACPIHP_SLOT_TYPE_COMMON;
>> +	case 1:
>> +		/* Physical processor with logical CPUs */
>> +		return ACPIHP_SLOT_TYPE_CPU;
>> +	case 2:
>> +		/* Memory board/box with memory devices */
>> +		return ACPIHP_SLOT_TYPE_MEM;
>> +	case 3:
>> +		/* Physical processor with CPUs and memory controllers */
>> +		return ACPIHP_SLOT_TYPE_CPU;
>> +	case 4:
>> +		/* IO eXtension board/box with IO host bridges */
>> +		return ACPIHP_SLOT_TYPE_IOX;
>> +	case 7:
>> +		/* Physical processor with CPUs, IO host bridges and MCs. */
>> +		return ACPIHP_SLOT_TYPE_CPU;
> 
> 
>    Why is this case ACPIHP_SLOT_TYPE_CPU? 
>    I think this case is ACPIHP_SLOT_TYPE_COMMON or else.
>    By the way how about simplifying slot type category?
>    Do we need to differentiate case7, 8, 9, 11 and 15?

Hi Izumi,
	Thanks for your comments!
	The 'case 7' is for the typical case of Intel next generation processors with
embedded memory controllers and IOH. It's reasonable to treat 9, 10, 15 in the same way
because I have encountered a system board with only CPU and memory in x86/IA64 world. 
For "case 8", I have no idea about what's the most suitable way to deal with it because
I haven't seen a ACPI implementation exhibits such a namespace structure yet.
 
	Actually we have strong dependency on firmware implementation to generate a
meaningful name for each hotplug slot.

> 	 
>    Best regards,
>    Taku Izumi
> 
> 
>> +	case 8:
>> +		/* Generic CONTAINER */
>> +		return ACPIHP_SLOT_TYPE_COMMON;
>> +	case 9:
>> +		/* System board with physical processors */
>> +		return ACPIHP_SLOT_TYPE_SYSTEM_BOARD;
>> +	case 11:
>> +		/* System board with physical processors and memory */
>> +		return ACPIHP_SLOT_TYPE_SYSTEM_BOARD;
>> +	case 15:
>> +		/* Node with processor, memory and IO host bridge */
>> +		return ACPIHP_SLOT_TYPE_NODE;
>> +	default:
>> +		return ACPIHP_SLOT_TYPE_UNKNOWN;
>> +	}
>> +}
>> +
>> +/*
>> + * Guess type of a hotplug slot according to the device type of the
>> + * corresponding ACPI object itself.
>> + */
>> +static enum acpihp_slot_type __init
>> +acpihp_enum_check_slot_self(struct acpihp_slot *slot)
>> +{
>> +	enum acpihp_dev_type type;
>> +
>> +	if (acpihp_dev_get_type(slot->handle, &type))
>> +		return ACPIHP_SLOT_TYPE_UNKNOWN;
>> +
>> +	switch (type) {
>> +	case ACPIHP_DEV_TYPE_CPU:
>> +		/* Logical CPU used in virtualization environment */
>> +		return ACPIHP_SLOT_TYPE_CPU;
>> +	case ACPIHP_DEV_TYPE_MEM:
>> +		/* Memory board with single memory device */
>> +		return ACPIHP_SLOT_TYPE_MEM;
>> +	case ACPIHP_DEV_TYPE_HOST_BRIDGE:
>> +		/* IO eXtension board/box with single IO host bridge */
>> +		return ACPIHP_SLOT_TYPE_IOX;
>> +	default:
>> +		return ACPIHP_SLOT_TYPE_UNKNOWN;
>> +	}
>> +}
>> +
>> +static int __init acpihp_enum_generate_slot_name(struct acpihp_slot *slot)
>> +{
>> +	int found = 0;
>> +	struct list_head *list;
>> +	struct acpihp_slot_id *slot_id;
>> +	unsigned long long uid;
>> +
>> +	/* Respect firmware settings if _UID return an integer. */
>> +	if (ACPI_SUCCESS(acpi_evaluate_integer(slot->handle, METHOD_NAME__UID,
>> +					       NULL, &uid)))
>> +		goto set_name;
>> +
>> +	if (slot->parent)
>> +		list = &slot->parent->slot_id_list;
>> +	else
>> +		list = &slot_id_list;
>> +
>> +	list_for_each_entry(slot_id, list, node)
>> +		if (slot_id->type == slot->type) {
>> +			found = 1;
>> +			break;
>> +		}
>> +	if (!found) {
>> +		slot_id = kzalloc(sizeof(struct acpihp_slot_id), GFP_KERNEL);
>> +		if (!slot_id) {
>> +			ACPIHP_DEBUG("fails to allocate slot instance ID.\n");
>> +			return -ENOMEM;
>> +		}
>> +		slot_id->type = slot->type;
>> +		list_add_tail(&slot_id->node, list);
>> +	}
>> +
>> +	uid = slot_id->instance_id++;
>> +
>> +set_name:
>> +	snprintf(slot->name, sizeof(slot->name) - 1, "%s%02llx",
>> +		 acpihp_get_slot_type_name(slot->type), uid);
>> +	dev_set_name(&slot->dev, "%s", slot->name);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Generate a meaningful name for the slot according to devices connecting
>> + * to this slot
>> + */
>> +static int __init acpihp_enum_rename_slot(struct acpihp_slot *slot)
>> +{
>> +	u32 child_types = 0;
>> +
>> +	slot->type = acpihp_enum_check_slot_self(slot);
>> +	if (slot->type == ACPIHP_SLOT_TYPE_UNKNOWN) {
>> +		acpi_walk_namespace(ACPI_TYPE_DEVICE, slot->handle,
>> +				ACPI_UINT32_MAX, acpihp_enum_get_dev_type,
>> +				NULL, NULL, (void **)&child_types);
>> +		acpi_walk_namespace(ACPI_TYPE_PROCESSOR, slot->handle,
>> +				ACPI_UINT32_MAX, acpihp_enum_get_dev_type,
>> +				NULL, NULL, (void **)&child_types);
>> +		slot->type = acpihp_enum_get_slot_type(child_types);
>> +	}
>> +
>> +	if (acpihp_enum_generate_slot_name(slot))
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static void __init acpihp_enum_rename_and_register_slots(void)
>> +{
>> +	struct acpihp_slot *slot;
>> +
>> +	list_for_each_entry(slot, &slot_list, slot_list) {
>> +		/* generate a meaningful name for this slot */
>> +		if (acpihp_enum_rename_slot(slot))
>> +			continue;
>> +
>> +		if (acpihp_register_slot(slot))
>> +			ACPIHP_DEBUG("fails to register slot %s.\n",
>> +				     slot->name);
>> +	}
>> +}
>> +
>> +static int __init acpihp_enum_generate_slots(void)
>> +{
>> +	acpi_status status;
>> +
>> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
>> +				     ACPI_UINT32_MAX, acpihp_enum_scan_slot,
>> +				     NULL, NULL, NULL);
>> +	if (!ACPI_SUCCESS(status))
>> +		goto out_err;
>> +
>> +	status = acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
>> +				     ACPI_UINT32_MAX, acpihp_enum_scan_slot,
>> +				     NULL, NULL, NULL);
>> +	if (!ACPI_SUCCESS(status))
>> +		goto out_err;
>> +
>> +	acpihp_enum_rename_and_register_slots();
>> +
>> +	return 0;
>> +
>> +out_err:
>> +	ACPIHP_DEBUG("fails to scan hotplug slots.\n");
>> +	acpihp_enum_cleanup_slots();
>> +
>> +	return -ENOTSUPP;
>> +}
>> +
>> +static void acpihp_enum_unregister_slots(void)
>> +{
>> +	struct acpihp_slot *slot, *tmp;
>> +	struct acpihp_slot_id *slot_id, *slot_id_safe;
>> +
>> +	list_for_each_entry_safe(slot, tmp, &slot_list, slot_list) {
>> +		acpihp_unregister_slot(slot);
>> +		list_del_init(&slot->slot_list);
>> +		acpihp_unmark_slot(slot->handle);
>> +		list_for_each_entry_safe(slot_id, slot_id_safe,
>> +					 &slot->slot_id_list, node) {
>> +			list_del(&slot_id->node);
>> +			kfree(slot_id);
>> +		}
>> +		acpihp_slot_put(slot);
>> +	}
>> +}
>> +
>> +static void acpihp_enum_cleanup_slots(void)
>> +{
>> +	struct acpihp_slot_id *slot_id, *tmp;
>> +
>> +	acpihp_enum_unregister_slots();
>> +	list_for_each_entry_safe(slot_id, tmp, &slot_id_list, node) {
>> +		list_del(&slot_id->node);
>> +		kfree(slot_id);
>> +	}
>> +}
>> +
>> +static int __init acpihp_enum_init(void)
>> +{
>> +	int i;
>> +	int retval;
>> +
>> +	/* probe for suitable enumerator. */
>> +	for (i = 0; slot_ops_array[i]; i++)
>> +		if (ACPI_SUCCESS(slot_ops_array[i]->init())) {
>> +			slot_ops_curr = slot_ops_array[i];
>> +			break;
>> +		}
>> +	if (slot_ops_curr == NULL) {
>> +		ACPIHP_DEBUG("no ACPI hotplug slot found.\n");
>> +		return -ENXIO;
>> +	}
>> +
>> +	retval = acpihp_register_class();
>> +	if (retval != 0) {
>> +		ACPIHP_DEBUG("fails to register ACPI hotplug slot class.\n");
>> +		goto out_fini;
>> +	}
>> +
>> +	retval = acpihp_enum_generate_slots();
>> +	if (retval != 0) {
>> +		ACPIHP_DEBUG("fails to enumerate ACPI hotplug slots.\n");
>> +		goto out_unregister_class;
>> +	}
>> +
>> +	/* Back out if no ACPI hotplug slot  found. */
>> +	if (list_empty(&slot_list)) {
>> +		ACPIHP_DEBUG("no ACPI hotplug slot found.\n");
>> +		retval = -ENODEV;
>> +		goto out_unregister_class;
>> +	}
>> +
>> +	return 0;
>> +
>> +out_unregister_class:
>> +	acpihp_unregister_class();
>> +out_fini:
>> +	slot_ops_curr->fini();
>> +	ACPIHP_DEBUG("fails to initialize hotplug slot enumerator.\n");
>> +
>> +	return retval;
>> +}
>> +
>> +static void __exit acpihp_enum_exit(void)
>> +{
>> +	acpihp_enum_cleanup_slots();
>> +	acpihp_unregister_class();
>> +	slot_ops_curr->fini();
>> +}
>> +
>> +module_init(acpihp_enum_init);
>> +module_exit(acpihp_enum_exit);
>> +
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_AUTHOR("Jiang Liu <jiang.liu@huawei.com>");
>> +MODULE_AUTHOR("Gaohuai Han <hangaohuai@huawei.com>");
>> -- 
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 

