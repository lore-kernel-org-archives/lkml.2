Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0JKPdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:33:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43047 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab0JKPdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:33:50 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "david.cohen@nokia.com" <david.cohen@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 11 Oct 2010 10:33:42 -0500
Subject: RE: [PATCHv2 2/3] iovmm: add superpages support to fixed da address
Thread-Topic: [PATCHv2 2/3] iovmm: add superpages support to fixed da address
Thread-Index: Actojuq55zyNunMPQP2e6mw0NIkBuwAyIBaw
Message-ID: <496565EC904933469F292DDA3F1663E602F47B2BF1@dlee06.ent.ti.com>
References: <1286226137-1233-1-git-send-email-x0095840@ti.com>
	<1286226137-1233-2-git-send-email-x0095840@ti.com>
	<1286226137-1233-3-git-send-email-x0095840@ti.com>
 <AANLkTimF5HqA0pbp7NXOXxOcuMMJWp9yuJPsw8-iPKjh@mail.gmail.com>
In-Reply-To: <AANLkTimF5HqA0pbp7NXOXxOcuMMJWp9yuJPsw8-iPKjh@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Felipe Contreras [mailto:felipe.contreras@gmail.com] 
> Sent: Sunday, October 10, 2010 10:22 AM
> To: Guzman Lugo, Fernando
> Cc: Hiroshi.DOYU@nokia.com; david.cohen@nokia.com; 
> felipe.contreras@nokia.com; ameya.palande@nokia.com; 
> linux-kernel@vger.kernel.org; andy.shevchenko@gmail.com; 
> linux-omap@vger.kernel.org
> Subject: Re: [PATCHv2 2/3] iovmm: add superpages support to 
> fixed da address
> 
> On Tue, Oct 5, 2010 at 12:02 AM, Fernando Guzman Lugo 
> <x0095840@ti.com> wrote:
> > This patch adds superpages support to fixed ad address inside 
> > iommu_kmap function.
> >
> > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> > ---
> >  arch/arm/plat-omap/iovmm.c |   61 
> > ++++++++++++++++++++++++++-----------------
> >  1 files changed, 37 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm/plat-omap/iovmm.c 
> b/arch/arm/plat-omap/iovmm.c 
> > index 34f0012..8006a19 100644
> > --- a/arch/arm/plat-omap/iovmm.c
> > +++ b/arch/arm/plat-omap/iovmm.c
> > @@ -87,27 +87,37 @@ static size_t sgtable_len(const struct sg_table 
> > *sgt)
> >  }
> >  #define sgtable_ok(x)  (!!sgtable_len(x))
> >
> > +
> > +static unsigned max_alignment(u32 addr) {
> > +       int i;
> > +       unsigned pagesize[] = { SZ_16M, SZ_1M, SZ_64K, SZ_4K, };
> > +       for (i = 0; i < ARRAY_SIZE(pagesize) && addr & 
> (pagesize[i] - 
> > +1); i++)
> > +               ;
> > +       return (i < ARRAY_SIZE(pagesize)) ? pagesize[i] : 0; }
> > +
> > +
> 
> I don't think those extra spaces make sense.

Ok, it will be fixed.

> 
> >  /*
> >  * calculate the optimal number sg elements from total 
> bytes based on
> >  * iommu superpages
> >  */
> > -static unsigned int sgtable_nents(size_t bytes)
> > +static unsigned int sgtable_nents(size_t bytes, u32 da, u32 pa)
> >  {
> > -       int i;
> > -       unsigned int nr_entries;
> > -       const unsigned long pagesize[] = { SZ_16M, SZ_1M, SZ_64K, 
> > SZ_4K, };
> > +       unsigned int nr_entries = 0, ent_sz;
> 
> How about s/unsigned int/unsigned/?

It is exactly the same, but not problem for me.

> 
> >
> >        if (!IS_ALIGNED(bytes, PAGE_SIZE)) {
> >                pr_err("%s: wrong size %08x\n", __func__, bytes);
> >                return 0;
> >        }
> >
> > -       nr_entries = 0;
> > -       for (i = 0; i < ARRAY_SIZE(pagesize); i++) {
> > -               if (bytes >= pagesize[i]) {
> > -                       nr_entries += (bytes / pagesize[i]);
> > -                       bytes %= pagesize[i];
> > -               }
> > +       while (bytes) {
> > +               ent_sz = max_alignment(da | pa);
> > +               ent_sz = min(ent_sz, (unsigned)iopgsz_max(bytes));
> > +               nr_entries++;
> > +               da += ent_sz;
> > +               pa += ent_sz;
> > +               bytes -= ent_sz;
> >        }
> >        BUG_ON(bytes);
> >
> > @@ -115,7 +125,8 @@ static unsigned int sgtable_nents(size_t bytes)
> >  }
> >
> >  /* allocate and initialize sg_table header(a kind of 
> 'superblock') */ 
> > -static struct sg_table *sgtable_alloc(const size_t bytes, 
> u32 flags)
> > +static struct sg_table *sgtable_alloc(const size_t bytes, 
> u32 flags,
> > +                                                       u32 da, u32 
> > +pa)
> >  {
> >        unsigned int nr_entries;
> >        int err;
> > @@ -127,9 +138,8 @@ static struct sg_table 
> *sgtable_alloc(const size_t 
> > bytes, u32 flags)
> >        if (!IS_ALIGNED(bytes, PAGE_SIZE))
> >                return ERR_PTR(-EINVAL);
> >
> > -       /* FIXME: IOVMF_DA_FIXED should support 'superpages' */
> > -       if ((flags & IOVMF_LINEAR) && (flags & IOVMF_DA_ANON)) {
> > -               nr_entries = sgtable_nents(bytes);
> > +       if (flags & IOVMF_LINEAR) {
> > +               nr_entries = sgtable_nents(bytes, da, pa);
> >                if (!nr_entries)
> >                        return ERR_PTR(-EINVAL);
> >        } else
> > @@ -409,7 +419,8 @@ static inline void sgtable_drain_vmalloc(struct 
> > sg_table *sgt)
> >        BUG_ON(!sgt);
> >  }
> >
> > -static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 
> pa, size_t 
> > len)
> > +static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, u32 
> > +da,
> > +                                                           
>     size_t 
> > +len)
> >  {
> >        unsigned int i;
> >        struct scatterlist *sg;
> > @@ -420,7 +431,8 @@ static void sgtable_fill_kmalloc(struct 
> sg_table 
> > *sgt, u32 pa, size_t len)
> >        for_each_sg(sgt->sgl, sg, sgt->nents, i) {
> >                size_t bytes;
> >
> > -               bytes = iopgsz_max(len);
> > +               bytes = max_alignment(da | pa);
> > +               bytes = min(bytes, (size_t)iopgsz_max(len));
> 
> Why the size_t casting?

To void this warning:
arch/arm/plat-omap/iovmm.c:440: warning: comparison of distinct pointer types lacks a cast

I will update with minor changes and resend.

Thanks and regards,
Fernando.

> 
> Otherwise:
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> 
> --
> Felipe Contreras
> 