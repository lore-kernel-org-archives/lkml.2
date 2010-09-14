Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0INRoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:44:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41070 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab0INRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:44:14 -0400
Message-ID: <4C8FB43D.5020604@ru.mvista.com>
Date: Tue, 14 Sep 2010 21:43:25 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: tom.leiming@gmail.com
CC: greg@kroah.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 6/6] USB: musb-gadget: fix dma length in txstate
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com> <1283873014-32511-7-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1283873014-32511-7-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>

> DMA length should not go beyond the availabe space of request buffer,
> so fix it.

> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Felipe Balbi <me@felipebalbi.com>
> Cc: Anand Gadiyar <gadiyar@ti.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>

[...]

> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> index fa826f9..cacae96 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -300,6 +300,11 @@ static void txstate(struct musb *musb, struct musb_request *req)
>  #ifndef	CONFIG_MUSB_PIO_ONLY
>  	if (is_dma_capable() && musb_ep->dma) {
>  		struct dma_controller	*c = musb->dma_controller;
> +		size_t request_size;
> +
> +		/* setup DMA, then program endpoint CSR */
> +		request_size = min_t(size_t, request->length - request->actual,
> +					musb_ep->dma->max_len);

    Er, you're moving this from under #ifdef CONFIG_USB_INVENTRA_DMA to the 
common code, right? Do you know that not all DMA drivers initialize max_len? For 
example CPPI driver doesn't, so it's left at zero. You're going to break DMA for 
CPPI. Please extend your patch, adding cppi_dma.c to it.

> @@ -307,11 +312,6 @@ static void txstate(struct musb *musb, struct musb_request *req)
>  
>  #ifdef CONFIG_USB_INVENTRA_DMA
>  		{
> -			size_t request_size;
> -
> -			/* setup DMA, then program endpoint CSR */
> -			request_size = min_t(size_t, request->length,
> -						musb_ep->dma->max_len);
>  			if (request_size < musb_ep->packet_sz)
>  				musb_ep->dma->desired_mode = 0;
>  			else

WBR, Sergei
