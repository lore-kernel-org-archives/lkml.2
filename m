Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab0DMR0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 13:26:54 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50519 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0DMR0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 13:26:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uEJvq4HoDX+jsnPW7XsmnTdEeGNEscefAZQ/WXoGbdWs/ij/11X24nxnCHfvg9IUi
	Hd3hj2cRYyr15cAamEGzA==
MIME-Version: 1.0
In-Reply-To: <20100412221158.GB3224@redhat.com>
References: <20100412184046.23784.27365.stgit@austin.mtv.corp.google.com> 
	<20100412221158.GB3224@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Tue, 13 Apr 2010 10:26:27 -0700
Message-ID: <w2naf41c7c41004131026s3b81d78cl6003df56c32da992@mail.gmail.com>
Subject: Re: [PATCH][v2] Changes to more io-controller stats patches to 
	address review comments.
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
       If this looks ok to you, can you please queue it up? Btw, after
Gui's patches there is 1 merge conflict in your for-2.6.35 branch when
applying this patch but it seems pretty straightforward to resolve. In
case you'd prefer a clean patch that takes care of the merge conflict
please let me know.

Thanks,
Divyesh

On Mon, Apr 12, 2010 at 3:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Apr 12, 2010 at 11:41:49AM -0700, Divyesh Shah wrote:
>> Changelog from v1:
>> o Call blkiocg_update_idle_time_stats() at cfq_rq_enqueued() instead of at
>>   dispatch time.
>>
>> Changelog from original patchset: (in response to Vivek Goyal's comments)
>> o group blkiocg_update_blkio_group_dequeue_stats() with other DEBUG functions
>> o rename blkiocg_update_set_active_queue_stats() to
>>   blkiocg_update_avg_queue_size_stats()
>> o s/request/io/ in blkiocg_update_request_add_stats() and
>>   blkiocg_update_request_remove_stats()
>> o Call cfq_del_timer() at request dispatch() instead of
>>   blkiocg_update_idle_time_stats()
>>
>> Signed-off-by: Divyesh Shah<dpshah@google.com>
>> ---
>
> Looks good to me.
>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>
> Thanks
> Vivek
>
>>
>>  block/blk-cgroup.c  |   28 +++++++++++++---------------
>>  block/blk-cgroup.h  |   12 ++++++------
>>  block/cfq-iosched.c |   20 +++++++++-----------
>>  3 files changed, 28 insertions(+), 32 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 1ecff7a..fd428c1 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -175,7 +175,7 @@ void blkiocg_update_idle_time_stats(struct blkio_group *blkg)
>>  }
>>  EXPORT_SYMBOL_GPL(blkiocg_update_idle_time_stats);
>>
>> -void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg)
>> +void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg)
>>  {
>>       unsigned long flags;
>>       struct blkio_group_stats *stats;
>> @@ -189,14 +189,21 @@ void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg)
>>       blkio_update_group_wait_time(stats);
>>       spin_unlock_irqrestore(&blkg->stats_lock, flags);
>>  }
>> -EXPORT_SYMBOL_GPL(blkiocg_update_set_active_queue_stats);
>> +EXPORT_SYMBOL_GPL(blkiocg_update_avg_queue_size_stats);
>> +
>> +void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>> +                     unsigned long dequeue)
>> +{
>> +     blkg->stats.dequeue += dequeue;
>> +}
>> +EXPORT_SYMBOL_GPL(blkiocg_update_dequeue_stats);
>>  #else
>>  static inline void blkio_set_start_group_wait_time(struct blkio_group *blkg,
>>                                       struct blkio_group *curr_blkg) {}
>>  static inline void blkio_end_empty_time(struct blkio_group_stats *stats) {}
>>  #endif
>>
>> -void blkiocg_update_request_add_stats(struct blkio_group *blkg,
>> +void blkiocg_update_io_add_stats(struct blkio_group *blkg,
>>                       struct blkio_group *curr_blkg, bool direction,
>>                       bool sync)
>>  {
>> @@ -209,9 +216,9 @@ void blkiocg_update_request_add_stats(struct blkio_group *blkg,
>>       blkio_set_start_group_wait_time(blkg, curr_blkg);
>>       spin_unlock_irqrestore(&blkg->stats_lock, flags);
>>  }
>> -EXPORT_SYMBOL_GPL(blkiocg_update_request_add_stats);
>> +EXPORT_SYMBOL_GPL(blkiocg_update_io_add_stats);
>>
>> -void blkiocg_update_request_remove_stats(struct blkio_group *blkg,
>> +void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
>>                                               bool direction, bool sync)
>>  {
>>       unsigned long flags;
>> @@ -221,7 +228,7 @@ void blkiocg_update_request_remove_stats(struct blkio_group *blkg,
>>                                       direction, sync);
>>       spin_unlock_irqrestore(&blkg->stats_lock, flags);
>>  }
>> -EXPORT_SYMBOL_GPL(blkiocg_update_request_remove_stats);
>> +EXPORT_SYMBOL_GPL(blkiocg_update_io_remove_stats);
>>
>>  void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
>>  {
>> @@ -602,15 +609,6 @@ SHOW_FUNCTION_PER_GROUP(empty_time, BLKIO_STAT_EMPTY_TIME, 0);
>>  #endif
>>  #undef SHOW_FUNCTION_PER_GROUP
>>
>> -#ifdef CONFIG_DEBUG_BLK_CGROUP
>> -void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>> -                     unsigned long dequeue)
>> -{
>> -     blkg->stats.dequeue += dequeue;
>> -}
>> -EXPORT_SYMBOL_GPL(blkiocg_update_dequeue_stats);
>> -#endif
>> -
>>  struct cftype blkio_files[] = {
>>       {
>>               .name = "weight",
>> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
>> index bfce085..18e031a 100644
>> --- a/block/blk-cgroup.h
>> +++ b/block/blk-cgroup.h
>> @@ -159,7 +159,7 @@ static inline char *blkg_path(struct blkio_group *blkg)
>>  {
>>       return blkg->path;
>>  }
>> -void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg);
>> +void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg);
>>  void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>>                               unsigned long dequeue);
>>  void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg);
>> @@ -188,7 +188,7 @@ BLKG_FLAG_FNS(empty)
>>  #undef BLKG_FLAG_FNS
>>  #else
>>  static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
>> -static inline void blkiocg_update_set_active_queue_stats(
>> +static inline void blkiocg_update_avg_queue_size_stats(
>>                                               struct blkio_group *blkg) {}
>>  static inline void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>>                                               unsigned long dequeue) {}
>> @@ -216,9 +216,9 @@ void blkiocg_update_completion_stats(struct blkio_group *blkg,
>>       uint64_t start_time, uint64_t io_start_time, bool direction, bool sync);
>>  void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
>>                                       bool sync);
>> -void blkiocg_update_request_add_stats(struct blkio_group *blkg,
>> +void blkiocg_update_io_add_stats(struct blkio_group *blkg,
>>               struct blkio_group *curr_blkg, bool direction, bool sync);
>> -void blkiocg_update_request_remove_stats(struct blkio_group *blkg,
>> +void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
>>                                       bool direction, bool sync);
>>  #else
>>  struct cgroup;
>> @@ -243,9 +243,9 @@ static inline void blkiocg_update_completion_stats(struct blkio_group *blkg,
>>               bool sync) {}
>>  static inline void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
>>                                               bool direction, bool sync) {}
>> -static inline void blkiocg_update_request_add_stats(struct blkio_group *blkg,
>> +static inline void blkiocg_update_io_add_stats(struct blkio_group *blkg,
>>               struct blkio_group *curr_blkg, bool direction, bool sync) {}
>> -static inline void blkiocg_update_request_remove_stats(struct blkio_group *blkg,
>> +static inline void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
>>                                               bool direction, bool sync) {}
>>  #endif
>>  #endif /* _BLK_CGROUP_H */
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index b6e095c..cda6b29 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1381,10 +1381,10 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
>>  {
>>       elv_rb_del(&cfqq->sort_list, rq);
>>       cfqq->queued[rq_is_sync(rq)]--;
>> -     blkiocg_update_request_remove_stats(&cfqq->cfqg->blkg, rq_data_dir(rq),
>> +     blkiocg_update_io_remove_stats(&cfqq->cfqg->blkg, rq_data_dir(rq),
>>                                               rq_is_sync(rq));
>>       cfq_add_rq_rb(rq);
>> -     blkiocg_update_request_add_stats(
>> +     blkiocg_update_io_add_stats(
>>                       &cfqq->cfqg->blkg, &cfqq->cfqd->serving_group->blkg,
>>                       rq_data_dir(rq), rq_is_sync(rq));
>>  }
>> @@ -1442,7 +1442,7 @@ static void cfq_remove_request(struct request *rq)
>>       cfq_del_rq_rb(rq);
>>
>>       cfqq->cfqd->rq_queued--;
>> -     blkiocg_update_request_remove_stats(&cfqq->cfqg->blkg, rq_data_dir(rq),
>> +     blkiocg_update_io_remove_stats(&cfqq->cfqg->blkg, rq_data_dir(rq),
>>                                               rq_is_sync(rq));
>>       if (rq_is_meta(rq)) {
>>               WARN_ON(!cfqq->meta_pending);
>> @@ -1541,7 +1541,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
>>       if (cfqq) {
>>               cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
>>                               cfqd->serving_prio, cfqd->serving_type);
>> -             blkiocg_update_set_active_queue_stats(&cfqq->cfqg->blkg);
>> +             blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
>>               cfqq->slice_start = 0;
>>               cfqq->dispatch_start = jiffies;
>>               cfqq->allocated_slice = 0;
>> @@ -2395,11 +2395,6 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
>>       }
>>
>>       cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
>> -     /*
>> -      * This is needed since we don't exactly match the mod_timer() and
>> -      * del_timer() calls in CFQ.
>> -      */
>> -     blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
>>       return 1;
>>  }
>>
>> @@ -3208,8 +3203,11 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>                               cfq_del_timer(cfqd, cfqq);
>>                               cfq_clear_cfqq_wait_request(cfqq);
>>                               __blk_run_queue(cfqd->queue);
>> -                     } else
>> +                     } else {
>> +                             blkiocg_update_idle_time_stats(
>> +                                             &cfqq->cfqg->blkg);
>>                               cfq_mark_cfqq_must_dispatch(cfqq);
>> +                     }
>>               }
>>       } else if (cfq_should_preempt(cfqd, cfqq, rq)) {
>>               /*
>> @@ -3235,7 +3233,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
>>       list_add_tail(&rq->queuelist, &cfqq->fifo);
>>       cfq_add_rq_rb(rq);
>>
>> -     blkiocg_update_request_add_stats(&cfqq->cfqg->blkg,
>> +     blkiocg_update_io_add_stats(&cfqq->cfqg->blkg,
>>                       &cfqd->serving_group->blkg, rq_data_dir(rq),
>>                       rq_is_sync(rq));
>>       cfq_rq_enqueued(cfqd, cfqq, rq);
>
