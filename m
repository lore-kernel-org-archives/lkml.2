Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab2EMMIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 08:08:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36219 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2EMMIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 08:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120512200901.811D37C0074@ra.kernel.org>
References: <20120512200901.811D37C0074@ra.kernel.org>
Date: Sun, 13 May 2012 14:08:20 +0200
X-Google-Sender-Auth: KpR2foqR_ADN6l3aseeP214kjsQ
Message-ID: <CAMuHMdVuDC7LiYuOdVELsxbbyf1PVZ-QvHY_7pUxigk+DWfysg@mail.gmail.com>
Subject: Re: bonding: don't increase rx_dropped after processing LACPDUs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Bohac <jbohac@suse.cz>, "David S. Miller" <davem@davemloft.net>
Cc: "netdev@vger.kernel.org.Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 10:09 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Author:     Jiri Bohac <jbohac@suse.cz>

>    bonding: don't increase rx_dropped after processing LACPDUs
>
>    Since commit 3aba891d, bonding processes LACP frames (802.3ad
>    mode) with bond_handle_frame(). Currently a copy of the skb is
>    made and the original is left to be processed by other
>    rx_handlers and the rest of the network stack by returning
>    RX_HANDLER_ANOTHER.  As there is no protocol handler for
>    PKT_TYPE_LACPDU, the frame is dropped and dev->rx_dropped
>    increased.
>
>    Fix this by making bond_handle_frame() return RX_HANDLER_CONSUMED
>    if bonding has processed the LACP frame.
>
>    Signed-off-by: Jiri Bohac <jbohac@suse.cz>
>    Signed-off-by: David S. Miller <davem@davemloft.net>

> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1444,8 +1444,9 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
>        struct sk_buff *skb = *pskb;
>        struct slave *slave;
>        struct bonding *bond;
> -       void (*recv_probe)(struct sk_buff *, struct bonding *,
> +       int (*recv_probe)(struct sk_buff *, struct bonding *,
>                                struct slave *);

drivers/net/bonding/bonding.h:struct bonding still has a version that
returns void:

        void     (*recv_probe)(struct sk_buff *, struct bonding *,
                               struct slave *);

drivers/net/bonding/bond_main.c: In function ‘bond_handle_frame’:
drivers/net/bonding/bond_main.c:1463: warning: assignment from
incompatible pointer type
drivers/net/bonding/bond_main.c: In function ‘bond_open’:
drivers/net/bonding/bond_main.c:3441: warning: assignment from
incompatible pointer type
drivers/net/bonding/bond_main.c:3448: warning: assignment from
incompatible pointer type

Can this cause crashes on architectures where the caller needs to
preserve space for the return value?

Don't know why I only start seeing this in -rc7, as the prototypes for the
functions related to the latter 2 warnings haven't changed recently.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
