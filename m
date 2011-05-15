Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1EOT4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 15:56:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12865 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab1EOT4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 15:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=swp1K7hMdWKq+VI5zzVJdEY/3rQvzt8GQXtl2kYgiptSi62ebwG63sF0DQefVwSGkZ
         szJEnmjtNtHqFT5eBdyQ==
MIME-Version: 1.0
In-Reply-To: <20110513185612.84b466ec.kamezawa.hiroyu@jp.fujitsu.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
 <1305276473-14780-11-git-send-email-gthelen@google.com> <20110513185612.84b466ec.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Sun, 15 May 2011 12:56:00 -0700
Message-ID: <BANLkTin6_CiP-Q8MyN=PKhpUhGhdmUQyEA@mail.gmail.com>
Subject: Re: [RFC][PATCH v7 10/14] memcg: dirty page accounting support routines
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 2:56 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 13 May 2011 01:47:49 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> Added memcg dirty page accounting support routines.  These routines are
>> used by later changes to provide memcg aware writeback and dirty page
>> limiting.  A mem_cgroup_dirty_info() tracepoint is is also included to
>> allow for easier understanding of memcg writeback operation.
>>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> with small nit..(see below)
>
>
>> ---
>>  include/linux/memcontrol.h        |    9 +++
>>  include/trace/events/memcontrol.h |   34 +++++++++
>>  mm/memcontrol.c                   |  145 +++++++++++++++++++++++++++++++++++++
>>  3 files changed, 188 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index f1261e5..f06c2de 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -36,6 +36,15 @@ enum mem_cgroup_page_stat_item {
>>       MEMCG_NR_FILE_DIRTY, /* # of dirty pages in page cache */
>>       MEMCG_NR_FILE_WRITEBACK, /* # of pages under writeback */
>>       MEMCG_NR_FILE_UNSTABLE_NFS, /* # of NFS unstable pages */
>> +     MEMCG_NR_DIRTYABLE_PAGES, /* # of pages that could be dirty */
>> +};
>> +
>> +struct dirty_info {
>> +     unsigned long dirty_thresh;
>> +     unsigned long background_thresh;
>> +     unsigned long nr_file_dirty;
>> +     unsigned long nr_writeback;
>> +     unsigned long nr_unstable_nfs;
>>  };
>>
>>  extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>> diff --git a/include/trace/events/memcontrol.h b/include/trace/events/memcontrol.h
>> index 781ef9fc..abf1306 100644
>> --- a/include/trace/events/memcontrol.h
>> +++ b/include/trace/events/memcontrol.h
>> @@ -26,6 +26,40 @@ TRACE_EVENT(mem_cgroup_mark_inode_dirty,
>>       TP_printk("ino=%ld css_id=%d", __entry->ino, __entry->css_id)
>>  )
>>
>> +TRACE_EVENT(mem_cgroup_dirty_info,
>> +     TP_PROTO(unsigned short css_id,
>> +              struct dirty_info *dirty_info),
>> +
>> +     TP_ARGS(css_id, dirty_info),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned short, css_id)
>> +             __field(unsigned long, dirty_thresh)
>> +             __field(unsigned long, background_thresh)
>> +             __field(unsigned long, nr_file_dirty)
>> +             __field(unsigned long, nr_writeback)
>> +             __field(unsigned long, nr_unstable_nfs)
>> +             ),
>> +
>> +     TP_fast_assign(
>> +             __entry->css_id = css_id;
>> +             __entry->dirty_thresh = dirty_info->dirty_thresh;
>> +             __entry->background_thresh = dirty_info->background_thresh;
>> +             __entry->nr_file_dirty = dirty_info->nr_file_dirty;
>> +             __entry->nr_writeback = dirty_info->nr_writeback;
>> +             __entry->nr_unstable_nfs = dirty_info->nr_unstable_nfs;
>> +             ),
>> +
>> +     TP_printk("css_id=%d thresh=%ld bg_thresh=%ld dirty=%ld wb=%ld "
>> +               "unstable_nfs=%ld",
>> +               __entry->css_id,
>> +               __entry->dirty_thresh,
>> +               __entry->background_thresh,
>> +               __entry->nr_file_dirty,
>> +               __entry->nr_writeback,
>> +               __entry->nr_unstable_nfs)
>> +)
>> +
>>  #endif /* _TRACE_MEMCONTROL_H */
>>
>>  /* This part must be outside protection */
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 248396c..75ef32c 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1328,6 +1328,11 @@ static unsigned int get_swappiness(struct mem_cgroup *memcg)
>>       return memcg->swappiness;
>>  }
>>
>> +static unsigned long dirty_info_reclaimable(struct dirty_info *info)
>> +{
>> +     return info->nr_file_dirty + info->nr_unstable_nfs;
>> +}
>> +
>>  /*
>>   * Return true if the current memory cgroup has local dirty memory settings.
>>   * There is an allowed race between the current task migrating in-to/out-of the
>> @@ -1358,6 +1363,146 @@ static void mem_cgroup_dirty_param(struct vm_dirty_param *param,
>>       }
>>  }
>>
>> +static inline bool mem_cgroup_can_swap(struct mem_cgroup *mem)
>> +{
>> +     if (!do_swap_account)
>> +             return nr_swap_pages > 0;
>> +     return !mem->memsw_is_minimum &&
>> +             (res_counter_read_u64(&mem->memsw, RES_LIMIT) > 0);
>> +}
>> +
>> +static s64 mem_cgroup_local_page_stat(struct mem_cgroup *mem,
>> +                                   enum mem_cgroup_page_stat_item item)
>> +{
>> +     s64 ret;
>> +
>> +     switch (item) {
>> +     case MEMCG_NR_FILE_DIRTY:
>> +             ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_FILE_DIRTY);
>> +             break;
>> +     case MEMCG_NR_FILE_WRITEBACK:
>> +             ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_FILE_WRITEBACK);
>> +             break;
>> +     case MEMCG_NR_FILE_UNSTABLE_NFS:
>> +             ret = mem_cgroup_read_stat(mem,
>> +                                        MEM_CGROUP_STAT_FILE_UNSTABLE_NFS);
>> +             break;
>> +     case MEMCG_NR_DIRTYABLE_PAGES:
>> +             ret = mem_cgroup_read_stat(mem, LRU_ACTIVE_FILE) +
>> +                     mem_cgroup_read_stat(mem, LRU_INACTIVE_FILE);
>> +             if (mem_cgroup_can_swap(mem))
>> +                     ret += mem_cgroup_read_stat(mem, LRU_ACTIVE_ANON) +
>> +                             mem_cgroup_read_stat(mem, LRU_INACTIVE_ANON);
>> +             break;
>> +     default:
>> +             BUG();
>> +             break;
>> +     }
>> +     return ret;
>> +}
>> +
>> +/*
>> + * Return the number of additional pages that the @mem cgroup could allocate.
>> + * If use_hierarchy is set, then this involves checking parent mem cgroups to
>> + * find the cgroup with the smallest free space.
>> + */
>> +static unsigned long
>> +mem_cgroup_hierarchical_free_pages(struct mem_cgroup *mem)
>> +{
>> +     u64 free;
>> +     unsigned long min_free;
>> +
>> +     min_free = global_page_state(NR_FREE_PAGES);
>> +
>> +     while (mem) {
>> +             free = (res_counter_read_u64(&mem->res, RES_LIMIT) -
>> +                     res_counter_read_u64(&mem->res, RES_USAGE)) >>
>> +                     PAGE_SHIFT;
>> +             min_free = min((u64)min_free, free);
>> +             mem = parent_mem_cgroup(mem);
>> +     }
>> +
>> +     return min_free;
>> +}
>> +
>> +/*
>> + * mem_cgroup_page_stat() - get memory cgroup file cache statistics
>> + * @mem:       memory cgroup to query
>> + * @item:      memory statistic item exported to the kernel
>> + *
>> + * Return the accounted statistic value.
>> + */
>> +static unsigned long mem_cgroup_page_stat(struct mem_cgroup *mem,
>> +                                       enum mem_cgroup_page_stat_item item)
>
> How about mem_cgroup_file_cache_stat() ?

