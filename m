Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2FPGg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:36:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60600 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2FPGg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:36:27 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDC28F0.8050805@jp.fujitsu.com>
Date: Sat, 16 Jun 2012 15:34:24 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: Sha Zhengju <handai.szj@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, yinghan@google.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 2/2] memcg: add per cgroup dirty pages accounting
References: <1339761611-29033-1-git-send-email-handai.szj@taobao.com> <1339761717-29070-1-git-send-email-handai.szj@taobao.com> <xr93k3z8twtg.fsf@gthelen.mtv.corp.google.com>
In-Reply-To: <xr93k3z8twtg.fsf@gthelen.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/16 0:32), Greg Thelen wrote:
> On Fri, Jun 15 2012, Sha Zhengju wrote:
>
>> This patch adds memcg routines to count dirty pages. I notice that
>> the list has talked about per-cgroup dirty page limiting
>> (http://lwn.net/Articles/455341/) before, but it did not get merged.
>
> Good timing, I was just about to make another effort to get some of
> these patches upstream.  Like you, I was going to start with some basic
> counters.
>
> Your approach is similar to what I have in mind.  While it is good to
> use the existing PageDirty flag, rather than introducing a new
> page_cgroup flag, there are locking complications (see below) to handle
> races between moving pages between memcg and the pages being {un}marked
> dirty.
>
>> I've no idea how is this going now, but maybe we can add per cgroup
>> dirty pages accounting first. This allows the memory controller to
>> maintain an accurate view of the amount of its memory that is dirty
>> and can provide some infomation while group's direct reclaim is working.
>>
>> After commit 89c06bd5 (memcg: use new logic for page stat accounting),
>> we do not need per page_cgroup flag anymore and can directly use
>> struct page flag.
>>
>>
>> Signed-off-by: Sha Zhengju<handai.szj@taobao.com>
>> ---
>>   include/linux/memcontrol.h |    1 +
>>   mm/filemap.c               |    1 +
>>   mm/memcontrol.c            |   32 +++++++++++++++++++++++++-------
>>   mm/page-writeback.c        |    2 ++
>>   mm/truncate.c              |    1 +
>>   5 files changed, 30 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index a337c2e..8154ade 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -39,6 +39,7 @@ enum mem_cgroup_stat_index {
>>   	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
>>   	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>>   	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
>> +	MEM_CGROUP_STAT_FILE_DIRTY,  /* # of dirty pages in page cache */
>>   	MEM_CGROUP_STAT_NSTATS,
>>   };
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 79c4b2b..5b5c121 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -141,6 +141,7 @@ void __delete_from_page_cache(struct page *page)
>>   	 * having removed the page entirely.
>>   	 */
>>   	if (PageDirty(page)&&  mapping_cap_account_dirty(mapping)) {
>> +		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_DIRTY);
>
> You need to use mem_cgroup_{begin,end}_update_page_stat around critical
> sections that:
> 1) check PageDirty
> 2) update MEM_CGROUP_STAT_FILE_DIRTY counter
>
> This protects against the page from being moved between memcg while
> accounting.  Same comment applies to all of your new calls to
> mem_cgroup_{dec,inc}_page_stat.  For usage pattern, see
> page_add_file_rmap.
>

If you feel some difficulty with mem_cgroup_{begin,end}_update_page_stat(),
please let me know...I hope they should work enough....

Thanks,
-Kame



