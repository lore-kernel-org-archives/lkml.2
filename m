Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0LXAwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 19:52:46 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49903 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0LXAwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 19:52:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DomomLpdBFML+LIZxP1r0EhV2QEm35TX2nuqvz02zfMUQc1rn+ctci/x+KsUp8PPY/
         rFjnhVf7nv6O1ds0qkNmXp+BOsmNew5t6+bAE7LW1TMzT97DdyFnMWO2Q/3iTi9cwFtG
         HG8h0BHzts45UyoBaZd/6tCBgy7KeL3XEaZKE=
MIME-Version: 1.0
In-Reply-To: <20101223083354.GB16046@balbir.in.ibm.com>
References: <20101210142745.29934.29186.stgit@localhost6.localdomain6>
	<20101210143112.29934.22944.stgit@localhost6.localdomain6>
	<AANLkTinaTUUfvK+Nc-Whck21r-OzT+0CFVnS4W_jG5aw@mail.gmail.com>
	<20101223083354.GB16046@balbir.in.ibm.com>
Date: Fri, 24 Dec 2010 09:52:43 +0900
Message-ID: <AANLkTi=CEkNQPxSGn8OB4k8+g66Ax9bj_4JYQTUAaa1B@mail.gmail.com>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v2)
From: Minchan Kim <minchan.kim@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 5:33 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * MinChan Kim <minchan.kim@gmail.com> [2010-12-14 20:02:45]:
>
>> > +                       if (should_reclaim_unmapped_pages(zone))
>> > +                               wakeup_kswapd(zone, order);
>>
>> I think we can put the logic into zone_watermark_okay.
>>
>
> I did some checks and zone_watermark_ok is used in several places for
> a generic check like this -- for example prior to zone_reclaim(), if
> in get_page_from_freelist() we skip zones based on the return value.
> The compaction code uses it as well, the impact would be deeper. The
> compaction code uses it to check whether an allocation will succeed or
> not, I don't want unmapped page control to impact that.

Agree.

>
>> > +                       /*
>> > +                        * We do unmapped page reclaim once here and once
>> > +                        * below, so that we don't lose out
>> > +                        */
>> > +                       reclaim_unmapped_pages(priority, zone, &sc);
>>
>> It can make unnecessary stir of lru pages.
>> How about this?
>> zone_watermark_ok returns ZONE_UNMAPPED_PAGE_FULL.
>> wakeup_kswapd(..., please reclaim unmapped page cache).
>> If kswapd is woke up by unmapped page full, kswapd sets up sc with unmap = 0.
>> If the kswapd try to reclaim unmapped page, shrink_page_list doesn't
>> rotate non-unmapped pages.
>
> With may_unmap set to 0 and may_writepage set to 0, I don't think this
> should be a major problem, like I said this code is already enabled if
> zone_reclaim_mode != 0 and CONFIG_NUMA is set.

True. It has been already in there.
But it is only NUMA and you are going to take out of NUMA.
That's why I have a concern.

I want to make this usefully in embedded.
Recently ChromOS try to protect mapped page so I think your series hep
the situation.
But frequent shrink unmapped pages makes stir of LRU which victim
mapped page(ie, tail of inactive file) can move into head of inactive
file. After all, LRU ordering makes confused so that NOT-LRU page can
be evicted.

>
>> > +unsigned long reclaim_unmapped_pages(int priority, struct zone *zone,
>> > +                                               struct scan_control *sc)
>> > +{
>> > +       if (unlikely(unmapped_page_control) &&
>> > +               (zone_unmapped_file_pages(zone) > zone->min_unmapped_pages)) {
>> > +               struct scan_control nsc;
>> > +               unsigned long nr_pages;
>> > +
>> > +               nsc = *sc;
>> > +
>> > +               nsc.swappiness = 0;
>> > +               nsc.may_writepage = 0;
>> > +               nsc.may_unmap = 0;
>> > +               nsc.nr_reclaimed = 0;
>>
>> This logic can be put in zone_reclaim_unmapped_pages.
>>
>
> Now that I refactored the code and called it zone_reclaim_pages, I
> expect the correct sc to be passed to it. This code is reused between
> zone_reclaim() and reclaim_unmapped_pages(). In the former,
> zone_reclaim does the setup.

Thanks.

>
>> If we want really this, how about the new cache lru idea as Kame suggests?
>> For example, add_to_page_cache_lru adds the page into cache lru.
>> page_add_file_rmap moves the page into inactive file.
>> page_remove_rmap moves the page into lru cache, again.
>> We can count the unmapped pages and if the size exceeds limit, we can
>> wake up kswapd.
>> whenever the memory pressure happens, first of all, reclaimer try to
>> reclaim cache lru.
>
> We already have a file LRU and that has active/inactive lists, I don't
> think a special mapped/unmapped list makes sense at this point.

That's for reclaim latency for embedded use case but I think it would
have benefit in desktop, too.
But it can be another patch series so I don't insist on.

Thanks, Balbir.


>
>
> --
>        Three Cheers,
>        Balbir
>



-- 
Kind regards,
Minchan Kim
