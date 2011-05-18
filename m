Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1ERFRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:17:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42532 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1ERFRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G5vsWimlAtsfY2+iF1WszG9MshoBlM6vA+3Ywt1Z7vx0LaVklxTigdHKZvoVOCQexM
         LmuyWrZQllyEHSllP5lKHpgrOvWkty9MBkiHCmtGNut6moHbFqYBrAjnGDR9DfyAU1xe
         HUr90NwZ8X841ct95zP3lQiO+9lFtzB/ZcHZY=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=TOm3aLQCD6j=4va6B+Jn2nSfwAg@mail.gmail.com>
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
Date: Wed, 18 May 2011 14:17:17 +0900
Message-ID: <BANLkTi=9W6-JXi94rZfTtTpAt3VUiY5fNw@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 4:22 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Tue, May 17, 2011 at 2:00 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> On Sun, May 15, 2011 at 12:12:36PM -0400, Andrew Lutomirski wrote:
>>> On Sun, May 15, 2011 at 11:27 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>>>
>>> That was probably because one of my testcases creates a 1.4GB file on
>>> ramfs.  (I can provoke the problem without doing evil things like
>>> that, but the test script is rather reliable at killing my system and
>>> it works fine on my other machines.)
>>
>> Ah I didn't read your first email.. I'm now running
>>
>> ./test_mempressure.sh 1500 1400 1
>>
>> with mem=2G and no swap, but cannot reproduce OOM.
>
> Do you have a Sandy Bridge laptop?  There was a recent thread on lkml
> suggesting that only Sandy Bridge laptops saw this problem.  Although
> there's something else needed to trigger it, because I can't do it
> from an initramfs I made that tried to show this problem.
>
>>
>> What's your kconfig?
>
> Attached.  This is 2.6.38.6.
>
>>
>>> If you want, I can try to generate a trace that isn't polluted with
>>> the evil ramfs file.
>>
>> No, thanks. However it would be valuable if you can retry with this
>> patch _alone_ (without the "if (need_resched()) return false;" change,
>> as I don't see how it helps your case).
>>
>> @@ -2286,7 +2290,7 @@ static bool sleeping_prematurely(pg_data_t
>> *pgdat, int order, long remaining,
>>        * must be balanced
>>        */
>>       if (order)
>> -               return pgdat_balanced(pgdat, balanced, classzone_idx);
>> +               return !pgdat_balanced(pgdat, balanced, classzone_idx);
>>       else
>>               return !all_zones_ok;
>>  }
>
> Done.
>
> I logged in, added swap, and ran a program that allocated 1900MB of
> RAM and memset it.  The system lagged a bit but survived.  kswapd
> showed 10% CPU (which is odd, IMO, since I'm using aesni-intel and I
> think that all the crypt happens in kworker when aesni-intel is in
> use).

I think kswapd could use 10% enough for reclaim.

>
> Then I started Firefox, loaded gmail, and ran test_mempressure.sh.
> Kaboom!  (I.e. system was hung)  SysRq-F saved the system and produced

Hang?
It means you see softhangup of kswapd? or mouse/keyboard doesn't move?

> the attached dump.  I had 6GB swap available, so there shouldn't have
> been any OOM.

Yes. It's strange but we have seen such case several times, AFAIR.

Let see your first OOM message.
(Intentionally, I don't inline OOM message as Web Gmail mangles it and
whoever see it is very annoying.)

If it consider min/low/high of zones, any zones can't meet your
allocation request. (order-0, GFP_WAIT|IO|FS|HIGHMEM). So the result
is natural.
But thing I wonder is that we have lots of free swap space as you said.
Why doesn't VM swap out anon pages of DMA32 zone and then happen OOM?

We are going to isolate anon pages of DMA32 as log said(ie,
isolated(anon):408kB)
So I think VM is going on rightly.
The thing is task speed of request allocation is faster than swapout's
speed. So swap device is very congested and most of swapout pages
would remain PG_writeback. In the end, shrink_page_list returns 0.

In high-order page reclaim, we can adjust task's speed by should_reclaim_stall.
But for order-0 page, should_reclaim_stall returns _false_ and at last
we can see OOM message although swap has lots of free space.
Does my guessing make sense?
If it is, does it make sense that OOM happens despite we have lots of
swap space in case of order-0?
How about this?

Andrew, Could you test this patch with !pgdat_balanced patch?
I think we shouldn't see OOM message if we have lots of free swap space.

== CUT_HERE ==
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f73b865..cc23f04 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1341,10 +1341,6 @@ static inline bool
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



Then, if you don't see any unnecessary OOM but still see the hangup,
could you apply this patch based on previous?

== CUT_HERE ==

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f73b865..703380f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2697,6 +2697,7 @@ static int kswapd(void *p)
                if (!ret) {
                        trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
                        order = balance_pgdat(pgdat, order, &classzone_idx);
+                       cond_resched();
                }
        }
        return 0;

-- 
Kind regards,
Minchan Kim
