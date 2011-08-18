Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1HRHFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:05:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1HRHFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:05:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=FpFNtr73q2tslcqAVkhfJz9ktS8aCRj+86O5dVp+FeTL0aLPHHLwgj2nOdO++IsZ4
	cjNARrbIsLgUfqGBVqaUQ==
From: Greg Thelen <gthelen@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v9 08/13] memcg: dirty page accounting support routines
References: <1313597705-6093-1-git-send-email-gthelen@google.com>
	<1313597705-6093-9-git-send-email-gthelen@google.com>
	<20110818100535.ecdb4a12.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 18 Aug 2011 00:04:21 -0700
In-Reply-To: <20110818100535.ecdb4a12.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Thu, 18 Aug 2011 10:05:35 +0900")
Message-ID: <xr93zkj7td3e.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> On Wed, 17 Aug 2011 09:15:00 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> Added memcg dirty page accounting support routines.  These routines are
>> used by later changes to provide memcg aware writeback and dirty page
>> limiting.  A mem_cgroup_dirty_info() tracepoint is is also included to
>> allow for easier understanding of memcg writeback operation.
>> 
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>
> I have small comments.
>
>> ---
>> Changelog since v8:
>> - Use 'memcg' rather than 'mem' for local variables and parameters.
>>   This is consistent with other memory controller code.
>> 
>>  include/linux/memcontrol.h        |    9 ++
>>  include/trace/events/memcontrol.h |   34 +++++++++
>>  mm/memcontrol.c                   |  147 +++++++++++++++++++++++++++++++++++++
>>  3 files changed, 190 insertions(+), 0 deletions(-)
>> 
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 630d3fa..9cc8841 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -36,6 +36,15 @@ enum mem_cgroup_page_stat_item {
>>  	MEMCG_NR_FILE_DIRTY, /* # of dirty pages in page cache */
>>  	MEMCG_NR_FILE_WRITEBACK, /* # of pages under writeback */
>>  	MEMCG_NR_FILE_UNSTABLE_NFS, /* # of NFS unstable pages */
>> +	MEMCG_NR_DIRTYABLE_PAGES, /* # of pages that could be dirty */
>> +};
>> +
>> +struct dirty_info {
>> +	unsigned long dirty_thresh;
>> +	unsigned long background_thresh;
>> +	unsigned long nr_file_dirty;
>> +	unsigned long nr_writeback;
>> +	unsigned long nr_unstable_nfs;
>>  };
>>  
>>  extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>> diff --git a/include/trace/events/memcontrol.h b/include/trace/events/memcontrol.h
>> index 781ef9fc..abf1306 100644
>> --- a/include/trace/events/memcontrol.h
>> +++ b/include/trace/events/memcontrol.h
>> @@ -26,6 +26,40 @@ TRACE_EVENT(mem_cgroup_mark_inode_dirty,
>>  	TP_printk("ino=%ld css_id=%d", __entry->ino, __entry->css_id)
>>  )
>>  
>> +TRACE_EVENT(mem_cgroup_dirty_info,
>> +	TP_PROTO(unsigned short css_id,
>> +		 struct dirty_info *dirty_info),
>> +
>> +	TP_ARGS(css_id, dirty_info),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(unsigned short, css_id)
>> +		__field(unsigned long, dirty_thresh)
>> +		__field(unsigned long, background_thresh)
>> +		__field(unsigned long, nr_file_dirty)
>> +		__field(unsigned long, nr_writeback)
>> +		__field(unsigned long, nr_unstable_nfs)
>> +		),
>> +
>> +	TP_fast_assign(
>> +		__entry->css_id = css_id;
>> +		__entry->dirty_thresh = dirty_info->dirty_thresh;
>> +		__entry->background_thresh = dirty_info->background_thresh;
>> +		__entry->nr_file_dirty = dirty_info->nr_file_dirty;
>> +		__entry->nr_writeback = dirty_info->nr_writeback;
>> +		__entry->nr_unstable_nfs = dirty_info->nr_unstable_nfs;
>> +		),
>> +
>> +	TP_printk("css_id=%d thresh=%ld bg_thresh=%ld dirty=%ld wb=%ld "
>> +		  "unstable_nfs=%ld",
>> +		  __entry->css_id,
>> +		  __entry->dirty_thresh,
>> +		  __entry->background_thresh,
>> +		  __entry->nr_file_dirty,
>> +		  __entry->nr_writeback,
>> +		  __entry->nr_unstable_nfs)
>> +)
>> +
>>  #endif /* _TRACE_MEMCONTROL_H */
>>  
>>  /* This part must be outside protection */
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 4e01699..d54adf4 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1366,6 +1366,11 @@ int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>>  	return memcg->swappiness;
>>  }
>>  
>> +static unsigned long dirty_info_reclaimable(struct dirty_info *info)
>> +{
>> +	return info->nr_file_dirty + info->nr_unstable_nfs;
>> +}
>> +
>>  /*
>>   * Return true if the current memory cgroup has local dirty memory settings.
>>   * There is an allowed race between the current task migrating in-to/out-of the
>> @@ -1396,6 +1401,148 @@ static void mem_cgroup_dirty_param(struct vm_dirty_param *param,
>>  	}
>>  }
>>  
>> +static inline bool mem_cgroup_can_swap(struct mem_cgroup *memcg)
>> +{
>> +	if (!do_swap_account)
>> +		return nr_swap_pages > 0;
>> +	return !memcg->memsw_is_minimum &&
>> +		(res_counter_read_u64(&memcg->memsw, RES_LIMIT) > 0);
>> +}
>
> I think
>
> 	if (nr_swap_pages == 0)
> 		return false;
> 	if (!do_swap_account)
> 		return true;
> 	if (memcg->memsw_is_mininum)
> 		return false;
>         if (res_counter_margin(&memcg->memsw) == 0)
> 		return false;
>
> is a correct check.

Ok.  I'll update to use your logic.

>> +
>> +static s64 mem_cgroup_local_page_stat(struct mem_cgroup *memcg,
>> +				      enum mem_cgroup_page_stat_item item)
>> +{
>> +	s64 ret;
>> +
>> +	switch (item) {
>> +	case MEMCG_NR_FILE_DIRTY:
>> +		ret = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_FILE_DIRTY);
>> +		break;
>> +	case MEMCG_NR_FILE_WRITEBACK:
>> +		ret = mem_cgroup_read_stat(memcg,
>> +					   MEM_CGROUP_STAT_FILE_WRITEBACK);
>> +		break;
>> +	case MEMCG_NR_FILE_UNSTABLE_NFS:
>> +		ret = mem_cgroup_read_stat(memcg,
>> +					   MEM_CGROUP_STAT_FILE_UNSTABLE_NFS);
>> +		break;
>> +	case MEMCG_NR_DIRTYABLE_PAGES:
>> +		ret = mem_cgroup_read_stat(memcg, LRU_ACTIVE_FILE) +
>> +			mem_cgroup_read_stat(memcg, LRU_INACTIVE_FILE);
>> +		if (mem_cgroup_can_swap(memcg))
>> +			ret += mem_cgroup_read_stat(memcg, LRU_ACTIVE_ANON) +
>> +				mem_cgroup_read_stat(memcg, LRU_INACTIVE_ANON);
>> +		break;
>> +	default:
>> +		BUG();
>> +		break;
>> +	}
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Return the number of additional pages that the @memcg cgroup could allocate.
>> + * If use_hierarchy is set, then this involves checking parent mem cgroups to
>> + * find the cgroup with the smallest free space.
>> + */
>> +static unsigned long
>> +mem_cgroup_hierarchical_free_pages(struct mem_cgroup *memcg)
>> +{
>> +	u64 free;
>> +	unsigned long min_free;
>> +
>> +	min_free = global_page_state(NR_FREE_PAGES);
>> +
>> +	while (memcg) {
>> +		free = (res_counter_read_u64(&memcg->res, RES_LIMIT) -
>> +			res_counter_read_u64(&memcg->res, RES_USAGE)) >>
>> +			PAGE_SHIFT;
>
> How about
> 		free = mem_cgroup_margin(&mem->res);
> ?
>
> Thanks,
> -Kame

Sounds good.  I'll update to:

        while (memcg) {
                free = res_counter_margin(&memcg->res) >> PAGE_SHIFT;
                min_free = min_t(u64, min_free, free);
                memcg = parent_mem_cgroup(memcg);
        }
