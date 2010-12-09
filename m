Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0LIATs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 19:19:48 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:55215 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0LIATr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 19:19:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xp6EJuCGPjuxMenm3qa+GgQ4itr5AUVpx37/HrOccAHk8+cf4Conot2zrIWw0Kk5tC
         teoxoPpNRJZ9bx/n4APKHYZHflJTMpsnIA8QrSmFj0Amw90Hc+6LKGDgfgbImN6OwDRk
         Di6IQrLJHyGhfr4J2BbWPR1nU8AG4cyMTJbPc=
MIME-Version: 1.0
In-Reply-To: <20101208065650.GP3158@balbir.in.ibm.com>
References: <20101207144923.GB2356@cmpxchg.org>
	<20101207150710.GA26613@barrios-desktop>
	<20101207151939.GF2356@cmpxchg.org>
	<20101207152625.GB608@barrios-desktop>
	<20101207155645.GG2356@cmpxchg.org>
	<AANLkTi=iNGT_p_VfW9GxdaKXLt2xBHM2jdwmCbF_u8uh@mail.gmail.com>
	<20101208095642.8128ab33.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTimtkb7Nczhads4u3r21RJauZvviLFkXjaL1ErDb@mail.gmail.com>
	<20101208105637.5103de75.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTim9to0Wa_iWyVA4FSV6sfT4tcR2bmV7t54HOQ1c@mail.gmail.com>
	<20101208065650.GP3158@balbir.in.ibm.com>
Date: Thu, 9 Dec 2010 09:19:46 +0900
Message-ID: <AANLkTimhRdRV4QS6gtLfm5DL-ZaeZjpdNT0-Muj4ePKP@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] deactivate invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 3:56 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * MinChan Kim <minchan.kim@gmail.com> [2010-12-08 11:15:19]:
>
>> On Wed, Dec 8, 2010 at 10:56 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Wed, 8 Dec 2010 10:43:08 +0900
>> > Minchan Kim <minchan.kim@gmail.com> wrote:
>> >
>> >> Hi Kame,
>> >>
>> > Hi,
>> >
>> >> > I wonder ...how about adding "victim" list for "Reclaim" pages ? Then, we don't need
>> >> > extra LRU rotation.
>> >>
>> >> It can make the code clean.
>> >> As far as I think, victim list does following as.
>> >>
>> >> 1. select victim pages by strong hint
>> >> 2. move the page from LRU to victim
>> >> 3. reclaimer always peeks victim list before diving into LRU list.
>> >> 4-1. If the victim pages is used by others or dirty, it can be moved
>> >> into LRU, again or remain the page in victim list.
>> >> If the page is remained victim, when do we move it into LRU again if
>> >> the reclaimer continues to fail the page?
>> > When sometone touches it.
>> >
>> >> We have to put the new rule.
>> >> 4-2. If the victim pages isn't used by others and clean, we can
>> >> reclaim the page asap.
>> >>
>> >> AFAIK, strong hints are just two(invalidation, readahead max window heuristic).
>> >> I am not sure it's valuable to add new hierarchy(ie, LRU, victim,
>> >> unevictable) for cleaning the minor codes.
>> >> In addition, we have to put the new rule so it would make the LRU code
>> >> complicated.
>> >> I remember how unevictable feature merge is hard.
>> >>
>> > yes, it was hard.
>> >
>> >> But I am not against if we have more usecases. In this case, it's
>> >> valuable to implement it although it's not easy.
>> >>
>> >
>> > I wonder "victim list" can be used for something like Cleancache, when
>> > we have very-low-latency backend devices.
>> > And we may able to have page-cache-limit, which Balbir proposed as.
>>
>> Yes, I thought that, too. I think it would be a good feature in embedded system.
>>
>> >
>> >  - kvictimed? will move unmappedd page caches to victim list
>> > This may work like a InactiveClean list which we had before and make
>> > sizing easy.
>> >
>>
>> Before further discuss, we need customer's confirm.
>> We know very well it is very hard to merge if anyone doesn't use.
>>
>> Balbir, What do think about it?
>>
>
> The idea seems interesting, I am in the process of refreshing my
> patches for unmapped page cache control. I presume the process of
> filling the victim list will be similar to what I have or unmapped
> page cache isolation.

I saw your previous implementation. It doesn't have any benefit from
victim list.
It needs scanning pfns, select unmapped page and move it into victim list.
I think we might need kvictimd as Kame said but I am not convinced.
If I have a trouble with implementing my series, I might think it. But
until now, I think it's not bad and rough test result isn't bad.

To be honest, I think victim list(or cleanlist) is to be another
project. If it is completed, maybe we can make my patches simple.
I approve page cache limit control POV but it should be another project.
So I want to merge this series then if we need really victim list,
let's consider at that time.

Anyway, I will see your next version to find needs of victim list.

>
>>
>> > Thanks,
>> > -Kame
>> >
>> >
>> >
>> >
>>
>>
>>
>> --
>> Kind regards,
>> Minchan Kim
>
> --
>        Three Cheers,
>        Balbir
>



-- 
Kind regards,
Minchan Kim
