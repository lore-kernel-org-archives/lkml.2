Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1CLAUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 19:20:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489Ab1CLAUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 19:20:32 -0500
Date: Fri, 11 Mar 2011 16:19:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Roland Dreier <roland@kernel.org>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        stable@kernel.org
Subject: Re: [PATCH] aio: Wake all waiters when destroying ctx
Message-Id: <20110311161924.b902942a.akpm@linux-foundation.org>
In-Reply-To: <x49fwqthh51.fsf@segfault.boston.devel.redhat.com>
References: <1299822937-6522-1-git-send-email-roland@kernel.org>
	<x49fwqthh51.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011 09:21:46 -0500
Jeff Moyer <jmoyer@redhat.com> wrote:

> Roland Dreier <roland@kernel.org> writes:
> 
> > From: Roland Dreier <roland@purestorage.com>
> >
> > The test program below will hang because io_getevents() uses
> > add_wait_queue_exclusive(), which means the wake_up() in io_destroy()
> > only wakes up one of the threads.  Fix this by using wake_up_all() in
> > the aio code paths where we want to make sure no one gets stuck.
> 
> [snip]
> 
> > Cc: <stable@kernel.org>
> > Signed-off-by: Roland Dreier <roland@purestorage.com>
> > ---
> >  fs/aio.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/aio.c b/fs/aio.c
> > index 26869cd..88f0ed5 100644
> > --- a/fs/aio.c
> > +++ b/fs/aio.c
> > @@ -520,7 +520,7 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
> >  	ctx->reqs_active--;
> >  
> >  	if (unlikely(!ctx->reqs_active && ctx->dead))
> > -		wake_up(&ctx->wait);
> > +		wake_up_all(&ctx->wait);
> >  }
> >  
> >  static void aio_fput_routine(struct work_struct *data)
> > @@ -1229,7 +1229,7 @@ static void io_destroy(struct kioctx *ioctx)
> >  	 * by other CPUs at this point.  Right now, we rely on the
> >  	 * locking done by the above calls to ensure this consistency.
> >  	 */
> > -	wake_up(&ioctx->wait);
> > +	wake_up_all(&ioctx->wait);
> >  	put_ioctx(ioctx);	/* once for the lookup */
> >  }
> >  
> 
> Thanks, Roland, this looks good.
> 
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

It's a fairly old bug (yes?) and we're presumably close to 2.6.38.  So
I scheduled the fix for 2.6.39 marked for backporting into 2.6.38.x and
earlier.

That may have been a bit over-cautious - feel free to argue ;)
