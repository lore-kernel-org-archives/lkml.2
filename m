Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab2C0Ucy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 16:32:54 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37798 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab2C0Ucx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 16:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <4F68E12C.8090807@gmx.net>
References: <4F68D14B.60409@gmx.net> <4F68E12C.8090807@gmx.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 27 Mar 2012 14:32:31 -0600
Message-ID: <CAErSpo6VxdvpmSA_RbPLcqduwqXbJg_VCqSdW7_+_UGLeWWT+w@mail.gmail.com>
Subject: Re: [PATCH 1/3] PNP: Simplify setting of resources
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2RKXB1j024726

On Tue, Mar 20, 2012 at 1:57 PM, Witold Szczeponik
<Witold.Szczeponik@gmx.net> wrote:
> This patch factors out the setting of PNP resources into one function which is
> then reused for all PNP resource types.  This makes the code more concise and
> avoids duplication.  The parameters "type" and "flags" are not used at the
> moment but will be used by follow-up patches.  Placeholders for these patches
> can be found in the comment lines that contain the "TBD" marker.
>
> As the code does not make any changes to the ABI, no regressions are expected.
>
> NB: While at it, support for bus type resources is added.
>
> The patch is applied against Linux 3.3.x.

A few minor comments below, but I think this looks good.  In the past,
I've sent PNP patches through linux-acpi and Len's ACPI tree.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
>
>
> Index: linux/drivers/pnp/interface.c
> ===================================================================
> --- linux.orig/drivers/pnp/interface.c
> +++ linux/drivers/pnp/interface.c
> @@ -298,6 +298,39 @@ static ssize_t pnp_show_current_resource
>        return ret;
>  }
>
> +static char *pnp_get_resource_value(char *buf,
> +                                   unsigned long type,
> +                                   resource_size_t *start,
> +                                   resource_size_t *end,
> +                                   unsigned long *flags)
> +{
> +       if (start)
> +               *start = 0;
> +       if (end)
> +               *end = 0;
> +       if (flags)
> +               *flags = 0;
> +
> +       /* TBD: allow for disabled resources */
> +
> +       buf = skip_spaces(buf);
> +       if (start) {
> +               *start = simple_strtoull(buf, &buf, 0);
> +               if (end) {
> +                       buf = skip_spaces(buf);
> +                       if (*buf == '-') {
> +                               buf = skip_spaces(buf + 1);
> +                               *end = simple_strtoull(buf, &buf, 0);
> +                       } else
> +                               *end = *start;
> +               }
> +       }
> +
> +       /* TBD: allow for additional flags, e.g., IORESOURCE_WINDOW */
> +
> +       return buf;
> +}
> +
>  static ssize_t pnp_set_current_resources(struct device *dmdev,
>                                         struct device_attribute *attr,
>                                         const char *ubuf, size_t count)
> @@ -305,7 +338,6 @@ static ssize_t pnp_set_current_resources
>        struct pnp_dev *dev = to_pnp_dev(dmdev);
>        char *buf = (void *)ubuf;
>        int retval = 0;
> -       resource_size_t start, end;
>
>        if (dev->status & PNP_ATTACHED) {
>                retval = -EBUSY;
> @@ -349,6 +381,10 @@ static ssize_t pnp_set_current_resources
>                goto done;
>        }
>        if (!strnicmp(buf, "set", 3)) {
> +               resource_size_t start;
> +               resource_size_t end;
> +               unsigned long flags;
> +
>                if (dev->active)
>                        goto done;
>                buf += 3;
> @@ -357,42 +393,42 @@ static ssize_t pnp_set_current_resources
>                while (1) {
>                        buf = skip_spaces(buf);
>                        if (!strnicmp(buf, "io", 2)) {
> -                               buf = skip_spaces(buf + 2);
> -                               start = simple_strtoul(buf, &buf, 0);
> -                               buf = skip_spaces(buf);
> -                               if (*buf == '-') {
> -                                       buf = skip_spaces(buf + 1);
> -                                       end = simple_strtoul(buf, &buf, 0);
> -                               } else
> -                                       end = start;
> -                               pnp_add_io_resource(dev, start, end, 0);
> -                               continue;
> -                       }
> -                       if (!strnicmp(buf, "mem", 3)) {
> -                               buf = skip_spaces(buf + 3);
> -                               start = simple_strtoul(buf, &buf, 0);
> -                               buf = skip_spaces(buf);
> -                               if (*buf == '-') {
> -                                       buf = skip_spaces(buf + 1);
> -                                       end = simple_strtoul(buf, &buf, 0);
> -                               } else
> -                                       end = start;
> -                               pnp_add_mem_resource(dev, start, end, 0);
> -                               continue;
> -                       }
> -                       if (!strnicmp(buf, "irq", 3)) {
> -                               buf = skip_spaces(buf + 3);
> -                               start = simple_strtoul(buf, &buf, 0);
> -                               pnp_add_irq_resource(dev, start, 0);
> -                               continue;
> -                       }
> -                       if (!strnicmp(buf, "dma", 3)) {
> -                               buf = skip_spaces(buf + 3);
> -                               start = simple_strtoul(buf, &buf, 0);
> -                               pnp_add_dma_resource(dev, start, 0);
> -                               continue;
> -                       }
> -                       break;
> +                               buf = pnp_get_resource_value(buf + 2,
> +                                                            IORESOURCE_IO,
> +                                                            &start,
> +                                                            &end,
> +                                                            &flags);

Looks like at least "&end" will fit on the same line as "&start".

> +                               pnp_add_io_resource(dev, start, end, flags);
> +                       } else if (!strnicmp(buf, "mem", 3)) {
> +                               buf = pnp_get_resource_value(buf + 3,
> +                                                            IORESOURCE_MEM,
> +                                                            &start,
> +                                                            &end,
> +                                                            &flags);
> +                               pnp_add_mem_resource(dev, start, end, flags);
> +                       } else if (!strnicmp(buf, "irq", 3)) {
> +                               buf = pnp_get_resource_value(buf + 3,
> +                                                            IORESOURCE_IRQ,
> +                                                            &start,
> +                                                            NULL,
> +                                                            &flags);
> +                               pnp_add_irq_resource(dev, start, flags);
> +                       } else if (!strnicmp(buf, "dma", 3)) {
> +                               buf = pnp_get_resource_value(buf + 3,
> +                                                            IORESOURCE_DMA,
> +                                                            &start,
> +                                                            NULL,
> +                                                            &flags);
> +                               pnp_add_dma_resource(dev, start, flags);
> +                       } else if (!strnicmp(buf, "bus", 3)) {
> +                               buf = pnp_get_resource_value(buf + 3,
> +                                                            IORESOURCE_BUS,
> +                                                            &start,
> +                                                            &end,
> +                                                            NULL);
> +                               pnp_add_bus_resource(dev, start, end);

It makes sense to allow a user to set bus number resources just like
any other resources, but I don't think the rest of PNP supports this
yet.  I think only PNPACPI supports bus number resources at all, so
when you "activate" the device after setting its resources, we'll call
pnpacpi_set_resources() and pnpacpi_encode_resources(), but
pnpacpi_encode_resources() doesn't know how to encode the address16
descriptor that will probably be used for bus numbers.

I guess that's all right, though.  We already have the same situation
for all the address space descriptors when used for IO or MEM.

> +                       } else
> +                               break;
>                }
>                mutex_unlock(&pnp_res_mutex);
>                goto done;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
