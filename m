Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1AZRxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:53:30 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51481 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1AZRx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:53:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VnlwAx3Sb6mv9gxBieuN66Dk7hc9Pe0dzXdD8mgomGGqftNcZrqfUMj+9C78vZ9aQj
         gaqYfBg42vvxqGdiiA31E9tH7+1eY1FA6DQLGNHBbLZT0CZFDIzZinSteW/kqOpP+DPu
         s94EC3TEB95L5q9RHuOnRUlutDvbOhoB/0/4M=
MIME-Version: 1.0
In-Reply-To: <20110126172354.GE8446@linux.vnet.ibm.com>
References: <20110126172148.GB8446@linux.vnet.ibm.com>
	<20110126172354.GE8446@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 19:53:28 +0200
X-Google-Sender-Auth: Xjei5EtYmzB227V4OqnLsM095oE
Message-ID: <AANLkTinF=r_wUw_ZgfcdrFD6nWh3VKwUOjQ+wsbVax0C@mail.gmail.com>
Subject: Re: [PATCH 3/7] zram: Speed insertion of new pages with cached idx
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 7:23 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> Calculate the first- and second-level indices for new page when the pool
> is initialized rather than calculating them on each insertion.
>
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
>  drivers/staging/zram/xvmalloc.c     |   13 +++++++++++--
>  drivers/staging/zram/xvmalloc_int.h |    4 ++++
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
> index 3fdbb8a..a507f95 100644
> --- a/drivers/staging/zram/xvmalloc.c
> +++ b/drivers/staging/zram/xvmalloc.c
> @@ -184,8 +184,13 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
>        u32 flindex, slindex;
>        struct block_header *nextblock;
>
> -       slindex = get_index_for_insert(block->size);
> -       flindex = slindex / BITS_PER_LONG;
> +       if (block->size >= (PAGE_SIZE - XV_ALIGN)) {
> +               slindex = pagesize_slindex;
> +               flindex = pagesize_flindex;
> +       } else {
> +               slindex = get_index_for_insert(block->size);
> +               flindex = slindex / BITS_PER_LONG;
> +       }
>
>        block->link.prev_page = 0;
>        block->link.prev_offset = 0;
> @@ -316,6 +321,10 @@ struct xv_pool *xv_create_pool(void)
>        if (!pool)
>                return NULL;
>
> +       /* cache the first/second-level indices for PAGE_SIZE allocations */
> +       pagesize_slindex = get_index_for_insert(PAGE_SIZE);
> +       pagesize_flindex = pagesize_slindex / BITS_PER_LONG;

Why is this in xv_create_pool(). AFAICT, it can be called multiple
times if there's more than one zram device. Do we really need
variables for these? They look like something GCC constant propagation
should take care of if they would be defines or static inline
functions.

> +
>        spin_lock_init(&pool->lock);
>
>        return pool;
> diff --git a/drivers/staging/zram/xvmalloc_int.h b/drivers/staging/zram/xvmalloc_int.h
> index 051a49b..68db384 100644
> --- a/drivers/staging/zram/xvmalloc_int.h
> +++ b/drivers/staging/zram/xvmalloc_int.h
> @@ -52,6 +52,10 @@
>
>  /* End of user params */
>
> +/* Cache of the first/second-level indices for PAGE_SIZE allocations */
> +static u32 pagesize_slindex;
> +static u32 pagesize_flindex;

This doesn't look right. You shouldn't put variable declarations in
header files.

> +
>  enum blockflags {
>        BLOCK_FREE,
>        PREV_FREE,
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
