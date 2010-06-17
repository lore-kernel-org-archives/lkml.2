Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab0FQHwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:52:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54259 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab0FQHwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:52:35 -0400
Message-ID: <4C19D36C.30007@cn.fujitsu.com>
Date: Thu, 17 Jun 2010 15:49:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] KVM: MMU: support pte prefetch when intercepted guest
 #PF
References: <4C16E974.8000304@cn.fujitsu.com> <4C1767C4.7020506@redhat.com>
In-Reply-To: <4C1767C4.7020506@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 06/15/2010 05:46 AM, Xiao Guangrong wrote:
>> Hi Avi, Marcelo,
>>
>> This patchset support pte prefetch when intercepted guest #PF,
>> the aim is to reduce guest #PF which can be intercepted by VMM.
>>
>> If we meet any failure in the prefetch path, we will exit it
>> and not try other ptes to avoid become heavy path.
>>
>> During my performance test, under EPT enabled case, unixbench
>> shows the performance improved ~1.2%,
> 
> Once the guest has faulted in all memory, we shouldn't see much
> improvement, yes?

I think you are right, this path only prefetch valid/pte.A=1 mapping.

> 
>> user EPT disable case,
>> unixbench shows the performance improved ~3.6%
>>    
> 
> I'm a little worried about this.  In some workloads, prefetch can often
> fail due to gpte.a=0 so we spend effort doing nothing.  

Yes, prefetch is not alway success, but the prefetch path is fast, it not cost
much time, at the worst case, only 128 bytes we need read form guest pte. Once
it's successful, much overload can be reduce.

> There is also
> the issue of marking pages as accessed or even dirty when in fact the
> guest did not access them.

> 
> We should map those pages with pte.a=pte.d=0 so we don't confuse host
> memory management.  On EPT (which lacks a/d bits) we can't enable it
> (but we can on NPT).
>

You are right, this is the speculative path.

For the pte.A bit:
we called mmu_set_spte() with speculative = true, so we set pte.a = 0 in this
path.

For the pte.D bit:
We should fix also set pte.d = 0 in speculative path, the same problem is in
invlpg/pte write path, will do it in the next version.


