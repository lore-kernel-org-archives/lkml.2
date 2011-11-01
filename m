Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1KAIVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 04:21:44 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:54002 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab1KAIVm convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 1 Nov 2011 04:21:42 -0400
Message-Id: <4EB01C8F0200001600008FAE@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 Beta 
Date: Tue, 01 Nov 2011 02:21:35 -0600
From: "Guan Jun He" <gjhe@suse.com>
To: "Shaohua Li" <shaohua.li@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][mm/memory.c]: transparent hugepage check condition
 missed
References: <transparent-hugepage-check-condition-miss>
 <1320049412-12642-1-git-send-email-gjhe@suse.com>
 <1320110288.22361.190.camel@sli10-conroe>
In-Reply-To: <1320110288.22361.190.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> On 11/1/2011 at 09:18 AM, in message <1320110288.22361.190.camel@sli10-conroe>,
Shaohua Li <shaohua.li@intel.com> wrote: 
> On Mon, 2011-10-31 at 16:23 +0800, Guanjun He wrote:
>> For the transparent hugepage module still does not support
>> tmpfs and cache,the check condition should always be checked 
>> to make sure that it only affect the anonymous maps, the 
>> original check condition missed this, this patch is to fix this.
>> Otherwise,the hugepage may affect the file-backed maps,
>> then the cache for the small-size pages will be unuseful,
>> and till now there is still no implementation for hugepage's cache.
>> 
>> Signed-off-by: Guanjun He <gjhe@suse.com>
>> ---
>>  mm/memory.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>> 
>> diff --git a/mm/memory.c b/mm/memory.c
>> index a56e3ba..79b85fe 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -3475,7 +3475,8 @@ int handle_mm_fault(struct mm_struct *mm, struct 
> vm_area_struct *vma,
>>  		if (pmd_trans_huge(orig_pmd)) {
>>  			if (flags & FAULT_FLAG_WRITE &&
>>  			    !pmd_write(orig_pmd) &&
>> -			    !pmd_trans_splitting(orig_pmd))
>> +			    !pmd_trans_splitting(orig_pmd) &&
>> +			    !vma->vm_ops)
>>  				return do_huge_pmd_wp_page(mm, vma, address,
>>  							   pmd, orig_pmd);
>>  			return 0;
> so if vma->vm_ops != NULL, how could the pmd_trans_huge(orig_pmd) be
> true? We never enable THP if vma->vm_ops != NULL.
acturally, pmd_trans_huge(orig_pmd) only checks the _PAGE_PSE bits, 
it's only a pagesize, not a flag to identity a hugepage.
If I change my default pagesize to PAGE_PSE, then THP will be confused.

There is already a defination:

#define VM_HUGEPAGE	0x01000000	/* MADV_HUGEPAGE marked this vma */

maybe,this can be the flag to identity a hugepage.But the comment marked it only stands for MADV_HUGEPAGE,
and it's still a hugepage.So, I suggest to add the check condition !vma->vm_ops, or turn to 
use VM_HUGEPAGE as the flag.
or
adjust the logic to:
(transparent_hugepage_enabled() use the VM_HUGEPAGE flag)

 if(transparent_hugepage_enabled(vma)){
    if (pmd_none(*pmd){
        ...
    }
    else
    {
      ...
    }
}


the original logic is:

if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) 
{
  ...
}
else
{
  ...
}

