Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1FTQpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:45:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab1FTQpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:45:09 -0400
Date: Mon, 20 Jun 2011 12:45:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] cfq: Fix starvation of async writes in presence of heavy
 sync workload
Message-ID: <20110620164504.GC4749@redhat.com>
References: <20110620141631.GA4749@redhat.com>
 <BANLkTin9xgN0t4rn_Zf81TBdnLmJXPzNDT1fXtg3m64SnJVn5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin9xgN0t4rn_Zf81TBdnLmJXPzNDT1fXtg3m64SnJVn5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 09:14:18AM -0700, Justin TerAvest wrote:
> On Mon, Jun 20, 2011 at 7:16 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > In presence of heavy sync workload CFQ can starve asnc writes.
> > If one launches multiple readers (say 16), then one can notice
> > that CFQ can withhold dispatch of WRITEs for a very long time say
> > 200 or 300 seconds.
> >
> > Basically CFQ schedules an async queue but does not dispatch any
> > writes because it is waiting for exisintng sync requests in queue to
> > finish. While it is waiting, one or other reader gets queued up and
> > preempts the async queue. So we did schedule the async queue but never
> > dispatched anything from it. This can repeat for long time hence
> > practically starving Writers.
> >
> > This patch allows async queue to dispatch atleast 1 requeust once
> > it gets scheduled and denies preemption if async queue has been
> > waiting for sync requests to drain and has not been able to dispatch
> > a request yet.
> >
> > One concern with this fix is that how does it impact readers
> > in presence of heavy writting going on.
> >
> > I did a test where I launch firefox, load a website and close
> > firefox and measure the time. I ran the test 3 times and took
> > average.
> >
> > - Vanilla kernel time ~= 1 minute 40 seconds
> > - Patched kenrel time ~= 1 minute 35 seconds
> >
> > Basically it looks like that for this test times have not
> > changed much for this test. But I would not claim that it does
> > not impact reader's latencies at all. It might show up in
> > other workloads.
> >
> > I think we anyway need to fix writer starvation. If this patch
> > causes issues, then we need to look at reducing writer's
> > queue depth further to improve latencies for readers.
> 
> Maybe we should be more specific about what it means to "fix writer starvation"
> 

Tao ma recently ran into issues with writer starvation. Here is
the lkml thread.

https://lkml.org/lkml/2011/6/9/167

I also ran some fio based scripts launching multiple readers
and multiple buffered writers and noticed that there are large
windows where we don't dispatch even a single request from
async queues. That's what starvation is. Time period for
not dispatching request was in the range of 200 seconds.

> This makes the preemption logic slightly harder to understand, and I'm
> concerned we'll keep making little adjustments like this to the
> scheduler.

If you have other ideas for handling this, we can definitely give
it a try.

Thanks
Vivek

> 
> >
> > Reported-and-Tested-by: Tao Ma <tm@tao.ma>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/cfq-iosched.c |    9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > Index: linux-2.6/block/cfq-iosched.c
> > ===================================================================
> > --- linux-2.6.orig/block/cfq-iosched.c  2011-06-10 10:05:34.660781278 -0400
> > +++ linux-2.6/block/cfq-iosched.c       2011-06-20 08:29:13.328186380 -0400
> > @@ -3315,8 +3315,15 @@ cfq_should_preempt(struct cfq_data *cfqd
> >         * if the new request is sync, but the currently running queue is
> >         * not, let the sync request have priority.
> >         */
> > -       if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
> > +       if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq)) {
> > +               /*
> > +                * Allow atleast one dispatch otherwise this can repeat
> > +                * and writes can be starved completely
> > +                */
> > +               if (!cfqq->slice_dispatch)
> > +                       return false;
> >                return true;
> > +       }
> >
> >        if (new_cfqq->cfqg != cfqq->cfqg)
> >                return false;
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
