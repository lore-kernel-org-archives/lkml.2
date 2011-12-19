Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1LSTww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:52:52 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57966 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1LSTwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:52:50 -0500
Message-ID: <4EEF960F.1070909@gmail.com>
Date: Mon, 19 Dec 2011 11:52:47 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] mm: Fix BUILD_BUG assertion in pmdp_clear_flush_young()
References: <20111217152253.1aedda0936cd5d1d98be5e76@canb.auug.org.au> <1324316288-2367-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1112191125320.19949@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1112191125320.19949@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 11:29 AM, David Rientjes wrote:
> On Mon, 19 Dec 2011, David Daney wrote:
>
>> From: David Daney<david.daney@cavium.com>
>>
>> It has been reported that when building for sh:
>>
>>      mm/pgtable-generic.c: In function 'pmdp_clear_flush_young':
>>      mm/pgtable-generic.c:76: error: call to '__build_bug_failed' declared with attribute error: BUILD_BUG failed
>>
>> Adding some ugle #ifdeffery will probably fix this issue.
>>
>
> It won't, CONFIG_HUGETLB_PAGE has nothing at all to do with this.
>

Sorry for the noise.  You are correct.


>> Signed-off-by: David Daney<david.daney@cavium.com>
>> ---
>>
>> This is completely untested, but may be the best fix for this.  Linus
>> and others have expressed a dislike for using BUG() to detect what
>> should be dead code paths at runtime, but it seems to be the state of
>> the art here.
>>
>
> The problem here is that HPAGE_PMD_MASK is being referenced without
> CONFIG_TRANSPARENT_HUGEPAGE.  pmdp_clear_flush_young() is only applicable
> with that config option enabled.  So rather than trying to minimize lines
> captured under an #ifdef by placing the BUG() directly in the function for
> asm-generic, you'll need to wrap pmd_clear_flush_young() with
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE and define its equivalent for
> CONFIG_TRANSPARENT_HUGEPAGE=n that breaks the build if not enabled.
>

That does sound like a better option.

I still think having the BUILD_BUG defined as we do in Andrew Morton's 
tree is the correct approach, and I don't want to see that reverted 
because of this ugliness.

Really this is hackery that should be cleaned up as you suggest, instead 
of being papered over with this BUG() thing.  I can't test SH things, 
otherwise I might look at it.  The SH maintainers should probably take a 
look instead.

David Daney

>>   mm/pgtable-generic.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>> index eb663fb..73784c8 100644
>> --- a/mm/pgtable-generic.c
>> +++ b/mm/pgtable-generic.c
>> @@ -70,7 +70,7 @@ int pmdp_clear_flush_young(struct vm_area_struct *vma,
>>   			   unsigned long address, pmd_t *pmdp)
>>   {
>>   	int young;
>> -#ifndef CONFIG_TRANSPARENT_HUGEPAGE
>> +#if !defined(CONFIG_HUGETLB_PAGE) || !defined(CONFIG_TRANSPARENT_HUGEPAGE)
>>   	BUG();
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>   	VM_BUG_ON(address&  ~HPAGE_PMD_MASK);

