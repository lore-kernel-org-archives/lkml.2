Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0GCMtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 08:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab0GCMtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 08:49:35 -0400
Message-ID: <4C2F31D9.5010104@redhat.com>
Date: Sat, 03 Jul 2010 15:49:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com> <4C2F2A0C.90704@cn.fujitsu.com> <4C2F2C5B.9020503@redhat.com> <4C2F2DBB.50904@cn.fujitsu.com> <4C2F30BD.7050702@redhat.com>
In-Reply-To: <4C2F30BD.7050702@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2010 03:44 PM, Avi Kivity wrote:
> On 07/03/2010 03:31 PM, Xiao Guangrong wrote:
>>
>> Avi Kivity wrote:
>>
>>>>
>>>          if (!direct) {
>>>              r = kvm_read_guest_atomic(vcpu->kvm,
>>>                            gw->pte_gpa[level - 2],
>>> &curr_pte, sizeof(curr_pte));
>>>              if (r || curr_pte != gw->ptes[level - 2]) {
>>>                  kvm_mmu_put_page(shadow_page, sptep);
>>>                  kvm_release_pfn_clean(pfn);
>>>                  sptep = NULL;
>>>                  break;
>>>              }
>>>          }
>>>
>>> the code you moved... under what scenario is it not sufficient?
>>>
>> I not move those code, just use common function instead, that it's
>> FNAME(check_level_mapping)(), there are do the same work.
>>
>> And this check is not sufficient, since it's only checked if the
>> mapping is zapped or not exist, for other words only when broken this
>> judgment:
>>     is_shadow_present_pte(*sptep)&&  !is_large_pte(*sptep)
>>
>> but if the middle level is present and it's not the large mapping,
>> this check is skipped.
>
>
> Well, in the description, it looked like everything was using small 
> pages (in kvm, level=1 means PTE level, we need to change this one 
> day).  Please describe again and say exactly when the guest or host 
> uses large pages.
>
>

Oh, I see what you mean.

Regarding the patch, is it possible just to move the check before, 
instead of adding the 'check' variable?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

