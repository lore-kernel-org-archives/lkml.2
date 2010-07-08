Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0GHNNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:13:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab0GHNNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:13:21 -0400
Date: Thu, 8 Jul 2010 09:13:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
       Divyesh Shah <dpshah@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC/RFT PATCH] cfq-iosched: Implement cfq group idling
Message-ID: <20100708131305.GB5093@redhat.com>
References: <20100707230521.GB7842@redhat.com>
 <AANLkTik9ubpcxaMe9DEjwLJBr2nyRxJDAx4fK1NidbHq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik9ubpcxaMe9DEjwLJBr2nyRxJDAx4fK1NidbHq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 10:53:48PM -0700, Nauman Rafique wrote:
> If group idling is enabled, wouldn't it lower the throughput on
> traditional drives that handle one IO at a time?

I did not understand why group idling is bad for SATA disk.

In fact group idling will take place only if queue idling is not taking
place. Most of the time it will kick in only if slice_idle = 0. If
there are cases where we it kicks in, lets get rid of these.

I am wondering about the case of sync-noidle queue where queue idle will
not kick in if other sync-noidle queues are on the tree. I need to
make sure group idle also does not come into the picture. I guess I 
need to check for only one queue in the group condition to make sure
group timer is not armed. I will look into it...

But the point remains that if slice_idle is not zero, most of the time
only slice_idle will not kick in. If group_idle kicks in once in a while
we can look into it to see if it is right thing to from fairness
perspective or just get rid of additional group idle based on certain
conditions.

Thanks
Vivek

