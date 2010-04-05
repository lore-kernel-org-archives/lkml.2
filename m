Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab0DEWRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:17:07 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22352 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab0DEWQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:16:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=eLn+RLV/7yWJsySGxIDyHgIK/gyIngmu/Ho7pSOek7/tb8jhS4ExXW59AgUcRD442
	VjufkVormfk8gEaO9wMew==
MIME-Version: 1.0
In-Reply-To: <20100405144550.GC876@redhat.com>
References: <20100401215541.2843.79107.stgit@austin.mtv.corp.google.com> 
	<20100401220109.2843.36040.stgit@austin.mtv.corp.google.com> 
	<20100402181049.GB3516@redhat.com> <h2vaf41c7c41004021353k37e6b085ma0e7acebdf37c65b@mail.gmail.com> 
	<20100405144550.GC876@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Mon, 5 Apr 2010 15:16:35 -0700
Message-ID: <x2zaf41c7c41004051516u6e0aee91ta68a542d366e0dcc@mail.gmail.com>
Subject: Re: [PATCH 2/3] blkio: Add io controller stats like
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 5, 2010 at 7:45 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Apr 02, 2010 at 01:53:30PM -0700, Divyesh Shah wrote:
>
> [..]
>> >> +#define GET_STAT_INDEXED(__VAR)                                              \
>> >> +uint64_t get_##__VAR##_stat(struct blkio_group *blkg, int type)              \
>> >> +{                                                                    \
>> >> +     return blkg->stats.__VAR[type];                                 \
>> >> +}                                                                    \
>> >> +
>> >> +GET_STAT_INDEXED(io_service_bytes);
>> >> +GET_STAT_INDEXED(io_serviced);
>> >> +GET_STAT_INDEXED(io_service_time);
>> >> +GET_STAT_INDEXED(io_wait_time);
>> >> +#undef GET_STAT_INDEXED
>> >> +
>> >> +#define GET_STAT(__VAR, __CONV)                                              \
>> >> +uint64_t get_##__VAR##_stat(struct blkio_group *blkg, int dummy)     \
>> >> +{                                                                    \
>> >> +     uint64_t data = blkg->stats.__VAR;                              \
>> >> +     if (__CONV)                                                     \
>> >> +             data = (uint64_t)jiffies_to_msecs(data) * NSEC_PER_MSEC;\
>> >> +     return data;                                                    \
>> >> +}
>> >> +
>> >> +GET_STAT(time, 1);
>> >> +GET_STAT(sectors, 0);
>> >> +#ifdef CONFIG_DEBUG_BLK_CGROUP
>> >> +GET_STAT(dequeue, 0);
>> >> +#endif
>> >> +#undef GET_STAT
>> >> +
>> >
>> > I think now so many macros to define different kind of functions is
>> > becoming really confusing. How about creating a two dimensional stat
>> > array which is indexed by type of io stat like "io_service_time" and
>> > then indexed by sub io type that is "READ, WRITE, SYNC" etc. And we
>> > can define a single function to read all kind of stats.
>> >
>> > That way we will not have to define one GET_STAT_INDEXED() and GET_STAT()
>> > for each unindexed variable. If there are not multiple functions then,
>> > then everywhere we don't have to pass around a function pointer to read
>> > the variable stat and code should become much simpler. Example, code
>> > follows.
>> >
>> >
>> > enum stat_type {
>> >        BLKIO_STAT_TIME
>> >        BLKIO_STAT_SECTORS
>> >        BLKIO_STAT_WAIT_TIME
>> >        BLKIO_STAT_SERVICE_TIME
>> > }
>> >
>> > enum stat_sub_type {
>> >        BLKIO_STAT_READ
>> >        BLKIO_STAT_WRITE
>> >        BLKIO_STAT_SYNC
>> > }
>> >
>> > blkio_get_stat_var(enum stat_type var, enum stat_sub_type var_type) {
>> >
>> >        if (var == BLKIO_STAT_TIME)
>> >                reutrn blkg->stat.time
>> >
>> >        /* Same as above for sectors */
>> >
>> >        return blkg->stat[var][var_type];
>> > }
>>
>> I'm not sure adding this level of complexity (2nd dimension for stats)
>> and the numerous if (..) statements (or switch) is warranted
>
> I think we need only two conditions to check. BLKIO_STAT_TIME and
> BLKIO_STAT_SECTROS. Rest of these fall into typed category and we
> don't have to check for tyeps.
>
>> when they
>> only apply for the get_stat() and get_typed_stat() functions. This
>> seems like a more complicated simplification :).
>
> I think this really is simplification. This also gets rid of all the
> function pointers you are passing around to differentiate between two
> types of stats. Also gets rid of special macros to generate one function
> each for one kind of stat. These dynamic macros make code hard to read
> and understand.
>
> Can you please try this two dimensional array for stats approach once.
> I belive your code will be much easier to read.

