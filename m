Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0ILQU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 12:20:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50147 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0ILQU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 12:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SWKJir4WtlQO25yyPNHmlVh/vVqI6R+D66ibX0S/gTQ9KwXKxDm5USCrrsDX08XdVS
         rA59bYNKKP7zR1VKNxa6NBiVm0Q48RHMhU+6cOrHXeF5coSXvq7AyVWGZeBu2KQTe2fD
         HQF5h59D9DU+Lq4+R/C+/ntL3KPF8nfJCoVmw=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=4kwu0Y5-MDye3TD+zZiku62NtNCMtWLn==p12@mail.gmail.com>
References: <1283697637-3117-1-git-send-email-minchan.kim@gmail.com>
	<20100908054831.GB20955@cmpxchg.org>
	<20100908154527.GA5936@barrios-desktop>
	<20100908151929.2586ace5.akpm@linux-foundation.org>
	<AANLkTi=4kwu0Y5-MDye3TD+zZiku62NtNCMtWLn==p12@mail.gmail.com>
Date: Mon, 13 Sep 2010 01:20:56 +0900
Message-ID: <AANLkTimzidMtKs073bxrYz8GsenRNuAAnQMy7a=FS5Sf@mail.gmail.com>
Subject: Re: [PATCH] vmscan: check all_unreclaimable in direct reclaim path
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Dave.

On Fri, Sep 10, 2010 at 5:24 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Thu, Sep 9, 2010 at 6:19 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Thu, 9 Sep 2010 00:45:27 +0900
>> Minchan Kim <minchan.kim@gmail.com> wrote:
>>
>>> +static inline bool zone_reclaimable(struct zone *zone)
>>> +{
>>> +     return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
>>> +}
>>> +
>>> +static inline bool all_unreclaimable(struct zonelist *zonelist,
>>> +             struct scan_control *sc)
>>> +{
>>> +     struct zoneref *z;
>>> +     struct zone *zone;
>>> +     bool all_unreclaimable = true;
>>> +
>>> +     if (!scanning_global_lru(sc))
>>> +             return false;
>>> +
>>> +     for_each_zone_zonelist_nodemask(zone, z, zonelist,
>>> +                     gfp_zone(sc->gfp_mask), sc->nodemask) {
>>> +             if (!populated_zone(zone))
>>> +                     continue;
>>> +             if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
>>> +                     continue;
>>> +             if (zone_reclaimable(zone)) {
>>> +                     all_unreclaimable = false;
>>> +                     break;
>>> +             }
>>> +     }
>>> +
>>>       return all_unreclaimable;
>>>  }
>>
>> Could we have some comments over these functions please?  Why they
>> exist, what problem they solve, how they solve them, etc.  Stuff which
>> will be needed for maintaining this code three years from now.
>>
>> We may as well remove the `inline's too.  gcc will tkae care of that.
>>
>>> -             if (nr_slab == 0 &&
>>> -                zone->pages_scanned >= (zone_reclaimable_pages(zone) * 6))
>>> +             if (nr_slab == 0 && !zone_reclaimable(zone))
>>
>> Extra marks for working out and documenting how we decided on the value
>> of "6".  Sigh.  It's hopefully in the git record somewhere.
>
> Here it is (necessary to add additional comment?):
>
> commit 4ff1ffb4870b007b86f21e5f27eeb11498c4c077
> Author: Nick Piggin <npiggin@suse.de>
> Date:   Mon Sep 25 23:31:28 2006 -0700
>
>    [PATCH] oom: reclaim_mapped on oom
>
>    Potentially it takes several scans of the lru lists before we can even start
>    reclaiming pages.
>
>    mapped pages, with young ptes can take 2 passes on the active list + one on
>    the inactive list.  But reclaim_mapped may not always kick in
> instantly, so it
>    could take even more than that.
>
>    Raise the threshold for marking a zone as all_unreclaimable from a
> factor of 4
>    time the pages in the zone to 6.  Introduce a mechanism to force
>    reclaim_mapped if we've reached a factor 3 and still haven't made progress.
>
>    Previously, a customer doing stress testing was able to easily OOM the box
>    after using only a small fraction of its swap (~100MB).  After the
> patches, it
>    would only OOM after having used up all swap (~800MB).
>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
>>
>
>
>
> --
> Regards
> dave
>



-- 
Kind regards,
Minchan Kim
