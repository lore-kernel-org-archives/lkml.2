Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2BPCFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:05:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48550 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2BPCFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:05:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Feb 2012 11:04:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH RFC 00/15] mm: memory book keeping and lru_lock
 splitting
Message-Id: <20120216110408.f35c3448.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120215224221.22050.80605.stgit@zurg>
References: <20120215224221.22050.80605.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 02:57:04 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> There should be no logic changes in this patchset, this is only tossing bits around.
> [ This patchset is on top some memcg cleanup/rework patches,
>   which I sent to linux-mm@ today/yesterday ]
> 
> Most of things in this patchset are self-descriptive, so here brief plan:
> 

AFAIK, Hugh Dickins said he has per-zone-per-lru-lock and is testing it.
So, please CC him and Johannes, at least.


> * Transmute struct lruvec into struct book. Like real book this struct will
>   store set of pages for one zone. It will be working unit for reclaimer code.
> [ If memcg is disabled in config there will only one book embedded into struct zone ]
> 

Why you need to add new structure rahter than enhancing lruvec ?
"book" means a binder of pages ?


> * move page-lru counters to struct book
> [ this adds extra overhead in add_page_to_lru_list()/del_page_from_lru_list() for
>   non-memcg case, but I believe it will be invisible, only one non-atomic add/sub
>   in the same cacheline with lru list ]
> 

This seems straightforward.

> * unify inactive_list_is_low_global() and cleanup reclaimer code
> * replace struct mem_cgroup_zone with single pointer to struct book

Hm, ok.

> * optimize page to book translations, move it upper in the call stack,
>   replace some struct zone arguments with struct book pointer.
> 

a page->book transrater from patch 2/15

+struct book *page_book(struct page *page)
+{
+	struct mem_cgroup_per_zone *mz;
+	struct page_cgroup *pc;
+
+	if (mem_cgroup_disabled())
+		return &page_zone(page)->book;
+
+	pc = lookup_page_cgroup(page);
+	if (!PageCgroupUsed(pc))
+		return &page_zone(page)->book;
+	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
+	smp_rmb();
+	mz = mem_cgroup_zoneinfo(pc->mem_cgroup,
+			page_to_nid(page), page_zonenum(page));
+	return &mz->book;
+}

What happens when pc->mem_cgroup is rewritten by move_account() ?
Where is the guard for lockless access of this ?

Thanks,
-Kame

