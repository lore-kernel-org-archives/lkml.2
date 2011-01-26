Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1AZHKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:10:41 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21969 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1AZHKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:10:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uk6rwaoPgJwWhR6D7JVOXDc//kYROpO4VX6H5wzW/2Rq5cl/X18kvX3XmUFV8SCF7A
         E8s0ntS/SHgxxgZBmJoQ==
MIME-Version: 1.0
In-Reply-To: <1295834493-5019-2-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	<1295834493-5019-2-git-send-email-ccross@android.com>
Date: Tue, 25 Jan 2011 23:10:37 -0800
X-Google-Sender-Auth: useNizR03HB2euMH42slRDT2mLU
Message-ID: <AANLkTiniMu1Y_q5W=Fui0CNc99MJB5eCkeiVe8JJoO_D@mail.gmail.com>
Subject: Re: [PATCH v2 01/28] ARM: tegra: irq: Rename gic pointers to avoid conflicts
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 6:01 PM, Colin Cross <ccross@android.com> wrote:
> A future patch will export gic_mask_irq and gic_unmask_irq.
> Rename the pointers in arch/arm/mach-tegra/irq.c to avoid
> a compile error.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  arch/arm/mach-tegra/irq.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
> index de7dfad..17c74d2 100644
> --- a/arch/arm/mach-tegra/irq.c
> +++ b/arch/arm/mach-tegra/irq.c
> @@ -46,24 +46,24 @@
>  #define ICTLR_COP_IER_CLR      0x38
>  #define ICTLR_COP_IEP_CLASS    0x3c
>
> -static void (*gic_mask_irq)(struct irq_data *d);
> -static void (*gic_unmask_irq)(struct irq_data *d);
> +static void (*tegra_gic_mask_irq)(struct irq_data *d);
> +static void (*tegra_gic_unmask_irq)(struct irq_data *d);
>
> -#define irq_to_ictlr(irq) (((irq)-32) >> 5)
> +#define irq_to_ictlr(irq) (((irq) - 32) >> 5)
>  static void __iomem *tegra_ictlr_base = IO_ADDRESS(TEGRA_PRIMARY_ICTLR_BASE);
> -#define ictlr_to_virt(ictlr) (tegra_ictlr_base + (ictlr)*0x100)
> +#define ictlr_to_virt(ictlr) (tegra_ictlr_base + (ictlr) * 0x100)
>
>  static void tegra_mask(struct irq_data *d)
>  {
>        void __iomem *addr = ictlr_to_virt(irq_to_ictlr(d->irq));
> -       gic_mask_irq(d);
> -       writel(1<<(d->irq&31), addr+ICTLR_CPU_IER_CLR);
> +       tegra_gic_mask_irq(d);
> +       writel(1 << (d->irq & 31), addr+ICTLR_CPU_IER_CLR);
>  }
>
>  static void tegra_unmask(struct irq_data *d)
>  {
>        void __iomem *addr = ictlr_to_virt(irq_to_ictlr(d->irq));
> -       gic_unmask_irq(d);
> +       tegra_gic_unmask_irq(d);
>        writel(1<<(d->irq&31), addr+ICTLR_CPU_IER_SET);
>  }
>
> @@ -98,8 +98,8 @@ void __init tegra_init_irq(void)
>                 IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
>
>        gic = get_irq_chip(29);
> -       gic_unmask_irq = gic->irq_unmask;
> -       gic_mask_irq = gic->irq_mask;
> +       tegra_gic_unmask_irq = gic->irq_unmask;
> +       tegra_gic_mask_irq = gic->irq_mask;
>        tegra_irq.irq_ack = gic->irq_ack;
>  #ifdef CONFIG_SMP
>        tegra_irq.irq_set_affinity = gic->irq_set_affinity;
> --
> 1.7.3.1

If there are no objections, I'm going to put this patch into
tegra/for-linus for a pull request for 2.6.38-rc3.
