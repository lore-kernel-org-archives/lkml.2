Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab0JTEeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:34:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27810 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0JTEeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:34:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:message-id:user-agent:
	mime-version:content-type;
	b=DGqsNwTVQ09zAInyeLf18150M7+KotcR8ElusD2epYyFJUkS3mZF1mw7K/nVsGnf9
	r7XbzjKma+Ai5gyxGC3ng==
From: Greg Thelen <gthelen@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 11/11] memcg: check memcg dirty limits in page writeback
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-12-git-send-email-gthelen@google.com>
	<20101019100015.7a0d4695.kamezawa.hiroyu@jp.fujitsu.com>
	<20101020131857.cd0ecd38.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 19 Oct 2010 21:33:21 -0700
Message-ID: <xr93hbghzdny.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> On Tue, 19 Oct 2010 10:00:15 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> On Mon, 18 Oct 2010 17:39:44 -0700
>> Greg Thelen <gthelen@google.com> wrote:
>> 
>> > If the current process is in a non-root memcg, then
>> > global_dirty_limits() will consider the memcg dirty limit.
>> > This allows different cgroups to have distinct dirty limits
>> > which trigger direct and background writeback at different
>> > levels.
>> > 
>> > Signed-off-by: Andrea Righi <arighi@develer.com>
>> > Signed-off-by: Greg Thelen <gthelen@google.com>
>> 
>> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> 
> Why FREEPAGES in memcg is not counted as dirtyable ?
>
> Thanks,
> -Kame

I think that FREEPAGES is considered dirtyable.  Below I include the
latest version of the code, which includes an improved version of
memcg_hierarchical_free_pages().

Notice that mem_cgroup_page_stat(MEMCG_NR_DIRTYABLE_PAGES) returns the
sum of:
1. compute free pages using memcg_hierarchical_free_pages()
2. mem_cgroup_read_stat(mem, LRU_ACTIVE_FILE) +
	mem_cgroup_read_stat(mem, LRU_INACTIVE_FILE)
3. if (mem_cgroup_can_swap(mem))
   ret += mem_cgroup_read_stat(mem, LRU_ACTIVE_ANON) +
	mem_cgroup_read_stat(mem, LRU_INACTIVE_ANON)

This algorithm is similar to how global (non-memcg) limits are computed
in global_dirtyable_memory().

/*
 * Return the number of the number of pages that the @mem cgroup could allocate.
 * If use_hierarchy is set, then this involves parent mem cgroups to find the
 * cgroup with the smallest free space.
 */
static unsigned long long
memcg_hierarchical_free_pages(struct mem_cgroup *mem)
{
	unsigned long free, min_free;

	min_free = global_page_state(NR_FREE_PAGES) << PAGE_SHIFT;

 	while (mem) {
 		free = res_counter_read_u64(&mem->res, RES_LIMIT) -
 			res_counter_read_u64(&mem->res, RES_USAGE);
 		min_free = min(min_free, free);
 		mem = parent_mem_cgroup(mem);
 	}

 	/* Translate free memory in pages */
 	return min_free >> PAGE_SHIFT;
}

/*
 * mem_cgroup_page_stat() - get memory cgroup file cache statistics
 * @item:      memory statistic item exported to the kernel
 *
 * Return the accounted statistic value.
 */
s64 mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
{
	struct mem_cgroup *mem;
	struct mem_cgroup *iter;
	s64 value;

	get_online_cpus();
	rcu_read_lock();
	mem = mem_cgroup_from_task(current);
	if (mem && !mem_cgroup_is_root(mem)) {
		/*
		 * If we're looking for dirtyable pages we need to evaluate
		 * free pages depending on the limit and usage of the parents
		 * first of all.
		 */
		if (item == MEMCG_NR_DIRTYABLE_PAGES)
			value = memcg_hierarchical_free_pages(mem);
		else
			value = 0;
		/*
		 * Recursively evaluate page statistics against all cgroup
		 * under hierarchy tree
		 */
		for_each_mem_cgroup_tree(iter, mem)
			value += mem_cgroup_local_page_stat(iter, item);
	} else
		value = -EINVAL;
	rcu_read_unlock();
	put_online_cpus();

	return value;
}
