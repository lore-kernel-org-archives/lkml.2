Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab1CWFVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 01:21:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42460 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1CWFVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 01:21:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct reclaim path completely
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20110322144950.GA2628@barrios-desktop>
References: <20110322200523.B061.A69D9226@jp.fujitsu.com> <20110322144950.GA2628@barrios-desktop>
Message-Id: <20110323142133.1AC6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 23 Mar 2011 14:21:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

> > zone->all_unreclaimable and zone->pages_scanned are neigher atomic
> > variables nor protected by lock. Therefore a zone can become a state
> > of zone->page_scanned=0 and zone->all_unreclaimable=1. In this case,
> 
> Possible although it's very rare.

Can you test by yourself andrey's case on x86 box? It seems
reprodusable. 

> > current all_unreclaimable() return false even though
> > zone->all_unreclaimabe=1.
> 
> The case is very rare since we reset zone->all_unreclaimabe to zero
> right before resetting zone->page_scanned to zero.
> But I admit it's possible.

Please apply this patch and run oom-killer. You may see following
pages_scanned:0 and all_unreclaimable:yes combination. likes below.
(but you may need >30min)

	Node 0 DMA free:4024kB min:40kB low:48kB high:60kB active_anon:11804kB 
	inactive_anon:0kB active_file:0kB inactive_file:4kB unevictable:0kB 
	isolated(anon):0kB isolated(file):0kB present:15676kB mlocked:0kB 
	dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
	slab_unreclaimable:0kB kernel_stack:0kB pagetables:68kB unstable:0kB 
	bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes


> 
>         CPU 0                                           CPU 1
> free_pcppages_bulk                              balance_pgdat
>         zone->all_unreclaimabe = 0
>                                                         zone->all_unreclaimabe = 1
>         zone->pages_scanned = 0
> > 
> > Is this ignorable minor issue? No. Unfortunatelly, x86 has very
> > small dma zone and it become zone->all_unreclamble=1 easily. and
> > if it becase all_unreclaimable, it never return all_unreclaimable=0
>         ^^^^^ it's very important verb.    ^^^^^ return? reset?
> 
>         I can't understand your point due to the typo. Please correct the typo.
> 
> > beucase it typicall don't have reclaimable pages.
> 
> If DMA zone have very small reclaimable pages or zero reclaimable pages,
> zone_reclaimable() can return false easily so all_unreclaimable() could return
> true. Eventually oom-killer might works.

The point is, vmscan has following all_unreclaimable check in several place.

                        if (zone->all_unreclaimable && priority != DEF_PRIORITY)
                                continue;

But, if the zone has only a few lru pages, get_scan_count(DEF_PRIORITY) return
{0, 0, 0, 0} array. It mean zone will never scan lru pages anymore. therefore
false negative smaller pages_scanned can't be corrected.

Then, false negative all_unreclaimable() also can't be corrected.


btw, Why get_scan_count() return 0 instead 1? Why don't we round up?
Git log says it is intentionally.

	commit e0f79b8f1f3394bb344b7b83d6f121ac2af327de
	Author: Johannes Weiner <hannes@saeurebad.de>
	Date:   Sat Oct 18 20:26:55 2008 -0700

	    vmscan: don't accumulate scan pressure on unrelated lists

> 
> In my test, I saw the livelock, too so apparently we have a problem.
> I couldn't dig in it recently by another urgent my work.
> I think you know root cause but the description in this patch isn't enough
> for me to be persuaded.
> 
> Could you explain the root cause in detail?

If you have an another fixing idea, please let me know. :)



