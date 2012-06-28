Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2F1B5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:57:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12216 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab2F1B5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:57:00 -0400
X-IronPort-AV: E=Sophos;i="4.77,488,1336320000"; 
   d="scan'208";a="5279184"
Message-ID: <4FEBBAF6.60409@cn.fujitsu.com>
Date: Thu, 28 Jun 2012 10:01:26 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 4/8] donot allow to eject the memory device if it is being
 used
References: <4FE97DD5.6030205@cn.fujitsu.com> <4FE97EEC.6060008@cn.fujitsu.com> <alpine.DEB.2.00.1206262118070.24245@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206262118070.24245@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/28 09:57:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/28 09:57:09,
	Serialize complete at 2012/06/28 09:57:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 06/27/2012 12:21 PM, David Rientjes Wrote:
> On Tue, 26 Jun 2012, Wen Congyang wrote:
> 
>> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
>> index a325bb9..2e5d5ab 100644
>> --- a/drivers/acpi/acpi_memhotplug.c
>> +++ b/drivers/acpi/acpi_memhotplug.c
>> @@ -78,6 +78,7 @@ struct acpi_memory_info {
>>  	unsigned short caching;	/* memory cache attribute */
>>  	unsigned short write_protect;	/* memory read/write attribute */
>>  	unsigned int enabled:1;
>> +	unsigned int failed:1;
>>  };
>>  
>>  struct acpi_memory_device {
>> @@ -251,9 +252,19 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>>  			node = memory_add_physaddr_to_nid(info->start_addr);
>>  
>>  		result = add_memory(node, info->start_addr, info->length);
>> -		if (result)
>> +
>> +		/*
>> +		 * If the memory block has been used by the kernel, add_memory()
>> +		 * returns -EEXIST. If add_memory() returns the other error, it
>> +		 * means that this memory block is not used by the kernel.
>> +		 */
>> +		if (result && result != -EEXIST) {
>> +			info->failed = 1;
>>  			continue;
>> -		info->enabled = 1;
>> +		}
>> +
>> +		if (!result)
>> +			info->enabled = 1;
>>  		num_enabled++;
>>  	}
>>  	if (!num_enabled) {
> 
> num_enabled should only be incremented for result == 0.
> 

If num_enabled is not incremented for result == -EEXIST, this device is not
managed by this module, and it is not able to be hot removed. Another problem
is the user will see a strange message: add_memory failed

Thanks
Wen Congyang
