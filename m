Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab1FBWXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:23:51 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37570 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1FBWXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tsnfzHmxUsVV06so38Wk5ff19t7SW7w6vv8h4ACQN4LWuIXoDH3wc0W42a+IAL+m5I
         eX6eH2Gqrlq0A5Iz1WkJI9oC8bjZqszop0ueG45//K4ZsAFhofT0gdU0JMH0QEqqZp9a
         sRHuYbASPrQoPMZpvfu6X0tjhMG3+/636AElo=
MIME-Version: 1.0
In-Reply-To: <20110602214041.GF2802@random.random>
References: <20110530165546.GC5118@suse.de>
	<20110530175334.GI19505@random.random>
	<20110531121620.GA3490@barrios-laptop>
	<20110531122437.GJ19505@random.random>
	<20110531133340.GB3490@barrios-laptop>
	<20110531141402.GK19505@random.random>
	<20110531143734.GB13418@barrios-laptop>
	<20110531143830.GC13418@barrios-laptop>
	<20110602182302.GA2802@random.random>
	<20110602202156.GA23486@barrios-laptop>
	<20110602214041.GF2802@random.random>
Date: Fri, 3 Jun 2011 07:23:48 +0900
Message-ID: <BANLkTim1WjdHWOQp7bMg5pFFKp1SSFoLKw@mail.gmail.com>
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

Hi Andrea,

On Fri, Jun 3, 2011 at 6:40 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> Hello Minchan,
>
> On Fri, Jun 03, 2011 at 05:21:56AM +0900, Minchan Kim wrote:
>> Isn't it rather aggressive?
>> I think cursor page is likely to be PageTail rather than PageHead.
>> Could we handle it simply with below code?
>
> It's not so likely, there is small percentage of compound pages that
> aren't THP compared to the rest that is either regular pagecache or
> anon regular or anon THP or regular shm. If it's THP chances are we

I mean we have more tail pages than head pages. So I think we are likely to
meet tail pages. Of course, compared to all pages(page cache, anon and
so on), compound pages would be very small percentage.

> isolated the head and it's useless to insist on more tail pages (at
> least for large page size like on x86). Plus we've compaction so

I can't understand your point. Could you elaborate it?

> insisting and screwing lru ordering isn't worth it, better to be
> permissive and abort... in fact I wouldn't dislike to remove the
> entire lumpy logic when COMPACTION_BUILD is true, but that alters the
> trace too...

AFAIK, it's final destination to go as compaction will not break lru
ordering if my patch(inorder-putback) is merged.

>
>> get_page(cursor_page)
>> /* The page is freed already */
>> if (1 == page_count(cursor_page)) {
>>       put_page(cursor_page)
>>       continue;
>> }
>> put_page(cursor_page);
>
> We can't call get_page on an tail page or we break split_huge_page,

Why don't we call get_page on tail page if tail page isn't free?
Maybe I need investigating split_huge_page.

> only an isolated lru can be boosted, if we take the lru_lock and we
> check the page is in lru, then we can isolate and pin it safely.
>

Thanks.


-- 
Kind regards,
Minchan Kim
