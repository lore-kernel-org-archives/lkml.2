Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1LZRvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 12:51:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1LZRvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 12:51:43 -0500
Message-ID: <4EF8B42C.2020402@lwfinger.net>
Date: Mon, 26 Dec 2011 11:51:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: fix regression in PIO case
References: <alpine.DEB.2.00.1112261608140.12108@axis700.grange> <alpine.DEB.2.00.1112261824000.12108@axis700.grange>
In-Reply-To: <alpine.DEB.2.00.1112261824000.12108@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2011 11:28 AM, Guennadi Liakhovetski wrote:
> This patch fixes the regression, introduced by
>
> commit 17030f48e31adde5b043741c91ba143f5f7db0fd
> From: Rafa³ Mi³ecki<zajec5@gmail.com>
> Date: Thu, 11 Aug 2011 17:16:27 +0200
> Subject: [PATCH] b43: support new RX header, noticed to be used in 598.314+ fw
>
> in PIO case.
>
> Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> ---
> diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
> index ce8a4bd..b64b64c 100644
> --- a/drivers/net/wireless/b43/pio.c
> +++ b/drivers/net/wireless/b43/pio.c
> @@ -617,9 +617,19 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
>   	const char *err_msg = NULL;
>   	struct b43_rxhdr_fw4 *rxhdr =
>   		(struct b43_rxhdr_fw4 *)wl->pio_scratchspace;
> +	size_t rxhdr_size = sizeof(*rxhdr);
>
>   	BUILD_BUG_ON(sizeof(wl->pio_scratchspace)<  sizeof(*rxhdr));
> -	memset(rxhdr, 0, sizeof(*rxhdr));
> +	switch (dev->fw.hdr_format) {
> +	case B43_FW_HDR_410:
> +	case B43_FW_HDR_351:
> +		rxhdr_size -= sizeof(rxhdr->format_598) -
> +			sizeof(rxhdr->format_351);
> +		break;
> +	case B43_FW_HDR_598:
> +		break;
> +	}

I do not think the above will work for format_410. By my count, the format_410 
struct is 4 bytes longer than the format_351 struct.

Even if it does work, I suggest using the following:

	size_t rxhdr_size;

    	BUILD_BUG_ON(sizeof(wl->pio_scratchspace)<  sizeof(*rxhdr));
	switch (dev->fw.hdr_format) {
	case B43_FW_HDR_351:
		rxhdr_size = sizeof(rxhdr->format_351);
		break;
	case B43_FW_HDR_410:
etc.


Larry
