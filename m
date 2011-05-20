Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751Ab1ETARQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:17:16 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37633 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933982Ab1ETARK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SGLpXDFIkL9haTVF3QA9E5KsR6T9xC3W+/PebdB1LcLK9iUX/sRxkv/7/5ZfWN4RuB
         K0hbnyCTw/z/skme+ntWNzY+JV9C3+KR0+Z748X7s9WGE/Kp2wDZIgy7PMsRH19GXYGM
         PEeQXjHiH6x6WVtvLWeUb1SB7Ir9P6EeziwZU=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
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
	<BANLkTima0hPrPwe_x06afAh+zTi-bOcRMg@mail.gmail.com>
	<BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
Date: Fri, 20 May 2011 09:17:09 +0900
Message-ID: <BANLkTim7j=q=SANBMOrSbzJKB_rMCNk4Vw@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
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

On Thu, May 19, 2011 at 11:16 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> I just booted 2.6.38.6 with exactly two patches applied.  Config was
> the same as I emailed yesterday.  Userspace is F15.  First was
> "aesni-intel: Merge with fpu.ko" because dracut fails to boot my
> system without it.  Second was this (sorry for whitespace damage):
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0665520..3f44b81 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -307,7 +307,7 @@ static void set_reclaim_mode(int priority, struct
> scan_control *sc,
>         */
>        if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
>                sc->reclaim_mode |= syncmode;
> -       else if (sc->order && priority < DEF_PRIORITY - 2)
> +       else if ((sc->order && priority < DEF_PRIORITY - 2) ||
> priority <= DEF_PRIORITY / 3)
>                sc->reclaim_mode |= syncmode;
>        else
>                sc->reclaim_mode = RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC;
> @@ -1342,10 +1342,6 @@ static inline bool
> should_reclaim_stall(unsigned long nr_taken,
>        if (current_is_kswapd())
>                return false;
>
> -       /* Only stall on lumpy reclaim */
> -       if (sc->reclaim_mode & RECLAIM_MODE_SINGLE)
> -               return false;
> -
>        /* If we have relaimed everything on the isolated list, no stall */
>        if (nr_freed == nr_taken)
>                return false;
>
> I started GNOME and Firefox, enabled swap, and ran test_mempressure.sh
> 1500 1400 1.  The system quickly gave the attached oops.
>
> The oops was the ud2 here:
>
>   0xffffffff810d251b <+215>:   mov    -0x28(%rbx),%rax
>   0xffffffff810d251f <+219>:   test   $0x40,%al
>   0xffffffff810d2521 <+221>:   je     0xffffffff810d2525 <shrink_page_list+225>
>   0xffffffff810d2523 <+223>:   ud2
>
> Please let me know what the next test to run is.

Okay. My first patch(!pgdat_balanced and cond_resched right after
balance_pgdat) sent you was successful. But the version removed
cond_resched was hang.

Let's not make the problem complex.
So let's put aside the above my patch.

Would you be willing to test one more with below patch?
(Of course, it would be damage by white space. I can't do anything for
it in my office. Sorry.)
If below patch still fix your problem like my first patch, we will
push this patch into mainline.

Thanks. Andrew.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 292582c..1663d24 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -231,8 +231,11 @@ unsigned long shrink_slab(struct shrink_control *shrink,
        if (scanned == 0)
                scanned = SWAP_CLUSTER_MAX;

-       if (!down_read_trylock(&shrinker_rwsem))
-               return 1;       /* Assume we'll be able to shrink next time */
+       if (!down_read_trylock(&shrinker_rwsem)) {
+               /* Assume we'll be able to shrink next time */
+               ret = 1;
+               goto out;
+       }

        list_for_each_entry(shrinker, &shrinker_list, list) {
                unsigned long long delta;
@@ -286,6 +289,8 @@ unsigned long shrink_slab(struct shrink_control *shrink,
                shrinker->nr += total_scan;
        }
        up_read(&shrinker_rwsem);
+out:
+       cond_resched();
        return ret;
 }

@@ -2331,7 +2336,7 @@ static bool sleeping_prematurely(pg_data_t
*pgdat, int order, long remaining,
         * must be balanced
         */
        if (order)
-               return pgdat_balanced(pgdat, balanced, classzone_idx);
+               return !pgdat_balanced(pgdat, balanced, classzone_idx);
        else
                return !all_zones_ok;
 }



>
> --Andy
>



-- 
Kind regards,
Minchan Kim
