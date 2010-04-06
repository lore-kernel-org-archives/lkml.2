Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab0DFRnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093Ab0DFRmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:42:35 -0400
Date: Tue, 6 Apr 2010 13:42:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH 2/3][v3] blkio: Add io controller stats like
Message-ID: <20100406174218.GE3029@redhat.com>
References: <20100406032630.23464.24685.stgit@austin.mtv.corp.google.com> <20100406033629.23464.90216.stgit@austin.mtv.corp.google.com> <20100406151621.GB3029@redhat.com> <s2haf41c7c41004060959j8d49feccx385545e66288c185@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s2haf41c7c41004060959j8d49feccx385545e66288c185@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 09:59:32AM -0700, Divyesh Shah wrote:
> Vivek,
>        I'll send out a v3.1 only for this patch since you've Acked the
> other 2 patches. Thanks a lot for the detailed reviews again!
> 

That's fine. You can just reply to same mail and attach the new patch.
Just that we need to explicitly mention to Jens to pick this new patch
with minor modifications.

Jens, how should we handle this patchset now? Original patches have
already been applied to you for-2.6.35 branch. Should Divyesh, now
send cleanup patches on top of these or something else?

Thanks
Vivek

> On Tue, Apr 6, 2010 at 8:16 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Apr 05, 2010 at 08:37:01PM -0700, Divyesh Shah wrote:
> >> - io_service_time (the time between request dispatch and completion for IOs
> >>   in the cgroup)
> >> - io_wait_time (the time spent waiting in the IO shceduler queues before
> >>   getting serviced)
> >> - io_serviced (number of IOs serviced from this blkio_group)
> >> - io_service_bytes (Number of bytes served for this cgroup)
> >>
> >> These stats are accumulated per operation type helping us to distinguish between
> >> read and write, and sync and async IO. This patch does not increment any of
> >> these stats.
> >>
> >> Signed-off-by: Divyesh Shah<dpshah@google.com>
> >> ---
> >>
> >>  Documentation/cgroups/blkio-controller.txt |   40 +++++++
> >>  block/blk-cgroup.c                         |  166 +++++++++++++++++++++++++---
> >>  block/blk-cgroup.h                         |   60 ++++++++--
> >>  block/cfq-iosched.c                        |    3 -
> >>  4 files changed, 239 insertions(+), 30 deletions(-)
> >>
> >> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> >> index 630879c..087925b 100644
> >> --- a/Documentation/cgroups/blkio-controller.txt
> >> +++ b/Documentation/cgroups/blkio-controller.txt
> >> @@ -77,7 +77,6 @@ Details of cgroup files
> >>  =======================
> >>  - blkio.weight
> >>       - Specifies per cgroup weight.
> >> -
> >>         Currently allowed range of weights is from 100 to 1000.
> >>
> >>  - blkio.time
> >> @@ -92,6 +91,41 @@ Details of cgroup files
> >>         third field specifies the number of sectors transferred by the
> >>         group to/from the device.
> >>
> >> +- blkio.io_service_bytes
> >> +     - Number of bytes transferred to/from the disk by the group. These
> >> +       are further divided by the type of operation - read or write, sync
> >> +       or async. First two fields specify the major and minor number of the
> >> +       device, third field specifies the operation type and the fourth field
> >> +       specifies the number of bytes.
> >> +
> >> +- blkio.io_serviced
> >> +     - Number of IOs completed to/from the disk by the group. These
> >> +       are further divided by the type of operation - read or write, sync
> >> +       or async. First two fields specify the major and minor number of the
> >> +       device, third field specifies the operation type and the fourth field
> >> +       specifies the number of IOs.
> >> +
> >
> > Hi Divyesh,
> >
> > V3 looks much better. Just couple of minor nits.
> >
> >> +- blkio.io_service_time
> >> +     - Total amount of time between request dispatch and request completion
> >> +       for the IOs done by this cgroup. This is in nanoseconds to make it
> >> +       meaningful for flash devices too. For devices with queue depth of 1,
> >> +       this time represents the actual service time. When queue_depth > 1,
> >> +       that is no longer true as requests may be served out of order.
> >
> > Like io_wait_time, can you also mention here that this time is cumulative
> > time and on NCQ disks it can be more than actual time elapsed.
> 
> Will do.
> 
> >
> > I did a quick run with your patches. I ran a sequential workload for 30s
> > in two groups of weight 100 and 200. Following is the output of
> > blkio.io_service_time (I have kept stats for only disk 253:3 in output).
> >
> > # cat test1/blkio.io_service_time
> > 253:3 Read 18019970625
> > 253:3 Write 0
> > 253:3 Sync 18019970625
> > 253:3 Async 0
> > 253:3 Total 18019970625
> >
> > # cat test2/blkio.io_service_time
> > 253:3 Read 35479070171
> > 253:3 Write 0
> > 253:3 Sync 35479070171
> > 253:3 Async 0
> >
> > This storage supports NCQ. We see that though I ran test only for
> > 30 seconds, total service ime for cgroup is close to 18+35=53 seconds.
> 
> Yes that is expected as from our discussion about NCQ as any IO can
> have the service time of multiple IOs coupled together when serviced
> out of order.
> 
> >
> >> +       This time is further divided by the type of operation -
> >> +       read or write, sync or async. First two fields specify the major and
> >> +       minor number of the device, third field specifies the operation type
> >> +       and the fourth field specifies the io_service_time in ns.
> >> +
> >> +- blkio.io_wait_time
> >> +     - Total amount of time the IO spent waiting in the scheduler queues for
> >> +       service. This can be greater than the total time elapsed since it is
> >> +       cumulative io_wait_time for all IOs. This is in nanoseconds to make it
> >> +       meaningful for flash devices too. This time is further divided by the
> >> +       type of operation - read or write, sync or async. First two fields
> >> +       specify the major and minor number of the device, third field
> >> +       specifies the operation type and the fourth field specifies the
> >> +       io_wait_time in ns.
> >> +
> >>  - blkio.dequeue
> >>       - Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y. This
> >>         gives the statistics about how many a times a group was dequeued
> >> @@ -99,6 +133,10 @@ Details of cgroup files
> >>         and minor number of the device and third field specifies the number
> >>         of times a group was dequeued from a particular device.
> >>
> >> +- blkio.reset_stats
> >> +     - Writing an int to this file will result in resetting all the stats
> >> +       for that cgroup.
> >> +
> >
> > Personally, I like adding a separate file to reset the stats. Now one does
> > not get surprised by the fact that writting to blkio.io_service_time, also
> > reset rest of the stats.
> >
> >>  CFQ sysfs tunable
> >>  =================
> >>  /sys/block/<disk>/queue/iosched/group_isolation
> >> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> >> index 5be3981..d585a05 100644
> >> --- a/block/blk-cgroup.c
> >> +++ b/block/blk-cgroup.c
> >> @@ -17,6 +17,8 @@
> >>  #include <linux/err.h>
> >>  #include "blk-cgroup.h"
> >>
> >> +#define MAX_KEY_LEN 100
> >> +
> >>  static DEFINE_SPINLOCK(blkio_list_lock);
> >>  static LIST_HEAD(blkio_list);
> >>
> >> @@ -55,12 +57,21 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
> >>  }
> >>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
> >>
> >> -void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> >> -                                             unsigned long time)
> >> +void blkio_group_init(struct blkio_group *blkg)
> >> +{
> >> +     spin_lock_init(&blkg->stats_lock);
> >> +}
> >> +EXPORT_SYMBOL_GPL(blkio_group_init);
> >> +
> >> +void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
> >>  {
> >> -     blkg->time += time;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&blkg->stats_lock, flags);
> >> +     blkg->stats.time += time;
> >> +     spin_unlock_irqrestore(&blkg->stats_lock, flags);
> >>  }
> >> -EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_stats);
> >> +EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
> >>
> >>  void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
> >>                       struct blkio_group *blkg, void *key, dev_t dev)
> >> @@ -170,13 +181,107 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
> >>       return 0;
> >>  }
> >>
> >> -#define SHOW_FUNCTION_PER_GROUP(__VAR)                                       \
> >> +static int
> >> +blkiocg_reset_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
> >> +{
> >
> > I guess we can rename this function to blkiocg_reset_stats().
> Will do
> 
> >
> > [..]
> >> @@ -217,16 +331,36 @@ struct cftype blkio_files[] = {
> >>       },
> >>       {
> >>               .name = "time",
> >> -             .read_seq_string = blkiocg_time_read,
> >> +             .read_map = blkiocg_time_read,
> >>       },
> >>       {
> >>               .name = "sectors",
> >> -             .read_seq_string = blkiocg_sectors_read,
> >> +             .read_map = blkiocg_sectors_read,
> >> +     },
> >> +     {
> >> +             .name = "io_service_bytes",
> >> +             .read_map = blkiocg_io_service_bytes_read,
> >> +     },
> >> +     {
> >> +             .name = "io_serviced",
> >> +             .read_map = blkiocg_io_serviced_read,
> >> +     },
> >> +     {
> >> +             .name = "io_service_time",
> >> +             .read_map = blkiocg_io_service_time_read,
> >> +     },
> >> +     {
> >> +             .name = "io_wait_time",
> >> +             .read_map = blkiocg_io_wait_time_read,
> >> +     },
> >> +     {
> >> +             .name = "reset_stats",
> >> +             .write_u64 = blkiocg_reset_write,
> >
> > use blkiocg_reset_stats?
> Will do
> >
> > Thanks
> > Vivek
> >
