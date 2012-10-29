Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab2J2GKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:10:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38579 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab2J2GKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:10:49 -0400
X-IronPort-AV: E=Sophos;i="4.80,669,1344182400"; 
   d="scan'208";a="6089016"
Message-ID: <508E1F3D.7030806@cn.fujitsu.com>
Date: Mon, 29 Oct 2012 14:16:29 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, liuj97@gmail.com, len.brown@intel.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, rjw@sisk.pl, laijs@cn.fujitsu.com,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v3 3/3] acpi,memory-hotplug : add memory offline code
 to acpi_memory_device_remove()
References: <1351247463-5653-1-git-send-email-wency@cn.fujitsu.com>	 <1351247463-5653-4-git-send-email-wency@cn.fujitsu.com> <1351271671.19172.74.camel@misato.fc.hp.com>
In-Reply-To: <1351271671.19172.74.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 14:10:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 14:10:07,
	Serialize complete at 2012/10/29 14:10:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/27/2012 01:14 AM, Toshi Kani Wrote:
> On Fri, 2012-10-26 at 18:31 +0800, wency@cn.fujitsu.com wrote:
>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> The memory device can be removed by 2 ways:
>> 1. send eject request by SCI
>> 2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
>>
>> In the 1st case, acpi_memory_disable_device() will be called.
>> In the 2nd case, acpi_memory_device_remove() will be called.
> 
> Hi Yasuaki, Wen,
> 
> Why do you need to have separate code design & implementation for the
> two cases?  In other words, can the 1st case simply use the same code
> path of the 2nd case, just like I did for the CPU hot-remove patch
> below?  It will simplify the code and make the memory notify handler
> more consistent with other handlers.
> https://lkml.org/lkml/2012/10/19/456

Yes, the 1st case can simply reuse the same code of the 2nd case.
It is another issue. The memory is not offlined and removed in 2nd
case. This patchset tries to fix this problem. After doing this,
we can merge the codes for the two cases.

But there is some bug in the code for 2nd case:
If offlining memory failed, we don't know such error in 2nd case, and
the kernel will in a dangerous state: the memory device is poweroffed
but the kernel is using it.

We should fix this bug before merging them.

Thanks
Wen Congyang

> 
> Thanks,
> -Toshi
> 
> 
>> acpi_memory_device_remove() will also be called when we unbind the
>> memory device from the driver acpi_memhotplug or a driver initialization
>> fails.
>>
>> acpi_memory_disable_device() has already implemented a code which
>> offlines memory and releases acpi_memory_info struct. But
>> acpi_memory_device_remove() has not implemented it yet.
>>
>> So the patch move offlining memory and releasing acpi_memory_info struct
>> codes to a new function acpi_memory_remove_memory(). And it is used by both
>> acpi_memory_device_remove() and acpi_memory_disable_device().
>>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Jiang Liu <liuj97@gmail.com>
>> CC: Len Brown <len.brown@intel.com>
>> CC: Christoph Lameter <cl@linux.com>
>> Cc: Minchan Kim <minchan.kim@gmail.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  drivers/acpi/acpi_memhotplug.c | 31 ++++++++++++++++++++++++-------
>>  1 file changed, 24 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
>> index 666dac6..92c973a 100644
>> --- a/drivers/acpi/acpi_memhotplug.c
>> +++ b/drivers/acpi/acpi_memhotplug.c
>> @@ -316,16 +316,11 @@ static int acpi_memory_powerdown_device(struct acpi_memory_device *mem_device)
>>  	return 0;
>>  }
>>  
>> -static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
>> +static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
>>  {
>>  	int result;
>>  	struct acpi_memory_info *info, *n;
>>  
>> -
>> -	/*
>> -	 * Ask the VM to offline this memory range.
>> -	 * Note: Assume that this function returns zero on success
>> -	 */
>>  	mutex_lock(&mem_device->list_lock);
>>  	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
>>  		if (info->enabled) {
>> @@ -333,10 +328,27 @@ static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
>>  			if (result)
>>  				return result;
>>  		}
>> +
>> +		list_del(&info->list);
>>  		kfree(info);
>>  	}
>>  	mutex_unlock(&mem_device->list_lock);
>>  
>> +	return 0;
>> +}
>> +
>> +static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
>> +{
>> +	int result;
>> +
>> +	/*
>> +	 * Ask the VM to offline this memory range.
>> +	 * Note: Assume that this function returns zero on success
>> +	 */
>> +	result = acpi_memory_remove_memory(mem_device);
>> +	if (result)
>> +		return result;
>> +
>>  	/* Power-off and eject the device */
>>  	result = acpi_memory_powerdown_device(mem_device);
>>  	if (result) {
>> @@ -487,12 +499,17 @@ static int acpi_memory_device_add(struct acpi_device *device)
>>  static int acpi_memory_device_remove(struct acpi_device *device, int type)
>>  {
>>  	struct acpi_memory_device *mem_device = NULL;
>> -
>> +	int result;
>>  
>>  	if (!device || !acpi_driver_data(device))
>>  		return -EINVAL;
>>  
>>  	mem_device = acpi_driver_data(device);
>> +
>> +	result = acpi_memory_remove_memory(mem_device);
>> +	if (result)
>> +		return result;
>> +
>>  	kfree(mem_device);
>>  
>>  	return 0;
> 
> 
> 

