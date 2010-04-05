Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0DEWHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:07:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48808 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab0DEWGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:06:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Xrr7i5CaKfGLMVb9TiJupDNH1kV2Oc7nQS1nnjWBiUw3rrUWzm0SS/RygO5dHMWO/
	0ttpbfbdWfX/Ll+zaeE4A==
MIME-Version: 1.0
In-Reply-To: <20100405172909.GI876@redhat.com>
References: <20100401215541.2843.79107.stgit@austin.mtv.corp.google.com> 
	<20100401220129.2843.36193.stgit@austin.mtv.corp.google.com> 
	<20100402191000.GD3516@redhat.com> <w2maf41c7c41004021636ia2261ffcv56b6c85928bdee86@mail.gmail.com> 
	<20100405151237.GD876@redhat.com> <t2qaf41c7c41004050953v8807001we5da5fb26d088c7a@mail.gmail.com> 
	<20100405172909.GI876@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Mon, 5 Apr 2010 15:06:31 -0700
Message-ID: <j2haf41c7c41004051506z7efc0b1ai55d2c9b1f621556b@mail.gmail.com>
Subject: Re: [PATCH 3/3] blkio: Increment the blkio cgroup stats for real now
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 5, 2010 at 10:29 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Apr 05, 2010 at 09:53:25AM -0700, Divyesh Shah wrote:
>> On Mon, Apr 5, 2010 at 8:12 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Fri, Apr 02, 2010 at 04:36:34PM -0700, Divyesh Shah wrote:
>> >> On Fri, Apr 2, 2010 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> > On Thu, Apr 01, 2010 at 03:01:41PM -0700, Divyesh Shah wrote:
>> >> >> We also add start_time_ns and io_start_time_ns fields to struct request
>> >> >> here to record the time when a request is created and when it is
>> >> >> dispatched to device. We use ns uints here as ms and jiffies are
>> >> >> not very useful for non-rotational media.
>> >> >>
>> >> >> Signed-off-by: Divyesh Shah<dpshah@google.com>
>> >> >> ---
>> >> >>
>> >> >>  block/blk-cgroup.c     |   60 ++++++++++++++++++++++++++++++++++++++++++++++--
>> >> >>  block/blk-cgroup.h     |   14 +++++++++--
>> >> >>  block/blk-core.c       |    6 +++--
>> >> >>  block/cfq-iosched.c    |    4 ++-
>> >> >>  include/linux/blkdev.h |   20 +++++++++++++++-
>> >> >>  5 files changed, 95 insertions(+), 9 deletions(-)
>> >> >>
>> >> >> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> >> >> index ad6843f..9af7257 100644
>> >> >> --- a/block/blk-cgroup.c
>> >> >> +++ b/block/blk-cgroup.c
>> >> >> @@ -15,6 +15,7 @@
>> >> >>  #include <linux/kdev_t.h>
>> >> >>  #include <linux/module.h>
>> >> >>  #include <linux/err.h>
>> >> >> +#include <linux/blkdev.h>
>> >> >>  #include "blk-cgroup.h"
>> >> >>
>> >> >>  static DEFINE_SPINLOCK(blkio_list_lock);
>> >> >> @@ -55,6 +56,26 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>> >> >>  }
>> >> >>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>> >> >>
>> >> >> +/*
>> >> >> + * Add to the appropriate stat variable depending on the request type.
>> >> >> + * This should be called with the blkg->stats_lock held.
>> >> >> + */
>> >> >> +void io_add_stat(uint64_t *stat, uint64_t add, unsigned int flags)
>> >> >> +{
>> >> >> +     if (flags & REQ_RW)
>> >> >> +             stat[IO_WRITE] += add;
>> >> >> +     else
>> >> >> +             stat[IO_READ] += add;
>> >> >> +     /*
>> >> >> +      * Everywhere in the block layer, an IO is treated as sync if it is a
>> >> >> +      * read or a SYNC write. We follow the same norm.
>> >> >> +      */
>> >> >> +     if (!(flags & REQ_RW) || flags & REQ_RW_SYNC)
>> >> >> +             stat[IO_SYNC] += add;
>> >> >> +     else
>> >> >> +             stat[IO_ASYNC] += add;
>> >> >> +}
>> >> >> +
>> >> >
>> >> > Hi Divyesh,
>> >> >
>> >> > Can we have any request based information limited to cfq and not put that
>> >> > in blkio-cgroup. The reason being that I am expecting that some kind of
>> >> > max bw policy interface will not necessarily be implemented at CFQ
>> >> > level. We might have to implement it at higher level so that it can
>> >> > work with all dm/md devices. If that's the case, then it might very well
>> >> > be either a bio based interface also.
>> >> >
>> >> > So just keeping that possibility in mind, can we keep blk-cgroup as
>> >> > generic as possible and not necessarily make it dependent on "struct
>> >> > request".
>> >>
>> >> Ok. I do understand the motivation for keeping the request related
>> >> info out of blk-cgroup. Everything except the rq->cmd_flags can be
>> >> easily done away with. Maybe I'll need to have CFQ send the sync and
>> >> direction bits as args to the functions that need it. Not ideal coz
>> >> we'll have functions with many args but I guess its not that bad too.
>> >>
>> >> >
>> >> > If you implement, two dimensional arrays for stats then we can have
>> >> > following function.
>> >> >
>> >> > blkio_add_stat(enum stat_type var enum stat_sub_type var_type, u64 val)
>> >>
>> >> I would want to avoid calls like these from CFQ into the blkcg code
>> >> because many CFQ events trigger update for multiple stats (you'll see
>> >> more with stats in later patchsets) and doing these calls
>> >> independently for each stat would mean that we would also need to grab
>> >> the stats_lock multiple times when we could've avoided that.
>> >
>> > I understand the need to club the updates and reduce the need of taking
>> > stats_lock multiple times. I was thinking of any of following.
>> >
>> > - Get rid of reset interface per cgroup. Rely on changing ioscheduler on
>> >  request queue and that will get rid of stats_lock entirely.
>>
>> This takes away the ability to reset stats at will which is very
>> useful when debugging and for testing IO controller.
>>
>
> What do you mean by "reset stats at will"? You can change ioscheduler at
> will and reset stats? The only possible issue I could think of is that only
> admin can change the ioscheduler in providing per cgroup interface, one can
> give write permission to indiviaul user and allow users to reset stats.

