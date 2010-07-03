Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0GCMUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 08:20:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56557 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab0GCMUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 08:20:08 -0400
Message-ID: <4C2F2A0C.90704@cn.fujitsu.com>
Date: Sat, 03 Jul 2010 20:16:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com>
In-Reply-To: <4C2F2835.5060508@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 07/03/2010 01:31 PM, Xiao Guangrong wrote:
>>
>>> See how the pte is reread inside fetch with mmu_lock held.
>>>
>>>      
>> It looks like something is broken in 'fetch' functions, this patch will
>> fix it.
>>
>> Subject: [PATCH] KVM: MMU: fix last level broken in FNAME(fetch)
>>
>> We read the guest level out of 'mmu_lock', sometimes, the host mapping is
>> confusion. Consider this case:
>>
>> VCPU0:                                              VCPU1
>>
>> Read guest mapping, assume the mapping is:
>> GLV3 ->  GLV2 ->  GLV1 ->  GFNA,
>> And in the host, the corresponding mapping is
>> HLV3 ->  HLV2 ->  HLV1(P=0)
>>
>>                                                     Write GLV1 and
>> cause the
>>                                                     mapping point to GFNB
>>                                                     (May occur in
>> pte_write or
>>                                                        invlpg path)
>>
>> Mapping GLV1 to GFNA
>>
>> This issue only occurs in the last indirect mapping, since if the middle
>> mapping is changed, the mapping will be zapped, then it will be detected
>> in the FNAME(fetch) path, but when it map the last level, it not checked.
>>
>> Fixed by also check the last level.
>>
>>    
> 
> I don't really see what is fixed.  We already check the gpte.  What's
> special about the new scenario?
> 

I mean is: while we map the last level, we will directly set to the pfn but
the pfn is got by walk_addr, at this time, the guest mapping may be changed.

What is the 'We already check the gpte' mean? i think i miss something :-(

