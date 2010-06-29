Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0F2Hjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:39:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57218 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab0F2Hjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:39:45 -0400
Message-ID: <4C29A25C.7040900@cn.fujitsu.com>
Date: Tue, 29 Jun 2010 15:35:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com> <4C287332.5080803@cn.fujitsu.com> <4C2883D3.2050606@redhat.com> <4C2949A5.1070303@cn.fujitsu.com> <4C299B7E.5020303@redhat.com>
In-Reply-To: <4C299B7E.5020303@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 06/29/2010 04:17 AM, Xiao Guangrong wrote:
>>
>>> If B is writeable-and-dirty, then it's D bit is already set, and we
>>> don't need to do anything.
>>>
>>> If B is writeable-and-clean, then we'll have an spte pointing to a
>>> read-only sp, so we'll get a write fault on access and an opportunity to
>>> set the D bit.
>>>
>>>      
>> Sorry, a typo in my reply, i mean mapping A and B both are
>> writable-and-clean,
>> while A occurs write-#PF, we should change A's spte map to writable
>> sp, if we
>> only update the spte in writable-and-clean sp(form readonly to
>> writable), the B's
>> D bit will miss set.
>>    
> 
> Right.
> 
> We need to update something to notice this:
> 
>  - FNAME(fetch)() to replace the spte
>  - FNAME(walk_addr)() to invalidate the spte
> 
> I think FNAME(walk_addr) is the right place, we're updating the gpte, so
> we should update the spte at the same time, just like a guest write. 
> But that will be expensive (there could be many sptes, so we have to
> call kvm_mmu_pte_write()), so perhaps FNAME(fetch) is easier.
> 

I agree.

> We have now
> 
>         if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
>             continue;
> 
> So we need to add a check, if sp->role.access doesn't match pt_access &
> pte_access, we need to get a new sp with the correct access (can only
> change read->write).
> 

Umm, we should update the spte at the gw->level, so we need get the child
sp, and compare its access at this point, just like this:

if (level == gw->level && is_shadow_present_pte(*sptep)) {
	child_sp = page_header(__pa(*sptep & PT64_BASE_ADDR_MASK));

	if (child_sp->access != pt_access & pte_access & (diry ? 1 : ~ACC_WRITE_MASK )) {
		/* Zap sptep */
		......
	}
		
}

So, why not use the new spte flag (SPTE_NO_DIRTY in my patch) to mark this spte then we can see
this spte whether need updated directly? i think it more simpler ;-)
