Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1CYEIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 00:08:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49522 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1CYEIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 00:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HlEyTjjcIyHn8X8Eh27jAZopKoJ+L8xgMNwDz1a1t0sVHCKcVovXfCQJczwupxxcRd
         +aOqrFzOiVzka/0xLyxmjRnfbq7PFfFqGvz9WnhCs1HqFiBV/47UdASgiSf2/kpcOSOy
         Oww8G0p/Sg1oippPVhdyHwIc3lx9d0sVnXwpQ=
MIME-Version: 1.0
In-Reply-To: <20110325143049.2e65091f.sfr@canb.auug.org.au>
References: <20110325143049.2e65091f.sfr@canb.auug.org.au>
Date: Fri, 25 Mar 2011 13:08:51 +0900
Message-ID: <AANLkTimZb9x7-5maMU-jibxLdq1pW=CVE4ABXsX6jJRN@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the block tree
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/25 Stephen Rothwell <sfr@canb.auug.org.au>:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 25 Mar 2011 14:27:57 +1100
> Subject: [PATCH] drbd: update for bitop api changes
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/block/drbd/drbd_bitmap.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
> index f0ae63d..eb925fa 100644
> --- a/drivers/block/drbd/drbd_bitmap.c
> +++ b/drivers/block/drbd/drbd_bitmap.c

Please remove "#include <asm-generic/bitops/le.h>" from this file.

> @@ -1184,10 +1184,10 @@ static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
>                        p_addr = __bm_map_pidx(b, bm_bit_to_page_idx(b, bm_fo), km);
>
>                        if (find_zero_bit)
> -                               i = generic_find_next_zero_le_bit(p_addr,
> +                               i = find_next_zero_bit_le(p_addr,
>                                                PAGE_SIZE*8, bm_fo & BITS_PER_PAGE_MASK);
>                        else
> -                               i = generic_find_next_le_bit(p_addr,
> +                               i = find_next_bit_le(p_addr,
>                                                PAGE_SIZE*8, bm_fo & BITS_PER_PAGE_MASK);
>
>                        __bm_unmap(p_addr, km);
> @@ -1287,9 +1287,9 @@ static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
>                        last_page_nr = page_nr;
>                }
>                if (val)
> -                       c += (0 == generic___test_and_set_le_bit(bitnr & BITS_PER_PAGE_MASK, p_addr));
> +                       c += (0 == __test_and_set_bit_le(bitnr & BITS_PER_PAGE_MASK, p_addr));
>                else
> -                       c -= (0 != generic___test_and_clear_le_bit(bitnr & BITS_PER_PAGE_MASK, p_addr));
> +                       c -= (0 != __test_and_clear_bit_le(bitnr & BITS_PER_PAGE_MASK, p_addr));
>        }
>        if (p_addr)
>                __bm_unmap(p_addr, km);
> @@ -1438,7 +1438,7 @@ int drbd_bm_test_bit(struct drbd_conf *mdev, const unsigned long bitnr)
>                bm_print_lock_info(mdev);
>        if (bitnr < b->bm_bits) {
>                p_addr = bm_map_pidx(b, bm_bit_to_page_idx(b, bitnr));
> -               i = generic_test_le_bit(bitnr & BITS_PER_PAGE_MASK, p_addr) ? 1 : 0;
> +               i = test_bit_le(bitnr & BITS_PER_PAGE_MASK, p_addr) ? 1 : 0;
>                bm_unmap(p_addr);
>        } else if (bitnr == b->bm_bits) {
>                i = -1;
> @@ -1482,7 +1482,7 @@ int drbd_bm_count_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
>                ERR_IF (bitnr >= b->bm_bits) {
>                        dev_err(DEV, "bitnr=%lu bm_bits=%lu\n", bitnr, b->bm_bits);
>                } else {
> -                       c += (0 != generic_test_le_bit(bitnr - (page_nr << (PAGE_SHIFT+3)), p_addr));
> +                       c += (0 != test_bit_le(bitnr - (page_nr << (PAGE_SHIFT+3)), p_addr));
>                }
>        }
>        if (p_addr)
> --
> 1.7.4.1
>
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
