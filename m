Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1D0INa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:13:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61603 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab1D0IN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l4/omQXAGl4wO3ZgSlmqG2BZRTQ4ciNx2VRVEevh/GeNNF3Vb2jl3gz8e6CR+rqAaU
         lqA3SJY7EjuGYbLC/F+FM4SVPxLFPss242PyjumMTX7q1Y/qB4vSBcRJZ5v40I+54+3F
         ZSES/iBhDbhRBDVROqfTGHEd4771BUxM/RfIM=
MIME-Version: 1.0
In-Reply-To: <1d9791f27df2341cb6750f5d6279b804151f57f9.1303833417.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<1d9791f27df2341cb6750f5d6279b804151f57f9.1303833417.git.minchan.kim@gmail.com>
Date: Wed, 27 Apr 2011 17:13:27 +0900
Message-ID: <BANLkTi=Hh03JeQO+oBx1rJ8wP--a=iHgDw@mail.gmail.com>
Subject: Re: [RFC 1/8] Only isolate page we can handle
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 1:25 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
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
> ---
>  include/linux/swap.h |    3 ++-
>  mm/compaction.c      |    2 +-
>  mm/memcontrol.c      |    2 +-
>  mm/vmscan.c          |   26 ++++++++++++++++++++------
>  4 files changed, 24 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 384eb5f..baef4ad 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -259,7 +259,8 @@ extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>                                                unsigned int swappiness,
>                                                struct zone *zone,
>                                                unsigned long *nr_scanned);
> -extern int __isolate_lru_page(struct page *page, int mode, int file);
> +extern int __isolate_lru_page(struct page *page, int mode, int file,
> +                               int not_dirty, int not_mapped);
>  extern unsigned long shrink_all_memory(unsigned long nr_pages);
>  extern int vm_swappiness;
>  extern int remove_mapping(struct address_space *mapping, struct page *page);
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 021a296..dea32e3 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -335,7 +335,7 @@ static unsigned long isolate_migratepages(struct zone *zone,
>                }
>
>                /* Try isolate the page */
> -               if (__isolate_lru_page(page, ISOLATE_BOTH, 0) != 0)
> +               if (__isolate_lru_page(page, ISOLATE_BOTH, 0, 0, 0) != 0)
>                        continue;
>
>                VM_BUG_ON(PageTransCompound(page));
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c2776f1..471e7fd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1193,7 +1193,7 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>                        continue;
>
>                scan++;
> -               ret = __isolate_lru_page(page, mode, file);
> +               ret = __isolate_lru_page(page, mode, file, 0, 0);
>                switch (ret) {
>                case 0:
>                        list_move(&page->lru, dst);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b3a569f..71d2da9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -954,10 +954,13 @@ keep_lumpy:
>  *
>  * page:       page to consider
>  * mode:       one of the LRU isolation modes defined above
> - *
> + * file:       page be on a file LRU
> + * not_dirty:  page should be not dirty or not writeback
> + * not_mapped: page should be not mapped
>  * returns 0 on success, -ve errno on failure.
>  */
> -int __isolate_lru_page(struct page *page, int mode, int file)
> +int __isolate_lru_page(struct page *page, int mode, int file,
> +                               int not_dirty, int not_mapped)
>  {
>        int ret = -EINVAL;
>
> @@ -976,6 +979,12 @@ int __isolate_lru_page(struct page *page, int mode, int file)
>        if (mode != ISOLATE_BOTH && page_is_file_cache(page) != file)
>                return ret;
>
> +       if (not_dirty)
> +               if (PageDirty(page) || PageWriteback(page))
> +                       return ret;
> +       if (not_mapped)
> +               if (page_mapped(page))
> +                       return ret;

I should have fixed this return value.
Now caller regards -EINVAL with BUG.
I will fix it in next version.

-- 
Kind regards,
Minchan Kim
