Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2HDXxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 19:53:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44278 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2HDXxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 19:53:49 -0400
MIME-Version: 1.0
In-Reply-To: <1344069330-29569-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344069330-29569-1-git-send-email-Julia.Lawall@lip6.fr>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 5 Aug 2012 07:53:26 +0800
Message-ID: <CAGsJ_4zYt6fJg9iE65VO4kqc-bD+o8ZuHY=ESjuPwfh-1uAPUw@mail.gmail.com>
Subject: Re: [PATCH] drivers/dma/sirf-dma.c: fix usage of devm functions
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/4 Julia Lawall <Julia.Lawall@lip6.fr>
>
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Fix some problems with the use of devm_ functions.
>
> devm_kzalloc: devm_kfree is not needed
>
> devm_ioremap: iounmap should not be used, no free is needed
>
> devm_request_irq: the devm_free_irq is followed by irq_dispose_mapping.  I
> don't know if it is safe to move the freeing of the irq in this case, so I
> have just un-devm'd this function, since the implicit freeing is never
> taken advantage of.
>
> In the original code failure of of_address_to_resource jumped to free_mem,
> but should have jumped to irq_dispose, since irq_of_parse_and_map has
> completed at this point.
>
> In the original code unmap_mem was after irq_dispose, but it should have
> been before, again since irq_of_parse_and_map has completed at this point.
>
> One of these problems was found using the following semantic match:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression x;
> @@
>
> *x = devm_ioremap(...)
> ...
> iounmap(x);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Barry Song <Baohua.Song@csr.com>

thanks!

>
> ---
> Not compiled.  Does free_irq actually have to be called before
> irq_dispose_mapping?
>
>  drivers/dma/sirf-dma.c |   23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
> index 434ad31..1af9e48 100644
> --- a/drivers/dma/sirf-dma.c
> +++ b/drivers/dma/sirf-dma.c
> @@ -570,21 +570,19 @@ static int __devinit sirfsoc_dma_probe(struct
> platform_device *op)
>
>         if (of_property_read_u32(dn, "cell-index", &id)) {
>                 dev_err(dev, "Fail to get DMAC index\n");
> -               ret = -ENODEV;
> -               goto free_mem;
> +               return -ENODEV;
>         }
>
>         sdma->irq = irq_of_parse_and_map(dn, 0);
>         if (sdma->irq == NO_IRQ) {
>                 dev_err(dev, "Error mapping IRQ!\n");
> -               ret = -EINVAL;
> -               goto free_mem;
> +               return -EINVAL;
>         }
>
>         ret = of_address_to_resource(dn, 0, &res);
>         if (ret) {
>                 dev_err(dev, "Error parsing memory region!\n");
> -               goto free_mem;
> +               goto irq_dispose;
>         }
>
>         regs_start = res.start;
> @@ -597,12 +595,11 @@ static int __devinit sirfsoc_dma_probe(struct
> platform_device *op)
>                 goto irq_dispose;
>         }
>
> -       ret = devm_request_irq(dev, sdma->irq, &sirfsoc_dma_irq, 0,
> DRV_NAME,
> -               sdma);
> +       ret = request_irq(sdma->irq, &sirfsoc_dma_irq, 0, DRV_NAME, sdma);
>         if (ret) {
>                 dev_err(dev, "Error requesting IRQ!\n");
>                 ret = -EINVAL;
> -               goto unmap_mem;
> +               goto irq_dispose;
>         }
>
>         dma = &sdma->dma;
> @@ -652,13 +649,9 @@ static int __devinit sirfsoc_dma_probe(struct
> platform_device *op)
>         return 0;
>
>  free_irq:
> -       devm_free_irq(dev, sdma->irq, sdma);
> +       free_irq(sdma->irq, sdma);
>  irq_dispose:
>         irq_dispose_mapping(sdma->irq);
> -unmap_mem:
> -       iounmap(sdma->base);
> -free_mem:
> -       devm_kfree(dev, sdma);
>         return ret;
>  }
>
> @@ -668,10 +661,8 @@ static int __devexit sirfsoc_dma_remove(struct
> platform_device *op)
>         struct sirfsoc_dma *sdma = dev_get_drvdata(dev);
>
>         dma_async_device_unregister(&sdma->dma);
> -       devm_free_irq(dev, sdma->irq, sdma);
> +       free_irq(sdma->irq, sdma);
>         irq_dispose_mapping(sdma->irq);
> -       iounmap(sdma->base);
> -       devm_kfree(dev, sdma);
>         return 0;
>  }

-barry
