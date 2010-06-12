Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0FLAFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 20:05:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40620 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0FLAFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 20:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=t/bsh64yebcBU+cweIUMCXCD37Auzje0QBMLY/GwTBAh80y9p6pInFIQnymzjKPMYU
         PmqNNvvJrikOq/y1H1Z/Y+4C6uK+0deSPIo6t15jba7Eg9dx43czyO784msiD/EIViYl
         X+BXY4WpAIPoyXbjtMG1JAsNe0pax77GIfr4Y=
MIME-Version: 1.0
In-Reply-To: <1275394921-26633-1-git-send-email-linus.walleij@stericsson.com>
References: <1275394921-26633-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 11 Jun 2010 17:05:31 -0700
X-Google-Sender-Auth: X05gQzGZsmMTX1jP6IMjDdqXZnU
Message-ID: <AANLkTikY8bV1DbMEspUNivD2zTiZOyNKL4ydHttLrFKk@mail.gmail.com>
Subject: Re: [PATCH 12/18] DMAENGINE: ste_dma40: allocate LCLA dynamically
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 5:22 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> Switch to allocating LCLA in memory instead of having a fixed
> address.
>
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/dma/ste_dma40.c    |  246 +++++++++++++++++++++++++++-----------------
>  drivers/dma/ste_dma40_ll.c |    5 +-
>  drivers/dma/ste_dma40_ll.h |   12 +-
>  3 files changed, 161 insertions(+), 102 deletions(-)
>
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 5579401..ec092fa 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
[..]
> @@ -2482,6 +2501,71 @@ static void __init d40_hw_init(struct d40_base *base)
>
>  }
>
> +static int __init d40_lcla_allocate(struct d40_base *base)
> +{
> +       unsigned long *page_list;
> +       int i, j;
> +       int ret = 0;
> +
> +       /*
> +        * This is somewhat ugly. We need 8192 bytes that are 18 bit aligned,
> +        * To full fill this hardware requirement without wasting 256 kb
> +        * we allocate pages until we get an aligned one.
> +        */
> +       page_list = kmalloc(sizeof(unsigned long) * MAX_LCLA_ALLOC_ATTEMPTS,
> +                           GFP_KERNEL);
> +
> +       if (!page_list) {
> +               ret = -ENOMEM;
> +               goto failure;
> +       }
> +
> +       /* Calculating how many pages that are required */
> +       base->lcla_pool.pages = SZ_1K * (base->num_phy_chans + PAGE_SIZE /
> +                                        SZ_1K - 1) / PAGE_SIZE + 3;
> +

What?

> +       for (i = 0; i < MAX_LCLA_ALLOC_ATTEMPTS; i++) {
> +               page_list[i] = __get_free_pages(GFP_KERNEL,
> +                                               base->lcla_pool.pages);
> +
> +               if ((virt_to_phys((void *)page_list[i]) &
> +                    (LCLA_ALIGNMENT - 1)) == 0 && page_list[i] != 0)
> +                       break;

It looks odd to test for page_list[i] being null after determining if
this is the desired alignment.

--
Dan
