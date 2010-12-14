Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab0LNWip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:38:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37017 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758910Ab0LNWin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:38:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wI4xFP89Q7YKihwj28YyUZe/q3Uo1CYQmbXbR20VuvXFvgNhHLRdYPLw6X1/oW2LjX
         hxLwWxoLGQI4AUcclcQShdTHlRtU0r/YEbh4hCnGTUw4/m5xEKrFvG3/4pzqGyA4Of0b
         7vswH6mfTijbHGUfOjQ9sxRejcv9ekNNUt7mk=
MIME-Version: 1.0
In-Reply-To: <20101214114542.GE14178@balbir.in.ibm.com>
References: <20101210142745.29934.29186.stgit@localhost6.localdomain6>
	<20101210143018.29934.11893.stgit@localhost6.localdomain6>
	<AANLkTimeecObDMQMbWzNhL1mE+UT9D3o1WWS4bmxtR4U@mail.gmail.com>
	<20101214114542.GE14178@balbir.in.ibm.com>
Date: Wed, 15 Dec 2010 07:38:42 +0900
Message-ID: <AANLkTimy2wKPGxMsO0d_CxUNiDcc+8HWRBctOTrkbbjX@mail.gmail.com>
Subject: Re: [PATCH 2/3] Refactor zone_reclaim (v2)
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

On Tue, Dec 14, 2010 at 8:45 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * MinChan Kim <minchan.kim@gmail.com> [2010-12-14 19:01:26]:
>
>> Hi Balbir,
>>
>> On Fri, Dec 10, 2010 at 11:31 PM, Balbir Singh
>> <balbir@linux.vnet.ibm.com> wrote:
>> > Move reusable functionality outside of zone_reclaim.
>> > Make zone_reclaim_unmapped_pages modular
>> >
>> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> > ---
>> >  mm/vmscan.c |   35 +++++++++++++++++++++++------------
>> >  1 files changed, 23 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/mm/vmscan.c b/mm/vmscan.c
>> > index e841cae..4e2ad05 100644
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -2815,6 +2815,27 @@ static long zone_pagecache_reclaimable(struct zone *zone)
>> >  }
>> >
>> >  /*
>> > + * Helper function to reclaim unmapped pages, we might add something
>> > + * similar to this for slab cache as well. Currently this function
>> > + * is shared with __zone_reclaim()
>> > + */
>> > +static inline void
>> > +zone_reclaim_unmapped_pages(struct zone *zone, struct scan_control *sc,
>> > +                               unsigned long nr_pages)
>> > +{
>> > +       int priority;
>> > +       /*
>> > +        * Free memory by calling shrink zone with increasing
>> > +        * priorities until we have enough memory freed.
>> > +        */
>> > +       priority = ZONE_RECLAIM_PRIORITY;
>> > +       do {
>> > +               shrink_zone(priority, zone, sc);
>> > +               priority--;
>> > +       } while (priority >= 0 && sc->nr_reclaimed < nr_pages);
>> > +}
>>
>> As I said previous version, zone_reclaim_unmapped_pages doesn't have
>> any functions related to reclaim unmapped pages.
>
> The scan control point has the right arguments for implementing
> reclaim of unmapped pages.

I mean you should set up scan_control setup in this function.
Current zone_reclaim_unmapped_pages doesn't have any specific routine
related to reclaim unmapped pages.
Otherwise, change the function name with just "zone_reclaim_pages". I
think you don't want it.

-- 
Kind regards,
Minchan Kim
