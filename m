Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3ACQJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:09:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57404 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab3ACQJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:09:43 -0500
Message-ID: <50E5ACC2.9030700@linux.vnet.ibm.com>
Date: Thu, 03 Jan 2013 10:07:30 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 7/8] zswap: add to mm/
References: <1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com> <1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010316-5806-0000-0000-00001DBE5A0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 03:56 PM, Seth Jennings wrote:
> zswap is a thin compression backend for frontswap. It receives
> pages from frontswap and attempts to store them in a compressed
> memory pool, resulting in an effective partial memory reclaim and
> dramatically reduced swap device I/O.
> 
> Additional, in most cases, pages can be retrieved from this
> compressed store much more quickly than reading from tradition
> swap devices resulting in faster performance for many workloads.
> 
> This patch adds the zswap driver to mm/
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  include/linux/swap.h |    4 +
>  mm/Kconfig           |   15 +
>  mm/Makefile          |    1 +
>  mm/page_io.c         |   22 +-
>  mm/swap_state.c      |    2 +-
>  mm/zswap.c           | 1077 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 1115 insertions(+), 6 deletions(-)
>  create mode 100644 mm/zswap.c
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 68df9c1..98981f0 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -321,6 +321,9 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
>  /* linux/mm/page_io.c */
>  extern int swap_readpage(struct page *);
>  extern int swap_writepage(struct page *page, struct writeback_control *wbc);
> +extern void end_swap_bio_write(struct bio *bio, int err);
> +extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
> +	void (*end_write_func)(struct bio *, int));
>  extern int swap_set_page_dirty(struct page *page);
>  extern void end_swap_bio_read(struct bio *bio, int err);
> 
> @@ -335,6 +338,7 @@ extern struct address_space swapper_space;
>  extern void show_swap_cache_info(void);
>  extern int add_to_swap(struct page *);
>  extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
> +extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
>  extern void __delete_from_swap_cache(struct page *);
>  extern void delete_from_swap_cache(struct page *);
>  extern void free_page_and_swap_cache(struct page *);
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 1680a012..68cd1b6 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -435,3 +435,18 @@ config FRONTSWAP
>  	  and swap data is stored as normal on the matching swap device.
> 
>  	  If unsure, say Y to enable frontswap.
> +
> +config ZSWAP
> +	bool "In-kernel swap page compression"
> +	depends on FRONTSWAP && CRYPTO
> +	select CRYPTO_LZO
> +	select ZSMALLOC
> +	default n
> +	help
> +	  Zswap is a backend for the frontswap mechanism in the VMM.
> +	  It receives pages from frontswap and attempts to store them
> +	  in a compressed memory pool, resulting in an effective
> +	  partial memory reclaim.  In addition, pages and be retrieved
> +	  from this compressed store much faster than most tradition
> +	  swap devices resulting in reduced I/O and faster performance
> +	  for many workloads.
> diff --git a/mm/Makefile b/mm/Makefile
> index 3a46287..1b1ed5c 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -32,6 +32,7 @@ obj-$(CONFIG_HAVE_MEMBLOCK) += memblock.o
>  obj-$(CONFIG_BOUNCE)	+= bounce.o
>  obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
>  obj-$(CONFIG_FRONTSWAP)	+= frontswap.o
> +obj-$(CONFIG_ZSWAP)	+= zswap.o
>  obj-$(CONFIG_HAS_DMA)	+= dmapool.o
>  obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
>  obj-$(CONFIG_NUMA) 	+= mempolicy.o
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 78eee32..56276fe 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -42,7 +42,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
>  	return bio;
>  }
> 
> -static void end_swap_bio_write(struct bio *bio, int err)
> +void end_swap_bio_write(struct bio *bio, int err)
>  {
>  	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
>  	struct page *page = bio->bi_io_vec[0].bv_page;
> @@ -179,15 +179,16 @@ bad_bmap:
>  	goto out;
>  }
> 
> +int __swap_writepage(struct page *page, struct writeback_control *wbc,
> +	void (*end_write_func)(struct bio *, int));
> +
>  /*
>   * We may have stale swap cache pages in memory: notice
>   * them here and get rid of the unnecessary final write.
>   */
>  int swap_writepage(struct page *page, struct writeback_control *wbc)
>  {
> -	struct bio *bio;
> -	int ret = 0, rw = WRITE;
> -	struct swap_info_struct *sis = page_swap_info(page);
> +	int ret = 0;
> 
>  	if (try_to_free_swap(page)) {
>  		unlock_page(page);
> @@ -199,6 +200,17 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>  		end_page_writeback(page);
>  		goto out;
>  	}
> +	ret = __swap_writepage(page, wbc, end_swap_bio_write);
> +out:
> +	return ret;
> +}
> +
> +int __swap_writepage(struct page *page, struct writeback_control *wbc,
> +	void (*end_write_func)(struct bio *, int))
> +{
> +	struct bio *bio;
> +	int ret = 0, rw = WRITE;
> +	struct swap_info_struct *sis = page_swap_info(page);
> 
>  	if (sis->flags & SWP_FILE) {
>  		struct kiocb kiocb;
> @@ -226,7 +238,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>  		return ret;
>  	}
> 
> -	bio = get_swap_bio(GFP_NOIO, page, end_swap_bio_write);
> +	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
>  	if (bio == NULL) {
>  		set_page_dirty(page);
>  		unlock_page(page);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index d1f6c2d..95a8597 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -68,7 +68,7 @@ void show_swap_cache_info(void)
>   * __add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
>   * but sets SwapCache flag and private instead of mapping and index.
>   */
> -static int __add_to_swap_cache(struct page *page, swp_entry_t entry)
> +int __add_to_swap_cache(struct page *page, swp_entry_t entry)
>  {
>  	int error;

I'd like to draw attention to these changes made to mm/page_io.c,
mm/swap_state.c, and include/linux/swap.h.  These changes were made to
accommodate zswap's ability to push pages out to the swap device.  I'd
like to make sure that no one has issue with these changes.

Thanks,
Seth

