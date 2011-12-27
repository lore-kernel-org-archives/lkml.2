Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab1L0SrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 13:47:11 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36473 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1L0SrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:47:07 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1112261824000.12108@axis700.grange>
References: <alpine.DEB.2.00.1112261608140.12108@axis700.grange>
	<alpine.DEB.2.00.1112261824000.12108@axis700.grange>
Date: Tue, 27 Dec 2011 19:47:06 +0100
Message-ID: <CACna6ry1tKXtUSQHknkEbzBq_gZUyxn1-9Guba2a56xzx242SA@mail.gmail.com>
Subject: Re: [PATCH] b43: fix regression in PIO case
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 26 grudnia 2011 18:28 użytkownik Guennadi Liakhovetski
<g.liakhovetski@gmx.de> napisał:
> This patch fixes the regression, introduced by
>
> commit 17030f48e31adde5b043741c91ba143f5f7db0fd
> From: Rafał Miłecki <zajec5@gmail.com>
> Date: Thu, 11 Aug 2011 17:16:27 +0200
> Subject: [PATCH] b43: support new RX header, noticed to be used in 598.314+ fw
>
> in PIO case.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
> index ce8a4bd..b64b64c 100644
> --- a/drivers/net/wireless/b43/pio.c
> +++ b/drivers/net/wireless/b43/pio.c
> @@ -617,9 +617,19 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
>        const char *err_msg = NULL;
>        struct b43_rxhdr_fw4 *rxhdr =
>                (struct b43_rxhdr_fw4 *)wl->pio_scratchspace;
> +       size_t rxhdr_size = sizeof(*rxhdr);
>
>        BUILD_BUG_ON(sizeof(wl->pio_scratchspace) < sizeof(*rxhdr));
> -       memset(rxhdr, 0, sizeof(*rxhdr));
> +       switch (dev->fw.hdr_format) {
> +       case B43_FW_HDR_410:
> +       case B43_FW_HDR_351:
> +               rxhdr_size -= sizeof(rxhdr->format_598) -
> +                       sizeof(rxhdr->format_351);
> +               break;
> +       case B43_FW_HDR_598:
> +               break;
> +       }
> +       memset(rxhdr, 0, rxhdr_size);

Huuh, that's really tricky. Can you just do "normal" conditions as
Larry suggested, please?

-- 
Rafał
