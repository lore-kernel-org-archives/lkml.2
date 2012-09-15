Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2IOBmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 21:42:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35153 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2IOBmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 21:42:00 -0400
Date: Fri, 14 Sep 2012 18:41:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Laura Abbott <lauraa@codeaurora.org>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC][PATCH] fs/buffer.c: Revoke LRU when trying to drop
 buffers
In-Reply-To: <1347384529-5862-1-git-send-email-lauraa@codeaurora.org>
Message-ID: <alpine.LSU.2.00.1209141821310.2138@eggly.anvils>
References: <1347384529-5862-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Laura Abbott wrote:
> When a buffer is added to the LRU list, a reference is taken which is
> not dropped until the buffer is evicted from the LRU list. This is the
> correct behavior, however this LRU reference will prevent the buffer
> from being dropped. This means that the buffer can't actually be dropped
> until it is selected for eviction. There's no bound on the time spent
> on the LRU list, which means that the buffer may be undroppable for
> very long periods of time. Given that migration involves dropping
> buffers, the associated page is now unmigratible for long periods of
> time as well.

Disclaimer: I'm no expert on buffer_heads, and haven't studied your
patch.  But it seems to me that this is an issue with the (unnamed)
filesystem you use, rather than a problem to be solved in drop_buffers().

extN, gfs2, ntfs, ocfs2 and xfs set .migratepage = buffer_migrate_page,
and I cannot see that page migration involves drop_buffers() at all in
that case: it transfers the buffer_heads from the old page to the new,
whether they're busy or not, with no attempt to free them.

Maybe your filesystem can be converted, with or without some extra help,
to buffer_migrate_page() instead of the default fallback_migrate_page():
which indeed has to play safe, doing the try_to_release_page() you see.
Maybe ask on the mailing list for your filesystem?

Hugh

> CMA relies on being able to migrate a specific range
> of pages, so these these types of failures make CMA significantly
> less reliable, especially under high filesystem usage.
> 
> Rather than waiting for the LRU algorithm to eventually kick out
> the buffer, explicitly remove the buffer from the LRU list when trying
> to drop it. There is still the possibility that the buffer
> could be added back on the list, but that indicates the buffer is
> still in use and would probably have other 'in use' indicates to
> prevent dropping.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  fs/buffer.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index ad5938c..daa0c3d 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1399,12 +1399,49 @@ static bool has_bh_in_lru(int cpu, void *dummy)
>  	return 0;
>  }
>  
> +static void __evict_bh_lru(void *arg)
> +{
> +	struct bh_lru *b = &get_cpu_var(bh_lrus);
> +	struct buffer_head *bh = arg;
> +	int i;
> +
> +	for (i = 0; i < BH_LRU_SIZE; i++) {
> +		if (b->bhs[i] == bh) {
> +			brelse(b->bhs[i]);
> +			b->bhs[i] = NULL;
> +			goto out;
> +		}
> +	}
> +out:
> +	put_cpu_var(bh_lrus);
> +}
> +
> +static bool bh_exists_in_lru(int cpu, void *arg)
> +{
> +	struct bh_lru *b = per_cpu_ptr(&bh_lrus, cpu);
> +	struct buffer_head *bh = arg;
> +	int i;
> +
> +	for (i = 0; i < BH_LRU_SIZE; i++) {
> +		if (b->bhs[i] == bh)
> +			return 1;
> +	}
> +
> +	return 0;
> +
> +}
>  void invalidate_bh_lrus(void)
>  {
>  	on_each_cpu_cond(has_bh_in_lru, invalidate_bh_lru, NULL, 1, GFP_KERNEL);
>  }
>  EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
>  
> +void evict_bh_lrus(struct buffer_head *bh)
> +{
> +	on_each_cpu_cond(bh_exists_in_lru, __evict_bh_lru, bh, 1, GFP_ATOMIC);
> +}
> +EXPORT_SYMBOL_GPL(evict_bh_lrus);
> +
>  void set_bh_page(struct buffer_head *bh,
>  		struct page *page, unsigned long offset)
>  {
> @@ -3052,6 +3089,7 @@ drop_buffers(struct page *page, struct buffer_head **buffers_to_free)
>  
>  	bh = head;
>  	do {
> +		evict_bh_lrus(bh);
>  		if (buffer_write_io_error(bh) && page->mapping)
>  			set_bit(AS_EIO, &page->mapping->flags);
>  		if (buffer_busy(bh))
> -- 
> 1.7.11.3
