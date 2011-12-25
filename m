Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1LYKWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 05:22:16 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26613 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1LYKWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 05:22:14 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 80.237.6.56
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19bWMN6IyFIIdZ59keBrkh2G6i4e4McHyA=
Message-ID: <1324808519.29243.8.camel@hakkenden.homenet>
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
From: "Nikolay S." <nowhere@hakkenden.ath.cx>
To: Hillf Danton <dhillf@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Sun, 25 Dec 2011 14:21:59 +0400
In-Reply-To: <CAJd=RBDa4LT1gbh6zPx+bzoOtSUeX=puJe6DVC-WyKoF4nw-dg@mail.gmail.com>
References: <1324437036.4677.5.camel@hakkenden.homenet>
	 <20111221095249.GA28474@tiehlicka.suse.cz> <20111221225512.GG23662@dastard>
	 <1324630880.562.6.camel@rybalov.eng.ttk.net>
	 <20111223102027.GB12731@dastard>
	 <1324638242.562.15.camel@rybalov.eng.ttk.net>
	 <20111223204503.GC12731@dastard>
	 <CAJd=RBDa4LT1gbh6zPx+bzoOtSUeX=puJe6DVC-WyKoF4nw-dg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вс., 25/12/2011 в 17:09 +0800, Hillf Danton пишет:
> On Sat, Dec 24, 2011 at 4:45 AM, Dave Chinner <david@fromorbit.com> wrote:
> [...]
> >
> > Ok, it's not a shrink_slab() problem - it's just being called ~100uS
> > by kswapd. The pattern is:
> >
> >        - reclaim 94 (batches of 32,32,30) pages from iinactive list
> >          of zone 1, node 0, prio 12
> >        - call shrink_slab
> >                - scan all caches
> >                - all shrinkers return 0 saying nothing to shrink
> >        - 40us gap
> >        - reclaim 10-30 pages from inactive list of zone 2, node 0, prio 12
> >        - call shrink_slab
> >                - scan all caches
> >                - all shrinkers return 0 saying nothing to shrink
> >        - 40us gap
> >        - isolate 9 pages from LRU zone ?, node ?, none isolated, none freed
> >        - isolate 22 pages from LRU zone ?, node ?, none isolated, none freed
> >        - call shrink_slab
> >                - scan all caches
> >                - all shrinkers return 0 saying nothing to shrink
> >        40us gap
> >
> > And it just repeats over and over again. After a while, nid=0,zone=1
> > drops out of the traces, so reclaim only comes in batches of 10-30
> > pages from zone 2 between each shrink_slab() call.
> >
> > The trace starts at 111209.881s, with 944776 pages on the LRUs. It
> > finishes at 111216.1 with kswapd going to sleep on node 0 with
> > 930067 pages on the LRU. So 7 seconds to free 15,000 pages (call it
> > 2,000 pages/s) which is awfully slow....
> >
> Hi all,
> 
> In hope, the added debug info is helpful.
> 
> Hillf
> ---
> 
> --- a/mm/memcontrol.c	Fri Dec  9 21:57:40 2011
> +++ b/mm/memcontrol.c	Sun Dec 25 17:08:14 2011
> @@ -1038,7 +1038,11 @@ void mem_cgroup_lru_del_list(struct page
>  		memcg = root_mem_cgroup;
>  	mz = page_cgroup_zoneinfo(memcg, page);
>  	/* huge page split is done under lru_lock. so, we have no races. */
> -	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
> +	if (WARN_ON_ONCE(MEM_CGROUP_ZSTAT(mz, lru) <
> +				(1 << compound_order(page))))
> +		MEM_CGROUP_ZSTAT(mz, lru) = 0;
> +	else
> +		MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
>  }
> 
>  void mem_cgroup_lru_del(struct page *page)

Hello,

Uhm.., is this patch against 3.2-rc4? I can not apply it. There's no
mem_cgroup_lru_del_list(), but void mem_cgroup_del_lru_list(). Should I
place changes there?

And also, -rc7 is here. May the problem be addressed as part of some
ongoing work? Is there any reason to try -rc7 (the problem requires
several days of uptime to become obvious)?

