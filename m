Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0F2HjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:39:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab0F2Hi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:38:59 -0400
Message-ID: <4C29A30A.8020107@redhat.com>
Date: Tue, 29 Jun 2010 10:38:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com> <4C287332.5080803@cn.fujitsu.com> <4C2883D3.2050606@redhat.com> <4C2949A5.1070303@cn.fujitsu.com> <4C299B7E.5020303@redhat.com>
In-Reply-To: <4C299B7E.5020303@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 10:06 AM, Avi Kivity wrote:
> On 06/29/2010 04:17 AM, Xiao Guangrong wrote:
>>
>>> If B is writeable-and-dirty, then it's D bit is already set, and we
>>> don't need to do anything.
>>>
>>> If B is writeable-and-clean, then we'll have an spte pointing to a
>>> read-only sp, so we'll get a write fault on access and an 
>>> opportunity to
>>> set the D bit.
>>>
>> Sorry, a typo in my reply, i mean mapping A and B both are 
>> writable-and-clean,
>> while A occurs write-#PF, we should change A's spte map to writable 
>> sp, if we
>> only update the spte in writable-and-clean sp(form readonly to 
>> writable), the B's
>> D bit will miss set.
>
> Right.
>
> We need to update something to notice this:
>
>  - FNAME(fetch)() to replace the spte
>  - FNAME(walk_addr)() to invalidate the spte
>
> I think FNAME(walk_addr) is the right place, we're updating the gpte, 
> so we should update the spte at the same time, just like a guest 
> write.  But that will be expensive (there could be many sptes, so we 
> have to call kvm_mmu_pte_write()), so perhaps FNAME(fetch) is easier.
>
> We have now
>
>         if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
>             continue;
>
> So we need to add a check, if sp->role.access doesn't match pt_access 
> & pte_access, we need to get a new sp with the correct access (can 
> only change read->write).

Note:

- modifying walk_addr() to call kvm_mmu_pte_write() is probably not so 
bad.  It's rare that a large pte walk sets the dirty bit, and it's 
probably rare to share those large ptes.  Still, I think the fetch() 
change is better since it's more local.

- there was once talk that instead of folding pt_access and pte_access 
together into the leaf sp->role.access, each sp level would have its own 
access permissions.  In this case we don't even have to get a new direct 
sp, only change the PT_DIRECTORY_LEVEL spte to add write permissions 
(all direct sp's would be writeable and permissions would be controlled 
at their parent_pte level).  Of course that's a much bigger change than 
this bug fix.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

