Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab1CBMmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:42:50 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46127 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab1CBMmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:42:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HyYgTk2PXOcNA0Xe67Y0WJxzgSnWYd3ad2K51p6lTQuH7XP/tdAos3I/gejFKp15ML
         7codqBmO+s6IsjQhZ5Ov04Z+G2nbPw0HUUKrcHt4K3AKvLlC+INYB87NNMmZ7cVFUvmt
         MAQ9ntXBVqpB1boJzpm2OzcLWrHp1Qeo9yU4w=
MIME-Version: 1.0
In-Reply-To: <1299008793-27428-2-git-send-email-fernando.lugo@ti.com>
References: <1299008793-27428-1-git-send-email-fernando.lugo@ti.com>
	<1299008793-27428-2-git-send-email-fernando.lugo@ti.com>
Date: Wed, 2 Mar 2011 14:42:36 +0200
Message-ID: <AANLkTince7L2uRog-nCJa14GH6ieKw2hEfEfWNZeGgNj@mail.gmail.com>
Subject: Re: [PATCH] OMAP:iommu - pgd and pte entries weren't getting flushed out
From: David Cohen <dacohen@gmail.com>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: hiroshi.doyu@nokia.com, tony@atomide.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Hari Kanigeri <h-kanigeri2@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 1, 2011 at 9:46 PM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:
> From: Hari Kanigeri <h-kanigeri2@ti.com>
>
> pgd and pte entries weren't getting flushed out leading to MMU faults.

May I ask you to add to the patch body description why it's wrong and
why your solution is necessary?

Br,

David

>
> Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
> ---
>  arch/arm/plat-omap/iommu.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
> index aeb2c33..e9473ff 100644
> --- a/arch/arm/plat-omap/iommu.c
> +++ b/arch/arm/plat-omap/iommu.c
> @@ -508,7 +508,7 @@ static u32 *iopte_alloc(struct iommu *obj, u32 *iopgd, u32 da)
>                        return ERR_PTR(-ENOMEM);
>
>                *iopgd = virt_to_phys(iopte) | IOPGD_TABLE;
> -               flush_iopgd_range(iopgd, iopgd);
> +               flush_iopgd_range(iopgd, iopgd + 1);
>
>                dev_vdbg(obj->dev, "%s: a new pte:%p\n", __func__, iopte);
>        } else {
> @@ -537,7 +537,7 @@ static int iopgd_alloc_section(struct iommu *obj, u32 da, u32 pa, u32 prot)
>        }
>
>        *iopgd = (pa & IOSECTION_MASK) | prot | IOPGD_SECTION;
> -       flush_iopgd_range(iopgd, iopgd);
> +       flush_iopgd_range(iopgd, iopgd + 1);
>        return 0;
>  }
>
> @@ -554,7 +554,7 @@ static int iopgd_alloc_super(struct iommu *obj, u32 da, u32 pa, u32 prot)
>
>        for (i = 0; i < 16; i++)
>                *(iopgd + i) = (pa & IOSUPER_MASK) | prot | IOPGD_SUPER;
> -       flush_iopgd_range(iopgd, iopgd + 15);
> +       flush_iopgd_range(iopgd, iopgd + 16);
>        return 0;
>  }
>
> @@ -567,7 +567,7 @@ static int iopte_alloc_page(struct iommu *obj, u32 da, u32 pa, u32 prot)
>                return PTR_ERR(iopte);
>
>        *iopte = (pa & IOPAGE_MASK) | prot | IOPTE_SMALL;
> -       flush_iopte_range(iopte, iopte);
> +       flush_iopte_range(iopte, iopte + 1);
>
>        dev_vdbg(obj->dev, "%s: da:%08x pa:%08x pte:%p *pte:%08x\n",
>                 __func__, da, pa, iopte, *iopte);
> @@ -592,7 +592,7 @@ static int iopte_alloc_large(struct iommu *obj, u32 da, u32 pa, u32 prot)
>
>        for (i = 0; i < 16; i++)
>                *(iopte + i) = (pa & IOLARGE_MASK) | prot | IOPTE_LARGE;
> -       flush_iopte_range(iopte, iopte + 15);
> +       flush_iopte_range(iopte, iopte + 16);
>        return 0;
>  }
>
> @@ -763,7 +763,7 @@ void iopgtable_clear_entry_all(struct iommu *obj)
>                        iopte_free(iopte_offset(iopgd, 0));
>
>                *iopgd = 0;
> -               flush_iopgd_range(iopgd, iopgd);
> +               flush_iopgd_range(iopgd, iopgd + 1);
>        }
>
>        flush_iotlb_all(obj);
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
