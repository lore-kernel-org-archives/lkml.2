Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0FCSg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:36:28 -0400
Received: from mail2.cray.com ([136.162.64.100]:47805 "EHLO mail2.cray.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab0FCSg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:36:27 -0400
Message-ID: <4C07F5EC.20600@cray.com>
Date: Thu, 3 Jun 2010 11:35:24 -0700
From: Doug Doan <dougd@cray.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "rientjes@google.com" <rientjes@google.com>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] hugetlb: call mmu notifiers on hugepage cow
References: <4BFED954.8060807@cray.com>	<20100601231600.3b3bf499.akpm@linux-foundation.org>	<4C06E5A6.6@cray.com>	<20100602163346.b8f8b8a4.akpm@linux-foundation.org>	<4C07E800.5010701@cray.com> <20100603111125.8cd6a787.akpm@linux-foundation.org>
In-Reply-To: <20100603111125.8cd6a787.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 11:11 AM, Andrew Morton wrote:
> On Thu, 3 Jun 2010 10:36:00 -0700
> Doug Doan<dougd@cray.com>  wrote:
>
>>> Well, specifically it means that
>>> mmu_notifier_invalidate_range_start/end() implemetnations can no longer
>>> take page_table_lock or any lock which nests outside page_table_lock.
>>> That lessens flexibility.
>>>
>>> As the other mmu_notifier_invalidate_range_start/end() callsite in this
>>> function carefully nested those calls outside page_table_lock, perhaps
>>> that was thought to be a significant thing.
>>
>> Here's my rationale: for the normal page case, the invalidation call is done
>> inside a page_table_lock,
>
> It is?  Where does that happen?

handle_pte_fault() acquires the lock before calling do_wp_page():

         ptl = pte_lockptr(mm, pmd);
         spin_lock(ptl);
         if (unlikely(!pte_same(*pte, entry)))
                 goto unlock;
         if (flags & FAULT_FLAG_WRITE) {
                 if (!pte_write(entry))
                         return do_wp_page(mm, vma, address,
                                         pte, pmd, ptl, entry);
                 entry = pte_mkdirty(entry);
         }

do_wp_page() calls set_pte_at_notify(), which either calls 
mmu_notifier_change_pte() or mmu_notifier_invalidate_page().

>
>> so the same should also be done in the huge page case.
>> Does it really make sense to call invalidation on one hugepage and have another
>> call invalidate the same hugepage while the first call is still not finished?
