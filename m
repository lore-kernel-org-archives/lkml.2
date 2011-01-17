Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1AQK2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:28:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47559 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1AQK2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:28:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W4uExICCwET3eZ0GVJsxz1r8h99SZKv8juSblumm2jpYWO8VCgA3liom+ucA7z8a42
         +aMn8QSRoQAUqwx/sQk+AmKuMiHdUqsxyKPZqilq2xw/ECZFbGCb30E3OE9T+6bg3PtP
         IFXpYfktGdQp2FIs0X4HYEWfAjKznkdNHiA3M=
MIME-Version: 1.0
In-Reply-To: <1295258917-31092-1-git-send-email-segoon@openwall.com>
References: <1295258917-31092-1-git-send-email-segoon@openwall.com>
Date: Mon, 17 Jan 2011 12:28:29 +0200
Message-ID: <AANLkTi=5GpSEsGNMcfTVDyo_cHoELPaD8EmJGUhPxPw2@mail.gmail.com>
Subject: Re: [PATCH] net: bluetooth: fix locking problem
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 12:08 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> If alloc_skb() failed we still hold hci_dev_list_lock.  The code should
> unlock it before exit.
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested only.
>
>  net/bluetooth/mgmt.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index f827fd9..ace8726 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -111,8 +111,10 @@ static int read_index_list(struct sock *sk)
>
>        body_len = sizeof(*ev) + sizeof(*rp) + (2 * count);
>        skb = alloc_skb(sizeof(*hdr) + body_len, GFP_ATOMIC);
> -       if (!skb)
> +       if (!skb) {
> +               read_unlock(&hci_dev_list_lock);
>                return -ENOMEM;
> +       }

patch was send already on weekend

>
>        hdr = (void *) skb_put(skb, sizeof(*hdr));
>        hdr->opcode = cpu_to_le16(MGMT_EV_CMD_COMPLETE);
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
