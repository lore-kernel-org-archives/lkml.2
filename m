Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2BBFWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 00:22:32 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33658 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2BBFWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 00:22:31 -0500
Message-ID: <4F2A1CF7.9020306@linux.vnet.ibm.com>
Date: Thu, 02 Feb 2012 13:19:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] hugetlb: try to search again if it is really needed
References: <4F101904.8090405@linux.vnet.ibm.com> <4F101969.8050601@linux.vnet.ibm.com> <20120201144353.7c75b5b6.akpm@linux-foundation.org>
In-Reply-To: <20120201144353.7c75b5b6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12020119-6102-0000-0000-000000C18DBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for your review!

On 02/02/2012 06:43 AM, Andrew Morton wrote:

> On Fri, 13 Jan 2012 19:45:45 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Search again only if some holes may be skipped in the first time
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/mm/hugetlbpage.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
>> index e12debc..6bf5735 100644
>> --- a/arch/x86/mm/hugetlbpage.c
>> +++ b/arch/x86/mm/hugetlbpage.c
>> @@ -309,9 +309,8 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
>>  	struct hstate *h = hstate_file(file);
>>  	struct mm_struct *mm = current->mm;
>>  	struct vm_area_struct *vma;
>> -	unsigned long base = mm->mmap_base, addr = addr0;
>> +	unsigned long base = mm->mmap_base, addr = addr0, start_addr;
> 
> grr.  The multiple-definitions-per-line thing is ugly, makes for more
> patch conflicts and reduces opportunities to add useful comments.


Yes, thanks.

>>  try_again:
>> +	start_addr = mm->free_area_cache;
>> +
>>  	/* make sure it can fit in the remaining address space */
>>  	if (mm->free_area_cache < len)
>>  		goto fail;
>> @@ -357,10 +358,9 @@ fail:
>>  	 * if hint left us with no space for the requested
>>  	 * mapping then try again:
>>  	 */
>> -	if (first_time) {
>> +	if (start_addr != base) {
>>  		mm->free_area_cache = base;
>>  		largest_hole = 0;
>> -		first_time = 0;
>>  		goto try_again;
> 
> The code used to retry a single time.  With this change the retrying is
> potentially infinite.  What is the reason for this change?  What is the
> potential for causing a lockup?
> 

Actually, it is not infinite, after retry, we set "mm->free_area_cache = base",
"start_addr" will set to "base" in the second search, so the condition of
"goto try_again" will be unsatisfied.