I should've said reset stats for a given cgroup at will. This is
mostly needed when debugging and for automated tests where we're
testing multiple cgroups and/or IO controller behavior between
different workloads (sync readers, buffered writers, sync_writers,
directIO read/write, etc). Resetting cgroup stats is something we use
regularly and depend on. If you feel very strongly about this being
counter-intuitive I can add a reset_stats file and make the other
stats read-only.

> I am not sure in practice why would you allow a user to reset stats.
> Especially if somebody's accounting software is based on these stats.
>
>> > - Can we use a function blkio_add_stat() with variable number of arguments
>> >  so that more than one stat can be updated in a single call?
>>
>> I really don't like this at all.
>>
>> > If you have other ideas to implement it without assuming "struct rq" in
>> > blk-cgroup, please do that.
>>
>> I've already got rid of any rq assumptions in blk-cgroup. The only
>> place where we're using rq is for rq_start_time_ns() and
>> rq_io-start_time_ns() functions but they are not used by the
>> blk-cgroup code directly (only CFQ uses them). For another user of
>> io-controller, we can implement a bio based functions.
>
> Ok, you have made blkg->stats_lock visible to cfq. That's fine too.

By visible you mean accessible through cfqg->blkg, right? However, I
don't intend to use it anywhere in cfq code.

> Can you rename io_add_stat to blkio_add_stat. I think in V2 also, it is
> still io_add_stat.

Sorry I missed that one. Will do in v3.
>
> Vivek
>
