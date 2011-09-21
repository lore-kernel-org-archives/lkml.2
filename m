Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1IUFtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:49:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54852 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1IUFts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:49:48 -0400
Message-ID: <4E797B55.20102@cn.fujitsu.com>
Date: Wed, 21 Sep 2011 13:51:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH x86,mm]  fix pgt_buf_end when memory hotplug
References: <4E688C03.7080608@cn.fujitsu.com> <alpine.DEB.2.00.1109081616450.12963@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1109081616450.12963@kaball-desktop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-21 13:48:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-21 13:48:22,
	Serialize complete at 2011-09-21 13:48:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2011 11:21 PM, Stefano Stabellini wrote:
> On Thu, 8 Sep 2011, Lai Jiangshan wrote:
>>
>> When I test memory hotplug, such message is always outputted when hot-adding
>> a memory block:
>>
>> initial kernel pagetable allocation wasted ffffffffffffffff pages
> 
> I take you are using tip/x86/mm, because that is the only branch that
> contains that warning.

No,
I was using tip/master.

Thanks,
Lai

> 
> 
>> This message comes from init_memory_mapping(), it shows "pgt_buf_end" is
>> incorrect here, and I found it was caused by alloc_low_page().
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index bbaaa00..e138e0a 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -317,7 +317,7 @@ void __init cleanup_highmap(void)
>>  
>>  static __ref void *alloc_low_page(unsigned long *phys)
>>  {
>> -	unsigned long pfn = pgt_buf_end++;
>> +	unsigned long pfn;
>>  	void *adr;
>>  
>>  	if (after_bootmem) {
>> @@ -327,6 +327,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
>>  		return adr;
>>  	}
>>  
>> +	pfn = pgt_buf_end++;
>>  	if (pfn >= pgt_buf_top)
>>  		panic("alloc_low_page: ran out of memory");
> 
> 
> This patch makes sense to me. It would also make sense to print the
> "allocation wasted" warning only if (!after_bootmem).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

