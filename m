Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0FQGth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:49:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51343 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0FQGtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:49:36 -0400
Message-ID: <4C19C4A9.7080607@cn.fujitsu.com>
Date: Thu, 17 Jun 2010 14:46:01 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 3/6] KVM: MMU: introduce gfn_to_page_atomic() and gfn_to_pfn_atomic()
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E999.6050004@cn.fujitsu.com> <4C17625E.3020308@redhat.com>
In-Reply-To: <4C17625E.3020308@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 06/15/2010 05:46 AM, Xiao Guangrong wrote:
>> Introduce gfn_to_page_atomic() and gfn_to_pfn_atomic(), those
>> functions is fast path and can used in atomic context, the later
>> patch will use those
>>
>>
>> @@ -942,6 +942,41 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
>>   }
>>   EXPORT_SYMBOL_GPL(gfn_to_hva);
>>
>> +static pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr)
>> +{
>> +    struct page *page[1];
>> +    int npages;
>> +    pfn_t pfn;
>> +
>> +    npages = __get_user_pages_fast(addr, 1, 1, page);
>> +
>> +    if (unlikely(npages != 1)) {
>> +        if (is_hwpoison_address(addr)) {
>> +            get_page(hwpoison_page);
>> +            return page_to_pfn(hwpoison_page);
>> +        }
>> +        get_page(bad_page);
>> +        return page_to_pfn(bad_page);
>> +    } else
>> +        pfn = page_to_pfn(page[0]);
>> +
>> +    return pfn;
>> +}
>>    
> 
> Too much duplication.  How about putting the tail end of the function in
> a common helper (with an inatomic flag)?
> 

OK, will cleanup it in the next version.
