Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1EGChY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:37:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20209 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1EGChW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:37:22 -0400
Message-ID: <4DC4B059.3030502@kernel.org>
Date: Fri, 06 May 2011 19:37:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] pci: Check bridge resources after resource allocation.
References: <4DC250A6.9040802@kernel.org> <20110506081243.GF16782@ram-laptop> <4DC4586C.6020308@kernel.org> <20110507015240.GN16782@ram-laptop>
In-Reply-To: <20110507015240.GN16782@ram-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DC4B061.0017,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2011 06:52 PM, Ram Pai wrote:
> On Fri, May 06, 2011 at 01:22:04PM -0700, Yinghai Lu wrote:
>> On 05/06/2011 01:12 AM, Ram Pai wrote:
>>> On Thu, May 05, 2011 at 12:24:22AM -0700, Yinghai Lu wrote:
>>>>
>>>> During pci remove/rescan testing found:
>>>>
>>>> [  541.141614] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
>>>> [  541.141965] pci 0000:c0:03.0:   bridge window [io  0x1000-0x0fff]
>>>> [  541.159181] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
>>>> [  541.159540] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
>>>> [  541.179374] pci 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
>>>> [  541.199198] pci 0000:c0:03.0: Error enabling bridge (-22), continuing
>>>> [  541.199202] pci 0000:c0:03.0: enabling bus mastering
>>>> [  541.199209] pci 0000:c0:03.0: setting latency timer to 64
>>>> [  541.199917] pcieport 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
>>>> [  541.199963] pcieport: probe of 0000:c0:03.0 failed with error -22
>>>>
>>>> This bug was uncovered by commit
>>>> | commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
>>>> | Author: Ram Pai <linuxram@us.ibm.com>
>>>> | Date:   Mon Feb 14 17:43:20 2011 -0800
>>>> |
>>>> |    PCI: pre-allocate additional resources to devices only after successful allo
>>>> cation of essential resources.
>>>>
>>>> After that commit, pci_hotplug_io_size is changed to additional_io_size from minium size. So it will not get into failed list, and will not be reset there.
>>>>
>>>> The root cause is: pci_bridge_check_ranges will set RESOURCE_IO flag for pci
>>>> bridge, and later if children does not need to IO resource. those bridge
>>>> resources will not need to be allocated. but flags still there.
>>>>
>>>> Add pci_bridge_check_resources() to close the loop.
>>>
>>> How about resetting the resource in  adjust_resources_sorted() if  call to
>>> adjust_resource() fails, and the resource is left with zero size?
>>>
>>> Something like this:
>>>
>>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>>> index 8e73abf..77e8454 100644
>>> --- a/drivers/pci/setup-bus.c
>>> +++ b/drivers/pci/setup-bus.c
>>> @@ -157,8 +157,11 @@ static void adjust_resources_sorted(struct resource_list_x *add_head,
>>>                          if(pci_assign_resource(list->dev, idx))
>>>                                 reset_resource(res);
>>>                 } else if (add_size) {
>>> -                       adjust_resource(res, res->start,
>>> -                               resource_size(res) + add_size);
>>> +                       if (adjust_resource(res, res->start,
>>> +                               resource_size(res) + add_size) && 
>>> +                               !resource_size(res)) {
>>> +                               reset_resource(res);
>>> +                       }
>>>                 }
>>>  out:
>>>                 tmp = list;
>>>
>>>
>>
>> no, adjust_resource will not change resource size to zero.
> 
> Ok. There are four scenarios that adjust_resources_sorted() gets called, three
> of which are handled properly and one case is not handled at all.  I think you
> are running against the one that is not handled.
> 
> So here are the 4 scenarios:
> a. non-hotplug resource having children resources
> b. non-hotplug resource without children resources
> c. hotplug resource with children resources
> d. hotplug resource without children resources.
> 
> case (a):  resource is in head but not in add_list --
> 		adjust_resource_sorted() has nothing to do.
> 		Currently this case is handled properly.
> 
> case (b):  resource is not in head and not in add_list --
> 		adjust_resource_sorted() has nothing to do.
> 		Currently this case is handled properly.
> 
> case (c):  resource is in head and in add_list --
> 		adjust_resource_sorted() extends the size
> 		of the resource. And if it fails
> 		to do so, the failure is ignored. 
> 		Currently this case is handled properly.
> 	
> case (d):  resource is not in head but in add_list --
> 		adjust_resource_sorted()  is not handling this
> 		case properly. 
> 
> 		If the reason the resource is not in head is because its
> 		allocation failed, then it must be in the failed list. 
> 		Since it is in the failed list, adjust_resource_sorted() 
> 		has nothing to do.
> 
> 		However if the resource is not in the head because
> 		it had no child resources to begin with, then
> 		adjust_resource_sorted() has to increase the size
> 		of the resource, in order to satisfy
> 		any future hotplug requests. If it unable 
> 		to increase the size then it has to reset the 
> 		resource, which means reset its flags too.
> 
> 		We need code that handles this case, which should
> 		solve your problem.
> 
> 		Here is the code, I think, should take care of your problem.
> 		Let me know if it works.
> 
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 8e73abf..56ec6f7 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -118,19 +118,18 @@ static inline void reset_resource(struct resource *res)
>   *
>   * @add_head : head of the list tracking requests requiring additional
>   *             resources
> - * @head     : head of the list tracking requests with allocated
> - *             resources
> + * @fail_head: head of the list tracking requests with failed 
> + *             resource allocation
>   *
>   * Walk through each element of the add_head and try to procure
>   * additional resources for the element, provided the element
> - * is in the head list.
> + * is not in the failed list.
>   */
>  static void adjust_resources_sorted(struct resource_list_x *add_head,
> -		struct resource_list *head)
> +		struct resource_list_x *fail_head)
>  {
>  	struct resource *res;
> -	struct resource_list_x *list, *tmp, *prev;
> -	struct resource_list *hlist;
> +	struct resource_list_x *list, *tmp, *prev, *f_list;
>  	resource_size_t add_size;
>  	int idx;
>  
> @@ -141,10 +140,10 @@ static void adjust_resources_sorted(struct resource_list_x *add_head,
>  		if (!res->flags)
>  			goto out;

No, should not change to fail_head here.

if one resource is in fail_head, that means that it is get reset already.

so !res->flags will be meet and get out ...

Thanks

Yinghai

>  
> -		/* skip this resource if not found in head list */
> -		for (hlist = head->next; hlist && hlist->res != res;
> -				hlist = hlist->next);
> -		if (!hlist) { /* just skip */
> +		/* skip this resource if found in failed list */
> +		for (f_list = fail_head->next; f_list && f_list->res != res; 
> +				f_list = f_list->next);
> +		if (f_list) {
>  			prev = list;
>  			list = list->next;
>  			continue;
> @@ -212,7 +211,7 @@ static void __assign_resources_sorted(struct resource_list *head,
>  	/* Try to satisfy any additional nice-to-have resource
>  		requests */
>  	if (add_head)
> -		adjust_resources_sorted(add_head, head);
> +		adjust_resources_sorted(add_head, fail_head);
>  	free_list(resource_list, head);
>  }
>  
> 
> RP

