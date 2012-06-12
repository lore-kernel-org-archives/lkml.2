Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2FLK6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:58:32 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51341 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2FLK6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:58:30 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 13/16] hugetlb/cgroup: add hugetlb cgroup control files
In-Reply-To: <4FD6FF47.8080200@jp.fujitsu.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FD6FF47.8080200@jp.fujitsu.com>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 12 Jun 2012 16:28:16 +0530
Message-ID: <87d354okzb.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061201-3568-0000-0000-000001F5541D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> (2012/06/09 17:59), Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
>> 
>> Add the control files for hugetlb controller
>> 
>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>   include/linux/hugetlb.h        |    5 ++
>>   include/linux/hugetlb_cgroup.h |    6 ++
>>   mm/hugetlb.c                   |    8 +++
>>   mm/hugetlb_cgroup.c            |  130 ++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 149 insertions(+)
>> 
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 4aca057..9650bb1 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -4,6 +4,7 @@
>>   #include<linux/mm_types.h>
>>   #include<linux/fs.h>
>>   #include<linux/hugetlb_inline.h>
>> +#include<linux/cgroup.h>
>> 
>>   struct ctl_table;
>>   struct user_struct;
>> @@ -221,6 +222,10 @@ struct hstate {
>>   	unsigned int nr_huge_pages_node[MAX_NUMNODES];
>>   	unsigned int free_huge_pages_node[MAX_NUMNODES];
>>   	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
>> +#ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
>> +	/* cgroup control files */
>> +	struct cftype cgroup_files[5];
>> +#endif
>>   	char name[HSTATE_NAME_LEN];
>>   };
>> 
>> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
>> index ceff1d5..ba4836f 100644
>> --- a/include/linux/hugetlb_cgroup.h
>> +++ b/include/linux/hugetlb_cgroup.h
>> @@ -62,6 +62,7 @@ extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>>   					 struct page *page);
>>   extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>>   					   struct hugetlb_cgroup *h_cg);
>> +extern int hugetlb_cgroup_file_init(int idx) __init;
>>   #else
>>   static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
>>   {
>> @@ -106,5 +107,10 @@ hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>>   {
>>   	return;
>>   }
>> +
>> +static inline int __init hugetlb_cgroup_file_init(int idx)
>> +{
>> +	return 0;
>> +}
>>   #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
>>   #endif
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 1ca2d8f..bf79131 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -30,6 +30,7 @@
>>   #include<linux/hugetlb.h>
>>   #include<linux/hugetlb_cgroup.h>
>>   #include<linux/node.h>
>> +#include<linux/hugetlb_cgroup.h>
>>   #include "internal.h"
>> 
>>   const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
>> @@ -1916,6 +1917,13 @@ void __init hugetlb_add_hstate(unsigned order)
>>   	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
>>   	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
>>   					huge_page_size(h)/1024);
>> +	/*
>> +	 * Add cgroup control files only if the huge page consists
>> +	 * of more than two normal pages. This is because we use
>> +	 * page[2].lru.next for storing cgoup details.
>> +	 */
>> +	if (order>= 2)
>> +		hugetlb_cgroup_file_init(hugetlb_max_hstate - 1);
>> 
>
> What happens at hugetlb module exit ? please see hugetlb_exit().
>
> BTW, module unload of hugetlbfs is restricted if hugetlb cgroup is mounted ??
>

hugetlb is a binary config

config HUGETLBFS
	bool "HugeTLB file system support"

config HUGETLB_PAGE
	def_bool HUGETLBFS

-aneesh

