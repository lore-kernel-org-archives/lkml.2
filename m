Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2CVNVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 09:21:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37353 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964924Ab2CVNVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 09:21:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120321140019.9ca39a31.akpm@linux-foundation.org>
References: <CAJd=RBALNtedfq+PLPnGKd4i4D0mLiVPdW_7pWWopnSZNC_vqA@mail.gmail.com>
	<20120222130659.d75b6f69.akpm@linux-foundation.org>
	<CAJd=RBA53nS70Q7GEeskKFas-hfg4GKmUf=Zut5anSN0P+d1KA@mail.gmail.com>
	<20120223121238.b597e7e4.akpm@linux-foundation.org>
	<20120321140019.9ca39a31.akpm@linux-foundation.org>
Date: Thu, 22 Mar 2012 21:21:22 +0800
Message-ID: <CAJd=RBC9wN_M6T=vxmw+HxwxJF8Me1pq+UwZGEGoxto+HmG-3Q@mail.gmail.com>
Subject: Re: [PATCH] mm: hugetlb: bail out unmapping after serving reference page
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 5:00 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 23 Feb 2012 12:12:38 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Thu, 23 Feb 2012 21:05:41 +0800
>> Hillf Danton <dhillf@gmail.com> wrote:
>>
>> > and a follow-up cleanup also attached.
>>
>> Please, never put more than one patches in an email - it is rather a
>> pain to manually unpick everything.
>>
>> > When unmapping given VM range, a couple of code duplicate, such as pte_page()
>> > and huge_pte_none(), so a cleanup needed to compact them together.
>> >
>> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> > ---
>> >
>> > --- a/mm/hugetlb.c  Thu Feb 23 20:13:06 2012
>> > +++ b/mm/hugetlb.c  Thu Feb 23 20:30:16 2012
>> > @@ -2245,16 +2245,23 @@ void __unmap_hugepage_range(struct vm_ar
>> >             if (huge_pmd_unshare(mm, &address, ptep))
>> >                     continue;
>> >
>> > +           pte = huge_ptep_get(ptep);
>> > +           if (huge_pte_none(pte))
>> > +                   continue;
>> > +
>> > +           /*
>> > +            * HWPoisoned hugepage is already unmapped and dropped reference
>> > +            */
>> > +           if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
>> > +                   continue;
>> > +
>> > +           page = pte_page(pte);
>> >             /*
>> >              * If a reference page is supplied, it is because a specific
>> >              * page is being unmapped, not a range. Ensure the page we
>> >              * are about to unmap is the actual page of interest.
>> >              */
>> >             if (ref_page) {
>> > -                   pte = huge_ptep_get(ptep);
>> > -                   if (huge_pte_none(pte))
>> > -                           continue;
>> > -                   page = pte_page(pte);
>> >                     if (page != ref_page)
>> >                             continue;
>> >
>> > @@ -2267,16 +2274,6 @@ void __unmap_hugepage_range(struct vm_ar
>> >             }
>> >
>> >             pte = huge_ptep_get_and_clear(mm, address, ptep);
>> > -           if (huge_pte_none(pte))
>> > -                   continue;
>> > -
>> > -           /*
>> > -            * HWPoisoned hugepage is already unmapped and dropped reference
>> > -            */
>> > -           if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
>> > -                   continue;
>> > -
>> > -           page = pte_page(pte);
>> >             if (pte_dirty(pte))
>> >                     set_page_dirty(page);
>> >             list_add(&page->lru, &page_list);
>>
>> This changes behaviour when ref_page refers to a hwpoisoned page.
>
> Respond, please?

First say sorry to you, Andrew.

The comment says, HWPoisoned hugepage is already unmapped;
and even if ref_page == HWPoisoned page, it is not added onto
page_list and no page_remove_rmap() is issued for it, so we end
up with no behavior change.

Thanks
-hd
