Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0DWMLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 08:11:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab0DWMLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 08:11:41 -0400
Message-ID: <4BD18E76.5000708@redhat.com>
Date: Fri, 23 Apr 2010 15:11:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/10] KVM MMU: fix for calculating gpa in invlpg code
References: <4BCFE3D5.5070105@cn.fujitsu.com> <4BCFE8C2.9080102@cn.fujitsu.com> <4BD18343.3050407@redhat.com> <4BD18CFD.4090102@cn.fujitsu.com>
In-Reply-To: <4BD18CFD.4090102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 03:05 PM, Xiao Guangrong wrote:
>
>
>>> @@ -478,9 +478,14 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu,
>>> gva_t gva)
>>>                ((level == PT_DIRECTORY_LEVEL&&   is_large_pte(*sptep))) ||
>>>                ((level == PT_PDPE_LEVEL&&   is_large_pte(*sptep)))) {
>>>                struct kvm_mmu_page *sp = page_header(__pa(sptep));
>>> +            int offset = 0;
>>> +
>>> +            if (PTTYPE == 32)
>>> +                offset = sp->role.quadrant<<   PT64_LEVEL_BITS;;
>>>
>>>        
>> Wrong for PT_DIRECTORY_LEVEL (should be q<<  8).  Also, too many
>> semicolons.
>>
>>      
> I guess you mean 'PT64_LEVEL_BITS' not 'PT_DIRECTORY_LEVEL' here :-)
>    

No, I mean if level == PT_DIRECTORY_LEVEL, then we want role.quadrant << 
8, not 9.

> It should be q<<  8 here? it hardly understand, take leve = 1 for example,
> 32-bit guest PTE page table mapping range is 2^(10+12), PAE's PTE page table
> mapping range is 2^(9+12),

For level == PT_DIRECTORY_LEVEL, quadrant is in the range 0..3.  Each sp 
maps 1GB, while the guest page table maps 4GB.  So the upper two bits 
become the quadrant.

>   so, i think it's quadrant<<  9 here, and other
> function like FNAME(prefetch_page), FNAME(sync_page) also are q<<  9
>    

They only work for PT_PAGE_TABLE_LEVEL, so for them 9 is correct.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

