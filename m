Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783Ab1JEOlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:41:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36708 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934392Ab1JEOlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:41:39 -0400
MIME-Version: 1.0
In-Reply-To: <1317808364-21081-1-git-send-email-rabin@rab.in>
References: <1317808364-21081-1-git-send-email-rabin@rab.in>
Date: Wed, 5 Oct 2011 09:41:36 -0500
Message-ID: <CABqD9hYw3qcMpcjyEtvstYD-WRB=QkVPS5S0MBbah=veZv9E6A@mail.gmail.com>
Subject: Re: [PATCH] block: fix UUID string buffer length
From: Will Drewry <wad@chromium.org>
To: Rabin Vincent <rabin@rab.in>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 4:52 AM, Rabin Vincent <rabin@rab.in> wrote:
> The UUID string buffer is several bytes shorter than what is actually
> required, because the space for the hyphens hasn't been taken into
> account.  Fix it, while also making it a regular char[] rather than a
> u8[] to make it clear what we're storing here.
>
> Cc: Will Drewry <wad@chromium.org>
> Signed-off-by: Rabin Vincent <rabin@rab.in>

You're absolutely right. It should match the sizeof used by sprintf's
calculation of the uuid string.
( http://lxr.linux.no/linux+v3.0.4/lib/vsprintf.c#L759 ).  The type
change is also entirely appropriate (even given the prototype of
part_unpack_uuid).

Thanks!

Reviewed-by: Will Drewry <wad@chromium.org>

> ---
>  block/genhd.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 8dfa21e..fa955b5 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -736,7 +736,7 @@ void __init printk_all_partitions(void)
>                struct hd_struct *part;
>                char name_buf[BDEVNAME_SIZE];
>                char devt_buf[BDEVT_SIZE];
> -               u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
> +               char uuid[sizeof("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")];
>
>                /*
>                 * Don't show empty devices or things that have been
> @@ -755,7 +755,7 @@ void __init printk_all_partitions(void)
>                while ((part = disk_part_iter_next(&piter))) {
>                        bool is_part0 = part == &disk->part0;
>
> -                       uuid[0] = 0;
> +                       uuid[0] = '\0';
>                        if (part->info)
>                                part_unpack_uuid(part->info->uuid, uuid);
>
> --
> 1.7.5.4
>
>
