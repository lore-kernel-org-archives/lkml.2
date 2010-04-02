Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab0DBUyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:54:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34007 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0DBUxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:53:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OODpKZybzHiHAjHLb8DHBeIDtabK5JG7lIVhTIBXHNJm1y6U38GnrF6y+3mCPBRc4
	QrfDXKRKy6AAzE9twCh5A==
MIME-Version: 1.0
In-Reply-To: <20100402181049.GB3516@redhat.com>
References: <20100401215541.2843.79107.stgit@austin.mtv.corp.google.com> 
	<20100401220109.2843.36040.stgit@austin.mtv.corp.google.com> 
	<20100402181049.GB3516@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 2 Apr 2010 13:53:30 -0700
Message-ID: <h2vaf41c7c41004021353k37e6b085ma0e7acebdf37c65b@mail.gmail.com>
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

Vivek, thanks for the detailed review. Comments inline. I'll send a V2
patchset soon.

On Fri, Apr 2, 2010 at 11:10 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 01, 2010 at 03:01:24PM -0700, Divyesh Shah wrote:
>> - io_service_time
>> - io_wait_time
>> - io_serviced
>> - io_service_bytes
>>
>
> Hi Divyesh,
>
> Some more description what exactly these stats are will be helpful. Please
> also update Documentation/cgroup/blkio-controller.txt file appropriately.
> Especially, "Details of cgroup files" section.

Done. Will be in V2

