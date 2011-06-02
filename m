Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1FBXBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 19:01:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46159 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1FBXBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 19:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zsr57nx4o3QSKUH0aT4+Dg0tjhaKpgliMcTqyAcx95erzBDbRCOaPYc/1rgpivoOR9
         JEEgUoGqsfxwH01XAbNgw48mVBVIHwmoD8cW8E4EiTkjdysf9uOA/eI6Yh0v8SGH6z4+
         p6t7asMg93hTu79359SnD9Y+8YjapZEn2k+Rk=
MIME-Version: 1.0
In-Reply-To: <20110602223201.GH2802@random.random>
References: <20110531121620.GA3490@barrios-laptop>
	<20110531122437.GJ19505@random.random>
	<20110531133340.GB3490@barrios-laptop>
	<20110531141402.GK19505@random.random>
	<20110531143734.GB13418@barrios-laptop>
	<20110531143830.GC13418@barrios-laptop>
	<20110602182302.GA2802@random.random>
	<20110602202156.GA23486@barrios-laptop>
	<20110602214041.GF2802@random.random>
	<BANLkTim1WjdHWOQp7bMg5pFFKp1SSFoLKw@mail.gmail.com>
	<20110602223201.GH2802@random.random>
Date: Fri, 3 Jun 2011 08:01:44 +0900
Message-ID: <BANLkTikA+ugFNS95Zs_o6QqG2u4r2g93=Q@mail.gmail.com>
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 7:32 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Fri, Jun 03, 2011 at 07:23:48AM +0900, Minchan Kim wrote:
>> I mean we have more tail pages than head pages. So I think we are likely to
>> meet tail pages. Of course, compared to all pages(page cache, anon and
>> so on), compound pages would be very small percentage.
>
> Yes that's my point, that being a small percentage it's no big deal to
> break the loop early.

Indeed.

>
>> > isolated the head and it's useless to insist on more tail pages (at
>> > least for large page size like on x86). Plus we've compaction so
>>
>> I can't understand your point. Could you elaborate it?
>
> What I meant is that if we already isolated the head page of the THP,
> we don't need to try to free the tail pages and breaking the loop
> early, will still give us a chance to free a whole 2m because we
> isolated the head page (it'll involve some work and swapping but if it
> was a compoundtranspage we're ok to break the loop and we're not
> making the logic any worse). Provided the PMD_SIZE is quite large like
> 2/4m...

Do you want this? (it's almost pseudo-code)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7a4469b..9d7609f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1017,7 +1017,7 @@ static unsigned long isolate_lru_pages(unsigned
long nr_to_scan,
        for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
                struct page *page;
                unsigned long pfn;
-               unsigned long end_pfn;
+               unsigned long start_pfn, end_pfn;
                unsigned long page_pfn;
                int zone_id;

@@ -1057,9 +1057,9 @@ static unsigned long isolate_lru_pages(unsigned
long nr_to_scan,
                 */
                zone_id = page_zone_id(page);
                page_pfn = page_to_pfn(page);
-               pfn = page_pfn & ~((1 << order) - 1);
+               start_pfn = pfn = page_pfn & ~((1 << order) - 1);
                end_pfn = pfn + (1 << order);
-               for (; pfn < end_pfn; pfn++) {
+               while (pfn < end_pfn) {
                        struct page *cursor_page;

                        /* The target page is in the block, ignore it. */
@@ -1086,17 +1086,25 @@ static unsigned long
isolate_lru_pages(unsigned long nr_to_scan,
                                break;

                        if (__isolate_lru_page(cursor_page, mode, file) == 0) {
+                               int isolated_pages;
                                list_move(&cursor_page->lru, dst);
                                mem_cgroup_del_lru(cursor_page);
-                               nr_taken += hpage_nr_pages(page);
+                               isolated_pages = hpage_nr_pages(page);
+                               nr_taken += isolated_pages;
+                               /* if we isolated pages enough, let's
break early */
+                               if (nr_taken > end_pfn - start_pfn)
+                                       break;
+                               pfn += isolated_pages;
                                nr_lumpy_taken++;
                                if (PageDirty(cursor_page))
                                        nr_lumpy_dirty++;
                                scan++;
                        } else {
                                /* the page is freed already. */
-                               if (!page_count(cursor_page))
+                               if (!page_count(cursor_page)) {
+                                       pfn++;
                                        continue;
+                               }
                                break;
                        }
                }

>
> The only way this patch makes things worse is for slub order 3 in the
> process of being freed. But tail pages aren't generally free anyway so
> I doubt this really makes any difference plus the tail is getting
> cleared as soon as the page reaches the buddy so it's probably

Okay. Considering getting clear PG_tail as soon as slub order 3 is
freed, it would be very rare case.

> unnoticeable as this then makes a difference only during a race (plus
> the tail page can't be isolated, only head page can be part of lrus
> and only if they're THP).
>
>> > insisting and screwing lru ordering isn't worth it, better to be
>> > permissive and abort... in fact I wouldn't dislike to remove the
>> > entire lumpy logic when COMPACTION_BUILD is true, but that alters the
>> > trace too...
>>
>> AFAIK, it's final destination to go as compaction will not break lru
>> ordering if my patch(inorder-putback) is merged.
>
> Agreed. I like your patchset, sorry for not having reviewed it in
> detail yet but there were other issues popping up in the last few
> days.

No problem. it's urgent than mine. :)

>
>> >> get_page(cursor_page)
>> >> /* The page is freed already */
>> >> if (1 == page_count(cursor_page)) {
>> >>       put_page(cursor_page)
>> >>       continue;
>> >> }
>> >> put_page(cursor_page);
>> >
>> > We can't call get_page on an tail page or we break split_huge_page,
>>
>> Why don't we call get_page on tail page if tail page isn't free?
>> Maybe I need investigating split_huge_page.
>
> Yes it's split_huge_page, only gup is allowed to increase the tail
> page because we're guaranteed while gup_fast does it,
> split_huge_page_refcount isn't running yet, because the pmd wasn't
> set as splitting and the irqs were disabled (or we'd be holding the
> page_table_lock for gup slow version after checking again the pmd
> wasn't splitting and so __split_huge_page_refcount will wait).

Thanks. I will have a time to understand your point with reviewing
split_huge_page and your this comment.

You convinced me and made me think thing I didn't think about which
are good points.
Thanks, Andrea.

>
> Thanks,
> Andrea
>



-- 
Kind regards,
Minchan Kim
