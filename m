Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0D1SLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0D1SLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:11:13 -0400
Message-ID: <4BD879F7.1020102@redhat.com>
Date: Wed, 28 Apr 2010 14:09:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] take all anon_vma locks in anon_vma_lock
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie> <1272403852-10479-3-git-send-email-mel@csn.ul.ie> <20100427231007.GA510@random.random> <20100428091555.GB15815@csn.ul.ie> <20100428153525.GR510@random.random> <20100428155558.GI15815@csn.ul.ie> <20100428162305.GX510@random.random> <20100428134719.32e8011b@annuminas.surriel.com> <20100428180336.GC510@random.random>
In-Reply-To: <20100428180336.GC510@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 02:03 PM, Andrea Arcangeli wrote:
> On Wed, Apr 28, 2010 at 01:47:19PM -0400, Rik van Riel wrote:
>>   static inline void anon_vma_unlock(struct vm_area_struct *vma)
>
> never mind as this is RFC, lock is clear enough
>
>> @@ -1762,7 +1760,8 @@ static int expand_downwards(struct vm_area_struct *vma,
>>   	if (error)
>>   		return error;
>>
>> -	anon_vma_lock(vma);
>> +	spin_lock(&mm->page_table_lock);
>> +	anon_vma_lock(vma,&mm->page_table_lock);
>
> This will cause a lock inversion (page_table_lock can only be taken
> after the anon_vma lock). I don't immediately see why the
> page_table_lock here though?

We need to safely walk the vma->anon_vma_chain /
anon_vma_chain->same_vma list.

So much for using the mmap_sem for read + the
page_table_lock to lock the anon_vma_chain list.

We'll need a new lock somewhere, probably in the
mm_struct since one per process seems plenty.

I'll add that in the next version of the patch.

-- 
All rights reversed
