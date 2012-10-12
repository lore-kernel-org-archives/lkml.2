Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422756Ab2JLKn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:43:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6512 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1422665Ab2JLKnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:43:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344182400"; 
   d="scan'208";a="5990031"
Message-ID: <5077F407.3040205@cn.fujitsu.com>
Date: Fri, 12 Oct 2012 18:42:15 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: yinghai@kernel.org, lenb@kernel.org, bhelgaas@google.com,
        izumi.taku@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Do not use acpi_device to find pci root bridge in
 _init code.
References: <1350037890-5899-1-git-send-email-tangchen@cn.fujitsu.com> <1350037890-5899-3-git-send-email-tangchen@cn.fujitsu.com> <5077F2C2.1010300@huawei.com>
In-Reply-To: <5077F2C2.1010300@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:43:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:43:11,
	Serialize complete at 2012/10/12 18:43:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 06:36 PM, Jiang Liu wrote:
> On 2012-10-12 18:31, Tang Chen wrote:
>> When the kernel is being initialized, and some hardwares are not added
>> to system, there won't be acpi_device structs for these devices. But
>> acpi_is_root_bridge() depends on acpi_device struct. As a result, all
>> the not-added root bridge will not be judged as a root bridge in
>> find_root_bridges(). And further more, no handle_hotplug_event_root()
>> notifier will be installed for them.
>>
>> This patch introduces a new api to find all root bridges in system by
>> getting HID directly from ACPI namespace, not depending on acpi_device
>> struct.
>>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>   drivers/acpi/pci_root.c |   27 ++++++++++++++++++++++-----
>>   1 files changed, 22 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>> index 7d0fb03..3819bee 100644
>> --- a/drivers/acpi/pci_root.c
>> +++ b/drivers/acpi/pci_root.c
>> @@ -128,9 +128,6 @@ EXPORT_SYMBOL_GPL(acpi_get_pci_rootbridge_handle);
>>   /**
>>    * acpi_is_root_bridge - determine whether an ACPI CA node is a PCI root bridge
>>    * @handle - the ACPI CA node in question.
>> - *
>> - * Note: we could make this API take a struct acpi_device * instead, but
>> - * for now, it's more convenient to operate on an acpi_handle.
>>    */
>>   int acpi_is_root_bridge(acpi_handle handle)
>>   {
>> @@ -138,8 +135,28 @@ int acpi_is_root_bridge(acpi_handle handle)
>>   	struct acpi_device *device;
>>
>>   	ret = acpi_bus_get_device(handle,&device);
>> -	if (ret)
>> -		return 0;
>> +	if (ret) {
>> +		/**
>> +		 * If a device is not added to the system yet, there won't be
>> +		 * an acpi_device struct for it. But it doesn't mean it is not
>> +		 * a PCI root bridge. In this case we need to get HID and CID
>> +		 * from ACPI namespace directly.
>> +		 */
>> +		struct acpi_device_info *info;
>> +		acpi_status status;
>> +		status = acpi_get_object_info(handle,&info);
>> +		if (ACPI_FAILURE(status)) {
>> +			printk(KERN_ERR PREFIX "%s: Error reading"
>> +					       "device info\n", __func__);
>> +			return 0;
>> +		}
>> +
>> +		ret = acpi_match_object_info_ids(info, root_device_ids);
>> +		if (ret)
>> +			return 0;
>> +		else
>> +			return 1;
>> +	}
> I have sent a similar patch to Yinghai before. For simplicity, we could
> use acpi_match_object_info_ids() instead of acpi_match_device_ids()
> directly.

Hum, I must have missed it. :)
Using acpi_match_object_info_ids() directly seems good. I'm just worry
about if it could cause any other problem. :)

So now, is this bug fixed ? And we don't need these patches, right ?

Thanks. :)

> Thanks!
> Gerry
>
>>
>>   	ret = acpi_match_device_ids(device, root_device_ids);
>>   	if (ret)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