>
>> These stats are accumulated per operation type helping us to distinguish between
>> read and write, and sync and async IO. This patch does not increment any of
>> these stats.
>>
>> Signed-off-by: Divyesh Shah<dpshah@google.com>
>> ---
>>
>>  block/blk-cgroup.c  |  178 ++++++++++++++++++++++++++++++++++++++++++++++-----
>>  block/blk-cgroup.h  |   39 +++++++++--
>>  block/cfq-iosched.c |    2 -
>>  3 files changed, 194 insertions(+), 25 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 5be3981..ad6843f 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -55,12 +55,15 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>>  }
>>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>>
>> -void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
>> -                                             unsigned long time)
>> +void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
>>  {
>> -     blkg->time += time;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&blkg->stats_lock, flags);
>> +     blkg->stats.time += time;
>> +     spin_unlock_irqrestore(&blkg->stats_lock, flags);
>>  }
>> -EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_stats);
>> +EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
>>
>>  void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>>                       struct blkio_group *blkg, void *key, dev_t dev)
>> @@ -170,13 +173,121 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>>       return 0;
>>  }
>>
>> -#define SHOW_FUNCTION_PER_GROUP(__VAR)                                       \
>> +static int
>> +blkiocg_reset_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>> +{
>> +     struct blkio_cgroup *blkcg;
>> +     struct blkio_group *blkg;
>> +     struct hlist_node *n;
>> +     struct blkio_group_stats *stats;
>> +
>> +     blkcg = cgroup_to_blkio_cgroup(cgroup);
>> +     spin_lock_irq(&blkcg->lock);
>> +     hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
>> +             spin_lock(&blkg->stats_lock);
>> +             stats = &blkg->stats;
>> +             memset(stats, 0, sizeof(struct blkio_group_stats));
>> +             spin_unlock(&blkg->stats_lock);
>> +     }
>> +     spin_unlock_irq(&blkcg->lock);
>> +     return 0;
>> +}
>> +
>> +void get_key_name(int type, char *disk_id, char *str, int chars_left)
>> +{
>
> get_key_name() should be static? Can we prefix all these internal function
> names with blkio?
Done. Will be in V2.

>
> Do we have to introduce this separate notion of char *disk_id. Can we
> simply stick to dev_t and do the sprintf like functions to convert that
> into key. For me personally it is just less confusion while reading code.
>
>> +     strlcpy(str, disk_id, chars_left);
>> +     chars_left -= strlen(str);
>> +     if (chars_left <= 0) {
>> +             printk(KERN_WARNING
>> +                     "Possibly incorrect cgroup stat display format");
>> +             return;
>> +     }
>> +     switch (type) {
>> +     case IO_READ:
>> +             strlcat(str, " Read", chars_left);
>> +             break;
>> +     case IO_WRITE:
>> +             strlcat(str, " Write", chars_left);
>> +             break;
>> +     case IO_SYNC:
>> +             strlcat(str, " Sync", chars_left);
>> +             break;
>> +     case IO_ASYNC:
>> +             strlcat(str, " Async", chars_left);
>> +             break;
>> +     case IO_TYPE_MAX:
>> +             strlcat(str, " Total", chars_left);
>> +             break;
>
> Should we use IO_TYPE_TOTAL for "Total" stats.

Can certainly replace MAX with TOTAL.

>
>> +     default:
>> +             strlcat(str, " Invalid", chars_left);
>> +     }
>> +}
>> +
>> +typedef uint64_t (get_var) (struct blkio_group *, int);
>> +
>> +#define MAX_KEY_LEN 100
>
> Can we move above define to the beginning of the file. So that it is
> easily visible.
Done
>
>> +uint64_t get_typed_stat(struct blkio_group *blkg, struct cgroup_map_cb *cb,
>> +             get_var *getvar, char *disk_id)
>> +{
>
> static function? blkio_get_typed_stat()?
Done
>
> Again, can we use dev_t instead of char *disk_id.
Good point. Done
>
>> +     uint64_t disk_total;
>> +     char key_str[MAX_KEY_LEN];
>> +     int type;
>> +
>> +     for (type = 0; type < IO_TYPE_MAX; type++) {
>> +             get_key_name(type, disk_id, key_str, MAX_KEY_LEN);
>> +             cb->fill(cb, key_str, getvar(blkg, type));
>> +     }
>> +     disk_total = getvar(blkg, IO_READ) + getvar(blkg, IO_WRITE);
>> +     get_key_name(IO_TYPE_MAX, disk_id, key_str, MAX_KEY_LEN);
>> +     cb->fill(cb, key_str, disk_total);
>> +     return disk_total;
>> +}
>> +
>> +uint64_t get_stat(struct blkio_group *blkg, struct cgroup_map_cb *cb,
>> +             get_var *getvar, char *disk_id)
>> +{
>> +     uint64_t var = getvar(blkg, 0);
>> +     cb->fill(cb, disk_id, var);
>> +     return var;
>> +}
>> +
>> +#define GET_STAT_INDEXED(__VAR)                                              \
>> +uint64_t get_##__VAR##_stat(struct blkio_group *blkg, int type)              \
>> +{                                                                    \
>> +     return blkg->stats.__VAR[type];                                 \
>> +}                                                                    \
>> +
>> +GET_STAT_INDEXED(io_service_bytes);
>> +GET_STAT_INDEXED(io_serviced);
>> +GET_STAT_INDEXED(io_service_time);
>> +GET_STAT_INDEXED(io_wait_time);
>> +#undef GET_STAT_INDEXED
>> +
>> +#define GET_STAT(__VAR, __CONV)                                              \
>> +uint64_t get_##__VAR##_stat(struct blkio_group *blkg, int dummy)     \
>> +{                                                                    \
>> +     uint64_t data = blkg->stats.__VAR;                              \
>> +     if (__CONV)                                                     \
>> +             data = (uint64_t)jiffies_to_msecs(data) * NSEC_PER_MSEC;\
>> +     return data;                                                    \
>> +}
>> +
>> +GET_STAT(time, 1);
>> +GET_STAT(sectors, 0);
>> +#ifdef CONFIG_DEBUG_BLK_CGROUP
>> +GET_STAT(dequeue, 0);
>> +#endif
>> +#undef GET_STAT
>> +
>
> I think now so many macros to define different kind of functions is
> becoming really confusing. How about creating a two dimensional stat
> array which is indexed by type of io stat like "io_service_time" and
> then indexed by sub io type that is "READ, WRITE, SYNC" etc. And we
> can define a single function to read all kind of stats.
>
> That way we will not have to define one GET_STAT_INDEXED() and GET_STAT()
> for each unindexed variable. If there are not multiple functions then,
> then everywhere we don't have to pass around a function pointer to read
> the variable stat and code should become much simpler. Example, code
> follows.
>
>
> enum stat_type {
>        BLKIO_STAT_TIME
>        BLKIO_STAT_SECTORS
>        BLKIO_STAT_WAIT_TIME
>        BLKIO_STAT_SERVICE_TIME
> }
>
> enum stat_sub_type {
>        BLKIO_STAT_READ
>        BLKIO_STAT_WRITE
>        BLKIO_STAT_SYNC
> }
>
> blkio_get_stat_var(enum stat_type var, enum stat_sub_type var_type) {
>
>        if (var == BLKIO_STAT_TIME)
>                reutrn blkg->stat.time
>
>        /* Same as above for sectors */
>
>        return blkg->stat[var][var_type];
> }

I'm not sure adding this level of complexity (2nd dimension for stats)
and the numerous if (..) statements (or switch) is warranted when they
only apply for the get_stat() and get_typed_stat() functions. This
seems like a more complicated simplification :).

