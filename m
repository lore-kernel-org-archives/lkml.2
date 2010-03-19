Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0CSVYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:24:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:58391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0CSVYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:24:34 -0400
Message-ID: <4BA3E9CD.70203@kernel.org>
Date: Fri, 19 Mar 2010 14:17:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tejun Heo <tj@kernel.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LKML] Re: Infinite loop on boot in free_early_partial due to
 start==end on tip/master
References: <1267801390.11737.38014.camel@zakaz.uk.xensource.com> <20100319182807.GA14985@phenom.dumpdata.com> <4BA3CAB8.7000702@kernel.org> <1269027289.23584.0.camel@localhost.localdomain> <20100319200409.GE31908@phenom.dumpdata.com>
In-Reply-To: <20100319200409.GE31908@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 01:04 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Mar 19, 2010 at 07:34:49PM +0000, Ian Campbell wrote:
>> On Fri, 2010-03-19 at 19:04 +0000, Yinghai Lu wrote: 
>>> On 03/19/2010 11:28 AM, Konrad Rzeszutek Wilk wrote:
>>>>> Subject: x86: do not free zero sized per cpu areas
>>>>>
>>>>> This avoids an infinite loop in free_early_partial().
>>>>
>>>> The patch fixed PV guests booting on Xen. I've added my
>>>> Tested-by .. Please merge it in the release.
>>>>
>>>> Thanks!
>>>>>
>>>>> Add a warning to free_early_partial to catch future problems.
>>>>>
>>>>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>>>>
>>>> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>
>>> please check update version...
>>>
>>> please check if this patch help...
>>>
>>> http://patchwork.kernel.org/patch/83832/
>>
>> Sorry Konrad, looks like I directed you to an older version of the patch
>> by mistake.
> 
> Np. I tested this one and it worked succesfully.
> 
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> index ef6370b..89a3205 100644
> --- a/arch/x86/kernel/setup_percpu.c
> +++ b/arch/x86/kernel/setup_percpu.c
> @@ -140,7 +140,8 @@  static void __init pcpu_fc_free(void *ptr, size_t
> size)
>  #ifdef CONFIG_NO_BOOTMEM
>  	u64 start = __pa(ptr);
>  	u64 end = start + size;
> -	free_early_partial(start, end);
> +	if (start < end)
> +		free_early_partial(start, end);

it seems we could remove this line

Tejun, how this could happen? free zero range ?

YH

>  #else
>  	free_bootmem(__pa(ptr), size);
>  #endif
> diff --git a/kernel/early_res.c b/kernel/early_res.c
> index 3cb2c66..f3a861b 100644
> --- a/kernel/early_res.c
> +++ b/kernel/early_res.c
> @@ -333,6 +333,11 @@  void __init free_early_partial(u64 start, u64 end)
>  	struct early_res *r;
>  	int i;
>  
> +	if (WARN_ONCE(start >= end,
> +		      "free_early_partial got wrong start/end
> %#llx/%#llx\n",
> +		      start, end))
> +		return;
> +
>  try_next:
>  	i = find_overlapped_early(start, end);
>  	if (i >= max_early_res)
> 
