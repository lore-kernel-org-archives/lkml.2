Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2DIHJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:09:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65414 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab2DIHJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <1333606083.31825.4.camel@vkoul-udesk3>
References: <CACKLOr2-=BF4AV=ZDizj9D37OL-d9D06p6R+dp9cJ_vDbBwqBw@mail.gmail.com>
	<1333606083.31825.4.camel@vkoul-udesk3>
Date: Mon, 9 Apr 2012 09:09:33 +0200
Message-ID: <CACKLOr2ZUpLQDWp4sBSxEWPmh15dO4exOvydZfm1FcCcGspnJg@mail.gmail.com>
Subject: Re: [dmaengine] Cyclic DMA regression.
From: javier Martin <javier.martin@vista-silicon.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2012 08:08, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> this is not right fix. The problem is that we shouldn't mark the cyclic
> descriptor as complete. So for all drivers using cyclic API they should
> do something like this. Can you test if this fixes your issue.
> -----------------
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index a45b5d2..0c7362a 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -571,11 +571,14 @@ static void imxdma_tasklet(unsigned long data)
>        if (desc->desc.callback)
>                desc->desc.callback(desc->desc.callback_param);
>
> -       dma_cookie_complete(&desc->desc);
> -
> -       /* If we are dealing with a cyclic descriptor keep it on ld_active */
> +       /* If we are dealing with a cyclic descriptor keep it on ld_active
> +        * and don't mark the descriptor as complete.
> +        * Only in non-cyclic cases it would be marked as complete
> +        */
>        if (imxdma_chan_is_doing_cyclic(imxdmac))
>                goto out;
> +       else
> +               dma_cookie_complete(&desc->desc);
>
>        /* Free 2D slot if it was an interleaved transfer */
>        if (imxdmac->enabled_2d) {
>
>
> --
> ~Vinod
>

Hi Vinod,
thank you for your patch.

It works fine for me:

Tested-by: Javier Martin <javier.martin@vista-silicon.com>

Could you apply it in your tree as a fix for 3.4?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
