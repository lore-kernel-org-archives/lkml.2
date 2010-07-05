Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab0GEJU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:20:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0GEJUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:20:52 -0400
Message-ID: <4C31A3F0.6070207@redhat.com>
Date: Mon, 05 Jul 2010 12:20:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com> <4C2F2A0C.90704@cn.fujitsu.com> <4C2F2C5B.9020503@redhat.com> <4C2F2DBB.50904@cn.fujitsu.com> <4C2F30BD.7050702@redhat.com> <4C2F31D9.5010104@redhat.com> <4C2F3527.3020307@cn.fujitsu.com> <4C309B23.9060808@redhat.com> <4C3148FF.3030209@cn.fujitsu.com> <4C319699.9000104@redhat.com> <4C319BBB.5020408@cn.fujitsu.com> <4C31A069.6090806@redhat.com> <4C31A13F.9030408@cn.fujitsu.com>
In-Reply-To: <4C31A13F.9030408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 12:09 PM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>
>    
>> I'm not convinced we can bypass the checks.  Consider:
>>
>>
>> VCPU0                 VCPU1
>>
>> #PF
>> walk_addr
>> ->  gpml4e0,gpdpe0,gpde0,gpte0
>>
>>                        replace gpdpe0 with gpdpe1
>>                        #PF
>>                        walk_addr
>> ->  gpml4e0,gpdpe1,gpde1,gpte1
>>                        fetch
>>                        ->  establish hpml4e0,hpdpte1,hpde0,hpte1
>> fetch
>> read hpdpe1
>> if (present(hpdpe1))
>>      continue;
>> ...
>> write hpte0 using shadow hieratchy for hpte1
>>
>>      
> Ah, i missed this case, thanks for you point it out, i'll fix it in
> the next version.
>    

Note: I think we have to check _after_ kvm_mmu_get_page(), otherwise we 
might be checking a page that is not write-protected and can change again.

So the logic needs to be something like

for_each_shadow_entry:
     if (!last_level && !present(*spte))
         kvm_mmu_get_page
     verify gpte
     if (last_level)
         mmu_set_spte()

-- 
error compiling committee.c: too many arguments to function

