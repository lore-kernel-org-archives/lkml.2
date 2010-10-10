Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0JJPWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:22:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40542 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0JJPWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gGJleLtCj96/fVAyM4wfKDTHkkAq2kyGOjToq2TKz2W/Hxa7Cihgl8xdY5Am7MNroY
         rBeZtPdkCXDvuWhN7YKbZVIAPzxlUxo+A6KYWrfDclxbIChRYmK9IN0miEmwh5sCckiI
         F7UWOXKNIsLcPCzF1D/nmMvnoA8iL7tED05M8=
MIME-Version: 1.0
In-Reply-To: <1286226137-1233-3-git-send-email-x0095840@ti.com>
References: <1286226137-1233-1-git-send-email-x0095840@ti.com>
	<1286226137-1233-2-git-send-email-x0095840@ti.com>
	<1286226137-1233-3-git-send-email-x0095840@ti.com>
Date: Sun, 10 Oct 2010 18:22:11 +0300
Message-ID: <AANLkTimF5HqA0pbp7NXOXxOcuMMJWp9yuJPsw8-iPKjh@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] iovmm: add superpages support to fixed da address
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <x0095840@ti.com>
Cc: Hiroshi.DOYU@nokia.com, david.cohen@nokia.com, felipe.contreras@nokia.com,
        ameya.palande@nokia.com, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 12:02 AM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
> This patch adds superpages support to fixed ad address
> inside iommu_kmap function.
>
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> ---
>  arch/arm/plat-omap/iovmm.c |   61 ++++++++++++++++++++++++++-----------------
>  1 files changed, 37 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> index 34f0012..8006a19 100644
> --- a/arch/arm/plat-omap/iovmm.c
> +++ b/arch/arm/plat-omap/iovmm.c
> @@ -87,27 +87,37 @@ static size_t sgtable_len(const struct sg_table *sgt)
>  }
>  #define sgtable_ok(x)  (!!sgtable_len(x))
>
> +
> +static unsigned max_alignment(u32 addr)
> +{
> +       int i;
> +       unsigned pagesize[] = { SZ_16M, SZ_1M, SZ_64K, SZ_4K, };
> +       for (i = 0; i < ARRAY_SIZE(pagesize) && addr & (pagesize[i] - 1); i++)
> +               ;
> +       return (i < ARRAY_SIZE(pagesize)) ? pagesize[i] : 0;
> +}
> +
> +

I don't think those extra spaces make sense.

>  /*
>  * calculate the optimal number sg elements from total bytes based on
>  * iommu superpages
>  */
> -static unsigned int sgtable_nents(size_t bytes)
> +static unsigned int sgtable_nents(size_t bytes, u32 da, u32 pa)
>  {
> -       int i;
> -       unsigned int nr_entries;
> -       const unsigned long pagesize[] = { SZ_16M, SZ_1M, SZ_64K, SZ_4K, };
> +       unsigned int nr_entries = 0, ent_sz;

How about s/unsigned int/unsigned/?

>
>        if (!IS_ALIGNED(bytes, PAGE_SIZE)) {
>                pr_err("%s: wrong size %08x\n", __func__, bytes);
>                return 0;
>        }
>
> -       nr_entries = 0;
> -       for (i = 0; i < ARRAY_SIZE(pagesize); i++) {
> -               if (bytes >= pagesize[i]) {
> -                       nr_entries += (bytes / pagesize[i]);
> -                       bytes %= pagesize[i];
> -               }
> +       while (bytes) {
> +               ent_sz = max_alignment(da | pa);
> +               ent_sz = min(ent_sz, (unsigned)iopgsz_max(bytes));
> +               nr_entries++;
> +               da += ent_sz;
> +               pa += ent_sz;
> +               bytes -= ent_sz;
>        }
>        BUG_ON(bytes);
>
> @@ -115,7 +125,8 @@ static unsigned int sgtable_nents(size_t bytes)
>  }
>
>  /* allocate and initialize sg_table header(a kind of 'superblock') */
> -static struct sg_table *sgtable_alloc(const size_t bytes, u32 flags)
> +static struct sg_table *sgtable_alloc(const size_t bytes, u32 flags,
> +                                                       u32 da, u32 pa)
>  {
>        unsigned int nr_entries;
>        int err;
> @@ -127,9 +138,8 @@ static struct sg_table *sgtable_alloc(const size_t bytes, u32 flags)
>        if (!IS_ALIGNED(bytes, PAGE_SIZE))
>                return ERR_PTR(-EINVAL);
>
> -       /* FIXME: IOVMF_DA_FIXED should support 'superpages' */
> -       if ((flags & IOVMF_LINEAR) && (flags & IOVMF_DA_ANON)) {
> -               nr_entries = sgtable_nents(bytes);
> +       if (flags & IOVMF_LINEAR) {
> +               nr_entries = sgtable_nents(bytes, da, pa);
>                if (!nr_entries)
>                        return ERR_PTR(-EINVAL);
>        } else
> @@ -409,7 +419,8 @@ static inline void sgtable_drain_vmalloc(struct sg_table *sgt)
>        BUG_ON(!sgt);
>  }
>
> -static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, size_t len)
> +static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, u32 da,
> +                                                               size_t len)
>  {
>        unsigned int i;
>        struct scatterlist *sg;
> @@ -420,7 +431,8 @@ static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, size_t len)
>        for_each_sg(sgt->sgl, sg, sgt->nents, i) {
>                size_t bytes;
>
> -               bytes = iopgsz_max(len);
> +               bytes = max_alignment(da | pa);
> +               bytes = min(bytes, (size_t)iopgsz_max(len));

Why the size_t casting?

Otherwise:
Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

-- 
Felipe Contreras
