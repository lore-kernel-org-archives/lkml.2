Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1ESCyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:54:08 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55133 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab1ESCyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BGch+TGeCqX7Kvp2sMwD/q6lka4PMrzhuuOZ8R9oudTRF9B9T8isTVZdAXZ2FStHff
         hSscAC4UJoZDAk5UGFFWWjzmoZYbEYsl+k36T2v20DM+sAHuJassPZwFCWOmy0EfG0T5
         bPIqDMJNAC7Rmzkab4w+t+56xOjqutrqH9GS0=
MIME-Version: 1.0
In-Reply-To: <BANLkTikHMUru=w4zzRmosrg2bDbsFWrkTQ@mail.gmail.com>
References: <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
	<20110512054631.GI6008@one.firstfloor.org>
	<BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
	<BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
	<20110514165346.GV6008@one.firstfloor.org>
	<BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
	<20110514174333.GW6008@one.firstfloor.org>
	<BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
	<20110515152747.GA25905@localhost>
	<BANLkTim-AnEeL=z1sYm=iN7sMnG0+m0SHw@mail.gmail.com>
	<20110517060001.GC24069@localhost>
	<BANLkTi=TOm3aLQCD6j=4va6B+Jn2nSfwAg@mail.gmail.com>
	<BANLkTi=9W6-JXi94rZfTtTpAt3VUiY5fNw@mail.gmail.com>
	<BANLkTikHMUru=w4zzRmosrg2bDbsFWrkTQ@mail.gmail.com>
Date: Thu, 19 May 2011 11:54:05 +0900
Message-ID: <BANLkTima0hPrPwe_x06afAh+zTi-bOcRMg@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 11:15 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Wed, May 18, 2011 at 1:17 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> On Wed, May 18, 2011 at 4:22 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>> No, thanks. However it would be valuable if you can retry with this
>>>> patch _alone_ (without the "if (need_resched()) return false;" change,
>>>> as I don't see how it helps your case).
>>>>
>>>> @@ -2286,7 +2290,7 @@ static bool sleeping_prematurely(pg_data_t
>>>> *pgdat, int order, long remaining,
>>>>        * must be balanced
>>>>        */
>>>>       if (order)
>>>> -               return pgdat_balanced(pgdat, balanced, classzone_idx);
>>>> +               return !pgdat_balanced(pgdat, balanced, classzone_idx);
>>>>       else
>>>>               return !all_zones_ok;
>>>>  }
>>>
>>> Done.
>>>
>>> I logged in, added swap, and ran a program that allocated 1900MB of
>>> RAM and memset it.  The system lagged a bit but survived.  kswapd
>>> showed 10% CPU (which is odd, IMO, since I'm using aesni-intel and I
>>> think that all the crypt happens in kworker when aesni-intel is in
>>> use).
>>
>> I think kswapd could use 10% enough for reclaim.
>>
>>>
>>> Then I started Firefox, loaded gmail, and ran test_mempressure.sh.
>>> Kaboom!  (I.e. system was hung)  SysRq-F saved the system and produced
>>
>> Hang?
>> It means you see softhangup of kswapd? or mouse/keyboard doesn't move?
>
> Mouse and keyboard dead.
>
>> Andrew, Could you test this patch with !pgdat_balanced patch?
>> I think we shouldn't see OOM message if we have lots of free swap space.
>>
>> == CUT_HERE ==
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index f73b865..cc23f04 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1341,10 +1341,6 @@ static inline bool
>> should_reclaim_stall(unsigned long nr_taken,
>>        if (current_is_kswapd())
>>                return false;
>>
>> -       /* Only stall on lumpy reclaim */
>> -       if (sc->reclaim_mode & RECLAIM_MODE_SINGLE)
>> -               return false;
>> -
>>        /* If we have relaimed everything on the isolated list, no stall */
>>        if (nr_freed == nr_taken)
>>                return false;
>>
>>
>>
>> Then, if you don't see any unnecessary OOM but still see the hangup,
>> could you apply this patch based on previous?
>
> With this patch, I started GNOME and Firefox, turned on swap, and ran
> test_mempressure.sh 1500 1400 1.  Instant panic (or OOPS and hang or
> something -- didn't get the top part).  Picture attached -- it looks
> like memcg might be involved.  I'm running F15, so it might even be
> doing something.

I cannot figure out why happens OOPS.
Let me know your kernel version and config.
Kame. Is there anything related to memcg you guess?

In addition, the patch I give was utterly stupid.
The goal is that we wait dirty page writeback in (order-0 | high
priority) reclaim.
(But I don't think it's ideal solution in this problem but just for
proving the problem)
But although we pass sync with 1 in set_reclaim_mode, it ignores.
So fix is following as. (NOTICE: It doesn't related to your OOPS. )
But before further experiment, let's fix your oops.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 292582c..69d317e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -311,7 +311,8 @@ static void set_reclaim_mode(int priority, struct
scan_control *sc,
         */
        if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
                sc->reclaim_mode |= syncmode;
-       else if (sc->order && priority < DEF_PRIORITY - 2)
+       else if ((sc->order && priority < DEF_PRIORITY - 2) ||
+                               prioiry <= DEF_PRIORITY / 3)
                sc->reclaim_mode |= syncmode;
        else
                sc->reclaim_mode = RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC;
@@ -1349,10 +1350,6 @@ static inline bool
should_reclaim_stall(unsigned long nr_taken,
        if (current_is_kswapd())
                return false;

-       /* Only stall on lumpy reclaim */
-       if (sc->reclaim_mode & RECLAIM_MODE_SINGLE)
-               return false;
-
        /* If we have relaimed everything on the isolated list, no stall */
        if (nr_freed == nr_taken)
                return false;



>
> I won't be able to get netconsole dumps until next week because I'm
> out of town and only have this one computer here.

No problem. :)
We should avoid OOPS for the experiment.


>
> I haven't tried the other patch.
>
> Also, the !pgdat_balanced fix plus the if (need_resched()) return
> false patch just hung once on 2.6.37-rc9.  I don't know what triggered

Thanks for the good information.
It seems need_resched patch isn't good candidate to fix current problem.
We already weeded it out.

Thank you very much for the testing!

> it.  Maybe yum.
>
> --Andy
>



-- 
Kind regards,
Minchan Kim
