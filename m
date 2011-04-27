Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1D0IBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:01:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38771 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1D0IBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:01:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Apr 2011 16:54:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 1/8] Only isolate page we can handle
Message-Id: <20110427165437.bef6967a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1d9791f27df2341cb6750f5d6279b804151f57f9.1303833417.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<1d9791f27df2341cb6750f5d6279b804151f57f9.1303833417.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 01:25:18 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> There are some places to isolate lru page and I believe
> users of isolate_lru_page will be growing.
> The purpose of them is each different so part of isolated pages
> should put back to LRU, again.
> 
> The problem is when we put back the page into LRU,
> we lose LRU ordering and the page is inserted at head of LRU list.
> It makes unnecessary LRU churning so that vm can evict working set pages
> rather than idle pages.
> 
> This patch adds new filter mask when we isolate page in LRU.
> So, we don't isolate pages if we can't handle it.
> It could reduce LRU churning.
> 
> This patch shouldn't change old behavior.
> It's just used by next patches.
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

nitpick below.

> ---
>  include/linux/swap.h |    3 ++-
>  mm/compaction.c      |    2 +-
>  mm/memcontrol.c      |    2 +-
>  mm/vmscan.c          |   26 ++++++++++++++++++++------
>  4 files changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 384eb5f..baef4ad 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -259,7 +259,8 @@ extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>  						unsigned int swappiness,
>  						struct zone *zone,
>  						unsigned long *nr_scanned);
> -extern int __isolate_lru_page(struct page *page, int mode, int file);
> +extern int __isolate_lru_page(struct page *page, int mode, int file,
> +				int not_dirty, int not_mapped);

Hmm, which is better to use 4 binary args or a flag with bitmask ?

Thanks,
-Kame

