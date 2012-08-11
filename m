Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2HKDM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 23:12:58 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:32776 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2HKDMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 23:12:35 -0400
Message-ID: <5025CD77.2030100@linux.vnet.ibm.com>
Date: Sat, 11 Aug 2012 11:11:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 05/12] KVM: reorganize hva_to_pfn
References: <5020E423.9080004@linux.vnet.ibm.com> <5020E509.8070901@linux.vnet.ibm.com> <20120810175115.GA12477@amt.cnet>
In-Reply-To: <20120810175115.GA12477@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081103-2000-0000-0000-000008AC5BDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2012 01:51 AM, Marcelo Tosatti wrote:
> On Tue, Aug 07, 2012 at 05:51:05PM +0800, Xiao Guangrong wrote:
>> We do too many things in hva_to_pfn, this patch reorganize the code,
>> let it be better readable
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  virt/kvm/kvm_main.c |  159 +++++++++++++++++++++++++++++++--------------------
>>  1 files changed, 97 insertions(+), 62 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 26ffc87..dd01bcb 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1043,83 +1043,118 @@ static inline int check_user_page_hwpoison(unsigned long addr)
>>  	return rc == -EHWPOISON;
>>  }
>>
>> -static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
>> -			bool write_fault, bool *writable)
>> +/*
>> + * The atomic path to get the writable pfn which will be stored in @pfn,
>> + * true indicates success, otherwise false is returned.
>> + */
>> +static bool hva_to_pfn_fast(unsigned long addr, bool atomic, bool *async,
>> +			    bool write_fault, bool *writable, pfn_t *pfn)
>>  {
>>  	struct page *page[1];
>> -	int npages = 0;
>> -	pfn_t pfn;
>> +	int npages;
>>
>> -	/* we can do it either atomically or asynchronously, not both */
>> -	BUG_ON(atomic && async);
>> +	if (!(async || atomic))
>> +		return false;
>>
>> -	BUG_ON(!write_fault && !writable);
>> +	npages = __get_user_pages_fast(addr, 1, 1, page);
>> +	if (npages == 1) {
>> +		*pfn = page_to_pfn(page[0]);
>>
>> -	if (writable)
>> -		*writable = true;
>> +		if (writable)
>> +			*writable = true;
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>>
>> -	if (atomic || async)
>> -		npages = __get_user_pages_fast(addr, 1, 1, page);
>> +/*
>> + * The slow path to get the pfn of the specified host virtual address,
>> + * 1 indicates success, -errno is returned if error is detected.
>> + */
>> +static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
>> +			   bool *writable, pfn_t *pfn)
>> +{
>> +	struct page *page[1];
>> +	int npages = 0;
>>
>> -	if (unlikely(npages != 1) && !atomic) {
>> -		might_sleep();
>> +	might_sleep();
>>
>> -		if (writable)
>> -			*writable = write_fault;
>> -
>> -		if (async) {
>> -			down_read(&current->mm->mmap_sem);
>> -			npages = get_user_page_nowait(current, current->mm,
>> -						     addr, write_fault, page);
>> -			up_read(&current->mm->mmap_sem);
>> -		} else
>> -			npages = get_user_pages_fast(addr, 1, write_fault,
>> -						     page);
>> -
>> -		/* map read fault as writable if possible */
>> -		if (unlikely(!write_fault) && npages == 1) {
>> -			struct page *wpage[1];
>> -
>> -			npages = __get_user_pages_fast(addr, 1, 1, wpage);
>> -			if (npages == 1) {
>> -				*writable = true;
>> -				put_page(page[0]);
>> -				page[0] = wpage[0];
>> -			}
>> -			npages = 1;
>> +	if (writable)
>> +		*writable = write_fault;
>> +
>> +	if (async) {
>> +		down_read(&current->mm->mmap_sem);
>> +		npages = get_user_page_nowait(current, current->mm,
>> +					      addr, write_fault, page);
>> +		up_read(&current->mm->mmap_sem);
>> +	} else
>> +		npages = get_user_pages_fast(addr, 1, write_fault,
>> +					     page);
>> +	if (npages != 1)
>> +		return npages;
> 
>  * Returns number of pages pinned. This may be fewer than the number
>  * requested. If nr_pages is 0 or negative, returns 0. If no pages
>  * were pinned, returns -errno.
>  */
> int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>                         struct page **pages)
> 
> 
> Current behaviour is
> 
>         if (atomic || async)
>                 npages = __get_user_pages_fast(addr, 1, 1, page);
> 
> 	if (npages != 1) 
> 		slow path retry;
> 
> The changes above change this, don't they?

Marcelo,

Sorry, I do not know why you thought the logic was changed, in this patch,
the logic is:

	/* return true if it is successful. */
        if (hva_to_pfn_fast(addr, atomic, async, write_fault, writable, &pfn))
                return pfn;

	/* atomic can not go to slow path. */
        if (atomic)
                return KVM_PFN_ERR_FAULT;

	/* get pfn by the slow path */
        npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
        if (npages == 1)
                return pfn;

	/* the error-handle path. */
	......


Did i miss something?


