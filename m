Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2ICIZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:25:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60001 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2ICIZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <50439D44.3080100@yahoo.es>
References: <50439D44.3080100@yahoo.es>
Date: Mon, 3 Sep 2012 11:25:13 +0300
Message-ID: <CAHp75VcQOeVeKPg8z9u+fd8ia4QAyrq6UQn-D7Q-yO9+pLS6LQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] dw_dmac: max_mem_width limits value for
 SRC/DST_TR_WID register
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        viresh kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 8:54 PM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> From: Hein Tibosch <hein_tibosch@yahoo.es>
>
> v4: now based and tested on 3.6-rc4
>
> The dw_dmac driver was earlier adapted to do 64-bit transfers on the memory
> side (see https://lkml.org/lkml/2012/1/18/52)
> This works on ARM platforms but for AVR32 (AP700x) the maximum allowed transfer
> size is 32-bits.
> This patch allows the arch code to set a new slave property max_mem_width to
> limit the size.
>
> Allowable values are:
>
> #define DW_MEM_WIDTH_64         0       /* default */
> #define DW_MEM_WIDTH_32         1       /* e.g. for avr32 */
There are 4 options: 32, 64, 128, and 256 bits. I would prefer to see
the value in conjunction with
real value in the register, namely 2 for 32, 3 - 64, 4 - 128, 5 - 256.

> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index d3c5a5a..311953c 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -190,14 +190,14 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
>  }
>
>  /*----------------------------------------------------------------------*/
> -
> -static inline unsigned int dwc_fast_fls(unsigned long long v)
> +static inline unsigned int dwc_fast_fls(unsigned long long v,
> +       struct dw_dma_slave *dws)
>  {
>         /*
>          * We can be a lot more clever here, but this should take care
>          * of the most common optimization.
>          */
> -       if (!(v & 7))
> +       if (dws->max_mem_width == DW_MEM_WIDTH_64 && !(v & 7))
>                 return 3;
>         else if (!(v & 3))
>                 return 2;

> @@ -655,7 +656,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>                 return NULL;
>         }
>
> -       src_width = dst_width = dwc_fast_fls(src | dest | len);
> +       src_width = dst_width = dwc_fast_fls(src | dest | len, dws);
And taking into consideration my upper comment, it could be easier to use
min_t(unsigned int, max_mem_width, dwc_fast_fls(...)) here and there.

> @@ -58,6 +58,9 @@ struct dw_dma_slave {
>         u32                     cfg_lo;
>         u8                      src_master;
>         u8                      dst_master;
> +#define        DW_MEM_WIDTH_64         0
> +#define        DW_MEM_WIDTH_32         1       /* e.g. for avr32 */
> +       u8                      max_mem_width;
Might be I missed something, but why is it slave configuration?
I think the controller (actually channel) structure is more suitable
to keep that field inside.

-- 
With Best Regards,
Andy Shevchenko
