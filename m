Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2BPIZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 03:25:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44155 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2BPIZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 03:25:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Feb 2012 17:24:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH RFC 00/15] mm: memory book keeping and lru_lock
 splitting
Message-Id: <20120216172409.5fa18608.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4F3C9798.7050800@openvz.org>
References: <20120215224221.22050.80605.stgit@zurg>
	<20120216110408.f35c3448.kamezawa.hiroyu@jp.fujitsu.com>
	<4F3C9798.7050800@openvz.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 09:43:52 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Thu, 16 Feb 2012 02:57:04 +0400
> > Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:

> >> * optimize page to book translations, move it upper in the call stack,
> >>    replace some struct zone arguments with struct book pointer.
> >>
> >
> > a page->book transrater from patch 2/15
> >
> > +struct book *page_book(struct page *page)
> > +{
> > +	struct mem_cgroup_per_zone *mz;
> > +	struct page_cgroup *pc;
> > +
> > +	if (mem_cgroup_disabled())
> > +		return&page_zone(page)->book;
> > +
> > +	pc = lookup_page_cgroup(page);
> > +	if (!PageCgroupUsed(pc))
> > +		return&page_zone(page)->book;
> > +	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
> > +	smp_rmb();
> > +	mz = mem_cgroup_zoneinfo(pc->mem_cgroup,
> > +			page_to_nid(page), page_zonenum(page));
> > +	return&mz->book;
> > +}
> >
> > What happens when pc->mem_cgroup is rewritten by move_account() ?
> > Where is the guard for lockless access of this ?
> 
> Initially this suppose to be protected with lru_lock, in final patch they are protected with rcu.

Hmm, VM_BUG_ON(!PageLRU(page)) ?

move_account() overwrites pc->mem_cgroup with isolating page from LRU.
but it doesn't take lru_lock.

BTW, what amount of perfomance benefit ?

Thanks,
-Kame

