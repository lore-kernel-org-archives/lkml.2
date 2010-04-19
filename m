Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0DSINS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:13:18 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65259 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0DSINR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:13:17 -0400
Date: Mon, 19 Apr 2010 17:07:01 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][BUGFIX][PATCH 2/2] memcg: fix file mapped underflow at
 migration (v3)
Message-Id: <20100419170701.3864992e.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100419131817.f263d93c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100413134207.f12cdc9c.nishimura@mxp.nes.nec.co.jp>
	<20100415120516.3891ce46.kamezawa.hiroyu@jp.fujitsu.com>
	<20100415120652.c577846f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100416193143.5807d114.kamezawa.hiroyu@jp.fujitsu.com>
	<20100419124225.91f3110b.nishimura@mxp.nes.nec.co.jp>
	<20100419131817.f263d93c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for explaining in detail.

On Mon, 19 Apr 2010 13:18:17 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 19 Apr 2010 12:42:25 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > Hmm, before going further, will you explain why we need a new PCG_MIGRATION flag ?
> > What's the problem of v2 ?
> > 
> 
> v2 can't handle migration-failure case of freed swapcache and the used page
> was swapped-out case. I think.
> 
> All "page" in following is ANON.
> 
> 
>      mem_cgroup_prepare_migration()
> 	     charge against new page.
>      
>      try_to_unmap()
>         -> mapcount goes down to 0.
>              -> an old page is unchaged
>      
But old page isn't uncharged iff PageSwapCache, is it ?

>      move_to_new_page()
>         -> may fail. (in some case.)   ----(*1)
> 
>      remap the old page to pte.
> 
>      mem_cgroup_end_migration()
> 		(at success *1)
> 		check charge for newpage is valid or not (*2)
> 
> 		(at fail *1)
> 		uncharge new page.
> 		What we should do for an old page. ---(*3)
> 
> At (*2). (*3), there are several cases.
> 
> (*2) migration was succeeded.
>     1. The new page was successfully remapped.
> 	-> Nothing to do.
>     2. The new page was remapped but finally unmapped before (*3)
> 	-> page_remove_rmap() will catch the event.
>     3. The new page was not remapped.
> 	-> page_remove_rmap() can't catch the event. end_migraion() has to
> 	uncharge it.
> 
> (*3) migration was failed.
>     1. The old page was successfully remapped.
> 	-> We have to recharge against the old page. (But it may hit OOM.)
>     2. The old page wasn't remapped.
>         -> mapcount is 0. No new charge will happen.
>     3. The old page wasn't remapped but SwapCache.
>         -> mapcount is 0. We have to recharge against the old page (But it may hit OOM)
> 
hmm, we've done try_charge at this point, so why can we cause oom here ?

> Maybe other seqence I couldn't write will exist......IMHO, "we have to recharge it because
> it's uncharged.." is bad idea. It seems hard to maintainace..
> 
> 
> When we use MIGRATION flag.
> After migaration.
> 
>     1. Agaisnt new page, we remove MIGRATION flag and try to uncharge() it again.
> 
>     2. Agaisnt old page, we remove MIGRATION flag and try to uncharge it again.
> 
> NOTE:  I noticed my v3 patch is buggy when the page-is-swapped-out case. It seems
>        mem_cgroup_uncharge_swapcache() has to wait for migration ends or some
>        other case handling. (Anyway, this race exists only after unlock_page(newpage).
>        So, wait for MIGRATION ends in spin will not be very bad.)
> 
> 
> To me, things are much simpler than now, we have to know what kind of magics behind us...
> 
> Maybe I can think of other tricks for handling them...but using a FLAG and prevent uncharge
> is the simplest, I think.
> 
Anyway, I agree that current implementation is complicated and there might be
some cases we are missing. MIGRATION flag can make it simpler.

I have one concern for now. Reading the patch, the flag have influence on
only anonymous pages, so we'd better to note it and I feel it strange to
set(and clear) the flag of "old page" always(iow, even when !PageAnon)
in prepare_migration.


Thanks,
Daisuke Nishimura.
