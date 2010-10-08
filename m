Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0JHMWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:22:10 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35090 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277Ab0JHMWI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:22:08 -0400
Message-Id: <1286540528.5117.1399034495@webmail.messagingengine.com>
X-Sasl-Enc: xvtg6j56oYCOlqBZyiQXDjyjoHWUcafR7jrqTs5YaiON 1286540528
From: "Jack Stone" <jwjstone@fastmail.fm>
To: "Nicolas Kaiser" <nikai@nikai.net>,
        "Dan Williams" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: MessagingEngine.com Webmail Interface
References: <20101008004801.2f0dee47@absol.kitzblitz>
Subject: Re: [PATCH] dma/timberdale: simplify conditional
In-Reply-To: <20101008004801.2f0dee47@absol.kitzblitz>
Date: Fri, 08 Oct 2010 13:22:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



We should be careful with this sort of transformation. It is only
guaranteed true if both sides are boolean. E.g. ((foo & mask) && (bar &
baz)) ¦¦ (!(foo & mask) && (!(bar & baz)) does not imply (foo & mask) ==
(bar & baz)). foo & mask could equal 0x0100 for example but bar & baz
could equal 0x0001. Both are true as logicals but they are not equal.

One safe way to make this patch would be to add !! in front of both
halves.

Of course this is a moot point if pdes->rx is a boolean or a single bit
but I don't have the source to hand to check this (% 2 is guaranteed to
be 0 or 1 so it doesn't matter).

Sorry if this doesn't make sense. Let me know and I can try and
rephrase.

Hope this helps,
Jack

On Fri, 08 Oct 2010 00:48 +0200, "Nicolas Kaiser" <nikai@nikai.net>
wrote:
> Simplify: ((a && b) || (!a && !b)) => (a == b)
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  drivers/dma/timb_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
> index 2ec1ed5..3b88a4e 100644
> --- a/drivers/dma/timb_dma.c
> +++ b/drivers/dma/timb_dma.c
> @@ -759,7 +759,7 @@ static int __devinit td_probe(struct platform_device
> *pdev)
>  			pdata->channels + i;
>  
>  		/* even channels are RX, odd are TX */
> -               if (((i % 2) && pchan->rx) || (!(i % 2) && !pchan->rx)) {
> +               if ((i % 2) == pchan->rx) {
>  			dev_err(&pdev->dev, "Wrong channel configuration\n");
>  			err = -EINVAL;
>  			goto err_tasklet_kill;
> -- 
> 1.7.2.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
