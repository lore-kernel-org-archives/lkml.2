Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab0KLUlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:41:14 -0500
Received: from smtp-out.google.com ([74.125.121.35]:51411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab0KLUlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:41:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:message-id:user-agent:
	mime-version:content-type;
	b=ybx7j9w6/bvvH4kj9sNuszAG5XkosGsm4HqKVei86HlBVJFhPs4XY1lqjTc/7LLW1
	DoRuPkRitaPRTDP/r2efg==
From: Greg Thelen <gthelen@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] memcg: simplify mem_cgroup_page_stat()
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-5-git-send-email-gthelen@google.com>
	<20101112081957.GF9131@cmpxchg.org>
Date: Fri, 12 Nov 2010 12:40:22 -0800
Message-ID: <xr93pquaxoll.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> writes:

> On Tue, Nov 09, 2010 at 01:24:29AM -0800, Greg Thelen wrote:
>> The cgroup given to mem_cgroup_page_stat() is no allowed to be
>> NULL or the root cgroup.  So there is no need to complicate the code
>> handling those cases.
>> 
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> ---
>>  mm/memcontrol.c |   48 ++++++++++++++++++++++--------------------------
>>  1 files changed, 22 insertions(+), 26 deletions(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index eb621ee..f8df350 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1364,12 +1364,10 @@ memcg_hierarchical_free_pages(struct mem_cgroup *mem)
>>  
>>  /*
>>   * mem_cgroup_page_stat() - get memory cgroup file cache statistics
>> - * @mem:	optional memory cgroup to query.  If NULL, use current task's
>> - *		cgroup.
>> + * @mem:	memory cgroup to query
>>   * @item:	memory statistic item exported to the kernel
>>   *
>> - * Return the accounted statistic value or negative value if current task is
>> - * root cgroup.
>> + * Return the accounted statistic value.
>>   */
>>  long mem_cgroup_page_stat(struct mem_cgroup *mem,
>>  			  enum mem_cgroup_nr_pages_item item)
>> @@ -1377,29 +1375,27 @@ long mem_cgroup_page_stat(struct mem_cgroup *mem,
>>  	struct mem_cgroup *iter;
>>  	long value;
>>  
>> +	VM_BUG_ON(!mem);
>> +	VM_BUG_ON(mem_cgroup_is_root(mem));
>> +
>>  	get_online_cpus();
>> -	rcu_read_lock();
>> -	if (!mem)
>> -		mem = mem_cgroup_from_task(current);
>> -	if (__mem_cgroup_has_dirty_limit(mem)) {
>
> What about mem->use_hierarchy that is checked in
> __mem_cgroup_has_dirty_limit()?  Is it no longer needed?

It is no longer needed because the callers of mem_cgroup_page_stat()
call __mem_cgroup_has_dirty_limit().  In the current implementation, if
use_hierarchy=1 then the cgroup does not have dirty limits, so calls
into mem_cgroup_page_stat() are avoided.  Specifically the callers of
mem_cgroup_page_stat() are:

1. mem_cgroup_dirty_info() which calls __mem_cgroup_has_dirty_limit()
   and returns false if use_hierarchy=1.

2. throttle_vm_writeout() which calls mem_dirty_info() ->
   mem_cgroup_dirty_info() -> __mem_cgroup_has_dirty_limit() will fall
   back to global limits if use_hierarchy=1.
