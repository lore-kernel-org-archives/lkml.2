Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2FMJnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:43:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64543 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2FMJnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120613130304.0186fa9d.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120613130054.b5695621.yoshikawa.takuya@oss.ntt.co.jp>
	<20120613130304.0186fa9d.yoshikawa.takuya@oss.ntt.co.jp>
Date: Wed, 13 Jun 2012 18:43:40 +0900
Message-ID: <CAC5umyj582T+9GbOYDzOAanmMcVZ-Fdxr7i-8GWf3gTSmtAKUA@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivers/net/ethernet/dec/tulip: Use standard
 __set_bit_le() function
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: akpm@linux-foundation.org, bhutchings@solarflare.com,
        grundler@parisc-linux.org, arnd@arndb.de, benh@kernel.crashing.org,
        avi@redhat.com, mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/13 Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>:
> From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
>
> To introduce generic set_bit_le() later, we remove our own definition
> and use a proper non-atomic bitops function: __set_bit_le().
>
> Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> Acked-by: Grant Grundler <grundler@parisc-linux.org>
> ---
>  drivers/net/ethernet/dec/tulip/de2104x.c    |    7 ++-----
>  drivers/net/ethernet/dec/tulip/tulip_core.c |    7 ++-----
>  2 files changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
> index 61cc093..77335853 100644
> --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> @@ -661,9 +661,6 @@ static netdev_tx_t de_start_xmit (struct sk_buff *skb,
>    new frame, not around filling de->setup_frame.  This is non-deterministic
>    when re-entered but still correct. */
>
> -#undef set_bit_le
> -#define set_bit_le(i,p) do { ((char *)(p))[(i)/8] |= (1<<((i)%8)); } while(0)
> -
>  static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
>  {
>        struct de_private *de = netdev_priv(dev);
> @@ -673,12 +670,12 @@ static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
>        u16 *eaddrs;
>
>        memset(hash_table, 0, sizeof(hash_table));
> -       set_bit_le(255, hash_table);                    /* Broadcast entry */
> +       __set_bit_le(255, hash_table);                  /* Broadcast entry */

Should this hash_table be converted from u16 hash_table[32] to
DECLARE_BITMAP(hash_table, 16 * 32) to ensure that it is aligned
on long-word boundary?
