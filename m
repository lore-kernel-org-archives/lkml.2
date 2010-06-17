Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab0FQIAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:00:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711Ab0FQIAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:00:47 -0400
Message-ID: <4C19D624.5040901@redhat.com>
Date: Thu, 17 Jun 2010 11:00:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] KVM: MMU: support pte prefetch when intercepted guest
 #PF
References: <4C16E974.8000304@cn.fujitsu.com> <4C1767C4.7020506@redhat.com> <4C19D36C.30007@cn.fujitsu.com>
In-Reply-To: <4C19D36C.30007@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 10:49 AM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>    
>> On 06/15/2010 05:46 AM, Xiao Guangrong wrote:
>>      
>>> Hi Avi, Marcelo,
>>>
>>> This patchset support pte prefetch when intercepted guest #PF,
>>> the aim is to reduce guest #PF which can be intercepted by VMM.
>>>
>>> If we meet any failure in the prefetch path, we will exit it
>>> and not try other ptes to avoid become heavy path.
>>>
>>> During my performance test, under EPT enabled case, unixbench
>>> shows the performance improved ~1.2%,
>>>        
>> Once the guest has faulted in all memory, we shouldn't see much
>> improvement, yes?
>>      
> I think you are right, this path only prefetch valid/pte.A=1 mapping.
>    

I mean for tdp.  Faulting is rare once the guest has touched all of memory.

>>> user EPT disable case,
>>> unixbench shows the performance improved ~3.6%
>>>
>>>        
>> I'm a little worried about this.  In some workloads, prefetch can often
>> fail due to gpte.a=0 so we spend effort doing nothing.
>>      
> Yes, prefetch is not alway success, but the prefetch path is fast, it not cost
> much time, at the worst case, only 128 bytes we need read form guest pte. Once
> it's successful, much overload can be reduce.
>    

Ok.

>> We should map those pages with pte.a=pte.d=0 so we don't confuse host
>> memory management.  On EPT (which lacks a/d bits) we can't enable it
>> (but we can on NPT).
>>
>>      
> You are right, this is the speculative path.
>
> For the pte.A bit:
> we called mmu_set_spte() with speculative = true, so we set pte.a = 0 in this
> path.
>
> For the pte.D bit:
> We should fix also set pte.d = 0 in speculative path, the same problem is in
> invlpg/pte write path, will do it in the next version.
>    

It's not enough to set spte.d=0, we also need to sample it later.


-- 
error compiling committee.c: too many arguments to function

