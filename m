Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab2FMLRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:17:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45722 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2FMLRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:17:23 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD87646.8020206@jp.fujitsu.com>
Date: Wed, 13 Jun 2012 20:15:18 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 15/16] hugetlb/cgroup: migrate hugetlb cgroup info
 from oldpage to new page during migration
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FD70329.4080009@jp.fujitsu.com> <87aa08okvz.fsf@skywalker.in.ibm.com>
In-Reply-To: <87aa08okvz.fsf@skywalker.in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/12 20:00), Aneesh Kumar K.V wrote:
> Kamezawa Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>  writes:
> 
>> (2012/06/09 18:00), Aneesh Kumar K.V wrote:
>>> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
>>>
>>> With HugeTLB pages, hugetlb cgroup is uncharged in compound page destructor.  Since
>>> we are holding a hugepage reference, we can be sure that old page won't
>>> get uncharged till the last put_page().
>>>
>>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
>>
>> one comment.
>>
>>> ---
>>>    include/linux/hugetlb_cgroup.h |    8 ++++++++
>>>    mm/hugetlb_cgroup.c            |   21 +++++++++++++++++++++
>>>    mm/migrate.c                   |    5 +++++
>>>    3 files changed, 34 insertions(+)
>>>
>>> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
>>> index ba4836f..b64d067 100644
>>> --- a/include/linux/hugetlb_cgroup.h
>>> +++ b/include/linux/hugetlb_cgroup.h
>>> @@ -63,6 +63,8 @@ extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>>>    extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>>>    					   struct hugetlb_cgroup *h_cg);
>>>    extern int hugetlb_cgroup_file_init(int idx) __init;
>>> +extern void hugetlb_cgroup_migrate(struct page *oldhpage,
>>> +				   struct page *newhpage);
>>>    #else
>>>    static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
>>>    {
>>> @@ -112,5 +114,11 @@ static inline int __init hugetlb_cgroup_file_init(int idx)
>>>    {
>>>    	return 0;
>>>    }
>>> +
>>> +static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
>>> +					  struct page *newhpage)
>>> +{
>>> +	return;
>>> +}
>>>    #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
>>>    #endif
>>> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
>>> index c2b7b8e..2d384fe 100644
>>> --- a/mm/hugetlb_cgroup.c
>>> +++ b/mm/hugetlb_cgroup.c
>>> @@ -394,6 +394,27 @@ int __init hugetlb_cgroup_file_init(int idx)
>>>    	return 0;
>>>    }
>>>
>>> +void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
>>> +{
>>> +	struct hugetlb_cgroup *h_cg;
>>> +
>>> +	VM_BUG_ON(!PageHuge(oldhpage));
>>> +
>>> +	if (hugetlb_cgroup_disabled())
>>> +		return;
>>> +
>>> +	spin_lock(&hugetlb_lock);
>>> +	h_cg = hugetlb_cgroup_from_page(oldhpage);
>>> +	set_hugetlb_cgroup(oldhpage, NULL);
>>> +	cgroup_exclude_rmdir(&h_cg->css);
>>> +
>>> +	/* move the h_cg details to new cgroup */
>>> +	set_hugetlb_cgroup(newhpage, h_cg);
>>> +	spin_unlock(&hugetlb_lock);
>>> +	cgroup_release_and_wakeup_rmdir(&h_cg->css);
>>> +	return;
>>
>>
>> Why do you need  cgroup_exclude/release rmdir here ? you holds hugetlb_lock()
>> and charges will not be empty, here.
>>
> 
>   But even without empty charge, we can still remove the cgroup right ?
>   ie if we don't have any task but some charge in the cgroup because of
>   shared mmap in hugetlbfs.
> 

IIUC, cgroup_exclude_rmdir() is for putting rmdir() task under sleep state
and avoiding busy retries. Here, current thread is invoking rmdir() against
the cgroup.....

from kernel/cgroup.c

	set RMDIR bit.
	mutex_unlock(&cgroup_mutex);

	call  ->pre_destroy()  

	mutex_lock(&cgroup_mutex);
	
	if cgroup has some refcnt, sleep and wait for
	an event some thread calls cgroup_release_and_wakeup_rmdir().


So, the waiter should call ->pre_destroy() and get succeeded.
wating for a wakeup-event of cgroup_release_and_wakeup_rmdir() by some
other thread holding refcnt on the cgroup.

In memcg case, kswapd or some may hold reference count of memcg and wake
up event in (2) will be issued.

In this hugetlb case, it doesn't seem to happen.

Thanks,
-Kame