There are 2 conditions now but as I mentioned that this is one of 2-3
patchsets for adding stats. More stats will increase the special
casing. I do agree the macros aren't exactly easy to read. I'll try
your suggested approach next and post a patchset when I'm done.

>
>>
>> >
>> > Also all these get_* function needs to be static.
>> Done
>> >
>> >> +#define SHOW_FUNCTION_PER_GROUP(__VAR, get_stats, getvar, show_total)        \
>> >>  static int blkiocg_##__VAR##_read(struct cgroup *cgroup,             \
>> >> -                     struct cftype *cftype, struct seq_file *m)      \
>> >> +             struct cftype *cftype, struct cgroup_map_cb *cb)        \
>> >>  {                                                                    \
>> >>       struct blkio_cgroup *blkcg;                                     \
>> >>       struct blkio_group *blkg;                                       \
>> >>       struct hlist_node *n;                                           \
>> >> +     uint64_t cgroup_total = 0;                                      \
>> >> +     char disk_id[10];                                               \
>> >>                                                                       \
>> >>       if (!cgroup_lock_live_group(cgroup))                            \
>> >>               return -ENODEV;                                         \
>> >> @@ -184,19 +295,32 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,                \
>> >>       blkcg = cgroup_to_blkio_cgroup(cgroup);                         \
>> >>       rcu_read_lock();                                                \
>> >>       hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {\
>> >> -             if (blkg->dev)                                          \
>> >> -                     seq_printf(m, "%u:%u %lu\n", MAJOR(blkg->dev),  \
>> >> -                              MINOR(blkg->dev), blkg->__VAR);        \
>> >> +             if (blkg->dev) {                                        \
>> >> +                     spin_lock_irq(&blkg->stats_lock);               \
>> >> +                     snprintf(disk_id, 10, "%u:%u", MAJOR(blkg->dev),\
>> >> +                                     MINOR(blkg->dev));              \
>> >> +                     cgroup_total += get_stats(blkg, cb, getvar,     \
>> >> +                                             disk_id);               \
>> >> +                     spin_unlock_irq(&blkg->stats_lock);             \
>> >> +             }                                                       \
>> >>       }                                                               \
>> >> +     if (show_total)                                                 \
>> >> +             cb->fill(cb, "Total", cgroup_total);                    \
>> >>       rcu_read_unlock();                                              \
>> >>       cgroup_unlock();                                                \
>> >>       return 0;                                                       \
>> >>  }
>> >>
>> >> -SHOW_FUNCTION_PER_GROUP(time);
>> >> -SHOW_FUNCTION_PER_GROUP(sectors);
>> >> +SHOW_FUNCTION_PER_GROUP(time, get_stat, get_time_stat, 0);
>> >> +SHOW_FUNCTION_PER_GROUP(sectors, get_stat, get_sectors_stat, 0);
>> >> +SHOW_FUNCTION_PER_GROUP(io_service_bytes, get_typed_stat,
>> >> +                     get_io_service_bytes_stat, 1);
>> >> +SHOW_FUNCTION_PER_GROUP(io_serviced, get_typed_stat, get_io_serviced_stat, 1);
>> >> +SHOW_FUNCTION_PER_GROUP(io_service_time, get_typed_stat,
>> >> +                     get_io_service_time_stat, 1);
>> >> +SHOW_FUNCTION_PER_GROUP(io_wait_time, get_typed_stat, get_io_wait_time_stat, 1);
>> >>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>> >> -SHOW_FUNCTION_PER_GROUP(dequeue);
>> >> +SHOW_FUNCTION_PER_GROUP(dequeue, get_stat, get_dequeue_stat, 0);
>> >>  #endif
>> >>  #undef SHOW_FUNCTION_PER_GROUP
>> >>
>> >> @@ -204,7 +328,7 @@ SHOW_FUNCTION_PER_GROUP(dequeue);
>> >>  void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
>> >>                       unsigned long dequeue)
>> >>  {
>> >> -     blkg->dequeue += dequeue;
>> >> +     blkg->stats.dequeue += dequeue;
>> >>  }
>> >>  EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
>> >>  #endif
>> >> @@ -217,16 +341,38 @@ struct cftype blkio_files[] = {
>> >>       },
>> >>       {
>> >>               .name = "time",
>> >> -             .read_seq_string = blkiocg_time_read,
>> >> +             .read_map = blkiocg_time_read,
>> >> +             .write_u64 = blkiocg_reset_write,
>> >>       },
>> >>       {
>> >>               .name = "sectors",
>> >> -             .read_seq_string = blkiocg_sectors_read,
>> >> +             .read_map = blkiocg_sectors_read,
>> >> +             .write_u64 = blkiocg_reset_write,
>> >> +     },
>> >> +     {
>> >> +             .name = "io_service_bytes",
>> >> +             .read_map = blkiocg_io_service_bytes_read,
>> >> +             .write_u64 = blkiocg_reset_write,
>> >> +     },
>> >> +     {
>> >> +             .name = "io_serviced",
>> >> +             .read_map = blkiocg_io_serviced_read,
>> >> +             .write_u64 = blkiocg_reset_write,
>> >> +     },
>> >> +     {
>> >> +             .name = "io_service_time",
>> >> +             .read_map = blkiocg_io_service_time_read,
>> >> +             .write_u64 = blkiocg_reset_write,
>> >> +     },
>> >> +     {
>> >> +             .name = "io_wait_time",
>> >> +             .read_map = blkiocg_io_wait_time_read,
>> >> +             .write_u64 = blkiocg_reset_write,
>> >>       },
>> >
>> > blkiocg_reset_write() is invoked if a user does some write on any of the
>> > above files. This will reset all the stats. So if I do echo x >
>> > blkio.time, I will see all other files being reset? I think this is
>> > little counter intutive.
>> >
>> > Either we need to reset only those specific stats (the file being written
>> > to) or may be we can provide a separate file "blkio.reset_stats" to reset
>> > all the stats?
>>
>> I added a note in the Documentation file that writing an int to any of
>> the stats should reset all. I don't get the point of introducing
>> another file for this and would want stats to be cleared all together
>> in order to have say io_service_time and io_serviced in sync, i.e.,
>> the io_service_time should always be the total service time for the
>> IOs accounted for in io_serviced.
>>
>
> I agree that reset should mean reset of all stats. It is a matter of
> whether to introduce a separate file or write to one file resets all the
> other files. Though I find writting to one file resetting the stats of
> other file un-intitutive, at the same time don't feel too excited about
> introducing a new file just for reset.
>
> Do we really need to introduce reset interface. Changing the ioscheduler to
> noop or deadline and then setting it back to cfq should reset the stats for
> all the cgroups.
>
> In fact we can probably get rid of per cgroup reset stats interface. We
> will then get rid of extra stat spin lock. If somebody wants to reset
> the stats, just change the ioscheduler.
> This will work until and unless somebody wants to reset the stats of one
> cgroup but not the other.

As mentioned on the other thread this is exactly what I find the main
use case of this interface. Once again, if you feel too strongly about
it we can have a separate reset_stats interface to make it more
intuitive.

>
> Thanks
> Vivek
>
