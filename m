Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030816Ab2GMG06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:26:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887Ab2GMG05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:26:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFFBFA3.8040203@jp.fujitsu.com>
Date: Fri, 13 Jul 2012 15:26:43 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lenb@kernel.org>, <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/3] acpi : cpu hot-remove returns error when cpu_down()
 fails
References: <4FFEB35A.6030500@jp.fujitsu.com> <1342111687.8472.16.camel@misato.fc.hp.com>
In-Reply-To: <1342111687.8472.16.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

2012/07/13 1:48, Toshi Kani wrote:
> On Thu, 2012-07-12 at 20:22 +0900, Yasuaki Ishimatsu wrote:
>> Even if cpu_down() fails, acpi_processor_remove() continues to remove the cpu.
>> But in this case, it should return error number since some process may run on
>> the cpu. If the cpu has a running process and the cpu is turned the power off,
>> the system may not work well.
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> ---
>>   drivers/acpi/processor_driver.c |   18 ++++++++++++------
>>   1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> Index: linux-3.5-rc4/drivers/acpi/processor_driver.c
>> ===================================================================
>> --- linux-3.5-rc4.orig/drivers/acpi/processor_driver.c	2012-06-25 04:53:04.000000000 +0900
>> +++ linux-3.5-rc4/drivers/acpi/processor_driver.c	2012-07-05 21:02:58.711285382 +0900
>> @@ -610,7 +610,7 @@ err_free_pr:
>>   static int acpi_processor_remove(struct acpi_device *device, int type)
>>   {
>>   	struct acpi_processor *pr = NULL;
>> -
>> +	int ret;
>>
>>   	if (!device || !acpi_driver_data(device))
>>   		return -EINVAL;
>> @@ -621,8 +621,9 @@ static int acpi_processor_remove(struct
>>   		goto free;
>>
>>   	if (type == ACPI_BUS_REMOVAL_EJECT) {
>> -		if (acpi_processor_handle_eject(pr))
>> -			return -EINVAL;
>> +		ret = acpi_processor_handle_eject(pr);
>> +		if (ret)
>> +			return ret;
>>   	}
>>
>>   	acpi_processor_power_exit(pr, device);
>> @@ -841,12 +842,17 @@ static acpi_status acpi_processor_hotadd
>>
>>   static int acpi_processor_handle_eject(struct acpi_processor *pr)
>>   {
>> -	if (cpu_online(pr->id))
>> -		cpu_down(pr->id);
>> +	int ret;
>> +
>> +	if (cpu_online(pr->id)) {
>> +		ret = cpu_down(pr->id);
>> +		if (ret)
>> +			return ret;
>> +	}
>>
>>   	arch_unregister_cpu(pr->id);
>>   	acpi_unmap_lsapic(pr->id);
>> -	return (0);
>> +	return ret;
>
> ret is uninitialized when !cpu_online().

Oops! I'll update it.

Thanks,
Yasuaki Ishimatsu

> Thanks,
> -Toshi
>
>>   }
>>   #else
>>   static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



