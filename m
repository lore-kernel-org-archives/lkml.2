Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab1FWRxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:53:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59008 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933678Ab1FWRxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:53:45 -0400
Message-ID: <4E037E21.6010203@cn.fujitsu.com>
Date: Fri, 24 Jun 2011 01:55:45 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 21/22] KVM: MMU: mmio page fault support
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FDE0.5080800@cn.fujitsu.com> <20110622215940.GA30064@amt.cnet> <4E02B0BE.7070003@cn.fujitsu.com> <20110623142134.GA12181@amt.cnet>
In-Reply-To: <20110623142134.GA12181@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-24 01:53:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-24 01:53:18,
	Serialize complete at 2011-06-24 01:53:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 10:21 PM, Marcelo Tosatti wrote:

>>> An spte does not have to contain the present bit to generate a valid EPT
>>> misconfiguration (and an spte dump is still required in that case).
>>> Use !is_mmio_spte() instead.
>>>
>>
>> We can not use !is_mmio_spte() here, since the shadow page can be zapped anytime,
>> for example:
>>
>> sp.spt[i] = mmio-spte
>>
>>           VCPU 0                                    VCPU 1    
>> Access sp.spte[i], ept misconfig is occurred
>>                                                    delete sp
>>                                    (if the number of shadow page is out of the limit
>>                                     or page shrink is required, and other events...)
>>
>> Walk shadow page out of the lock and get the
>> non-present spte
>> (*the point we are discussing*)
> 
> Then is_mmio_spte(non-present spte) == false, right? Point is that it
> only sptes with precise mmio spte pattern should be considered mmio
> sptes, otherwise consider a genuine EPT misconfiguration error (which
> must be reported).
> 

No, not all no mmio spte is considered a genuine EPT misconfig, as the above
case, we can get !is_mmio_spte(), but it is not the genuine EPT misconfig
since it is caused by shadow page zapped
 
> What about using fault code instead of spte as Avi suggested instead?
> 

Do you mean waking guest page table to get mmio gva/mmio gpa for softmmu instead
of walking shadow page table?

I think it is unsafe, since guest can change the mapping anytime, we can get the
wrong mmio gva/mmio gpa to mmio emulate, consider follow case:

gva is mapped to the mmio region, we set the reserved bits in the spte:

VCPU 0                                               VCPU 1
Access gva, reserved page fault is occurred
                                             map gva to the RAM region
Walking guest page table and get the RAM gpa           TLB flush
(*the point we are discussing*)

Then we can get the wrong gpa to mmio emulate, so
- VMM can detected the invalid mmio access
- the event is missed, it neither accesses the mmio region nor the RAM region,
  it is not as the real cpu does

Anyway, mmio spte is needed to detect bugs for hard mmu

>> So, the bug we can detect is: it is the mmio access but the spte is point to the normal
>> page.
>>
>>>
>>>> +
>>>> +	/*
>>>> +	 * If the page table is zapped by other cpus, let the page
>>>> +	 * fault path to fix it.
>>>> +	 */
>>>> +	return 0;
>>>> +}
>>>
>>> I don't understand when would this happen, can you please explain?
>>>
>>
>> The case is above :-)
> 
> No need to jump to page fault handler, can let CPU fault again on non
> present spte.
> 

It is a good idea, will do, thanks!
> 

