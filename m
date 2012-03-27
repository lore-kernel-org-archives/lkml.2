Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2C0Vk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:40:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41917 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2C0VkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <4F68E1D3.1060309@gmx.net>
References: <4F68D14B.60409@gmx.net> <4F68E1D3.1060309@gmx.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 27 Mar 2012 14:38:49 -0600
Message-ID: <CAErSpo75MV2-XvVQdMrcunFbC+bZvPQXmh5Hzt1ihOOjz2pS0w@mail.gmail.com>
Subject: Re: [PATCH 2/3] PNP: Allow resources to be set as disabled
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 2:00 PM, Witold Szczeponik
<Witold.Szczeponik@gmx.net> wrote:
> This patch allows to set PNP resources as "disabled".  As such, the patch is
> a follow-up to commit 18fd470a48396c8795ba7256c5973e92ffa25cb3 where parsing
> of ACPI PNP resources that can be disabled was enabled.
>
> The patch achieves this by doing two things: (1) it allows the strings
> "disabled" and "<none>" to be used as a valid PNP resource value, and (2) when
> assigning PNP resources, it copies the flags masked by IORESOURCE_BITS from the
> resource's templates.

These look like reasonable things to do, but (2) doesn't seem to
depend on (1), so you might just split them into two patches.

>  The latter is necessary because the resource settings
> require proper IORESOURCE_BITS which are not known during the definition of
> these resources using the "/sys/bus/pnp/*/*/resources" interface.  (In fact,
> they should not be set by the user as the resource templates define the
> proper settings.)
>
> The patch is required in order to support the setting of "disabled" IRQs like
> described in the commit 29df8d8f8702f0f53c1375015f09f04bc8d023c1, i.e., with
> this patch applied, some vintage IBM ThinkPads like the 600E can allocate the
> resources such that all devices can be used simultaneously.
>
> If the second part of the patch is not applied, the resource flags are not
> initialized properly and obscure messages in the kernel log have be seen

s/be/been/

> ("invalid flags").
>
> The patch is applied against Linux 3.3.x.
>
>
> Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
>
>
> Index: linux/drivers/pnp/interface.c
> ===================================================================
> --- linux.orig/drivers/pnp/interface.c
> +++ linux/drivers/pnp/interface.c
> @@ -311,10 +311,14 @@ static char *pnp_get_resource_value(char
>        if (flags)
>                *flags = 0;
>
> -       /* TBD: allow for disabled resources */
> -
>        buf = skip_spaces(buf);
> -       if (start) {
> +       if (flags && !strnicmp(buf, "disabled", 8)) {
> +               buf += 8;
> +               *flags |= IORESOURCE_DISABLED;
> +       } else if (flags && !strnicmp(buf, "<none>", 6)) {
> +               buf += 6;
> +               *flags |= IORESOURCE_DISABLED;

What's the value in supporting both "disabled" and "<none>"?  Having
both suggests that they do different things, but it looks like they
have the same effect.

> +       } else if (start) {
>                *start = simple_strtoull(buf, &buf, 0);
>                if (end) {
>                        buf = skip_spaces(buf);
> Index: linux/drivers/pnp/manager.c
> ===================================================================
> --- linux.orig/drivers/pnp/manager.c
> +++ linux/drivers/pnp/manager.c
> @@ -18,11 +18,27 @@
>
>  DEFINE_MUTEX(pnp_res_mutex);
>
> +static struct resource *pnp_find_resource(struct pnp_dev *dev,
> +                                         unsigned char rule,
> +                                         unsigned long type,
> +                                         unsigned int bar)
> +{
> +       struct resource *res = pnp_get_resource(dev, type, bar);
> +
> +       /* when the resource already exists, set its resource bits from rule */
> +       if (res) {
> +               res->flags &= ~IORESOURCE_BITS;
> +               res->flags |= rule & IORESOURCE_BITS;
> +       }
> +
> +       return res;
> +}
> +
>  static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
>  {
>        struct resource *res, local_res;
>
> -       res = pnp_get_resource(dev, IORESOURCE_IO, idx);
> +       res = pnp_find_resource(dev, rule->flags, IORESOURCE_IO, idx);
>        if (res) {
>                pnp_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
>                        "flags %#lx\n", idx, (unsigned long long) res->start,
> @@ -65,7 +81,7 @@ static int pnp_assign_mem(struct pnp_dev
>  {
>        struct resource *res, local_res;
>
> -       res = pnp_get_resource(dev, IORESOURCE_MEM, idx);
> +       res = pnp_find_resource(dev, rule->flags, IORESOURCE_MEM, idx);
>        if (res) {
>                pnp_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
>                        "flags %#lx\n", idx, (unsigned long long) res->start,
> @@ -78,6 +94,7 @@ static int pnp_assign_mem(struct pnp_dev
>        res->start = 0;
>        res->end = 0;
>
> +       /* ??? rule->flags restricted to 8 bits, all tests bogus ??? */
>        if (!(rule->flags & IORESOURCE_MEM_WRITEABLE))
>                res->flags |= IORESOURCE_READONLY;
>        if (rule->flags & IORESOURCE_MEM_CACHEABLE)
> @@ -123,7 +140,7 @@ static int pnp_assign_irq(struct pnp_dev
>                5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
>        };
>
> -       res = pnp_get_resource(dev, IORESOURCE_IRQ, idx);
> +       res = pnp_find_resource(dev, rule->flags, IORESOURCE_IRQ, idx);
>        if (res) {
>                pnp_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
>                        idx, (int) res->start, res->flags);
> @@ -182,7 +199,7 @@ static int pnp_assign_dma(struct pnp_dev
>                1, 3, 5, 6, 7, 0, 2, 4
>        };
>
> -       res = pnp_get_resource(dev, IORESOURCE_DMA, idx);
> +       res = pnp_find_resource(dev, rule->flags, IORESOURCE_DMA, idx);
>        if (res) {
>                pnp_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
>                        idx, (int) res->start, res->flags);
>
