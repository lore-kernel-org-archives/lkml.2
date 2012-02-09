Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2BIG3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:29:33 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:63023 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548Ab2BIG3a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:29:30 -0500
MIME-Version: 1.0
In-Reply-To: <20120209151413.0dfec71771dd156843c0f4fa@canb.auug.org.au>
References: <20120209151413.0dfec71771dd156843c0f4fa@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 8 Feb 2012 22:29:10 -0800
X-Google-Sender-Auth: MG2SOtIG6QZAHUa6JbtzMOVwuWQ
Message-ID: <CACxGe6sskg2t0QtOgWCKvYFdqWbsM4Cbdt05ZaNCLzrdNd6iLQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the irqdomain tree with the arm tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 8:14 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the irqdomain tree got a conflict in
> arch/arm/common/gic.c between commit c11907f588d6 ("ARM: 7318/1: gic:
> refactor irq_start assignment") from the arm tree and commit 7da5a66bbf1f
> ("irq_domain: Remove 'new' irq_domain in favour of the ppc one") from the
> irqdomain tree.
>
> I fixed it up (see below) and can carry the fix as necessary.

Thanks Stephen.

The context fixup looks correct to me.  I'll test the current
linux-next tree when I get a chance (I'm at a conference at the
moment).


g.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/arm/common/gic.c
> index ca6b5dd,8cf934c..0000000
> --- a/arch/arm/common/gic.c
> +++ b/arch/arm/common/gic.c
> @@@ -348,12 -344,15 +345,11 @@@ void __init gic_cascade_irq(unsigned in
>
>  static void __init gic_dist_init(struct gic_chip_data *gic)
>  {
> -       unsigned int i, irq;
> +       unsigned int i;
>        u32 cpumask;
>        unsigned int gic_irqs = gic->gic_irqs;
> -       struct irq_domain *domain = &gic->domain;
>        void __iomem *base = gic_data_dist_base(gic);
>  -      u32 cpu = 0;
>  -
>  -#ifdef CONFIG_SMP
>  -      cpu = cpu_logical_map(smp_processor_id());
>  -#endif
>  +      u32 cpu = cpu_logical_map(smp_processor_id());
>
>        cpumask = 1 << cpu;
>        cpumask |= cpumask << 8;
> @@@ -694,12 -689,13 +686,12 @@@ void __init gic_init_bases(unsigned in
>         * For primary GICs, skip over SGIs.
>         * For secondary GICs, skip over PPIs, too.
>         */
>  -      hwirq_base = 32;
>  -      if (gic_nr == 0) {
>  -              if ((irq_start & 31) > 0) {
>  -                      hwirq_base = 16;
>  -                      if (irq_start != -1)
>  -                              irq_start = (irq_start & ~31) + 16;
>  -              }
>  +      if (gic_nr == 0 && (irq_start & 31) > 0) {
> -               domain->hwirq_base = 16;
> ++              hwirq_base = 16;
>  +              if (irq_start != -1)
>  +                      irq_start = (irq_start & ~31) + 16;
>  +      } else {
> -               domain->hwirq_base = 32;
> ++              hwirq_base = 32;
>        }
>
>        /*



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
