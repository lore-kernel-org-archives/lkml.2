Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1LLOtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:49:09 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57772 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1LLOtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:49:05 -0500
Message-ID: <4EE6145C.9070606@gmail.com>
Date: Mon, 12 Dec 2011 09:49:00 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH v3] mm: simplify find_vma_prev
References: <1323466526.27746.29.camel@joe2Laptop> <1323470921-12931-1-git-send-email-kosaki.motohiro@gmail.com> <20111212132616.GB15249@tiehlicka.suse.cz>
In-Reply-To: <20111212132616.GB15249@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/12/11 8:26 AM), Michal Hocko wrote:
> On Fri 09-12-11 17:48:40, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>
>> commit 297c5eee37 (mm: make the vma list be doubly linked) added
>> vm_prev member into vm_area_struct. Therefore we can simplify
>> find_vma_prev() by using it. Also, this change help to improve
>> page fault performance because it has strong locality of reference.
>>
>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>> ---
>>   mm/mmap.c |   36 ++++++++----------------------------
>>   1 files changed, 8 insertions(+), 28 deletions(-)
>>
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index eae90af..b9c0241 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -1603,39 +1603,19 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
>>
>>   EXPORT_SYMBOL(find_vma);
>>
>> -/* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
>> +/*
>> + * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
>> + * Note: pprev is set to NULL when return value is NULL.
>> + */
>>   struct vm_area_struct *
>>   find_vma_prev(struct mm_struct *mm, unsigned long addr,
>>   			struct vm_area_struct **pprev)
>>   {
>> -	struct vm_area_struct *vma = NULL, *prev = NULL;
>> -	struct rb_node *rb_node;
>> -	if (!mm)
>> -		goto out;
>> -
>> -	/* Guard against addr being lower than the first VMA */
>> -	vma = mm->mmap;
>
> Why have you removed this guard? Previously we had pprev==NULL and
> returned mm->mmap.
> This seems like a semantic change without any explanation. Could you
> clarify?

IIUC, find_vma_prev() is module unexported and none of known caller use
pprev==NULL. Thus, I thought it can be also simplified. Am I missing 
something?