>
> Also all these get_* function needs to be static.
Done
>
>> +#define SHOW_FUNCTION_PER_GROUP(__VAR, get_stats, getvar, show_total)        \
>>  static int blkiocg_##__VAR##_read(struct cgroup *cgroup,             \
>> -                     struct cftype *cftype, struct seq_file *m)      \
>> +             struct cftype *cftype, struct cgroup_map_cb *cb)        \
>>  {                                                                    \
>>       struct blkio_cgroup *blkcg;                                     \
>>       struct blkio_group *blkg;                                       \
>>       struct hlist_node *n;                                           \
>> +     uint64_t cgroup_total = 0;                                      \
>> +     char disk_id[10];                                               \
>>                                                                       \
>>       if (!cgroup_lock_live_group(cgroup))                            \
>>               return -ENODEV;                                         \
>> @@ -184,19 +295,32 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,                \
>>       blkcg = cgroup_to_blkio_cgroup(cgroup);                         \
>>       rcu_read_lock();                                                \
>>       hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {\
>> -             if (blkg->dev)                                          \
>> -                     seq_printf(m, "%u:%u %lu\n", MAJOR(blkg->dev),  \
>> -                              MINOR(blkg->dev), blkg->__VAR);        \
>> +             if (blkg->dev) {                                        \
>> +                     spin_lock_irq(&blkg->stats_lock);               \
>> +                     snprintf(disk_id, 10, "%u:%u", MAJOR(blkg->dev),\
>> +                                     MINOR(blkg->dev));              \
>> +                     cgroup_total += get_stats(blkg, cb, getvar,     \
>> +                                             disk_id);               \
>> +                     spin_unlock_irq(&blkg->stats_lock);             \
>> +             }                                                       \
>>       }                                                               \
>> +     if (show_total)                                                 \
>> +             cb->fill(cb, "Total", cgroup_total);                    \
>>       rcu_read_unlock();                                              \
>>       cgroup_unlock();                                                \
>>       return 0;                                                       \
>>  }
>>
>> -SHOW_FUNCTION_PER_GROUP(time);
>> -SHOW_FUNCTION_PER_GROUP(sectors);
>> +SHOW_FUNCTION_PER_GROUP(time, get_stat, get_time_stat, 0);
>> +SHOW_FUNCTION_PER_GROUP(sectors, get_stat, get_sectors_stat, 0);
>> +SHOW_FUNCTION_PER_GROUP(io_service_bytes, get_typed_stat,
>> +                     get_io_service_bytes_stat, 1);
>> +SHOW_FUNCTION_PER_GROUP(io_serviced, get_typed_stat, get_io_serviced_stat, 1);
>> +SHOW_FUNCTION_PER_GROUP(io_service_time, get_typed_stat,
>> +                     get_io_service_time_stat, 1);
>> +SHOW_FUNCTION_PER_GROUP(io_wait_time, get_typed_stat, get_io_wait_time_stat, 1);
>>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>> -SHOW_FUNCTION_PER_GROUP(dequeue);
>> +SHOW_FUNCTION_PER_GROUP(dequeue, get_stat, get_dequeue_stat, 0);
>>  #endif
>>  #undef SHOW_FUNCTION_PER_GROUP
>>
>> @@ -204,7 +328,7 @@ SHOW_FUNCTION_PER_GROUP(dequeue);
>>  void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
>>                       unsigned long dequeue)
>>  {
>> -     blkg->dequeue += dequeue;
>> +     blkg->stats.dequeue += dequeue;
>>  }
>>  EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
>>  #endif
>> @@ -217,16 +341,38 @@ struct cftype blkio_files[] = {
>>       },
>>       {
>>               .name = "time",
>> -             .read_seq_string = blkiocg_time_read,
>> +             .read_map = blkiocg_time_read,
>> +             .write_u64 = blkiocg_reset_write,
>>       },
>>       {
>>               .name = "sectors",
>> -             .read_seq_string = blkiocg_sectors_read,
>> +             .read_map = blkiocg_sectors_read,
>> +             .write_u64 = blkiocg_reset_write,
>> +     },
>> +     {
>> +             .name = "io_service_bytes",
>> +             .read_map = blkiocg_io_service_bytes_read,
>> +             .write_u64 = blkiocg_reset_write,
>> +     },
>> +     {
>> +             .name = "io_serviced",
>> +             .read_map = blkiocg_io_serviced_read,
>> +             .write_u64 = blkiocg_reset_write,
>> +     },
>> +     {
>> +             .name = "io_service_time",
>> +             .read_map = blkiocg_io_service_time_read,
>> +             .write_u64 = blkiocg_reset_write,
>> +     },
>> +     {
>> +             .name = "io_wait_time",
>> +             .read_map = blkiocg_io_wait_time_read,
>> +             .write_u64 = blkiocg_reset_write,
>>       },
>
> blkiocg_reset_write() is invoked if a user does some write on any of the
> above files. This will reset all the stats. So if I do echo x >
> blkio.time, I will see all other files being reset? I think this is
> little counter intutive.
>
> Either we need to reset only those specific stats (the file being written
> to) or may be we can provide a separate file "blkio.reset_stats" to reset
> all the stats?

