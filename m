Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab2KNDIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:08:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34572 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab2KNDIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:08:21 -0500
MIME-Version: 1.0
In-Reply-To: <1348111122-27400-1-git-send-email-robin.k.dong@gmail.com>
References: <1348111122-27400-1-git-send-email-robin.k.dong@gmail.com>
Date: Wed, 14 Nov 2012 11:08:20 +0800
Message-ID: <CANsebLGKQcDM8rkiZdqAVqf8JLPt4UMhz4keNs9KYh=1VjdiLQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] md: add new interface 'mk_rq' in target_type
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
> We are now trying to modify flashcache(https://github.com/facebook/flashcache)
> to make it request based so that
> we can let cfq io-controller control the bandwidth between different
> io cgroups.
>
> A search in the dm directory tells me that only multipath is a request
> based dm target and its functionality
> is very simple and map_rq() is used to map the request to different underlying devices.
> We can't work in this way because:
>
> 1. the request which processed by map_rq() need to be issued to
>         different lower devices (disk device and cache device, in flashcache), therefore the request
>         can't be totally remapped by simply changing its queue and returning DM_MAPIO_REMAPPED in map_rq() like multipath_map()
> 2. to submit bios drectly in map_rq() (by return DM_MAPIO_SUBMITTED) will cause BUG_ON(!irqs_disabled())
>         in dm_request_fn() because the submit_bio()->generic_make_request()->blk_queue_bio() will definitly call spin_unlock_irq to enable the irqs
>
> As above,the interface map_rq() provided by devcie-mapper framework
> is not enough for an autonomous target, like flashcache.
>
> We propose to add a new
> mk_rq interface so that we can make the requests
> by ourselves.
>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  drivers/md/dm-io.c    |   58 ++++++++++++++++++++++++++++--------------------
>  drivers/md/dm-log.c   |    1 +
>  include/linux/dm-io.h |    3 ++
>  3 files changed, 38 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index ea5dd28..f767792 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -287,8 +287,8 @@ static void km_dp_init(struct dpages *dp, void *data)
>  /*-----------------------------------------------------------------
>   * IO routines that accept a list of pages.
>   *---------------------------------------------------------------*/
> -static void do_region(int rw, unsigned region, struct dm_io_region *where,
> -                     struct dpages *dp, struct io *io)
> +static void do_region(struct dm_io_request *io_req, unsigned region,
> +               struct dm_io_region *where, struct dpages *dp, struct io *io)
>  {
>         struct bio *bio;
>         struct page *page;
> @@ -298,6 +298,7 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
>         sector_t remaining = where->count;
>         struct request_queue *q = bdev_get_queue(where->bdev);
>         sector_t discard_sectors;
> +       int rw = io_req->bi_rw;
>
>         /*
>          * where->count may be zero if rw holds a flush and we need to
> @@ -339,15 +340,26 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
>                 }
>
>                 atomic_inc(&io->count);
> -               submit_bio(rw, bio);
> +               if (!io_req->only_create_bio)
> +                       submit_bio(rw, bio);
> +               else {
> +                       bio->bi_rw |= rw;
> +                       if (io_req->start) {
> +                               io_req->end->bi_next = bio;
> +                               io_req->end = bio;
> +                       } else
> +                               io_req->start = io_req->end = bio;
> +                       bio->bi_next = NULL;
> +               }
>         } while (remaining);
>  }
>
> -static void dispatch_io(int rw, unsigned int num_regions,
> +static void dispatch_io(struct dm_io_request *io_req, unsigned int num_regions,
>                         struct dm_io_region *where, struct dpages *dp,
>                         struct io *io, int sync)
>  {
>         int i;
> +       int rw = io_req->bi_rw;
>         struct dpages old_pages = *dp;
>
>         BUG_ON(num_regions > DM_IO_MAX_REGIONS);
> @@ -362,7 +374,7 @@ static void dispatch_io(int rw, unsigned int num_regions,
>         for (i = 0; i < num_regions; i++) {
>                 *dp = old_pages;
>                 if (where[i].count || (rw & REQ_FLUSH))
> -                       do_region(rw, i, where + i, dp, io);
> +                       do_region(io_req, i, where + i, dp, io);
>         }
>
>         /*
> @@ -372,8 +384,8 @@ static void dispatch_io(int rw, unsigned int num_regions,
>         dec_count(io, 0, 0);
>  }
>
> -static int sync_io(struct dm_io_client *client, unsigned int num_regions,
> -                  struct dm_io_region *where, int rw, struct dpages *dp,
> +static int sync_io(struct dm_io_request *io_req,  unsigned int num_regions,
> +                  struct dm_io_region *where, struct dpages *dp,
>                    unsigned long *error_bits)
>  {
>         /*
> @@ -385,7 +397,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
>         volatile char io_[sizeof(struct io) + __alignof__(struct io) - 1];
>         struct io *io = (struct io *)PTR_ALIGN(&io_, __alignof__(struct io));
>
> -       if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
> +       if (num_regions > 1 && (io_req->bi_rw & RW_MASK) != WRITE) {
>                 WARN_ON(1);
>                 return -EIO;
>         }
> @@ -393,12 +405,12 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
>         io->error_bits = 0;
>         atomic_set(&io->count, 1); /* see dispatch_io() */
>         io->sleeper = current;
> -       io->client = client;
> +       io->client = io_req->client;
>
>         io->vma_invalidate_address = dp->vma_invalidate_address;
>         io->vma_invalidate_size = dp->vma_invalidate_size;
>
> -       dispatch_io(rw, num_regions, where, dp, io, 1);
> +       dispatch_io(io_req, num_regions, where, dp, io, 1);
>
>         while (1) {
>                 set_current_state(TASK_UNINTERRUPTIBLE);
> @@ -416,30 +428,29 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
>         return io->error_bits ? -EIO : 0;
>  }
>
> -static int async_io(struct dm_io_client *client, unsigned int num_regions,
> -                   struct dm_io_region *where, int rw, struct dpages *dp,
> -                   io_notify_fn fn, void *context)
> +static int async_io(struct dm_io_request *io_req, unsigned int num_regions,
> +               struct dm_io_region *where, struct dpages *dp)
>  {
>         struct io *io;
>
> -       if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
> +       if (num_regions > 1 && (io_req->bi_rw & RW_MASK) != WRITE) {
>                 WARN_ON(1);
> -               fn(1, context);
> +               io_req->notify.fn(1, io_req->notify.context);
>                 return -EIO;
>         }
>
> -       io = mempool_alloc(client->pool, GFP_NOIO);
> +       io = mempool_alloc(io_req->client->pool, GFP_NOIO);
>         io->error_bits = 0;
>         atomic_set(&io->count, 1); /* see dispatch_io() */
>         io->sleeper = NULL;
> -       io->client = client;
> -       io->callback = fn;
> -       io->context = context;
> +       io->client = io_req->client;
> +       io->callback = io_req->notify.fn;
> +       io->context = io_req->notify.context;
>
>         io->vma_invalidate_address = dp->vma_invalidate_address;
>         io->vma_invalidate_size = dp->vma_invalidate_size;
>
> -       dispatch_io(rw, num_regions, where, dp, io, 0);
> +       dispatch_io(io_req, num_regions, where, dp, io, 0);
>         return 0;
>  }
>
> @@ -499,11 +510,10 @@ int dm_io(struct dm_io_request *io_req, unsigned num_regions,
>                 return r;
>
>         if (!io_req->notify.fn)
> -               return sync_io(io_req->client, num_regions, where,
> -                              io_req->bi_rw, &dp, sync_error_bits);
> +               return sync_io(io_req, num_regions, where,
> +                               &dp, sync_error_bits);
>
> -       return async_io(io_req->client, num_regions, where, io_req->bi_rw,
> -                       &dp, io_req->notify.fn, io_req->notify.context);
> +       return async_io(io_req, num_regions, where, &dp);
>  }
>  EXPORT_SYMBOL(dm_io);
>
> diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
> index 627d191..3bf065a 100644
> --- a/drivers/md/dm-log.c
> +++ b/drivers/md/dm-log.c
> @@ -463,6 +463,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
>                         kfree(lc);
>                         return r;
>                 }
> +               lc->io_req.only_create_bio = 0;
>
>                 lc->disk_header = vmalloc(buf_size);
>                 if (!lc->disk_header) {
> diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
> index f4b0aa3..8782163 100644
> --- a/include/linux/dm-io.h
> +++ b/include/linux/dm-io.h
> @@ -61,6 +61,9 @@ struct dm_io_request {
>         struct dm_io_memory mem;        /* Memory to use for io */
>         struct dm_io_notify notify;     /* Synchronous if notify.fn is NULL */
>         struct dm_io_client *client;    /* Client memory handler */
> +       int only_create_bio;
> +       struct bio *start;
> +       struct bio *end;
>  };
>
>  /*
> --
> 1.7.1
>



-- 
--
Best Regard
Robin Dong
