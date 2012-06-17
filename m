Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab2FQGxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 02:53:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36930 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2FQGxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 02:53:23 -0400
MIME-Version: 1.0
In-Reply-To: <xr937gv8vc1y.fsf@gthelen.mtv.corp.google.com>
References: <1339761611-29033-1-git-send-email-handai.szj@taobao.com>
	<xr937gv8vc1y.fsf@gthelen.mtv.corp.google.com>
Date: Sun, 17 Jun 2012 14:53:22 +0800
Message-ID: <CAFj3OHUcat5TwAn2FQbJo02sGULmq6r=k3DOkhK6GBXPwOroPw@mail.gmail.com>
Subject: Re: [PATCH 1/2] memcg: remove MEMCG_NR_FILE_MAPPED
From: Sha Zhengju <handai.szj@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, yinghan@google.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:18 PM, Greg Thelen <gthelen@google.com> wrote:
> On Fri, Jun 15 2012, Sha Zhengju wrote:
>
>> While doing memcg page stat accounting, there's no need to use MEMCG_NR_FILE_MAPPED
>> as an intermediate, we can use MEM_CGROUP_STAT_FILE_MAPPED directly.
>>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
>> ---
>>  include/linux/memcontrol.h |   22 ++++++++++++++++------
>>  mm/memcontrol.c            |   25 +------------------------
>>  mm/rmap.c                  |    4 ++--
>>  3 files changed, 19 insertions(+), 32 deletions(-)
>
> I assume this patch is relative to v3.4.
>


Yeah, I cook it based on linux-stable v3.4.


>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index f94efd2..a337c2e 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -27,9 +27,19 @@ struct page_cgroup;
>>  struct page;
>>  struct mm_struct;
>>
>> -/* Stats that can be updated by kernel. */
>> -enum mem_cgroup_page_stat_item {
>> -     MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
>> +/*
>> + * Statistics for memory cgroup.
>> + */
>> +enum mem_cgroup_stat_index {
>> +     /*
>> +      * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
>> +      */
>> +     MEM_CGROUP_STAT_CACHE,     /* # of pages charged as cache */
>> +     MEM_CGROUP_STAT_RSS,       /* # of pages charged as anon rss */
>> +     MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
>> +     MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>> +     MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
>> +     MEM_CGROUP_STAT_NSTATS,
>>  };
>
> This has unfortunate side effect of letting code outside of memcontrol.c
> manipulate memcg internally managed statistics
> (e.g. MEM_CGROUP_STAT_CACHE) with mem_cgroup_{dec,inc}_page_stat.  I
> think that your change is fine.  The complexity and presumed performance
> overhead of the extra layer of indirection was not worth it.
>
>>  struct mem_cgroup_reclaim_cookie {
>> @@ -170,17 +180,17 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>>  }
>>
>>  void mem_cgroup_update_page_stat(struct page *page,
>> -                              enum mem_cgroup_page_stat_item idx,
>> +                              enum mem_cgroup_stat_index idx,
>>                                int val);
>>
>>  static inline void mem_cgroup_inc_page_stat(struct page *page,
>> -                                         enum mem_cgroup_page_stat_item idx)
>> +                                         enum mem_cgroup_stat_index idx)
>>  {
>>       mem_cgroup_update_page_stat(page, idx, 1);
>>  }
>>
>>  static inline void mem_cgroup_dec_page_stat(struct page *page,
>> -                                         enum mem_cgroup_page_stat_item idx)
>> +                                         enum mem_cgroup_stat_index idx)
>>  {
>>       mem_cgroup_update_page_stat(page, idx, -1);
>>  }
>
> You missed two more uses of enum mem_cgroup_page_stat_item in
> memcontrol.h.
>

Ah, I find them, thanks for reviewing!


Thanks,
Sha
