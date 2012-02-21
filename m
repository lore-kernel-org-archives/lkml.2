Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2BUJS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 04:18:59 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42469 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2BUJS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 04:18:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Feb 2012 18:17:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] mm/memcg: remove mem_cgroup_reset_owner
Message-Id: <20120221181728.3778b1fd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1202201534340.23274@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils>
	<alpine.LSU.2.00.1202201534340.23274@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 15:35:38 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> With mem_cgroup_reset_uncharged_to_root() now making sure that freed
> pages point to root_mem_cgroup (instead of to a stale and perhaps
> long-deleted memcg), we no longer need to initialize page memcg to
> root in those odd places which put a page on lru before charging. 
> Delete mem_cgroup_reset_owner().
> 
> But: we have no init_page_cgroup() nowadays (and even when we had,
> it was called before root_mem_cgroup had been allocated); so until
> a struct page has once entered the memcg lru cycle, its page_cgroup
> ->mem_cgroup will be NULL instead of root_mem_cgroup.
> 
> That could be fixed by reintroducing init_page_cgroup(), and ordering
> properly: in future we shall probably want root_mem_cgroup in kernel
> bss or data like swapper_space; but let's not get into that right now.
> 
> Instead allow for this in page_relock_lruvec(): treating NULL as
> root_mem_cgroup, and correcting pc->mem_cgroup before going further.
> 
> What?  Before even taking the zone->lru_lock?  Is that safe?
> Yes, because compaction and lumpy reclaim use __isolate_lru_page(),
> which refuses unless it sees PageLRU - which may be cleared at any
> instant, but we only need it to have been set once in the past for
> pc->mem_cgroup to be initialized properly.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Ok, this seems to be much better than current reset_owner().

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks,
-Kame