I added a note in the Documentation file that writing an int to any of
the stats should reset all. I don't get the point of introducing
another file for this and would want stats to be cleared all together
in order to have say io_service_time and io_serviced in sync, i.e.,
the io_service_time should always be the total service time for the
IOs accounted for in io_serviced.

> Secondly, instead of providing separate files for all the stats
> "io_service_bytes, io_serviced...." do you think it makes sense to put
> these in a single file "blkio.stat". Something like what memory controller
> does for providing stats in a single file. I think number of files per
> cgroup will be little less overwhelming that way.
>
> Thinking loud, Hm.., but these stats are per device (unlink memory cgroup)
> that too each stat has been broken down by type (READ, WRITE, SYNC..etc), so it
> might be too much of info in a single file. That way, keeping these in
> separate files makese sense. I guess, per stat file is ok, given the
> fact that stats are per device.

Yeah we'd rather keep them separate.
>
> Thanks
> Vivek
>
>>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>>         {
>>               .name = "dequeue",
>> -             .read_seq_string = blkiocg_dequeue_read,
>> +             .read_map = blkiocg_dequeue_read,
>>         },
>>  #endif
>>  };
>> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
>> index fe44517..5c5e529 100644
>> --- a/block/blk-cgroup.h
>> +++ b/block/blk-cgroup.h
>> @@ -23,6 +23,14 @@ extern struct cgroup_subsys blkio_subsys;
>>  #define blkio_subsys_id blkio_subsys.subsys_id
>>  #endif
>>
>> +enum io_type {
>> +     IO_READ = 0,
>> +     IO_WRITE,
>> +     IO_SYNC,
>> +     IO_ASYNC,
>> +     IO_TYPE_MAX
>> +};
>> +
>>  struct blkio_cgroup {
>>       struct cgroup_subsys_state css;
>>       unsigned int weight;
>> @@ -30,6 +38,23 @@ struct blkio_cgroup {
>>       struct hlist_head blkg_list;
>>  };
>>
>> +struct blkio_group_stats {
>> +     /* total disk time and nr sectors dispatched by this group */
>> +     uint64_t time;
>> +     uint64_t sectors;
>> +     /* Total disk time used by IOs in ns */
>> +     uint64_t io_service_time[IO_TYPE_MAX];
>> +     uint64_t io_service_bytes[IO_TYPE_MAX]; /* Total bytes transferred */
>> +     /* Total IOs serviced, post merge */
>> +     uint64_t io_serviced[IO_TYPE_MAX];
>> +     /* Total time spent waiting in scheduler queue in ns */
>> +     uint64_t io_wait_time[IO_TYPE_MAX];
>> +#ifdef CONFIG_DEBUG_BLK_CGROUP
>> +     /* How many times this group has been removed from service tree */
>> +     unsigned long dequeue;
>> +#endif
>> +};
>> +
>>  struct blkio_group {
>>       /* An rcu protected unique identifier for the group */
>>       void *key;
>> @@ -38,15 +63,13 @@ struct blkio_group {
>>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>>       /* Store cgroup path */
>>       char path[128];
>> -     /* How many times this group has been removed from service tree */
>> -     unsigned long dequeue;
>>  #endif
>>       /* The device MKDEV(major, minor), this group has been created for */
>>       dev_t   dev;
>>
>> -     /* total disk time and nr sectors dispatched by this group */
>> -     unsigned long time;
>> -     unsigned long sectors;
>> +     /* Need to serialize the stats in the case of reset/update */
>> +     spinlock_t stats_lock;
>> +     struct blkio_group_stats stats;
>>  };
>>
>>  typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
>> @@ -105,8 +128,8 @@ extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>>  extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
>>  extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
>>                                               void *key);
>> -void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
>> -                                             unsigned long time);
>> +void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>> +                                     unsigned long time);
>>  #else
>>  struct cgroup;
>>  static inline struct blkio_cgroup *
>> @@ -122,7 +145,7 @@ blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
>>
>>  static inline struct blkio_group *
>>  blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
>> -static inline void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
>> +static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>>                                               unsigned long time) {}
>>  #endif
>>  #endif /* _BLK_CGROUP_H */
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index c18e348..d91df9f 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -914,7 +914,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>>
>>       cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
>>                                       st->min_vdisktime);
>> -     blkiocg_update_blkio_group_stats(&cfqg->blkg, used_sl);
>> +     blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
>>  }
>>
>>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
>
