Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2DDEnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 00:43:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59166 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2DDEnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 00:43:31 -0400
Message-ID: <4F7BD16F.2010903@openvz.org>
Date: Wed, 04 Apr 2012 08:43:27 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Konstantin Khlebnikov <koct9i@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Pallipadi Venkatesh <venki@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [x86 PAT PATCH 1/2] x86, pat: remove the dependency on 'vm_pgoff'
 in track/untrack pfn vma routines
References: <20120331170947.7773.46399.stgit@zurg>  <1333413969-30761-1-git-send-email-suresh.b.siddha@intel.com>  <1333413969-30761-2-git-send-email-suresh.b.siddha@intel.com>  <4F7A8C94.3040708@openvz.org> <1333495881.12400.19.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1333495881.12400.19.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Tue, 2012-04-03 at 09:37 +0400, Konstantin Khlebnikov wrote:
>> Suresh Siddha wrote:
>>> 'pfn' argument for track_pfn_vma_new() can be used for reserving the attribute
>>> for the pfn range. No need to depend on 'vm_pgoff'
>>>
>>> Similarly, untrack_pfn_vma() can depend on the 'pfn' argument if it
>>> is non-zero or can use follow_phys() to get the starting value of the pfn
>>> range.
>>>
>>> Also the non zero 'size' argument can be used instead of recomputing
>>> it from vma.
>>>
>>> This cleanup also prepares the ground for the track/untrack pfn vma routines
>>> to take over the ownership of setting PAT specific vm_flag in the 'vma'.
>>>
>>> Signed-off-by: Suresh Siddha<suresh.b.siddha@intel.com>
>>> Cc: Venkatesh Pallipadi<venki@google.com>
>>> Cc: Konstantin Khlebnikov<khlebnikov@openvz.org>
>>> ---
>>>    arch/x86/mm/pat.c |   30 +++++++++++++++++-------------
>>>    1 files changed, 17 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
>>> index f6ff57b..617f42b 100644
>>> --- a/arch/x86/mm/pat.c
>>> +++ b/arch/x86/mm/pat.c
>>> @@ -693,14 +693,10 @@ int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
>>>    			unsigned long pfn, unsigned long size)
>>>    {
>>>    	unsigned long flags;
>>> -	resource_size_t paddr;
>>> -	unsigned long vma_size = vma->vm_end - vma->vm_start;
>>>
>>> -	if (is_linear_pfn_mapping(vma)) {
>>> -		/* reserve the whole chunk starting from vm_pgoff */
>>> -		paddr = (resource_size_t)vma->vm_pgoff<<   PAGE_SHIFT;
>>> -		return reserve_pfn_range(paddr, vma_size, prot, 0);
>>> -	}
>>> +	/* reserve the whole chunk starting from pfn */
>>> +	if (is_linear_pfn_mapping(vma))
>>> +		return reserve_pfn_range(pfn, size, prot, 0);
>>
>> you mix here pfn and paddr: old code passes paddr as first argument of reserve_pfn_range().
>
> oops. That was my oversight. I updated the two patches to address this.
> Also I cleared VM_PAT flag as part of the untrack_pfn_vma(), so that the
> use cases (like the i915 case) which just evict the pfn's (by using
> unmap_mapping_range) with out actually removing the vma will do the
> free_pfn_range() only when it is required.
>
> Attached (to this e-mail) are the -v2 versions of the PAT patches. I
> tested these on my SNB laptop.

Ok, I'll send them as part of updated patchset.

>
> thanks,
> suresh

