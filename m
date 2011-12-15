Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab1LOBJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 20:09:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54405 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1LOBJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 20:09:05 -0500
MIME-Version: 1.0
In-Reply-To: <4EE7C74D.1020306@oracle.com>
References: <4EE7C74D.1020306@oracle.com>
Date: Thu, 15 Dec 2011 09:09:04 +0800
X-Google-Sender-Auth: oER8BUkLIKPwINpHmF2-MuT7zQo
Message-ID: <CANejiEU3v9EwhBaL6+nWLrsp-jetV=TVWU7v4vy1cU34qA92gw@mail.gmail.com>
Subject: Re: [PATCH] AIO: Don't plug the I/O queue in do_io_submit()
From: Shaohua Li <shli@kernel.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Andi Kleen <ak@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/14 Dave Kleikamp <dave.kleikamp@oracle.com>:
> Asynchronous I/O latency to a solid-state disk greatly increased
> between the 2.6.32 and 3.0 kernels. By removing the plug from
> do_io_submit(), we observed a 34% improvement in the I/O latency.
>
> Unfortunately, at this level, we don't know if the request is to
> a rotating disk or not.
>
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: linux-aio@kvack.org
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 78c514c..d131a2c 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1696,7 +1696,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>        struct kioctx *ctx;
>        long ret = 0;
>        int i = 0;
> -       struct blk_plug plug;
>        struct kiocb_batch batch;
>
>        if (unlikely(nr < 0))
> @@ -1716,8 +1715,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>
>        kiocb_batch_init(&batch, nr);
>
> -       blk_start_plug(&plug);
> -
>        /*
>         * AKPM: should this return a partial result if some of the IOs were
>         * successfully submitted?
> @@ -1740,7 +1737,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>                if (ret)
>                        break;
>        }
> -       blk_finish_plug(&plug);
>
>        kiocb_batch_free(&batch);
>        put_ioctx(ctx);
can you explain why this can help? Note, in 3.1 kernel we now force flush
plug list if the list is too long, which will remove a lot of latency.
