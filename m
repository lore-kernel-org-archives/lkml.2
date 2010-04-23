Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0DWMI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 08:08:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49263 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab0DWMI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 08:08:26 -0400
Message-ID: <4BD18CFD.4090102@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 20:05:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/10] KVM MMU: fix for calculating gpa in invlpg code
References: <4BCFE3D5.5070105@cn.fujitsu.com> <4BCFE8C2.9080102@cn.fujitsu.com> <4BD18343.3050407@redhat.com>
In-Reply-To: <4BD18343.3050407@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 04/22/2010 09:12 AM, Xiao Guangrong wrote:
>> If the guest is 32-bit, we should use 'quadrant' to adjust gpa
>> offset
>>
>>    
> 
> Good catch.  Only affects kvm_mmu_pte_write(), so I don't think this had
> ill effects other than not prefetching the correct address?
> 

Yes

>> @@ -478,9 +478,14 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu,
>> gva_t gva)
>>               ((level == PT_DIRECTORY_LEVEL&&  is_large_pte(*sptep))) ||
>>               ((level == PT_PDPE_LEVEL&&  is_large_pte(*sptep)))) {
>>               struct kvm_mmu_page *sp = page_header(__pa(sptep));
>> +            int offset = 0;
>> +
>> +            if (PTTYPE == 32)
>> +                offset = sp->role.quadrant<<  PT64_LEVEL_BITS;;
>>    
> 
> Wrong for PT_DIRECTORY_LEVEL (should be q << 8).  Also, too many
> semicolons.
> 

I guess you mean 'PT64_LEVEL_BITS' not 'PT_DIRECTORY_LEVEL' here :-)

It should be q << 8 here? it hardly understand, take leve = 1 for example,
32-bit guest PTE page table mapping range is 2^(10+12), PAE's PTE page table
mapping range is 2^(9+12), so, i think it's quadrant << 9 here, and other
function like FNAME(prefetch_page), FNAME(sync_page) also are q << 9

Sorry for the double semicolons here, will fix it

Thanks,
Xiao
