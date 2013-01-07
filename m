Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3AGWP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:15:26 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39985 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3AGWPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:15:24 -0500
Date: Mon, 7 Jan 2013 14:15:21 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Zach Brown <zab@redhat.com>,
        bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, tytso@mit.edu
Subject: Re: [PATCH 04/32] aio: remove retry-based AIO
Message-ID: <20130107221521.GD26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-5-git-send-email-koverstreet@google.com>
 <CAJd=RBCHJSkA0UChN+41HknLgi=NOM32jq3L9+Rse_a66FrP4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBCHJSkA0UChN+41HknLgi=NOM32jq3L9+Rse_a66FrP4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 03:47:37PM +0800, Hillf Danton wrote:
> On Thu, Dec 27, 2012 at 9:59 AM, Kent Overstreet <koverstreet@google.com> wrote:
> > @@ -1585,18 +1278,27 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
> >          * don't see ctx->dead set here, io_destroy() waits for our IO to
> >          * finish.
> >          */
> > -       if (ctx->dead) {
> > -               spin_unlock_irq(&ctx->ctx_lock);
> > +       if (ctx->dead)
> >                 ret = -EINVAL;
> > +       spin_unlock_irq(&ctx->ctx_lock);
> > +       if (ret)
> >                 goto out_put_req;
> > +
> > +       if (unlikely(kiocbIsCancelled(req))) {
> > +               ret = -EINTR;
> > +       } else {
> > +               ret = req->ki_retry(req);
> >         }
> > -       aio_run_iocb(req);
> > -       if (!list_empty(&ctx->run_list)) {
> > -               /* drain the run list */
> > -               while (__aio_run_iocbs(ctx))
> > -                       ;
> > +       if (ret != -EIOCBQUEUED) {
> > +               /*
> > +                * There's no easy way to restart the syscall since other AIO's
> > +                * may be already running. Just fail this IO with EINTR.
> > +                */
> > +               if (unlikely(ret == -ERESTARTSYS || ret == -ERESTARTNOINTR ||
> > +                            ret == -ERESTARTNOHAND || ret == -ERESTART_RESTARTBLOCK))
> > +                       ret = -EINTR;
> > +               aio_complete(req, ret, 0);
> >         }
> > -       spin_unlock_irq(&ctx->ctx_lock);
> >
> >         aio_put_req(req);       /* drop extra ref to req */
> >         return 0;
> 
>           return ret;          yes?

No - and this code is _really_ confusing. If we get an error we can
return it in two different ways:

1) By making the io_submit() call fail
2) Through the io_event that aio_complete() delivers

Note the return 0 coming after the aio_complete() call - we don't want
to return ret because then we'd be delivering an error twice.
