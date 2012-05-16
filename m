Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab2EPKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:09:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46975 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894Ab2EPKJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120516072927.GN7988@linux-sh.org>
References: <20120515154333.6659.66479.sendpatchset@w520>
	<20120516072927.GN7988@linux-sh.org>
Date: Wed, 16 May 2012 19:09:54 +0900
Message-ID: <CANqRtoSSEb9jwEmvbhBuyHp-9BfUSRabQzqjrrVGTFDP-AHutQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 4:29 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, May 16, 2012 at 12:43:33AM +0900, Magnus Damm wrote:
>> +static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
>> +{
>> +     struct platform_device *pdev = p->pdev;
>> +     struct gpio_em_config *pdata = pdev->dev.platform_data;
>> +
>> +     p->irq_base = irq_alloc_descs(pdata->irq_base, 0,
>> +                                   pdata->number_of_pins, numa_node_id());
>> +     if (IS_ERR_VALUE(p->irq_base)) {
>> +             dev_err(&pdev->dev, "cannot get irq_desc\n");
>> +             return -ENXIO;
>> +     }
>> +     pr_debug("gio: hw base = %d, nr = %d, sw base = %d\n",
>> +              pdata->gpio_base, pdata->number_of_pins, p->irq_base);
>> +
>> +     p->irq_domain = irq_domain_add_legacy(pdev->dev.of_node,
>> +                                           pdata->number_of_pins,
>> +                                           p->irq_base, 0,
>> +                                           &em_gio_irq_domain_ops, p);
>> +     if (!p->irq_domain) {
>> +             irq_free_descs(p->irq_base, pdata->number_of_pins);
>> +             return -ENXIO;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
> There's no reason to use a legacy domain here, this is a pretty
> straightforward candidate for a linear map. You can use ->to_irq() for
> the irq_create_mapping() invocation and then later look up the IRQ with
> irq_linear_revmap().

I believe I have my reasons for using the legacy domain, but I agree
that it is possible to use irq_create_mapping() and
irq_linear_revmap() in the case of linear mappings. Actually, it's
exactly what my DT prototype patch does. Please see this patch that
adds linear irq domain support in the DT case, and the patch
description also includes information about when the legacy irq domain
is used and when the linear one is:

http://groups.google.com/group/linux.kernel/browse_thread/thread/25a8d7e4d311ab59?pli=1

> irq_domain_add_legacy() exists for existing static ranges, which there is
> really no reason to be adding in new board/platform support. You don't
> have to worry about virq overlap since irq_create_mapping() already wraps
> on top of irq_alloc_desc_xxx() for lookup.

So I intentionally made use of the legacy domain in the non-DT case.
This because I want to let the SoC code set the static IRQ ranges via
platform data.
>
>> +static void __devexit em_gio_irq_domain_cleanup(struct em_gio_priv *p)
>> +{
>> +     struct gpio_em_config *pdata = p->pdev->dev.platform_data;
>> +
>> +     irq_free_descs(p->irq_base, pdata->number_of_pins);
>> +     /* FIXME: irq domain wants to be freed! */
>> +}
>> +
> After which point you can iterate and dispose of the virq mappings with
> irq_dispose_mapping(). The lack of irq domain teardown functionality does
> need to be addressed though.

I can't see any GPIO driver doing that yet, but yes, that is possible.

Thanks,

/ magnus
