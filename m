Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab0JFAvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 20:51:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5186 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119Ab0JFAvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 20:51:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:in-reply-to:message-id:
	user-agent:mime-version:content-type:content-transfer-encoding;
	b=Z6hlCiaGJs8m0loKWGkOk6sExGdTByPmuGa0bNWGMdoBex/tCyL+lrur3O6q1uZZv
	4ZQ9mU99d4jyPvBpdwnjA==
From: Greg Thelen <gthelen@google.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 03/10] memcg: create extensible page stat update routines
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
	<1286175485-30643-4-git-send-email-gthelen@google.com>
	<20101005154250.GA9515@barrios-desktop>
	<xr93aamstnpy.fsf@ninji.mtv.corp.google.com>
	<AANLkTi=LsoJ+_rGGjXgPTESW4Hpi03XzUL_K2ULPLGxf@mail.gmail.com>
Date: Tue, 05 Oct 2010 17:48:09 -0700
In-Reply-To: <AANLkTi=LsoJ+_rGGjXgPTESW4Hpi03XzUL_K2ULPLGxf@mail.gmail.com>
	(Minchan Kim's message of "Wed, 6 Oct 2010 08:57:15 +0900")
Message-ID: <xr93y6acjgdy.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim <minchan.kim@gmail.com> writes:

> On Wed, Oct 6, 2010 at 4:59 AM, Greg Thelen <gthelen@google.com> wrote:
>> Minchan Kim <minchan.kim@gmail.com> writes:
>>
>>> On Sun, Oct 03, 2010 at 11:57:58PM -0700, Greg Thelen wrote:
>>>> Replace usage of the mem_cgroup_update_file_mapped() memcg
>>>> statistic update routine with two new routines:
>>>> * mem_cgroup_inc_page_stat()
>>>> * mem_cgroup_dec_page_stat()
>>>>
>>>> As before, only the file_mapped statistic is managed.  However,
>>>> these more general interfaces allow for new statistics to be
>>>> more easily added.  New statistics are added with memcg dirty
>>>> page accounting.
>>>>
>>>> Signed-off-by: Greg Thelen <gthelen@google.com>
>>>> Signed-off-by: Andrea Righi <arighi@develer.com>
>>>> ---
>>>>  include/linux/memcontrol.h |   31 ++++++++++++++++++++++++++++---
>>>>  mm/memcontrol.c            |   17 ++++++++---------
>>>>  mm/rmap.c                  |    4 ++--
>>>>  3 files changed, 38 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>>> index 159a076..7c7bec4 100644
>>>> --- a/include/linux/memcontrol.h
>>>> +++ b/include/linux/memcontrol.h
>>>> @@ -25,6 +25,11 @@ struct page_cgroup;
>>>>  struct page;
>>>>  struct mm_struct;
>>>>
>>>> +/* Stats that can be updated by kernel. */
>>>> +enum mem_cgroup_write_page_stat_item {
>>>> +    MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
>>>> +};
>>>> +
>>>
>>> mem_cgrou_"write"_page_stat_item?
>>> Does "write" make sense to abstract page_state generally?
>>
>> First I will summarize the portion of the design relevant to this
>> comment:
>>
>> This patch series introduces two sets of memcg statistics.
>> a) the writable set of statistics the kernel updates when pages change
>>   state (example: when a page becomes dirty) using:
>>     mem_cgroup_inc_page_stat(struct page *page,
>>                                enum mem_cgroup_write_page_stat_item idx)
>>     mem_cgroup_dec_page_stat(struct page *page,
>>                                enum mem_cgroup_write_page_stat_item idx)
>>
>> b) the read-only set of statistics the kernel queries to measure the
>>   amount of dirty memory used by the current cgroup using:
>>     s64 mem_cgroup_page_stat(enum mem_cgroup_read_page_stat_item item)
>>
>>   This read-only set of statistics is set of a higher level conceptual
>>   counters.  For example, MEMCG_NR_DIRTYABLE_PAGES is the sum of the
>>   counts of pages in various states (active + inactive).  mem_cgroup
>>   exports this value as a higher level counter rather than individual
>>   counters (active & inactive) to minimize the number of calls into
>>   mem_cgroup_page_stat().  This avoids extra calls to cgroup tree
>>   iteration with for_each_mem_cgroup_tree().
>>
>> Notice that each of the two sets of statistics are addressed by a
>> different type, mem_cgroup_{read vs write}_page_stat_item.
>>
>> This particular patch (memcg: create extensible page stat update
>> routines) introduces part of this design.  A later patch I emailed
>> (memcg: add dirty limits to mem_cgroup) added
>> mem_cgroup_read_page_stat_item.
>>
>>
>> I think the code would read better if I renamed
>> enum mem_cgroup_write_page_stat_item to
>> enum mem_cgroup_update_page_stat_item.
>>
>> Would this address your concern
>
> Thanks for the kind explanation.
> I understand your concept.
>
> I think you makes update and query as completely different level
> abstraction but you could use similar terms.
> Even the terms(write VS read) make me more confusing.
>
> How about renaming following as?
>
> 1. mem_cgroup_write_page_stat_item -> mem_cgroup_page_stat_item
> 2. mem_cgroup_read_page_stat_item -> mem_cgroup_nr_pages_item
>
> At least it looks to be easy for me to understand the code.
> But it's just my preference. If others think your semantic is more
> desirable, I am not against it strongly.

I think your suggestion is good.  I will include it in the next revision
of the patch series.

> Thanks, Greg.
>
>>
>> --
>> Greg
>>
