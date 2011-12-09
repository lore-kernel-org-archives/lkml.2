Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1LIUhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:37:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1LIUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:37:03 -0500
Date: Fri, 9 Dec 2011 12:37:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [BUGFIX][PATCH v2] add mem_cgroup_replace_page_cache.
Message-Id: <20111209123701.7e43dadf.akpm@linux-foundation.org>
In-Reply-To: <20111208161829.b6101de6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111206123923.1432ab52.kamezawa.hiroyu@jp.fujitsu.com>
	<20111207111455.GA18249@tiehlicka.suse.cz>
	<20111208161829.b6101de6.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011 16:18:29 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> commit ef6a3c6311 adds a function replace_page_cache_page(). This
> function replaces a page in radix-tree with a new page.
> At doing this, memory cgroup need to fix up the accounting information.
> memcg need to check PCG_USED bit etc.
> 
> In some(many?) case, 'newpage' is on LRU before calling replace_page_cache().
> So, memcg's LRU accounting information should be fixed, too.
> 
> This patch adds mem_cgroup_replace_page_cache() and removing old hooks.
> In that function, old pages will be unaccounted without touching res_counter
> and new page will be accounted to the memcg (of old page). At overwriting
> pc->mem_cgroup of newpage, take zone->lru_lock and avoid race with
> LRU handling.
> 
> Background:
>   replace_page_cache_page() is called by FUSE code in its splice() handling.
>   Here, 'newpage' is replacing oldpage but this newpage is not a newly allocated
>   page and may be on LRU. LRU mis-accounting will be critical for memory cgroup
>   because rmdir() checks the whole LRU is empty and there is no account leak.
>   If a page is on the other LRU than it should be, rmdir() will fail.
> 
> Changelog: v1 -> v2
>   - fixed mem_cgroup_disabled() check missing.
>   - added comments.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/memcontrol.h |    6 ++++++
>  mm/filemap.c               |   18 ++----------------
>  mm/memcontrol.c            |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 52 insertions(+), 16 deletions(-)

It's a relatively intrusive patch and I'm a bit concerned about
feeding it into 3.2.

How serious is the bug, and which kernel version(s) do you think we
should fix it in?

