Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab0DLOEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 10:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0DLOEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 10:04:11 -0400
Date: Mon, 12 Apr 2010 10:04:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH 3/3] blkio: Add more debug-only per-cgroup stats
Message-ID: <20100412140403.GB1294@redhat.com>
References: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com> <20100409041515.23105.11858.stgit@austin.mtv.corp.google.com> <20100409192102.GB3722@redhat.com> <p2xaf41c7c41004091709s452528bft796a2946712de92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <p2xaf41c7c41004091709s452528bft796a2946712de92@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 05:09:07PM -0700, Divyesh Shah wrote:
> On Fri, Apr 9, 2010 at 12:21 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Apr 08, 2010 at 09:15:35PM -0700, Divyesh Shah wrote:
> >> 1) group_wait_time - This is the amount of time the cgroup had to wait to get a
> >>   timeslice for one of its queues from when it became busy, i.e., went from 0
> >>   to 1 request queued. This is different from the io_wait_time which is the
> >>   cumulative total of the amount of time spent by each IO in that cgroup waiting
> >>   in the scheduler queue. This stat is a great way to find out any jobs in the
> >>   fleet that are being starved or waiting for longer than what is expected (due
> >>   to an IO controller bug or any other issue).
> >> 2) empty_time - This is the amount of time a cgroup spends w/o any pending
> >>    requests. This stat is useful when a job does not seem to be able to use its
> >>    assigned disk share by helping check if that is happening due to an IO
> >>    controller bug or because the job is not submitting enough IOs.
> >
> > Divyesh,
> >
> > This empty_time looks like a redundant stats. One can just look at
> > group_wait_time. If group_wait_time is  not increasing, then application
> > in cgroup is not doing any IO. If it is increasing then one can look
> > at so many other stas like blkio.time, blkio.sectors etc to find out
> > if cgroup is making any progress or not.
> 
> Vivek,
>         group_wait_time could not be increasing even when the cgroup
> is dominating the disk by sending tons of IO all the time and you
> can't conclude that the cgroup is not doing any IO.

If group is dominating the disk, then blkio.time and blkio.sectors and
other stats are increasing continuously and we know group is being served
which in turn implies that application is sending tons of IO.

> Even when it is
> increasing, any of the other stats don't give what we are looking for
> with this stat.. which is how busy is the application really able to
> keep its IO queues over a given period of time.

will blkio.avg_queue_size not tell you how an application is keeping
a group busy over a period of time?

When group_wait time is increasing (that means applicatio is doing IO but
group has not yet been scheduled in), then will blkio.io_queued will
give will give you a good idea how busy a group is?

If due to IO controller bug, group is not being scheduled, then
avg_queue_size will not have enough samples, but blkio.io_queued will
still be increasing or will be a big number and will tell you that
group is busy but is not making any progress.

But I do realize that rest of the stats don't exactly tell how long 
group was empty. So lets keep it as you seem to be finding it useful. Also
avg_queue_size doe not account for time you are not doing any IO.

[..]
> >>  void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg)
> >>  {
> >>       unsigned long flags;
> >> @@ -116,9 +186,14 @@ void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg)
> >>                       stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] +
> >>                       stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE];
> >>       stats->avg_queue_size_samples++;
> >> +     blkio_update_group_wait_time(stats);
> >
> > Will cfq_choose_cfqg() be a better place to call this function. Why should
> > we call it when an active queue is set. Instead when a group is chosen
> > to dispatch request from, we can update the wait time.
> 
> Does that cover pre-emption cases too?
> 

That's a good point. In preemption path we don't use cfq_choose_cfqg(). So
it is fine.

[..]
> >>  struct blkio_cgroup {
> >>       struct cgroup_subsys_state css;
> >>       unsigned int weight;
> >> @@ -74,6 +84,21 @@ struct blkio_group_stats {
> >>       uint64_t avg_queue_size_samples;
> >>       /* How many times this group has been removed from service tree */
> >>       unsigned long dequeue;
> >> +
> >> +     /* Total time spent waiting for it to be assigned a timeslice. */
> >> +     uint64_t group_wait_time;
> >> +     uint64_t start_group_wait_time;
> >> +
> >> +     /* Time spent idling for this blkio_group */
> >> +     uint64_t idle_time;
> >> +     uint64_t start_idle_time;
> >> +     /*
> >> +      * Total time when we have requests queued and do not contain the
> >> +      * current active queue.
> >> +      */
> >> +     uint64_t empty_time;
> >> +     uint64_t start_empty_time;
> >> +     uint16_t flags;
> >
> > Does this flags has to be inside blkio_group_stats? May be a better
> > place is inside blkio_group as it represents the blkio_group status.
> > That's a differnet thing that as of today all three flags are helping out
> > only for stats purposes but in future we could add more flags?
> 
> I agree with you in principle. Would it make sense to move this to
> blkg when we have a use-case for it beyond stats?
> 

Ok, that's fine with me.

[..]
> >>  static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
> >> -                             struct cfq_queue *cfqq)
> >> +                             struct cfq_queue *cfqq, bool forced)
> >>  {
> >>       struct cfq_rb_root *st = &cfqd->grp_service_tree;
> >>       unsigned int used_sl, charge_sl;
> >> @@ -916,6 +916,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
> >>       cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
> >>                                       st->min_vdisktime);
> >>       blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
> >> +     blkiocg_set_start_empty_time(&cfqg->blkg, forced);
> >
> > Why this needs to be called from CFQ? Can't we just internally call this
> > from blkiocg_update_request_remove_stats() internally. So when we remove
> > a request, we update the stats in blkio. That time blkio can checek if
> > group became empty and start the time?
> 
> >From Documentation/cgroups/blkio-controller.txt:
> This is the amount of time a cgroup spends without any pending
> requests when not being served, i.e., it does not include any time
> spent idling for one of the queues of the cgroup.
> 
> Calling this from remove_stats will add the idle time in here too.

Ok, so to get a real sense of how long a group was empty, I need to add up
empty_time and idle_time.

Thanks
Vivek
