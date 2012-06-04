Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2FDBVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:21:44 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59683 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2FDBVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:21:42 -0400
X-AuditID: 9c93016f-b7c3cae000001954-5e-4fcc0da3c499
Message-ID: <4FCC0DB4.30106@kernel.org>
Date: Mon, 04 Jun 2012 10:21:56 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
References: <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils> <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com> <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com> <alpine.LSU.2.00.1206012108430.11308@eggly.anvils> <20120603181548.GA306@redhat.com> <CA+55aFwZ5PsBLqM7K8vDQdbS3sf+vi3yeoWx6XKV=nF8k2r7DQ@mail.gmail.com> <20120603183139.GA1061@redhat.com> <20120603205332.GA5412@redhat.com> <alpine.LSU.2.00.1206031459450.15427@eggly.anvils> <CA+55aFz--XDSOConDoM2SO0Jpd78Dg4GsGP+Z0F+__JWz+6JoQ@mail.gmail.com>
In-Reply-To: <CA+55aFz--XDSOConDoM2SO0Jpd78Dg4GsGP+Z0F+__JWz+6JoQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 08:13 AM, Linus Torvalds wrote:

> On Sun, Jun 3, 2012 at 3:17 PM, Hugh Dickins <hughd@google.com> wrote:
>>
>> But another strike against that commit: I tried fixing it up to use
>> start_page instead of page at the end, with the worrying but safer
>> locking I suggested at first, with a count of how many times it went
>> there, and how many times it succeeded.
> 
> You can't use start_page anyway, it might not be a valid page. There's
> a reson it does that "pfn_valid_within()", methinks.


Right. I missed that. I think we can use the page passed to rescue_unmovable_pageblock.
We make sure it's valid in isolate_freepages. So how about this?

barrios@bbox:~/linux-2.6$ git diff
diff --git a/mm/compaction.c b/mm/compaction.c
index 4ac338a..7459ab5 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -368,11 +368,11 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 static bool rescue_unmovable_pageblock(struct page *page)
 {
        unsigned long pfn, start_pfn, end_pfn;
-       struct page *start_page, *end_page;
+       struct page *start_page, *end_page, *cursor_page;
 
        pfn = page_to_pfn(page);
        start_pfn = pfn & ~(pageblock_nr_pages - 1);
-       end_pfn = start_pfn + pageblock_nr_pages;
+       end_pfn = start_pfn + pageblock_nr_pages - 1;
 
        start_page = pfn_to_page(start_pfn);
        end_page = pfn_to_page(end_pfn);
@@ -381,19 +381,19 @@ static bool rescue_unmovable_pageblock(struct page *page)
        if (page_zone(start_page) != page_zone(end_page))
                return false;
 
-       for (page = start_page, pfn = start_pfn; page < end_page; pfn++,
-                                                                 page++) {
+       for (cursor_page = start_page, pfn = start_pfn; cursor_page <= end_page; pfn++,
+                                                                 cursor_page++) {
                if (!pfn_valid_within(pfn))
                        continue;
 
-               if (PageBuddy(page)) {
-                       int order = page_order(page);
+               if (PageBuddy(cursor_page)) {
+                       int order = page_order(cursor_page);
 
                        pfn += (1 << order) - 1;
-                       page += (1 << order) - 1;
+                       cursor_page += (1 << order) - 1;
 
                        continue;
-               } else if (page_count(page) == 0 || PageLRU(page))
+               } else if (page_count(cursor_page) == 0 || PageLRU(cursor_page))
                        continue;
 
                return false;


> 
> Anyway, my current plan is to apply your "mm: fix warning in
> __set_page_dirty_nobuffers" patch - even if it's just a harmless
> WARN_ON_ONCE(), and revert 5ceb9ce6fe94. Sounds like Dave hit normally
> hit his problem much before two hours, and it must be even longer now.

> 

> Ack on that plan?


No objection.
The patch wasn't a bug fix and even test workload was very theoretical.

> 
>         Linus
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



-- 
Kind regards,
Minchan Kim
