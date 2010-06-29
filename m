Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0F2HGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:06:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab0F2HGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:06:47 -0400
Message-ID: <4C299B7E.5020303@redhat.com>
Date: Tue, 29 Jun 2010 10:06:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com> <4C287332.5080803@cn.fujitsu.com> <4C2883D3.2050606@redhat.com> <4C2949A5.1070303@cn.fujitsu.com>
In-Reply-To: <4C2949A5.1070303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 04:17 AM, Xiao Guangrong wrote:
>
>> If B is writeable-and-dirty, then it's D bit is already set, and we
>> don't need to do anything.
>>
>> If B is writeable-and-clean, then we'll have an spte pointing to a
>> read-only sp, so we'll get a write fault on access and an opportunity to
>> set the D bit.
>>
>>      
> Sorry, a typo in my reply, i mean mapping A and B both are writable-and-clean,
> while A occurs write-#PF, we should change A's spte map to writable sp, if we
> only update the spte in writable-and-clean sp(form readonly to writable), the B's
> D bit will miss set.
>    

Right.

We need to update something to notice this:

  - FNAME(fetch)() to replace the spte
  - FNAME(walk_addr)() to invalidate the spte

I think FNAME(walk_addr) is the right place, we're updating the gpte, so 
we should update the spte at the same time, just like a guest write.  
But that will be expensive (there could be many sptes, so we have to 
call kvm_mmu_pte_write()), so perhaps FNAME(fetch) is easier.

We have now

         if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
             continue;

So we need to add a check, if sp->role.access doesn't match pt_access & 
pte_access, we need to get a new sp with the correct access (can only 
change read->write).

>>> Anyway, i think we should re-intall the mapping when the state is
>>> changed. :-(
>>>
>>>        
>> When the gpte is changed from read-only to writeable or from clean to
>> dirty, we need to update the spte, yes.  But that's true for other sptes
>> as well, not just large gptes.
>>
>>      
> I think the indirect sp is not hurt by this bug since for the indirect sp, the access
> just form its upper-level, and the D bit is only in the last level, when we change the
> pte's access, is not affect its sp's access.
>
> But for direct sp, the sp's access is form all level. and different mapping that not share
> the last mapping page will have the same last sp.
>    

Right.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

