Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab2GIUiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:38:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65114 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2GIUiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:38:13 -0400
Date: Mon, 9 Jul 2012 13:37:39 -0700 (PDT)
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
In-Reply-To: <20120709144657.GF4627@tiehlicka.suse.cz>
Message-ID: <alpine.LSU.2.00.1207091311300.1842@eggly.anvils>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-4-git-send-email-hannes@cmpxchg.org> <20120709144657.GF4627@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Michal Hocko wrote:
> 
> Maybe I am missing something but who does the uncharge from:
> shmem_unuse
>   mem_cgroup_cache_charge
>   shmem_unuse_inode
>     shmem_add_to_page_cache

There isn't any special uncharge for shmem_unuse(): once the swapcache
page is matched up with its memcg, it will get uncharged by one of the
usual routes to swapcache_free() when the page is freed: maybe in the
call from __remove_mapping(), maybe when free_page_and_swap_cache()
ends up calling it.

Perhaps you're worrying about error (or unfound) paths in shmem_unuse()?
By the time we make the charge, we know for sure that it's a shmem page,
and make the charge appropriately; in racy cases it might get uncharged
again in the delete_from_swap_cache().  Can the unfound case occur these
days?  I'd have to think more deeply to answer that, but the charge will
not go missing.

Hugh
