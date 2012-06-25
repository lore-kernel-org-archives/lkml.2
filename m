Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab2FYXbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:31:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37126 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab2FYXbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:31:39 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
References: <cover.1340665087.git.aquini@redhat.com>
	<7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
Date: Mon, 25 Jun 2012 19:31:38 -0400
X-Google-Sender-Auth: 55JCq_sVDFwJ2_gvbTbehEU-a8c
Message-ID: <CAPbh3rvN0U=xVuqb=7wHkbEAgM=dC67uG-1=m=8GAv9MNX7LWg@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 7:25 PM, Rafael Aquini <aquini@redhat.com> wrote:
> This patch introduces helper functions that teach compaction and migration bits
> how to cope with pages which are part of a guest memory balloon, in order to
> make them movable by memory compaction procedures.
>

Should the names that are exported be prefixed with kvm_?

> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> ---
>  include/linux/mm.h |   17 +++++++++++++
>  mm/compaction.c    |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/migrate.c       |   30 +++++++++++++++++++++-
>  3 files changed, 118 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b36d08c..360656e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1629,5 +1629,22 @@ static inline unsigned int debug_guardpage_minorder(void) { return 0; }
>  static inline bool page_is_guard(struct page *page) { return false; }
>  #endif /* CONFIG_DEBUG_PAGEALLOC */
>
> +#if (defined(CONFIG_VIRTIO_BALLOON) || \
> +       defined(CONFIG_VIRTIO_BALLOON_MODULE)) && defined(CONFIG_COMPACTION)
> +extern int is_balloon_page(struct page *);
> +extern int isolate_balloon_page(struct page *);
> +extern int putback_balloon_page(struct page *);
> +
> +/* return 1 if page is part of a guest's memory balloon, 0 otherwise */
> +static inline int PageBalloon(struct page *page)
> +{
> +       return is_balloon_page(page);
> +}
> +#else
> +static inline int PageBalloon(struct page *page)               { return 0; }
> +static inline int isolate_balloon_page(struct page *page)      { return 0; }
> +static inline int putback_balloon_page(struct page *page)      { return 0; }
> +#endif /* (VIRTIO_BALLOON || VIRTIO_BALLOON_MODULE) && COMPACTION */
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MM_H */
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 7ea259d..8835d55 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -14,6 +14,7 @@
>  #include <linux/backing-dev.h>
>  #include <linux/sysctl.h>
>  #include <linux/sysfs.h>
> +#include <linux/export.h>
>  #include "internal.h"
>
>  #if defined CONFIG_COMPACTION || defined CONFIG_CMA
> @@ -312,6 +313,14 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>                        continue;
>                }
>
> +               /*
> +                * For ballooned pages, we need to isolate them before testing
> +                * for PageLRU, as well as skip the LRU page isolation steps.
> +                */
> +               if (PageBalloon(page))
> +                       if (isolate_balloon_page(page))
> +                               goto isolated_balloon_page;
> +
>                if (!PageLRU(page))
>                        continue;
>
> @@ -338,6 +347,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>
>                /* Successfully isolated */
>                del_page_from_lru_list(page, lruvec, page_lru(page));
> +isolated_balloon_page:
>                list_add(&page->lru, migratelist);
>                cc->nr_migratepages++;
>                nr_isolated++;
> @@ -903,4 +913,66 @@ void compaction_unregister_node(struct node *node)
>  }
>  #endif /* CONFIG_SYSFS && CONFIG_NUMA */
>
> +#if defined(CONFIG_VIRTIO_BALLOON) || defined(CONFIG_VIRTIO_BALLOON_MODULE)
> +/*
> + * Balloon pages special page->mapping.
> + * users must properly allocate and initiliaze an instance of balloon_mapping,
> + * and set it as the page->mapping for balloon enlisted page instances.
> + *
> + * address_space_operations necessary methods for ballooned pages:
> + *   .migratepage    - used to perform balloon's page migration (as is)
> + *   .invalidatepage - used to isolate a page from balloon's page list
> + *   .freepage       - used to reinsert an isolated page to balloon's page list
> + */
> +struct address_space *balloon_mapping;
> +EXPORT_SYMBOL(balloon_mapping);
> +
> +/* ballooned page id check */
> +int is_balloon_page(struct page *page)
> +{
> +       struct address_space *mapping = page->mapping;
> +       if (mapping == balloon_mapping)
> +               return 1;
> +       return 0;
> +}
> +
> +/* __isolate_lru_page() counterpart for a ballooned page */
> +int isolate_balloon_page(struct page *page)
> +{
> +       struct address_space *mapping = page->mapping;
> +       if (mapping->a_ops->invalidatepage) {
> +               /*
> +                * We can race against move_to_new_page() and stumble across a
> +                * locked 'newpage'. If we succeed on isolating it, the result
> +                * tends to be disastrous. So, we sanely skip PageLocked here.
> +                */
> +               if (likely(!PageLocked(page) && get_page_unless_zero(page))) {
> +                       /*
> +                        * A ballooned page, by default, has just one refcount.
> +                        * Prevent concurrent compaction threads from isolating
> +                        * an already isolated balloon page.
> +                        */
> +                       if (page_count(page) == 2) {
> +                               mapping->a_ops->invalidatepage(page, 0);
> +                               return 1;
> +                       }
> +                       /* Drop refcount taken for this already isolated page */
> +                       put_page(page);
> +               }
> +       }
> +       return 0;
> +}
> +
> +/* putback_lru_page() counterpart for a ballooned page */
> +int putback_balloon_page(struct page *page)
> +{
> +       struct address_space *mapping = page->mapping;
> +       if (mapping->a_ops->freepage) {
> +               mapping->a_ops->freepage(page);
> +               put_page(page);
> +               return 1;
> +       }
> +       return 0;
> +}
> +#endif /* CONFIG_VIRTIO_BALLOON || CONFIG_VIRTIO_BALLOON_MODULE */
>  #endif /* CONFIG_COMPACTION */
> diff --git a/mm/migrate.c b/mm/migrate.c
> index be26d5c..ffc02a4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -78,7 +78,10 @@ void putback_lru_pages(struct list_head *l)
>                list_del(&page->lru);
>                dec_zone_page_state(page, NR_ISOLATED_ANON +
>                                page_is_file_cache(page));
> -               putback_lru_page(page);
> +               if (unlikely(PageBalloon(page)))
> +                       VM_BUG_ON(!putback_balloon_page(page));
> +               else
> +                       putback_lru_page(page);
>        }
>  }
>
> @@ -783,6 +786,17 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
>                }
>        }
>
> +       if (PageBalloon(page)) {
> +               /*
> +                * A ballooned page does not need any special attention from
> +                * physical to virtual reverse mapping procedures.
> +                * To avoid burning cycles at rmap level,
> +                * skip attempts to unmap PTEs or remap swapcache.
> +                */
> +               remap_swapcache = 0;
> +               goto skip_unmap;
> +       }
> +
>        /*
>         * Corner case handling:
>         * 1. When a new swap-cache page is read into, it is added to the LRU
> @@ -852,6 +866,20 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>                        goto out;
>
>        rc = __unmap_and_move(page, newpage, force, offlining, mode);
> +
> +       if (PageBalloon(newpage)) {
> +               /*
> +                * A ballooned page has been migrated already. Now, it is the
> +                * time to wrap-up counters, handle the old page back to Buddy
> +                * and return.
> +                */
> +               list_del(&page->lru);
> +               dec_zone_page_state(page, NR_ISOLATED_ANON +
> +                                   page_is_file_cache(page));
> +               put_page(page);
> +               __free_page(page);
> +               return rc;
> +       }
>  out:
>        if (rc != -EAGAIN) {
>                /*
> --
> 1.7.10.2
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
