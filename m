Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2IJJLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:11:08 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37714 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2IJJLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:11:04 -0400
Message-ID: <504DAE9F.5090807@linux.vnet.ibm.com>
Date: Mon, 10 Sep 2012 17:10:55 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: MMU: release noslot pfn on the fail path properly
References: <5049908A.7070501@linux.vnet.ibm.com> <504DA343.9080602@redhat.com> <504DA6D6.5030704@linux.vnet.ibm.com> <504DACA9.4030301@redhat.com>
In-Reply-To: <504DACA9.4030301@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091009-9574-0000-0000-00000457A2A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 05:02 PM, Avi Kivity wrote:
> On 09/10/2012 11:37 AM, Xiao Guangrong wrote:
>> On 09/10/2012 04:22 PM, Avi Kivity wrote:
>>> On 09/07/2012 09:13 AM, Xiao Guangrong wrote:
>>>> We can not directly call kvm_release_pfn_clean to release the pfn
>>>> since we can meet noslot pfn which is used to cache mmio info into
>>>> spte
>>>>
>>>> Introduce mmu_release_pfn_clean to do this kind of thing
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>> ---
>>>>  arch/x86/kvm/mmu.c         |   19 ++++++++++++++-----
>>>>  arch/x86/kvm/paging_tmpl.h |    4 ++--
>>>>  2 files changed, 16 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>>> index 399c177..3c10bca 100644
>>>> --- a/arch/x86/kvm/mmu.c
>>>> +++ b/arch/x86/kvm/mmu.c
>>>> @@ -2432,6 +2432,16 @@ done:
>>>>  	return ret;
>>>>  }
>>>>
>>>> +/*
>>>> + * The primary user is page fault path which call it to properly
>>>> + * release noslot_pfn.
>>>> + */
>>>> +static void mmu_release_pfn_clean(pfn_t pfn)
>>>> +{
>>>> +	if (!is_error_pfn(pfn))
>>>> +		kvm_release_pfn_clean(pfn);
>>>> +}
>>>> +
>>>
>>> Too many APIs, each slightly different.  How do I know which one to call?
>>
>> It is only used in mmu and it is a static function.
> 
> Still, how do I know which one to call?  The name tells me nothing.
> When I read the code, how do I know if a call is correct or not?
> 
>>
>>>
>>> Please change kvm_release_pfn_*() instead, calling some arch hook (or
>>> even #ifdef CONFIG_KVM_HAS_FAST_MMIO) to check for the special case.
>>
>> We only need to call it on page fault path. If we change the common API
>> other x86 components have to suffer from it.
> 
> This way, I have to suffer from it.

Sorry. :(

> 
> btw, what about another approach, to avoid those paths completely?
> Avoid calling __direct_map() with error_pfn, and jump to a label after
> kvm_release_pfn_clean() in page_fault(), etc?

I will try it.


