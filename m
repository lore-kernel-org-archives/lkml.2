Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1JLNfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:35:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40016 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1JLNf2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:35:28 -0400
MIME-Version: 1.0
In-Reply-To: <1318422455-17539-14-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
	<1318422455-17539-14-git-send-email-philipp.reisner@linbit.com>
Date: Wed, 12 Oct 2011 15:35:28 +0200
X-Google-Sender-Auth: xHRcxoeQ24HKaonqUIxMPPdJjG4
Message-ID: <CAMuHMdXGCEUGanrsyFkgyr3ZAr5YpgrjbVqJtvCu5Li6XMMDMA@mail.gmail.com>
Subject: Re: [PATCH 13/13] DRBD: Fix comparison always false warning due to
 long/long long compare
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philipp Reisner <philipp.reisner@linbit.com>,
        David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 14:27, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> From: David Howells <dhowells@redhat.com>
>
> Fix warnings of the following nature in the drbd header:
>
> In file included from drivers/block/drbd/drbd_bitmap.c:32:
> drivers/block/drbd/drbd_int.h: In function 'drbd_get_syncer_progress':
> drivers/block/drbd/drbd_int.h:2234: warning: comparison is always false due to limited range of data
>
> where mdev->rs_total (an unsigned long) is being compared to 1ULL << 32, which
> is always false on a 32-bit machine.

But on 32-bit, unsigned long is never larger than UINT_MAX neither, so
it doesn't
really change anything??

> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
>
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> ---
>  drivers/block/drbd/drbd_int.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
> index ece2e4a..de42c7c 100644
> --- a/drivers/block/drbd/drbd_int.h
> +++ b/drivers/block/drbd/drbd_int.h
> @@ -2071,7 +2071,7 @@ static inline void drbd_get_syncer_progress(struct drbd_conf *mdev,
>                 * Note: currently we don't support such large bitmaps on 32bit
>                 * arch anyways, but no harm done to be prepared for it here.
>                 */
> -               unsigned int shift = mdev->rs_total >= (1ULL << 32) ? 16 : 10;
> +               unsigned int shift = mdev->rs_total > UINT_MAX ? 16 : 10;
>                unsigned long left = *bits_left >> shift;
>                unsigned long total = 1UL + (mdev->rs_total >> shift);
>                unsigned long tmp = 1000UL - left * 1000UL/total;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
