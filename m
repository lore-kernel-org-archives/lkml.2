Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1BDJ3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:29:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45583 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab1BDJ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:29:37 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Feb 2011 18:23:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] memcg: no uncharged pages reach
 page_cgroup_zoneinfo
Message-Id: <20110204182321.5ba58fdd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110204092650.GB2289@cmpxchg.org>
References: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
	<1296743166-9412-2-git-send-email-hannes@cmpxchg.org>
	<20110204090145.7f1918fc.kamezawa.hiroyu@jp.fujitsu.com>
	<20110204092650.GB2289@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011 10:26:50 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Feb 04, 2011 at 09:01:45AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu,  3 Feb 2011 15:26:02 +0100
> > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > > All callsites check PCG_USED before passing pc->mem_cgroup, so the
> > > latter is never NULL.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Thank you!
> 
> > I want BUG_ON() here.
> 
> I thought about it too at first.  But look at the callsites, all but
> one of them do not even expect this function to return NULL, so if
> this condition had ever been true, we would have seen crashes in the
> callsites.
> 

Hmm ok.
-Kame

> The only caller that checks for NULL is
> mem_cgroup_get_reclaim_stat_from_page() and I propose to remove that
> as well; patch attached.
> 
> Do you insist on the BUG_ON?
> 
> ---
> Subject: memcg: page_cgroup_zoneinfo never returns NULL
> 
> For a page charged to a memcg, there is always valid memcg per-zone
> info.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4a4483d..5f974b3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1017,9 +1017,6 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
>  	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
>  	smp_rmb();
>  	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
> -	if (!mz)
> -		return NULL;
> -
>  	return &mz->reclaim_stat;
>  }
>  
> 

