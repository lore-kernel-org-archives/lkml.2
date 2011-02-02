Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1BBKxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:53:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62875 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1BBKxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:53:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m64IQ3WhMi1EUIZOWVPGVsh7t8rsgabHiqES9SI/DYOOTyRpkHA7+Fhs6CtXD0JP21
         T1x0h82oABDOA7HAD5/yTuG4e4YKGpBROlj++bT9OTpKWRTBWGkiIHgdv3b9xkJT/F+W
         WTgaaaznpsZe/lPz5P3HxBMB28+XNYC1A7ePQ=
MIME-Version: 1.0
In-Reply-To: <20110202004349.64A543E09BD@tassilo.jf.intel.com>
References: <20110201443.618138584@firstfloor.org>
	<20110202004349.64A543E09BD@tassilo.jf.intel.com>
Date: Wed, 2 Feb 2011 11:53:44 +0100
Message-ID: <AANLkTim4df7n9gky1sTgqchi+8KrrxV7JEf3mVq8O3f7@mail.gmail.com>
Subject: Re: [PATCH] [34/139] mac80211: Fix BUG in pskb_expand_head when
 transmitting shared skbs
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 1:43 AM, Andi Kleen <andi@firstfloor.org> wrote:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.

There has been a followup patch to this one [1]. That should be
considered as well.

Thanks,
Helmut

[1] http://www.spinics.net/lists/linux-wireless/msg61531.html

> ------------------
> From: Helmut Schaa <helmut.schaa@googlemail.com>
>
> commit 7e2447075690860e2cea96b119fc9cadbaa7e83c upstream.
>
> mac80211 doesn't handle shared skbs correctly at the moment. As a result
> a possible resize can trigger a BUG in pskb_expand_head.
>
> [  676.030000] Kernel bug detected[#1]:
> [  676.030000] Cpu 0
> [  676.030000] $ 0   : 00000000 00000000 819662ff 00000002
> [  676.030000] $ 4   : 81966200 00000020 00000000 00000020
> [  676.030000] $ 8   : 819662e0 800043c0 00000002 00020000
> [  676.030000] $12   : 3b9aca00 00000000 00000000 00470000
> [  676.030000] $16   : 80ea2000 00000000 00000000 00000000
> [  676.030000] $20   : 818aa200 80ea2018 80ea2000 00000008
> [  676.030000] $24   : 00000002 800ace5c
> [  676.030000] $28   : 8199a000 8199bd20 81938f88 80f180d4
> [  676.030000] Hi    : 0000026e
> [  676.030000] Lo    : 0000757e
> [  676.030000] epc   : 801245e4 pskb_expand_head+0x44/0x1d8
> [  676.030000]     Not tainted
> [  676.030000] ra    : 80f180d4 ieee80211_skb_resize+0xb0/0x114 [mac80211]
> [  676.030000] Status: 1000a403    KERNEL EXL IE
> [  676.030000] Cause : 10800024
> [  676.030000] PrId  : 0001964c (MIPS 24Kc)
> [  676.030000] Modules linked in: mac80211_hwsim rt2800lib rt2x00soc rt2x00pci rt2x00lib mac80211 crc_itu_t crc_ccitt cfg80211 compat arc4 aes_generic deflate ecb cbc [last unloaded: rt2800pci]
> [  676.030000] Process kpktgend_0 (pid: 97, threadinfo=8199a000, task=81879f48, tls=00000000)
> [  676.030000] Stack : ffffffff 00000000 00000000 00000014 00000004 80ea2000 00000000 00000000
> [  676.030000]         818aa200 80f180d4 ffffffff 0000000a 81879f78 81879f48 81879f48 00000018
> [  676.030000]         81966246 80ea2000 818432e0 80f1a420 80203050 81814d98 00000001 81879f48
> [  676.030000]         81879f48 00000018 81966246 818432e0 0000001a 8199bdd4 0000001c 80f1b72c
> [  676.030000]         80203020 8001292c 80ef4aa2 7f10b55d 801ab5b8 81879f48 00000188 80005c90
> [  676.030000]         ...
> [  676.030000] Call Trace:
> [  676.030000] [<801245e4>] pskb_expand_head+0x44/0x1d8
> [  676.030000] [<80f180d4>] ieee80211_skb_resize+0xb0/0x114 [mac80211]
> [  676.030000] [<80f1a420>] ieee80211_xmit+0x150/0x22c [mac80211]
> [  676.030000] [<80f1b72c>] ieee80211_subif_start_xmit+0x6f4/0x73c [mac80211]
> [  676.030000] [<8014361c>] pktgen_thread_worker+0xfac/0x16f8
> [  676.030000] [<8002ebe8>] kthread+0x7c/0x88
> [  676.030000] [<80008e0c>] kernel_thread_helper+0x10/0x18
> [  676.030000]
> [  676.030000]
> [  676.030000] Code: 24020001  10620005  2502001f <0200000d> 0804917a  00000000  2502001f  00441023  00531021
>
> Fix this by making a local copy of shared skbs prior to mangeling them.
> To avoid copying the skb unnecessarily move the skb_copy call below the
> checks that don't need write access to the skb.
>
> Also, move the assignment of nh_pos and h_pos below the skb_copy to point
> to the correct skb.
>
> It would be possible to avoid another resize of the copied skb by using
> skb_copy_expand instead of skb_copy but that would make the patch more
> complex. Also, shared skbs are a corner case right now, so the resize
> shouldn't matter much.
>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  net/mac80211/tx.c |   21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> Index: linux-2.6.35.y/net/mac80211/tx.c
> ===================================================================
> --- linux-2.6.35.y.orig/net/mac80211/tx.c
> +++ linux-2.6.35.y/net/mac80211/tx.c
> @@ -1679,15 +1679,13 @@ netdev_tx_t ieee80211_subif_start_xmit(s
>        int nh_pos, h_pos;
>        struct sta_info *sta = NULL;
>        u32 sta_flags = 0;
> +       struct sk_buff *tmp_skb;
>
>        if (unlikely(skb->len < ETH_HLEN)) {
>                ret = NETDEV_TX_OK;
>                goto fail;
>        }
>
> -       nh_pos = skb_network_header(skb) - skb->data;
> -       h_pos = skb_transport_header(skb) - skb->data;
> -
>        /* convert Ethernet header to proper 802.11 header (based on
>         * operation mode) */
>        ethertype = (skb->data[12] << 8) | skb->data[13];
> @@ -1859,6 +1857,20 @@ netdev_tx_t ieee80211_subif_start_xmit(s
>                goto fail;
>        }
>
> +       /*
> +        * If the skb is shared we need to obtain our own copy.
> +        */
> +       if (skb_shared(skb)) {
> +               tmp_skb = skb;
> +               skb = skb_copy(skb, GFP_ATOMIC);
> +               kfree_skb(tmp_skb);
> +
> +               if (!skb) {
> +                       ret = NETDEV_TX_OK;
> +                       goto fail;
> +               }
> +       }
> +
>        hdr.frame_control = fc;
>        hdr.duration_id = 0;
>        hdr.seq_ctrl = 0;
> @@ -1877,6 +1889,9 @@ netdev_tx_t ieee80211_subif_start_xmit(s
>                encaps_len = 0;
>        }
>
> +       nh_pos = skb_network_header(skb) - skb->data;
> +       h_pos = skb_transport_header(skb) - skb->data;
> +
>        skb_pull(skb, skip_header_bytes);
>        nh_pos -= skip_header_bytes;
>        h_pos -= skip_header_bytes;
>
