Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab2E1MYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:24:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab2E1MYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:24:41 -0400
Message-ID: <4FC36E85.4010909@redhat.com>
Date: Mon, 28 May 2012 15:24:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
References: <4FC316E3.6080607@linux.vnet.ibm.com> <4FC35A15.6080000@redhat.com> <4FC363EE.6060204@linux.vnet.ibm.com>
In-Reply-To: <4FC363EE.6060204@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 02:39 PM, Xiao Guangrong wrote:
> On 05/28/2012 06:57 PM, Avi Kivity wrote:
> 
>> On 05/28/2012 09:10 AM, Xiao Guangrong wrote:
>>> The huge page size is 4M on non-PAE host, but 2M page size is used in
>>> transparent_hugepage_adjust(), so the page we get after adjust the
>>> mapping level is not the head page, the BUG_ON() will be triggered
>>>
>>>
>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>> index 72102e0..be3cea4 100644
>>> --- a/arch/x86/kvm/mmu.c
>>> +++ b/arch/x86/kvm/mmu.c
>>> @@ -2595,8 +2595,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>>>  			*gfnp = gfn;
>>>  			kvm_release_pfn_clean(pfn);
>>>  			pfn &= ~mask;
>>> -			if (!get_page_unless_zero(pfn_to_page(pfn)))
>>> -				BUG();
>>> +			kvm_get_pfn(pfn);
>>>  			*pfnp = pfn;
>>>  		}
>>>  	}
>> 
>> Shouldn't we adjust mask instead?
>> 
> 
> 
> Adjusting mask to map the whole 4M huge page to KVM guest?

The code moves the refcount from the small page to the huge page.  i.e.
from pfn 0x1312 to pfn 0x1200.  But if the huge page frame contains
0x400 pages, it should move the refcount to pfn 0x1000.

> But it seams 4M page size is not supported on VMX/SVM.

We always use 64-bit PTEs in the lowest level, whether using shadow,
EPT, or NPT.  Note NPT supports 32-bit PTEs in the lowest level, but we
don't support that configuration.  But that doesn't mean we can't use
host 4M pages to back guest 2M pages (or direct maps).

-- 
error compiling committee.c: too many arguments to function
