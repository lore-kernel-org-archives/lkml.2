Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab1ELTPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:15:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64393 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1ELTPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tRZDNRmGSj6AABSKAH7pKwRZ0fMmlPRnmpDB2UVSP2MS0WFXfY4AJYFl/g8yGNwAwL
         EmznhgNjzqmLzeLHVlTbfy6q5VecdwXVMsuMfaC6aJBMaWSWe8/3N+JLGYcplTocrtmN
         BVB97F3fDgsjMSkXZ32rpfIwFUF74u+/p1+PA=
MIME-Version: 1.0
In-Reply-To: <1305227500-15595-3-git-send-email-geert@linux-m68k.org>
References: <1305227500-15595-1-git-send-email-geert@linux-m68k.org>
	<1305227500-15595-3-git-send-email-geert@linux-m68k.org>
Date: Thu, 12 May 2011 21:15:01 +0200
X-Google-Sender-Auth: n_B6X4nEc-WcDfIBrGZqU47ApvY
Message-ID: <BANLkTinjoDhQRZ+1nc2uow3bWepziGMf0g@mail.gmail.com>
Subject: Re: [PATCH 2/3] hydra: Fix regression caused during net_device_ops conversion
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Russell King <linux@arm.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@chicken.sonytel.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 21:11, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> From: Geert Uytterhoeven <geert@chicken.sonytel.be>

Sorry, the above line is bogus. Please remove it.

> Changeset 5618f0d1193d6b051da9b59b0e32ad24397f06a4 ("hydra: convert to
> net_device_ops") broke hydra by adding 8390.o to the link. That
> meant that lib8390.c was included twice, once in hydra.c and once in
> 8390.c, subject to different macros. This patch reverts that by
> avoiding the wrappers in 8390.c.
>
> Fix based on commits 217cbfa856dc1cbc2890781626c4032d9e3ec59f ("mac8390:
> fix regression caused during net_device_ops conversion") and
> 4e0168fa4842e27795a75b205a510f25b62181d9 ("mac8390: fix build with
> NET_POLL_CONTROLLER").
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: stable@kernel.org
> ---
>  drivers/net/Makefile |    2 +-
>  drivers/net/hydra.c  |   14 +++++++-------
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index c64675f..4d2f094 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -231,7 +231,7 @@ obj-$(CONFIG_SGI_IOC3_ETH) += ioc3-eth.o
>  obj-$(CONFIG_DECLANCE) += declance.o
>  obj-$(CONFIG_ATARILANCE) += atarilance.o
>  obj-$(CONFIG_A2065) += a2065.o
> -obj-$(CONFIG_HYDRA) += hydra.o 8390.o
> +obj-$(CONFIG_HYDRA) += hydra.o
>  obj-$(CONFIG_ARIADNE) += ariadne.o
>  obj-$(CONFIG_CS89x0) += cs89x0.o
>  obj-$(CONFIG_MACSONIC) += macsonic.o
> diff --git a/drivers/net/hydra.c b/drivers/net/hydra.c
> index c5ef62c..1cd481c 100644
> --- a/drivers/net/hydra.c
> +++ b/drivers/net/hydra.c
> @@ -98,15 +98,15 @@ static const struct net_device_ops hydra_netdev_ops = {
>        .ndo_open               = hydra_open,
>        .ndo_stop               = hydra_close,
>
> -       .ndo_start_xmit         = ei_start_xmit,
> -       .ndo_tx_timeout         = ei_tx_timeout,
> -       .ndo_get_stats          = ei_get_stats,
> -       .ndo_set_multicast_list = ei_set_multicast_list,
> +       .ndo_start_xmit         = __ei_start_xmit,
> +       .ndo_tx_timeout         = __ei_tx_timeout,
> +       .ndo_get_stats          = __ei_get_stats,
> +       .ndo_set_multicast_list = __ei_set_multicast_list,
>        .ndo_validate_addr      = eth_validate_addr,
> -       .ndo_set_mac_address    = eth_mac_addr,
> +       .ndo_set_mac_address    = eth_mac_addr,
>        .ndo_change_mtu         = eth_change_mtu,
>  #ifdef CONFIG_NET_POLL_CONTROLLER
> -       .ndo_poll_controller    = ei_poll,
> +       .ndo_poll_controller    = __ei_poll,
>  #endif
>  };
>
> @@ -125,7 +125,7 @@ static int __devinit hydra_init(struct zorro_dev *z)
>        0x10, 0x12, 0x14, 0x16, 0x18, 0x1a, 0x1c, 0x1e,
>     };
>
> -    dev = alloc_ei_netdev();
> +    dev = ____alloc_ei_netdev(0);
>     if (!dev)
>        return -ENOMEM;
>
> --
> 1.7.0.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
