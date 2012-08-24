Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab2HXCIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:08:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50779 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab2HXCIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:08:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120823135839.GB19968@dhcp22.suse.cz>
References: <CAFNq8R7ibTNeRP_Wftwyr7mK6Du4TVysQysgL_RYj+CGf9N2qg@mail.gmail.com>
	<20120823095022.GB10685@dhcp22.suse.cz>
	<CAFNq8R5pY0yPp-LQYNywpMhVtXgqPSy3RYqHVTVpPXs52kOmJw@mail.gmail.com>
	<20120823135839.GB19968@dhcp22.suse.cz>
Date: Fri, 24 Aug 2012 10:08:20 +0800
Message-ID: <CAFNq8R7ry5kyuMombamf6jLmiLcWFnRQRp2vYt1+kv+pPec1_w@mail.gmail.com>
Subject: Re: Fixup the page of buddy_higher address's calculation
From: Li Haifeng <omycle@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/23 Michal Hocko <mhocko@suse.cz>:
> On Thu 23-08-12 20:30:34, Gavin Shan wrote:
>> On Thu, Aug 23, 2012 at 06:21:06PM +0800, Li Haifeng wrote:
> [...]
>> >>> From d7cd78f9d71a5c9ddeed02724558096f0bb4508a Mon Sep 17 00:00:00 2001
>> >>> From: Haifeng Li <omycle@gmail.com>
>> >>> Date: Thu, 23 Aug 2012 16:27:19 +0800
>> >>> Subject: [PATCH] Fixup the page of buddy_higher address's calculation
>> >>
>> >> Some general questions:
>> >> Any word about the change? Is it really that obvious? Why do you think the
>> >> current state is incorrect? How did you find out?
>> >>
>> >> And more specific below:
>> >>
>> >>> Signed-off-by: Haifeng Li <omycle@gmail.com>
>> >>> ---
>> >>>  mm/page_alloc.c |    2 +-
>> >>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >>>
>> >>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> >>> index ddbc17d..5588f68 100644
>> >>> --- a/mm/page_alloc.c
>> >>> +++ b/mm/page_alloc.c
>> >>> @@ -579,7 +579,7 @@ static inline void __free_one_page(struct page *page,
>> >>>                 combined_idx = buddy_idx & page_idx;
>> >>>                 higher_page = page + (combined_idx - page_idx);
>> >>>                 buddy_idx = __find_buddy_index(combined_idx, order + 1);
>> >>> -               higher_buddy = page + (buddy_idx - combined_idx);
>> >>> +               higher_buddy = page + (buddy_idx - page_idx);
>>
>> Haifeng, Not sure it would be better? At least, the expression
>> would be more explicitly meaningful than yours.
>>
>>                   higher_buddy = higher_page + (buddy_idx - combined_idx);
>
Thanks Gavin. Yes, it's more meaningful. :)

> Yes, indeed. It would be also good to mention that this is a regression
> since 43506fad (mm/page_alloc.c: simplify calculation of combined index
> of adjacent buddy lists). IIUC this basically disables the heuristic
> because page_is_buddy will fail for order+1, right?
>
> Maybe 2.6.38+ stable candidate, then.
>
> Could you repost with the full changelog, please?
>

OK.

> Thanks
> --
> Michal Hocko
> SUSE Labs

Also sorry for the confusing title. Repost it.
------------------------------------------------------>
Subject: [PATCH] Fix the page address of higher page's buddy calculation

Calculate the page address of higher page's buddy should be based
higher_page with the offset between index of higher page and
index of higher page's buddy.

Signed-off-by: Haifeng Li <omycle@gmail.com>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cdef1d4..642cd62 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -536,7 +536,7 @@ static inline void __free_one_page(struct page *page,
                combined_idx = buddy_idx & page_idx;
                higher_page = page + (combined_idx - page_idx);
                buddy_idx = __find_buddy_index(combined_idx, order + 1);
-               higher_buddy = page + (buddy_idx - combined_idx);
+               higher_buddy = higher_page + (buddy_idx - combined_idx);
                if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
                        list_add_tail(&page->lru,
                                &zone->free_area[order].free_list[migratetype]);
--
1.7.5.4