> Also, it would be useful to have the option of controlling idling on
> queue and idling on group independently. Idling on group would also be
> useful for achieving isolation in cases where a group uses more than
> one thread to send down IOs. In that case, if we idle on group, it
> might send an IO down from another thread within the idling period.
> 
> On Wed, Jul 7, 2010 at 4:05 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Currently we idle on sequential queues and allow dispatch from a single
> > queue and that can become a bottleneck on higher end storage. For example
> > on my HP EVA, I can run multiple sequential streams and achieve top BW
> > of around 350 MB/s. But with CFQ, dispatching from single queue does not
> > keep the array busy (limits to 150-180 MB/s with 4 or 8 processes).
> >
> > One approach to solve this issue is simply use slice_idle = 0. But this
> > also takes away the any service differentiation between groups.
> >
> > This patch implements a new tunable "group_idle". This is similar to
> > slice_idle but it forces idling at cfq group level and not at cfq queue
> > level. So the idea is that one can run with slice_idle = 0 and group_idle
> > = 8, so that we don't idle on individual queues in the group but idle
> > on the group and still keep the IO controller working.
> >
> > Not idling on individual queues in the group will dispatch requests from
> > multiple queues in the group at the same time and achieve higher throughput
> > on higher end storage.
> >
> > I have done some testing with multiple sequential readers using fio in two
> > groups of weights 100 and 200. I run 1, 2, 4, 8 sequential readers in two
> > groups.  Group names are test1 and test2 and throughputs are in KB/s.
> >
> > Default CFQ
> > ===========
> > Kernel=2.6.35-rc4-ioc+
> > DIR=/mnt/iostestmnt/fio        DEV=/dev/sdf1
> > Workload=bsr      iosched=cfq     Filesz=512M bs=4K
> > group_isolation=1 slice_idle=8    group_idle=8    quantum=8
> > =============================================================
> > job     Set NR  test1  test2
> > ---     --- --  --------------
> > bsr     1   1   61629  135182
> > bsr     1   2   62073  121222
> > bsr     1   4   51386  105694
> > bsr     1   8   50883  82450
> >
> > Note how total BW is really low (around 150 - 180 MB/s) while array can
> > support up to 350MB/s
> >
> > CFQ (slice_idle = 0)
> > ====================
> > Kernel=2.6.35-rc4-ioc+
> > DIR=/mnt/iostestmnt/fio        DEV=/dev/sdf1
> > Workload=bsr      iosched=cfq     Filesz=512M bs=4K
> > group_isolation=1 slice_idle=0    group_idle=8    quantum=8
> > =========================================================================
> > job     Set NR  test1  test2
> > ---     --- --  --------------
> > bsr     1   1   62952  139499
> > bsr     1   2   95775  186426
> > bsr     1   4   115410 235632
> > bsr     1   8   125036 227859
> >
> > With slice_idle=0, we can almost touch 350MB/s and still get the service
> > differentiation.
> >
> > CFQ (slice_idle = 0, group_idle = 0)
> > ===================================
> > Kernel=2.6.35-rc4-ioc+
> > DIR=/mnt/iostestmnt/fio        DEV=/dev/sdf1
> > Workload=bsr      iosched=cfq     Filesz=512M bs=4K
> > group_isolation=1 slice_idle=0    group_idle=0    quantum=8
> > =========================================================================
> > job     Set NR  test1  test2
> > ---     --- --  --------------
> > bsr     1   1   155274 153544
> > bsr     1   2   173448 174263
> > bsr     1   4   177629 178458
> > bsr     1   8   179846 179226
> >
> > With both slice_idle = 0 and group_idle = 0, it is alsmost like deadline.
> > We lose service differentation but achieve high throughput.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >
> > ---
> >  block/cfq-iosched.c |   46 ++++++++++++++++++++++++++++++++++++++++------
> >  1 files changed, 40 insertions(+), 6 deletions(-)
> >
> > Index: linux-2.6/block/cfq-iosched.c
> > ===================================================================
> > --- linux-2.6.orig/block/cfq-iosched.c
> > +++ linux-2.6/block/cfq-iosched.c
> > @@ -30,6 +30,7 @@ static const int cfq_slice_sync = HZ / 1
> >  static int cfq_slice_async = HZ / 25;
> >  static const int cfq_slice_async_rq = 2;
> >  static int cfq_slice_idle = HZ / 125;
> > +static int cfq_group_idle = HZ / 125;
> >  static const int cfq_target_latency = HZ * 3/10; /* 300 ms */
> >  static const int cfq_hist_divisor = 4;
> >
> > @@ -198,6 +199,8 @@ struct cfq_group {
> >        struct hlist_node cfqd_node;
> >        atomic_t ref;
> >  #endif
> > +       /* number of requests that are on the dispatch list or inside driver */
> > +       int dispatched;
> >  };
> >
> >  /*
> > @@ -271,6 +274,7 @@ struct cfq_data {
> >        unsigned int cfq_slice[2];
> >        unsigned int cfq_slice_async_rq;
> >        unsigned int cfq_slice_idle;
> > +       unsigned int cfq_group_idle;
> >        unsigned int cfq_latency;
> >        unsigned int cfq_group_isolation;
> >
> > @@ -1838,6 +1842,9 @@ static bool cfq_should_idle(struct cfq_d
> >        BUG_ON(!service_tree);
> >        BUG_ON(!service_tree->count);
> >
> > +       if (!cfqd->cfq_slice_idle)
> > +               return false;
> > +
> >        /* We never do for idle class queues. */
> >        if (prio == IDLE_WORKLOAD)
> >                return false;
> > @@ -1862,7 +1869,7 @@ static void cfq_arm_slice_timer(struct c
> >  {
> >        struct cfq_queue *cfqq = cfqd->active_queue;
> >        struct cfq_io_context *cic;
> > -       unsigned long sl;
> > +       unsigned long sl, group_idle = 0;
> >
> >        /*
> >         * SSD device without seek penalty, disable idling. But only do so
> > @@ -1878,15 +1885,19 @@ static void cfq_arm_slice_timer(struct c
> >        /*
> >         * idle is disabled, either manually or by past process history
> >         */
> > -       if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
> > -               return;
> > +       if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq)) {
> > +               /* no queue idling. Check for group idling */
> > +               if (cfqd->cfq_group_idle)
> > +                       group_idle = cfqd->cfq_group_idle;
> > +               else
> > +                       return;
> > +       }
> >
> >        /*
> >         * still active requests from this queue, don't idle
> >         */
> >        if (cfqq->dispatched)
> >                return;
> > -
> >        /*
> >         * task has exited, don't wait
> >         */
> > @@ -1899,7 +1910,7 @@ static void cfq_arm_slice_timer(struct c
> >         * slice, then don't idle. This avoids overrunning the allotted
> >         * time slice.
> >         */
> > -       if (sample_valid(cic->ttime_samples) &&
> > +       if (!group_idle && sample_valid(cic->ttime_samples) &&
> >            (cfqq->slice_end - jiffies < cic->ttime_mean)) {
> >                cfq_log_cfqq(cfqd, cfqq, "Not idling. think_time:%d",
> >                                cic->ttime_mean);
> > @@ -1908,11 +1919,15 @@ static void cfq_arm_slice_timer(struct c
> >
> >        cfq_mark_cfqq_wait_request(cfqq);
> >
> > -       sl = cfqd->cfq_slice_idle;
> > +       if (group_idle)
> > +               sl = cfqd->cfq_group_idle;
> > +       else
> > +               sl = cfqd->cfq_slice_idle;
> >
> >        mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
> >        cfq_blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
> > -       cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
> > +       cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu group_idle: %d", sl,
> > +                       group_idle ? 1 : 0);
> >  }
> >
> >  /*
> > @@ -1928,6 +1943,7 @@ static void cfq_dispatch_insert(struct r
> >        cfqq->next_rq = cfq_find_next_rq(cfqd, cfqq, rq);
> >        cfq_remove_request(rq);
> >        cfqq->dispatched++;
> > +       (RQ_CFQG(rq))->dispatched++;
> >        elv_dispatch_sort(q, rq);
> >
> >        cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
> > @@ -2231,6 +2247,16 @@ static struct cfq_queue *cfq_select_queu
> >                goto keep_queue;
> >        }
> >
> > +       /*
> > +        * If group idle is enabled and there are requests dispatched from
> > +        * this group, wait for requests to complete.
> > +        */
> > +       if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1
> > +           && cfqq->cfqg->dispatched) {
> > +               cfqq = NULL;
> > +               goto keep_queue;
> > +       }
> > +
> >  expire:
> >        cfq_slice_expired(cfqd, 0);
> >  new_queue:
> > @@ -3373,6 +3399,7 @@ static void cfq_completed_request(struct
> >        WARN_ON(!cfqq->dispatched);
> >        cfqd->rq_in_driver--;
> >        cfqq->dispatched--;
> > +       (RQ_CFQG(rq))->dispatched--;
> >        cfq_blkiocg_update_completion_stats(&cfqq->cfqg->blkg,
> >                        rq_start_time_ns(rq), rq_io_start_time_ns(rq),
> >                        rq_data_dir(rq), rq_is_sync(rq));
> > @@ -3847,6 +3874,7 @@ static void *cfq_init_queue(struct reque
> >        cfqd->cfq_slice[1] = cfq_slice_sync;
> >        cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
> >        cfqd->cfq_slice_idle = cfq_slice_idle;
> > +       cfqd->cfq_group_idle = cfq_group_idle;
> >        cfqd->cfq_latency = 1;
> >        cfqd->cfq_group_isolation = 0;
> >        cfqd->hw_tag = -1;
> > @@ -3919,6 +3947,7 @@ SHOW_FUNCTION(cfq_fifo_expire_async_show
> >  SHOW_FUNCTION(cfq_back_seek_max_show, cfqd->cfq_back_max, 0);
> >  SHOW_FUNCTION(cfq_back_seek_penalty_show, cfqd->cfq_back_penalty, 0);
> >  SHOW_FUNCTION(cfq_slice_idle_show, cfqd->cfq_slice_idle, 1);
> > +SHOW_FUNCTION(cfq_group_idle_show, cfqd->cfq_group_idle, 1);
> >  SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
> >  SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
> >  SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
> > @@ -3951,6 +3980,7 @@ STORE_FUNCTION(cfq_back_seek_max_store,
> >  STORE_FUNCTION(cfq_back_seek_penalty_store, &cfqd->cfq_back_penalty, 1,
> >                UINT_MAX, 0);
> >  STORE_FUNCTION(cfq_slice_idle_store, &cfqd->cfq_slice_idle, 0, UINT_MAX, 1);
> > +STORE_FUNCTION(cfq_group_idle_store, &cfqd->cfq_group_idle, 0, UINT_MAX, 1);
> >  STORE_FUNCTION(cfq_slice_sync_store, &cfqd->cfq_slice[1], 1, UINT_MAX, 1);
> >  STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
> >  STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
> > @@ -3972,6 +4002,7 @@ static struct elv_fs_entry cfq_attrs[] =
> >        CFQ_ATTR(slice_async),
> >        CFQ_ATTR(slice_async_rq),
> >        CFQ_ATTR(slice_idle),
> > +       CFQ_ATTR(group_idle),
> >        CFQ_ATTR(low_latency),
> >        CFQ_ATTR(group_isolation),
> >        __ATTR_NULL
> > @@ -4025,6 +4056,12 @@ static int __init cfq_init(void)
> >        if (!cfq_slice_idle)
> >                cfq_slice_idle = 1;
> >
> > +#ifdef CONFIG_CFQ_GROUP_IOSCHED
> > +       if (!cfq_group_idle)
> > +               cfq_group_idle = 1;
> > +#else
> > +               cfq_group_idle = 0;
> > +#endif
> >        if (cfq_slab_setup())
> >                return -ENOMEM;
> >
> >
