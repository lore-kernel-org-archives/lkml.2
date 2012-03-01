Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab2CAKAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:00:49 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:47239 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab2CAKAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:00:48 -0500
Date: Thu, 1 Mar 2012 11:00:35 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 next] memcg: fix deadlock by avoiding stat lock when
 anon
Message-ID: <20120301100035.GC1665@cmpxchg.org>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
 <alpine.LSU.2.00.1202282125240.4875@eggly.anvils>
 <20120229193517.GD1673@cmpxchg.org>
 <alpine.LSU.2.00.1202291648340.11821@eggly.anvils>
 <alpine.LSU.2.00.1202291843120.14002@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1202291843120.14002@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 06:44:59PM -0800, Hugh Dickins wrote:
> Fix deadlock in "memcg: use new logic for page stat accounting".
> 
> page_remove_rmap() first calls mem_cgroup_begin_update_page_stat(),
> which may take move_lock_mem_cgroup(), unlocked at the end of
> page_remove_rmap() by mem_cgroup_end_update_page_stat().
> 
> The PageAnon case never needs to mem_cgroup_dec_page_stat(page,
> MEMCG_NR_FILE_MAPPED); but it often needs to mem_cgroup_uncharge_page(),
> which does lock_page_cgroup(), while holding that move_lock_mem_cgroup().
> Whereas mem_cgroup_move_account() calls move_lock_mem_cgroup() while
> holding lock_page_cgroup().
> 
> Since mem_cgroup_begin and end are unnecessary here for PageAnon,
> simply avoid the deadlock and wasted calls in that case.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Agreed, let's keep that lock ordering for now, and the comment makes
it clear.  Thanks!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
