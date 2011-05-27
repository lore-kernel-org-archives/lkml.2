Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1E0M7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:59:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53351 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab1E0M7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:59:32 -0400
MIME-Version: 1.0
In-Reply-To: <1306476003-4624-3-git-send-email-namhyung@gmail.com>
References: <1306476003-4624-1-git-send-email-namhyung@gmail.com>
	<1306476003-4624-3-git-send-email-namhyung@gmail.com>
Date: Fri, 27 May 2011 08:59:31 -0400
Message-ID: <BANLkTikvtFzDEipU=-SJMLB5rwHu+z01-w@mail.gmail.com>
Subject: Re: [PATCH 3/3] nbd: adjust 'max_part' according to part_shift
From: Paul Clements <paul.clements@us.sios.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Laurent Vivier <Laurent.Vivier@bull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 2:00 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> The 'max_part' parameter determines how many partitions are supported
> on each nbd device. However the actual number can be changed to the
> power of 2 minus 1 form during the module initialization as
> alloc_disk() is called with (1 << part_shift) for some reason.
>
> So adjust 'max_part' also at least for consistency with loop and brd.
> It is exported via sysfs already, and a user should check this value
> after module loading if [s]he wants to use that number correctly
> (i.e. fdisk or something).
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Laurent Vivier <Laurent.Vivier@bull.net>
> Cc: Paul Clements <Paul.Clements@steeleye.com>

Sure, looks good.

Thanks,
Paul

> ---
>  drivers/block/nbd.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index fdee7567fd15..f533f3375e24 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -754,9 +754,20 @@ static int __init nbd_init(void)
>                return -ENOMEM;
>
>        part_shift = 0;
> -       if (max_part > 0)
> +       if (max_part > 0) {
>                part_shift = fls(max_part);
>
> +               /*
> +                * Adjust max_part according to part_shift as it is exported
> +                * to user space so that user can know the max number of
> +                * partition kernel should be able to manage.
> +                *
> +                * Note that -1 is required because partition 0 is reserved
> +                * for the whole disk.
> +                */
> +               max_part = (1UL << part_shift) - 1;
> +       }
> +
>        if ((1UL << part_shift) > DISK_MAX_PARTS)
>                return -EINVAL;
>
> --
> 1.7.5.2
>
>
