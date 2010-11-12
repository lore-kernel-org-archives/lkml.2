Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0KLUkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:40:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:19756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab0KLUkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:40:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:message-id:user-agent:
	mime-version:content-type;
	b=AszSdp6EYkQL0kaq++/BQMG2osA9SWODtZbfmDkL0IhV6PJgBsV6MFfGupfObROMT
	2GacVnN0sHyAZRok5Q74g==
From: Greg Thelen <gthelen@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] memcg: make throttle_vm_writeout() memcg aware
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-4-git-send-email-gthelen@google.com>
	<20101112081754.GE9131@cmpxchg.org>
Date: Fri, 12 Nov 2010 12:39:35 -0800
Message-ID: <xr93wroixomw.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> writes:

> On Tue, Nov 09, 2010 at 01:24:28AM -0800, Greg Thelen wrote:
>> If called with a mem_cgroup, then throttle_vm_writeout() should
>> query the given cgroup for its dirty memory usage limits.
>> 
>> dirty_writeback_pages() is no longer used, so delete it.
>> 
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> ---
>>  include/linux/writeback.h |    2 +-
>>  mm/page-writeback.c       |   31 ++++++++++++++++---------------
>>  mm/vmscan.c               |    2 +-
>>  3 files changed, 18 insertions(+), 17 deletions(-)
>
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index d717fa9..bf85062 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -131,18 +131,6 @@ EXPORT_SYMBOL(laptop_mode);
>>  static struct prop_descriptor vm_completions;
>>  static struct prop_descriptor vm_dirties;
>>  
>> -static unsigned long dirty_writeback_pages(void)
>> -{
>> -	unsigned long ret;
>> -
>> -	ret = mem_cgroup_page_stat(NULL, MEMCG_NR_DIRTY_WRITEBACK_PAGES);
>> -	if ((long)ret < 0)
>> -		ret = global_page_state(NR_UNSTABLE_NFS) +
>> -			global_page_state(NR_WRITEBACK);
>
> There are two bugfixes in this patch.  One is getting rid of this
> fallback to global numbers that are compared to memcg limits.  The
> other one is that reclaim will now throttle writeout based on the
> cgroup it runs on behalf of, instead of that of the current task.
>
> Both are undocumented and should arguably not even be in the same
> patch...?

I will better document these changes in the commit message and I will
split the change into two patches for clarity.

- sub-patch 1 will change throttle_vm_writeout() to only consider global
  usage and limits.  This would remove memcg consideration from
  throttle_vm_writeout() and thus ensure that only global limits are
  compared to global usage.

- sub-patch 2 will introduce memcg consideration consistently into
  throttle_vm_writeout().  This will allow throttle_vm_writeout() to
  consider memcg usage and limits, but they will uniformly applied.
  memcg usage will not be compared to global limits.

>> @@ -703,12 +691,25 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
>>  }
>>  EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
>>  
>> -void throttle_vm_writeout(gfp_t gfp_mask)
>> +/*
>> + * Throttle the current task if it is near dirty memory usage limits.
>> + * If @mem_cgroup is NULL or the root_cgroup, then use global dirty memory
>> + * information; otherwise use the per-memcg dirty limits.
>> + */
>> +void throttle_vm_writeout(gfp_t gfp_mask, struct mem_cgroup *mem_cgroup)
>>  {
>>  	struct dirty_info dirty_info;
>> +	unsigned long nr_writeback;
>>  
>>          for ( ; ; ) {
>> -		global_dirty_info(&dirty_info);
>> +		if (!mem_cgroup || !memcg_dirty_info(mem_cgroup, &dirty_info)) {
>> +			global_dirty_info(&dirty_info);
>> +			nr_writeback = global_page_state(NR_UNSTABLE_NFS) +
>> +				global_page_state(NR_WRITEBACK);
>> +		} else {
>> +			nr_writeback = mem_cgroup_page_stat(
>> +				mem_cgroup, MEMCG_NR_DIRTY_WRITEBACK_PAGES);
>> +		}
>
> Odd branch ordering, but I may be OCDing again.
>
> 	if (mem_cgroup && memcg_dirty_info())
> 		do_mem_cgroup_stuff()
> 	else
> 		do_global_stuff()
>
> would be more natural, IMO.

I agree.  I will resubmit this series with your improved branch ordering.
