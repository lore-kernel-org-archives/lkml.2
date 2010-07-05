Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0GEJFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:05:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab0GEJFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:05:50 -0400
Message-ID: <4C31A069.6090806@redhat.com>
Date: Mon, 05 Jul 2010 12:05:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com> <4C2F2A0C.90704@cn.fujitsu.com> <4C2F2C5B.9020503@redhat.com> <4C2F2DBB.50904@cn.fujitsu.com> <4C2F30BD.7050702@redhat.com> <4C2F31D9.5010104@redhat.com> <4C2F3527.3020307@cn.fujitsu.com> <4C309B23.9060808@redhat.com> <4C3148FF.3030209@cn.fujitsu.com> <4C319699.9000104@redhat.com> <4C319BBB.5020408@cn.fujitsu.com>
In-Reply-To: <4C319BBB.5020408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 11:45 AM, Xiao Guangrong wrote:
>
>
> Avi Kivity wrote:
>
>>> Looks into the code more carefully, maybe this code is wrong:
>>>
>>>
>>>                if (!direct) {
>>>                        r = kvm_read_guest_atomic(vcpu->kvm,
>>> -                                          gw->pte_gpa[level - 2],
>>> +                                          gw->pte_gpa[level - 1],
>>>                                         &curr_pte, sizeof(curr_pte));
>>> -                    if (r || curr_pte != gw->ptes[level - 2]) {
>>> +                    if (r || curr_pte != gw->ptes[level - 1]) {
>>>                                   kvm_mmu_put_page(sp, sptep);
>>>                                   kvm_release_pfn_clean(pfn);
>>>                                   sptep = NULL;
>>>
>>> It should check the 'level' mapping not 'level - 1', in the later
>>> description
>>> i'll explain it.
>>>
>>
>> Right, this fixes the check for the top level, but it removes a check
>> from the bottom level.
>>
>
> We no need check the bottom level if guest not modify the bottom level,
> if guest modify it, the bottom level is no-present,

Why?  VCPU1 will call kvm_mmu_pte_write (or invlpg) and establishes the 
HPTE.  Then VCPU0 calls mmu_set_pte() and writes the old GPTE.

> it also can broke
> Point A's judgment and be checked by 'Point C'

Well, the 'continue' in point A means we skip the check.  That's not good.

>> We need to move this to the top of the loop so we check all levels.  I
>> guess this is why you needed to add a new check point.  But since we
>> loop at least glevels times, we don't need two check points.
>>
>
>>
>> Ok.   So moving the check to before point A, and s/level - 2/level - 1/
>> should work, yes?
>>
>> Should be slightly simpler since we don't need to kvm_mmu_put_page(sp,
>> sptep) any more.
>
> Yeah, it can work, but check all levels is really unnecessary, if guest not
> modify the level, the check can be avoid.
>
> This is why i choose two check-point, one is behind Point A's judgment, this
> point checks the level which modified by guest, and another point is at mapping
> last level point, this check is alway need.

I'm not convinced we can bypass the checks.  Consider:


VCPU0                 VCPU1

#PF
walk_addr
-> gpml4e0,gpdpe0,gpde0,gpte0

                       replace gpdpe0 with gpdpe1
                       #PF
                       walk_addr
-> gpml4e0,gpdpe1,gpde1,gpte1
                       fetch
                       -> establish hpml4e0,hpdpte1,hpde0,hpte1
fetch
read hpdpe1
if (present(hpdpe1))
     continue;
...
write hpte0 using shadow hieratchy for hpte1

-- 
error compiling committee.c: too many arguments to function

