Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1IPGEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:04:52 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:60066 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab1IPGEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:04:51 -0400
MIME-Version: 1.0
In-Reply-To: <1316142577.29510.130.camel@sli10-conroe>
References: <1316142577.29510.130.camel@sli10-conroe>
Date: Fri, 16 Sep 2011 08:04:49 +0200
Message-ID: <CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 5:09 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> Recently Maxim and I discussed why his aiostress workload performs poorly. If
> you didn't follow the discussion, here are the issues we found:
> 1. cfq seeky dection isn't good. Assume a task accesses sector A, B, C, D, A+1,
> B+1, C+1, D+1, A+2...Accessing A, B, C, D is random. cfq will detect the queue
> as seeky, but since when accessing A+1, A+1 is already in disk cache, this
> should be detected as sequential really. Not sure if any real workload has such
> access patern, and seems not easy to have a clean fix too. Any idea for this?

Not all disks will cache 4 independent streams, we can't make that
assumption in cfq.
The current behaviour of assuming it as seeky should work well enough,
in fact it will be put in the seeky tree, and it can enjoy the seeky
tree quantum of time. If the second round takes a short time, it will
be able to schedule a third round again after the idle time.
If there are other seeky processes competing for the tree, the cache
can be cleared by the time it gets back to your 4 streams process, so
it will behave exactly as a seeky process from cfq point of view.
If the various accesses were submitted in parallel, the deep seeky
queue logic should kick in and make sure the process gets a sequential
quantum, rather than sharing it with other seeky processes, so
depending on your disk, it could perform better.

>
> 2. deep seeky queue idle. This makes raid performs poorly. I would think we
> revert the logic. Deep queue is more popular with high end hardware. In such
> hardware, we'd better not do idle.
> Note, currently we set a queue's slice after the first request is finished.
> This means the drive already idles a little time. If the queue is truely deep,
> new requests should already come in, so idle isn't required.
> Looks Vivek used to post a patch to rever it, but it gets ignored.
> http://us.generation-nt.com/patch-cfq-iosched-revert-logic-deep-queues-help-198339681.html
I get a 404 here. I think you are seeing only one half of the medal.
That logic is there mainly to ensure fairness between deep seeky
processes and normal seeky processes that want low latency.
If you remove that logic, a single process making many parallel aio
reads could completely swamp one machine, preventing other seeky
processes from progressing.
Instead of removing completely the logic, you should make the depth
configurable, so multi-spindle storages could allow deeper queues
before switching to fairness-enforcing policy.


> Signed-off-by: Shaohua Li<shaohua.li@intel.com>
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index a33bd43..f75439e 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -334,7 +334,6 @@ enum cfqq_state_flags {
>        CFQ_CFQQ_FLAG_sync,             /* synchronous queue */
>        CFQ_CFQQ_FLAG_coop,             /* cfqq is shared */
>        CFQ_CFQQ_FLAG_split_coop,       /* shared cfqq will be splitted */
> -       CFQ_CFQQ_FLAG_deep,             /* sync cfqq experienced large depth */
>        CFQ_CFQQ_FLAG_wait_busy,        /* Waiting for next request */
>  };
>
> @@ -363,7 +362,6 @@ CFQ_CFQQ_FNS(slice_new);
>  CFQ_CFQQ_FNS(sync);
>  CFQ_CFQQ_FNS(coop);
>  CFQ_CFQQ_FNS(split_coop);
> -CFQ_CFQQ_FNS(deep);
>  CFQ_CFQQ_FNS(wait_busy);
>  #undef CFQ_CFQQ_FNS
>
> @@ -2375,17 +2373,6 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
>                goto keep_queue;
>        }
>
> -       /*
> -        * This is a deep seek queue, but the device is much faster than
> -        * the queue can deliver, don't idle
> -        **/
> -       if (CFQQ_SEEKY(cfqq) && cfq_cfqq_idle_window(cfqq) &&
> -           (cfq_cfqq_slice_new(cfqq) ||
> -           (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start))) {
> -               cfq_clear_cfqq_deep(cfqq);
> -               cfq_clear_cfqq_idle_window(cfqq);
> -       }
> -
I haven't seen the patch that introduced this code hunk, but this
could disrupt the cache in your first scenario if the reads A B C D
were sent in parallel. You mistakenly assume your disk can issue more
requests in parallel only because many of them hit the cache. Now you
start sending other unrelated requests (your 4 stream process is not
identified as deep any more, so other processes in the seeky tree
compete with it), and this makes your cache hit ratio drop and
everything slows down.
>        if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
>                cfqq = NULL;
>                goto keep_queue;
> @@ -3298,13 +3285,10 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>
>        enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
>
> -       if (cfqq->queued[0] + cfqq->queued[1] >= 4)
> -               cfq_mark_cfqq_deep(cfqq);
> -
>        if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
>                enable_idle = 0;
>        else if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
> -           (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
> +           CFQQ_SEEKY(cfqq))
>                enable_idle = 0;
>        else if (sample_valid(cic->ttime.ttime_samples)) {
>                if (cic->ttime.ttime_mean > cfqd->cfq_slice_idle)
> @@ -3874,11 +3858,6 @@ static void cfq_idle_slice_timer(unsigned long data)
>                 */
>                if (!RB_EMPTY_ROOT(&cfqq->sort_list))
>                        goto out_kick;
> -
> -               /*
> -                * Queue depth flag is reset only when the idle didn't succeed
> -                */
> -               cfq_clear_cfqq_deep(cfqq);
>        }
>  expire:
>        cfq_slice_expired(cfqd, timed_out);
>
>
>
Thanks,
Corrado
