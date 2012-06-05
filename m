Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390Ab2FECxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 22:53:47 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57057 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab2FECxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 22:53:45 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V7 07/14] mm/page_cgroup: Make page_cgroup point to the cgroup rather than the mem_cgroup
In-Reply-To: <4FCD648E.90709@jp.fujitsu.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FCD648E.90709@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 05 Jun 2012 08:23:28 +0530
Message-ID: <87ehpu8o5z.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12060502-9574-0000-0000-0000030BEE28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> (2012/05/30 23:38), Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
>> 
>> We will use it later to make page_cgroup track the hugetlb cgroup information.
>> 
>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>   include/linux/mmzone.h      |    2 +-
>>   include/linux/page_cgroup.h |    8 ++++----
>>   init/Kconfig                |    4 ++++
>>   mm/Makefile                 |    3 ++-
>>   mm/memcontrol.c             |   42 +++++++++++++++++++++++++-----------------
>>   5 files changed, 36 insertions(+), 23 deletions(-)
>> 
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 2427706..2483cc5 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -1052,7 +1052,7 @@ struct mem_section {
>> 
>>   	/* See declaration of similar field in struct zone */
>>   	unsigned long *pageblock_flags;
>> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
>> +#ifdef CONFIG_PAGE_CGROUP
>>   	/*
>>   	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
>>   	 * section. (see memcontrol.h/page_cgroup.h about this.)
>> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
>> index a88cdba..7bbfe37 100644
>> --- a/include/linux/page_cgroup.h
>> +++ b/include/linux/page_cgroup.h
>> @@ -12,7 +12,7 @@ enum {
>>   #ifndef __GENERATING_BOUNDS_H
>>   #include<generated/bounds.h>
>> 
>> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
>> +#ifdef CONFIG_PAGE_CGROUP
>>   #include<linux/bit_spinlock.h>
>> 
>>   /*
>> @@ -24,7 +24,7 @@ enum {
>>    */
>>   struct page_cgroup {
>>   	unsigned long flags;
>> -	struct mem_cgroup *mem_cgroup;
>> +	struct cgroup *cgroup;
>>   };
>> 
>
> This patch seems very bad.

I had to change that to 

struct page_cgroup {
	unsigned long flags;
	struct cgroup_subsys_state *css;
};

to get memcg to work. We end up changing css.cgroup on cgroupfs mount/umount.

>
>   - What is the performance impact to memcg ? Doesn't this add extra overheads 
>     to memcg lookup ?

Considering that we are stashing cgroup_subsys_state, it should be a
simple addition. I haven't measured the exact numbers. Do you have any
suggestion on the tests I can run ?

>   - Hugetlb reuquires much more smaller number of tracking information rather
>     than memcg requires. I guess you can record the information into page->private
>     if you want.

So If we end up tracking page cgroup in struct page all these extra over
head will go away. And in most case we would have both memcg and hugetlb
enabled by default.

>   - This may prevent us from the work 'reducing size of page_cgroup'
>

by reducing you mean moving struct page_cgroup info to struct page
itself ? If so this should not have any impact right ? Most of the
requirement of hugetlb should be similar to memcg. 

> So, strong Nack to this. I guess you can use page->private or some entries in
> struct page, you have many pages per accounting units. Please make an effort
> to avoid using page_cgroup.
>

HugeTLB already use page->private of compound page head to track subpool
pointer. So we won't be able to use page->private.

-aneesh