The suggested rename is possible.  But for consistency I assume we
would also want to rename:
* mem_cgroup_local_page_stat()
* enum mem_cgroup_page_stat_item
* mem_cgroup_update_page_stat()
* mem_cgroup_move_account_page_stat()

I have a slight preference for leaving it as is,
mem_cgroup_page_stat(), to allow for future coverage of pages other
that just file cache pages.  But I do not feel very strongly.

>> +{
>> +     struct mem_cgroup *iter;
>> +     s64 value;
>> +
>> +     /*
>> +      * If we're looking for dirtyable pages we need to evaluate free pages
>> +      * depending on the limit and usage of the parents first of all.
>> +      */
>> +     if (item == MEMCG_NR_DIRTYABLE_PAGES)
>> +             value = mem_cgroup_hierarchical_free_pages(mem);
>> +     else
>> +             value = 0;
>> +
>> +     /*
>> +      * Recursively evaluate page statistics against all cgroup under
>> +      * hierarchy tree
>> +      */
>> +     for_each_mem_cgroup_tree(iter, mem)
>> +             value += mem_cgroup_local_page_stat(iter, item);
>> +
>> +     /*
>> +      * Summing of unlocked per-cpu counters is racy and may yield a slightly
>> +      * negative value.  Zero is the only sensible value in such cases.
>> +      */
>> +     if (unlikely(value < 0))
>> +             value = 0;
>> +
>> +     return value;
>> +}
>
> seems very nice handling of hierarchy :)
