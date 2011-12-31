Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1LaOzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 09:55:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60032 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1LaOzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 09:55:23 -0500
MIME-Version: 1.0
In-Reply-To: <4EFCA4F9.7070703@gmail.com>
References: <CAJd=RBBJG+hLLc3mR-WzByU1gZEcdFUAoZzyir+1A4a0tVnSmg@mail.gmail.com>
	<4EFCA4F9.7070703@gmail.com>
Date: Sat, 31 Dec 2011 22:55:22 +0800
Message-ID: <CAJd=RBCuh=zDLZ7J9sV_p_ghoXP-VX6PEAx01t8p_pziTimxnA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscam: check page order in isolating lru pages
From: Hillf Danton <dhillf@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 1:35 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> (12/29/11 7:45 AM), Hillf Danton wrote:
>>
>> Before we try to isolate physically contiguous pages, check for page order
>> is
>> added, and if the reclaim order is no larger than page order, we should
>> give up
>> the attempt.
>>
>> Signed-off-by: Hillf Danton<dhillf@gmail.com>
>> Cc: Michal Hocko<mhocko@suse.cz>
>> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Andrew Morton<akpm@linux-foundation.org>
>> Cc: David Rientjes<rientjes@google.com>
>> Cc: Hugh Dickins<hughd@google.com>
>> ---
>>
>> --- a/mm/vmscan.c       Thu Dec 29 20:20:16 2011
>> +++ b/mm/vmscan.c       Thu Dec 29 20:28:14 2011
>> @@ -1162,6 +1162,7 @@ static unsigned long isolate_lru_pages(u
>>                unsigned long end_pfn;
>>                unsigned long page_pfn;
>>                int zone_id;
>> +               unsigned int isolated_pages = 0;
>>
>>                page = lru_to_page(src);
>>                prefetchw_prev_lru_page(page, src, flags);
>> @@ -1172,7 +1173,7 @@ static unsigned long isolate_lru_pages(u
>>                case 0:
>>                        mem_cgroup_lru_del(page);
>>                        list_move(&page->lru, dst);
>> -                       nr_taken += hpage_nr_pages(page);
>> +                       isolated_pages = hpage_nr_pages(page);
>>                        break;
>>
>>                case -EBUSY:
>> @@ -1184,8 +1185,11 @@ static unsigned long isolate_lru_pages(u
>>                        BUG();
>>                }
>>
>> +               nr_taken += isolated_pages;
>>                if (!order)
>>                        continue;
>> +               if (isolated_pages != 1&&  isolated_pages>= (1<<  order))
>> +                       continue;
>
>
> strange space alignment. and I don't think we need "isolated_pages != 1"
> check.
>
> Otherwise, Looks good to me.
>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>

Hi KOSAKI

It is re-prepared and please review again.
1, changelog is updated,
2, the check for page order is refined,
3, comment is also added.

Thanks
Hillf

===cut please===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: vmscam: check page order in isolating lru pages

Before try to isolate physically contiguous pages, check for page order is
added, and if it is not regular page, we should give up the attempt.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
---

--- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
+++ b/mm/vmscan.c	Sat Dec 31 22:44:16 2011
@@ -1162,6 +1162,7 @@ static unsigned long isolate_lru_pages(u
 		unsigned long end_pfn;
 		unsigned long page_pfn;
 		int zone_id;
+		unsigned int isolated_pages = 1;

 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
@@ -1172,7 +1173,7 @@ static unsigned long isolate_lru_pages(u
 		case 0:
 			mem_cgroup_lru_del(page);
 			list_move(&page->lru, dst);
-			nr_taken += hpage_nr_pages(page);
+			isolated_pages = hpage_nr_pages(page);
 			break;

 		case -EBUSY:
@@ -1184,8 +1185,12 @@ static unsigned long isolate_lru_pages(u
 			BUG();
 		}

+		nr_taken += isolated_pages;
 		if (!order)
 			continue;
+		/* try pfn-based isolation only for regular page */
+		if (isolated_pages != 1)
+			continue;

 		/*
 		 * Attempt to take all pages in the order aligned region
@@ -1227,7 +1232,6 @@ static unsigned long isolate_lru_pages(u
 				break;

 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
-				unsigned int isolated_pages;

 				mem_cgroup_lru_del(cursor_page);
 				list_move(&cursor_page->lru, dst);
