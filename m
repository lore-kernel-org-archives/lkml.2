Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2GKStc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:49:32 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:36400 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab2GKSta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:49:30 -0400
Date: Wed, 11 Jul 2012 11:48:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/11] mm: shmem: do not try to uncharge known swapcache
 pages
In-Reply-To: <20120710171628.GB29114@tiehlicka.suse.cz>
Message-ID: <alpine.LSU.2.00.1207111118310.1797@eggly.anvils>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-4-git-send-email-hannes@cmpxchg.org> <20120709144657.GF4627@tiehlicka.suse.cz> <alpine.LSU.2.00.1207091311300.1842@eggly.anvils> <20120710171628.GB29114@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Michal Hocko wrote:
> On Mon 09-07-12 13:37:39, Hugh Dickins wrote:
> > On Mon, 9 Jul 2012, Michal Hocko wrote:
> > > 
> > > Maybe I am missing something but who does the uncharge from:
> > > shmem_unuse
> > >   mem_cgroup_cache_charge
> > >   shmem_unuse_inode
> > >     shmem_add_to_page_cache
> > 
> > There isn't any special uncharge for shmem_unuse(): once the swapcache
> > page is matched up with its memcg, it will get uncharged by one of the
> > usual routes to swapcache_free() when the page is freed: maybe in the
> > call from __remove_mapping(), maybe when free_page_and_swap_cache()
> > ends up calling it.
> > 
> > Perhaps you're worrying about error (or unfound) paths in shmem_unuse()?
> 
> Yes that was exactly my concern.
> 
> > By the time we make the charge, we know for sure that it's a shmem page,
> > and make the charge appropriately; in racy cases it might get uncharged
> > again in the delete_from_swap_cache().  Can the unfound case occur these
> > days?  
> 
> I cannot find a change that would prevent from that.

Yes.

> 
> > I'd have to think more deeply to answer that, but the charge will
> > not go missing.

Yes, the unfound case certainly can still occur these days.  It's very
similar to the race with truncation/eviction which shmem_unuse_inode()
already allows for (-ENOENT from shmem_add_to_page_cache()).  In that
"error" case, the swap entry got removed after we found it in the
file's radix tree, before we get to replace it there.  Whereas in the
"unfound" case, the swap entry got removed from the file's radix tree
before we even found it there, so we haven't a clue which file it ever
belonged to.

But it doesn't matter.  We have charged the memcg (the original memcg if
memsw is enabled, or swapoff's own if memsw is disabled), and the charge
is redundant now that the page has been truncated; but it's a common
occurrence with swapcache (most common while PageWriteback or PageLocked)
that the swap and charge cannot be released immediately, and it sorts
itself out under pressure once the page reaches the bottom of the
inactive anon and __remove_mapping()'s swapcache_free().

The worst of it is misleading stats meanwhile; but SwapCache has
always been tiresome that way (duplicated in memory and on swap).

The crucial change with regard to unfound entries was back in 2.6.33,
when we added SWAP_MAP_SHMEM: prior to that, we didn't know in advance
if the swap belonged to shmem or to task, and had to be more careful
about when we charge.

Hugh
