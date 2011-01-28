Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1A1InB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:43:01 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45246 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1A1InA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:43:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 17:36:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH 1/4] memcg: fix limit estimation at reclaim for
 hugepage
Message-Id: <20110128173655.7c1d9ebd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTinikUM09bXbLZ5zU1gdgfdPZSQmbycbbeSyGk59@mail.gmail.com>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128122449.e4bb0e5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128134019.27abcfe2.nishimura@mxp.nes.nec.co.jp>
	<20110128135839.d53422e8.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikCjKCtjhRH-ZVsEQN-Luz==8g8e60uxhCTeD2w@mail.gmail.com>
	<20110128081723.GD2213@cmpxchg.org>
	<AANLkTinikUM09bXbLZ5zU1gdgfdPZSQmbycbbeSyGk59@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 17:25:58 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi Hannes,
> 
> On Fri, Jan 28, 2011 at 5:17 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Fri, Jan 28, 2011 at 05:04:16PM +0900, Minchan Kim wrote:
> >> Hi Kame,
> >>
> >> On Fri, Jan 28, 2011 at 1:58 PM, KAMEZAWA Hiroyuki
> >> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> > How about this ?
> >> > ==
> >> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> >
> >> > Current memory cgroup's code tends to assume page_size == PAGE_SIZE
> >> > and arrangement for THP is not enough yet.
> >> >
> >> > This is one of fixes for supporing THP. This adds
> >> > mem_cgroup_check_margin() and checks whether there are required amount of
> >> > free resource after memory reclaim. By this, THP page allocation
> >> > can know whether it really succeeded or not and avoid infinite-loop
> >> > and hangup.
> >> >
> >> > Total fixes for do_charge()/reclaim memory will follow this patch.
> >>
> >> If this patch is only related to THP, I think patch order isn't good.
> >> Before applying [2/4], huge page allocation will retry without
> >> reclaiming and loop forever by below part.
> >>
> >> @@ -1854,9 +1858,6 @@ static int __mem_cgroup_do_charge(struct
> >>       } else
> >>               mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> >>
> >> -     if (csize > PAGE_SIZE) /* change csize and retry */
> >> -             return CHARGE_RETRY;
> >> -
> >>       if (!(gfp_mask & __GFP_WAIT))
> >>               return CHARGE_WOULDBLOCK;
> >>
> >> Am I missing something?
> >
> > No, you are correct.  But I am not sure the order really matters in
> > theory: you have two endless loops that need independent fixing.
> 
> That's why I ask a question.
> Two endless loop?
> 
> One is what I mentioned. The other is what?
> Maybe this patch solve the other.
> But I can't guess it by only this description. Stupid..
> 
> Please open my eyes.
> 

One is.

  if (csize > PAGE_SIZE)
	return CHARGE_RETRY;

By this, reclaim will never be called.


Another is a check after memory reclaim.
==
       ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
                                        gfp_mask, flags);
        /*
         * try_to_free_mem_cgroup_pages() might not give us a full
         * picture of reclaim. Some pages are reclaimed and might be
         * moved to swap cache or just unmapped from the cgroup.
         * Check the limit again to see if the reclaim reduced the
         * current usage of the cgroup before giving up
         */
        if (ret || mem_cgroup_check_under_limit(mem_over_limit))
                return CHARGE_RETRY;
==

ret != 0 if one page is reclaimed. Then, khupaged will retry charge and 
cannot get enough room, reclaim, one page -> again. SO, in busy memcg,
HPAGE_SIZE allocation never fails.

Even if khupaged luckly allocates HPAGE_SIZE, because khugepaged walks vmas
one by one and try to collapse each pmd, under mmap_sem(), this seems a hang by
khugepaged, infinite loop.


Thanks,
-Kame





