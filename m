Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0LDBds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 20:33:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46349 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0LDBdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 20:33:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AkqBM9k7vlq9tvxnw1Q2Kyw3e1yBXSNckw6ueUhfPyWeH4G9j+RNKFL9/KHF+/rHJn
         LNiOYhdZFJ7RWxwdyWEg9RsfmC6pSLrrc4hUy/MjWhGq3p3lFMgytUo8ESmgyK5XH7ef
         9kDvJBV0FYLqWX3ynqMkKtGtMC1X0DUwptfRc=
MIME-Version: 1.0
In-Reply-To: <4CF6284C.1010802@dsn.okisemi.com>
References: <4CF6284C.1010802@dsn.okisemi.com>
Date: Fri, 3 Dec 2010 17:33:45 -0800
X-Google-Sender-Auth: 1kc0c_g1aP0ze5dn6eYigQ3lWwY
Message-ID: <AANLkTi=BOYUwEAxWBhYVhco-Eo2n1isbb_kbJkao11XP@mail.gmail.com>
Subject: Re: [PATCH] dma : EG20T PCH: Fix miss-setting DMA descriptor
From: Dan Williams <dan.j.williams@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, kok.howg.ewe@intel.com,
        "Wang Qi\"" <qi.wang@intel.com>,
        "Wang Yong Y\"" <yong.y.wang@intel.com>,
        "Intel OTC\"" <joel.clark@intel.com>, margie.foster@intel.com,
        "Andrew\"" <andrew.chih.howe.khor@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/1 Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>:
> From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
>
>
>
> Currently, in case of using scatter/gather mode, head of data is not sent to
>
> destination. The cause is second descriptor address is set to NEXT.
>
> The NEXT must have head of descriptor address.
>
> This patch sets head of descriptor address to the NEXT.
>
>
>
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/dma/pch_dma.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 92b6790..a3d54c0 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
[..]
> @@ -273,10 +268,16 @@ static void pdc_dostart(struct pch_dma_chan *pd_chan, struct pch_dma_desc* desc)
>        dev_dbg(chan2dev(&pd_chan->chan), "chan %d -> next: %x\n",
>                pd_chan->chan.chan_id, desc->regs.next);
>
> -       if (list_empty(&desc->tx_list))
> +       if (list_empty(&desc->tx_list)) {
> +               channel_writel(pd_chan, DEV_ADDR, desc->regs.dev_addr);
> +               channel_writel(pd_chan, MEM_ADDR, desc->regs.mem_addr);
> +               channel_writel(pd_chan, SIZE, desc->regs.size);
> +               channel_writel(pd_chan, NEXT, desc->regs.next);
>                pdc_set_mode(&pd_chan->chan, DMA_CTL0_ONESHOT);
> -       else
> +       } else {
> +               channel_writel(pd_chan, NEXT, virt_to_phys(&desc->regs));

There is a reason for the following comment for virt_to_phys():

/*      This function does not give bus mappings for DMA transfers. In
 *      almost all conceivable cases a device driver should not be using
 *      this function
 */

...in this case this wants to be:

     channel_write(pd_chan, NEXT, desc->txd.phys);

I'll let Yong comment on the correctness of the rest.

--
Dan
