Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab1DMLJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 07:09:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:34495 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab1DMLJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:09:33 -0400
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
In-Reply-To: <BANLkTikBEJa7bJJoLFU7NoiEgOjVHVG08A@mail.gmail.com>
References: <20110411223623.4278fad1@notabene.brown>
	 <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org>
	 <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard>
	 <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard>
	 <4DA44C86.3090305@fusionio.com> <20110412133117.GE31057@dastard>
	 <4DA45790.2010109@fusionio.com> <20110412143452.GH31057@dastard>
	 <20110413070827.11b2a71d@notabene.brown>
	 <BANLkTikBEJa7bJJoLFU7NoiEgOjVHVG08A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 13:12:02 +0200
Message-ID: <1302693122.2035.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 19:23 -0700, Linus Torvalds wrote:
>  kernel/sched.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 48013633d792..a187c3fe027b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4111,20 +4111,20 @@ need_resched:
>                                         try_to_wake_up_local(to_wakeup);
>                         }
>                         deactivate_task(rq, prev, DEQUEUE_SLEEP);
> +
> +                       /*
> +                        * If we are going to sleep and we have plugged IO queued, make
> +                        * sure to submit it to avoid deadlocks.
> +                        */
> +                       if (blk_needs_flush_plug(prev)) {
> +                               raw_spin_unlock(&rq->lock);
> +                               blk_flush_plug(prev);
> +                               raw_spin_lock(&rq->lock);
> +                       }
>                 }
>                 switch_count = &prev->nvcsw;
>         }
>  
> -       /*
> -        * If we are going to sleep and we have plugged IO queued, make
> -        * sure to submit it to avoid deadlocks.
> -        */
> -       if (prev->state != TASK_RUNNING && blk_needs_flush_plug(prev)) {
> -               raw_spin_unlock(&rq->lock);
> -               blk_flush_plug(prev);
> -               raw_spin_lock(&rq->lock);
> -       }
> -
>         pre_schedule(rq, prev);
>  
>         if (unlikely(!rq->nr_running)) 

Right, that cures the preemption problem. The reason I suggested placing
it where it was is that I'd like to keep all things that release
rq->lock in the middle of schedule() in one place, but I guess we can
cure that with some extra comments.



