Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2L2Hrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 02:47:40 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:51557 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2L2Hri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 02:47:38 -0500
MIME-Version: 1.0
In-Reply-To: <1356573611-18590-5-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-5-git-send-email-koverstreet@google.com>
Date: Sat, 29 Dec 2012 15:47:37 +0800
Message-ID: <CAJd=RBCHJSkA0UChN+41HknLgi=NOM32jq3L9+Rse_a66FrP4g@mail.gmail.com>
Subject: Re: [PATCH 04/32] aio: remove retry-based AIO
From: Hillf Danton <dhillf@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Zach Brown <zab@redhat.com>,
        bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 9:59 AM, Kent Overstreet <koverstreet@google.com> wrote:
> @@ -1585,18 +1278,27 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>          * don't see ctx->dead set here, io_destroy() waits for our IO to
>          * finish.
>          */
> -       if (ctx->dead) {
> -               spin_unlock_irq(&ctx->ctx_lock);
> +       if (ctx->dead)
>                 ret = -EINVAL;
> +       spin_unlock_irq(&ctx->ctx_lock);
> +       if (ret)
>                 goto out_put_req;
> +
> +       if (unlikely(kiocbIsCancelled(req))) {
> +               ret = -EINTR;
> +       } else {
> +               ret = req->ki_retry(req);
>         }
> -       aio_run_iocb(req);
> -       if (!list_empty(&ctx->run_list)) {
> -               /* drain the run list */
> -               while (__aio_run_iocbs(ctx))
> -                       ;
> +       if (ret != -EIOCBQUEUED) {
> +               /*
> +                * There's no easy way to restart the syscall since other AIO's
> +                * may be already running. Just fail this IO with EINTR.
> +                */
> +               if (unlikely(ret == -ERESTARTSYS || ret == -ERESTARTNOINTR ||
> +                            ret == -ERESTARTNOHAND || ret == -ERESTART_RESTARTBLOCK))
> +                       ret = -EINTR;
> +               aio_complete(req, ret, 0);
>         }
> -       spin_unlock_irq(&ctx->ctx_lock);
>
>         aio_put_req(req);       /* drop extra ref to req */
>         return 0;

          return ret;          yes?
