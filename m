Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238Ab0GPBo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 21:44:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45295 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935160Ab0GPBo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 21:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WvamzbiqG4dvFaJkfAbMWkdMli10g/s3F0JzWVAY9ZoqSTSXcotDoCpjlytn2lkqYd
         hrFSDWQLNZvP1TS307V/W0i+oaLsXdRL6neg7ApP3BmqUJVgltd6HHeMTnYZvLRUNokV
         Hz8q5TU6UxVKWVWhZXbyLZ1OyMkRsCLFSCm5c=
MIME-Version: 1.0
In-Reply-To: <20100716090302.7351.A69D9226@jp.fujitsu.com>
References: <20100713144008.EA52.A69D9226@jp.fujitsu.com>
	<20100715121551.bd5ccc61.akpm@linux-foundation.org>
	<20100716090302.7351.A69D9226@jp.fujitsu.com>
Date: Fri, 16 Jul 2010 10:44:24 +0900
Message-ID: <AANLkTikwsuuZHJxK0+1mdJVLZ7vw3r4oZBQrzuowLQXE@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vmscan: shrink_slab() require number of lru_pages, 
	not page order
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:39 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> >     nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
>> >     if (nr_slab_pages0 > zone->min_slab_pages) {
>> > +           unsigned long lru_pages = zone_reclaimable_pages(zone);
>> > +
>> >             /*
>> >              * shrink_slab() does not currently allow us to determine how
>> >              * many pages were freed in this zone. So we take the current
>> > @@ -2622,7 +2624,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>> >              * Note that shrink_slab will free memory on all zones and may
>> >              * take a long time.
>> >              */
>> > -           while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
>> > +           while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
>> >                    (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
>> >                     nr_slab_pages0))
>> >                     ;
>>
>> Wouldn't it be better to recalculate zone_reclaimable_pages() each time
>> around the loop?  For example, shrink_icache_memory()->prune_icache()
>> will remove pagecache from an inode if it hits the tail of the list.
>> This can change the number of reclaimable pages by squigabytes, but
>> this code thinks nothing changed?
>
> Ah, I missed this. incrementa patch is here.
>
> thank you!
>
>
>
> From 8f7c70cfb4a25f8292a59564db6c3ff425a69b53 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 16 Jul 2010 08:40:01 +0900
> Subject: [PATCH] vmscan: recalculate lru_pages on each shrink_slab()
>
> Andrew Morton pointed out shrink_slab() may change number of reclaimable
> pages (e.g. shrink_icache_memory()->prune_icache() will remove unmapped
> pagecache).
>
> So, we need to recalculate lru_pages on each shrink_slab() calling.
> This patch fixes it.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

It does make sense.

-- 
Kind regards,
Minchan Kim
