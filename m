Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab2KNDId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:08:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34572 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab2KNDIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:08:32 -0500
MIME-Version: 1.0
In-Reply-To: <1348111122-27400-2-git-send-email-robin.k.dong@gmail.com>
References: <1348111122-27400-1-git-send-email-robin.k.dong@gmail.com>
	<1348111122-27400-2-git-send-email-robin.k.dong@gmail.com>
Date: Wed, 14 Nov 2012 11:08:31 +0800
Message-ID: <CANsebLGsjC7FWUEVi6aW86Bx1gNtJVpHeewRxiO3X-YtkVNk4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] md: modify dm_io() so it could return bios instead of
 submitting it
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

2012/9/20 Robin Dong <robin.k.dong@gmail.com>:
> From: Robin Dong <sanbai@taobao.com>
>
> When trying to modify flashcache to request based (current it's bio based), we need
> to make request from bios by ourselves, but dm_io() will submit these bios directly,
> so we propose to modify the dm_io() to return bios instead of submiting it.
>
> This could also improve the flexibility of dm_io().
>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  drivers/md/dm.c               |   11 +++++++++++
>  include/linux/device-mapper.h |    3 +++
>  2 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 4e09b6f..bf6e3bb 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1459,11 +1459,22 @@ static int dm_request_based(struct mapped_device *md)
>  static void dm_request(struct request_queue *q, struct bio *bio)
>  {
>         struct mapped_device *md = q->queuedata;
> +       struct dm_table *map = dm_get_live_table(md);
> +       struct dm_target *ti = dm_table_find_target(map, bio->bi_sector);
> +
> +       if (ti->type->mk_rq) {
> +               ti->type->mk_rq(ti, q, bio);
> +               goto out;
> +       }
>
>         if (dm_request_based(md))
>                 blk_queue_bio(q, bio);
>         else
>                 _dm_request(q, bio);
> +
> +out:
> +       dm_table_put(map);
> +       return;
>  }
>
>  void dm_dispatch_request(struct request *rq)
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 38d27a1..2386389 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -50,6 +50,8 @@ typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
>                           union map_info *map_context);
>  typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
>                                   union map_info *map_context);
> +typedef int (*dm_make_request_fn) (struct dm_target *ti,
> +                               struct request_queue *q, struct bio *bio);
>
>  /*
>   * Returns:
> @@ -136,6 +138,7 @@ struct target_type {
>         dm_dtr_fn dtr;
>         dm_map_fn map;
>         dm_map_request_fn map_rq;
> +       dm_make_request_fn mk_rq;
>         dm_endio_fn end_io;
>         dm_request_endio_fn rq_end_io;
>         dm_presuspend_fn presuspend;
> --
> 1.7.1
>



-- 
--
Best Regard
Robin Dong
