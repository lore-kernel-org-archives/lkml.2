Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0ILQUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 12:20:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50147 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0ILQUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 12:20:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TAG29DKgWKBkQD7XaiG2aORb7edq7MOPc5C3z0MZvyaP06jAI5E5zV1jlLTW+eAUmJ
         juQw1WQScdWo7C03/jEfs573O2s3blbHYgHfKxrl5c82WjAKQ/xodRMG0oXmo3FRo+RU
         w92bU+L3s9hDHydzjc7Az4i61QEQCruWTzD4k=
MIME-Version: 1.0
In-Reply-To: <20100908151929.2586ace5.akpm@linux-foundation.org>
References: <1283697637-3117-1-git-send-email-minchan.kim@gmail.com>
	<20100908054831.GB20955@cmpxchg.org>
	<20100908154527.GA5936@barrios-desktop>
	<20100908151929.2586ace5.akpm@linux-foundation.org>
Date: Mon, 13 Sep 2010 01:20:36 +0900
Message-ID: <AANLkTi=jmV=x2rJ=G4iicYFO6UqPbfob_VnkY7VNbP3X@mail.gmail.com>
Subject: Re: [PATCH] vmscan: check all_unreclaimable in direct reclaim path
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 7:19 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 9 Sep 2010 00:45:27 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> +static inline bool zone_reclaimable(struct zone *zone)
>> +{
>> +     return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
>> +}
>> +
>> +static inline bool all_unreclaimable(struct zonelist *zonelist,
>> +             struct scan_control *sc)
>> +{
>> +     struct zoneref *z;
>> +     struct zone *zone;
>> +     bool all_unreclaimable = true;
>> +
>> +     if (!scanning_global_lru(sc))
>> +             return false;
>> +
>> +     for_each_zone_zonelist_nodemask(zone, z, zonelist,
>> +                     gfp_zone(sc->gfp_mask), sc->nodemask) {
>> +             if (!populated_zone(zone))
>> +                     continue;
>> +             if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
>> +                     continue;
>> +             if (zone_reclaimable(zone)) {
>> +                     all_unreclaimable = false;
>> +                     break;
>> +             }
>> +     }
>> +
>>       return all_unreclaimable;
>>  }
>
> Could we have some comments over these functions please?  Why they
> exist, what problem they solve, how they solve them, etc.  Stuff which
> will be needed for maintaining this code three years from now.
>
> We may as well remove the `inline's too.  gcc will tkae care of that.

Okay. I will resend.

>
>> -             if (nr_slab == 0 &&
>> -                zone->pages_scanned >= (zone_reclaimable_pages(zone) * 6))
>> +             if (nr_slab == 0 && !zone_reclaimable(zone))
>
> Extra marks for working out and documenting how we decided on the value
> of "6".  Sigh.  It's hopefully in the git record somewhere.
>
Originally it is just following as.

                if (zone->pages_scanned > zone->present_pages * 2)
                        zone->all_unreclaimable = 1;

Nick change it with remained lru * 4 [1] and increased 6 [2].
But the description doesn't have why we determine it by "4".
So I can't handle it in my patch.

I don't like undocumented magic value. :(

[1]
commit 9d0aa0f7a99c88dd20bc188756b892f174d93fc1
Author: nickpiggin <nickpiggin>
Date:   Sun Oct 17 16:20:56 2004 +0000

    [PATCH] kswapd lockup fix

    Fix some bugs in the kswapd logic which can cause kswapd lockups.


[2]
commit 4ff1ffb4870b007b86f21e5f27eeb11498c4c077
Author: Nick Piggin <npiggin@suse.de>
Date:   Mon Sep 25 23:31:28 2006 -0700

    [PATCH] oom: reclaim_mapped on oom

-- 
Kind regards,
Minchan Kim
